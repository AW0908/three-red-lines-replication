---
tags: [mtpa, data]
status: in-progress
updated: 2026-10-14
---

# Wind Terminal

Commercial terminal (万得 Wind) at **PKU Guanghua School of Management, [number withheld]rd floor**. Used to fill what the free [[AKShare EastMoney]] source cannot deliver: delisted developers, reused HK codes, ownership type, restricted cash.

## Access

| Item | Value |
|---|---|
| Quota | [number withheld] minutes per semester with student ID |
| Used so far | ≈ [number withheld] min (visit [number withheld]) |
| Remaining | ≈ [number withheld] min |
| Export | xlsx to USB stick (USB-A), then copied into `Daten/` |
| Backups | Bloomberg via an acquaintance at Guanghua; notes from annual reports via HKEXnews / cninfo |

> [!warning] Unverified
> Whether the PKU library offers **CSMAR** access has not been checked.

## Visit [number withheld] – exports

| File | Wind path | Rows | Columns |
|---|---|---|---|
| `Daten/A_delistet.xlsx` | 内地股票 → 市场类 → 上市状态 → 已摘牌股票 | [number withheld] firms | 证券代码, 证券简称, 所属Wind行业名称([number withheld]) [全部明细], 摘牌日期, 终止上市原因 |
| `Daten/HK_delistet.xlsx` | 香港股票 → 港股市场类 → 已摘牌港股 | [number withheld] firms | same columns; 终止上市原因 empty |

These two files were filtered to the [number withheld] developers in [[Delisted Developers]]. (Not in the staged copy used for this vault; row counts from `PROJEKT_STAND.md`.)

## Reading Wind exports

> [!todo] Always
> - Wind xlsx breaks `openpyxl` (stylesheet error). Read with `pd.read_excel(f, engine="calamine")` (`pip install python-calamine`).
> - First row = header; **last row = "数据来源：Wind"** → drop it.
[firm-specific excerpt withheld in public process copy]

## Export settings (checklist, sheet Ablauf)

[number withheld]. Open 数据浏览器 (Data Browser); load codes by import/paste – do **not** filter by industry (HK firms may drop out).
[number withheld]. Report periods 2016-12-31 to 2022-12-31, only 中报 (interim) + 年报 (annual).
[number withheld]. Statement: 合并报表 (consolidated), never 母公司 (parent only).
[number withheld]. Currency CNY, unit 元 – or export the currency column (HK firms report in RMB or HKD).
[number withheld]. Always export **both** 预收款项 and 合同负债.
[number withheld]. Spot check [number withheld]–[number withheld] firms (e.g. Evergrande 2020-12-31) against known values; note empty columns.
[number withheld]. Watch the timer; priority C only with time left.

Wind field names are search terms; the exact label in the terminal may differ slightly. The full field list with Wind terms is in [[Variables and Metrics]].

## Open searches

- **Ownership type (SOE vs. private):** searches for `gssx` / `qyxz` found nothing. Look in the indicator tree under 基本资料 → 公司资料: 公司属性 / 企业性质 / 实际控制人属性.
- **Restricted cash 受限货币资金 for A-shares:** check whether Wind has it; otherwise annual reports via cninfo.

Plan for the next visit: [[Wind Visit [number withheld] Checklist]]. Overview: [[Data Overview]].

---
Source: `PROJEKT_STAND.md` §[number withheld], §[number withheld] item [number withheld]; `Daten/Wind_Export_Checkliste.xlsx` (sheets Ablauf, Hinweise); `Daten/wind_codes.txt`; project memory note of 2026-10-13.
