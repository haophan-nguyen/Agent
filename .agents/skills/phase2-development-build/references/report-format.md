# Phase 2 report contract

Use this format for `execute` and `audit/report-only`, including blocked or partial work. It specifies report contents, not permission to carry out any operation.

## Version and identity

Use a repository reporting convention if one exists; otherwise write `docs/reports/phase2-<task-id>-v<major>.<minor>.md`, starting at v1.0. Inspect existing reports and select the next unused revision. Preserve older reports and link the superseded version with a brief revision note. Report version and Test Design version are independent.

At the top, identify project/task, report version, mode, preparation timestamp using the convention below, report author, design ID/version/path and approval status, approved source baseline, inspected/built revision plus dirty-tree identity, and disposition. Distinguish report preparation time from historical execution time. Mark unavailable metadata explicitly; do not guess it.

## Timestamp convention

Apply this convention automatically to every future Phase 2 report in either mode, across metadata, prose, tables, approvals, execution records, and evidence summaries:

- Format timestamps as ISO 8601 with a numeric UTC offset, for example `2026-11-01T09:00:00+07:00`. Use `+00:00` for UTC rather than `Z`. Do not include geographical timezone names or timezone abbreviations in report text.
- Preserve actual precision: a time recorded only to the minute remains `2026-11-01T09:00+07:00`; retain seconds or fractional seconds only when recorded. Never append invented seconds, fractional digits, or other missing time components.
- If only a date is known, retain the ISO 8601 date, such as `2026-11-01`, and state that the time was not recorded. Do not invent midnight or append a UTC offset to a date-only value.
- Use an offset established for the recorded event. For historical evidence, do not substitute the report preparation time or the current local offset. If a time or offset cannot be established, retain the known components at their recorded precision, explicitly identify the missing information (for example, `UTC offset unknown`), and do not present the value as a complete normalized timestamp.
- Normalize historical timestamps only in the new report when supported by evidence; cite the source without reproducing geographical timezone names. Leave existing reports, raw logs, firmware, and Test Design unchanged.

Use these exact nine section headings. Keep sections concise; use `Not performed`, `Not applicable` with a reason, or `Unknown` when appropriate rather than inventing content.

## 1. Task Understanding

State the approved behavior, constraints, implementation boundary, protected areas, required configurations/checks, and evidence criteria. Identify applicable `AGENTS.md` and design references. State the current request and mode, separating approved facts, observed baseline facts, assumptions, and unresolved questions. An assumption cannot fill an approval gap.

## 2. Implementation Plan and Decision Rationale

Map planned changes to approved requirements and explain material decisions using short technical justifications and evidence. Include preservation constraints and how they will be checked. Separate planned actions from completed actions. In an audit, describe the inspection plan and attribute documented historical decisions; if no rationale is recorded, say so.

Give conclusions and concise, reviewable reasons. Do not expose hidden chain-of-thought, internal deliberation, or a fabricated reasoning transcript.

## 3. Key Actions and Tool Results

Record actions actually performed in this run, with commands/tool operations, working directories, relevant environment settings, versions, dates, exit codes, and evidence references. Distinguish source review, configuration, compilation/linking, and approved software checks. In an audit, list read-only inspection here and clearly label any historical actions cited from existing evidence. Never imply audited commands were rerun.

## 4. Issues, Troubleshooting and Resolutions

For each issue, record symptom/evidence, established cause or unverified hypothesis, authorized investigation/correction, retry result, residual impact, and status. Separate host permission failures from firmware build failures. Preserve failed attempts alongside successful ones. Disclose warnings and whether their origin was established; without baseline evidence, do not assert that a warning is pre-existing. Identify blockers and required engineer action. Do not imply equipment is absent merely because availability is unverified.

## 5. Human Approvals

