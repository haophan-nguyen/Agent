# Failure classification and recovery playbook

Use during execution/debug, or to interpret retained evidence in an audit. This playbook offers candidate actions; it grants no permissions. Apply the entry gate, mode, recovery budget, and stopping rules in [../SKILL.md](../SKILL.md) before any action. Audit mode never performs live diagnostics or recovery.

## Classify with evidence

Keep test status (PASS, FAIL, BLOCKED, NOT RUN) independent of the following categories:

| Category | Primary meaning |
| --- | --- |
| ENVIRONMENT_TOOL | Host, toolchain, debugger/tool installation, missing tool, or command-launch problem. |
| PERMISSION | Sandbox restriction, access denied, or required operation approval. |
| HARDWARE_SETUP | Power, wiring, board/boot setup, connections, or probe problems. |
| FIRMWARE_RUNTIME | Crash, exception, HardFault, hang, interrupt, or memory fault. |
| FUNCTIONAL_TIMING | Output/data mismatch, protocol failure, or timing violation. |
| TEST_INFRASTRUCTURE | Harness, logging, measurement, or evidence-collection failure. |
| REQUIREMENT_DESIGN | Conflicting, incomplete, incorrect, or ambiguous approved requirements. |
| UNKNOWN | Evidence does not support a more specific classification. |

Classifications and root-cause hypotheses are provisional until supported. Record reclassification with the new evidence and retain earlier diagnoses and retry counts. Use a primary category and linked contributing categories when supported; avoid forcing a single cause. For example, access denied is not proof of faulty firmware, and an absent trace is not proof of a timing failure. Preserve a demonstrated criterion violation as FAIL even if another part of its evidence collection is blocked.

Before recovery, retain the original symptom, exact operation, execution ID, identities/configuration, outputs, and relevant device state where authorized. Each category below requires these common records plus the listed diagnostic evidence. Record unavailable evidence and why; do not fabricate it.

For every category, a missing requestable engineer decision triggers the interactive approval checkpoint in `SKILL.md`, not silent termination. Separate hard prerequisites from reviewable risks: request scoped acceptance for noncritical provenance/evidence uncertainties; obtain mandatory authority and resolve unsafe state or critical identity before affected operations. Missing required test evidence still prevents PASS. Record the explicit request, APPROVE/DENY/DEFER response or awaiting state, and subsequent actions. Preserve evidence and issue-wide counters while waiting; do not rerun completed discovery simply because the checkpoint spans turns.

## ENVIRONMENT_TOOL

- **Typical symptoms:** Executable not found, loader/DLL failure, incompatible tool version, debugger server failing before attachment, host process crash, or missing SDK/runtime needed by an approved runner.
- **Diagnostics:** Inspect exact exit/output and working directory; resolve tool paths and recorded versions; compare launch arguments, process environment, and dependencies with approved project records. Inspect wrappers for build/flash hooks. Use non-invasive version/help queries only when they have no target side effects. Distinguish inability to launch a tool from firmware failure.
- **Permitted automatic recovery:** Select an already installed approved executable or correct a demonstrably wrong invocation/working directory; apply a process-local environment correction consistent with the approved configuration. Restart a host-only tool only when no target attachment/reset or shared-service disruption follows. Re-execution consumes the applicable recovery budget. No application/build-input changes.
- **Engineer approval required:** Tool installation/update, changed toolchain/SDK, persistent environment changes, privilege escalation, restarting shared services, and any command with target side effects. Route required build/source changes to Phase 2; do not rebuild here.
- **Escalate when:** No approved compatible tool is available, the next fix changes baseline/scope, the same error persists without new evidence, or the retry limit is reached.
- **Required diagnostic evidence:** Resolved executable path/version as available, launch command and directory, relevant environment differences, loader/tool output and exit code, comparison with approved configuration, and attempted correction/retry result. Do not infer availability or approval from a filename alone.

## PERMISSION

- **Typical symptoms:** Sandbox denial, access denied on a device/file/process, permission prompt, or an operation blocked by policy or account privileges.
- **Diagnostics:** Identify the exact denied operation, resource, identity, tool output, and boundary. Separate engineer task approval from execution-environment permission. A failed path lookup alone may be ENVIRONMENT_TOOL; classify based on actual evidence.
- **Permitted automatic recovery:** Preserve the restriction/denial; inspect existing authority through permitted read-only means. If engineer task authority is missing, present the concrete request in the conversation and wait for APPROVE, DENY, or DEFER; preparing a proposal alone is insufficient. There is no automatic privilege grant. Retry only after each required permission is granted and all other gates pass.
- **Engineer approval required:** Obtain the engineer's exact target/image/operation scope before hardware interaction; then use the environment's native escalation mechanism if needed for that command/resource. A native prompt is not a substitute for missing engineer authority. If task authority already exists, do not request it again merely because native permission is needed.
- **Escalate when:** A denied operation has no independently authorized alternative, permission is genuinely unavailable, or the boundary is outside engineer control. While an engineer decision is awaited/deferred, preserve a pending checkpoint rather than closing the workflow solely for missing approval. Do not repeatedly prompt after denial or use alternate accounts, paths, executables, or tools to bypass the restriction. Independent authorized tests can continue.
- **Required diagnostic evidence:** Restricted/denied command or operation, resource/target/image and scope, actual error if any, explicit conversation request and reference, response or awaiting/deferred state, separate native permission outcome, preserved context/counters, and subsequent authorized action/result. Do not invent a denial, approval event, or completed operation from silence or a historical success.

