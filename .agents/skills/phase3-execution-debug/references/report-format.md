# Phase 3 execution and audit report contract

Use for both modes, including blocked or partial work. This contract specifies records, not authorization to execute. Reports contain concise technical conclusions and decision rationales, never hidden chain-of-thought or reconstructed history.

## Version, identity, and storage

Follow the repository's report naming convention; otherwise use `docs/reports/phase3-<task-id>-v<major>.<minor>.md`, starting at v1.0. Inspect existing reports and choose the next unused version. Preserve earlier reports, link the predecessor, and state the revision reason. Report and Test Design versions are independent.

At the top identify task/project, report version and mode, author, preparation timestamp, execution/audit period as known, design ID/version/path and approval status, Phase 2 report/evidence references, Phase 3 entry authority, source plus dirty-input identity, executable/firmware identity, target and execution configuration, and disposition. Use `Unknown`, `Not recorded`, or `Not applicable` with a reason for missing/inapplicable information. A report preparation time is not an execution time.

### Evidence checkpoints and final-report timing

In execute mode, issue the final report when the authorized execution path completes, is denied with no independently authorized continuation, or cannot continue because of an unresolved hard prerequisite. Present any requestable engineer decision explicitly in the conversation first. Do not generate a terminal BLOCKED report merely because an approval has not been requested or is awaiting a response. A proposal hidden in a report does not satisfy this checkpoint.

While awaiting approval or after DEFER, retain periodic evidence checkpoints marked nonterminal and the exact resume action. Ending a chat turn to await a response does not close the execution run. Keep workflow/checkpoint states separate from PASS/FAIL/BLOCKED/NOT RUN test statuses; a blocked test may belong to an active run awaiting a decision. Close a deferred run only on an explicit engineer instruction or a separate genuine inability to continue. Audit/report-only may finalize its read-only assessment of historical gaps without requesting authority to rerun tests.

Preserve prior reports and evidence when resuming. Link an additive continuation ledger/checkpoint to earlier records and carry forward failure IDs and recovery counts; do not rewrite history or repeat completed discovery/host diagnostics without evidence of changed state. Generate the next versioned final report after the resumed authorized path reaches a reporting condition.

Retain execution evidence in a task/version-specific directory, such as `docs/reports/evidence/<task-id>/phase3-v<version>/`, or an approved repository evidence store. Give stable references to large files retained elsewhere; record path/URI, size/hash, custody/location, and access limitations as appropriate. Identify ignored/temporary files, uncommitted artifacts, retention risks, and missing evidence. A file's existence does not make it durable or committed. In audit mode, reference original records without altering/moving them; this run writes only the new report. If saving the report is blocked, present its contents and state the unsaved-output blocker.

## Timestamp convention

Apply throughout report metadata, prose, action logs, approvals, failure records, and evidence tables:

- Use ISO 8601 with numeric UTC offsets, for example `2026-11-01T09:00:00+07:00`; use `+00:00` for UTC rather than `Z`. Do not include geographical timezone identifiers or timezone abbreviations in reports, including quoted narratives or link labels.
- Preserve recorded precision: minute-only remains `2026-11-01T09:00+07:00`; seconds/fractions appear only when available. Never invent components to fill a format.
- For date-only evidence, retain the ISO date and state that time was not recorded; do not invent midnight or append an offset to a date.
- Establish offsets from evidence for the event; do not substitute the current offset for historical events. If time or offset is unknown, retain known components/precision and explicitly state what is missing rather than presenting a complete normalized timestamp.
- Keep relative hardware ticks/sample positions distinct from wall-clock timestamps; state frequency/timebase and correlation only when known. Do not invent wall-clock time from an uncorrelated trace.
- Normalize supported timestamps only in the new report. Preserve raw logs and prior reports unchanged; link evidence instead of copying incompatible timestamp text. If a path itself includes a geographical timezone identifier, use an evidence ID and a neutral link label rather than reproducing it in report prose.

## Result and provenance rules

