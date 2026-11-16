---
tags: [mtpa, tasks, hub]
status: in-progress
updated: 2026-10-16
---

# Task Board (hub)

Hub: [[[number withheld] Home]] · How a task runs: [[Agent Team Overview]]

> [!info] Source of truth
> Status lives only in the cards `tasks/T###.md` (`agents/status.sh`, live: `python3 agents/dashboard.py`). Snapshot 2026-10-16 16:30.

| ID | Task | Status | Worker → Reviewer | Result |
|---|---|---|---|---|
| T001 | [[T001 A-Share Audit]] | ✅ DELIVERED [number withheld] | Codex → Gemini | [number withheld] A-share firms, field coverage |
| T002 | [[T002 LaTeX Skeleton]] | ✅ DELIVERED [number withheld] (override) | Claude → Codex | proposal skeleton |
| T006 | [[T006 Overleaf Structure]] | ✅ DELIVERED [number withheld] (override) | Claude → Codex | preamble + one file per section |
| T007 | [[T007 R Environment Check]] | ✅ DELIVERED [number withheld] (override) | Codex → Gemini | R [number withheld] chain works |
| T003 | [[T003 HK Raw Data Audit]] | ✅ DELIVERED [number withheld] | Codex → Gemini | [number withheld] HK firms, [number withheld] non-Dec fiscal years |
| T004 | [[T004 Firm Panel and Red-Line Metrics]] | ✅ DELIVERED [number withheld] (override: PASS, `.DS_Store` only) | Codex (high) → Gemini | panel [number withheld] rows, [number withheld] firms → Firm Panel |
| T005 | [[T005 Descriptives and Bunching Plots]] | ▶️ EXECUTED [number withheld] [number withheld]:[number withheld] – Co-PI QA next | Codex → Gemini | summary stats, table by dose, bunching histograms (R) |

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Next
[number withheld]. T005 executed [number withheld]:[number withheld] → Co-PI checks report + figures
[number withheld]. Co-PI QA → `candidate.sh` → `review.sh` → accept
[number withheld]. New cards (Co-PI): copy outputs → `proposal/`; writer card "Context and Data"; manual SOE coding; restricted cash A-shares (cninfo)

## Run history (from `state/runs.log`)
| Date | Runs |
|---|---|
| [number withheld] | T001 worker + review PASS; T002 worker ×[number withheld], review REWORK ×[number withheld] |
| [number withheld] | T006 worker + review REWORK (procedural) |
| [number withheld] | T007 worker + review ESCALATE (criterion wording); T003 worker ×[number withheld] + review PASS; T004 worker ×[number withheld] (run [number withheld] stopped on HK date collisions → PI rule; follow-up fixes) + review PASS/ESCALATE (`.DS_Store`) → override |

Overrides used so far (T002, T006, T007, T004): every finding concerned the procedure or the criterion wording, not the result – reasons in `state/approvals.log`.

Source: `agents/status.sh` output, `state/runs.log`, `state/approvals.log`, task cards.
