---
tags: [mtpa, proposal]
status: open
updated: 2026-10-14
---

# Proposal Outline

Maps each required section of the first draft ([[Proposal Requirements]]) to:
- its current state in `proposal/main.tex`;
- the project content that will go there;
- what blocks it.

Due ≈ **2026-11-27, week [number withheld], preliminary** ([[Deliverables and Deadlines]]).

> [!info] Source of truth
> The draft lives in `proposal/main.tex`, a Git clone of the Overleaf project, synced only via `agents/overleaf.sh` ([[Overleaf Sync]]). This note is a planning snapshot as of 2026-10-14. Task status is in `tasks/T###.md` ([[Task Board]]); decisions are in `state/STATE.md` ([[Decisions and Open Questions]]).

## Current state of `proposal/main.tex`

- The skeleton exists, from task [[T002 LaTeX Skeleton]]. The reviewer verdict is **REWORK**: criteria [number withheld]–[number withheld] are met (it compiles; format, section order and TODOs are correct). Criterion [number withheld] (no changes outside the write scope) could not be verified, because files outside `proposal/` changed during the task and their origin is undocumented. The reviewer states the LaTeX skeleton itself needs no revision (`review/T002.md`).
- **Every section is a placeholder.** It contains only `% TODO(PI): …` comments, a placeholder abstract and keywords line, a commented-out bibliography (`% TODO: activate with the first \cite`), and an empty AI-use table. There is no substantive text, citation or number.
- Working title, marked `TODO(PI)`: *"Real or Cosmetic Deleveraging? China's Three Red Lines and Property Developers' Balance Sheets"*.
- `proposal/references.bib` contains only a comment line (checked in the project folder on 2026-10-14).

## Section map

