---
name: phase2-development-build
description: Execute or audit Phase 2 development and build work in an embedded four-phase workflow, using an engineer-approved Test Design and producing a versioned evidence report. Use for authorized implementation/build or report-only review; stop before hardware execution and later phases.
---

# Phase 2 - Development & Build

Follow the repository's four phases: Requirement & Test Design; Development & Build; Execution & Debug; Verification & Report. This skill covers only Phase 2. Read applicable `AGENTS.md` files before acting; the approved Test Design is the source of truth for requirements, permitted changes, checks, and acceptance criteria.

## Select the mode

Use the mode requested by the engineer. Otherwise infer it from the requested action; if authority to execute is unclear, perform only read-only discovery and ask for clarification before implementation or build.

| Mode | Permitted work |
| --- | --- |
| `execute` | Perform development, configuration, builds, and Phase 2 checks authorized by the approved design and current task; capture evidence and write a report. |
| `audit/report-only` | Inspect existing source, diffs, approvals, logs, and artifacts; perform read-only comparisons or hash calculations; write a new report. Do not edit source, build configuration, dependencies, or existing evidence; do not configure, rebuild, clean, generate code, or execute firmware. |

A request to create or update this skill is not permission to execute its workflow. In report-only mode, missing evidence is a finding, never a reason to rebuild or repair implementation. If a request explicitly names audit/report-only but also asks for rebuilding or repairs, flag the mode conflict and obtain clarification before those actions; safe audit work may continue. Switch modes only with engineer authorization.

## Validate the entry gate

Before any implementation, configuration, or build:

1. Read the complete applicable Test Design, its revision/approval record, repository instructions, and the current task. Discover the design from the task and repository documentation; do not assume a fixed filename or choose between conflicting baselines silently.
2. Identify the exact design ID/version, explicit engineer approval and its reference, approved requirements/test IDs, implementation boundaries, protected files and behavior, constraints, acceptance criteria, evidence requirements, and required build configurations. Approval of an older revision does not approve later changes.
3. Verify authorization to start Phase 2. Design approval and execution permission are separate: honor any deferred-start condition and require the separate instruction when one is specified. A historical report or existing binary does not grant current execution authority.
4. Compare the requested work with that approved baseline. Stop implementation/build if approval is missing or unverifiable, requirements/instructions conflict, essential scope is ambiguous, or the change exceeds approved scope. Identify the discrepancy and request engineer clarification or a revised, approved design. Do not silently amend requirements, relax acceptance criteria, or record approval on the engineer's behalf.

When the gate fails, safe inspection may establish the blocker and a report may record it; no implementation/build may follow until it is resolved. Record existing approval evidence without asking for the same approval again. Keep design approval, Phase 2 start authorization, command escalation, and final acceptance as separate records.

## Establish the baseline and plan

- Record repository revision, applicable instruction/design identities, and starting working-tree state, including staged, unstaged, and relevant untracked changes. Preserve pre-existing work. Review both the current task delta and the cumulative source delta from the approved baseline; do not attribute pre-existing edits to this run.
- Map each approved requirement and Phase 2 check to the proposed source location, implementation decision, and verification method. Give a concise technical rationale for material choices and preservation of protected behavior, including relevant helper API side effects.
- Discover toolchain/SDK versions, board/target selections, build entry points, presets/configurations, and expected outputs from the design and repository. Resolve material gaps with the engineer rather than selecting a different board, SDK, or configuration. Do not assume every project uses Debug/Release, CMake, or a particular processor.
- Inspect build entry points and hooks for side effects. Select build-only commands; combined build/flash/debug targets cannot be run under Phase 2 authority. In audit mode, read saved configuration and tool metadata without invoking a command that may regenerate build state.

## Execute authorized development and build

Skip this section entirely in `audit/report-only` mode.

1. Implement only the approved changes. Preserve protected initialization, interrupt/peripheral behavior, generated files, SDK contents, and build settings as required by this project's design. Do not refactor unrelated code or repair unrelated warnings.
2. Review source diffs against the starting state and approved baseline. Check staged/unstaged and relevant untracked files, whitespace, scope boundaries, and requirement coverage. Inspect changed helpers and configuration for unintended effects. If an unexpected pre-existing change invalidates the design/build baseline, stop and clarify; do not erase it.
3. Run the required configure/build commands for every approved configuration and the approved Phase 2 checks. Record exact commands, working directory, relevant environment adjustments, tool versions, timestamps/time zone, exit codes, full logs, diagnostics, and output identities. Preserve original failures and subsequent attempts. Do not run Phase 3 execution/debug procedures to fill a test-result gap.
4. Investigate failures within scope. Distinguish command-launch/permission problems, environment/configuration failures, and compiler/linker failures using actual output. Retry after an identified correction; stop when resolution needs an unapproved change or repeated attempts provide no new evidence. Report unresolved causes rather than broadening scope or weakening checks.
5. When the execution environment requires escalation, request human approval through its permission mechanism for the concrete command and reason before running it outside current permissions. Design approval does not waive command permissions. If permission is denied or unavailable, record the affected operation as blocked; do not bypass the boundary. Do not invent approval details or a successful retry.
6. Review the final diff and verify that the final source/configuration state matches the recorded build inputs. If an in-scope edit follows a build, rebuild the affected required configurations and checks; otherwise mark prior evidence stale. Distinguish an incremental/no-op build from actual compilation/linking; do not imply a clean build was run.

Capture source revision plus working-tree diff/identity, toolchain and SDK identity, configuration, firmware artifact path/size/SHA-256, logs, and check evidence. A commit ID alone does not identify an uncommitted implementation. If identity or provenance cannot be established, record the limitation. Keep evidence available for review; do not rely solely on an ignored build directory without disclosing its retention risk.

## Audit existing work

In `audit/report-only`, compare the approved design with existing implementation and retained records. Verify accessible references, source/artifact identities, configuration coverage, command results, and evidence freshness using read-only methods. Attribute historical actions to their recorded operator/date. Separate a prior report's claim from the underlying evidence actually inspected; matching hashes support identity, not proof of hardware execution or historical permissions.

Do not reconstruct missing commands, approval events, troubleshooting, timestamps, or test runs. Record discrepancies, missing/stale evidence, and scope violations. Do not repair them. A gate failure remains a finding even when an existing report claims completion.

## Report and stop

For either mode, including blocked work, create a new versioned Markdown report under `docs/reports/`. Read [references/report-format.md](references/report-format.md) when preparing it; use all nine required sections and its result/evidence rules. Do not overwrite a previous report. Report-only mode may write this new report; it must leave implementation, build outputs, and existing evidence unchanged. If report writing is not permitted, present the report and record the unsaved-output blocker.

Present the report and relevant diffs/evidence for engineer review. Distinguish Phase 2 completion from hardware verification and final engineer acceptance. Stop after the handoff document: do not flash, attach a debugger, run target tests, commit, push, or enter another phase as part of this skill. Those actions require the applicable separate authorization and workflow; flashing requires engineer involvement, and final verification requires explicit engineer acceptance.