| Test status | Meaning |
| --- | --- |
| PASS | The test executed, met all approved acceptance criteria, and has sufficient evidence attributable to its exact executable/image, configuration, and test case. |
| FAIL | Evidence demonstrates violation of an approved acceptance criterion. Keep a demonstrated violation visible even if another part of the run is blocked. |
| BLOCKED | A required prerequisite, authorization, tool, or sufficient attributable evidence is unavailable. State the specific blocker. |
| NOT RUN | The test has not executed and no outcome is asserted; state why, including sequencing or scope where relevant. |

Status is independent of failure category, issue disposition, and phase/audit completion. Record every attempt, including failed attempts before recovery. A later PASS is a new result; show its relationship to earlier failures and apply the design's repetition/consistency rules to any final per-test summary. Do not mask intermittent failures, count missing evidence as PASS, or average failures away. When a blocked test also has an earlier failed attempt, retain both and explain the current summary.

Distinguish actual instrument measurements, engineer visual observations, register/debug captures, host outputs, source calculations, and inferred behavior. A calculation or visible activity cannot establish quantitative target timing. Tool exit 0 alone cannot establish functional compliance. Distinguish measured resolution/accuracy and test perturbations where relevant.

Each material result must identify source revision plus relevant dirty-input identity, exact firmware/executable, build and runtime configuration, target/setup, test/execution ID, operator as known, method, approved expected criterion, actual observation, status, and evidence. A matching image file hash alone does not prove that it was loaded or executed. Record the target-to-image linkage and its method. If missing/mismatched provenance makes an outcome indefensible, record BLOCKED and attribute any historical success claim separately.

## Execution ledger

Record each execution attempt and material diagnostic/recovery action in retained records. Use tables or a structured log suited to the project; no specific file format is required. Link compact report summaries to full logs. In audit mode assess the existing ledger and record gaps without creating fictitious historical entries.

Required fields:

- Test ID, requirement IDs, execution ID, failure ID where applicable, operator, start/end/duration at actual precision, and event sequence when absolute times are unknown.
- Source revision and working-input identity; firmware/executable path, size, SHA-256 and build configuration; target identity and evidence of loaded image; relevant runtime/setup configuration.
- Exact command/tool operation, tool version where known, working directory, relevant environment, instrument/debug settings and side effects; approved timeouts, duration/repetition, and safe stop behavior.
- Actual outputs/observations, exit/termination state, approved criterion, test status, raw/derived evidence IDs, units/measurement method, and evidence gaps.
- Failure category and confidence, concise root-cause hypothesis or verified cause with supporting evidence, diagnostic action and short rationale.
- Recovery action, authorization scope/reference, attempt number and remaining limit, previous actions, and actual outcome. State explicitly if an action was only proposed, denied, engineer-performed, or not performed.
- Retest execution/evidence, result, final issue disposition, residual risk, and continue/stop/escalate decision.

Record approval checkpoints in the same ledger or an explicitly linked additive approval ledger. For each checkpoint retain:

- Checkpoint ID and affected test/failure IDs; hard prerequisite versus reviewable risk, supporting evidence, uncertainty, impact, and mitigation.
- Exact requested command/operation, directory, target/probe, firmware path/configuration/hash, side effects/risks, bounded authorization scope, finite limits, conditions and exclusions.
- Explicit conversational request with APPROVE/DENY/DEFER choices, attributable message/reference and time when available. Distinguish prepared requests from presented requests; a ledger entry alone does not present a request. Do not invent event IDs or exact presentation times.
- State such as PREPARED, AWAITING_RESPONSE, APPROVED, DENIED, or DEFERRED; actual response/scope, approver and timestamp as recorded, or explicit absence of a response. Silence is never approval. Keep separately answerable risk acceptance and operation authorization distinct even when grouped for presentation.
- Separate native tool/sandbox permission request/outcome and scope; neither authority substitutes for the other. No restricted command may run while its engineer task authority is pending.
- Resume context: completed/pending actions, baseline and target identity, existing grants, evidence references, counters/remaining recovery allowance, unresolved hard gates and exact next action. Waiting consumes no attempts.
- Actual subsequent action/execution ID, result/evidence and conditions satisfied; or denial alternative, deferred context, or final inability to continue. Append responses/actions when they occur; do not pre-record approval or execution.

