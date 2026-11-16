---
tags: [mtpa, tasks, data]
status: open
updated: 2026-10-14
---

# T003 – HK Raw Data Audit (listed + delisted)

| Field | Value |
|---|---|
| Card | `tasks/T003.md` |
| Status | **PLAN** – drafted by Co-PI 2026-10-14, waiting for PI approval |
| Priority | normal |
| Worker → Reviewer | Codex → Antigravity |
| Write scope | `code/t003_audit_hk.py`, `output/tables/t003_hk_{firms,field_coverage,fiscal_year_ends,items}.csv` |

## Why
HK counterpart of [[T001 A-Share Audit]]. Needed before [[T004 Firm Panel and Red-Line Metrics]]: shows which HK firms and items exist on the [number withheld] target dates, and makes the date-rule problem visible.

## What it does
[number withheld]. Stacks `raw_hk_balance.csv` ([number withheld] listed codes) and `delisted_hk_balance.csv` ([number withheld] delisted codes).
[number withheld]. Matches the [number withheld] target dates twice: on `REPORT_DATE` and on `STD_REPORT_DATE`.
[number withheld]. Firm table, item list, coverage table per item × date rule × source, fiscal-year-end table.
[number withheld]. Flags `[number withheld]` (wrong firm 国恩科技 after code reuse) – flags only, excludes nothing.

## Acceptance criteria (summary)
[number withheld] firm rows expected, [number withheld]-character codes, date counts [number withheld]–[number withheld], `[number withheld]` flagged once, shares in [[number withheld]], only target dates, non-December year ends listed ([number withheld], [number withheld], [number withheld], [number withheld], [number withheld] if present), reproducible run, `Daten/` untouched.

## Open questions for the PI (also in [[Decisions and Open Questions]])
- No currency column in the EastMoney data – how to establish HKD vs RMB?
- Date rule `REPORT_DATE` vs `STD_REPORT_DATE` (the data agent found [number withheld] vs [number withheld] delisted HK firms on target dates depending on the rule).
- [number withheld] 方圆房服集团 reports until [number withheld] despite Wind delisting 2020-05-28 – keep or drop?

## How to start
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Related: [[Data Issues]] · [[AKShare EastMoney]] · [[Field Coverage]] · [[Delisted Developers]]

Source: `tasks/T003.md`; data agent findings 2026-10-14.
