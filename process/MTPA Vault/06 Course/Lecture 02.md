---
tags: [mtpa, course, lecture]
status: reference
updated: 2026-10-14
---

# Lecture [number withheld]: AI-assisted and Data-intensive Research

Hub: [[Course Overview]]

**Date:** 2026-09-18 (week [number withheld]) · **Slides:** `Lecture Note/Lecture02_Slides.pdf` ([number withheld] slides) · **Guest part:** [[Lecture [number withheld] Guest - AI Agent Organization]]

Plan (slide [number withheld]): [number withheld] guest lecture on AI-assisted social science research ([[Lecture [number withheld] Guest - AI Agent Organization]]) · [number withheld] additional tips for using AI in research · [number withheld] using big data in research.

## [number withheld] Additional tips for using AI in research (slides [number withheld]–[number withheld])

**Core message:** "We are transitioning from prompt engineering to agent-based workflow building" (slide [number withheld]). Why it matters (slide [number withheld]): the distance from idea to result shrinks. Raw AI ideas are not always compelling, but AI *execution* is. Researchers, referees and advisors need calibration about what AI can actually do.

**Prompt engineering (slides [number withheld]–[number withheld])**
- Zero-shot prompts have four parts: instructions, context, input data, output indicator. Few-shot prompts add input-output examples.
- Ten principles: ([number withheld]) clear and specific; ([number withheld]) decompose complex questions; ([number withheld]) try different phrasings; ([number withheld]) set a role or scope; ([number withheld]) request stepwise explanation; ([number withheld]) ask for clarification, and beware **"fake literature"** ("please offer real citations and data sources"); ([number withheld]) avoid confirmation bias by not putting your own opinion in the prompt (ask about positive *and* negative contributions); ([number withheld]) constrain format and structure; ([number withheld]) use few-shot prompting; ([number withheld]) keep thinking critically.

**Claude Code and the AI ladder (slides [number withheld]–[number withheld])**
- AI ladder (slide [number withheld]): level [number withheld] = copy-paste from a chatbot … level [number withheld] = dedicated coding agents (Claude Code, Codex CLI) … level [number withheld] = "orchestrate teams of agents in containers".
- **The context window is "the single most important concept"** (slides [number withheld]–[number withheld]). The whole history is re-sent every turn, and performance degrades as context grows. "Context engineering is the new prompt engineering."
- **Intentional compaction** (slides [number withheld]–[number withheld]): write progress to files (e.g. `progress.md`, `plan.md`), then start fresh and read them. After [number withheld]+ turns start a new session; work in focused [number withheld]–[number withheld]-turn chunks. "Files persist, context doesn't."
- Data privacy (slides [number withheld]–[number withheld]): file contents read during a session are sent to the API. Keep proprietary or IRB-covered data walled off, and keep credentials out of files the agent reads.
- Getting started (slide [number withheld]): be specific; iterate but don't argue; correct early; **trust but verify**, especially for edge cases in statistical methods.

**Worked example: empty folder to publication figure (slides [number withheld]–[number withheld]).** US homeownership by age from Census/FRED. The agent recovered from dead ends (a [number withheld] error, a missing FRED key) by itself and wrote `download_data.py`, `clean_data.py` and `make_figures.py`. Lessons (slide [number withheld]):
- let the agent do data acquisition;
- describe the figure, not the code;
- iterate in small steps;
- **always generate scripts, not just outputs**;
- **"The judgement is still yours."**

## [number withheld] Using big data in research (slides [number withheld]–[number withheld])

- Definition (slide [number withheld]): data too large or complex for traditional processing, characterised by volume, velocity and variety.
- **Scanner data** (slides [number withheld]–[number withheld]): Circana, NielsenIQ, Kantar. Disaggregate price and quantity, the choice environment, and panel structure. Used in IO, marketing and increasingly public/health/macro economics.
- **Search engine data** (slides [number withheld]–[number withheld]): Google Trends (relative volumes only); **Baidu Index** (a monotonic mapping to actual searches, finer regional detail in China, no direct download).
- Other sources (slides [number withheld]–[number withheld]): live-streaming data (Kuaishou; the instructor's own work via web spiders); Baidu Index for the end of Zero-COVID (a three-phase DiD, slide [number withheld]); **Uber data** (Chen et al. [number withheld], JPE), including a very detailed step-by-step construction of the analysis sample (slides [number withheld]–[number withheld]). "A good paper has very detailed (step-by-step) description of how the final study sample is generated" (slide [number withheld]).
- Further reading (slide [number withheld]): Beraja et al. ([number withheld]); Einav & Levin ([number withheld]); Currie et al. ([number withheld]).

## Relevance for our project

- **Agent workflow → [[Agent Team Overview]].** The project sits at roughly ladder level [number withheld]–[number withheld]: Claude Code as Co-PI, Codex and Antigravity as worker and reviewer, coordinated via files. The design follows the guest lecture ([[Lecture [number withheld] Guest - AI Agent Organization]]).
- **Context management → Task Workflow.** Writing state to files (`state/STATE.md`, task cards, `PROJEKT_STAND.md`) and starting each worker call fresh is the "intentional compaction" pattern of slides [number withheld]–[number withheld]. The text worker is called "without chat history" (`agents/TEAM.md`).
- **"Fake literature" → [[Literature Overview]], Safeguards.** Every citation must be verified at the source. Several items in the literature list are still marked unverified (e.g. Kleven [number withheld] Bunching, FRL [number withheld] Spillover Volatility).
- **Scripts, not outputs → Scripts and Environment.** Analysis results come from scripts in `code/` with outputs in `output/` (`AGENTS.md` rule [number withheld]), e.g. T001 A-Share Audit.
- **Step-by-step sample construction → [[Data Overview]], Empirical Design.** The Uber example sets the bar for how we document the developer sample: A-shares, HK, delisted firms, removal of B-shares and non-developers (Delisted Developers, Data Issues).
- **Privacy.** Wind exports and PKU-licensed data: check licence terms before sharing with external AI services.
  > [!idea] Suggestion (not decided)
  > Add a line to `AGENTS.md` or Safeguards on whether Wind exports may be read by cloud agents. Licensing is not addressed in the current sources. PI decision.

---
Source: `Lecture Note/Lecture02_Slides.pdf` slides [number withheld]–[number withheld]; `agents/TEAM.md` (Rollen); `AGENTS.md` (Arbeitsregeln).
