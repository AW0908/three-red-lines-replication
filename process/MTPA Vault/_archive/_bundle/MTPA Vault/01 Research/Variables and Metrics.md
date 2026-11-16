---
tags: [mtpa, data, research]
status: in-progress
updated: 2026-10-14
---

# Variables and Metrics

Definitions of the three red-line ratios, the outcome variables of the [[Empirical Design]], and how each maps to the raw fields in the two free sources ([[AKShare EastMoney]]: A-share EastMoney column codes, HK 中文 item names in `STD_ITEM_NAME`) and to the Wind search terms used for the [[Wind Terminal]]. No panel and no ratio has been computed yet; that is planned in [[T004 Firm Panel and Red-Line Metrics]].

> [!info] Source of truth
> Variable definitions are the PI's decision (`PROJEKT_STAND.md` §[number withheld], `state/STATE.md`). This note is a navigation layer. Mapping choices that the sources do not settle are marked as suggestions or open questions; see also [[Decisions and Open Questions]].

## Panel frame

- Unit: firm × half-year. [number withheld] reporting dates, [number withheld] June and [number withheld] December, **2016-12-31 to 2022-12-31** ([number withheld]H2–[number withheld]H2).
- Statements: consolidated (合并报表), per the Wind checklist.
- Income-statement items are **cumulative within the fiscal year** (H1 = Jan–Jun, FY = Jan–Dec), so a stand-alone H2 flow = FY − H1. See [[Data Issues]].
- Pre-policy treatment date: number of lines breached at **2019-12-31 or 2020-06-30** – both named in `PROJEKT_STAND.md` §[number withheld]; not yet decided.

## The three red lines

Thresholds and the colour categories are described in [[Three Red Lines Policy]]. Category = number of lines breached: green [number withheld], yellow [number withheld], orange [number withheld], red [number withheld].

| # | Ratio | Breach if | Definition (PROJEKT_STAND §[number withheld]) |
|---|---|---|---|
| [number withheld] | Liability-to-asset ratio excl. advance receipts | > [number withheld] % | (total liabilities − advance receipts from buyers) / total assets |
| [number withheld] | Net gearing | > [number withheld] % | net financial debt / equity |
| [number withheld] | Cash-to-short-term-debt | < [number withheld] | cash (excluding restricted cash) / short-term debt |

### Field mapping per ratio

| Component | A-share (EastMoney code) | HK (EastMoney `STD_ITEM_NAME`) | Wind search term (checklist) |
|---|---|---|---|
| Total assets | `TOTAL_ASSETS` | 总资产 | 资产总计 |
| Total liabilities | `TOTAL_LIABILITIES` | 总负债 | 负债合计 |
| Advance receipts (old standard) | `ADVANCE_RECEIVABLES` (预收款项) | 预收款项 | 预收款项 / 预收账款 |
| Contract liabilities (IFRS [number withheld] / CAS [number withheld]) | `CONTRACT_LIAB` (合同负债) | 合同负债 | 合同负债 |
| Cash | `MONETARYFUNDS` (货币资金) | 现金及等价物 | 货币资金 |
| Restricted cash | **not in EastMoney A-share data** | 受限制存款及现金 | 受限资金 / 受限制现金 |
| Short-term borrowings | `SHORT_LOAN` (短期借款) | 短期贷款 | 短期借款 |
| Non-current liabilities due < [number withheld] year | `NONCURRENT_LIAB_1YEAR` (一年内到期的非流动负债) | – | 一年内到期的非流动负债 |
| Long-term borrowings | `LONG_LOAN` (长期借款) | 长期贷款 | 长期借款 |
| Bonds | `BOND_PAYABLE` (应付债券) | 应付债券, 可转换票据及债券; senior notes as 应付票据 / 应付票据(非流动) | 应付债券 |
| Total equity | `TOTAL_EQUITY` | 总权益 / 股东权益 | 所有者权益合计 / 股东权益合计 |

**Line [number withheld].** Advance receipts = `ADVANCE_RECEIVABLES` ∪ `CONTRACT_LIAB` (A) or 预收款项 ∪ 合同负债 (HK). The item was renamed under the new revenue standard, so depending on firm and year it sits in one or the other field; `PROJEKT_STAND.md` §[number withheld] says to **sum** both. Wind: always export both.

**Line [number withheld].** Interest-bearing debt per the Wind checklist (lines [number withheld][number withheld] rows): 短期借款 + 一年内到期的非流动负债 + 长期借款 + 应付债券; net of cash (货币资金); divided by total equity.

**Line [number withheld].** Cash excluding restricted cash / short-term debt (短期借款 + 一年内到期的非流动负债 per the checklist). For A-shares the restricted part is missing in EastMoney → Wind or annual reports via cninfo ([[Wind Visit [number withheld] Checklist]]).

