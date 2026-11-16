---
tags: [mtpa, agents, workflow]
status: reference
updated: 2026-10-14
---

# Task Workflow

Every larger work step runs through one task card `tasks/T###.md` (template `tasks/_TEMPLATE.md`). The card's `status:` field is the only place where a task's status is kept, and it is set **only by the scripts**. Overview of all cards: `agents/status.sh` → [[Task Board]].

> [!info]
> Small questions and explanations need no task card (`AGENTS.md`). Tasks that are faster done than reviewed run directly in one tool (`agents/TEAM.md`, Grenzen).

## The [number withheld] steps

| Step | Who | What | Command | Status after |
|---|---|---|---|---|
| [number withheld] | [[Role - PI]] | States the goal to the Co-PI (in chat with Claude Code) | – | – |
| [number withheld] | [[Role - Co-PI]] | Creates `tasks/T###.md` from `tasks/_TEMPLATE.md` | (file edit) | `PLAN` |
| [number withheld] | PI | Reads the card, approves | `agents/pi.sh approve T###` | `APPROVED` |
| [number withheld] | [[Role - Worker]] / [[Role - Writer]] | Implements; report to `tasks/T###_report.md` | `agents/worker.sh T###` | `EXECUTED` |
| [number withheld] | Co-PI | First-pass QA of report and result against the criteria; returns to worker or freezes | `agents/candidate.sh T###` | `CANDIDATE` |
| [number withheld] | [[Role - Independent Reviewer]] | Verdict to `review/T###.md` | `agents/review.sh T###` | `PASS` / `REWORK` / `ESCALATE` |
| [number withheld] | Co-PI / PI | On `REWORK` back to step [number withheld]; on `PASS` the PI accepts | `agents/pi.sh accept T###` | `DELIVERED` |

After `DELIVERED` (writing tasks only): `agents/overleaf.sh push T###` uploads to Overleaf ([[Overleaf Sync]]). The Co-PI then logs the task in `AI_USAGE_LOG.md` and updates `PROJEKT_STAND.md`.

**Override.** If a finding persists that neither worker nor Co-PI can fix, the PI decides: `agents/pi.sh override T### "reason"` accepts despite `REWORK` or `ESCALATE` and logs the reason in `state/approvals.log`.

**Escalate.** `ESCALATE` goes directly to the PI: the reviewer found a problem affecting question, sample, estimand or data integrity. The PI decides and it is recorded in `state/STATE.md`.

**Return.** `agents/pi.sh return T###` sends a card in any status back to `PLAN` (in the script; not listed in TEAM.md's step table).

## State diagram

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Status gates enforced by the scripts

| Script | Allowed start status | Sets |
|---|---|---|
| `agents/pi.sh approve` | `PLAN` | `APPROVED` |
| `agents/worker.sh` | `APPROVED`, `REWORK`, `EXECUTED` | `EXECUTED` |
| `agents/candidate.sh` | `EXECUTED`, `CANDIDATE`, `REWORK` | `CANDIDATE` |
| `agents/review.sh` | `CANDIDATE` (and worker ≠ reviewer, freeze file present and intact) | `PASS` / `REWORK` / `ESCALATE` |
| `agents/pi.sh accept` | `PASS` | `DELIVERED` |
| `agents/pi.sh override` | `REWORK`, `ESCALATE` (reason required) | `DELIVERED` |
| `agents/pi.sh return` | any | `PLAN` |
| `agents/overleaf.sh push` | `DELIVERED` | – (commit + push) |

> [!info] REWORK without a new worker run
> `agents/candidate.sh` also accepts `REWORK`, for the case where the Co-PI could clarify a finding without a worker run; the reason must be given in the card. This is exactly what happened in [[T002 LaTeX Skeleton]].

## Task card structure (`tasks/_TEMPLATE.md`)

Front matter: `id`, `title`, `status`, `priority`, `worker`, `reviewer`, `created`. Sections (German headings, which the scripts parse):

| Heading | Meaning | Used by script |
|---|---|---|
| Ziel | one sentence: checkable result and its use in the proposal | – |
| Eingaben (nur lesen) | inputs, read-only, paths in backticks | `worker.sh` hashes them (baseline) |
| Schreibbereich | write scope, paths in backticks | `worker.sh` (detects `proposal/`), `review.sh` (out-of-scope check) |
| Schritte | steps | – |
| Abnahmekriterien | acceptance criteria, each checkable without asking | reviewer |
| Ausführungsbefehl | execution command | worker, reviewer |
| Stopp-Bedingungen | stop conditions | worker |
| Offene Fragen an den PI | open questions to the PI | – |
| Rückmeldung Co-PI | Co-PI feedback for rework | worker |

## Files produced per task

| File | Written by |
|---|---|
| `tasks/T###.md` | Co-PI (content); scripts (`status:` only) |
| `tasks/T###_report.md`, `tasks/T###_worker.log` | `worker.sh` |
| `review/T###_baseline.sha256` | `worker.sh` (first run only) |
| `review/T###_frozen.sha256` | `candidate.sh` |
| `review/T###_proposal.diff`, `review/T###_latex.txt` | `candidate.sh` (writing tasks) |
| `review/T###.md`, `review/T###_reviewer.log` | `review.sh` |
| `state/runs.log` | `worker.sh`, `review.sh` |
| `state/approvals.log` | `pi.sh` |

Workflow graphic: `Team_Workflow_EN.png` ([number withheld] numbered boxes; box [number withheld] "Upload – text tasks only, only after acceptance" and "Pull the latest version – before every text task" are the Overleaf lane). See also [[Agent Org Chart.canvas]].

Related: [[Agent Team Overview]] · [[Scripts Reference]] · [[Safeguards]] · [[Run Log]]

Source: `agents/TEAM.md` (Ablauf einer Aufgabe); `agents/roles/co-pi.md`; `agents/pi.sh`; `agents/worker.sh`; `agents/candidate.sh`; `agents/review.sh`; `agents/overleaf.sh`; `tasks/_TEMPLATE.md`; `Team_Workflow_EN.png`.
