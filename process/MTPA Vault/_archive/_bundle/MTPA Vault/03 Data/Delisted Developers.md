---
tags: [mtpa, data]
status: in-progress
updated: 2026-10-14
---

# Delisted Developers

Why: EastMoney/AKShare only covers firms listed **today**. The developers that ran into distress after the policy (e.g. 泰禾 Tahoe, 蓝光 Blue Light, 阳光城 Yango, 恒大 Evergrande) were delisted. Leaving them out is survivorship bias exactly where the policy bites – see [[Identification Threats]].

## Construction

`Daten/delistete_immobilienfirmen.csv`, filtered from the Wind exports `A_delistet.xlsx` ([number withheld] firms) and `HK_delistet.xlsx` ([number withheld] firms) – see [[Wind Terminal]]:

- Wind industry contains 房地产管理和开发 (real estate management and development)
- delisting date from 2017-01-01
- no B-shares

Columns: `market`, `code` (Wind format), `name`, `sub` (Wind level-[number withheld] industry), `delist_date`, `reason` (A-shares only), `listed_at_policy` (still listed on 2020-08-20), `reused_code` (HK code reassigned after delisting, marked `!`).

## Counts (computed)

**[number withheld] firms: [number withheld] A-share, [number withheld] HK. [number withheld] were still listed on 2020-08-20.**

| Wind sub-industry | A | HK | Total |
|---|---|---|---|
| 房地产开发 (property development) | [number withheld] | [number withheld] | [number withheld] |
| 房地产经营公司 (real estate operating companies) | [number withheld] | [number withheld] | [number withheld] |
| 多样化房地产活动 (diversified real estate activities) | [number withheld] | [number withheld] | [number withheld] |
| 房地产服务 (real estate services = property management) | [number withheld] | [number withheld] | [number withheld] |
| **Total** | **[number withheld]** | **[number withheld]** | **[number withheld]** |

| `listed_at_policy` | A | HK | Total |
|---|---|---|---|
| True | [number withheld] | [number withheld] | [number withheld] |
| False (delisted before 2020-08-20) | [number withheld] | [number withheld] | [number withheld] |

- `reused_code = True`: [number withheld] HK firms ([number withheld] A-share) → not loadable via AKShare, only via Wind.
- A-share delisting reason: [number withheld] × 交易型退市 (trading-based), [number withheld] × 财务型退市 (financial-based).
- Delisting year (A / HK): [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld] · [number withheld] [number withheld]/[number withheld].

> [!idea] Suggestion (not decided)
> `PROJEKT_STAND.md` §[number withheld] says the [number withheld] 房地产服务 (property management) firms should "probably" be excluded from the main analysis. Not yet decided by the PI. The [number withheld] 房地产经营公司 and [number withheld] 多样化房地产活动 firms also need a developer/non-developer decision, like the A-share list ([[Decisions and Open Questions]]).

## What AKShare returned (`fetch_delisted.py`)

`Daten/fetch_delisted.py` skips the [number withheld] reused codes and requests the remaining **[number withheld] A + [number withheld] HK** firms. `PROJEKT_STAND.md` §[number withheld]/§[number withheld] still calls it "not yet run", but its output files exist (listed in `review/T002.md`), so it has been run.

| Output | Result |
|---|---|
| `delisted_a_balance.csv`, `delisted_a_income.csv` | **empty – header only** (EastMoney delivers no delisted A-shares). Not in the staged copy; reported by PI/lead. |
| `delisted_hk_income.csv` | not in the staged copy; not checked |
| `delisted_hk_balance.csv` | **[number withheld] of [number withheld] HK firms** with data; [number withheld] rows; report dates 2000-12-31 to 2026-06-30; long format (`STD_ITEM_NAME`, `AMOUNT`, `REPORT_DATE`, `STD_REPORT_DATE`, `FISCAL_YEAR` …) |

Reconciliation: [number withheld] = [number withheld] (HK with EastMoney data) + [number withheld] ([[Wind Visit [number withheld] Checklist|Wind catch-up list]]: [number withheld] A-share + [number withheld] HK without EastMoney data + [number withheld] HK with reused code).

### The [number withheld] HK firms with data – computed from `delisted_hk_balance.csv`

