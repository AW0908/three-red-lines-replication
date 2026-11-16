---
tags: [mtpa, data]
status: in-progress
updated: 2026-10-16
---
Hub: [[Data Overview]]

# Wind Terminal

Siblings: [[AKShare EastMoney]] · [[Delisted Developers]] · [[Data Issues]] · [[Firm Panel]]

Commercial terminal (万得 Wind) at **PKU Guanghua School of Management, [number withheld]rd floor**. Fills what the free EastMoney source cannot deliver: delisted developers, reused HK codes, ownership type.

## Access

| Item | Value |
|---|---|
| Quota | [number withheld] minutes per semester with student ID |
| Used | ≈ [number withheld] min at visit [number withheld]; after visit [number withheld] (2026-10-16) the quota is **mostly used** (exact minutes not recorded) |
| Export | xlsx to USB stick, then into `Daten/` |
| Backups | Bloomberg via an acquaintance at Guanghua; annual reports via HKEXnews / cninfo |

> [!warning] Unverified
> Whether the PKU library offers **CSMAR** access has not been checked.

## Visit [number withheld] – delisting lists

| File | Wind path | Rows |
|---|---|---|
| `Daten/A_delistet.xlsx` | 内地股票 → 市场类 → 上市状态 → 已摘牌股票 | [number withheld] firms |
| `Daten/HK_delistet.xlsx` | 香港股票 → 港股市场类 → 已摘牌港股 | [number withheld] firms |

Filtered to the [number withheld] developers in [[Delisted Developers]].

## Visit [number withheld] – 2026-10-16 (`Daten/wind_2[number withheld][number withheld][number withheld]/`)

Plan: `protocols/wind_besuch_2026-10-16/CHECKLISTE.md` (blocks [number withheld]–[number withheld] must, [number withheld] should, [number withheld] optional). Exports: half-year and annual reports 2016-06-30 … 2022-12-31 ([number withheld] dates), consolidated, unit 元.

| File | Content |
|---|---|
| `wind_A_delistet_v2.xlsx` | [number withheld] delisted A-shares, [number withheld] balance/income fields × [number withheld] dates, RMB; 实际控制人名称/属性 (2020-06-30). Replaces `wind_A_delistet.xlsx` |
| `wind_HK_delistet_v2.xlsx` | [number withheld] delisted HK firms (incl. [number withheld] codes with `!`), [number withheld] fields × [number withheld] dates, **原始币种** (reporting currency); 实际控制人属性. Replaces `wind_HK_delistet.xlsx` |
| `wind_A_gelistet_eigentum.xlsx` | [number withheld] A-shares, Wind 房地产开发 (today's members): 实际控制人名称/属性, 2020-06-30 |
| `Sicherung_A_1.xlsx` | [number withheld] A-shares, Wind 房地产经营公司 + 多元化房地产业务: same fields |
| `sicherung_HK_3 / _1 / _2.xlsx` | HK firms of Wind 房地产开发 ([number withheld]) / 多元化房地产业务 ([number withheld]) / 房地产经营公司 ([number withheld]): same fields (assignment as used in T004) |

Outcome per checklist block: [number withheld] (delisted A) done · [number withheld] (delisted HK) done · [number withheld] (ownership) done for all A-share developers and most HK firms · [number withheld] (restricted cash A) **not obtained** · [number withheld] ([number withheld] low-priority firms) **not done**.

## Still missing

| Gap | Handling |
|---|---|
| [number withheld] low-priority firms ([number withheld] A delisted before policy, [number withheld], [number withheld]![number withheld], [number withheld], [number withheld]) | excluded from the panel |
| HK reporting currency (exports in 原始币种) | open; decided conversion: PBoC central parity on the reporting date |
| HK ownership often "境外" (offshore holding) or empty – says nothing about SOE/private | manual coding (PI) via `t004_ownership_unresolved.csv` |
| Restricted cash 受限货币资金 for A-shares | open; cninfo annual reports, firms near `rl3` = [number withheld] first |

## Reading Wind exports

> [!todo] Always
> - Python: `openpyxl` fails on the stylesheet → `pd.read_excel(f, engine="calamine")`. R: `readxl::read_excel` works (T004).
> - First row = header (multi-line string per column: item, 年度类型, 报告期 date, 币种 → parse date and currency from it); **last row "数据来源：Wind"** → drop; drop blank rows.
[firm-specific excerpt withheld in public process copy]
> - Empty cells after delisting, and for HK firms without a half-year report, are expected.

Export settings used: Data Browser (数据浏览器), codes by paste/import (not by industry filter), 中报 + 年报 only, 合并报表, both 预收款项 and 合同负债, A-shares and HK queried separately.

Source: `Daten/wind_2026-10-16/README.md`; `protocols/wind_besuch_2026-10-16/CHECKLISTE.md`; `PROJEKT_STAND.md` §[number withheld], §[number withheld] (Wind-Besuch [number withheld]); `state/STATE.md`; `tasks/T004.md` (inputs, step [number withheld]); `Daten/Wind_Export_Checkliste.xlsx`.
