---
tags: [mtpa, data, code]
status: reference
updated: 2026-10-14
---

# Scripts and Environment

Data scripts and the Python setup. Agent-team scripts (`agents/*.sh`) are in [[Scripts Reference]].

## Scripts

| Script | Purpose | Inputs → outputs | Status |
|---|---|---|---|
| `Daten/akshare_coverage_test.py` | Downloads current developers ([number withheld] A-shares from EastMoney board 房地产开发, [number withheld] HK codes from a manual list) via AKShare/EastMoney; writes raw files and a coverage report | → `Daten/akshare_output/raw_a_*.csv`, `raw_hk_*.csv`, `firm_list.csv`, `coverage_report.xlsx` | run 2026-10-13 (≈ [number withheld]–[number withheld] min) |
| `Daten/fetch_delisted.py` | Loads balance/income of the delisted developers in `delistete_immobilienfirmen.csv`, **skipping reused codes** (`!`); imports `fetch_a` / `fetch_hk` from `akshare_coverage_test.py` | → `Daten/akshare_output/delisted_{a,hk}_{balance,income}.csv` | has been run (output files exist); `PROJEKT_STAND.md` still says "not yet run" |
| `code/t001_audit_a_shares.py` | T001 audit: A-share firm table and field coverage over the [number withheld] dates; input checks with STOP conditions; no file under `Daten/` modified | `firm_list.csv`, `raw_a_balance.csv` → `output/tables/t001_a_firms.csv`, `t001_a_field_coverage.csv` | accepted 2026-10-13 – [[T001 A-Share Audit]] |

Not a script but derived data: `Daten/delistete_immobilienfirmen.csv` (filter of the Wind exports) and `output/tables/wind_nachholliste.csv` ([number withheld] firms for Wind) – no generating script in the project folder.

### Key details of `akshare_coverage_test.py`

- Monkey-patches `requests.Session.request` with a **[number withheld] s default timeout** (AKShare sets none and hangs).
- A-shares: own EastMoney query for only the [number withheld] dates ([number withheld] requests instead of ~[number withheld] per sheet); `em_get` with [number withheld] retries.
- HK: `ak.stock_financial_hk_report_em(..., indicator="报告期")`, returns all report dates.
- `PERIODS`: 2016-12-31 and every [number withheld][number withheld] / [number withheld][number withheld] of [number withheld]–[number withheld] ([number withheld] dates).
- Field search by regex on column names (A) or `STD_ITEM_NAME` (HK) – dictionaries `A_BAL_FIELDS`, `A_INC_FIELDS`, `HK_BAL_FIELDS`, `HK_INC_FIELDS`; mapping in [[Variables and Metrics]].
- Coverage = share of firm × date cells with a non-missing **and non-zero** value (A) or any matched item (HK); denominator firms fetched × [number withheld].

### Run commands

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Environment

| Item | Value |
|---|---|
| Virtual env | `Daten/.venv` – akshare [number withheld], pandas [number withheld], openpyxl; activate with `source Daten/.venv/bin/activate` |
| Network | EastMoney reachable **only from Anton's Mac** (China network, VPN off) |
| pip mirror | `-i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com` (Tsinghua mirror was not reachable) |
| Wind xlsx | needs `python-calamine`: `pd.read_excel(f, engine="calamine")` |
| CSV encoding | UTF-[number withheld] with BOM (`utf-[number withheld]-sig`); read `code` as text |

## Project rules for code (`AGENTS.md`)

- Scripts in `code/`, run from the project folder with **relative paths** and a **fixed seed**.
- `data/raw/` is never modified; `data/processed/` is regenerable; tables/figures to `output/tables`, `output/figures`.
- `Daten/` stays where it is unless Anton agrees to a move (proposal: copy raw files to `data/raw/`, scripts to `code/`).
- No results copied into texts by hand.

> [!idea] Suggestion (not decided)
> Record the origin of `delisted_*.csv` and `wind_nachholliste.csv` (who/what produced them, when) – `review/T002.md` lists them as changed outside any task with origin unchecked. A small script in `code/` that regenerates `wind_nachholliste.csv` from `delistete_immobilienfirmen.csv` and the AKShare results would make it reproducible.

Related: [[Data Overview]], [[AKShare EastMoney]], [[Task Workflow]].

---
Source: `Daten/akshare_coverage_test.py`; `Daten/fetch_delisted.py`; `code/t001_audit_a_shares.py`; `tasks/T001.md`; `tasks/T001_report.md`; `review/T002.md`; `tasks/T002.md`; `PROJEKT_STAND.md` §[number withheld]; `AGENTS.md` (Ordner, Arbeitsregeln).
