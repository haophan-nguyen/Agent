# TD01-P3-H5: bounded T09 debugger and register-capture checkpoint

This is a **nonterminal execute checkpoint** following [T07 PASS](t07-summary.json). T07 used three planned H4 resets with attributable engineer observations; H4 is exhausted. T04-T06 remain BLOCKED because no oscilloscope or logic analyzer is available. No quantitative timing PASS is claimed. Current counts: PASS 1 / FAIL 0 / BLOCKED 4 / NOT RUN 0.

## Requested decision

**APPROVE, DENY, or DEFER** one session using the prepared [runner](run-approved-t09.ps1), [GDB command file](t09-capture.gdb), and [capture helper](t09-capture.py), solely for TD-01 v1.1 **T09 / R5**, on the same safe physical FRDM-MCXN236 via **SPOBEAQ0BCREX**.

Working directory: `D:\work_space\Agent\Agent`.

Exact image: `D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf`; **199936 bytes**; debug `-g -O0`, Cortex-M33 / MCXN236VDF; SHA-256 **2859DB1162705BF6567EDB235DE6A05AC08153268E00B64B7248AC382E36E391**. No new firmware is built or edited. Current source is HEAD `b630da3bd67d84150d1cc574c2959be5e8e73039` plus the retained 14-line application change, raw SHA-256 `46AD8D67DE632F9FDFFB8D8366AA9E832FAC03D81BAAC0A44C8A4D1976E588AF`.

Approval also confirms that the same physical target/probe and safe setup remain applicable, that another load of this exact image may replace affected-sector contents, and that any newly needed flash/volatile evidence is already preserved. Otherwise DEFER and identify the missing prerequisite. R3's approved historical-risk disposition covers separately authorized T09; it supplies no hardware authority itself. R1/H1 are not reused, and R2/H2 remain cancelled.

## Exact host operations and target sequence

Launch only this server instance, with a new private unused port; do not connect to an existing server:

```powershell
& 'C:\NXP\LinkServer_26.9.130\LinkServer.exe' gdbserver --probe SPOBEAQ0BCREX --update-mode none --no-boot --gdb-port 3337 --semihost-port -1 --no-rtos MCXN236:FRDM-MCXN236
```

After that instance reports ready, launch one client:

```powershell
& 'C:\Users\LENOVO\.mcuxpressotools\arm-gnu-toolchain-14.2.rel1-mingw-w64-x86_64-arm-none-eabi\bin\arm-none-eabi-gdb.exe' --nx --nh --batch -x 'D:\work_space\Agent\Agent\docs\reports\evidence\TD-01\phase3-v1.1\resume-02\t09-capture.gdb' 'D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf'
```

The helper performs only these bounded operations, retaining full host/server output plus structured events/captures:

1. Connect `target remote 127.0.0.1:3337`. Set session disconnect policy to **stop** and arrange for this owned GDB server to close when its client disconnects.
2. Set `monitor flash_load_option no_mass_at_0` and `monitor flash_load_option no_mass_not_0`; no mass erase is authorized. Issue **one GDB `load`** of the exact image. This additional load is required by the installed LinkServer Readme's documented GDB workflow, including attach mode. It is not hidden under exhausted H3, nor an unnecessary repeat of V02's standalone verification.
3. Before any application continue, read and compare **all three image regions byte-for-byte** against the exact ELF: flash `0x00000000`/688 bytes from file offset 4096, `0x00000400`/8040 bytes from offset 5120, and `0x00002368`/4 bytes from offset 16384. Hashes/results are retained. A mismatch blocks functional continuation; no automatic programming retry occurs.
4. Set a hardware breakpoint at **0x00001e7a**, immediately after BOARD_InitHardware. Issue **one explicit `monitor reset`** and continue to that point. Require the actual PC to match. Read actual SysTick priority byte at **0xE000ED23**, CTRL at **0xE000E010**, LOAD at **0xE000E014**, SystemCoreClock at **0x20000000**, and actual PRIMASK/BASEPRI/FAULTMASK through documented `monitor register_display core` output. Missing/ambiguous masks stop the capture rather than supplying assumed values.
5. Remove that owned breakpoint, set a hardware breakpoint at **0x00001ea4**, continue to the instruction after the timing update, require the actual PC to match, and repeat the same capture. Compare actual priority, CTRL configuration bits and masks, and require final LOAD=5999999 with processor-clock/timer/interrupt bits enabled. Values and check outcomes are retained whether PASS, FAIL or BLOCKED.
6. Remove owned breakpoints and disconnect with **ondisconnect stop**. On normal completion, the last observed core state is halted at the after-update position. No final reset, resume or restoration is included. Stop the owned session through its documented disconnect behavior; do not terminate unrelated/shared processes. Error/unknown running-state paths issue no speculative recovery.

