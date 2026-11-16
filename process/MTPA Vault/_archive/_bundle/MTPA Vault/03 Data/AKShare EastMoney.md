---
tags: [mtpa, data]
status: done
updated: 2026-10-14
---

# AKShare EastMoney

Free source: the Python package AKShare (akshare [number withheld]) pulling financial statements from EastMoney (东方财富). Covers **currently listed** firms only. Run on 2026-10-13 with `Daten/akshare_coverage_test.py` (see [[Scripts and Environment]]).

## Sample

| Market | Firms | How selected |
|---|---|---|
| A-share | [number withheld] | Today's members of the EastMoney industry board 房地产开发 (property development); includes [number withheld] B-shares |
| HK | [number withheld] | Manual list of mainland developers in the script (`HK_FIRMS`, [number withheld] codes) plus [number withheld] Jiayuan in `firm_list.csv` |

All [number withheld] firms have `fetched = True` in `firm_list.csv`.

> [!warning] [number withheld] (Jiayuan) is the wrong firm
[firm-specific excerpt withheld in public process copy]

## Output files (`Daten/akshare_output/`)

| File | Content |
|---|---|
| `firm_list.csv` | [number withheld] rows: `code`, `name`, `board`, `market`, `fetched` (UTF-[number withheld] with BOM; read `code` as text) |
| `raw_a_balance.csv` ([number withheld] MB) | A-share balance sheets, **wide** format, EastMoney column codes, key `code` + `REPORT_DATE`. Contains **all quarters [number withheld]–[number withheld] ([number withheld] rows)**, not only the [number withheld] dates → every script must filter |
| `raw_a_income.csv` | A-share income statements (`NETPROFIT`, `PARENT_NETPROFIT`, `MINORITY_INTEREST`, `TOTAL_OPERATE_INCOME`, `INVEST_INCOME` …) |
| `raw_hk_balance.csv` | HK balance sheets, **long** format: `STD_ITEM_NAME` (Chinese), `AMOUNT`, `REPORT_DATE`, `code` |
| `raw_hk_income.csv` | HK income statements, long format |
| `coverage_report.xlsx` | sheets Coverage (share of firm-half-years with a value), Firmen (firm list), HK_Bilanzposten ([number withheld] distinct HK balance items) |
| `delisted_hk_balance.csv`, `delisted_hk_income.csv`, `delisted_a_balance.csv`, `delisted_a_income.csv` | delisted developers via `Daten/fetch_delisted.py` – see [[Delisted Developers]] |

Key A-share columns: `TOTAL_ASSETS`, `TOTAL_LIABILITIES`, `ADVANCE_RECEIVABLES`, `CONTRACT_LIAB`, `MONETARYFUNDS`, `SHORT_LOAN`, `NONCURRENT_LIAB_1YEAR`, `LONG_LOAN`, `BOND_PAYABLE`, `PERPETUAL_BOND`, `OTHER_EQUITY_TOOL`, `TOTAL_EQUITY`, `MINORITY_EQUITY`, `LONG_EQUITY_INVEST`, `INVENTORY`. Mapping to the ratios: [[Variables and Metrics]].

## How the download works

- A-shares: own EastMoney request (`emweb.securities.eastmoney.com/PC_HSF1[number withheld]/NewFinanceAnalysis/`, endpoints `zcfzbAjaxNew` balance, `lrbAjaxNew` income) asking only for the [number withheld] dates in batches of five; company type via AKShare's `_stock_balance_sheet_by_report_ctype_em`.
- HK: `ak.stock_financial_hk_report_em(stock, symbol="资产负债表"/"利润表", indicator="报告期")` – returns all report dates.
- Global HTTP timeout of [number withheld] s (AKShare sets none and hangs), [number withheld] retries, [number withheld] s pause between firms.
[firm-specific excerpt withheld in public process copy]

## Coverage in short

A-shares near [number withheld] % for core items, minority equity [number withheld] %, JV investments [number withheld] %, `PERPETUAL_BOND` [number withheld] %, restricted cash missing. HK core items ≈ [number withheld] %, 合同负债 [number withheld] %, 预收款项 [number withheld] %, 受限制存款及现金 [number withheld] %. Details: [[Field Coverage]].

## Limits

- **Survivorship bias:** only today's listed firms – distressed developers that were delisted (e.g. Tahoe 泰禾, Blue Light 蓝光, Yango 阳光城) are missing. Covered via [[Wind Terminal]] and [[Delisted Developers]].
- EastMoney returns **no data for delisted A-shares**.
- Network: EastMoney reachable only from Anton's Mac (China network, VPN off).

Issues list: [[Data Issues]]. Overview: [[Data Overview]].

---
Source: `PROJEKT_STAND.md` §[number withheld], §[number withheld], §[number withheld]; `Daten/akshare_coverage_test.py`; `Daten/akshare_output/firm_list.csv`; `Daten/akshare_output/coverage_report.xlsx`; `tasks/T001_report.md`; project memory note of 2026-10-13.
