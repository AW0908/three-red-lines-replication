---
tags: [mtpa, data, hub]
status: in-progress
updated: 2026-10-16
---
# Data Overview

Hub of `[number withheld] Data`. Back to [[[number withheld] Home]] · Other hubs: [[Research Question]] · [[Replication Package]] · [[Task Board]] · [[To-Do]]

Goal: one firm × half-year panel of Chinese property developers (A-share + HK, listed + delisted), [number withheld] dates 2016-12-31 … 2022-12-31, with the three red-line ratios, treatment intensity, ownership and outcomes. **Status 2026-10-16: panel built (T004 delivered [number withheld]).**

## Data flow

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Python is used for download and raw-data audits (T001, T003), R for cleaning, estimation and figures. Scripts run from `replication/` and read raw data as `../Daten/...` until it is copied to `replication/data/raw/`. `Daten/` must not be modified or moved without asking.

## Status per source

| Source | Content | Status |
|---|---|---|
| EastMoney via AKShare | statements of listed A ([number withheld]) + HK ([number withheld]) firms; [number withheld] delisted HK firms | **done** (2026-10-13); audited: A in T001, HK in T003 – [[AKShare EastMoney]] |
| Wind visit [number withheld] | lists of delisted A ([number withheld]) and HK ([number withheld]) firms → [number withheld] delisted developers | **done** – [[Wind Terminal]], [[Delisted Developers]] |
| Wind visit [number withheld] (2026-10-16) | statements of [number withheld] delisted A + [number withheld] delisted HK firms; ownership (实际控制人属性) | **done**; quota mostly used; [number withheld] low-priority firms not exported – [[Wind Terminal]] |
| Annual reports (cninfo) | restricted cash for A-shares | **open** – total cash used as upper bound for `rl3` |
| Annual reports (HKEXnews) | HK reporting currency | **open** – HK amounts "as reported" |
| Ownership coding | `soe` from Wind | **partly**: known for [number withheld] % of the broad panel sample; rest manual (PI) |
| CSMAR | alternative database | PKU access **unverified** |
| Firm panel (T004) | [number withheld] rows, [number withheld] firms | ✅ **DELIVERED** [number withheld] – [[Firm Panel]] |
| Descriptives, bunching plots (T005) | first tables and histograms | not started – [[Task Board]] |

## Children

| Note | Content |
|---|---|
| [[AKShare EastMoney]] | free source, files, download method |
| [[Wind Terminal]] | access, visit [number withheld] + [number withheld] exports, reading rules, what is missing |
| [[Delisted Developers]] | [number withheld] delisted developers, where their data come from |
| [[Field Coverage]] | item coverage A (T001), HK (T003), panel (T004) |
| [[Data Issues]] | all known issues with status and handling |
| [[Firm Panel]] | what T004 produced |

Definitions of all variables: [[Research Question]] → Variables and Metrics.

Source: `PROJEKT_STAND.md` §[number withheld], §[number withheld] (T001, T007, Wind-Besuch [number withheld]); `state/STATE.md`; `tasks/T004.md`; `tasks/T004_report.md`; `Daten/wind_2026-10-16/README.md`; `replication/README.md` §[number withheld]–[number withheld].
