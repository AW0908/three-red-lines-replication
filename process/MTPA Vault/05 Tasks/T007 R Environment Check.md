---
tags: [mtpa, task, replication]
status: done
updated: 2026-10-16
---

Hub: [[Task Board]]

# T007 R Environment Check

| Field | Value |
|---|---|
| Card | `tasks/T007.md` – check R environment: packages, versions, test estimation on simulated data |
| Status | `DELIVERED` 2026-10-16 10:40 **via override** |
| Priority | low |
| Worker → Reviewer | Codex (low) → Antigravity (gemini-[number withheld]-flash-low) |
| Timeline ([number withheld]) | approved [number withheld]:[number withheld] · worker [number withheld]:[number withheld] · review ESCALATE [number withheld]:[number withheld] · override [number withheld]:[number withheld] |
| Outputs | `t007_r_setup_check.R`; `t007_r_packages.csv`; `t0[number withheld]_twfe_check.{csv,tex}`; `t007_event_study_check.pdf` (now in `replication/`) |

Proves that the proposal's estimations run reproducibly in R. Uses **simulated** data only ([number withheld] firms × [number withheld] half-years, true effect of `dose × post` = [number withheld]).

## Key results

| Item | Value |
|---|---|
| Versions | R [number withheld] · fixest [number withheld] · did [number withheld] · data.table [number withheld] · ggplot2 [number withheld] · modelsummary [number withheld] (+ rdrobust [number withheld], readxl [number withheld] installed; CRAN mirror USTC) |
| TWFE (`feols`, firm + period FE, clustered by firm) | coef [number withheld], SE [number withheld], [number withheld] % CI [[number withheld]; [number withheld]] contains [number withheld]; N = [number withheld] |
| Reproducibility | two runs, identical CSV hash |
| Event study | period [number withheld] reference; CI of period [number withheld] excludes [number withheld] |

Consequence: Codex workers can run `Rscript`; division of labour **Python for download/raw data, R for preparation, estimation, figures**. `replication/` became the only place for code, data and outputs (→ [[Replication Package]]).

## Why ESCALATE and override

Criterion [number withheld] required every pre-period CI to contain [number withheld] – mis-specified by the Co-PI: with six [number withheld] % tests, ≈ [number withheld] % chance that at least one excludes [number withheld] without any pre-trend. The worker reported it and did not change the seed (desired behaviour). Outside changes (`agents/lib.sh` fix, `agents/dashboard.*`, `agents/TEAM.md`, new `replication/`) came from Co-PI/PI. PI reason: *R chain works; criterion [number withheld] mis-specified, deviation random; outside changes by Co-PI or PI*.

## Open points

- Rule for future cards: test pre-trends **jointly**, not via individual CIs.
- R packages report being built under R [number withheld]; they load under [number withheld].

Siblings: [[T006 Overleaf Structure]] · [[T004 Firm Panel and Red-Line Metrics]]

Source: `tasks/T007.md`; `tasks/T007_report.md`; `review/T007.md`; `state/runs.log`; `state/approvals.log`; `PROJEKT_STAND.md` §[number withheld]; `replication/README.md`.
