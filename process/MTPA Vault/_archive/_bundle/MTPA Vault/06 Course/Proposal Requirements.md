---
tags: [mtpa, course, proposal]
status: reference
updated: 2026-10-14
---

# Proposal Requirements

What the syllabus requires for the first draft, the referee reports, the final paper and the response to reviewers. Status of our own draft: [[Proposal Outline]]. Deadlines: [[Deliverables and Deadlines]].

## Format (syllabus pp. [number withheld]–[number withheld])

| Item | First draft | Final paper |
|---|---|---|
| Length | **[number withheld]–[number withheld] pages** | **[number withheld]–[number withheld] pages** |
| Line spacing | [number withheld] | [number withheld] |
| Margins | [number withheld] inch | [number withheld] inch |
| Font | [number withheld]pt Times New Roman | [number withheld]pt Times New Roman |
| Abstract | ≤ [number withheld] words, may be single-spaced | (not restated) |
| Bibliography | single-spaced | (not restated) |
| Extra | – | Changes since the draft tracked or clearly marked |

> [!info] Implementation in `proposal/main.tex`
> The preamble uses `\documentclass[[number withheld]pt]{article}`, `geometry` with `margin=[number withheld]in`, `\onehalfspacing`, and Times via `newtxtext`/`newtxmath`. The abstract and bibliography sit in `singlespace`. This is task [[T002 LaTeX Skeleton]]. The file uses `a4paper`; the syllabus names no paper size.

## Required sections of the first draft (syllabus p. [number withheld])

| # | Section | What it must contain |
|---|---|---|
| [number withheld] | **Title page** | Abstract of **≤ [number withheld] words** (may be single-spaced); **[number withheld]–[number withheld] keywords** summarising the research |
| [number withheld] | **Introduction** | In **at most the first three paragraphs**: (a) research question and proposed methodology; (b) motivation for the study; (c) why the research is important and how it contributes to the literature |
| [number withheld] | **Related literature** | A **focal paper** (or a few) used as model/benchmark for one's own paper, and how one's work relates to it |
| [number withheld] | **Theoretical model or framework** | A theoretical model or framework; "you may use a graph to show the framework if possible" |
| [number withheld] | **Empirical model** | Write down the equation(s) and estimation strategy. *Reduced form:* explain how the causal effect of interest is identified and **list potential confounders**. *Structural:* explain how the policy-invariant deep parameters are identified |
| [number withheld] | **Context and data** | Institutional background; data source(s); **summary statistics of key variables**; and in particular **a descriptive table that gives insight into the question** |
| [number withheld] | **Preliminary analysis** | At minimum, **analyse** the summary statistics; preliminary estimates are a plus. Students may check with the instructor what counts as acceptable progress (especially for structural proposals) |
| [number withheld] | **Bibliography** | Single-spaced |
| [number withheld] | **AI-use appendix** (if applicable) | See below |

> [!warning] Two small wording gaps in project files
> - `PROJEKT_STAND.md` §[number withheld] says Preliminary Analysis needs "at least summary statistics". The syllabus says students must at least **analyse** them, not merely present them.
> - The TODO in `proposal/main.tex` under Theoretical Framework says the requirements "list no further detail". The syllabus does add one hint: a graph may be used to show the framework.

### How a reader will judge the introduction (syllabus p. [number withheld])

The syllabus asks reviewers to check, and authors to answer, the following in the introduction: the primary question or hypothesis; why it is interesting and how it contributes; the data used and whether they are unique or representative; the intuition behind the empirical test; and the findings. While reading further, reviewers ask whether the paper can identify the claimed effect, whether the results justify the conclusions (including external validity and heterogeneity), and whether the findings are supported by theory.

## AI-use appendix (syllabus pp. [number withheld] and [number withheld])

Required for any **substantive** AI use (in this project: certainly applicable, see [[Agent Team Overview]]). Each entry must state:

- [ ] the AI-assisted **tool(s)**
- [ ] **date(s)**
- [ ] **purpose(s)**
- [ ] **representative prompts or tasks**
- [ ] **how the output was checked**
- [ ] **how it was modified or rejected**

Pure spelling or grammar checks that generate no substantive content need not be disclosed. The appendix table in `proposal/main.tex` has exactly these six columns (Date, Tool, Purpose, Representative prompt or task, How checked, Modified or rejected) and is fed from `AI_USAGE_LOG.md`. See [[AI Usage Log]].

## Grading standard (Lecture [number withheld], slide [number withheld])

Grading follows **Bloom's taxonomy**. Only the higher levels (Analyze: draw connections; Evaluate: justify a stand; Create: produce original work) reach **> [number withheld]**. Remember, Understand and Apply stay **≤ [number withheld]**. For the proposal this means pure description of the policy and data is not enough: it needs our own analysis and evaluation, e.g. the off-balance-sheet test in [[Empirical Design]] and the gap argument in [[Literature Gap]].

> [!warning] Unverified
> The exact level where the >[number withheld] / ≤[number withheld] bracket splits is not sharply marked on the slide graphic (see [[Course Overview]]).

## Peer review / referee reports (syllabus pp. [number withheld]–[number withheld])

- The instructor acts as **editor**. He assigns each student **two anonymised proposals** (names and identifying information removed), matched to the reviewer's area where possible. An assignment outside one's expertise is possible and meant as a learning opportunity.
- Each reviewer writes **detailed written comments** on both proposals. In turn, two classmates review our draft.
- The instructor forwards anonymised reports to authors **with his own "two cents"**. He may present selected proposals and reports in class.
- Reading guide for reviewers: see the questions under "How a reader will judge the introduction" above (syllabus p. [number withheld]).

> [!warning] Confidentiality: binding for every agent
> Peer-review material must be treated as confidential. Another student's unpublished proposal or referee report may **not** be uploaded to any external AI service (syllabus p. [number withheld]). `AGENTS.md` rule [number withheld]: such files are not read, summarised or cited by any tool, even on request, and they do not belong in the project folder. It follows that the agent team must never be given the assigned proposals or our own draft referee reports on them. See [[Safeguards]].

## Final paper and response to reviewers (syllabus p. [number withheld])

**Final proposal / report / paper**
- A revised version that addresses all feedback from the instructor and the two referees that the author finds appropriate. It may be extended into a report or paper.
- **Track or clearly mark changes** since the first submission.
- [number withheld]–[number withheld] pages, same format. **The literature review must be more thorough than in the draft.**
- If submitted as an empirical report or paper: empirical results fully presented and analysed.
- If submitted as a proposal: a **detailed data-access plan, identification strategy, planned analyses and appropriate preliminary evidence**.

**Response to reviewers** (separate file)
- [ ] Point-by-point response to **each** comment
- [ ] For each: state whether you **agree or disagree**, and why
- [ ] Describe the **corresponding revision**, or justify why no change was made

The planned folder is `final/` (`AGENTS.md`, Ordner).

---
Source: `MTPA_Syllabus_Autumn26-27.pdf` pp. [number withheld]–[number withheld]; `Lecture01_Slides.pdf` slide [number withheld]; `AGENTS.md` (Abgaben, Arbeitsregeln [number withheld] and [number withheld]); `PROJEKT_STAND.md` §[number withheld]; `proposal/main.tex`; `AI_USAGE_LOG.md` (header).