## HARDWARE_SETUP

- **Typical symptoms:** Unreachable target, unstable connection, unexpected boot mode, absent signal, brownout/reset indication, or probe/cabling/power mismatch.
- **Diagnostics:** Inspect setup records, board/probe identity, power specifications, wiring and boot configuration; compare with approved setup. Request engineer observations or use authorized instruments for actual readings. Querying a probe can attach/halt/reset a target; inspect its effects and authority first. Rule out host tools/permissions without assuming the board is faulty.
- **Permitted automatic recovery:** Reopen a host-side connection only when its effect is understood and approved; execute specifically preauthorized reset/reconnect/power-control sequences within the approved electrical/setup limits and recovery budget. Capture evidence before state loss. A listed sequence is not blanket reset authority.
- **Engineer approval required:** Physical rewiring, changing voltage or clock/boot settings, power cycling, resets, probe reconfiguration, or debugger attachment not already specifically covered. Use engineer-assisted steps when physical access or suitable tools are unavailable.
- **Escalate when:** Target/image identity is uncertain, electrical limits or setup are unknown, instability persists, hardware intervention is needed, or safety/evidence preservation is threatened. Stop affected operations immediately if damage is plausible.
- **Required diagnostic evidence:** Device/board/probe identity and connection, setup diagram or attributable engineer description, measured rails/settings with method and units, boot/reset indications, probe output, and authorization plus before/after recovery state. Distinguish measurement from visual inspection and unverified setup assumptions.

## FIRMWARE_RUNTIME

- **Typical symptoms:** HardFault/exception, watchdog reset, hang, lost heartbeat, unexpected interrupt behavior, memory fault/corruption, or repeatable crash.
- **Diagnostics:** Preserve logs and an authorized fault snapshot; associate PC/LR/stack, exception/reset status, memory/register values, and backtrace with the exact image and matching symbols. Consider optimization, interrupt context, debugger perturbation, and watchdog effects. Read-to-clear registers and invasive memory access require effect-aware authorization. Static source/symbol inspection may support a hypothesis but does not prove target behavior.
- **Permitted automatic recovery:** Analyze retained dumps/logs offline. Retest/relaunch or perform reset/reconnect only when explicitly covered by target/image authority and the recovery budget, after retaining required fault evidence. Program the same designated image only if specific flashing authority already covers that recovery; capture the programming result and identity linkage.
- **Engineer approval required:** New debug attachment/halt/step, breakpoint/watchpoint, register/memory write, reset, or flash outside existing scope. Source/instrumentation changes and rebuilt diagnostic images require a return to Phase 2 and new provenance/authorization; do not patch live memory to make a test pass.
- **Escalate when:** The fault repeats without useful progress, root cause requires source/build changes, destructive recovery would erase essential evidence, runtime state cannot be safely inspected, or the budget is exhausted.
- **Required diagnostic evidence:** Fault/reset logs, exact image/hash and matching symbols, available register/stack/dump data, capture operation and side effects, hypothesis with confidence, each recovery/retest, recurrence, and residual risk. Mark missing symbols/snapshots explicitly; do not promote correlation to verified cause.

## FUNCTIONAL_TIMING

- **Typical symptoms:** Wrong output/polarity, incorrect data, protocol errors, lost events, latency violation, or interval/frequency/duty measurements outside an approved bound.
- **Diagnostics:** Compare actual data with exact approved units, limits, sample counts, duration, startup/steady-state conditions, and protocol semantics. Check signal mapping, measurement setup, sample rate/timebase, trigger, uncertainty, and debugger/harness perturbation. Separate measured behavior from source calculations and visual impressions. Check runtime/setup causes as evidence warrants.
- **Permitted automatic recovery:** Reprocess retained raw data using the approved method; correct a demonstrated acquisition/analysis configuration error only within approved settings and scope, retaining the original result and identifying infrastructure involvement. Repeat the approved test within the remaining budget. Do not trim violating samples or discard intermittent failures unless the approved method explicitly provides that rule.
- **Engineer approval required:** Revised thresholds, measurement method outside approved scope, changed stimulus/load/duration, hardware changes, new intrusive debugging, or firmware changes. Route acceptance/design changes to Phase 1 and firmware/build changes to Phase 2.
- **Escalate when:** A violation is confirmed, compliance depends on unapproved interpretation, measurement resolution/accuracy is inadequate, firmware changes are needed, or bounded recovery does not resolve it. A confirmed failure remains recorded even if independent tests continue.
- **Required diagnostic evidence:** Raw captures/data, actual values/units and approved limits, stimulus and sample coverage, analysis method/tool, instrument settings and relevant accuracy, target/image/configuration, observed violation, and original plus retest results. Human-visible activity alone cannot pass quantitative timing.

