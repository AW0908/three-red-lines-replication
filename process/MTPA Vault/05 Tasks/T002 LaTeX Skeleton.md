---
tags: [mtpa, task, proposal]
status: done
updated: 2026-10-16
---

Hub: [[Task Board]]

# T002 LaTeX Skeleton

| Field | Value |
|---|---|
| Card | `tasks/T002.md` – LaTeX skeleton of the research proposal |
| Status | `DELIVERED` 2026-10-15 13:48 **via override** |
| Priority | normal |
| Worker → Reviewer | Claude (sonnet) → Codex (medium, read-only) |
| Write scope | `proposal/main.tex`, `proposal/references.bib` |
| Runs | [number withheld] worker runs ([number withheld], [number withheld]:[number withheld]–[number withheld]:[number withheld]); [number withheld] reviews → `REWORK` ([number withheld]:[number withheld], [number withheld]:[number withheld]) |

## Why the override

Both reviews found criteria [number withheld]–[number withheld] **met** (compiles, syllabus format, six sections in order, title page, TODO comments only, no numbers or citations). Only criterion [number withheld] ("nothing else changed") was not evidenced: the time-based scope check listed [number withheld] files outside `proposal/` changed by the Co-PI and parallel data work. The PI accepted with the logged reason: *criteria [number withheld]–[number withheld] met; finding only concerns provenance evidence outside `proposal/`*.

## Key results

- `proposal/main.tex`: pdfLaTeX skeleton – `article` [number withheld]pt, [number withheld]-inch margins, `\onehalfspacing`, Times (`newtxtext`); title page with working title, abstract and keyword placeholders; sections Introduction · Related Literature · Theoretical Framework · Empirical Model · Context and Data · Preliminary Analysis, each with `% TODO(PI)` items from the syllabus; bibliography block (`plainnat`, commented out); appendix "AI-Use Statement" table.
- `proposal/references.bib`: comments only, no entries.
- Split into a modular structure by [[T006 Overleaf Structure]]; T002 + T006 are in Overleaf since commit `[number withheld]`.

## Open points

- [ ] Working title "Real or Cosmetic Deleveraging? China's Three Red Lines and Property Developers' Balance Sheets" – still marked `% TODO(PI)`.
- [ ] Citation style: `plainnat` (author-year) unless Zhuang requires another.
- [ ] Paper size (preamble `a4paper`) and content of Theoretical Framework – PI.

Siblings: [[T006 Overleaf Structure]] · [[T001 A-Share Audit]]

Source: `tasks/T002.md`; `review/T002.md`; `state/runs.log`; `state/approvals.log` (2026-10-15 13:48); `PROJEKT_STAND.md` §[number withheld].
