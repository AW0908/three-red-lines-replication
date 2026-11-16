---
tags: [mtpa, data]
status: open
updated: 2026-10-14
---

# Data Issues

Every known data problem as of 2026-10-14, with status and the task that handles it. "Handled" means the issue is dealt with in code or a list, not that the panel is clean. T003–T005 are the planned cards on the [[Task Board]]; only T001 and T002 exist in `tasks/` so far.

> [!info] Source of truth
> `PROJEKT_STAND.md` §[number withheld] and the task cards. Items marked "found in this vault" come from read-only checks on the staged files.

## Sample and coverage

| # | Issue | Status | Handled by |
|---|---|---|---|
| [number withheld] | **Survivorship bias:** EastMoney board = only today's listed firms; distressed developers missing | partly handled: [number withheld] delisted developers identified; [number withheld] HK delisted firms loaded via AKShare; [number withheld] still missing | [[Delisted Developers]], [[Wind Visit [number withheld] Checklist]] |
| [number withheld] | **EastMoney delivers no delisted A-shares** (`delisted_a_*.csv` header only) – all [number withheld] delisted A-share developers missing | open | Wind visit [number withheld] |
| [number withheld] | **Reused HK codes** (`!` in Wind): [number withheld] firms not loadable via AKShare | open | Wind visit [number withheld] ([number withheld] high, [number withheld] low priority) |
| [number withheld] | [number withheld] HK delisted firms without EastMoney data ("keine Daten mehr") | open | Wind visit [number withheld] ([number withheld] high, [number withheld] low priority) |
[firm-specific excerpt withheld in public process copy]
| [number withheld] | **B-share duplicates** in the A-share list ([number withheld] firms, codes [number withheld]…/[number withheld]…, e.g. 深物业A/深物业B, 市北B股, 金桥Ｂ股) | flagged in T001 (`b_share`); treatment = PI decision | [[T001 A-Share Audit]] → [[T004 Firm Panel and Red-Line Metrics]] |
| [number withheld] | **Non-developers** in the A-share board (e.g. 卧龙新能) and in the delisted list (房地产服务 property management, operating companies) | open – PI decision on developer definition | [[Decisions and Open Questions]] → T004 |
| [number withheld] | [number withheld] 中新集团 has [number withheld] of [number withheld] dates; cause not established (reviewer's IPO explanation is unsupported and was not adopted) | open, documented | [[T001 A-Share Audit]] |
| [number withheld] | Shorter interim coverage for some HK IPOs after [number withheld] (德信, 美的置业, 金辉) | open | T003 |
| [number withheld] | **Restricted cash missing for A-shares** → line [number withheld] cannot follow the policy definition | open | Wind visit [number withheld], else cninfo annual reports |
| [number withheld] | **Ownership type (SOE/private)** missing for all firms; Wind indicator not found | open | Wind visit [number withheld] |
| [number withheld] | Land purchases: no source field identified | open | [[Variables and Metrics]] |

## Raw-data structure

| # | Issue | Status | Handled by |
|---|---|---|---|
| [number withheld] | `raw_a_balance.csv` holds **all quarters [number withheld]–[number withheld] ([number withheld] rows)**, not only the [number withheld] dates (contrary to the original description) | handled in T001 by explicit filter; every later script must filter too | T001, T004 |
| [number withheld] | Advance receipts split between `ADVANCE_RECEIVABLES` (预收款项) and `CONTRACT_LIAB` (合同负债) by firm/year; HK same with 预收款项 / 合同负债 (IFRS [number withheld]) | rule set in PROJEKT_STAND (sum for line [number withheld]); exact sum/coalesce rule open | T004; see [[Variables and Metrics]] |
| [number withheld] | HK statements in **long format** (`STD_ITEM_NAME`), items renamed across years | open | T003 |
| [number withheld] | HK firms report partly in **HKD**, partly in RMB → currency check | open | T003 / T004 |
| [number withheld] | Half-year **income statements cumulative** (H1 = Jan–Jun, FY = Jan–Dec) | open | T004 |
| [number withheld] | `code` must be read as **text** (leading zeros); `coverage_report.xlsx` already lost them (e.g. [number withheld] for [number withheld]) | handled in T001; keep for all scripts | T001, T004 |
| [number withheld] | Wind xlsx breaks `openpyxl` → `engine="calamine"`; last row "数据来源：Wind" | known, rule documented | [[Wind Terminal]] |
| [number withheld] | Coverage report under-counts HK perpetuals ([number withheld] % vs 永久资本证券 at [number withheld] firms per PROJEKT_STAND) and bonds (senior notes in 应付票据) | open | T003 |

## Found in this vault (2026-10-14, read-only checks)

| # | Issue | Status | Handled by |
|---|---|---|---|
| [number withheld] | **Non-December fiscal years** in `delisted_hk_balance.csv`: [number withheld] firms ([number withheld], [number withheld], [number withheld], [number withheld], [number withheld], all FY end [number withheld] March) have no panel date on `REPORT_DATE`, while `STD_REPORT_DATE` maps them to standard dates; also [number withheld][number withheld] ([number withheld]) and [number withheld][number withheld] ([number withheld]) year ends and fiscal-year changes ([number withheld], [number withheld], [number withheld], [number withheld]). Which date field defines the half-year is undecided | open | T003 / T004 |
| [number withheld] | [number withheld] 方圆房服集团: Wind delisting 2020-05-28 but EastMoney reports to 2026-06-30 – possibly a board transfer, **unverified** | open | T003 |
| [number withheld] | `PROJEKT_STAND.md` §[number withheld]/§[number withheld] says `fetch_delisted.py` is "not yet run", but its outputs exist (`review/T002.md`); origin of `delisted_*.csv` and `wind_nachholliste.csv` not recorded in a task card | open – update PROJEKT_STAND, log origin | Co-PI / PI |
| [number withheld] | Raw row count: T001 report says [number withheld] rows, the T001 review says [number withheld] | open, minor | T001 note |

> [!idea] Suggestion (not decided)
> Issues [number withheld]–[number withheld] could be added to `PROJEKT_STAND.md` §[number withheld] and to the T003 card so they are not lost. Decision on adding them lies with the PI.

Related: [[Field Coverage]], [[Data Overview]], [[AKShare EastMoney]].

---
Source: `PROJEKT_STAND.md` §[number withheld]–[number withheld], §[number withheld], §[number withheld]; `tasks/T001.md`; `tasks/T001_report.md`; `review/T001.md`; `review/T002.md`; `tasks/T002.md` (Rückmeldung on delisted files); `AI_USAGE_LOG.md` (T001 row); `Daten/akshare_output/coverage_report.xlsx`; `Daten/akshare_output/delisted_hk_balance.csv`; `output/tables/wind_nachholliste.csv`; project memory note of 2026-10-13.
