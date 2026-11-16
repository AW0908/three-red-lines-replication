---
tags: [mtpa, task, data]
status: done
updated: 2026-10-14
---

Hub: [[Task Board]]

# T001 A-Share Audit

> [!success] DELIVERED 2026-10-13 17:03 — accepted by the PI after reviewer verdict PASS.

| Field | Value |
|---|---|
| ID | T001 |
| Title (original) | Audit der A-Share-Rohdaten – Stichprobe und Feldabdeckung (audit of the A-share raw data – sample and field coverage) |
| Status | `DELIVERED` |
| Priority | not set in card → default `normal` (Model Tiers) |
| Worker | Codex (`codex`, reasoning effort medium) → Role - Worker |
| Reviewer | Antigravity (`agy`, `gemini-[number withheld]-flash-medium`) → Role - Independent Reviewer |
| Created | 2026-10-13 |

## Goal

Two tables showing which A-share firms and fields are actually available for the firm half-year panel [number withheld]H2–[number withheld]H2. They are the basis for Anton's decision which firms enter the sample (proposal section "Context and Data"). The task itself excludes no firm and computes no red-line metric yet.

## Inputs (read-only)

- `Daten/akshare_output/firm_list.csv` – firm list (UTF-[number withheld] with BOM; columns `code`, `name`, `board`, `market`, `fetched`)
- `Daten/akshare_output/raw_a_balance.csv` – A-share balance sheets, wide format, keys `code` and `REPORT_DATE`

See AKShare EastMoney and [[Data Overview]].

## Write scope

- `code/t001_audit_a_shares.py`
- `output/tables/t001_a_firms.csv`
- `output/tables/t001_a_field_coverage.csv`

Everything else unchanged, in particular all of `Daten/`.

## Steps (summary)

[number withheld]. Read both inputs with `code` as text (keep leading zeros).
[number withheld]. Restrict balance data to the [number withheld] reporting dates: every [number withheld] June and [number withheld] December from 2016-12-31 to 2022-12-31 (the raw file contains all quarters since [number withheld]).
[number withheld]. Firm table: one row per A-share firm with `code`, `name`, `n_stichtage` (number of reporting dates with `TOTAL_ASSETS` present and > [number withheld]), `erster_stichtag` / `letzter_stichtag` (first/last reporting date), `b_share` (code starts with `[number withheld]` or `[number withheld]`).
[number withheld]. Coverage table per field: `feld`, `n_vorhanden` (present), `n_gesamt` (total firm-date rows), `anteil` (share) for [number withheld] balance-sheet fields plus the derived row `ADVANCE_OR_CONTRACT` (at least one of the two advance-payment fields present). Field details → Field Coverage, Variables and Metrics.

## Acceptance criteria (summarised)

[number withheld]. Firm table: exactly [number withheld] rows, one per A-share firm, no duplicate `code`.
[number withheld]. Every `code` is a six-digit text with leading zeros.
[number withheld]. `n_stichtage` between [number withheld] and [number withheld].
[number withheld]. `b_share` true exactly for codes starting `[number withheld]`/`[number withheld]` — [number withheld] firms.
[number withheld]. Coverage table: [number withheld] rows; `anteil = n_vorhanden / n_gesamt` in [[number withheld]]; `n_gesamt` identical in all rows.
[number withheld]. No reporting date outside the [number withheld] enters either table.
[number withheld]. Execution command `Daten/.venv/bin/python code/t001_audit_a_shares.py` runs from the project folder and regenerates both files.
[number withheld]. No file under `Daten/` changed.

## Timeline

| Time (2026-10-13) | Event | Source |
|---|---|---|
| – | Card created by Co-PI (`PLAN`) | `tasks/T001.md` |
| [number withheld]:[number withheld] | `APPROVED` by PI | `state/approvals.log` |
| [number withheld]:[number withheld] | Worker run: codex medium (priority normal) → `EXECUTED` | `state/runs.log` |
| (between) | Co-PI first-pass QA, freeze → `CANDIDATE` ([number withheld] files frozen) | `review/T001.md` header |
| [number withheld]:[number withheld] | Review: agy gemini-[number withheld]-flash-medium → **PASS** | `state/runs.log`, `review/T001.md` |
| [number withheld]:[number withheld] | `DELIVERED` by PI | `state/approvals.log` |

## Verdict

**PASS.** All [number withheld] criteria "evidenced as met". Inputs unchanged ([number withheld] files, SHA-[number withheld]); candidate unchanged after review. Not checked by the reviewer: active re-execution of the script (reviewer role forbids running commands); reproducibility was verified statically from code and data.

## Results

| Item | Value |
|---|---|
| A-share firms | [number withheld], of which [number withheld] B-shares (codes [number withheld]…/[number withheld]…) |
| Firms with all [number withheld] reporting dates | [number withheld]; [number withheld] 中新集团 (Zhongxin Group) has [number withheld] |
| Firm half-years after date filter | [number withheld] |
| Coverage: total assets, liabilities, cash, equity | [number withheld] % |
| Coverage: advance payments (either field, `ADVANCE_OR_CONTRACT`) | [number withheld] % |
| Coverage: minority equity 少数股东权益 (`MINORITY_EQUITY`) | [number withheld] % |
| Coverage: JV / associate investments (`LONG_EQUITY_INVEST`) | [number withheld] % |
| Coverage: bonds payable | [number withheld] % |
| Coverage: `PERPETUAL_BOND` | [number withheld] % |
| Coverage: `OTHER_EQUITY_TOOL` | [number withheld] % |

Files: `code/t001_audit_a_shares.py`, `output/tables/t001_a_firms.csv`, `output/tables/t001_a_field_coverage.csv`.

**Correction to the project state:** `raw_a_balance.csv` contains all quarters from [number withheld] to [number withheld] ([number withheld] rows), not only the [number withheld] reporting dates. Every script must filter explicitly → Data Issues.

> [!warning] Unverified
> - The reviewer explained the [number withheld] dates of [number withheld] by its IPO at end-[number withheld]. `AI_USAGE_LOG.md` records this explanation as unevidenced and **not adopted**.
> - The reviewer's text mentions [number withheld] raw rows; the worker report and `PROJEKT_STAND.md` state [number withheld]. The difference is not resolved in the sources.

## Open questions (PI decisions)

- [ ] Which firms are not developers (e.g. 卧龙新能)? T001 only flags B-shares; the developer definition is Anton's decision.
- [ ] How to handle the B-share duplicates.
- Worker notes: `erster_stichtag`/`letzter_stichtag` refer to dates with positive total assets (consistent with `n_stichtage`); `code` must be read as text when importing the CSV.

Logged in `AI_USAGE_LOG.md` (entry 2026-10-13) → AI Usage Log. Next data tasks: [[T003 HK Raw Data Audit]], [[T004 Firm Panel and Red-Line Metrics]].

Related: [[Task Board]] · Run Log · Task Workflow · Done

Source: `tasks/T001.md`; `tasks/T001_report.md`; `review/T001.md`; `state/runs.log`; `state/approvals.log`; `PROJEKT_STAND.md` §[number withheld] (T001); `AI_USAGE_LOG.md` (2026-10-13, T001).
