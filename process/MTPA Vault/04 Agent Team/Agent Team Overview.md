---
tags: [mtpa, agents, hub]
status: reference
updated: 2026-10-16
---

# Agent Team Overview

Hub for the AI agent team that produces the research proposal. Built after the guest lecture of 2026-09-18 on agentic research workflows (→ [[Course Overview]]). Deliberately small: **one lead, one worker, one independent reviewer per task**.

> [!info] Source of truth
> Binding definition: `agents/TEAM.md`, `agents/roles/*.md` and the scripts in `agents/`. Task status lives only in the cards `tasks/T###.md` (→ [[Task Board]]); PI decisions only in `state/STATE.md`.

## Who is who

| Role | Who | Main job | Writes to |
|---|---|---|---|
| **PI** | Anton (human) | Question, estimand, sample, data rules, public claims; approves, accepts, overrides | only via `agents/pi.sh` |
| **Co-PI** | Claude Code | Task cards, triggers worker, first-pass QA, freeze | `tasks/`, `state/`, `protocols/` |
| **Worker (data/code)** | Codex CLI | Python + R (`Rscript`, R [number withheld]) in `replication/` | card write scope only |
| **Worker (text)** | Claude, separate call | LaTeX in `proposal/` | `proposal/` only |
| **Reviewer** | Antigravity (Gemini) for data tasks; Codex (read-only) for text tasks | Verdict on the frozen candidate | nothing (script writes `review/`) |

Details → [[Roles]].

## Principles

[number withheld]. **The PI is a human.** Responsibility for a claim never transfers to an AI.
[number withheld]. **Whoever executes does not review** (different tools; `review.sh` enforces it).
[number withheld]. **Approve the plan first, then execute** (`worker.sh` refuses `PLAN`).
[number withheld]. **Hand off files, not chat.**
[number withheld]. **One place for state:** cards for status, `state/STATE.md` for decisions.
[number withheld]. **Only the Co-PI session edits project files** outside `tasks/`, `review/`, `state/` — and not while a card is `APPROVED`/`EXECUTED`/`CANDIDATE` (→ [[Task Workflow]]).

## Org chart

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Canvas version: [[Agent Org Chart.canvas]]. Anton's team diagram (outside the vault): `Team_Workflow_EN.png` in the project root, source `agents/Team_Workflow_EN.tex` — updated 2026-10-16 with an R/RStudio lane and a data-basis lane.

## Children

- [[Roles]] – responsibilities, write scope, "never does" per role
- [[Task Workflow]] – card lifecycle, override path, parallel-session rule
- [[Scripts and Safeguards]] – scripts, model tiers, Overleaf sync, dashboard, enforced vs rule-only
- [[Agent Org Chart.canvas]]

Related hubs: [[Task Board]] · [[Replication Package]] · [[[number withheld] Home]]

Source: `agents/TEAM.md`; `agents/roles/*.md`; `AGENTS.md` (parallel-session rule); `PROJEKT_STAND.md` §[number withheld]; `state/approvals.log`; `Team_Workflow_EN.png` (2026-10-16).
