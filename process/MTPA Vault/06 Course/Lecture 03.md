---
tags: [mtpa, course, lecture]
status: reference
updated: 2026-10-14
---

# Lecture [number withheld]: Research Design and Reproducible Workflow

**Date:** 2026-10-09 (week [number withheld]) · **Slides:** `Lecture Note/Lecture03_Slides.pdf` ([number withheld] slides)

Plan (slide [number withheld]): [number withheld] research design · [number withheld] (systematic) literature review · [number withheld] AI-assisted reproducible workflow. Admin (slide [number withheld]): every student or group should book a **one-on-one office hour** to discuss their plan (Tencent Docs sign-up sheet). See [[Course Overview]].

## [number withheld] Research design (slides [number withheld]–[number withheld])

- **Research design** (slide [number withheld]) means planning and executing empirical studies: decisions about sample, treatment, outcome variables and methods for estimating causal effects. Design-based work uses RCTs or quasi-experiments.
- **Leamer ([number withheld]), "Let's take the con out of econometrics"** (slides [number withheld]–[number withheld]): take data seriously; mind the limits of regression; use multiple methods; be transparent about assumptions; focus on design. Since then design has "moved front and center" in empirical micro.
- **Athey & Imbens ([number withheld], JEP)** (slides [number withheld], [number withheld]–[number withheld]): use identification strategies such as RDD, synthetic control, DiD, network methods, and combinations of experimental and observational data.
- **Problems with observational data:**
  - *SUTVA* (slide [number withheld]): a well-defined single treatment and no interference. Easily violated by contamination, spillovers or clustering.
  - *Selection bias and confounding* (slides [number withheld]–[number withheld]): Simpson's paradox with PKU admissions by school (slide [number withheld]); a minimum-wage example where unobserved cost of living confounds the effect on employment (slide [number withheld]).
- **Balancing observables** (slides [number withheld]–[number withheld]): doubly robust methods / **AIPW**. They are consistent if either the outcome model or the propensity model is correctly specified.
- **Internal vs. external validity** (slides [number withheld]–[number withheld]): there is a trade-off. "External validity should receive more emphasis, but without internal validity, little can be learned."
- **After the estimate** (slides [number withheld]–[number withheld]):
  - **Placebo analyses**: a pseudo-outcome or pseudo-population whose true effect is zero. A rejection signals the main analysis may not be credible.
  - **Robustness**: vary sample and specification; Athey & Imbens ([number withheld]) robustness measure. Report both preferred and alternative specifications.
  - **Identification sensitivity**: Andrews, Gentzkow & Shapiro ([number withheld]) link estimates to data moments. Reduced-form models have more transparent identification (omitted-ability example).
- **Conclusion** (slide [number withheld]): take data seriously (clarify population and sample); know the issues with observational data; choose appropriate methods; discuss internal and external validity; run placebo and robustness checks; discuss identification.

## [number withheld] (Systematic) literature review (slides [number withheld]–[number withheld])

- An SLR identifies and evaluates **all** relevant literature on a question through a transparent, replicable process carried out by **at least two researchers independently** (slide [number withheld]). It differs from narrative, scoping and rapid reviews by its explicit methods, low bias risk and comprehensiveness (slide [number withheld]).
- **Seven steps** (slide [number withheld]):
  [number withheld]. Define the research question.
  [number withheld]. Select databases.
  [number withheld]. Define search terms.
  [number withheld]. Merge hits.
  [number withheld]. Apply inclusion and exclusion criteria.
  [number withheld]. Perform the review.
  [number withheld]. Synthesise.
