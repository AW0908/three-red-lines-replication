---
tags: [mtpa, data]
status: in-progress
updated: 2026-10-16
---
Hub: [[Data Overview]]

# Data Issues

Siblings: [[Field Coverage]] · [[Firm Panel]] · [[AKShare EastMoney]] · [[Wind Terminal]] · [[Delisted Developers]]

Status 2026-10-16. "Handled" = dealt with in a decision or in `01_clean.R` (T004, delivered [number withheld]). Decisions: `state/STATE.md`.

## Sample

| # | Issue | Status | How handled |
|---|---|---|---|
| [number withheld] | Survivorship: EastMoney board = today's firms only | handled | [number withheld] delisted developers; data from EastMoney ([number withheld] HK) + Wind visit [number withheld] ([number withheld] A, [number withheld] HK) |
| [number withheld] | No delisted A-shares in EastMoney | handled | Wind visit [number withheld]: [number withheld] A-shares |
| [number withheld] | Reused HK codes (`!`) | handled | [number withheld] high-priority via Wind; [number withheld]![number withheld] (low priority) not exported |
| [number withheld] | [number withheld] HK delisted firms without EastMoney data | handled | [number withheld] via Wind; [number withheld], [number withheld], [number withheld] out (low priority / property services) |
[firm-specific excerpt withheld in public process copy]
| [number withheld] | B-share duplicates ([number withheld] firms) | handled (PI [number withheld]) | duplicates dropped, A line kept |
[firm-specific excerpt withheld in public process copy]
| [number withheld] | [number withheld] 中新集团 has [number withheld] of [number withheld] dates | open, documented | cause not established |
| [number withheld] | Short HK interim histories after IPO (德信, 美的置业, 金辉) | handled | unbalanced panel; only firm-dates with a financial row ([number withheld] register periods counted, not kept) |
| [number withheld] | [number withheld] low-priority firms not exported | accepted | excluded from panel |

## Items and definitions

| # | Issue | Status | How handled |
|---|---|---|---|
| [number withheld] | Restricted cash missing for A-shares | **open** | total cash as upper bound, `rl3_upper_bound` (PI [number withheld]); fill from cninfo, firms near `rl3` = [number withheld] first |
| [number withheld] | Ownership (SOE/private) | **partly** | Wind 实际控制人属性; `soe` known [number withheld] % of broad sample; HK "境外"/empty → manual coding (PI) |
| [number withheld] | Advance receipts split 预收款项 / 合同负债 | handled (PI [number withheld]) | summed; missing → [number withheld] + `adv_missing` (HK EastMoney [number withheld] %, HK Wind [number withheld] %); robustness without |
| [number withheld] | Perpetual items blank when a firm has none | handled (Co-PI) | `perp` = [number withheld] + `perp_missing` ([number withheld] rows) |
| [number withheld] | HK 股东权益 = owners' equity only | handled | `te` = 总权益 (balance identity holds) |
| [number withheld] | HK long format, renamed items | handled | T003 item catalogue; final mapping checked by Co-PI |
| [number withheld] | Coverage report under-counts HK perpetuals and bonds | handled | exact names: 永久资本证券; 应付票据 (senior notes) in debt |
| [number withheld] | HK cash missing: [number withheld] EastMoney firm-dates ([number withheld] firms) + [number withheld] Wind in main sample | **open** | 短期存款 present but not substituted; PI to decide |
| [number withheld] | Land purchases: no source field | **open** | – |
| [number withheld] | Income statements cumulative (YTD) | partly | outcomes use YTD values; stand-alone H2 flows not computed |

## Dates, currency, raw structure

| # | Issue | Status | How handled |
|---|---|---|---|
| [number withheld] | HK non-December fiscal years; quarterly reports causing [number withheld] duplicate keys ([number withheld] firms) | handled (PI [number withheld]) | only annual + half-year reports ([number withheld]/[number withheld]); nearest [number withheld]./[number withheld].; ties → earlier date; `fye_flag` ([number withheld] firms), robustness without |
| [number withheld] | HK currency (HKD vs RMB; Wind HK in 原始币种) | **open** | decided: PBoC central parity on the reporting date; not implemented, `currency` = "reported"; ratios unaffected |
| [number withheld] | `raw_a_balance.csv` holds all quarters [number withheld]–[number withheld] | handled | explicit date filter |
| [number withheld] | `code` must be text (leading zeros) | handled | all scripts |
| [number withheld] | Wind xlsx breaks `openpyxl`; trailer row "数据来源：Wind" | handled | Python `calamine`; R `readxl` works; trailer dropped |
| [number withheld] | HK balance keys [number withheld] vs [number withheld] | open, documented | [number withheld] reported in `t004_panel_counts.csv` |
| [number withheld] | No overlapping EastMoney/Wind firm-dates | open | no numerical cross-source check possible |
| [number withheld] | [number withheld] 方圆房服集团 delisting vs. data to [number withheld] | handled | property services → excluded |
| [number withheld] | `PROJEKT_STAND.md` §[number withheld]/§[number withheld] still says `fetch_delisted.py` not run | open | update PROJEKT_STAND (Co-PI/PI) |
| [number withheld] | T001 raw rows [number withheld] (report) vs [number withheld] (review) | open, minor | – |

Source: `state/STATE.md`; `PROJEKT_STAND.md` §[number withheld], §[number withheld]; `tasks/T003.md`, `tasks/T003_report.md`; `tasks/T004.md` (Co-PI feedback runs [number withheld]–[number withheld]); `tasks/T004_report.md`; `Daten/wind_2026-10-16/README.md`; `review/T001.md`.
