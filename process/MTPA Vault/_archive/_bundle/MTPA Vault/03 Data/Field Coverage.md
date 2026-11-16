---
tags: [mtpa, data]
status: done
updated: 2026-10-14
---

# Field Coverage

How complete the raw fields are over the [number withheld] panel dates (2016-12-31 … 2022-12-31). Field meanings: [[Variables and Metrics]].

## A-shares – T001 audit (accepted 2026-10-13)

From `output/tables/t001_a_field_coverage.csv` ([[T001 A-Share Audit]]). Base: **[number withheld] firm-dates** = [number withheld] firms × [number withheld] dates + [number withheld] 中新集团 × [number withheld]. A field counts as present when non-missing (zeros included).

| Field | Meaning | Present | Share |
|---|---|---|---|
| `TOTAL_ASSETS` | total assets | [number withheld] | [number withheld] % |
| `TOTAL_LIABILITIES` | total liabilities | [number withheld] | [number withheld] % |
| `ADVANCE_RECEIVABLES` | 预收款项 advance receipts | [number withheld] | [number withheld] % |
| `CONTRACT_LIAB` | 合同负债 contract liabilities | [number withheld] | [number withheld] % |
| `ADVANCE_OR_CONTRACT` | at least one of the two | [number withheld] | [number withheld] % |
| `MONETARYFUNDS` | 货币资金 cash | [number withheld] | [number withheld] % |
| `SHORT_LOAN` | 短期借款 | [number withheld] | [number withheld] % |
| `NONCURRENT_LIAB_1YEAR` | 一年内到期的非流动负债 | [number withheld] | [number withheld] % |
| `LONG_LOAN` | 长期借款 | [number withheld] | [number withheld] % |
| `BOND_PAYABLE` | 应付债券 | [number withheld] | [number withheld] % |
| `PERPETUAL_BOND` | 永续债 | [number withheld] | [number withheld] % |
| `OTHER_EQUITY_TOOL` | 其他权益工具 | [number withheld] | [number withheld] % |
| `TOTAL_EQUITY` | total equity | [number withheld] | [number withheld] % |
| `MINORITY_EQUITY` | 少数股东权益 | [number withheld] | [number withheld] % |
| `LONG_EQUITY_INVEST` | 长期股权投资 (JV/associates) | [number withheld] | [number withheld] % |
| `INVENTORY` | 存货 | [number withheld] | [number withheld] % |

Firms: [number withheld], of which [number withheld] B-shares; [number withheld] with all [number withheld] dates, [number withheld] with [number withheld] ([number withheld] dates missing mid-sample; cause not established).

**Not available for A-shares:** restricted cash (受限货币资金). `PROJEKT_STAND.md` §[number withheld] adds: `OTHER_EQUITY_TOOL` > [number withheld] for only [number withheld] firms (not re-checked here; raw file not staged).

### A-share income statement (coverage_report.xlsx)

Net profit [number withheld] %, parent net profit [number withheld] %, minority profit `MINORITY_INTEREST` [number withheld] %, revenue `TOTAL_OPERATE_INCOME` [number withheld] %, investment income `INVEST_INCOME` [number withheld] %.

> [!info] Why `coverage_report.xlsx` differs slightly from T001
> The coverage report divides by [number withheld] × [number withheld] = [number withheld] (so total assets show [number withheld] %, not [number withheld] %) and counts only **non-zero** values; T001 uses the [number withheld] actual rows and counts non-missing values. Example: `ADVANCE_RECEIVABLES` [number withheld] % vs [number withheld] %. For perpetuals the report picks the better-filled of `PERPETUAL_BOND`/`OTHER_EQUITY_TOOL` ([number withheld] %).

## HK – current developers (coverage_report.xlsx)

Base: [number withheld] HK firms × [number withheld] dates (this includes the wrong firm under [number withheld] – see [[Data Issues]]). A firm-date counts if any matched item has a value.

