---
tags: [mtpa, agents, workflow]
status: reference
updated: 2026-10-16
---

Hub: [[Agent Team Overview]]

# Task Workflow

Every larger work step runs through one card `tasks/T###.md` (template `tasks/_TEMPLATE.md`). `status:` is set **only by the scripts**. Overview: `agents/status.sh` or the live dashboard → [[Scripts and Safeguards]]; snapshot → [[Task Board]]. Small questions need no card.

## The [number withheld] steps

| Step | Who | What | Command | Status after |
|---|---|---|---|---|
| [number withheld] | PI | States the goal to the Co-PI | – | – |
| [number withheld] | Co-PI | Writes the card | file edit | `PLAN` |
| [number withheld] | PI | Reads and approves | `agents/pi.sh approve T###` | `APPROVED` |
| [number withheld] | Worker | Implements; report `tasks/T###_report.md` | `agents/worker.sh T###` | `EXECUTED` |
| [number withheld] | Co-PI | First-pass QA; feedback in card + rerun, or freeze | `agents/candidate.sh T###` | `CANDIDATE` |
| [number withheld] | Reviewer | Verdict `review/T###.md` | `agents/review.sh T###` | `PASS` / `REWORK` / `ESCALATE` |
| [number withheld] | PI | Accepts after `PASS` | `agents/pi.sh accept T###` | `DELIVERED` |

After `DELIVERED`: text tasks → `agents/overleaf.sh push T###`; Co-PI logs the task in `AI_USAGE_LOG.md` and updates `PROJEKT_STAND.md`. `agents/pi.sh return T###` sends any card back to `PLAN`.

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Override path – used in practice

`agents/pi.sh override T### "reason"` accepts despite `REWORK`/`ESCALATE`; the reason is appended to `state/approvals.log`. In all three cases so far the finding concerned the procedure or the card, not the result:

| Task | Verdict | Override reason (approvals.log, translated) | Date |
|---|---|---|---|
| T002 | REWORK ×[number withheld] | criteria [number withheld]–[number withheld] met; finding only concerns provenance evidence outside `proposal/` | 2026-10-15 13:48 |
| T006 | REWORK | criteria [number withheld]–[number withheld] met; change to `worker.sh` by the Co-PI, documented in the card | 2026-10-15 13:54 |
| T007 | ESCALATE | R chain works; criterion [number withheld] mis-specified by the Co-PI, deviation random; outside changes by Co-PI/PI | 2026-10-16 10:40 |

Common root cause: the out-of-scope check is time-based and flags edits by the Co-PI or parallel work. Hence the next rule.

## Parallel-session rule (`AGENTS.md`)

Only the Co-PI session changes project files outside `tasks/`, `review/`, `state/` — and **not while any card is `APPROVED`, `EXECUTED` or `CANDIDATE`**. Other sessions (e.g. vault building) do not change these files. Example of the problem: the team-diagram update on 2026-10-16 was written by a separate Claude session during T003/T004 and had to be recorded in both cards.

## Co-PI first-pass QA loop (example T004)

Stops are the intended behaviour: the worker stops on a stop condition, the Co-PI checks the raw data, the PI decides if a research rule is affected (`state/STATE.md`), the card gets a "Co-PI feedback" entry, and `worker.sh` runs again. T004 needed [number withheld] worker runs on 2026-10-16 (details in its task note → [[Task Board]]).

## Files per task

| File | Written by |
|---|---|
| `tasks/T###.md` | Co-PI (content), scripts (`status:` only) |
| `tasks/T###_report.md`, `tasks/T###_worker.log` | `worker.sh` |
| `review/T###_baseline.sha256` / `_frozen.sha256` | `worker.sh` (first run) / `candidate.sh` |
| `review/T###_proposal.diff`, `_latex.txt` | `candidate.sh` (text tasks) |
| `review/T###.md` | `review.sh` (only the latest review is kept) |
| `state/runs.log` / `state/approvals.log` | `worker.sh`, `review.sh` / `pi.sh` |
| `state/terminal.log` | terminal output of the script runs |

Siblings: [[Roles]] · [[Scripts and Safeguards]] · Agent Org Chart.canvas

Source: `agents/TEAM.md` (Ablauf einer Aufgabe); `AGENTS.md` (parallel sessions); `agents/pi.sh`; `agents/worker.sh`; `agents/candidate.sh`; `agents/review.sh`; `state/approvals.log`; `state/runs.log`; `tasks/T003.md`, `tasks/T004.md`.