## TEST_INFRASTRUCTURE

- **Typical symptoms:** Harness crash, parser/schema mismatch, missing or truncated logs, lost serial data, instrument acquisition failure, inadequate measurement coverage, mismatched timestamps, or evidence linked to the wrong run.
- **Diagnostics:** Compare raw output with parsed results and harness commands/version; inspect capture configuration, storage availability, timebase, buffering, and execution-to-evidence association. Determine whether the test ran but evidence failed, or execution never started. Preserve any raw failure that already proves a firmware violation.
- **Permitted automatic recovery:** Reparse existing evidence without changing original files; select a writable task evidence location within permissions; correct an approved capture setting; restart capture or an isolated host harness and retest within budget when target effects and repeatability are authorized. Write derived artifacts separately with their input references.
- **Engineer approval required:** Test harness/source changes, dependency installs, changed sampling/method outside approved limits, disruptive instrument/device actions, or rerunning a test whose side effects are not authorized. Harness repair is not implicit permission to change the approved test.
- **Escalate when:** Required evidence is irretrievably lost, a retest cannot be safely repeated, harness and firmware faults cannot be separated, criteria cannot be evaluated reliably, or the budget is exhausted. Report unsupported claims as BLOCKED, not PASS.
- **Required diagnostic evidence:** Raw and parsed output, harness/tool identity and configuration, storage/capture errors, affected interval/sample coverage, mapping to execution and firmware, collection gap and impact, and recovery/retest evidence. Disclose ignored/temporary evidence and retention risk.

## REQUIREMENT_DESIGN

- **Typical symptoms:** Conflicting limits, missing expected behavior or test method, incompatible prerequisites, ambiguous units/scope, or a requirement inconsistent with the approved test procedure.
- **Diagnostics:** Cite the exact approved design revision, conflicting statements, related test/requirement IDs, and why the gap prevents an objective decision. Check existing approved clarifications without inventing precedence. A surprising result alone does not prove the requirement is wrong.
- **Permitted automatic recovery:** No automatic design repair. Inspect approved records and prepare a concrete clarification request; continue only independent tests whose criteria remain unambiguous and authorized.
- **Engineer approval required:** Clarification that changes scope or criteria, waivers, changed tests, and return to Phase 1 for revised approval. A design change that affects firmware also requires the relevant Phase 2 work and renewed Phase 3 gates.
- **Escalate when:** Conflicts or missing criteria prevent a defensible outcome. Stop affected tests immediately; do not spend recovery attempts trying to satisfy invented criteria or silently choose the easiest interpretation.
- **Required diagnostic evidence:** Design/approval identity, cited clauses and test mappings, observed conflict and impact, pending engineer decision, and any actual approved clarification. Preserve prior results under their original baseline; acceptance of risk is not a passing measurement.

## UNKNOWN

- **Typical symptoms:** Inconsistent or incomplete data, uncorrelated reset/output loss, no reproducible signature, or insufficient evidence to distinguish hardware, firmware, tool, and harness causes.
- **Diagnostics:** Build a concise evidence timeline, verify identity/configuration, compare retained successes/failures, and select the least disruptive authorized observation that distinguishes plausible categories. Mark confidence and unknowns explicitly; absence of evidence does not establish a cause.
- **Permitted automatic recovery:** Non-invasive offline inspection and a bounded repeat of an already authorized test when safe, likely to yield new evidence, and within budget. Do not apply a sequence of speculative resets, reflashes, or parameter changes.
- **Engineer approval required:** Any additional intrusive observation/recovery outside existing scope, new hardware access, expanded test method, or source/design changes. Request the specific next observation or decision, not open-ended control.
- **Escalate when:** No useful discrimination is possible, the same result repeats without new information, identity is uncertain, a safe next step is unavailable, or the budget is exhausted. Keep UNKNOWN as a legitimate unresolved category.
- **Required diagnostic evidence:** All known symptoms and capture limitations, event order/times at recorded precision, exact run identities, candidate hypotheses and supporting/contrary facts, next observation rationale, attempts consumed, and the remaining blocker.

## Recovery disposition

Use issue dispositions such as open, awaiting engineer, recovered with retest evidence, or unresolved at handoff; these are separate from test status. A retest PASS does not erase the original FAIL, prove a speculative root cause, or resolve intermittent behavior contrary to the design. Link every intervention to its authorization and new execution evidence. Preserve the issue-wide count through reclassification and shared failures as defined in `SKILL.md`.

At escalation, provide the symptom/category and confidence, evidence references, actions already attempted and count, current test status, affected dependencies, residual risk, and the exact engineer decision or intervention needed. Explicitly request the decision in the conversation when needed; a report recommendation alone is insufficient. Do not continue the restricted action while awaiting it. Resume within an approved scope, retain a deferred checkpoint, or finalize a denied/unavailable path only after considering independently authorized alternatives.
