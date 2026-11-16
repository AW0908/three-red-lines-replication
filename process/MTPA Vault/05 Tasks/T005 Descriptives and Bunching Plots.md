---
tags: [mtpa, task, analysis]
status: open
updated: 2026-10-16
---

Hub: [[Task Board]]

# T005 Descriptives and Bunching Plots

| Field | Value |
|---|---|
| Card | `tasks/T005.md` – descriptive table and bunching histograms of the three red-line ratios |
| Status | `APPROVED` [number withheld] [number withheld]:[number withheld] – card rewritten for R (`replication/code/03_figures.R`): summary stats, table by `dose`, bunching histograms, breach shares over time |
| Priority | normal |
| Worker → Reviewer | Codex → Antigravity |
| Input | `replication/data/processed/panel_firm_halfyear.csv` (from T004) |
| Outputs | `replication/outputs/tables/t0[number withheld]_summary_stats.{csv,tex}`; `replication/outputs/figures/t0[number withheld]_bunching_rl{[number withheld]}.pdf` |

## What it delivers

- The **descriptive table** the syllabus requires in "Context and Data": N, mean, SD, p1[number withheld]/p5[number withheld]/p9[number withheld] of the three ratios, `n_breached` and all outcomes, by period and market (A / HK).
- First **bunching histograms** around [number withheld] % / [number withheld] % / [number withheld], pre ([number withheld]H1–[number withheld]H2) vs post ([number withheld]H2–[number withheld]H2), [number withheld]H1 dropped; threshold line, bin width and N stated.
- LaTeX table (`booktabs`) for `\input` in the proposal (→ [[Proposal Outline]]).

## Key acceptance points

N equals non-missing counts per cell; [number withheld]H1 excluded and stated; `.tex` compiles in `proposal/main.tex`; run command recreates all files; `data/processed/` unchanged. Stop if a ratio has > [number withheld] % missing in a period × market cell.

## Open points

- [ ] PI: confirm pre/post windows and dropping [number withheld]H1 as anticipation period.
- Formal Kleven ([number withheld]) excess-mass estimation = separate later card.

> [!idea] Suggestion (not decided)
> The card still names a Python script (`t005_descriptives.py`, run with `../Daten/.venv`), while the agreed split since T007 is R for preparation, estimation and figures (`PROJEKT_STAND.md` §[number withheld]). The Co-PI could revise the card to R before approval.

Siblings: [[T004 Firm Panel and Red-Line Metrics]] · [[T007 R Environment Check]]

Source: `tasks/T005.md`; `PROJEKT_STAND.md` §[number withheld] (T007).