> [!idea] Suggestion (not decided) – open mapping choices for the PI
> - **Sum vs. coalesce for line [number withheld]:** if a firm reports both 预收款项 and 合同负债 in the same period (post-standard, 预收款项 can hold non-sale items), summing may double-count less than it seems – or include items that are not buyer prepayments. Check a few firm-years before fixing the rule.
> - **Missing vs. zero:** T001 counts a field as present when non-missing (zeros included); `coverage_report.xlsx` counts only non-zero values. A rule is needed for whether a missing borrowing field means [number withheld] (PROJEKT_STAND §[number withheld]: gaps are "mostly = item not present").
> - **Cash in line [number withheld]:** the sources define "excluding restricted" only for line [number withheld]. Whether net gearing also nets only unrestricted cash is open.
> - **`NONCURRENT_LIAB_1YEAR`** may contain non-debt items (e.g. lease liabilities); whether to use it in full as short-term debt is open.
> - **HK short-term debt:** HK has no separate "current portion" item in the mapped list; 短期贷款 plus the current part of 应付票据 is a candidate. HK cash 现金及等价物 is reported separately from 受限制存款及现金, so it may already be the unrestricted figure – verify on two or three annual reports.
> - **Perpetual bonds in line [number withheld]:** whether 永续债 / 永久资本证券 are treated as debt or equity in the ratio changes the measured leverage and is part of the research question.
> - **Currency:** HK firms report partly in HKD, partly in RMB; ratios are currency-free, but levels (inventory, revenue, size) need harmonisation.

## Outcome variables (dose-response DiD)

| Outcome | Definition | A-share fields | HK fields |
|---|---|---|---|
| Minority equity share | 少数股东权益 / 总权益 (minority equity / total equity) | `MINORITY_EQUITY` / `TOTAL_EQUITY` | 少数股东权益 / 总权益 |
| Minority profit share | 少数股东损益 / 净利润 | `MINORITY_INTEREST` / `NETPROFIT` (income statement) | 少数股东损益 / 除税后溢利 |
| 明股实债 gap (debt disguised as equity) | minority equity share − minority profit share | from the two rows above | from the two rows above |
| JV / associate investments over total assets | 长期股权投资 / 总资产 | `LONG_EQUITY_INVEST` / `TOTAL_ASSETS` | (联营公司权益 + 合营公司权益) / 总资产 |
| Perpetual bonds in equity | 永续债 (A) / 永久资本证券 (HK, perpetual capital securities) | `PERPETUAL_BOND`; `OTHER_EQUITY_TOOL` (其他权益工具) | 永久资本证券 |
| Reported leverage | the three red-line ratios | see above | see above |
| Inventory (projects) | 存货 | `INVENTORY` | 存货, 发展中及待售物业 |
| Land purchases | – | **no source field identified yet** | **no source field identified yet** |
| Revenue | 营业总收入 / 营业额 | `TOTAL_OPERATE_INCOME` | 营业额, 营运收入 |
| JV / associate income (supporting) | 对联营企业和合营企业的投资收益 / 应占合营及联营公司溢利 | `INVEST_INCOME` (matched by the script; pattern also allows `INVEST_JOINT_INCOME`) | 应占联营公司溢利, 应占合营公司溢利 |

Further planned outcome: **adjusted leverage** – JV debt added back pro rata, or a proxy via minority equity / perpetuals, compared with reported leverage (`PROJEKT_STAND.md` §[number withheld] point [number withheld]). No field mapping exists yet.

The 明股实债 indicator follows the press evidence ([number withheld]st Century Business Herald, [number withheld]: a gap of > [number withheld] pp between minority share of equity and minority share of profit) – see [[Press Evidence Off-Balance-Sheet Debt]].

> [!idea] Suggestion (not decided)
> - Minority profit share is unstable when net profit is near zero or negative (frequent for distressed developers [number withheld]–[number withheld]). Options: use annual (FY) values only, use a multi-period sum, or winsorise. PI decision.
> - `OTHER_EQUITY_TOOL` (其他权益工具) can contain perpetual bonds and preferred shares; `PERPETUAL_BOND` is only [number withheld] % covered. Whether to use `PERPETUAL_BOND` where present and `OTHER_EQUITY_TOOL` otherwise is open.
> - Land purchases: candidate sources are the cash-flow statement or annual-report notes; neither has been downloaded. Needs a decision whether to keep this outcome.

## Controls and heterogeneity (Wind checklist, priority B/C)

| Variable | Wind term | Status |
|---|---|---|
| Ownership SOE vs. private | 企业性质 / 公司属性 (also try 实际控制人属性) | **indicator not found yet** – see [[Wind Visit [number withheld] Checklist]] |
| Market capitalisation | 总市值 (at reporting date) | not in AKShare download |
| Province of headquarters | 省份 | optional |
| Issuer credit rating | 主体评级 | optional |
| Guarantees for JVs | 对外担保 (notes) | optional; possibly not in Wind |

SOE vs. private is the central heterogeneity dimension (Shi et al. find effects only for private developers – [[Shi Hao Xie Kim [number withheld]]]).

Coverage of each field: [[Field Coverage]]. Known problems: [[Data Issues]].

---
Source: `PROJEKT_STAND.md` §[number withheld], §[number withheld], §[number withheld]; `Daten/Wind_Export_Checkliste.xlsx` (sheets Felder, Hinweise); `Daten/akshare_coverage_test.py` (field regex dictionaries `A_BAL_FIELDS`, `A_INC_FIELDS`, `HK_BAL_FIELDS`, `HK_INC_FIELDS`); `Daten/akshare_output/coverage_report.xlsx` (sheets Coverage, HK_Bilanzposten); `code/t001_audit_a_shares.py`.
