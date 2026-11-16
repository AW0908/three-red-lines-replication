---
tags: [mtpa, progress, todo]
status: open
updated: 2026-10-14
---

# To-Do

Owner: **PI** = Anton · **Co-PI** = Claude Code · **W** = worker via script. Order = priority.

## This week (until Fri 2026-10-17)
- [ ] **PI** – Decide T002: re-freeze + re-review, or `agents/pi.sh override T002 "reason"` → [[T002 LaTeX Skeleton]]
- [ ] **PI** – Run `agents/overleaf.sh check` once by hand (worker could not compile) → [[Overleaf Sync]]
- [ ] **PI** – Review and approve `tasks/T003.md` → [[T003 HK Raw Data Audit]]
- [ ] **Co-PI/W** – Run T003 → candidate → review
- [ ] **PI** – Office hour with Zhuang (Fri [number withheld]:[number withheld]–[number withheld]:[number withheld], Room [number withheld]): topic, question, design → [[Research Question]]
- [ ] **PI** – Wind visit [number withheld] (~[number withheld] min left) → [[Wind Visit [number withheld] Checklist]]
- [ ] **PI** – Check whether PKU library has CSMAR access (unverified)

## Decisions needed (block T004) → [[Decisions and Open Questions]]
- [ ] Developer definition, property services, B-shares, [number withheld]
- [ ] HK date rule and non-December fiscal year ends
- [ ] Red-line formulas (rl1 denominator, interest-bearing debt, restricted cash, perpetuals)
- [ ] Pre-policy reference date; currency harmonisation

## Literature and policy (until [number withheld] Oct)
- [ ] Find primary source for the [number withheld]/[number withheld]/[number withheld]/[number withheld] % caps, exact date, pilot list, start date → [[Three Red Lines Policy]]
- [ ] Re-check S&P China Ratings PDF (cap order differs from Caixin in extraction)
- [ ] Read full texts: [[Ma and Xie [number withheld]]], [[Zheng Dong Jiang SSRN]], [[Shi Hao Xie Kim [number withheld]]], [[Chen Du Ma [number withheld]]]
- [ ] Decide whether to add Ba, Huang & Zhang ([number withheld]) and Cao & Ma ([number withheld]) → [[Literature Gap]]
- [ ] CNKI search (经济研究, 金融研究, 管理世界) for bunching / window dressing at the red lines
- [ ] Narrow the gap claim to threshold-specific circumvention → [[Literature Gap]]
- [ ] Choose focal paper(s) → [[Proposal Outline]]

## Data and analysis (until [number withheld] Nov)
- [ ] Ownership type SOE vs private for all firms (Wind)
- [ ] Restricted cash 受限货币资金 for A-shares (Wind or cninfo)
- [ ] [[T004 Firm Panel and Red-Line Metrics]]
- [ ] [[T005 Descriptives and Bunching Plots]]
- [ ] Copy raw data into `data/raw/` and scripts into `code/` (only after PI OK – `Daten/` must not be moved)
- [ ] Update `PROJEKT_STAND.md`: `fetch_delisted.py` has been run; new data findings → [[Data Issues]]

## Writing (until [number withheld] Nov)
- [ ] Writer cards per section once numbers exist → [[Proposal Outline]]
- [ ] First DiD / event-study estimate (after course week [number withheld], [number withheld] Nov) → [[Empirical Design]]
- [ ] Fill AI-use appendix from `AI_USAGE_LOG.md` → [[AI Usage Log]]

## Agent-team housekeeping (found by vault agent, see [[Safeguards]])
- [ ] `overleaf.sh check` passes when `latexmk` is missing – make it fail
- [ ] `overleaf.sh push` adds the whole `proposal/` folder (`git add -A`) – restrict to write scope?
- [ ] Document `pi.sh return` in `TEAM.md`; `candidate.sh` accepts REWORK without new worker run
- [ ] Keep earlier review reports instead of overwriting `review/T###.md`

Source: `PROJEKT_STAND.md` §[number withheld], task cards, vault agents' reports 2026-10-14.