- By sub-industry: [number withheld] 房地产开发, [number withheld] 房地产经营公司, [number withheld] 多样化房地产活动, [number withheld] 房地产服务. [number withheld] were listed at policy date.
- Filtering on `REPORT_DATE` ∈ the [number withheld] panel dates: **[number withheld] firms, [number withheld] firm-dates** ([number withheld] rows). Firms by number of panel dates: [number withheld] dates → [number withheld] firms; [number withheld] → [number withheld]; [number withheld] → [number withheld]; [number withheld] → [number withheld]; [number withheld] → [number withheld]; [number withheld] → [number withheld]; [number withheld] → [number withheld].
- **[number withheld] firms have no panel date on `REPORT_DATE`**: [number withheld] 易易壹金融, [number withheld] 凯华集团, [number withheld] 华厦置业, [number withheld] 高银地产, [number withheld] 保集健康 – all with fiscal year ending [number withheld] March (`FISCAL_YEAR` = [number withheld][number withheld]). Using `STD_REPORT_DATE` instead: [number withheld] firms, [number withheld] firm-dates (only [number withheld] has none – its data end 2016-09-30).
- Other non-December fiscal years: [number withheld] PALADIN ([number withheld][number withheld]), [number withheld] LHN ([number withheld][number withheld]); mixed values for [number withheld], [number withheld], [number withheld], [number withheld] (fiscal-year change).

| Code | Name | Sub | Delisted | Panel dates (REPORT_DATE) | Last report |
|---|---|---|---|---|---|
| [number withheld] | 中国恒大 | 房地产开发 | 2025-08-25 | [number withheld] | 2023-06-30 |
| [number withheld] | 祥生控股集团 | 房地产开发 | 2024-11-11 | [number withheld] | 2022-12-31 |
| [number withheld] | 上坤地产 | 房地产开发 | 2025-10-27 | [number withheld] | 2023-06-30 |
| [number withheld] | 大唐集团控股 | 房地产开发 | 2024-10-29 | [number withheld] | 2022-06-30 |
| [number withheld] | 德信中国 | 房地产开发 | 2026-01-07 | [number withheld] | 2023-12-31 |
| [number withheld] | 首创置业 | 房地产开发 | 2021-09-30 | [number withheld] | 2021-06-30 |
| [number withheld] | 大发地产 | 房地产经营公司 | 2024-10-29 | [number withheld] | 2022-06-30 |
| [number withheld] | 银城国际控股 | 房地产开发 | 2025-03-31 | [number withheld] | 2022-12-31 |
| [number withheld] | 五矿地产 | 房地产开发 | 2026-03-04 | [number withheld] | 2025-06-30 |
| [number withheld] | 大悦城地产 | 多样化房地产活动 | 2025-11-28 | [number withheld] | 2025-06-30 |

([number withheld] of [number withheld] shown – the developers most relevant to the policy; full per-firm output is reproducible with the method below.)

> [!warning] Anomaly – [number withheld] 方圆房服集团
> Wind delisting date 2020-05-28, but `delisted_hk_balance.csv` has reports up to 2026-06-30 under one `ORG_CODE` with a smooth asset series. Possibly a board transfer (GEM → Main Board) rather than a true delisting – **unverified**. Property-management firm, not listed at policy date.

### Method

Read-only pandas on the staged copies: `delisted_hk_balance.csv` read as text; `code` unique counts; `REPORT_DATE`/`STD_REPORT_DATE` parsed and filtered to the [number withheld] dates 2016-12-31 … 2022-12-31; joined to `delistete_immobilienfirmen.csv` on the [number withheld]-digit HK code. Breakdowns of the [number withheld]-firm list via `pd.crosstab`.

Related: [[Data Issues]], [[Field Coverage]], [[Data Overview]].

---
Source: `PROJEKT_STAND.md` §[number withheld]–[number withheld], §[number withheld]; `Daten/delistete_immobilienfirmen.csv`; `Daten/fetch_delisted.py`; `Daten/akshare_output/delisted_hk_balance.csv`; `output/tables/wind_nachholliste.csv`; `review/T002.md`; project memory note of 2026-10-13.
