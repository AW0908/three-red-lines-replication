---
tags: [mtpa, course, lecture, agents]
status: reference
updated: 2026-10-14
---

# Lecture [number withheld] Guest: AI Agent Organization

**Guest lecture:** "Innovation with Agents: Reliable Research with AI" ("Codex + DeepSeek Harness: Principles for reliable social science with AI agents"), Zhihan Cui, Assistant Professor, PKU iGHD · **Date:** 2026-09-18 · **Slides:** `Lecture Note/Lecture02_SlidesGuest.pdf` ([number withheld] slides)

> [!info] Why this note matters
> Slides [number withheld]–[number withheld] (the "AI Agent Organization Chart") are the blueprint for the project's agent team. `agents/TEAM.md` opens with: "Implementation of the 'AI Agent Organization Chart' from the guest lecture of [number withheld] (slides [number withheld]–[number withheld]) as a small team, as recommended there: one lead, one worker, one independent reviewer." See [[Agent Team Overview]] and [[Agent Org Chart.canvas]].

## Part [number withheld]: Agentic workflow basics (slides [number withheld]–[number withheld])

- **One real question, not a whole paper** (slide [number withheld]). The demo used a single question from a JMIR [number withheld] study: does describing a doctor as using AI change willingness to seek help ([number withheld] groups, [number withheld] participants)? Goal: **an audit trail, rerunnable outputs and independent review.**
- **Four-question checklist** for any agent tool (slide [number withheld]): ([number withheld]) right project? ([number withheld]) which model? ([number withheld]) read/write/network permissions? ([number withheld]) where is the evidence? "The interface may change. This checklist should not."
- **Chatbot vs. agent** (slide [number withheld]): a chatbot answers; an agent goes goal → plan → act → check. "Think of an agent as a junior research assistant with tools, not as an oracle."
- **Workflow [number withheld]: a stable project home** (slide [number withheld]). "Folders are long-term memory." Structure: `data/raw/` (never overwritten, read-only), `protocols/`, `scripts/`, `outputs/`, `review/`, `tasks/`, `state/`; root `AGENTS.md` (agent instructions) and `PROJECT.md` (research context). Write project state to files: approved plan, task status, open questions.
- **Workflow [number withheld]: Audit → Approve → Execute** (slides [number withheld]–[number withheld]). Write a "research contract", not "please analyze this paper". Example instruction: "Check the sample, coding, scale direction, and missing-data rules. Propose a plan and wait. Do not change raw data or add analyses without approval." Small choices change the question (any AI vs. none; intensive AI vs. none; adding controls). **Freeze the estimand before execution.**
- **Workflow [number withheld]: validate before writing the conclusion** (slide [number withheld]). An intentional reverse-coding bug passes a range check but fails a meaning check. "Code ran successfully is not enough." Validation order: **variable meaning → sample → clean rerun → interpretation.**

## Part [number withheld]: The AI Agent Organization Chart (slides [number withheld]–[number withheld])

### The full chart (slide [number withheld])

Title: *"AI Agent Organization Chart: Layered Collaboration and Independent Validation"*. Mottos: "Approve plan first, then execute" · "Report first, then audit" · "Centralized intelligence, division of labor, strict review, fast decisions". The chart has two highlighted features: **"Shared state: one source of truth"** and **"Independent review: separate doing from checking."** The slide note says: "Use the chart as a map, not a checklist to memorize."

| Layer | Count in chart | Role | Responsibilities |
|---|---|---|---|
| Top | [number withheld] | **PI / Chief Controller** | Define goals and success criteria; approve Co-PI execution plans; handle major conflicts and exceptions; assign independent validation when needed; may call an **ad-hoc reviewer** for large tasks. **"PI does not execute tasks directly."** |
| Middle | [number withheld] | **Co-PI / Subtask Lead** | Plan, manage, first-pass QA, revision loop: turn PI goals into an execution plan, submit it for PI approval, manage two executors and combine their outputs, revise and deliver the final package |
| Execution | [number withheld] ([number withheld] per Co-PI) | **Executor A / B** | Implementation and revision: complete assigned tasks; revise based on feedback |
| Validation | [number withheld] ([number withheld] per Co-PI) | **Independent Reviewer** | Testing and challenge: does not take part in execution; validates against preset criteria; outputs **PASS / REWORK / ESCALATE**; escalates major issues to the PI |

