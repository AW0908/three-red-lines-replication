---
tags: [mtpa, agents, role]
status: reference
updated: 2026-10-14
---

# Role - Worker

**Who:** Codex CLI for data and code tasks (`worker: codex`). For writing tasks in `proposal/` the worker is Claude with the additional rules in [[Role - Writer]].

> "Clear task, limited write scope, clear stop condition." — "A file named 'final' is not evidence. Show how the result was produced." (guest lecture, slide [number withheld])

The worker implements exactly one approved task card and leaves evidence.

## Inputs

- The task card (read completely first), then `AGENTS.md` and the inputs listed in the card's section *Eingaben* (inputs, read-only).
- On `REWORK`: `review/T###.md` and the card section "Rückmeldung Co-PI"; fix exactly those points.

## Responsibilities

- Write only within the card's write scope (*Schreibbereich*).
- Never change, move or overwrite inputs or raw data (`Daten/`, `data/raw/`).
- Do not silently change the question: no extra analyses, other filters or other samples. If the card cannot be implemented or a stop condition occurs: stop and explain under "Offene Fragen" (open questions).
- Scripts run from the project folder with relative paths and a fixed seed.
- Run the card's execution command itself and check every acceptance criterion before reporting.
- No network access: missing data is an open question, not a reason for substitute data.
- Do not invent numbers, sources or results.

## Writes to

Only the paths in the card's write scope. The last message is saved by the script as `tasks/T###_report.md` with exactly these sections:

| Section (German original) | Content |
|---|---|
| Ergebnis | [number withheld]–[number withheld] sentences: what was produced |
| Dateien | every created/changed file, path in backticks, with purpose |
| Ausführung | exact command and the last lines of its output |
| Abnahmekriterien | per criterion: met / not met, with the number or file that proves it |
| Offene Fragen | what stayed unclear, what was assumed, what was not checked |

## Must never

- Change `status:` in the card.
- Write outside the write scope (rule; the Codex sandbox technically allows the whole project folder — see [[Safeguards]]).
- Touch `Daten/` or `data/raw/`.
- Invent data, sources or results.

## Technical setup

`agents/worker.sh` runs Codex as `codex exec -s workspace-write` (writes only inside the project folder, no network) with `model_reasoning_effort` from [[Model Tiers]]. Example: [[T001 A-Share Audit]].

Related: [[Agent Team Overview]] · [[Task Workflow]] · [[Role - Co-PI]] · [[Scripts Reference]]

Source: `agents/roles/worker.md`; `agents/worker.sh`; `agents/TEAM.md` (Rollen, Was technisch abgesichert ist); guest lecture `Lecture Note/Lecture02_SlidesGuest.pdf` slide [number withheld].