- Question frameworks (slides [number withheld]–[number withheld]): **CIMO** (Context, Intervention, Mechanisms, Outcomes), also CLIP, ECLIPSE, PIFT, PESTEL, SPICE. Questions must be clear, focused, answerable and fixed **before** the search, with inclusion criteria set at this stage.
- Sources (slides [number withheld]–[number withheld]): Web of Science (the instructor's write-up "Conduct literature search at PKU" is on the course website), LitSonar; grey literature (EconBiz, ProQuest) to reduce publication bias.
- Search terms (slides [number withheld]–[number withheld]): blocks of synonyms, related and broader terms; **OR within a block, AND between blocks**; truncation (`*`); keywords vs. subject headings.
- Documentation (slides [number withheld]–[number withheld]): record the database and query date per hit and the number of hits per source. Inclusion criteria are justified and pilot-tested; screen by title/abstract first, then full text. Show the flow in a **PRISMA [number withheld] flow diagram**.

## [number withheld] AI-assisted reproducible workflow (slides [number withheld]–[number withheld])

- Three concepts (slide [number withheld]): **computational reproducibility** (same data, code and procedure: do the numbers reappear?), **robustness** (reasonable alternative choices: does the conclusion survive?), **replicability** (new data: does the finding generalise?).
- "The goal is not flawless code. The goal is inspectable scientific evidence" (slide [number withheld]). A workflow is repeatable; a chat response is not a research artifact (slide [number withheld]).
- **Large-scale AI audit: Schwartz, Andrews & Shapiro, NBER WP [number withheld] ([number withheld])** (slides [number withheld]–[number withheld]). [number withheld] replication packages from AER, QJE, Econometrica, REStud and JPE; [number withheld] flagged. [number withheld] % of discrepancies are only in the last printed digit. In **[number withheld] of [number withheld]** papers, at least one estimate changes by more than [number withheld] % when one influential unit is removed. "Reproduced does not mean robust."
- Definitions (slides [number withheld]–[number withheld]): **independent unit**, e.g. the firm in a firm-year panel (within-firm correlation allowed); **empirical influence function**, the sensitivity of an estimate to one observation or cluster.
- "Reproduction is a necessary checkpoint, not a substitute for a sound research design" (slide [number withheld]).
- **Six-step reproducible workflow** (slides [number withheld]–[number withheld]):
  [number withheld]. **Document the research design**: sample, treatment, outcome, estimator, *decision log*. "AI can help write the research specification; you must choose it." "If the specification is ambiguous, perfectly reproducible code can still reproduce the wrong design."
  [number withheld]. **Track every data input**: source → raw copy (untouched, checksum) → documented transforms → analysis. Public data: save URLs, retrieval dates, licences. Restricted data: document access limits.
  [number withheld]. **Make every step executable**: one entry point (`make all` / `run_all.sh`), the same environment (lock file), no manual edits.
  [number withheld]. **Let AI rebuild the results**: read the README, run in a clean environment, compare with reported values, record commands, versions and discrepancies. "Do not silently change the published target."
  [number withheld]. **Use AI to challenge AI**: Agent A flags, Agent B tries to overturn, verification reruns the original software, the researcher reviews. "An AI-generated discrepancy is a hypothesis to verify, not an accusation."
  [number withheld]. **Stress-test**: influential observations, numerical precision, optimisation starts, alternative specifications. "Expose fragility, not search for a preferred estimate."
- Replication-package layout (slide [number withheld]): `README.md`, `data/raw`, `data/processed`, `code/[number withheld]_clean…`, `outputs/`, `environment.lock`, `run_all.sh`.
- Takeaways (slide [number withheld]): clear documentation; scripts that rebuild all key outputs; a preserved environment; automated comparisons and logs; sensitivity checks and human review. **"AI does the repetitive work. Researchers own the scientific judgment."**

## Relevance for our project

- **Design choices → [[Research Question]], Empirical Design.** Slide [number withheld]'s specification list (sample, treatment, outcome, estimator, decision log) maps onto open PI decisions: developer definition, B-share duplicates (T001 A-Share Audit), treatment timing ([number withheld] vs. [number withheld]), outcomes. The decision log already exists as `state/STATE.md` (Decisions and Open Questions).
- **SUTVA and confounding → Identification Threats.** Spillovers between developers via JVs, and from banks' "two red lines" (Dec [number withheld]), are a SUTVA and confounding concern. COVID-[number withheld] and anticipation of the policy are further confounders. Selection near the thresholds is a selection-bias issue.
- **Placebo tests → Empirical Design.**
  > [!idea] Suggestion (not decided)
  > Candidate placebo checks in the spirit of slide [number withheld]: (a) bunching tests at non-policy thresholds (e.g. [number withheld] % / [number withheld] % liability ratio); (b) a pseudo-policy date in the pre-period (e.g. [number withheld]); (c) outcomes the policy should not affect. Selection and definitions are the PI's decisions.
[firm-specific excerpt withheld in public process copy]
- **Systematic search → [[Literature Overview]], Literature Gap.** The claim that threshold circumvention has "not been systematically studied" rests on searches so far (`PROJEKT_STAND.md` §[number withheld]). An SLR-style protocol (CIMO question, Boolean blocks in English and Chinese, including 经济研究 / 金融研究 / 管理世界, plus a PRISMA count) would make the gap claim defensible.
  > [!idea] Suggestion (not decided)
  > Run the literature search as a documented mini-SLR task card (query log, databases, dates, hit counts), executed by a worker and checked by a reviewer.
- **Reproducible pipeline → Scripts and Environment, Task Workflow.** Raw data are never changed (`data/raw/`, SHA-[number withheld] checks in T001); scripts run with relative paths and a fixed seed (`AGENTS.md` rule [number withheld]). The worker/reviewer split is the "AI challenges AI" step [number withheld] ([[Agent Team Overview]]). The project copy as of 2026-10-14 has no single entry point (`run_all.sh` / Makefile) and no environment lock file. The environment is `Daten/.venv`, described in `PROJEKT_STAND.md` §[number withheld].

---
Source: `Lecture Note/Lecture03_Slides.pdf` slides [number withheld]–[number withheld]; `PROJEKT_STAND.md` §[number withheld], §[number withheld], §[number withheld], §[number withheld]; `AGENTS.md` (Arbeitsregeln); `state/STATE.md`.