Store failure evidence before recovery and keep it after success. Identify derived analyses and their raw inputs/tool configuration; do not overwrite raw captures to represent corrected parsing. Preserve permission/launch failures separately from firmware failures. Human-assisted execution requires attributable engineer results and sufficient evidence, not merely an instruction checklist.

## Required report sections

Use these exact nine headings. Keep sections reviewable; state `Not performed`, `Unknown`, or `Not applicable` with a reason instead of inventing content.

## 1. Task Understanding & Entry Gate

State mode, approved behavior and scope, applicable `AGENTS.md`, design/approval identity, Phase 2 handoff and retained evidence, protected inputs, and pending Phase 3 tests. Summarize every entry-gate item with its evidence and outcome, identifying any pending approval checkpoint. Distinguish global/test-specific hard blockers from reviewable risks requiring scoped disposition. Missing mandatory authority, unsafe setup, critical target identity and required test evidence cannot be waived as risks; incomplete historical provenance or noncritical gaps may be reviewable when they do not invalidate mandatory prerequisites. Include known source/image/build/runtime identity, target linkage, tool availability, unresolved Phase 2 issues, and actual engineer risk acceptance. Separate approved facts, actual observations, assumptions, and unverified claims; an assumption cannot supply authorization.

In an audit, distinguish authority for this read-only report from evidence of historical execution authority. A historical gate gap remains a finding even if a previous report claims completion.

## 2. Execution Plan and Decision Rationale

Map planned tests to requirements, acceptance criteria, prerequisites/dependencies, sequence, tools, evidence, measurement adequacy, and permissions. Include intended observation durations, repetitions, timeouts, safe stopping, and finite recovery limits. Explain material diagnostic/setup choices concisely, identifying perturbation risks. Distinguish planned actions from performed ones. In an audit, describe the inspection plan and label any historical rationale as documented or unknown.

## 3. Key Actions, Tool Calls and Observations

Summarize operations actually performed with test/execution IDs, time/sequence, exact command or tool action, directory/environment/configuration, operator, tool version where known, observations, exit/result, and evidence IDs. Separate host launch, programming, reset, debug, capture, measurement, and analysis. Identify engineer-assisted actions and which evidence was actually received. Show instructions awaiting engineer action as pending.

In an audit list this run's read-only inspections separately from cited historical actions; never imply audited tests/tools were rerun. Preserve original errors and failed attempts alongside later success; do not hide subcommand failure behind the final shell exit code.

## 4. Failure Classification, Debugging and Recovery History

Provide a structured record per failure/issue with all these fields:

| Field | Required content |
| --- | --- |
| Failure ID | Stable ID; related/shared-cause issues and previous records. |
| Test ID | Affected test/requirement IDs and execution IDs. |
| Failure category | Primary category, contributing categories, confidence, reclassification and evidence. |
| Symptom | Actual observation and its time/sequence; keep test status separate. |
| Supporting evidence | Raw logs/captures, identities/configuration, actual criterion violation or blocker, limitations. |
| Root-cause hypothesis or verified cause | Concise explanation supported by evidence; label uncertainty and what would verify it. |
| Diagnostic actions | Actual operation, result, reference, and short technical rationale; distinguish proposed actions. |
| Recovery attempts | Chronological action/outcome, count consumed, finite limit, scope, and evidence; retain failed/uncertain attempts. |
| Human approvals | Scope, decision, reference, and relevant interventions; pending/denied/unknown when applicable. |
| Retest results | New execution ID, unchanged approved criteria, actual observations/status/evidence; state when not performed. |
| Final disposition | Open, awaiting engineer, recovered with retest evidence, or unresolved; residual risk and next required decision. |

Include useful progress, reasons for any repeated action, budget exhaustion or earlier stopping, and required return to Phase 1/2. State any need for external enforcement of retry/operation limits; skill instructions alone cannot guarantee it. Do not turn a successful retest into proof of a root cause that remains hypothetical.

## 5. Human Approvals and Interventions

Record approval type, precise task/baseline/target/image/operation scope, approver as known, timestamp at recorded precision, actual decision, and attributable reference. Distinguish design approval, Phase 3 entry, image designation, flashing, disruptive operations, native environment escalation, out-of-scope changes, return to Phase 1/2, acceptance of residual risks/blockers, and final review/acceptance. Link approvals covering a bounded sequence; do not fabricate separate approval events.

