---
tags: [mtpa, tasks, data]
status: open
updated: 2026-10-14
---

# T004 – Firm Panel and Red-Line Metrics

| Field | Value |
|---|---|
| Card | `tasks/T004.md` |
| Status | **PLAN – BLOCKED** (must not be approved yet) |
| Priority | **high** (sample definition and ratio computation carry the proposal's claims) |
| Worker → Reviewer | Codex → Antigravity |
| Output | `data/processed/panel_firm_halfyear.csv`, `output/tables/t004_panel_counts.csv` |

## Blocked by
- [ ] [[T003 HK Raw Data Audit]] delivered
- [ ] [[Wind Visit [number withheld] Checklist]] done ([number withheld] firms + SOE flag + restricted cash)
- [ ] [number withheld] PI decisions → [[Decisions and Open Questions]] (developer definition, B-shares, HK date rule, red line [number withheld] formula, interest-bearing debt, restricted cash, reference date, currency, perpetuals)

## Planned content
- Three ratios `rl1`, `rl2`, `rl3`, `n_breached`, pre-policy treatment intensity → definitions in [[Variables and Metrics]] and [[Three Red Lines Policy]]
- Outcomes: minority equity share, 明股实债 gap, JV investments / assets, perpetuals / equity, inventory / assets → [[Empirical Design]]
- Filter-step count table (sample flow for the proposal)

Source: `tasks/T004.md`.
