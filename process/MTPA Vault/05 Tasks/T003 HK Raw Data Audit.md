---
tags: [mtpa, task, data]
status: done
updated: 2026-10-16
---

Hub: [[Task Board]]

# T003 HK Raw Data Audit

| Field | Value |
|---|---|
| Card | `tasks/T003.md` – audit of the HK raw data (listed + delisted): sample, report dates, field coverage |
| Status | `DELIVERED` 2026-10-16 15:38 (review **PASS**) |
| Priority | normal |
| Worker → Reviewer | Codex (medium) → Antigravity (gemini-[number withheld]-flash-medium) |
| Timeline ([number withheld]) | approved [number withheld]:[number withheld] · worker [number withheld]:[number withheld], [number withheld]:[number withheld] · review PASS [number withheld]:[number withheld] · accepted [number withheld]:[number withheld] |
| Outputs | `replication/code/t003_audit_hk.py`; `replication/outputs/tables/t003_hk_{firms,field_coverage,fiscal_year_ends,items}.csv` |

HK counterpart of [[T001 A-Share Audit]]; excludes no firm, computes no ratio. Basis for the HK date rule and item mapping in [[T004 Firm Panel and Red-Line Metrics]].

## Key results

| Item | Value |
|---|---|
| HK firms in the balance files | **[number withheld]** ([number withheld] listed only, [number withheld] delisted only, [number withheld] both: `[number withheld]`, `[number withheld]`) |
| Wrong firm flagged | `[number withheld]` = 国恩科技 (code reused), flagged once |
| Coverage denominators (firm-dates with 总资产 on the [number withheld] target dates) | `REPORT_DATE`: listed [number withheld], delisted [number withheld] · `STD_REPORT_DATE`: listed [number withheld], delisted [number withheld] |
| Non-December fiscal year | **[number withheld] firms**: [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld] |
| 发展中物业 | does not exist; closest item `发展中及待售物业` reported (not equated) |
| Delisted HK codes without EastMoney data | [number withheld] ([number withheld] of them exported from Wind on [number withheld]; `[number withheld]`, `[number withheld]`, `[number withheld]` stay out) plus [number withheld] reused codes |
| Reproducibility | rerun byte-identical; `Daten/` unchanged ([number withheld] files) |

Field-level HK coverage → [[Data Overview]].

## History

- Run [number withheld] stopped on missing delisted HK codes – the stop condition was a Co-PI error; card corrected, codes only listed in the report.
- PI decision 2026-10-16 (`state/STATE.md`): HK dates mapped to the nearest [number withheld]./[number withheld]., non-December fiscal years flagged, robustness without them.

## Open points

- [ ] HK reporting currency (separate card; PI decided PBoC mid-rate conversion).
- Review header listed T003's own output files as "outside the write scope" and "no baseline stored" – a script issue (→ [[Agent Team Overview]]), not a finding on the result.

Siblings: [[T001 A-Share Audit]] · [[T004 Firm Panel and Red-Line Metrics]]

Source: `tasks/T003.md`; `tasks/T003_report.md`; `review/T003.md`; `state/runs.log`; `state/approvals.log`; `state/STATE.md`.