| # | Required section (syllabus p. [number withheld]) | Status in `main.tex` | Content source in the project | Blocking dependencies |
|---|---|---|---|---|
| [number withheld] | Title page: abstract ≤ [number withheld] words, [number withheld]–[number withheld] keywords | Placeholder; working title marked TODO(PI) | [[Research Question]] | Final question and estimand (PI, target [number withheld].); write last |
| [number withheld] | Introduction: Q + method, motivation, contribution in ≤ [number withheld] paragraphs | [number withheld] TODO(PI) lines | [[Research Question]], [[Three Red Lines Policy]], [[Literature Gap]], [[Empirical Design]] | Final question; gap claim verified ([[Literature Overview]]) |
| [number withheld] | Related literature, incl. focal paper(s) | TODO(PI) | [[Literature Overview]], [[Ma and Xie [number withheld]]], [[Zheng Dong Jiang SSRN]], [[Shi Hao Xie Kim [number withheld]]], [[Chen Du Ma [number withheld]]], [[FRL [number withheld] Spillover Volatility]], [[Kleven [number withheld] Bunching]], [[Press Evidence Off-Balance-Sheet Debt]], [[Literature Gap]] | Full texts not yet read; focal paper not chosen (PI); Ma & Xie abstract not retrieved; FRL title only; Kleven citation unverified; search for prior bunching/window-dressing studies incl. Chinese journals open |
| [number withheld] | Theoretical framework (graph allowed) | TODO(PI) | [[Three Red Lines Policy]] (thresholds, categories, caps), [[Variables and Metrics]] | No framework drafted in the sources yet; caps of [number withheld]/[number withheld]/[number withheld] % unverified (primary source needed); week [number withheld] lecture "Theory-guided policy evaluation" ([number withheld].) |
| [number withheld] | Empirical model: equations, identification, confounders | [number withheld] TODO(PI) lines | [[Empirical Design]] (bunching, dose-response DiD, adjusted leverage, event study), [[Identification Threats]] (COVID-[number withheld], banks' "two red lines", anticipation, selection, survivorship, small N, SOE vs. private) | Treatment date ([number withheld] vs. [number withheld]) and outcomes to be fixed by the PI; week [number withheld] DiD lecture ([number withheld].); SOE/private ownership data ([[Wind Visit [number withheld] Checklist]]) |
| [number withheld] | Context and data: institutional background, sources, summary statistics, **descriptive table** | [number withheld] TODO(PI) lines | [[Three Red Lines Policy]], [[Data Overview]], [[AKShare EastMoney]], [[Wind Terminal]], [[Delisted Developers]], [[Field Coverage]], [[Data Issues]] | Unified panel and red-line metrics ([[T004 Firm Panel and Red-Line Metrics]]); HK raw data audit ([[T003 HK Raw Data Audit]]); delisted-firm data (`fetch_delisted.py` run, second Wind visit); developer definition and B-share handling (PI, from [[T001 A-Share Audit]]) |
| [number withheld] | Preliminary analysis: at least *analyse* summary statistics; ideally first estimates | [number withheld] TODO(PI) lines | [[T005 Descriptives and Bunching Plots]], [[Empirical Design]] | **[[T004 Firm Panel and Red-Line Metrics]] and [[T005 Descriptives and Bunching Plots]]**; first DiD estimate after the panel exists (target [number withheld].) |
| [number withheld] | Bibliography (single-spaced) | Commented out; `references.bib` empty | [[Literature Overview]] | Every entry verified at the original source (`AGENTS.md` rule [number withheld]); activate with the first `\cite` |
| [number withheld] | AI-use appendix | Empty six-column table, `% source: AI_USAGE_LOG.md` | [[AI Usage Log]], [[Agent Team Overview]] | Translate German log entries to English; keep the log current until submission |

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Status checklist per section

### [number withheld]. Title page
- [x] Working title in place (marked TODO(PI))
- [ ] Title confirmed by PI
- [ ] Abstract ≤ [number withheld] words (write last)
- [ ] [number withheld]–[number withheld] keywords

### [number withheld]. Introduction
- [ ] Para [number withheld]: research question and method ([[Research Question]], [[Empirical Design]])
- [ ] Para [number withheld]: motivation (policy relevance, [[Three Red Lines Policy]], [[Press Evidence Off-Balance-Sheet Debt]])
- [ ] Para [number withheld]: contribution ([[Literature Gap]])
- [ ] Gap claim checked against a documented search

### [number withheld]. Related literature
- [ ] Full texts of candidate focal papers read
- [ ] Focal paper(s) chosen by PI and the relation to them stated
- [ ] Unverified items resolved or flagged ([[Ma and Xie [number withheld]]], [[FRL [number withheld] Spillover Volatility]], [[Kleven [number withheld] Bunching]])
- [ ] Search for prior bunching / window-dressing studies on the red lines, incl. Chinese journals (经济研究, 金融研究, 管理世界)

### [number withheld]. Theoretical framework
- [ ] Framework chosen by PI (a graph is allowed)
- [ ] Policy details (categories, caps, dates, pilot firms) verified at primary source ([[Three Red Lines Policy]])

### [number withheld]. Empirical model
- [ ] Bunching specification (excess mass, Kleven [number withheld]) written down
- [ ] Dose-response DiD equation (firm and half-year FE, firm-clustered SEs) written down
- [ ] Treatment definition and date fixed by PI
- [ ] Identification argument and confounder list ([[Identification Threats]])
- [ ] Placebo and robustness plan ([[Lecture [number withheld]]])

### [number withheld]. Context and data
- [ ] Institutional background ([[Three Red Lines Policy]])
- [ ] Data sources and sample construction step by step ([[Data Overview]], [[Delisted Developers]])
- [ ] Summary statistics of key variables ([[Variables and Metrics]])
- [ ] **Descriptive table** giving insight into the question (e.g. red-line status before vs. after the policy)

### [number withheld]. Preliminary analysis
- [ ] Panel built ([[T004 Firm Panel and Red-Line Metrics]])
- [ ] Descriptives and bunching histograms ([[T005 Descriptives and Bunching Plots]])
- [ ] Written analysis of the summary statistics
- [ ] Optional: first DiD / event-study estimate

### [number withheld]. Bibliography
- [ ] `references.bib` filled with verified entries only
- [ ] `\bibliography` activated

### [number withheld]. AI-use appendix
- [ ] Table filled from `AI_USAGE_LOG.md` (English)
- [ ] All six required fields per entry (tool, date, purpose, prompt/task, how checked, modified/rejected)

### Format and submission
- [ ] [number withheld]–[number withheld] pages; [number withheld] spacing, [number withheld]-inch margins, [number withheld]pt Times (preamble done in T002)
- [ ] Compiles via `agents/overleaf.sh check`
- [ ] Submission date and channel confirmed with the instructor ([[Deliverables and Deadlines]])

> [!idea] Suggestion (not decided)
> Draft section [number withheld] (institutional background, data sources) before T004 finishes: it depends mainly on verified policy facts and on data documentation that already exists ([[Data Overview]]). Sections [number withheld] and [number withheld] could run in parallel with the data work. Sequencing is the PI's decision; see [[Timeline]].

---
Source: `proposal/main.tex`; `tasks/T002.md`; `review/T002.md`; `MTPA_Syllabus_Autumn26-27.pdf` pp. [number withheld], [number withheld]; `PROJEKT_STAND.md` §[number withheld], §[number withheld], §[number withheld], §[number withheld], §[number withheld]; `AGENTS.md` (Abgaben, Arbeitsregeln).
