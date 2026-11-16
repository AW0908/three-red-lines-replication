---
tags: [mtpa, course, hub]
status: reference
updated: 2026-10-14
---

# Course Overview

**Modern Tools for Policy Analysis (MTPA)**, Peking University, Autumn [number withheld][number withheld]. A problem-driven course on designing, implementing and communicating credible policy research. It runs from a policy question to a target estimand, research design, estimation strategy, diagnostics and sensitivity analysis, and policy interpretation. The methods covered are experiments, quasi-experiments, IV, causal ML, modern DiD and RDD, structural counterfactuals and cost-benefit analysis. The course also stresses reproducibility and the **responsible use of AI** (syllabus p. [number withheld]).

> [!info] Binding source
> The syllabus (`MTPA_Syllabus_Autumn26-27.pdf`) is the binding source for all rules and dates. If it conflicts with any project file, the syllabus wins (`AGENTS.md`, section "Kurs"). Deadlines: [[Deliverables and Deadlines]]. Proposal rules: [[Proposal Requirements]].

## Key facts

| Item | Value |
|---|---|
| Course ID | [number withheld] |
| Instructor | Castiel Chen Zhuang (庄晨), <email-redacted> |
| TA | Jiajun Chen (陈家骏), <email-redacted> |
| Lecture | Friday [number withheld]:[number withheld]–[number withheld]:[number withheld], Teaching Building No. [number withheld], Classroom [number withheld] |
| Office / office hour | Room [number withheld], School of Economics; Friday [number withheld]:[number withheld]–[number withheld]:[number withheld] or by appointment |
| One-on-one meeting | Each student (or group) should book a one-on-one office hour to discuss their plan. The sign-up sheet is on Tencent Docs (Lecture [number withheld], slide [number withheld]) |
| Course folder | PKU Cloud Disk (北大网盘), which holds announcements, lecture notes and readings. Do not share the link or passcode (syllabus p. [number withheld]) |
| Software | Anaconda (Python), R + RStudio, Stata (ask the TA for access); install by the second lecture (syllabus p. [number withheld]). Lecture [number withheld] slide [number withheld] also lists CC Switch |
| Exam | None. Grading is one research project in stages ([[Deliverables and Deadlines]]) |
| Grading level | Individual, unless stated otherwise (syllabus p. [number withheld]) |

> [!todo] Meet the instructor
> `PROJEKT_STAND.md` §[number withheld] item [number withheld] plans to discuss the topic with Zhuang after a Friday lecture (office hour Fri [number withheld]:[number withheld]–[number withheld]:[number withheld], Room [number withheld]). The target is to agree the topic by [number withheld] (Timeline).

## Learning objectives (syllabus pp. [number withheld]–[number withheld])

- Translate a policy question into a target population, treatment, outcome, comparison and causal estimand. See [[Research Question]].
- Choose an experimental, quasi-experimental or structural design and state its identifying assumptions. See Empirical Design and Identification Threats.
- Implement methods in reproducible code, with diagnostics and sensitivity analyses. See Scripts and Environment.
- Distinguish prediction from causal estimation, and use treatment-effect heterogeneity responsibly.
- Evaluate internal validity, external validity, welfare and implementation constraints.
- Use AI tools transparently while independently verifying evidence, citations, code and results. See [[Agent Team Overview]].

## Course arc (syllabus p. [number withheld], "tentative")

| Week | Date | Topic | Note | Relevance for the project |
|---|---|---|---|---|
| [number withheld] | 2026-09-11 | Overview: from policy question to policy evidence | [[Lecture [number withheld]]], [[Weekly Reading - Week [number withheld]]] | Framing a policy problem |
| [number withheld] | 2026-09-18 | AI-assisted and data-intensive research | [[Lecture [number withheld]]], [[Lecture [number withheld] Guest - AI Agent Organization]] | Basis of the [[Agent Team Overview]] |
| [number withheld] | 2026-09-25 | No class (Mid-Autumn Festival) | – | – |
| [number withheld] | 2026-10-02 | No class (National Day Holiday) | – | – |
| [number withheld] | 2026-10-09 | Research design and reproducible workflow | [[Lecture [number withheld]]] | Design, placebo tests, reproducibility |
| [number withheld] | 2026-10-16 | Experiment design and implementation ([number withheld]) | – | – |
| [number withheld] | 2026-10-23 | Experiment design and implementation ([number withheld]) | – | – |
| [number withheld] | 2026-10-30 | IV and natural experiments for impact evaluation | – | – |
| [number withheld] | 2026-11-06 | Theory-guided policy evaluation | – | Input for the Theoretical Framework section |
| [number withheld] | 2026-11-13 | DID: basics and recent advances | – | Core method: dose-response DiD, event study (Empirical Design) |
| [number withheld] | 2026-11-20 | RDD: basics and recent advances | – | Threshold logic, related to bunching at the red lines |
| [number withheld] | 2026-11-27 | Causal ML and policy learning | – | **First draft due (week [number withheld])** |
| [number withheld] | 2026-12-04 | Student presentations ([number withheld]) | – | Presentation |
| [number withheld] | 2026-12-11 | Student presentations ([number withheld]) | – | Presentation; **referee reports due (week [number withheld])** |
| [number withheld] | 2026-12-18 | Structural demand estimation | – | – |
| [number withheld] | 2026-12-25 | Counterfactuals and cost-benefit analysis | – | **Final paper + response to reviewers due (week [number withheld])** |

University calendar (Lecture [number withheld], slide [number withheld]): final exam preparation and exams Dec [number withheld] – Jan [number withheld]; winter holiday Jan [number withheld] – Feb [number withheld].