**Numbered flow in the chart:**
[number withheld]. PI assigns a strategic task.
[number withheld]. Co-PI submits an execution plan.
[number withheld]. PI approves the plan and authorises work.
[number withheld]. Execution.
[number withheld]. First-pass QA and packaging.
[number withheld]. Independent validation.
[number withheld]. Revision loop and final delivery to the PI.

The loop closes with "Feedback & revision" from reviewer to executors.

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

### Start small (slides [number withheld]–[number withheld], [number withheld]–[number withheld])

- **Slide [number withheld], "start with one small team":** human researcher, then AI PI, then Co-PI/Subtask Lead, then Worker Agents A/B plus Independent Reviewer. Order of work: **first-pass QA → independent review → revision → final delivery to the PI.** "Serious issues can go directly to the PI; routine rework goes through the Co-PI." The human researcher approves research scope, sensitive data and public claims.
- **Slide [number withheld], why multiple agents:** "the person who does the work should not be the only person who decides whether it is correct."

  | Gains | Costs |
  |---|---|
  | Specialisation | More messages and waiting |
  | Independent checking (the reviewer starts from criteria, not excuses) | More context lost at handoff |
  | Traceability (easier to locate failures) | Several agents can still share the same wrong assumption |

  Rule: do the work, review independently, add more roles only when justified.
- **Slide [number withheld], more agents ≠ better research.** An extra layer helps when the task can be split, acceptance criteria are clear and errors are expensive. Keep it simple when the task is tiny, inputs are not ready, or approval is slower than execution. Default: **[number withheld] worker + [number withheld] reviewer**; add leads only if the work truly branches. Benefits must be measured on the task (quality, total time, human rework), not inferred from agent count.
- **Slide [number withheld]:** "You do not need [number withheld] agents. First make one research task complete a reliable loop." One project (approved inputs, rerunnable result) · one review (evidence and rejection criteria) · one feedback loop. **"Reliability comes from workflow design, not from trusting one model."** Check data authorisation, privacy and tool-use boundaries before sharing anything.

### Role cards (slides [number withheld]–[number withheld])

| Role | IN | DO | OUT | Key sentence |
|---|---|---|---|---|
| **PI / Lead Agent** (slide [number withheld]) | Research question, constraints, risk boundaries | Set acceptance criteria, approve plans, resolve major conflicts | Approve / return / freeze; call an extra reviewer when needed | "Think of the PI as the project lead, not the super-worker." "An AI PI can coordinate work, but it cannot replace required human approval." Human research responsibility does not transfer to the AI PI |
| **Co-PI / Subtask Lead** (slide [number withheld]) | Approved goal, protocol, acceptance criteria | Split tasks, assign files, combine outputs, first-pass QA | Candidate package → revision → formal delivery to the PI | "The Co-PI is not a message forwarder; it is responsible for delivery completeness." |
| **Worker Agent** (slide [number withheld]) | Task card, assigned files, approved version | Implement, test, revise; **do not silently change the question** | Script + output + run command/log + open questions | "Clear task, limited write scope, clear stop condition." "A file named 'final' is not evidence. Show how the result was produced." |
| **Independent Reviewer** (slide [number withheld]) | Original evidence, acceptance criteria, **frozen candidate version** | Test edge cases, check scale and sample, rerun cleanly | **PASS / REWORK / ESCALATE + evidence** | "Test the result, not the story." Start from evidence and criteria, not from the worker's explanation. Routine fixes go to the Co-PI; major problems escalate to the PI. "A separate chat alone does not guarantee independent evidence." |

### Handoff and governance (slides [number withheld]–[number withheld])

