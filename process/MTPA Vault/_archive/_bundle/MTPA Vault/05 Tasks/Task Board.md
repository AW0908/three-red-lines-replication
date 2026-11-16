---
tags: [mtpa, tasks, board]
status: in-progress
updated: 2026-10-14
---

# Task Board

> [!info] Source of truth
> Status lives only in the cards `tasks/T###.md` (`agents/status.sh` prints the overview). This board is a snapshot of 2026-10-14.
> Lifecycle: [[Task Workflow]] · Roles: [[Agent Team Overview]]

| ID | Title | Status | Priority | Worker → Reviewer | Blocked by | Next action (who) |
|---|---|---|---|---|---|---|
| T001 | [[T001 A-Share Audit]] | ✅ DELIVERED | normal | Codex → Antigravity | – | – |
| T002 | [[T002 LaTeX Skeleton]] | 🔁 REWORK (procedural) | normal | Claude → Codex | PI decision | PI: re-freeze + re-review or `agents/pi.sh override T002 "…"` |
| T003 | [[T003 HK Raw Data Audit]] | 📝 PLAN (new) | normal | Codex → Antigravity | PI approval | PI: read card, `agents/pi.sh approve T003` |
| T004 | [[T004 Firm Panel and Red-Line Metrics]] | 📝 PLAN (new, blocked) | high | Codex → Antigravity | [number withheld] PI questions, T003, Wind visit [number withheld] | PI: answer questions in [[Decisions and Open Questions]] |
| T005 | [[T005 Descriptives and Bunching Plots]] | 📝 PLAN (new, blocked) | normal | Codex → Antigravity | T004 | – |

## Columns

### 📝 PLAN
- [ ] [[T003 HK Raw Data Audit]] – ready for approval
- [ ] [[T004 Firm Panel and Red-Line Metrics]] – blocked
- [ ] [[T005 Descriptives and Bunching Plots]] – blocked

### ▶️ APPROVED / EXECUTED / CANDIDATE
- (none)

### 🔁 REWORK
- [ ] [[T002 LaTeX Skeleton]]

### ✅ DELIVERED
- [x] [[T001 A-Share Audit]] (2026-10-13 17:03)

## Dependency graph

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

> [!idea] Suggestion (not decided) – later cards
> Writer cards (Claude → Codex) for Introduction, Related Literature and Institutional Background once the literature full texts are read; a formal bunching estimation card (Kleven excess mass); a DiD/event-study card after course week [number withheld] ([number withheld] Nov).

Source: `tasks/T001.md`, `tasks/T002.md`, `tasks/T003.md`, `tasks/T004.md`, `tasks/T005.md`, `state/runs.log`, `state/approvals.log`.