> [!info] Lecture numbering vs. weeks
> Lecture numbers count only weeks with class: Lecture [number withheld] = week [number withheld], Lecture [number withheld] = week [number withheld], Lecture [number withheld] = week [number withheld] (dated [number withheld] October [number withheld] on its title slide).

## Grading logic

| Component | Weight |
|---|---|
| In-class participation and presentation | [number withheld] % |
| First draft of research proposal | [number withheld] % |
| Two peer review / referee reports | [number withheld] % |
| Final proposal / report / paper | [number withheld] % |
| Responses to reviewers | [number withheld] % |

(Syllabus p. [number withheld]; Lecture [number withheld], slide [number withheld].)

- **Journal-style pipeline.** Draft → two anonymous peer referee reports, with the instructor acting as "editor" and adding his own comments → revised final paper with tracked changes plus a point-by-point response (syllabus pp. [number withheld]–[number withheld]).
- **Bloom's taxonomy (Lecture [number withheld], slide [number withheld]).** The upper levels (Create, Evaluate, Analyze) are bracketed as ">[number withheld]"; the lower levels as "≤[number withheld]". In practice, a score above [number withheld] requires your own analysis, evaluation or new work, not description alone (`PROJEKT_STAND.md` §[number withheld]).
  > [!warning] Unverified
  > The exact cut-off level on the slide graphic is not sharply marked. The reading above (top three levels) is an interpretation of the slide.
- **Participation** covers preparation (readings done before class), attendance and involvement. There may be random in-class quizzes with prizes. Signing in for someone else counts as cheating (syllabus p. [number withheld]).
- **Extensions** must be requested at least one week in advance (syllabus p. [number withheld]).
- **Study groups** of [number withheld]–[number withheld] are encouraged. If the class has more than [number withheld] students, a group presentation with a shared grade may be allowed (syllabus p. [number withheld]).

## AI policy (syllabus p. [number withheld]): governs the agent team

> [!warning] This policy is binding for every agent in the project
> `AGENTS.md` turns these rules into the project's working rules [number withheld]–[number withheld]. The [[Agent Team Overview]] and Safeguards put them into practice.

**Allowed** (unless an assignment says otherwise): brainstorming, developing search strategies, language editing, coding and debugging, explaining unfamiliar methods, and feedback on drafts.

**Responsibility.** The student is responsible for *every* claim, citation, equation, interpretation, empirical result and line of code. AI-generated citations must be checked against the original source. AI output must never be cited in place of the underlying evidence.

**Disclosure.** Any substantive AI use requires an **AI-use appendix** stating the tool, date, purpose, representative prompts or tasks, how the output was checked, and how it was modified or rejected. Pure spelling or grammar checks are exempt. See AI Usage Log and [[Proposal Requirements]].

**Prohibited:**
- submitting unverified AI content as one's own analysis;
- **fabricating references, data, results or quotations**;
- using AI in activities designated AI-free;
- **uploading confidential data or another student's unpublished proposal or referee report to an external AI service**. Peer-review material is confidential.

**Enforcement.** Suspected misuse is judged on the research process, version history, code and results, source verification, and the student's ability to explain and defend the work. AI-detection scores alone are not proof.

**Honor code (syllabus p. [number withheld]).** AI tools may **not** be listed as authors or co-authors. Plagiarism includes presenting AI content in violation of the policy. Penalty: zero for the assignment, possible course failure and disciplinary action.

### What this means for the agent team

| Syllabus rule | Implementation in the project |
|---|---|
| Student responsible for every claim | Human PI (Anton) approves plans and accepts results (Role - PI) |
| Verify citations / no fabrication | `AGENTS.md` rule [number withheld]; unverified facts are marked as such (Safeguards) |
| Confidential peer material | `AGENTS.md` rule [number withheld]: no tool reads, summarises or cites other students' proposals or referee reports. These files never enter the project folder |
| AI-use appendix | `AI_USAGE_LOG.md` → appendix table in `proposal/main.tex` (AI Usage Log) |
| Process and version history as evidence | Task cards, review reports, `state/runs.log`, Git history of `proposal/` (Task Workflow, Run Log) |
| Reproducible code | `AGENTS.md` rule [number withheld]: scripts, fixed seed, relative paths (Scripts and Environment) |

## Recommended resources (syllabus p. [number withheld])

No required texts. Recommended: Angrist & Pischke ([number withheld]) *Mostly Harmless Econometrics*; Bardach & Patashnik ([number withheld]) *A Practical Guide for Policy Analysis*, [number withheld]th ed.; Cameron & Trivedi ([number withheld]) *Microeconometrics Using Stata*, [number withheld]nd ed.; Cunningham ([number withheld]) *Causal Inference: The Remix*, [number withheld]nd ed.; Deaton ([number withheld]); Gertler et al. ([number withheld]) *Impact Evaluation in Practice*; Train ([number withheld]); Wager ([number withheld], draft). Online: Gentzkow & Shapiro ([number withheld]) "Code and data for the social sciences"; NBER videos; Nikolov ([number withheld]) writing tips; Shapiro ([number withheld]) on applied micro talks.

## Related notes

[[[number withheld] Home]] · [[Deliverables and Deadlines]] · [[Proposal Requirements]] · [[Proposal Outline]] · Timeline

---
Source: `MTPA_Syllabus_Autumn26-27.pdf` pp. [number withheld]–[number withheld]; `Lecture01_Slides.pdf` slides [number withheld], [number withheld]–[number withheld], [number withheld], [number withheld]; `Lecture Note/Lecture03_Slides.pdf` slide [number withheld]; `AGENTS.md` (Kurs, Arbeitsregeln); `PROJEKT_STAND.md` §[number withheld], §[number withheld].
