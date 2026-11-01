# TD01-P3-B7 / H7: finite extension and corrected T09 capture

Nonterminal execute checkpoint. T07 is PASS; T04-T06 remain BLOCKED because the engineer has no oscilloscope or logic analyzer. T09 remains BLOCKED. Counts: PASS 1 / FAIL 0 / BLOCKED 4 / NOT RUN 0.

## Evidence and correction

[H6 review](t09-native-review.json) and [P3-F08](t09-failure-P3-F08.json) preserve the actual failure. All three image regions matched, the first hardware breakpoint reached **0x1e7a**, and actual core/mask output was obtained. The helper then issued `-data-read-memory-bytes 0xFFFFFFFFE000ED23 1`, which GDB rejected. This was an unintended address-formatting deviation from the approved 32-bit address, not a demonstrated firmware defect or unsupported byte access. No write/patch at that wrong address occurred. Owned breakpoints were removed and stop/disconnect completed; last captured core PC was before the timer update. No restoration reset/run followed.

Confirmed cause: PowerShell sign-extended a high-bit signed hex literal when converting it to an Int64 address parameter. The separately prepared [corrected helper](run-approved-t09-fixed.ps1) uses explicit positive-width literals and rejects any address outside unsigned32 range before issuing a target read. Host-only regression checks confirm `0xE000ED23L` formats exactly as `0xE000ED23`, all three high register addresses have eight hex digits, and the old sign-extended input is rejected. MI parsing/coverage checks still pass. No GDB or hardware was launched for these checks. H5/H6 helpers and raw evidence remain unchanged.

P3-F05 is **3/3 consumed, 0 remaining** under the approved conservative dispatch accounting. Only **two actual programming operations** occurred in this resume so far: L01 and H6; H5's load-containing dispatch was charged but Python failed before any actual load. P3-F07 native capability recovery is 1/3; P3-F08 correction has consumed 0/3; P3-F02 remains 2/3. No budget renews implicitly.

## B7: separately answerable finite budget decision

**APPROVE, DENY, or DEFER** increasing **only P3-F05's cumulative limit from 3 to 4**, allowing **one additional attempt**, with its associated validating readback and T09 capture. Retain all three consumed counts and failed attempts; this is not a reset or blanket increase. The extension alone grants no hardware authority and changes no TD criterion. No fifth intervention may start without another explicit finite decision.

The new evidence supporting this bounded extension is the confirmed host formatting defect and passing host-only address regression. No firmware repair/rebuild is proposed.

## H7: separately answerable operation decision

**APPROVE, DENY, or DEFER** one session using the corrected helper, conditional on B7 approval, exact identity/setup checks, and concrete native permission.

Working directory: `D:\work_space\Agent\Agent`. Same physical FRDM-MCXN236 / probe **SPOBEAQ0BCREX**. Same Debug ELF:

`D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf`, **199936 bytes**, debug `-g -O0`, Cortex-M33 / MCXN236VDF, SHA-256 **2859DB1162705BF6567EDB235DE6A05AC08153268E00B64B7248AC382E36E391**.

Start one **new owned** server on unused private port **3339**, since the prior server reports it closed after H6 disconnect. Do not reuse another server or kill unrelated processes:

```powershell
& 'C:\NXP\LinkServer_26.9.130\LinkServer.exe' gdbserver --probe SPOBEAQ0BCREX --update-mode none --no-boot --gdb-port 3339 --semihost-port -1 --no-rtos MCXN236:FRDM-MCXN236
```

After that instance is ready, launch one client:

```powershell
& 'C:\Users\LENOVO\.mcuxpressotools\arm-gnu-toolchain-14.2.rel1-mingw-w64-x86_64-arm-none-eabi\bin\arm-none-eabi-gdb.exe' --nx --nh --interpreter=mi3
```

The corrected native MI helper performs the same reviewed [H6 capture sequence](t09-native-checkpoint.md), through `127.0.0.1:3339`, with exact unsigned32 register addresses:

1. Select exact ELF; connect to the owned server; set disconnect-stop/owned-server-close policy; disable mass erase for loads at and away from zero.
2. **One same-image load** and complete three-region byte-for-byte readback at 0x0/688 bytes, 0x400/8040 bytes, 0x2368/4 bytes. Stop on mismatch or missing bytes before application execution.
3. Hardware breakpoint **0x1e7a**, **one explicit planned monitor reset**, and continue to actual PC0x1e7a. Capture current priority byte at **0xE000ED23**, CTRL at **0xE000E010**, LOAD at **0xE000E014**, SystemCoreClock at **0x20000000**, and actual core interrupt masks.
4. Remove first breakpoint; set hardware breakpoint **0x1ea4** and continue to it; repeat actual captures. Evaluate unchanged T09 priority/configuration/mask preservation, enabled processor clock/timer/interrupt bits and final LOAD=5999999. No assumed values or quantitative timing claims.
5. Remove owned breakpoints, stop/disconnect and exit the owned client/server. **Normal final core state is halted after the update.** No restoration reset/run.

The corrected helper adds address-domain guarding; it does not patch the target/application or change the approved requirements. Its full commands and frozen inputs are in [t09-fixed-plan.json](t09-fixed-plan.json).

## Effects, finite limits and prerequisites

- Same affected-sector erase/program/data-loss, connection/driver reset/halt/SWD/mailbox/RAM-support effects as previous approved loads. One explicit test reset, two controlled continues/halts, hardware breakpoint changes, actual reads including COUNTFLAG clear, and final halted state. Partial programming, connection loss or unknown state is possible on error.
- One new server, readiness deadline **15 s**; one client, whole observation deadline **120 s**; ordinary command/continue deadline **10 s**; load deadline **30 s**. No automatic retry, fallback server, forced interruption, kill or reset on timeout. Retain PID/logs and request disposition on uncertainty. Safe cleanup only as in the corrected helper when no command/continue is in progress.
- On the approved load-containing dispatch, P3-F05 becomes **4/4**, and P3-F08 correction/retest becomes **1/3**. P3-F07 stays 1/3 and P3-F02 stays 2/3. No further intervention is authorized by remaining unrelated counters.
- Approval also confirms unchanged safe physical board/probe setup, permission to replace all affected-sector contents again, and preservation of newly needed flash/volatile evidence; otherwise DEFER with missing facts. R3's accepted historical-risk scope remains separate. Native permission is another required layer.
- Excludes mass erase/unlock, probe/boot changes, arbitrary patches, software breakpoints, extra flash/reset/continue/recovery, power/wiring/instrument changes, application/image/build/design edits, rebuilds, commit/push, Phase 4 and final acceptance. H7 authorizes use of the prepared corrected evidence helper only.

## Resume and report condition

Record B7 and H7 separately. On both APPROVE, record the new cumulative finite limit without discarding counts, verify frozen inputs/private port/setup, obtain native permission and run this session once. A denied required scope is not repeatedly requested. On DEFER preserve the checkpoint. Do not issue a terminal report solely for pending/deferred decisions.

When the authorized path completes, denial leaves no authorized independent continuation, or another genuine unresolved hard blocker stops the run, write `docs/reports/phase3-TD-01-v1.1.md` with all nine sections, every failure/attempt and actual measured/observed evidence. Final review/acceptance and Phase 4 remain pending. Strong enforcement requires external runner/access controls/interlocks; skill and ledger records alone do not guarantee it.
