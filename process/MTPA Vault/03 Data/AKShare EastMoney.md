---
tags: [mtpa, data]
status: done
updated: 2026-10-16
---
Hub: [[Data Overview]]

# AKShare EastMoney

Siblings: [[Wind Terminal]] · [[Delisted Developers]] · [[Field Coverage]] · [[Data Issues]] · [[Firm Panel]]

Free source: Python package AKShare (akshare [number withheld]) pulling statements from EastMoney (东方财富). Covers **currently listed** firms plus some delisted HK firms; **no delisted A-shares**. Downloaded 2026-10-13 with `Daten/akshare_coverage_test.py` and `Daten/fetch_delisted.py` (environment `Daten/.venv`). Primary source in the panel: [number withheld] of [number withheld] rows (T004, delivered [number withheld]).

## Sample

| Market | Firms | Selection | Panel treatment (decided 2026-10-16) |
|---|---|---|---|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
| HK delisted | [number withheld] with data (of [number withheld] requested) | `fetch_delisted.py`, [number withheld]-firm list minus [number withheld] reused codes | in panel; [number withheld] and [number withheld] appear in both HK files (T003) |

## Files (`Daten/akshare_output/`)

| File | Content |
|---|---|
| `firm_list.csv` | [number withheld] rows: `code`, `name`, `board`, `market`, `fetched` (UTF-[number withheld] BOM; read `code` as text) |
| `raw_a_balance.csv`, `raw_a_income.csv` | A-share, **wide**, EastMoney column codes, key `code` + `REPORT_DATE`; all quarters [number withheld]–[number withheld] → filter to the [number withheld] dates |
| `raw_hk_balance.csv`, `raw_hk_income.csv` | HK, **long**: `STD_ITEM_NAME`, `AMOUNT`, `REPORT_DATE`, `STD_REPORT_DATE`, `DATE_TYPE_CODE`, `code` |
| `delisted_hk_balance.csv`, `delisted_hk_income.csv` | delisted HK, same long format |
| `delisted_a_*.csv` | header only (EastMoney has no delisted A-shares) |
| `coverage_report.xlsx` | first coverage check (superseded by T001/T003, see [[Field Coverage]]) |

Item mapping into the panel: [[Research Question]] → Variables and Metrics.

## Download method

- A-shares: own EastMoney request (`emweb.securities.eastmoney.com/PC_HSF1[number withheld]/NewFinanceAnalysis/`, `zcfzbAjaxNew` balance, `lrbAjaxNew` income).
- HK: `ak.stock_financial_hk_report_em(stock, symbol="资产负债表"/"利润表", indicator="报告期")` – all report dates incl. quarterly (`DATE_TYPE_CODE` [number withheld]/[number withheld]; dropped in the panel).
[firm-specific excerpt withheld in public process copy]
- Network: EastMoney reachable only from Anton's Mac (China network, VPN off).

Source: `PROJEKT_STAND.md` §[number withheld], §[number withheld]; `tasks/T003.md`, `tasks/T003_report.md`; `tasks/T004.md`, `tasks/T004_report.md`; `state/STATE.md`; `Daten/akshare_output/firm_list.csv`.
