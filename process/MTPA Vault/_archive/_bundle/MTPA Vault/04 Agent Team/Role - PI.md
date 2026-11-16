---
tags: [mtpa, agents, role]
status: reference
updated: 2026-10-14
---

# Role - PI

**Who:** Anton Wilhelmi (human). The only role that is not an AI.

## Responsibilities

- Decides the research question, estimand, sample, data rules and every public claim.
- States the goal of a task to the [[Role - Co-PI]] (workflow step [number withheld]).
- Reads each task card and approves it (step [number withheld]); may change `priority:` before approving ([[Model Tiers]]).
- Accepts results after a `PASS` (step [number withheld]).
- Decides `ESCALATE` cases and records the decision in `state/STATE.md` (entered by the Co-PI with date).
- May override a persisting `REWORK`/`ESCALATE` finding that neither worker nor Co-PI can fix; the reason is logged.
- Runs data downloads (AKShare, EastMoney) himself, because workers have no network.
- Remains responsible for every statement in the proposal (syllabus; guest lecture slide [number withheld]). The review does not replace his own check (`agents/TEAM.md`).

## Inputs

- Task card `tasks/T###.md`, worker report `tasks/T###_report.md`, review `review/T###.md`.
- `state/STATE.md`, `PROJEKT_STAND.md`.

## Writes to / commands

Only via `agents/pi.sh` (logged to `state/approvals.log` with a SHA-[number withheld] prefix of the card):

| Command | Effect |
|---|---|
| `agents/pi.sh approve T###` | `PLAN` → `APPROVED` |
| `agents/pi.sh accept T###` | `PASS` → `DELIVERED` |
| `agents/pi.sh return T###` | any status → `PLAN` (back to the Co-PI) |
| `agents/pi.sh override T### "reason"` | `REWORK` or `ESCALATE` → `DELIVERED`, reason appended as `OVERRIDE: …` |

## Must never

- Hand responsibility for a claim to an AI.
- Put other students' proposals or referee reports into a task card or any AI service (`AGENTS.md` rule [number withheld]).

> [!info]
> `agents/pi.sh` is meant to be run by Anton only. Claude Code is blocked from running it according to `agents/TEAM.md` (via `.claude/settings.json`); see [[Safeguards]].

Related: [[Agent Team Overview]] · [[Task Workflow]] · [[Decisions and Open Questions]] · [[Run Log]]

Source: `agents/TEAM.md` (Rollen, Ablauf einer Aufgabe, Grenzen); `agents/pi.sh`; `AGENTS.md` (Agenten-Team, Arbeitsregeln).
