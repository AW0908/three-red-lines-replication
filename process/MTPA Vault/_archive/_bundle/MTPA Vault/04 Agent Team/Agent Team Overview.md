---
tags: [mtpa, agents]
status: reference
updated: 2026-10-14
---

# Agent Team Overview

The research proposal is produced with a small AI agent team built after the guest lecture of 2026-09-18 on agentic research workflows ([[Lecture [number withheld] Guest - AI Agent Organization]], slides [number withheld]–[number withheld]). Following the lecture's advice, it is deliberately small: **one lead, one worker, one independent reviewer** per task; more roles only when a task needs them.

> [!info] Source of truth
> This note is a navigation snapshot. The binding definition is `agents/TEAM.md` (plus `agents/roles/*.md` and the scripts in `agents/`). Task status lives only in the task cards `tasks/T###.md`; decisions and open questions only in `state/STATE.md`.

## Who is who

| Role | Who | Main job | Writes to | Note |
|---|---|---|---|---|
| **PI** | Anton (human) | Research question, estimand, sample, data, public claims; approves plans; accepts results | – (decisions via `agents/pi.sh`) | [[Role - PI]] |
| **Co-PI / Subtask Lead** | Claude Code | Turns the goal into a task card, triggers the worker, first-pass QA, packages the result for the PI | `tasks/`, `state/`, `protocols/` | [[Role - Co-PI]] |
| **Worker (data, code)** | Codex CLI | Implements, tests, revises, leaves evidence | only the card's write scope | [[Role - Worker]] |
| **Worker (text)** | Claude, separate call without chat history | LaTeX text in `proposal/` per `agents/roles/writer.md` | only `proposal/` | [[Role - Writer]] |
| **Independent Reviewer** | Antigravity (Gemini) for data tasks; Codex for text tasks | Checks the frozen result against the acceptance criteria; not involved in execution | nothing; the script writes `review/T###.md` | [[Role - Independent Reviewer]] |

Which tool is worker and which is reviewer is set per task card in the fields `worker:` and `reviewer:`. For text tasks Codex reviews because, in read-only mode, it can run commands and compare numbers in the text against files in `output/`. Co-PI and text worker are both Claude, so the first truly independent check is Codex's review.

## Core principles (from `agents/TEAM.md`)

[number withheld]. **The PI is a human.** Responsibility for any claim does not transfer to an AI (syllabus; guest lecture slide [number withheld]).
[number withheld]. **Whoever executes does not review.** Worker and reviewer are always different tools, i.e. different model families. `agents/review.sh` refuses otherwise.
[number withheld]. **Approve the plan first, then execute.** `agents/worker.sh` refuses cards in status `PLAN`.
[number withheld]. **Hand off files, not chat transcripts.** Each role reads the task card and the files named there, not the previous role's explanation (lecture slide [number withheld]).
[number withheld]. **One place for state.** Task status only in `tasks/T###.md`; decisions and open questions only in `state/STATE.md`.

## Org chart

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Visual version: [[Agent Org Chart.canvas]]. Anton's own workflow graphic is `Team_Workflow_EN.png` (source `agents/Team_Workflow_EN.tex`); its legend states three rules: *no worker starts without your approval ([number withheld]); whoever executes does not review; nothing reaches Overleaf without your acceptance ([number withheld])*.

## Mapping to the guest lecture

| Lecture concept (slides [number withheld]–[number withheld]) | Implementation in this project |
|---|---|
| Human researcher approves scope, sensitive data, public claims; AI PI cannot replace human approval | PI is Anton himself, not an AI; `agents/pi.sh` is his only |
| Co-PI: plan · split tasks · first-pass QA → candidate package | Claude Code writes cards, runs `agents/candidate.sh` |
| Worker: clear task, limited write scope, stop condition; "script + output + run command/log + open questions" | Card sections *Schreibbereich*, *Stopp-Bedingungen*; mandatory report format |
| Reviewer: frozen candidate, PASS / REWORK / ESCALATE + evidence | SHA-[number withheld] freeze; first line `VERDICT: …` |
| Artifact handoff, not chat; "a shared folder does not wake another agent" | Scripts trigger each step explicitly |
| Governance: approvals, permissions, versioning, escalation; "a prompt rule ≠ a technical security boundary" | [[Safeguards]] separates enforced vs rule-only |
| "More agents ≠ better research"; keep it simple when the task is tiny | Small questions need no task card (`AGENTS.md`) |

## Limits (from `agents/TEAM.md`)

- **No network for workers.** Data downloads (AKShare, EastMoney) are started by Anton himself in the terminal.
- **Quotas.** Every script call uses the respective subscription. Small tasks that are faster done than reviewed run directly in one tool, without the team.
- **Confidential material.** Other students' proposals and referee reports never go into a task card.
- **AI log.** After `DELIVERED` the Co-PI adds the task to `AI_USAGE_LOG.md` (tools, purpose, how checked, what was rejected) → [[AI Usage Log]].

## Related

[[Task Workflow]] · [[Model Tiers]] · [[Safeguards]] · [[Overleaf Sync]] · [[Scripts Reference]] · [[Task Board]] · [[Run Log]] · [[T001 A-Share Audit]] · [[T002 LaTeX Skeleton]] · [[[number withheld] Home]]

Source: `agents/TEAM.md` (Rollen, Grundsätze, Grenzen); `AGENTS.md` (Agenten-Team); `agents/roles/*.md`; `agents/Team_Workflow_EN.tex`; `Team_Workflow_EN.png`; `Lecture Note/Lecture02_SlidesGuest.pdf` slides [number withheld]–[number withheld].
