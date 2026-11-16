---
tags: [mtpa, replication, r]
status: done
updated: 2026-10-16
---

# R Environment and RStudio

Hub: [[Replication Package]]

## Division of labour
**Python** downloads raw data (needs network → Anton runs it on his Mac). **R** does cleaning, estimation and figures.
Codex workers can run `Rscript`; reviewers only read.

## Versions (`replication/environment.lock`)
| Software | Version | Use |
|---|---|---|
| R | [number withheld] | everything below |
| fixest | [number withheld] | FE regressions, event studies, clustered SE |
| did | [number withheld] | modern DiD estimators (course week [number withheld]) |
| data.table | [number withheld] | data handling |
| ggplot2 | [number withheld] | figures |
| modelsummary | [number withheld] | LaTeX tables (booktabs) |
| rdrobust | [number withheld] | RDD, course week [number withheld] |
| readxl | [number withheld] | Wind `.xlsx` exports |

CRAN mirror in China: `https://mirrors.ustc.edu.cn/CRAN/` (fallback `https://mirrors.aliyun.com/CRAN/`).

## Checked by T007 (simulated data)
TWFE on [number withheld] firms × [number withheld] periods: estimate [number withheld], [number withheld] % CI [[number withheld]; [number withheld]] contains the true [number withheld]; two runs identical.
Lesson: test pre-trends **jointly**, not via individual CIs (one of six pre-period CIs excluded [number withheld] by chance). → [[Task Board]]

## Working in RStudio
[number withheld]. Open RStudio → *Session → Set Working Directory* → `Policy Analysis/replication/` (scripts expect this working directory).
[number withheld]. Run a single step: `source("code/01_clean.R")`; whole build: Terminal tab → `./run_all.sh`.
[number withheld]. Inspect the panel: `panel <- data.table::fread("data/processed/panel_firm_halfyear.csv")`.

> [!idea] Suggestion (not decided)
> An RStudio project file `replication/replication.Rproj` would set the working directory automatically. Create it via a small card once no card is active.

Source: `replication/README.md` §[number withheld], `replication/environment.lock`, `tasks/T007.md`, `tasks/T007_report.md`.
