---
tags: [mtpa, task, log]
status: reference
updated: 2026-10-14
---

# Run Log

Combined chronological view of `state/runs.log` (worker and reviewer runs, written by `agents/worker.sh` / `agents/review.sh`) and `state/approvals.log` (PI decisions, written only by `agents/pi.sh`). Snapshot 2026-10-14; the log files themselves are the record.

| Date | Time | Task | Source log | Actor | Tool / tier | Priority | Result |
|---|---|---|---|---|---|---|---|
| 2026-10-13 | [number withheld]:[number withheld] | [[T001 A-Share Audit]] | approvals | PI | `pi.sh approve` (card sha2[number withheld] `[number withheld]a5[number withheld]a7[number withheld]`) | – | `APPROVED` |
| 2026-10-13 | [number withheld]:[number withheld] | [[T001 A-Share Audit]] | runs | Worker | codex, medium | normal | `EXECUTED` |
| 2026-10-13 | [number withheld]:[number withheld] | [[T001 A-Share Audit]] | runs | Reviewer | agy, gemini-[number withheld]-flash-medium | normal | **PASS** |
| 2026-10-13 | [number withheld]:[number withheld] | [[T001 A-Share Audit]] | approvals | PI | `pi.sh accept` (card sha2[number withheld] `[number withheld]a2[number withheld]a8[number withheld]bc`) | – | `DELIVERED` |
| 2026-10-13 | [number withheld]:[number withheld] | [[T002 LaTeX Skeleton]] | approvals | PI | `pi.sh approve` (card sha2[number withheld] `[number withheld]c1edd6[number withheld]f6b8`) | – | `APPROVED` |
| 2026-10-13 | [number withheld]:[number withheld] | [[T002 LaTeX Skeleton]] | runs | Worker | claude, sonnet | normal | `EXECUTED` |
| 2026-10-13 | [number withheld]:[number withheld] | [[T002 LaTeX Skeleton]] | runs | Worker | claude, sonnet | normal | `EXECUTED` |
| 2026-10-13 | [number withheld]:[number withheld] | [[T002 LaTeX Skeleton]] | runs | Worker | claude, sonnet | normal | `EXECUTED` |
| 2026-10-13 | [number withheld]:[number withheld] | [[T002 LaTeX Skeleton]] | runs | Reviewer | codex, medium | normal | **REWORK** |
| 2026-10-13 | [number withheld]:[number withheld] | [[T002 LaTeX Skeleton]] | runs | Reviewer | codex, medium | normal | **REWORK** |

## Not in the logs

- `agents/candidate.sh` (freeze → `CANDIDATE`) writes no log line; freezes are visible only in `review/T###_frozen.sha256` and the review header.
- The "Rechte" (permissions) line that the current `worker.sh` writes for Claude runs is absent from the T002 entries — it was added to the script later (see `review/T002.md`, finding [number withheld]).
- No `override` or `return` has been used so far.

## Counts

| | T001 | T002 |
|---|---|---|
| Worker runs | [number withheld] | [number withheld] |
| Review runs | [number withheld] | [number withheld] |
| PI actions | [number withheld] | [number withheld] |

Related: [[Task Board]] · [[Task Workflow]] · [[Model Tiers]] · [[Scripts Reference]]

Source: `state/runs.log`; `state/approvals.log`; `agents/worker.sh`; `agents/candidate.sh`; `agents/pi.sh`; `review/T002.md`.
