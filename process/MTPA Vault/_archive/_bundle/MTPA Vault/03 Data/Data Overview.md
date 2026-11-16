---
tags: [mtpa, data]
status: in-progress
updated: 2026-10-14
---

# Data Overview

Goal: a firm × half-year panel of Chinese property developers (A-share + Hong Kong, including firms delisted after the policy), [number withheld] reporting dates 2016-12-31 to 2022-12-31, from which the three red-line ratios and the outcomes in [[Variables and Metrics]] are computed. Status 2026-10-14: raw data partly collected, **panel not built yet**.

> [!info] Source of truth
> `PROJEKT_STAND.md` §[number withheld]–[number withheld] and the task cards in `tasks/`. Raw data live in Anton's folder `Daten/`, which must **not be moved without asking** (`AGENTS.md`). Proposed later layout: copy (not move) raw data to `data/raw/`, scripts to `code/` – only after asking.

## Data flow

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Status per source

| Source | What | Files | Status |
|---|---|---|---|
| EastMoney via AKShare – A-shares | balance sheet + income statement, [number withheld] firms of today's EastMoney board 房地产开发 | `raw_a_balance.csv` ([number withheld] MB), `raw_a_income.csv` | downloaded 2026-10-13; audited in [[T001 A-Share Audit]] |
| EastMoney via AKShare – HK | balance sheet + income statement, [number withheld] firms from a manual list (long format) | `raw_hk_balance.csv`, `raw_hk_income.csv` | downloaded 2026-10-13; audit planned in [[T003 HK Raw Data Audit]] |
| Coverage report | field coverage, firm list, list of all HK balance items | `coverage_report.xlsx` | done – see [[Field Coverage]] |
| Wind – delisted lists | all delisted A-shares ([number withheld]) and HK shares ([number withheld]) | `Daten/A_delistet.xlsx`, `Daten/HK_delistet.xlsx` | exported at Wind visit [number withheld] (≈ [number withheld] min used) |
| Derived delisted developer list | [number withheld] firms ([number withheld] A, [number withheld] HK) | `Daten/delistete_immobilienfirmen.csv` | done – see [[Delisted Developers]] |
| EastMoney via AKShare – delisted | balance/income for delisted developers without reused code | `delisted_hk_balance.csv` ([number withheld] firms with data), `delisted_hk_income.csv`, `delisted_a_*.csv` | run; A-share files empty (header only, per lead/PI note); HK has data |
| Wind – catch-up list | [number withheld] delisted developers still without data ([number withheld] high priority) | `output/tables/wind_nachholliste.csv` | to be downloaded at visit [number withheld] – [[Wind Visit [number withheld] Checklist]] |
| Wind – ownership (SOE/private) | for all sample firms | – | **indicator not found yet** |
| Restricted cash A-shares | 受限货币资金 | – | missing; Wind or cninfo annual reports |
| CSMAR | alternative database | – | PKU library access **unverified** |
| Firm-half-year panel | unified A + HK + delisted, three ratios, pre-policy category | `data/processed/` | **not started** – [[T004 Firm Panel and Red-Line Metrics]] |
| Descriptives, bunching plots | first descriptive table, histograms | `output/tables`, `output/figures` | **not started** – [[T005 Descriptives and Bunching Plots]] |

> [!warning] Not in the staged copy
> The raw EastMoney files (`raw_a_*`, `raw_hk_*`), the Wind exports (`A_delistet.xlsx`, `HK_delistet.xlsx`) and the files `delisted_a_*.csv` / `delisted_hk_income.csv` were not part of the copy used for this vault. Their content is described from `PROJEKT_STAND.md`, `tasks/T001_report.md` and `review/T002.md`, not re-checked here.

## Planned panel steps (PROJEKT_STAND §[number withheld], item [number withheld])

- [ ] Build firm-half-year panel [number withheld]H2–[number withheld]H2 in `code/`, output to `data/processed/`
- [ ] Unify A + HK + delisted firms
- [ ] Drop B-shares and non-developers (PI decision on the developer definition)
- [ ] Harmonise currency (HKD vs RMB)
- [ ] Compute the three red-line ratios; assign pre-policy category
- [ ] First descriptive table and bunching histograms

Related: [[AKShare EastMoney]], [[Wind Terminal]], [[Data Issues]], [[Scripts and Environment]], [[Task Board]], [[To-Do]].

---
Source: `PROJEKT_STAND.md` §[number withheld]–[number withheld], §[number withheld]; `AGENTS.md` (Ordner); `tasks/T001_report.md`; `review/T002.md` (list of changed files incl. `delisted_*.csv`); `output/tables/wind_nachholliste.csv`; `Daten/akshare_output/delisted_hk_balance.csv`; project memory note of 2026-10-13 (Wind visit plan).
