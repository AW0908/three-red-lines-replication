---
tags: [mtpa, task, proposal]
status: done
updated: 2026-10-16
---

Hub: [[Task Board]]

# T006 Overleaf Structure

| Field | Value |
|---|---|
| Card | `tasks/T006.md` – Overleaf project structure: preamble, section files, folders for figures and tables, bibliography |
| Status | `DELIVERED` 2026-10-15 13:54 **via override** |
| Priority | low |
| Worker → Reviewer | Claude (haiku) → Codex (low, read-only) |
| Timeline ([number withheld]) | approved [number withheld]:[number withheld] · worker [number withheld]:[number withheld] · review REWORK [number withheld]:[number withheld] · override [number withheld]:[number withheld] |
| Write scope | `proposal/main.tex`, `preamble.tex`, `sections/01–06_*.tex`, `appendix/ai_use.tex`, `figures/README.txt`, `tables/README.txt`, `references.bib` |

Splits the one-file skeleton of [[T002 LaTeX Skeleton]] into modules so later writer cards can edit single sections. No content change.

## Key results

- `preamble.tex`: all T002 packages plus `caption`, `subcaption`, `threeparttable`, `float`, `xcolor`, `\graphicspath{{figures/}}`; `hyperref` last.
- `main.tex`: only `\documentclass`, `\input{preamble}`, title page, `\input` of sections [number withheld]–[number withheld], bibliography block, `\appendix` + `appendix/ai_use`.
- Section files with labels `sec:intro` … `sec:preliminary`; all [number withheld] `% TODO(PI)` comments carried over verbatim.
- Compiles cleanly (`review/T006_latex.txt`); in Overleaf since commit `[number withheld]`.

## Why the override

Reviewer found criteria [number withheld]–[number withheld] met but flagged a change to `agents/worker.sh` outside the scope. It came from the Co-PI (a `Write(./proposal/**)` rule added and removed again; Claude ignores it because `Edit(...)` covers all write tools). PI reason: *criteria [number withheld]–[number withheld] met; change to worker.sh by the Co-PI, documented in the card*.

## Open points

- [ ] BibTeX of the focal papers: Anton exports from publisher/DOI pages into `literature/`, then a `low` card fills `references.bib`.
- [ ] Copy script `replication/outputs/` → `proposal/figures/`, `proposal/tables/` still missing.
- Citation style stays `plainnat` unless Zhuang specifies otherwise.

Siblings: [[T002 LaTeX Skeleton]] · [[T007 R Environment Check]]

Source: `tasks/T006.md`; `tasks/T006_report.md`; `review/T006.md`; `state/runs.log`; `state/approvals.log`; `PROJEKT_STAND.md` §[number withheld].
