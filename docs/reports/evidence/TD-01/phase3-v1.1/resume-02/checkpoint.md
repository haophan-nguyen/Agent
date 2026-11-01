# TD-01 v1.1 Phase 3 resume checkpoint 02

This is a **nonterminal checkpoint**, in `execute` mode, awaiting fresh engineer decisions TD01-P3-R3 and TD01-P3-H3. It does not close Phase 3 or replace the previous report. Codex prepared it after the engineer's new explicit resume request on 2026-11-01; the message event time was not supplied. Collection times are in the linked JSON records.

## Restored state and identity

- Approved design: [TD-01 v1.1](../../../../../test_design/TD-01.md), R1-R5 and T01-T09 unchanged. Applicable instructions: root AGENTS.md and the Phase 3 skill with its report contract and failure playbook.
- Predecessors: [Phase 3 report v1.0](../../../../phase3-TD-01-v1.0.md), [execution ledger](../../phase3-v1.0/execution-ledger.json), [failure ledger](../../phase3-v1.0/failure-ledger.json), [stopped continuation/approval ledger](../approval-ledger.json), and [V01 result](../verify-result.json). Historical evidence remains unchanged.
- Historical source HEAD: `fcc0898c30a32d0091f347dc434029f9debec17c`. Current HEAD: `b630da3bd67d84150d1cc574c2959be5e8e73039`. The intervening commit adds only the Phase 2/3 skill and reference files; production inputs did not change in that commit.
- Existing application working change: 14 additions; normalized Git blob `a8ac886e5385cf0ffd0421ac1f0dec0322523e55`; raw SHA-256 `46AD8D67DE632F9FDFFB8D8366AA9E832FAC03D81BAAC0A44C8A4D1976E588AF`. It still matches Phase 2.
- Designated Debug image: `D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf`, **199936 bytes**, SHA-256 **2859DB1162705BF6567EDB235DE6A05AC08153268E00B64B7248AC382E36E391**. This matches the Phase 2 manifest and V01 preflight.
- Configuration: debug, `-g -O0 -Wall -Werror`, Cortex-M33 / MCXN236VDF. Retained build provenance: GCC 14.2.1 / Arm GNU 14.2.Rel1, SDK 2026.09.00, CMake 3.30.0, Ninja 1.13.2. Full historical dependency identity remains incomplete.
- Target: engineer's personal FRDM-MCXN236, asset ID not applicable, physical board revision unknown. Probe: **SPOBEAQ0BCREX**, historical descriptor MCU-LINK FRDM-MCXN236 (r0E7), CMSIS-DAP V3.146. The descriptor is not proof of PCB revision.
- V01 identified NXP MCXN236 / Cortex-M33, CPU ID 00000D21, DAP DP ID 6BA02477. No live target access was performed during this resume. Current loaded image and execution/halt state remain unknown; the historical operation reported reset/halt and flash-driver SOFTRESETs.
- R1/H1 retain their historical decisions and completed V01 action only. They supply **no future authority**. R2/H2 were cancelled before presentation and remain cancelled. The new resume instruction authorizes Phase 3 continuation, not disruptive operations or residual-risk acceptance.
- Recovery counters: P3-F02 **2/3 consumed, 1 remaining**; P3-F01/F03/F04/F05/F06 and A01/A02 **0/3 consumed, 3 remaining each**. No counter was renewed. V01 was the initial identity diagnostic, not a recovery intervention or TD functional test.

[resume-identity.json](resume-identity.json) retains current tracked/selected-input identities and a preservation manifest for 41 previous evidence files, including ignored raw logs. It records the existing dirty/untracked state without claiming a clean checkout. These snapshots establish current preservation, not historical build provenance.

## Investigation and next action

The retained [V01 raw output](../verify-output.log) reports a flash/file mismatch, first at `0x0000044C`: file `0x0020FD5D`, flash `0x0020FD43`. Native exit was -1, the inner driver reported 1, and the logging shell exited 0. The shell result does not override the verifier failure.

Offline analysis mapped all **20 reported file words** through the current ELF's PT_LOAD segments; every word matches the exact designated ELF. See [mismatch-analysis.json](mismatch-analysis.json). This supports **P3-F05 / TEST_INFRASTRUCTURE: confirmed image attribution mismatch**. The full old image and why it differs remain unknown. No application, runtime, or timing defect has been proven, and no TD criterion violation has been observed. The log is not a full flash dump or proof of current live state.

Repeating unchanged verification would not load the designated image. The next appropriate action is one exact-image **load --no-reset**, then one associated **verify** only after a successful, expected load result. This is proposed, not executed. Verification would establish compared flash contents, not normal application execution or a T07/T09 PASS.

## TD01-P3-R3: separately answerable risk disposition

**APPROVE, DENY, or DEFER** accepting these retained uncertainties solely to use the exact Debug ELF above for H3 and subsequent separately authorized T07/T09 work under TD-01 v1.1:

- A01: historical Phase 2 native escalation approval is not attributable from retained records.
- A02: complete historical SDK/toolchain/dependency immutability is not established.
- P3-F03: the Debug CMake cache differs from the Phase 2 audit; original cache bytes, cause, author, and change time are unknown. Its current SHA-256 remains `B5DDFE3306EE488491294AF9D3E6891AE9387397B94B13100B6CDB0DE9C4A647`, as in the saved Phase 3 checkpoint.

