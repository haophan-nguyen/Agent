# TD01-P3-H6: native GDB T09 retest and final existing image-load allowance

Nonterminal execute checkpoint. [T07 is PASS](t07-summary.json); T04-T06 are BLOCKED for unavailable oscilloscope/logic analyzer. T09 remains BLOCKED; no R5 target snapshots exist yet.

## Preserved H5 failure and state

[H5 result](t09-session-result.json) and [raw GDB error](t09-gdb-stderr.log) show that installed GDB 15.2.90.20241130-git lacks Python scripting. The helper assumed that capability. Its Python block was rejected **before any helper target connection, load, reset or register capture**. No firmware violation is demonstrated. Classification: [P3-F07 / ENVIRONMENT_TOOL](t09-failure-P3-F07.json), with TEST_INFRASTRUCTURE contributor.

H5's one client allowance is exhausted. Its result's `loadInterventionIssued=true` means the load-containing script was dispatched, not that flash programming occurred. Actual H5 loads: **0**. Per the explicitly approved conservative dispatch rule, P3-F05 remains **2/3 consumed**, not refunded. P3-F02 remains **2/3**. P3-F07 has consumed **0/3** pending a retest.

The [native host state query](h5-owned-server-host-state.json) verified owned H5 LinkServer PID **22292** waiting at **127.0.0.1:3337**. A preceding sandbox query denied listener access and hid process objects; its empty results were not used to claim server absence. This passive permission-boundary follow-up consumed no recovery intervention. Last normal target observation remains T07 reset 3; live target state after the host failure has not been inspected. Do not terminate unrelated host processes.

## H6 decision and exact scope

**APPROVE, DENY, or DEFER** one bounded retest with the prepared [native MI runner](run-approved-t09-native.ps1). It uses native GDB commands, with **no Python support, installation, SDK/toolchain change or rebuild**. The runner's MI string/memory parsing, split-block coverage and rejection of incomplete memory coverage were checked using host-only samples; neither GDB nor hardware was launched for those checks.

Working directory: `D:\work_space\Agent\Agent`.

Target: the same engineer physical FRDM-MCXN236 / probe **SPOBEAQ0BCREX**. Reuse **only the identified owned H5 server PID22292 / 127.0.0.1:3337**, after host-only verification of its executable, command line, probe/device selection and listener. This reuse is new H6 scope; do not attach to another server or start a replacement automatically if the prerequisite changes.

Launch exactly one client:

```powershell
& 'C:\Users\LENOVO\.mcuxpressotools\arm-gnu-toolchain-14.2.rel1-mingw-w64-x86_64-arm-none-eabi\bin\arm-none-eabi-gdb.exe' --nx --nh --interpreter=mi3
```

The runner sends native GDB/MI commands over that client's stdin; exact commands and capture logic are reviewable in the runner. The same exact Debug ELF is selected with `-file-exec-and-symbols`, with no IDE/build action:

`D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf`, **199936 bytes**, SHA-256 **2859DB1162705BF6567EDB235DE6A05AC08153268E00B64B7248AC382E36E391**; debug `-g -O0`, Cortex-M33 / MCXN236VDF. Current source identity and R3 risk disposition are unchanged.

### Permitted target operations, once only

1. Connect to the owned server, set `monitor ondisconnect stop` and the owned session's `monitor kill_server` behavior. Set both `monitor flash_load_option no_mass_at_0` and `no_mass_not_0`. No mass erase is permitted.
2. Issue **one additional same-image `load`** because the documented LinkServer GDB workflow requires it. Read all three regions via `-data-read-memory-bytes` and compare every returned byte against the exact ELF before any application continue: `0x0`/688 bytes, `0x400`/8040 bytes, `0x2368`/4 bytes. Retain full raw MI memory replies and expected/actual hashes. Stop on mismatch or incomplete coverage.
3. Insert a hardware breakpoint at **0x1e7a**, issue **one explicit planned `monitor reset`**, continue to the breakpoint, and require the actual PC to match. Record actual SysTick priority byte **0xE000ED23**, CTRL **0xE000E010**, LOAD **0xE000E014**, SystemCoreClock **0x20000000**, and PRIMASK/BASEPRI/FAULTMASK from documented `monitor register_display core` output.
4. Remove that owned breakpoint, insert a hardware breakpoint at **0x1ea4**, continue, require that actual PC, and record the same fields. Evaluate unchanged T09 criteria: priority, CTRL configuration and masks preserved; processor clock/timer/interrupt bits enabled; final LOAD=5999999. Do not substitute assumed values or count missing evidence as PASS.
5. Remove the owned breakpoint, disconnect with stop policy, and exit the owned GDB client. The owned server is configured to close upon disconnect. On normal completion the last observed core is **halted after the timing update**. No restoration reset or resume is authorized. Safe error cleanup is limited to removing owned breakpoints and stop/disconnect when no command/continue is in progress; unknown/in-progress/timeout paths issue no further commands.

### Bounds, effects and exclusions

- One client only; no server relaunch, automatic retry or fallback connection. Remote/ordinary command and continue-to-stop observation deadlines **10 s**, load observation deadline **30 s**, whole-client observation deadline **120 s**. No forced interruption/kill/reset on timeout; preserve active PID/logs and request disposition.
- Connection/driver resets, SWD/mailbox activity, RAM support execution, affected-sector erase/program/data loss, the explicit test reset, two controlled continues/halts, hardware breakpoint changes, and actual memory/register reads are disruptive. CTRL reads clear COUNTFLAG. Final halted state intentionally stops normal blinking. No quantitative timing evidence is derived.
- **Counters:** on dispatch, charge this as P3-F05's **final existing attempt 3/3** and P3-F07 native-helper recovery/retest **1/3**. Associated image validation and T09 captures may complete that final allowed attempt if safe and authorized. No new image-recovery intervention may start afterward without an explicitly increased finite budget and separate scope. P3-F02 remains 2/3; no conversation restart renews any budget.
- Approval also confirms unchanged safe physical board/probe setup and permission to replace affected flash-sector contents again, with all newly needed flash/volatile evidence already retained. Otherwise DEFER and specify what is missing. R3's accepted historical uncertainty remains separate from hardware authority. Native execution permission is still required.
- Excludes mass erase/unlock, probe updates, boot changes, arbitrary register/memory patching, software breakpoints, extra load/reset/continue/recovery, power/wiring/instrument actions, application/image/build/design edits, rebuild, commit/push, Phase 4 and final acceptance. Only the prepared evidence-capture helper replaces the unsupported helper; no application source changes.

## Resume and reporting

[t09-native-plan.json](t09-native-plan.json) records exact client arguments, input hashes and readback regions. Preserve H5 helper/plan/raw output as historical evidence; do not overwrite them. The waiting server's raw logs may append if this new scope is approved; retain the H5-boundary snapshots before reuse.

Exact next action: record the H6 response; if approved, check owned server and frozen inputs through the separate native mechanism and run this one prepared session. On DENY, do not repeatedly request the denied scope; assess independent paths and report. On DEFER, retain the checkpoint. Do not issue a terminal report merely for an unanswered/deferred request.

After the authorized path reaches a valid stopping condition, write `docs/reports/phase3-TD-01-v1.1.md`, retaining T07 and every T09 attempt/failure, all counters, actual approvals, raw captures and quantitative timing blockers. Phase 4 and final acceptance remain pending. Skill/ledger controls alone do not provide external hardware interlocks or guaranteed counter enforcement.
