"""Proposed H5-only capture helper, executed inside GDB after explicit approval."""
import datetime
import hashlib
import json
import pathlib
import re

import gdb

ROOT = pathlib.Path(r'D:\work_space\Agent\Agent\docs\reports\evidence\TD-01\phase3-v1.1\resume-02')
IMAGE = pathlib.Path(r'D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf')
EXPECTED_HASH = '2859DB1162705BF6567EDB235DE6A05AC08153268E00B64B7248AC382E36E391'
OUTPUT = ROOT / 't09-capture.json'
STOP = ROOT / 't09-stop-requested.json'
STATE = {'testId': 'T09', 'executionId': 'TD01-P3-T09-A01', 'events': [],
         'imageSha256': EXPECTED_HASH, 'status': 'BLOCKED', 'connected': False,
         'loadedImageVerified': False, 'snapshots': {}, 'cleanup': []}


def now():
    return datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=7))).isoformat()


def save():
    OUTPUT.write_text(json.dumps(STATE, indent=2) + '\n', encoding='utf-8')


def command(text):
    if STOP.exists():
        raise gdb.GdbError('Observation deadline/STOP marker present; no further target command')
    STATE['events'].append({'recordedAt': now(), 'command': text, 'state': 'ISSUING'})
    save()
    result = gdb.execute(text, to_string=True)
    STATE['events'][-1].update(state='COMPLETED', output=result)
    print(result, end='' if result.endswith('\n') else '\n')
    save()
    return result


def memory(address, count):
    if STOP.exists():
        raise gdb.GdbError('Observation deadline/STOP marker present; no further target read')
    return bytes(gdb.selected_inferior().read_memory(address, count))


def word(address):
    return int.from_bytes(memory(address, 4), 'little')


def capture(label, expected_pc):
    if STOP.exists():
        raise gdb.GdbError('Observation deadline/STOP marker present; no further capture')
    pc = int(gdb.parse_and_eval('$pc'))
    if pc != expected_pc:
        raise gdb.GdbError(f'{label}: unexpected PC 0x{pc:08X}; expected 0x{expected_pc:08X}')
    core = command('monitor register_display core')
    masks = {}
    for name in ('PriMask', 'BasePri', 'FaultMask'):
        found = re.findall(r'(?im)(?:^|[}\s])' + name + r'\s*=\s*(0x[0-9a-f]+)', core)
        if len(found) != 1:
            raise gdb.GdbError(f'{label}: missing/ambiguous actual {name}; stop without invented values')
        masks[name] = int(found[0], 16)
    snapshot = {'recordedAt': now(), 'pc': pc, 'priorityRawByte': memory(0xE000ED23, 1)[0],
                'ctrlRaw': word(0xE000E010), 'load': word(0xE000E014),
                'systemCoreClock': word(0x20000000), 'interruptMasks': masks,
                'coreRegisterOutput': core,
                'method': 'Halted debug read; CTRL read clears COUNTFLAG; no timing inference'}
    snapshot['ctrlConfiguration'] = snapshot['ctrlRaw'] & 7
    STATE['snapshots'][label] = snapshot
    save()
    print('TD09_' + label.upper() + ' ' + json.dumps(snapshot, sort_keys=True))
    return snapshot


if OUTPUT.exists():
    raise gdb.GdbError('Capture already exists; no automatic retry/overwrite')
if hashlib.sha256(IMAGE.read_bytes()).hexdigest().upper() != EXPECTED_HASH:
    raise gdb.GdbError('Exact approved image identity changed')
save()
connected = False
try:
    command('target remote 127.0.0.1:3337')
    connected = True
    STATE['connected'] = True
    command('monitor ondisconnect stop')
    command('monitor kill_server')
    command('monitor flash_load_option no_mass_at_0')
    command('monitor flash_load_option no_mass_not_0')
    command('load')
    image_bytes = IMAGE.read_bytes()
    verified = []
    for address, offset, size in ((0, 4096, 688), (0x400, 5120, 8040), (0x2368, 16384, 4)):
        actual = memory(address, size)
        expected = image_bytes[offset:offset + size]
        match = actual == expected
        verified.append({'address': address, 'fileOffset': offset, 'bytes': size,
                         'matches': match, 'actualSha256': hashlib.sha256(actual).hexdigest(),
                         'expectedSha256': hashlib.sha256(expected).hexdigest()})
        STATE['imageReadback'] = verified
        save()
        if not match:
            raise gdb.GdbError(f'Loaded image readback mismatch at region 0x{address:08X}; do not run')
    STATE['loadedImageVerified'] = True
    save()
    before_break = gdb.Breakpoint('*0x00001e7a', type=gdb.BP_HARDWARE_BREAKPOINT)
    STATE['events'].append({'recordedAt': now(), 'operation': 'Create hardware breakpoint', 'pc': 0x1E7A})
    save()
    command('monitor reset')
    command('continue')
    before = capture('before', 0x1E7A)
    before_break.delete()
    after_break = gdb.Breakpoint('*0x00001ea4', type=gdb.BP_HARDWARE_BREAKPOINT)
    STATE['events'].append({'recordedAt': now(), 'operation': 'Replace hardware breakpoint', 'pc': 0x1EA4})
    save()
    command('continue')
    after = capture('after', 0x1EA4)
    after_break.delete()
    checks = {'priorityPreserved': before['priorityRawByte'] == after['priorityRawByte'],
              'ctrlPreserved': before['ctrlConfiguration'] == after['ctrlConfiguration'],
              'processorClockTimerAndInterruptEnabled': before['ctrlConfiguration'] == after['ctrlConfiguration'] == 7,
              'interruptMasksPreserved': before['interruptMasks'] == after['interruptMasks'],
              'finalLoad5999999': after['load'] == 5999999}
    STATE['checks'] = checks
    STATE['status'] = 'PASS' if all(checks.values()) else 'FAIL'
    STATE['completedAt'] = now()
    save()
except Exception as error:
    STATE['error'] = str(error)
    STATE['stoppedAt'] = now()
    save()
    print('TD09_CAPTURE_ERROR ' + str(error))
finally:
    if connected and STOP.exists():
        STATE['cleanup'].append('Deadline/STOP marker present; no explicit cleanup or restoration command issued')
    elif connected:
        try:
            thread = gdb.selected_thread()
            if thread is not None and thread.is_stopped():
                command('delete breakpoints')
                command('disconnect')
                STATE['cleanup'].append('Owned breakpoints removed; disconnected with ondisconnect stop; no restore/reset/run')
            else:
                STATE['cleanup'].append('Thread state unknown/running; no further target command issued')
        except Exception as error:
            STATE['cleanup'].append('Cleanup uncertain: ' + str(error))
    STATE['finalState'] = 'Expected halted after update if normal cleanup completed; otherwise unknown. Not a normal-timing run.'
    save()
print('TD09_RESULT ' + STATE['status'])