Known mitigation: the application and exact ELF match the retained Phase 2 identities; recorded build graph/compile commands matched the prior comparison; this run changes no build/source/design input. Risks remain recorded. Acceptance does not reconstruct or certify historical approvals/dependencies, authorize any hardware operation, waive mandatory identity/setup/evidence, change acceptance criteria, or establish PASS. The prior R1 acceptance is not reused.

## TD01-P3-H3: separately answerable load and verification approval

**APPROVE, DENY, or DEFER** exactly the following two invocations, with working directory `D:\work_space\Agent\Agent`, target `MCXN236:FRDM-MCXN236`, probe `SPOBEAQ0BCREX`, and the exact Debug ELF/hash above:

```powershell
& 'C:\NXP\LinkServer_26.9.130\LinkServer.exe' flash --probe SPOBEAQ0BCREX --update-mode none --no-boot MCXN236:FRDM-MCXN236 load --no-reset 'D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf'
```

Only after that invocation completes successfully, with output consistent with the approved target/image and no unexpected condition:

```powershell
& 'C:\NXP\LinkServer_26.9.130\LinkServer.exe' flash --probe SPOBEAQ0BCREX --update-mode none --no-boot MCXN236:FRDM-MCXN236 verify 'D:\work_space\Agent\Agent\frdmmcxn236_led_blinky\debug\frdmmcxn236_led_blinky.elf'
```

**Effects and risks:** replace existing firmware by erasing/programming affected flash sectors; data in those sectors, including trailing sector contents, may be lost. The preconnect hook asserts a 50 ms wire reset, connects SWD, and requests a debug-mailbox session. RAM flash drivers may execute and issue SOFTRESETs, halt the core, disturb state, erase volatile evidence, or leave an unknown/halted target. `--no-reset` suppresses the post-program execution-from-reset step; it does **not** prevent connection/driver resets. `--no-boot` is a probe option, not a target-reset guarantee. Interrupted/failed programming may leave a partially programmed target.

**Approval prerequisites:** separately approve R3; confirm the same physical FRDM-MCXN236 is associated with SPOBEAQ0BCREX and the current power/connections are safe for these effects; confirm the existing firmware and all affected-sector data may be replaced and any flash/volatile evidence needing retention has already been preserved. If any of those facts cannot be confirmed, DEFER and state what is missing. A critical target/setup mismatch stops the operation. No live preservation read is implied or authorized by this request.

**Limits:** one load plus one validating verify, no automatic retry. Charge P3-F05 recovery attempt **1 of 3** when the load intervention is issued, including failed/uncertain outcomes; the associated verification does not consume a second attempt. Requests/waiting consume none. Each invocation has a **30 s observation deadline**. On error, mismatch, unexpected state or uncertain completion, retain output and issue no subsequent target command. Do not forcibly interrupt a state-changing command or issue a restoration/reset; request engineer disposition. A successful verification still requires a separate decision for reset/run and T07/T09.

**Exclusions:** mass erase / `--erase-all`, unlock/resurrection, probe firmware update, changed boot settings, extra invocations/recovery, standalone reset/run, GDB attachment or register testing, T07 resets, instrument actions, source/image/build/design edits, rebuilding, committing, pushing, and Phase 4. New engineer H3 authority and any required native sandbox permission are distinct. No native hardware prompt is submitted before engineer authority and hard prerequisites are satisfied.

## Remaining execution and reporting state

Applicable Phase 3 unique-test counts remain **PASS 0 / FAIL 0 / BLOCKED 5 / NOT RUN 0**; TD hardware test attempts remain 0. Historical target identity diagnostics: V01, one completed mismatch; hardware recovery interventions: 0. T01/T02/T03/T08 are earlier-phase tests and have not been rerun.

- **T04-T06: BLOCKED** because the engineer now explicitly reports no oscilloscope or logic analyzer. No quantitative timing substitute or acceptance change is proposed.
- **T07: priority after image identity is established.** Three engineer-controlled resets, actual initial-ON and subsequent-pattern observations required. No reset authority or observation has been supplied. Preserve the approved criterion; visual observations cannot establish quantitative timing limits.
- **T09: priority after image identity is established.** Separate bounded debugger session with actual before/after SysTick priority, CTRL configuration, interrupt masks, and final LOAD=5999999. Retained offline PCs are 0x1e7a before update and 0x1ea4 after update. Session authority and actual captures remain pending; no build-before-debug IDE launch is permitted.

The full seven-item entry gate and additive failure/test state are in [execution-continuation.json](execution-continuation.json). Request/response/native-permission/action state is in [approval-ledger.json](approval-ledger.json). No source/configuration/image change, build, commit, target operation, or Phase 4 work occurred during preparation of this checkpoint. No completed discovery/version/help/probe diagnostic was rerun.

Exact resume action: record separate attributable R3/H3 decisions; if approved, resolve the stated physical/data-preservation prerequisites, recheck only operation-critical identity freshness, obtain the concrete native permission where required, then issue the one load and conditional verifying invocation with raw output and operation/result records. Stop for a new scoped T07/T09 checkpoint afterward, or on any earlier unexpected result. Strong retry/operation enforcement would require an external runner or interlock; the skill and persisted counters alone do not guarantee it.

Do not issue a terminal report solely while approval is pending/deferred. At a valid later stopping condition, produce the next unused final report `docs/reports/phase3-TD-01-v1.1.md`, with all nine sections and retained evidence links. The previous report and evidence remain preserved; final engineer acceptance and Phase 4 are pending.
