---
tags: [mtpa, research, data]
status: in-progress
updated: 2026-10-16
---
Hub: [[Research Question]]

# Variables and Metrics

Siblings: [[Three Red Lines Policy]] · [[Empirical Design]] · [[Identification Threats]] · Data: [[Data Overview]]

> [!info] Status
> Definitions below were **decided by the PI on 2026-10-16** (`state/STATE.md`) and implemented in `replication/code/01_clean.R` (T004). T004 was **delivered on [number withheld]** (review PASS). Panel results: Firm Panel note under [[Data Overview]].

## [number withheld]. Panel frame

| Element | Decision (2026-10-16) |
|---|---|
[firm-specific excerpt withheld in public process copy]
| Dates | [number withheld] half-year ends 2016-12-31 … 2022-12-31 |
| HK date rule | only annual + half-year reports (`DATE_TYPE_CODE` [number withheld]/[number withheld]); map to nearest [number withheld]./[number withheld].; ties → **earlier** date ([number withheld]. → [number withheld]., [number withheld]. → [number withheld].); `fye_flag` for non-December fiscal years; robustness without them |
| Source priority | EastMoney first; Wind only where EastMoney has no row for that firm-date |
| Treatment intensity | `dose` = `n_breached` on **2019-12-31**; robustness `dose_2[number withheld]h1` on 2020-06-30; constant within firm |
| Post | `post` = [number withheld] for `date` ≥ **2020-12-31** |
[firm-specific excerpt withheld in public process copy]
| Currency | record reporting currency per HK firm; HKD → RMB at PBoC central parity on the reporting date (ratios are currency-free). **Not implemented yet**: HK `currency` = "reported" |

## [number withheld]. Red-line ratios

| Variable | Formula | Robustness | Breach |
|---|---|---|---|
| `rl1` | (`tl` − `adv`) / (`ta` − `adv`) | `rl1_alt` = (`tl` − `adv`) / `ta` (numerator adjusted only) | `b1`: > [number withheld] |
| `rl2` | (`ibd` − `cash`) / `te`; perpetuals as equity (as reported) | `rl2_adj` = (`ibd` + `perp` − `cash`) / (`te` − `perp`); perpetuals as debt | `b2`: > [number withheld] |
| `rl3` | (`cash` − `rcash`) / `std`; if `rcash` missing: `cash` / `std` and `rl3_upper_bound = TRUE` | – | `b3`: < [number withheld] |
| `ibd` | `std` + `ltd` (core) | `ibd_ext` = `ibd` + `lease` + `notes` | – |
| `n_breached` | `b1` + `b2` + `b3` (NA if any ratio NA) | – | – |

> [!warning] Unverified
> The `rl1` formula (advance receipts removed from numerator **and** denominator) is not checked against a primary source; flagged `[unverified]` in the variable dictionary. The wording in `PROJEKT_STAND.md` §[number withheld] ("liabilities excl. advance receipts / total assets") corresponds to `rl1_alt`. See [[Three Red Lines Policy]].

- **Restricted cash, A-shares:** in neither EastMoney nor the Wind exports → total cash as an **upper bound** for `rl3` (all A rows flagged); to be filled from cninfo annual reports, starting with firms near `rl3` = [number withheld].
- **Perpetuals:** reported line [number withheld] = equity, adjusted line [number withheld] = debt; the gap `rl2_gap` is an outcome for cosmetic deleveraging.

## [number withheld]. Missing-value rules

| Rule | Implementation |
|---|---|
| Sums of components | all components missing → NA; otherwise missing components count as [number withheld] (`n_components_present`) |
| Missing advance receipts | `adv` = [number withheld] (makes `rl1` conservatively high), flag `adv_missing`; robustness without these observations (PI, 2026-10-16) |
| Missing perpetuals | `ta` present and all perpetual items missing → `perp` = `perp_mi` = [number withheld], flag `perp_missing` (Co-PI rule after run [number withheld], same logic as `adv`) |
| Denominator ≤ [number withheld] | ratio = NA, counted per ratio |

## [number withheld]. Final item mapping (T004, incl. Co-PI refinements after run [number withheld])