Record engineer-assisted physical actions/results and evidence; distinguish requested from completed work. Mark pending, denied, unavailable, or historically unverified authority and its effects. An unsupported narrative in an old report is not a verified permission grant. Reuse valid approvals within scope without requesting them again. Risk acceptance does not change criteria or convert BLOCKED/FAIL to PASS.

Link each actual request, response or awaiting/deferred state, and subsequent action to the approval ledger. State what was presented in the conversation, not merely proposed in a report. Show bounded grouped requests without conflating risk disposition, hardware authorization, and native permission. If denied, record independently authorized alternatives considered and their outcome; if deferred, identify preserved context and resume point. If a terminal report contains unresolved approvals, explain the denial, genuine hard blocker, or explicit engineer instruction that closed the path rather than treating an unasked/unanswered decision as closure.

## 6. Test Results & Requirement Traceability

Map every approved requirement and applicable Phase 3 test to expected criterion, method/configuration, actual observations, per-attempt execution ID, status, evidence, and remaining work. Include requirements whose Phase 3 check is inapplicable with a reason; do not duplicate earlier-phase passes as new execution. Keep protected behavior and dependent blocked tests visible.

Show original failures and retests and the basis for the current per-test summary. Explain excluded/out-of-scope findings without treating them as approved changes. Report PASS/FAIL/BLOCKED/NOT RUN counts for unique tests separately from attempt counts; state any partially performed test details. For audits, distinguish historical evidence-supported outcomes from this run's absence of execution. Missing/stale/mismatched historical evidence cannot support a PASS.

## 7. Evidence References

Provide an evidence index with IDs, descriptive links/paths, type/method, associated test/execution/failure IDs, source/image/configuration/target linkage, identities/hashes where appropriate, historical/current attribution, availability/inspection result, and retention risk.

Cover approved design and approvals, Phase 2 report/build provenance, source/diff manifest, executable/image manifest, target/programming identity records, full command logs/exit codes, serial/debug/fault records, raw instrument captures/settings and relevant accuracy, analysis inputs/outputs, recovery ledger, and engineer-provided results as applicable. Mark absent/inaccessible items explicitly. Verify accessible links/files and internal associations using read-only inspection; do not claim inspection of unavailable raw evidence. A narrative report cannot replace missing raw results.

## 8. Remaining Issues, Risks and Blockers

List unresolved failure IDs/categories, affected tests/dependencies, stale/missing evidence, setup or identity uncertainty, permission gaps, retry limits reached, and residual risks. Separate hard prerequisites from reviewable risks; state what resolves each prerequisite or which scoped risk disposition was requested. State what is known, unknown, accepted by an attributable engineer decision, denied, deferred, or awaiting response, with checkpoint references. Give a concrete engineer action or Phase 1/2 handback needed per blocker. Risk acceptance does not establish absent test evidence or waive mandatory authority/identity/safety conditions. Do not assume equipment is absent merely because availability is unverified, or imply risk acceptance occurred because work continued.

## 9. Final Status & Phase 4 Handoff

For a final report, state Phase 3 **complete for engineer review**, **partially complete**, or **blocked**, with the basis and unique-test counts for PASS, FAIL, BLOCKED, and NOT RUN. Identify why final reporting is now appropriate under the timing rules above. A nonterminal approval checkpoint states awaiting response/deferred and the resume action instead of declaring the run finished. Completion means all required Phase 3 execution/debug records and planned tests are addressed according to the approved scope; it does not imply all tests pass. A report with only a blocked entry gate is not completed execution. State outcome quality and unresolved failures separately. In audit mode, state audit disposition independently of historical Phase 3 completion and do not certify unsupported execution.

Hand off the exact tested baseline/images/configurations/targets, design and approval references, test matrix and raw evidence index, failures/classifications and recovery counts, remaining risks/blockers, needed decisions/retests, and evidence retention limitations. Identify the review/acceptance status as pending unless explicit engineer evidence exists. Describe only Phase 4 prerequisites; stop for engineer review and do not begin Phase 4. Final verification requires engineer acceptance.