Record approval type, exact scope/design revision or command, approver as known, date as known, decision, and reference. Distinguish engineer design approval, any required Phase 2 start instruction, execution-permission escalation, and review/acceptance. Use explicit evidence or an attributable approval record; label a prior report's unsupported approval narrative as unverified. Never invent names, timestamps, permission prompts, approvals, or acceptance. Record pending, denied, or unavailable approvals and their effects. If no escalation was needed, say so.

## 6. Requirement Traceability

Include a table mapping every approved requirement to implementation file/symbol or diff, relevant test/check IDs, evidence references, Phase 2 finding, and remaining target verification. Include unchanged/protected behavior. Mark out-of-scope findings without treating them as approved changes. Source-based calculations and preservation checks support development conclusions; they do not establish measured device behavior.

## 7. Build and Test Results

List every required configuration and approved check/test ID, method, expected criterion, actual result, status, and evidence. Identify the tested source/configuration/artifact and whether results were produced now or inspected historically. Separate configure and build results, incremental/no-op and clean builds, warnings, source inspection, calculations, host checks, and target execution.

Use the design's status vocabulary when specified; otherwise apply:

| Status | Meaning |
| --- | --- |
| PASS | The specific check ran, met its expected criterion, and has sufficient attributable evidence. Qualify source/build passes by method; they are not hardware passes. |
| FAIL | Evidence shows a criterion was not met. Keep a demonstrated failure visible even if other checks are blocked. |
| NOT RUN | The check was not performed; no result is asserted. In audit mode, explicitly state that no builds/tests were rerun. |
| BLOCKED | A required prerequisite, authorization, or evidence is missing. State exactly what prevents a defensible result. |

Report an unavailable, stale, or mismatched historical result as unverified/blocked, with its original claim attributed separately; do not promote it to PASS. A build alone cannot pass timing, reset, target register, or other hardware criteria. If target work was not run during Phase 2, state that; distinguish any separately documented historical hardware evidence from this run.

## 8. Evidence References

Provide paths/links and identities for the approved design and approval record, source revision plus working-tree diff, reviewed source/configuration, toolchain/SDK metadata, complete logs/exit codes, check outputs, and firmware manifests (configuration, path, byte size, SHA-256). Link each material result to supporting evidence; do not treat a narrative report as a substitute for missing raw results.

During execute mode, retain logs/diffs/manifests in a stable task/version-specific location, such as `docs/reports/evidence/<task-id>-v<version>/`, or the repository's evidence store. Reference large binaries by retained location and hash as appropriate. Identify ignored/temporary artifacts and retention risks; do not claim they are committed or durable. In audit mode, reference existing evidence without altering it. State what was actually inspected, what is missing or inaccessible, and what remains assumed.

## 9. Final Status and Phase 3 Handoff

State whether Phase 2 is blocked, incomplete, or complete for engineer review, and why. For an audit, give the audit disposition separately from the historical Phase 2 claim; do not certify completion if required evidence is missing. List unresolved defects, scope/approval gaps, warnings, and pending checks. Identify candidate image/configuration/hash only when supported; do not silently select a hardware test image when engineer designation is required.

Provide the Phase 3 prerequisites, pending test IDs/criteria/evidence, engineer decisions, and known or unverified board/probe/instrument availability as applicable. Describe a handoff only; it does not start Phase 3. Record final acceptance as pending unless explicit engineer acceptance exists. State which operations were actually performed and that this run stopped at Phase 2.

## Local examples, not project defaults

This skill was informed by repository-relative `docs/test_design/TD-01.md` and `build/phase2-evidence/report.md`. Consult them only when relevant and available. They illustrate separate design/start approval, requirement-to-source/test mapping, source calculations versus hardware measurements, configuration-specific logs, host escalation, warning disclosure, and source/image identities. The old report's ignored build-directory location is not the destination for new reports.

Do not inherit their board, timing values, requirement/test IDs, tool paths, configurations, approval events, or reported successes into another task. Derive those from that task's approved design and inspect its own evidence.
