---
tags: [mtpa, agents, role]
status: reference
updated: 2026-10-14
---

# Role - Writer

**Who:** Claude, started by `agents/worker.sh` as a **separate call without chat history** (`worker: claude`). The writer rules (`agents/roles/writer.md`) are appended to the general [[Role - Worker]] rules whenever the card's write scope contains `proposal/`.

`proposal/` is a git clone of the Overleaf project. The writer edits only the LaTeX files listed in the card's write scope and never runs git; syncing is done by the script ([[Overleaf Sync]]).

## Inputs

- Task card, `AGENTS.md`, `PROJEKT_STAND.md`, `state/STATE.md`, files under `output/`, `literature/`.
- Before every writing task `agents/worker.sh` automatically runs `agents/overleaf.sh pull`.

## Rules

- **Language and form:** English, academic economics-paper style. Syllabus format: [number withheld] line spacing, [number withheld]-inch margins, [number withheld]pt Times New Roman; draft [number withheld]–[number withheld] pages.
- **Every number has a source in the project.** Numbers, tables and figures only from files under `output/`, with a LaTeX comment `% source: output/...` directly above. No number from memory, no rounded estimate, no "approximately".
- **Every reference is evidenced.** Cite only what is listed with a source in `PROJEKT_STAND.md` or `literature/`. Keep the recorded verification status: anything marked unverified or "abstract only" gets the comment `% UNVERIFIED: ...` and may not carry a claim beyond the abstract.
- **No new substantive decisions.** Question, estimand, sample and identification assumptions come from `PROJEKT_STAND.md` and `state/STATE.md`. If something is missing: `% TODO(PI): ...` at that spot and listed under open questions.
- **Name assumptions.** Wherever the text claims a causal effect, the identification assumption is stated in the same paragraph.
- **LaTeX must compile.** Escape special characters (`_`, `%`, `&`); only packages in the preamble (or added there if the preamble is in scope).
- Report: list every changed `.tex`/`.bib` file; under acceptance criteria additionally list all numbers in the new text with their source file.

## Writes to

Only `proposal/` (and within it only the files in the card's write scope).

## Must never

- Run commands or git (technically enforced: no Bash tool).
- Write outside `proposal/` (technically enforced: only `Edit(./proposal/**)` allowed).
- Use numbers not in `output/` or citations not in `PROJEKT_STAND.md` / `literature/`.
- Make research decisions.

## Technical setup

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Model from [[Model Tiers]]. Consequence seen in [[T002 LaTeX Skeleton]]: the writer cannot run `agents/overleaf.sh check` itself ("Bash refused"); compilation is checked by `agents/candidate.sh` instead.

Related: [[Agent Team Overview]] · [[Task Workflow]] · [[Proposal Outline]] · [[Proposal Requirements]]

Source: `agents/roles/writer.md`; `agents/worker.sh` (case `claude`); `agents/TEAM.md` (Rollen, Overleaf); `tasks/T002_report.md`.