No function calls into target code or software breakpoints are used. Reading CTRL clears transient COUNTFLAG. Core-register display may include fault/status registers; these are debug observations, not timing measurements. GDB load may initialize debug execution state, and the connection/flash-driver path may reset/halt the target and execute RAM support code. The single monitor reset is a separately identified planned T09 setup step, not an unrecorded recovery action.

## Effects, accounting and finite limits

- **Effects:** affected-sector erase/program and data loss; 50 ms preconnect wire reset/SWD/debug-mailbox interaction as configured; driver SOFTRESETs/RAM execution; the explicit T09 reset; core halts and two controlled continues; hardware debug-breakpoint changes; actual memory/register reads including COUNTFLAG clear; disconnect leaving the core halted. Normal LED execution may stop. Partial programming, unexpected target state, tool failure or lost connection remains possible.
- **Accounting:** P3-F05 is currently **1/3 consumed, 2 remaining** from L01/V02. Conservatively charge this additional load-containing client dispatch as a **separate attempt 2/3**, including failed/uncertain dispatch, with its three-region readback as associated validation. One attempt would remain, but it grants no automatic retry. Planned T09 reset/breakpoint steps are explicitly logged test setup, not additional recovery permission. P3-F02 remains **2/3 consumed, 1 remaining**; its host history is not reset.
- **Bounds:** one server launch, 15 s server-readiness deadline; one GDB client, **120 s observation deadline**, remote response/connect timeouts 10 s. At deadline, retain PID/logs and set a host stop marker that prevents further explicit helper operations at the next safe boundary. Do not forcibly interrupt a state-changing command, kill a process or reset the target. An in-progress continue may remain active; request engineer disposition if completion/state is uncertain.
- **No automatic retry:** one same-image load, one validating readback, one planned monitor reset, two hardware-breakpoint capture points, cleanup/disconnect only as described. Stop earlier on mismatch, unexpected PC, missing mandatory capture or unsafe/uncertain state. Preserve failed/partial data.
- **Excludes:** mass erase, unlock/resurrection, probe updates, boot-setting changes, arbitrary target memory/register patching, software breakpoints, extra flash/reset/continue/recovery, wiring/power changes, instruments, source/image/build/design edits, rebuilding, committing/pushing, Phase 4 or final acceptance.

## Resume and evidence

[t09-plan.json](t09-plan.json) freezes command/input identities, including the helpers, installed tool and hook identities. Entry into this run is already explicitly authorized, and R3 is approved; the missing layer is **H5 operation authority**, followed by concrete native permission. No GDB server/client has been launched while preparing this checkpoint.

Exact resume action: record H5 decision. On APPROVE, check the frozen input identities, current physical/preservation facts and private-port availability, request the concrete native permission, then run the bounded session once. On DENY/DEFER, retain state and do not substitute an unapproved attach or load. Any tool failure, timeout, mismatch or criterion violation is recorded/classified under the skill and prior counters; no application/build repair occurs here.

After an authorized T09 path finishes, denial leaves no independent authorized test, or a genuine hard blocker prevents continuation, generate final report `docs/reports/phase3-TD-01-v1.1.md` with the nine required sections. Do not issue a terminal report solely while H5 is awaiting/deferred. Phase 4 and final engineer acceptance remain outside this task. Strong retry/operation enforcement needs an external runner/access controls or interlocks; saved counters and skill instructions alone do not guarantee it.
