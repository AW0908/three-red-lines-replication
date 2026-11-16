---
tags: [mtpa, task, data]
status: in-progress
updated: 2026-10-16
---

Hub: [[Task Board]]

# T004 Firm Panel and Red-Line Metrics

> [!success] Delivered [number withheld] [number withheld]:[number withheld]
> Reviewer verdict **PASS** on all criteria; the script set ESCALATE only because macOS `.DS_Store` changed during the review → accepted by Anton via override (all result files unchanged).

| Field | Value |
|---|---|
| Card | `tasks/T004.md` – firm-half-year panel [number withheld]H2–[number withheld]H2 with red-line ratios, treatment intensity, ownership, outcomes (R) |
| Status | `DELIVERED` [number withheld] [number withheld]:[number withheld] (approved [number withheld]:[number withheld]; override: review PASS, ESCALATE only for `.DS_Store`) |
| Priority | **high** |
| Worker → Reviewer | Codex (high, `Rscript`) → Antigravity (gemini-[number withheld]-flash-high) |
| Outputs | `replication/data/processed/panel_firm_halfyear.csv` via `replication/code/01_clean.R`; tables `t0[number withheld]_panel_counts`, `t0[number withheld]_item_coverage`, `t0[number withheld]_ownership_unresolved`, `t0[number withheld]_variable_dictionary` |

Definitions → [[Variables and Metrics]]; data description → [[Firm Panel]]. Binding rules: PI decisions of 2026-10-16 in `state/STATE.md`.

## History ([number withheld] worker runs, [number withheld]:[number withheld]–[number withheld]:[number withheld])

| Run | Outcome | Resolution |
|---|---|---|
| [number withheld] | Stop: [number withheld] duplicate firm × date keys ([number withheld] HK firms) | **PI rule:** only annual/half-year reports ([number withheld]/[number withheld]); ties → earlier date |
| [number withheld] | Stop: HK income items not in T003 list | Co-PI mapping (营业额, 除税后溢利, …) |
| [number withheld] | Stop: HK 股东权益 = owners' equity only | Co-PI: `te` = 总权益; all items re-checked against raw files |
| [number withheld] | Stop: HK `adv` missing [number withheld] % | **PI rule:** missing `adv` → [number withheld], flag `adv_missing` |
| [number withheld] | Stop on coverage rule | [number withheld] % stop replaced by coverage reporting |
| [number withheld] | Panel built, criteria [number withheld]–[number withheld] verified by Co-PI | fix: `perp` blank → [number withheld], flag `perp_missing` |
| [number withheld] | Perp fix verified → frozen | – |

## Headline results

| Item | Value |
|---|---|
| Panel | [number withheld] firm-dates ([number withheld] EastMoney + [number withheld] Wind), [number withheld] firms, [number withheld] columns; byte-identical on rerun |
| Rows all / broad / main · firms main / broad | [number withheld] / [number withheld] / [number withheld] · [number withheld] / [number withheld] |
| SOE known (panel, broad) | [number withheld] / [number withheld] = [number withheld] % |
| Dose (main, firms): [number withheld] / [number withheld] / [number withheld] / [number withheld] / NA | [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] |
| Ratio NA: `rl1` / `rl2` / `rl3` | [number withheld] / [number withheld] / [number withheld] |
| `rl3_upper_bound` | all [number withheld] A-share rows (no restricted cash) |
| `adv_missing` | HK EastMoney [number withheld] %, HK Wind [number withheld] %, A Wind [number withheld] % |
| Regression sample (Co-PI QC) | [number withheld] firms / [number withheld] obs |

> [!warning] Unverified
> Co-PI QC after run [number withheld] says `rl2_adj` exists for [number withheld] rows; the worker report gives [number withheld]. Not reconciled in the sources.

## Open points

- [ ] Independent review → PI accept (`agents/pi.sh accept T004`).
- [ ] HK currency still "reported" (RMB conversion = separate card); A-share restricted cash from cninfo; manual SOE coding (`t004_ownership_unresolved.csv`, [number withheld] firms).
- [ ] [number withheld] HK EastMoney firm-dates without 现金及等价物 in `sample_main` (no substitution made); `rl1` formula `[unverified]`; [number withheld] vs [number withheld] HK keys; unexplained `.DS_Store` change (criterion [number withheld] "not fully met").

Siblings: [[T003 HK Raw Data Audit]] · [[T005 Descriptives and Bunching Plots]]

Source: `tasks/T004.md` (Co-PI feedback); `tasks/T004_report.md`; `state/runs.log`; `state/approvals.log`; `state/STATE.md`.
