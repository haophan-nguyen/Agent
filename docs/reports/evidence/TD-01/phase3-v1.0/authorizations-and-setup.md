# Attributable authority and setup record

Recorded by Codex for TD-01 v1.1, execute mode. Both engineer messages below were received on 2026-11-01; message event times and message IDs were not supplied. Collection timestamps elsewhere do not establish approval times. Approver: engineer/user in this chat; personal name not supplied.

## A-P3-ENTRY — initial engineer instruction

The engineer requested use of phase3-execution-debug in execute mode for TD-01 v1.1 and authorized Phase 3 preparation, non-invasive tool discovery, read-only diagnostics, and autonomous approved operations when tools and permissions allow. The engineer designated the existing Debug ELF as candidate, subject to identity verification, and required review of Phase 2 findings, actual evidence, bounded failure/recovery handling, and a Phase 3 report.

Explicit approval is required before flashing, resetting, debugger attachment, or any other disruptive hardware operation. Source modification, rebuilding, committing, and starting Phase 4 are prohibited. Candidate designation is not programming authority or acceptance of residual provenance risks.

## A-P3-SETUP — engineer reply to preparation question

Engineer-provided facts:

- Board: personal NXP FRDM-MCXN236; asset ID N/A.
- Physical board revision: not yet verified.
- Engineer cites NXP UM12041 Rev. 3.0, Table 25: J5 pin 1 = P4_18; J5 pin 8 = GND. These are candidate measurement connections pending physical confirmation.
- Oscilloscope/logic analyzer availability and model: not yet confirmed.
- COM3 detected, with target firmware identity and execution still unverified.

The engineer instructed continuation of non-invasive discovery and independently authorized preparation, prohibited assumptions or fabricated measurements and quantitative timing PASS claims, and repeated the approval requirement for flash/reset/debug/disruptive interaction. If equipment is unavailable, affected timing tests must be BLOCKED while independent authorized work may continue. Availability is currently unverified, not established absent.

No physical connection, voltage, instrument setting, LED observation, firmware programming, reset, register result, waveform, risk acceptance, or disruptive-operation approval was supplied by this reply.

## A-NATIVE — current execution-environment approval requests

Three concrete requests used exec_command with sandbox_permissions=require_escalated:

1. Read-only Windows CIM USB-device and relevant debug/instrument-process inventory. Tool result chunk ede0a5 returned completed commands; structured operation times are in host-discovery-escalated.json.
2. Host-only LinkServer version/help and GNU readelf/objdump version/offline ELF inspection. Tool result chunk e0d456 returned completed commands; structured operation times are in host-tools-escalated.json.
3. LinkServer probes --no-boot and host flash/reset help. Tool result chunk 28b8ec returned completed commands; structured operation times are in probe-discovery.json.

The native mechanism allowed these concrete commands to execute. Separate approver identity, approval-decision timestamp, and approval-event ID were not exposed in the returned results; they are not invented. These requests did not include flash verification, programming, target reset, a GDB server/client connection, register access, or probe firmware updates. Their scope grants no such authority.

Historical Phase 2 escalation approval remains unverified (A01); these current permission requests cannot establish that history.
