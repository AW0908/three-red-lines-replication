---
tags: [mtpa, data]
status: done
updated: 2026-10-16
---
Hub: [[Data Overview]]

# Field Coverage

Siblings: [[AKShare EastMoney]] · [[Data Issues]] · [[Firm Panel]]

How complete the raw items are on the [number withheld] panel dates (2016-12-31 … 2022-12-31). Item mapping: [[Research Question]] → Variables and Metrics.

## A-shares – T001 audit (accepted 2026-10-13)

Base: **[number withheld] firm-dates** ([number withheld] firms × [number withheld] + [number withheld] 中新集团 × [number withheld]). Present = non-missing (zeros included).

| Field | Meaning | Share |
|---|---|---|
| `TOTAL_ASSETS`, `TOTAL_LIABILITIES`, `MONETARYFUNDS`, `TOTAL_EQUITY` | core items | [number withheld] % |
| `ADVANCE_RECEIVABLES` / `CONTRACT_LIAB` / either | 预收款项 / 合同负债 | [number withheld] % / [number withheld] % / [number withheld] % |
| `SHORT_LOAN` | 短期借款 | [number withheld] % |
| `NONCURRENT_LIAB_1YEAR` | 一年内到期的非流动负债 | [number withheld] % |
| `LONG_LOAN` | 长期借款 | [number withheld] % |
| `BOND_PAYABLE` | 应付债券 | [number withheld] % |
| `PERPETUAL_BOND` / `OTHER_EQUITY_TOOL` | 永续债 / 其他权益工具 | [number withheld] % / [number withheld] % |
| `MINORITY_EQUITY` | 少数股东权益 | [number withheld] % |
| `LONG_EQUITY_INVEST` | 长期股权投资 | [number withheld] % |
| `INVENTORY` | 存货 | [number withheld] % |

Income (coverage_report): net profit [number withheld] %, minority profit [number withheld] %, revenue [number withheld] %. **Restricted cash: not available for A-shares.**

## HK – T003 audit (DELIVERED 2026-10-16, review PASS)

- **[number withheld] HK codes** in the two EastMoney balance files: [number withheld] listed, [number withheld] delisted, [number withheld] in both ([number withheld], [number withheld]). [number withheld] flagged as wrong firm (国恩科技).
- Coverage computed twice (`REPORT_DATE` / `STD_REPORT_DATE`); base = firm-dates with 总资产: listed [number withheld] / [number withheld], delisted [number withheld] / [number withheld].
- **[number withheld] firms** with non-December fiscal year → `fye_flag` in the panel.
- Item catalogue `t003_hk_items.csv` = basis of the final HK mapping. `发展中物业` does not exist; observed item `发展中及待售物业` (listed: [number withheld] % vs 存货 [number withheld] %, per Co-PI) → HK inventory = sum of both.
- The first `coverage_report.xlsx` under-counted HK perpetuals ([number withheld] %) and bonds (senior notes in 应付票据); the exact-name mapping fixes this (`永久资本证券`; `应付票据`, `应付票据(非流动)` in debt).
- HK income items (Co-PI check, [number withheld] firms, report types [number withheld]/[number withheld]): 营业额 [number withheld], 除税后溢利 [number withheld], 少数股东损益 [number withheld], 应占联营公司溢利 [number withheld], 应占合营公司溢利 [number withheld].
- Per-item shares: `replication/outputs/tables/t003_hk_field_coverage.csv` (not reproduced here).

## Panel – red-line items in `sample_main` (T004, delivered [number withheld])

Present values / financial rows:

| Market / source | `ta`, `tl`, `te` | `cash` | `std` | `ltd` | `adv` (before zero-fill) | `rcash` |
|---|---:|---:|---:|---:|---:|---:|
| A / EastMoney | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld] |
| A / Wind | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld] |
| HK / EastMoney | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] |
| HK / Wind | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] |

Full item × market × source table: `replication/outputs/tables/t004_item_coverage.csv`. HK cash gaps by firm: [[Firm Panel]].

Source: `tasks/T001_report.md`, `output/tables/t001_a_field_coverage.csv` (now under `replication/outputs/tables/`); `tasks/T003_report.md`; `review/T003.md`; `tasks/T003.md`; `tasks/T004.md` (Co-PI feedback); `tasks/T004_report.md`; `PROJEKT_STAND.md` §[number withheld].
