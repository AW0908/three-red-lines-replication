---
tags: [mtpa, agents, role]
status: reference
updated: 2026-10-16
---

Hub: [[Agent Team Overview]]

# Roles

Five roles, each defined in `agents/roles/*.md`. Worker and reviewer tools are set per card (`worker:`, `reviewer:`); model tier per card (`priority:`) → [[Scripts and Safeguards]].

## Overview

| Role | Who | Inputs | Writes to | Never does |
|---|---|---|---|---|
| **PI** | Anton (human) | card, worker report, review, `state/STATE.md`, `PROJEKT_STAND.md` | only via `agents/pi.sh` → `state/approvals.log` | hands responsibility for a claim to an AI; puts other students' proposals or referee reports into any AI tool |
| **Co-PI** | Claude Code (model set by Anton via `/model`) | PI goal, `PROJEKT_STAND.md`, `state/STATE.md` | `tasks/`, `state/`, `protocols/`; after delivery `AI_USAGE_LOG.md`, `PROJEKT_STAND.md` | runs `pi.sh`; sets `status:` by hand; takes research decisions; `git push` in `proposal/` |
| **Worker (data/code)** | Codex CLI, `codex exec -s workspace-write` | card, `AGENTS.md`, card inputs (read only); on `REWORK` also `review/T###.md` | only the card's write scope (now under `replication/`) + report | changes `status:`; touches `Daten/` or raw data; invents data; adds analyses or filters not in the card |
| **Worker (text) / Writer** | Claude, separate call without chat history | card, `AGENTS.md`, `PROJEKT_STAND.md`, `state/STATE.md`, outputs, `literature/` | only `proposal/` files in the write scope | runs commands or git (no Bash); uses numbers not in outputs or citations without a project source |
| **Independent Reviewer** | Antigravity `agy --mode plan` (data); Codex `-s read-only` (text) | frozen candidate, card, script facts (input hashes, out-of-scope changes, LaTeX diff/compile) | nothing – `review.sh` writes `review/T###.md` | changes files; runs commands; invents findings |

## Responsibilities in short

| Role | Core responsibilities |
|---|---|
| PI | States goals; approves cards (may change `priority:` first); accepts after `PASS`; decides `ESCALATE`; may override a persisting `REWORK`/`ESCALATE` with a logged reason; runs network downloads himself |
| Co-PI | One card = one checkable result; acceptance criteria checkable without asking; open research questions go to the PI, not decided; first-pass QA → feedback in the card or `candidate.sh`; after `DELIVERED`: Overleaf push (text tasks), AI log, `PROJEKT_STAND.md` |
| Worker (data/code) | Implements exactly the card; relative paths, fixed seed; runs the run command itself and checks every criterion; stops on a stop condition and reports instead of working around it |
| Writer | English academic style; every number with `% source: …` from outputs; unverified references marked `% UNVERIFIED`; missing decisions as `% TODO(PI)`; LaTeX must compile |
| Reviewer | Checks variable meaning, sample counts, reproducibility, scope, every criterion; first line `VERDICT: PASS / REWORK / ESCALATE`; anything not checkable listed under "not checked" |

## Report and verdict formats

| Output | Sections |
|---|---|
| Worker report `tasks/T###_report.md` | Result · Files · Execution (command + last lines) · Acceptance criteria (met / not met with evidence) · Open questions |
| Review `review/T###.md` | Header (date, tier, frozen files, input check, out-of-scope changes) · `VERDICT:` · Findings · Criteria · Not checked |

| Verdict | Meaning | Goes to |
|---|---|---|
| `PASS` | all criteria evidenced as met | PI for acceptance |
| `REWORK` | fixable within the card | Co-PI |
| `ESCALATE` | touches question, estimand, sample, data integrity, or the card itself is wrong | PI directly |

> [!info] In practice (as of 2026-10-16)
> - The reviewer never re-executes scripts (role forbids commands); reproducibility is checked statically from code and the worker's logged hashes (T001, T003, T007).
> - Codex workers now also run `Rscript` (R [number withheld]) – first used in T007 (environment check) and T004 (panel).
> - The Co-PI's first-pass QA carried T004 through five worker stops and seven runs (see [[Task Workflow]]).

Siblings: [[Task Workflow]] · [[Scripts and Safeguards]]

Source: `agents/roles/co-pi.md`, `worker.md`, `writer.md`, `reviewer.md`; `agents/TEAM.md`; `agents/worker.sh`; `agents/review.sh`; `tasks/T004.md`; `tasks/T007_report.md`; `review/T003.md`; `review/T007.md`.
