---
tags: [mtpa, data, todo]
status: open
updated: 2026-10-14
---

# Wind Visit [number withheld] Checklist

Second visit to the [[Wind Terminal]] (PKU Guanghua, [number withheld]rd floor). **≈ [number withheld] minutes left** of the [number withheld]-minute semester quota. Plan stated by Anton on 2026-10-13.

## Before the visit

- [ ] USB stick (USB-A) + student ID; check opening hours of Guanghua [number withheld]rd floor
[firm-specific excerpt withheld in public process copy]
- [ ] Code list of **all sample firms** for the ownership query: `Daten/wind_codes.txt` ([number withheld] current firms: [number withheld] A + [number withheld] HK) + the [number withheld] codes in `Daten/delistete_immobilienfirmen.csv`
- [ ] Field list ready (Wind search terms below)

## At the terminal

[number withheld]. - [ ] 数据浏览器 (Data Browser) → load codes by import/paste, **not** by industry filter
[number withheld]. - [ ] Periods 2016-12-31 to 2022-12-31, only 中报 + 年报; 合并报表; currency CNY, unit 元 (or export currency column)
[number withheld]. - [ ] **Main batch – [number withheld] high-priority firms, balance sheet + income statement, half-years 2016-12-31 … 2022-12-31, export all in one batch**
   - balance: 资产总计, 负债合计, 预收款项 **and** 合同负债, 货币资金, 受限资金/受限制现金, 短期借款, 一年内到期的非流动负债, 长期借款, 应付债券, 所有者权益合计, 少数股东权益, 长期股权投资 / 于合营及联营公司的权益, 永续债 / 其他权益工具, 存货
   - income: 净利润, 少数股东损益, 营业总收入 / 营业额, 对联营企业和合营企业的投资收益
[number withheld]. - [ ] **Ownership type (SOE vs. private) for ALL sample firms** – indicator not found at visit [number withheld] (`gssx`, `qyxz` failed). Look under 基本资料 → 公司资料: 公司属性 / 企业性质 / 实际控制人属性
[number withheld]. - [ ] **Restricted cash 受限货币资金 for A-shares** – if Wind has it, add to the export for all A-share firms; otherwise note → cninfo annual reports
[number withheld]. - [ ] Spot check [number withheld]–[number withheld] firms (e.g. Evergrande 2020-12-31); note empty columns
[number withheld]. - [ ] Optional, only with time left: the [number withheld] low-priority firms; 总市值 (market cap); 省份; 主体评级
[number withheld]. - [ ] Save everything to the stick before the timer runs out

## After the visit

- [ ] Copy exports into `Daten/` (do not overwrite existing files)
- [ ] Read with `pd.read_excel(f, engine="calamine")`; drop last row "数据来源：Wind"
- [ ] Check which of the [number withheld] firms actually came back with data
- [ ] Check whether the PKU library has **CSMAR** access (unverified)
- [ ] Update `PROJEKT_STAND.md` §[number withheld] (minutes used, files) and `AI_USAGE_LOG.md` if AI help was used

## Catch-up list (`output/tables/wind_nachholliste.csv`, [number withheld] firms)

Computed breakdown:

| Priority | A-share | HK – no EastMoney data | HK – reused code | Total |
|---|---|---|---|---|
| High | [number withheld] | [number withheld] | [number withheld] | **[number withheld]** |
| Low | [number withheld] | [number withheld] | [number withheld] | **[number withheld]** |
| **Total** | **[number withheld]** | **[number withheld]** | **[number withheld]** | **[number withheld]** |

The priority rule is not written down in the sources; in the data, all [number withheld] high-priority firms were listed at the policy date (2020-08-20) and none is 房地产服务, while the [number withheld] low-priority firms were delisted before the policy ([number withheld]) or are property-management firms ([number withheld]). By sub-industry, high: [number withheld] 房地产开发, [number withheld] 多样化房地产活动, [number withheld] 房地产经营公司.

### High priority ([number withheld])

| # | Market | Wind code | Name | Sub-industry | Delisted | Reason |
|---|---|---|---|---|---|---|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

### Low priority ([number withheld], optional)

| # | Market | Wind code | Name | Sub-industry | Delisted | Listed at policy | Reason |
|---|---|---|---|---|---|---|---|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

Names shown without the "(退市)" suffix used in the CSV.

> [!idea] Suggestion (not decided)
> Time budget for [number withheld] min, following the visit-[number withheld] checklist timings: ~[number withheld] min setup, ~[number withheld] min main batch, ~[number withheld] min ownership search + export, ~[number withheld] min restricted cash, ~[number withheld] min checks, rest as buffer for optional items. Keep a buffer, since the quota is per semester.

Related: [[Delisted Developers]], [[Data Issues]], [[Variables and Metrics]], [[To-Do]].

---
Source: `output/tables/wind_nachholliste.csv` (counts via `pd.crosstab` on `prioritaet`, `market`, `grund`, `sub`); `Daten/Wind_Export_Checkliste.xlsx` (sheets Ablauf, Felder, Hinweise); `Daten/wind_codes.txt`; `PROJEKT_STAND.md` §[number withheld], §[number withheld] item [number withheld]; project memory note of 2026-10-13 (Wind visit [number withheld] plan).
