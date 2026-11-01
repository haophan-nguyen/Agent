# TD01-P3-H4: T07 reset and observation checkpoint

Nonterminal `execute` continuation of [checkpoint 02](checkpoint.md). H3 completed: [L01 load review](load-review.json) and [V02 verification review](verify-after-load-review.json) establish the exact designated Debug image contents on NXP MCXN236 via SPOBEAQ0BCREX. All three flash regions matched; no normal-running observation has yet been received. Last known target state remains unknown after reset/halt and flash-driver SOFTRESETs. No command remains in progress.

R3 was explicitly approved for retained A01/A02/P3-F03 uncertainties in H3 and subsequent separately authorized T07/T09. H3 is exhausted. R1/H1 remain historical with no future authority; R2/H2 remain cancelled. No approval is inferred from those records.

## Exact H4 request

**APPROVE, DENY, or DEFER** up to **three planned, separately logged T07 wire-reset invocations**, one at a time. Each uses this exact command from working directory `D:\work_space\Agent\Agent`:

```powershell
& 'C:\NXP\LinkServer_26.9.130\LinkServer.exe' reset --probe SPOBEAQ0BCREX --update-mode none --no-boot --type wire --ms 50 MCXN236:FRDM-MCXN236
```

Target: the engineer's same personal physical FRDM-MCXN236 and probe SPOBEAQ0BCREX. No image programming is requested. The selected/verified image remains:

`D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf`

199936 bytes; debug `-g -O0`, Cortex-M33 / MCXN236VDF; SHA-256 `2859DB1162705BF6567EDB235DE6A05AC08153268E00B64B7248AC382E36E391`.

Approval also confirms that the same safe power/connections/board-probe association remain applicable and that the engineer is present and ready to observe the red LED. Otherwise DEFER and state the missing condition. The observed image association must remain unchanged; any critical change stops the sequence.

## Procedure, effects and bounds

1. Retain the fresh approval and obtain the concrete native permission before the first reset. No reset is issued while authority is pending.
2. Announce each reset. Issue one invocation and retain its exact operation, stdout/stderr and result. Each command has a 30 s observation deadline. On error, unexpected state, timeout or uncertain completion, issue no subsequent command or automatic recovery; preserve evidence and seek engineer disposition. No forced interruption is authorized.
3. The engineer watches from reset release through at least **5 s** of subsequent activity. Record initial LED ON/OFF/uncertain, subsequent complete blink pattern, observed stalls or faults, and any observation limitation. The startup-to-first-transition interval has no exact 500 ms requirement. Do not invent the observation timestamp or infer millisecond timing from visual blinking.
4. Wait for the actual attributable observation before the next planned reset. No response means no next reset. Capture and classify any demonstrated violation; do not rerun to erase it. An incomplete observation cannot support PASS. If observations are inconsistent or inadequate, stop the remaining sequence for diagnosis/decision.
5. A T07 PASS requires sufficient observations from all three planned resets under the unchanged criterion: initial ON and consistent required subsequent blink pattern without observed stalls/faults. Planned test resets are repetitions, not recovery retries. Any reset/retry beyond these three requires a separate recovery decision and persisted issue counter.

A wire reset disrupts execution, clears volatile state and may destroy unretained fault evidence; the target may start running or remain in an unexpected/halted state. H4 authorizes this reset/test transition only. It does not assert that reset will restore normal operation. The engineer previously confirmed preservation for H3; preserve any newly supplied fault evidence before reset.

Excludes flashing/erase, GDB attachment, memory/register writes, changes to boot settings or probe firmware, power cycling/rewiring, extra reset/recovery invocations, instruments, source/image/build/design edits, rebuilding, commits/pushes and Phase 4. No quantitative timing PASS may be inferred. T04-T06 remain BLOCKED because no oscilloscope or logic analyzer is available.

## T09 and retained state

T09 remains a priority after this checkpoint, with a separate bounded debugger request still required. Saved offline positions are 0x1e7a immediately after BOARD_InitHardware and 0x1ea4 after the timer update. Required evidence remains actual before/after SysTick priority, CTRL configuration and relevant masks, plus final LOAD=5999999. No numerical priority is assumed.

The installed `C:\NXP\LinkServer_26.9.130\Readme.md` documents a GDB `load` requirement, including attach mode. `docs\GDBServer.md` documents reset and disconnect effects. No no-load attach behavior has been verified, and no GDB server/client has been launched. If the chosen method requires another same-image programming operation, it must be explicitly included in a new scope and accounted separately; H3 cannot be reused. Resolving this does not authorize a rebuild or source change. Incidental offline `rg` wildcard-path lookup errors were followed by successful directory/glob searches; they caused no target action or TD test outcome.

Counters now: P3-F05 **1/3 consumed, 2 remaining** after L01/V02; P3-F02 **2/3 consumed, 1 remaining**; all other saved issue counts unchanged. Applicable unique-test status remains **0 PASS / 0 FAIL / 5 BLOCKED / 0 NOT RUN**; no T07/T09 attempt has started. Approval checkpoint state is independent of those test statuses.

Exact resume action: record the H4 decision; if approved and ready, resolve native permission and execute reset 1 with logging, then wait for actual engineer observations before resets 2 and 3. If deferred, preserve state without repeating completed diagnostics. No final versioned report is issued solely for this pending decision; the next final report remains v1.1 at a valid later stopping condition.