| Var | A – EastMoney | A – Wind | HK – EastMoney | HK – Wind |
|---|---|---|---|---|
| `ta` | `TOTAL_ASSETS` | 资产总计 | 总资产 | 资产总计 |
| `tl` | `TOTAL_LIABILITIES` | 负债合计 | 总负债 | 负债合计 |
| `adv` | `ADVANCE_RECEIVABLES` + `CONTRACT_LIAB` | 预收账款 + 合同负债 | 预收款项 + 合同负债 | 预收款项 + 合同负债 |
| `cash` | `MONETARYFUNDS` | 货币资金 | 现金及等价物 | 现金及现金等价物 |
| `rcash` | – (missing) | – (missing) | 受限制存款及现金 | 受限资金 |
| `std` | `SHORT_LOAN` + `NONCURRENT_LIAB_1YEAR` | 短期借款 + 一年内到期的非流动负债 | 短期贷款 + 应付票据 | 短期借贷及长期借贷当期到期部分 |
| `ltd` | `LONG_LOAN` + `BOND_PAYABLE` | 长期借款 + 应付债券 | 长期贷款 + 应付票据(非流动) + 应付债券 + 可转换票据及债券 + 可转换债券及票据 | 长期借贷 |
| `lease` | `LEASE_LIAB` | – | 融资租赁负债(流动) + 融资租赁负债(非流动) | – |
| `notes` | `NOTE_PAYABLE` | – | none (HK 应付票据 = senior notes, already in debt) | – |
| `perp` | `PERPETUAL_BOND`, else `OTHER_EQUITY_TOOL` | 其他权益工具:永续债, else 其他权益工具 | 永久资本证券 | 永续债_合计 |
| `perp_mi` | – | – | – | 永续债_归属于少数股东 |
| `te` | `TOTAL_EQUITY` | 股东权益合计 | **总权益** (not 股东权益 = owners only) | 股东权益合计 |
| `mi` | `MINORITY_EQUITY` | 少数股东权益 | 少数股东权益 | 少数股东权益 |
| `jv` | `LONG_EQUITY_INVEST` | 长期股权投资 | 联营公司权益 + 合营公司权益 | 对联营公司投资 + 对共同发展公司投资 |
| `inv` | `INVENTORY` | 存货 | 存货 + 发展中及待售物业 | 存货 |
| `rev` | `TOTAL_OPERATE_INCOME` | 营业总收入 | 营业额 | 营业总收入 |
| `ni` | `NETPROFIT` | 净利润 | 除税后溢利 | 除税后利润(净利润) |
| `ni_mi` | `MINORITY_INTEREST` | 少数股东损益 | 少数股东损益 | 少数股东损益 |
| `jv_inc` | `INVEST_JOINT_INCOME` | 对联营企业和合营企业的投资收益 | 应占联营公司溢利 + 应占合营公司溢利 | 权益性投资损益 |

Notes: HK `发展中物业` does not exist; the observed item is `发展中及待售物业` (T003). HK 贷款及垫款 is not used (ambiguous). Wind 股东权益合计 includes minorities. Income items are year-to-date (H1 = Jan–Jun, FY = Jan–Dec). The T004 report lists no further substitutions; all mapped HK names are in the T003 catalogue.

## [number withheld]. Outcomes

| Variable | Definition | Idea |
|---|---|---|
| `mi_share` | `mi` / `te` | financing moved to minority partners |
| `mi_gap` | `mi_share` − `ni_mi` / `ni` (YTD; NA if `ni` ≤ [number withheld]) | 明股实债 indicator (debt disguised as equity) |
| `jv_ta` | `jv` / `ta` | shifting into non-consolidated JVs / associates |
| `perp_te` | `perp` / `te` | debt-like instruments booked as equity |
| `rl2_gap` | `rl2_adj` − `rl2` | cosmetic part of net gearing |
| `inv_ta`, `log_ta` | `inv` / `ta`; log(`ta`) | real adjustment; size |
| `rl1`–`rl3` | reported ratios | reported leverage |

Not available yet: land purchases (no source field); adjusted leverage with JV debt added back pro rata (no JV-debt field; only proxies via `mi`, `perp`).

## [number withheld]. Ownership (`soe`)

| `owner_type_raw` (Wind 实际控制人属性, 2020-06-30) | `soe` |
|---|---|
| 国资委, 地方国资委, 中央国有企业, 地方国有企业, 中央国家机关, 地方政府 | [number withheld] |
| 个人 | [number withheld] |
| 境外, 其他, 集体企业, 大学, empty | NA → `t004_ownership_unresolved.csv`, manual coding by the PI |

Provisional coverage: `soe` known for [number withheld] % of the broad panel sample (details under [[Data Overview]]).

Source: `state/STATE.md` (decisions 2026-10-16); `tasks/T004.md` (steps [number withheld]–[number withheld], Co-PI feedback runs [number withheld]–[number withheld]); `tasks/T004_report.md` (name refinements, flags); `tasks/T003_report.md`; `replication/README.md` §[number withheld], §[number withheld]; `PROJEKT_STAND.md` §[number withheld].