- **Slide [number withheld], hand off artifacts, not chat transcripts.** Example card "T017 · Review candidate v1": from Co-PI [number withheld] to Reviewer [number withheld]; inputs: plan v1 + candidate v1; write: `review/T017.md` only; checks: N / scale / clean run; return: PASS | REWORK | ESCALATE. Steps:
  [number withheld]. The sender saves the task card and artifacts.
  [number withheld]. The receiving agent is triggered explicitly.
  [number withheld]. The receiver reads the same version and writes a review report.

  "A shared folder does not wake another agent. Someone, or an orchestrator, must trigger the next step." Across machines or sandboxes: transfer explicitly, then verify the version. The course assumes manual artifact handoff, not automatic cross-tool orchestration.
- **Slide [number withheld], governance** (turn rules into settings and records that can be checked):
  - **Approval:** pause when the question changes (sample, estimand, sensitive data, public release).
  - **Permissions:** give only what is needed (writable folders, network, tools, credentials).
  - **Versioning:** know who can change what; assign writers; freeze a candidate before review.
  - **Escalation:** know when to call a human (budget overrun, repeated failure, serious anomaly → stop).
  - "Local interface ≠ local inference. A prompt rule ≠ a technical security boundary."

## Relevance for our project

How the chart maps onto the project (details: [[Agent Team Overview]], [[Task Workflow]], [[Safeguards]]):

| Lecture element | Project implementation | Deviation / note |
|---|---|---|
| PI (slides [number withheld], [number withheld]) | **Anton, a human** ([[Role - PI]]) | Slide [number withheld] shows an *AI* PI under a human researcher. The project merges the two: the PI is human, as slide [number withheld]'s "cannot replace required human approval" demands |
| Co-PI (slide [number withheld]) | Claude Code ([[Role - Co-PI]]): task cards, first-pass QA, `agents/candidate.sh` | One Co-PI instead of three (slide [number withheld]/[number withheld]: start small) |
| Executors A/B (slide [number withheld]) | Codex for data/code ([[Role - Worker]]); Claude as text worker ([[Role - Writer]]) | One worker per task, by type |
| Independent Reviewer (slide [number withheld]) | Antigravity (data) / Codex (text) ([[Role - Independent Reviewer]]); verdict in `review/T###.md` | Worker and reviewer are always different model families, to reduce the "same wrong assumption" risk of slide [number withheld] |
| Approve plan first (slides [number withheld], [number withheld], [number withheld]) | Card status `PLAN` → `agents/pi.sh approve` → `APPROVED`; `worker.sh` refuses `PLAN` cards | – |
| Frozen candidate (slides [number withheld], [number withheld]) | `agents/candidate.sh` freezes the candidate with SHA-[number withheld] checksums (`review/T###_frozen.sha256`) | – |
| Artifacts, not chats (slide [number withheld]) | Task cards `tasks/T###.md`, reports `tasks/T###_report.md`, reviews `review/T###.md`; each step triggered by a script | Manual triggering, as the lecture assumes |
| Shared state (slides [number withheld], [number withheld]) | `state/STATE.md` (decisions, open questions), `state/approvals.log`, `state/runs.log` | [[Decisions and Open Questions]], [[Run Log]] |
| Stable project home (slide [number withheld]) | `data/raw/`, `protocols/`, `code/`, `output/`, `review/`, `tasks/`, `state/`, `AGENTS.md`, `PROJEKT_STAND.md` | `code/` instead of `scripts/`; `PROJEKT_STAND.md` plays the role of `PROJECT.md` |
| Validate meaning before conclusions (slide [number withheld]) | Acceptance criteria in task cards; Co-PI recounts key numbers independently (see [[T001 A-Share Audit]]) | – |
| Permissions (slide [number withheld]) | Write scope per card; no `git push` by any tool in `proposal/`; credentials only in the macOS keychain ([[Overleaf Sync]]) | – |
| Model choice per role (slide [number withheld], "Which model?") | `priority:` → model tier via `agents/lib.sh` ([[Model Tiers]]) | – |

---
Source: `Lecture Note/Lecture02_SlidesGuest.pdf` slides [number withheld]–[number withheld] (slide [number withheld] read from a rendered image of the chart); `agents/TEAM.md` (intro, Rollen, Ablauf, Overleaf); `AGENTS.md` (Agenten-Team); `review/T002.md` (checksum file name).
