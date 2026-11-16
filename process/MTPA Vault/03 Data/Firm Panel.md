---
tags: [mtpa, data, panel]
status: in-progress
updated: 2026-10-16
---
Hub: [[Data Overview]]

# Firm Panel

Siblings: [[Field Coverage]] · [[Data Issues]] · [[Wind Terminal]] · [[Delisted Developers]] · [[AKShare EastMoney]]

> [!success] Delivered [number withheld] [number withheld]:[number withheld]
> Reviewer verdict **PASS** on all criteria; the script set ESCALATE only because macOS `.DS_Store` changed during the review → accepted by Anton via override (all result files unchanged).

## Output

| Item | Value |
|---|---|
| Panel file | `replication/data/processed/panel_firm_halfyear.csv` |
| Script | `replication/code/01_clean.R` (run: `cd replication && Rscript code/01_clean.R`; two runs byte-identical) |
| Side tables | `replication/outputs/tables/t004_panel_counts.csv`, `t004_item_coverage.csv`, `t004_ownership_unresolved.csv`, `t004_variable_dictionary.csv` |
| Unit | firm × reporting date (`firm_id` × `date`), unique keys |
| Dates | [number withheld]: 2016-12-31 … 2022-12-31 |
| Size | **[number withheld] rows, [number withheld] firms, [number withheld] columns** |
| Rows kept | only firm-dates with a financial row; [number withheld] register periods without one are counted, not kept |
| Source split | [number withheld] EastMoney rows, [number withheld] Wind rows (no overlapping firm-dates → no numerical cross-source check) |

## Rows by market × status

| Market | Status | All rows | Broad | Main |
|---|---|---:|---:|---:|
| A | listed | [number withheld] | [number withheld] | [number withheld] |
| A | delisted | [number withheld] | [number withheld] | [number withheld] |
| HK | listed | [number withheld] | [number withheld] | [number withheld] |
| HK | delisted | [number withheld] | [number withheld] | [number withheld] |
| **Total** | | **[number withheld]** | **[number withheld]** | **[number withheld]** |

## Firms and SOE coverage

| Market | Status | Register main / broad | Panel main / broad | `soe` known (panel broad) |
|---|---|---:|---:|---:|
| A | listed | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] / [number withheld] |
| A | delisted | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] / [number withheld] |
| HK | listed | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] / [number withheld] |
| HK | delisted | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] / [number withheld] |
| **Total** | | **[number withheld] / [number withheld]** | **[number withheld] / [number withheld]** | **[number withheld] / [number withheld] = [number withheld] %** |

Register: `soe` known for [number withheld]/[number withheld] = [number withheld] %; [number withheld] register firms listed in `t004_ownership_unresolved.csv` for manual coding.

## Treatment intensity (`dose`, firms)

| Sample | [number withheld] | [number withheld] | [number withheld] | [number withheld] | NA |
|---|---:|---:|---:|---:|---:|
| main | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
| main without `adv_missing` firms | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
| broad | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
| broad without `adv_missing` firms | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |

"Without `adv_missing`" drops firms with at least one affected panel period. Co-PI QC after run [number withheld]: regression sample [number withheld] firms / [number withheld] observations.

## Ratio NA counts (all rows)

| Ratio | NA | Denominator ≤ [number withheld] |
|---|---:|---:|
| `rl1`, `rl1_alt` | [number withheld] | [number withheld] |
| `rl2`, `rl2_adj` | [number withheld] | [number withheld] |
| `rl3` | [number withheld] | [number withheld] |

After the perpetual fix (`perp` = [number withheld] where all perpetual items are missing, [number withheld] rows): `perp` present in [number withheld] rows, `rl2_adj` / `rl2_gap` in [number withheld], `perp_te` in [number withheld].

## Flags

| Flag | Count |
|---|---|
| `rl3_upper_bound` (no restricted cash) | all [number withheld] A-share rows; FALSE in all [number withheld] rows with `rcash` |
| `adv_missing` – A / EastMoney | [number withheld] / [number withheld] ([number withheld] %) |
| `adv_missing` – A / Wind | [number withheld] / [number withheld] ([number withheld] %) |
| `adv_missing` – HK / EastMoney | [number withheld] / [number withheld] ([number withheld] %) |
| `adv_missing` – HK / Wind | [number withheld] / [number withheld] ([number withheld] %) |

## HK cash gaps

[firm-specific excerpt withheld in public process copy]

## Open limitations

- HK amounts in reporting currency (`currency` = "reported"); RMB conversion pending.
- A-share restricted cash missing → `rl3` is an upper bound for all A rows.
- Manual SOE coding outstanding ([number withheld] % known).
- `rl1` formula `[unverified]` against a primary source.
- HK balance keys [number withheld] vs [number withheld] in the Co-PI date-rule check ([number withheld], documented).
- HK cash gaps above; 短期存款 as a cash substitute not decided.
- Review of T004 not done yet; `.DS_Store` change outside scope during the run (cause unknown, irrelevant to data).

Source: `tasks/T004_report.md` (final run); `tasks/T004.md` (steps [number withheld]–[number withheld], Co-PI QC runs [number withheld]–[number withheld]); `state/STATE.md`; `state/runs.log`.