| Field | Matched HK items | Share |
|---|---|---|
| Total assets / liabilities / equity | 总资产 / 总负债 / 股东权益, 总权益 | [number withheld] % |
| Advance receipts | 预收款项 | [number withheld] % |
| Contract liabilities | 合同负债 | [number withheld] % |
| Cash | 现金及等价物 | [number withheld] % |
| Restricted cash | 受限制存款及现金 | [number withheld] % |
| Short-term loans | 短期贷款 | [number withheld] % |
| Long-term loans | 长期贷款 | [number withheld] % |
| Bonds (regex 债券) | 应付债券, 可转换票据及债券 | [number withheld] % |
| Perpetuals (regex 永续/永久资本证券) | – | [number withheld] % in the report |
| Minority equity | 少数股东权益 | [number withheld] % |
| JV / associates | 联营公司权益, 合营公司权益 | [number withheld] % |
| Inventory | 存货, 发展中及待售物业 | [number withheld] % |
| Net profit / minority profit / revenue (income statement) | 除税后溢利 / 少数股东损益 / 营业额, 营运收入 | [number withheld] % |
| JV income | 应占联营公司溢利, 应占合营公司溢利 | [number withheld] % |

`PROJEKT_STAND.md` §[number withheld] summary: core items ≈ [number withheld] %; 合同负债 [number withheld] %, 预收款项 [number withheld] % (IFRS [number withheld] renaming → combine both); 受限制存款及现金 [number withheld] %; 联营/合营公司权益 [number withheld] %; senior notes reported as 应付票据 / 应付票据(非流动); perpetuals as **永久资本证券** ([number withheld] firms).

> [!warning] Discrepancy
> The coverage report shows [number withheld] % for HK perpetuals although 永久资本证券 is in its own list of HK balance items, and `PROJEKT_STAND.md` reports it for [number withheld] firms. The bond row ([number withheld] %) also misses senior notes booked as 应付票据. Both coverage figures understate availability; recompute in [[T003 HK Raw Data Audit]].

## HK – delisted developers (computed for this vault)

From `delisted_hk_balance.csv`: [number withheld] firms with at least one panel date on `REPORT_DATE`, **[number withheld] firm-dates**. Share of those firm-dates with the item (and number of firms with it at least once):

| Item | Share of firm-dates | Firms (of [number withheld]) |
|---|---|---|
| 总资产, 总负债, 总权益 | [number withheld] % | [number withheld] |
| 预收款项 / 预收账款(非流动) | [number withheld] % | [number withheld] |
| 合同负债 | [number withheld] % | [number withheld] |
| 预收 ∪ 合同负债 | [number withheld] % | [number withheld] |
| 现金及等价物 | [number withheld] % | [number withheld] |
| 受限制存款及现金 | [number withheld] % | [number withheld] |
| 短期贷款 | [number withheld] % | [number withheld] |
| 长期贷款 | [number withheld] % | [number withheld] |
| 应付票据 (incl. non-current) | [number withheld] % | [number withheld] |
| 应付债券 / 可转换… (regex 债券) | [number withheld] % | [number withheld] |
| 永久资本证券 | [number withheld] % | [number withheld] |
| 少数股东权益 | [number withheld] % | [number withheld] |
| 联营公司权益 / 合营公司权益 | [number withheld] % | [number withheld] |
| 存货 / 发展中及待售物业 | [number withheld] % | [number withheld] |

Method: pandas, rows with non-missing `AMOUNT` and `REPORT_DATE` in the [number withheld] dates; regex match on `STD_ITEM_NAME`; distinct (code, date) pairs. The set mixes developers with operating and property-management firms (see [[Delisted Developers]]), which lowers the shares for 预收/合同负债 and inventory.

Related: [[AKShare EastMoney]], [[Data Overview]].

---
Source: `output/tables/t001_a_field_coverage.csv`; `output/tables/t001_a_firms.csv`; `tasks/T001_report.md`; `Daten/akshare_output/coverage_report.xlsx` (sheets Coverage, HK_Bilanzposten); `Daten/akshare_coverage_test.py` (`coverage_wide`, `coverage_long`); `Daten/akshare_output/delisted_hk_balance.csv`; `PROJEKT_STAND.md` §[number withheld], §[number withheld].
