---
tags: [mtpa, agents, role]
status: reference
updated: 2026-10-14
---

# Role - Co-PI

**Who:** Claude Code (in conversation with Anton it always acts as Co-PI and reads `agents/roles/co-pi.md`). The Co-PI's own model is set by Anton in Claude Code with `/model`; the scripts do not influence it.

> "The Co-PI is not a message forwarder — it is responsible for delivery completeness." (guest lecture, slide [number withheld])

The Co-PI plans and is responsible for the completeness of the delivery. It does **not** run the analysis itself.

## Inputs

- The PI's goal, `PROJEKT_STAND.md`, `state/STATE.md`.

## Responsibilities

**Plan**
- Create `tasks/T###.md` from `tasks/_TEMPLATE.md` (next free number), status `PLAN`.
- One card = one checkable result; split large work into several cards.
- Assign tools: data/code tasks `worker: codex`, `reviewer: agy`; writing tasks in `proposal/` `worker: claude`, `reviewer: codex`. Commission text only once the numbers it needs are in `output/`.
- Set `priority:` (`high` / `normal` / `low`; when in doubt the higher one) → [[Model Tiers]].
- Write acceptance criteria a third party can check without asking (numbers, files, value ranges, scale endpoints).
- Do not take decisions that change question, estimand, sample or data rules: record them as open questions in the card and in `state/STATE.md`, then wait for the PI.
- Show the card to the PI and **stop**.

**Execute**
- After approval: `agents/worker.sh T###`.

**First-pass QA**
- Check `tasks/T###_report.md` and the files named there against every acceptance criterion.
- Gap found: write points under "Rückmeldung Co-PI" (Co-PI feedback) in the card, rerun `agents/worker.sh T###`.
- Complete: `agents/candidate.sh T###`, then `agents/review.sh T###`.

**After the review**
- `REWORK`: `agents/worker.sh T###` (the worker reads `review/T###.md`), then candidate and review again.
- `ESCALATE`: stop and present the problem to the PI with reference to `review/T###.md`.
- `PASS`: present result, review and open points to the PI in a few sentences; the PI accepts.
- After `DELIVERED`: for writing tasks `agents/overleaf.sh push T###`; add an entry to `AI_USAGE_LOG.md`; update `PROJEKT_STAND.md`.

## Writes to

`tasks/`, `state/`, `protocols/` (plus `AI_USAGE_LOG.md` and `PROJEKT_STAND.md` after delivery).

## Must never

- Run `agents/pi.sh`.
- Set `status:` to `APPROVED` or `DELIVERED` (statuses are set only by the scripts).
- Make research decisions (question, estimand, sample, data rules).
- Run `git push` in `proposal/` itself (only via `agents/overleaf.sh push`).

> [!warning] Rule only, partly
> Claude Code *could* edit `status:` in a card by hand; it is only instructed not to. `state/approvals.log` shows which approvals really went through `agents/pi.sh`. See [[Safeguards]].

Related: [[Agent Team Overview]] · [[Task Workflow]] · [[Role - PI]] · [[Role - Worker]] · [[Role - Independent Reviewer]]

Source: `agents/roles/co-pi.md`; `agents/TEAM.md` (Rollen, Wichtigkeit und Modellwahl, Was technisch abgesichert ist); `AGENTS.md` (Agenten-Team); guest lecture `Lecture Note/Lecture02_SlidesGuest.pdf` slide [number withheld].
