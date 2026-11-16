---
tags: [mtpa, task, proposal]
status: in-progress
updated: 2026-10-14
---

# T002 LaTeX Skeleton

> [!warning] Status `REWORK` — but the LaTeX is fine
> The reviewer (Codex) found criteria **[number withheld]–[number withheld] evidenced as met**. The only open point is **criterion [number withheld]** ("nothing other than `proposal/main.tex` and `proposal/references.bib` was changed"): the review script listed [number withheld] files modified outside the write scope during the task, and their attribution to *other* actors could not be independently evidenced. A worker write outside `proposal/` is explicitly **not** shown either. The reviewer: "the LaTeX skeleton needs no revision for this".

| Field | Value |
|---|---|
| ID | T002 |
| Title (original) | LaTeX-Grundgerüst des Research Proposal (LaTeX skeleton of the research proposal) |
| Status | `REWORK` |
| Priority | `normal` |
| Worker | Claude (`claude`, `sonnet`) → [[Role - Writer]] |
| Reviewer | Codex (`codex`, medium, read-only) → [[Role - Independent Reviewer]] |
| Created | 2026-10-13 |

## Goal

Turn `proposal/main.tex` into a compilable skeleton with the format and all mandatory parts the syllabus requires for the first draft. No substantive text yet; it fixes where which content will go later. → [[Proposal Requirements]], [[Proposal Outline]]

## Inputs (read-only)

- `AGENTS.md` – format rules and mandatory parts of the proposal
- `PROJEKT_STAND.md` – topic and working research question (§[number withheld])
- `proposal/main.tex` – previous state from Overleaf

## Write scope

- `proposal/main.tex`
- `proposal/references.bib`

## Steps (summary)

[number withheld]. Preamble for pdfLaTeX: `article` [number withheld]pt; `geometry` [number withheld]-inch margins; `setspace` `\onehalfspacing`; Times via `newtxtext`/`newtxmath`; `amsmath`, `graphicx`, `booktabs`, `natbib`, `hyperref`.
[number withheld]. Title page: working title "Real or Cosmetic Deleveraging? China's Three Red Lines and Property Developers' Balance Sheets" marked `% TODO(PI): working title`; author Anton Wilhelmi; course line "Modern Tools for Policy Analysis, Peking University, Autumn [number withheld]"; single-spaced `abstract` with placeholder; `Keywords:` line with placeholder; page break.
[number withheld]. Sections in this order: Introduction; Related Literature; Theoretical Framework; Empirical Model; Context and Data; Preliminary Analysis.
[number withheld]. Each section only `% TODO(PI): ...` comments listing what the syllabus requires; Introduction additionally the three first paragraphs (question and method, motivation, contribution).
[number withheld]. Bibliography prepared single-spaced; `\bibliographystyle{plainnat}` and `\bibliography{references}` commented out with `% TODO: activate with the first \cite`.
[number withheld]. `proposal/references.bib` with one comment line, no entries.
[number withheld]. `\appendix` with section "AI-Use Statement": empty `booktabs` table (Date, Tool, Purpose, Representative prompt or task, How checked, Modified or rejected), comment `% source: AI_USAGE_LOG.md`.

## Acceptance criteria (summarised) and review result

| # | Criterion | Review (2026-10-13 20:21) |
|---|---|---|
| [number withheld] | Compiles with pdfLaTeX without errors (`agents/overleaf.sh check`) | met — `review/T002_latex.txt` reports a clean build (from `candidate.sh`) |
| [number withheld] | Preamble: `article` [number withheld]pt, [number withheld]-inch margins, `\onehalfspacing`, `newtxtext` | met |
| [number withheld] | Six sections in order, then bibliography block, then AI-Use appendix | met |
| [number withheld] | Title page: title, author, single-spaced abstract placeholder (≤ [number withheld] words), keywords line ([number withheld]–[number withheld], none invented) | met |
| [number withheld] | No substantive text, no project number, no `\cite`, no `.bib` entry | met |
| [number withheld] | Each section ≥ [number withheld] `% TODO(PI):`, covering mandatory content from `AGENTS.md`, nothing invented | met |
| [number withheld] | Title marked as working title, no unescaped special characters | met |
| [number withheld] | Nothing changed except the two files | **not checkable** regarding attribution to T002 |

## Timeline

| Time (2026-10-13) | Event | Source |
|---|---|---|
| – | Card created (`PLAN`) | `tasks/T002.md` |
| [number withheld]:[number withheld] | `APPROVED` by PI | `state/approvals.log` |
| [number withheld]:[number withheld] | Worker run: claude sonnet | `state/runs.log` |
| [number withheld]:[number withheld] | Worker run: claude sonnet | `state/runs.log` |
| [number withheld]:[number withheld] | Worker run: claude sonnet | `state/runs.log` |
| (between) | Co-PI feedback after first version: format, order and compile OK; TODOs too generic → replace by concrete mandatory items from `PROJEKT_STAND.md` §[number withheld] | `tasks/T002.md`, Rückmeldung Co-PI |
| [number withheld]:[number withheld] | Review [number withheld]: codex medium → **REWORK** (per Co-PI note: missing evidence on criterion [number withheld]) | `state/runs.log`, `tasks/T002.md` |
| (between) | Co-PI: finding concerns the review procedure, not the text; `review.sh` extended to list out-of-scope changes; file attribution written into the card; candidate re-frozen without text change | `tasks/T002.md` |
| [number withheld]:[number withheld] | Review [number withheld]: codex medium → **REWORK** (criterion [number withheld] still not evidenced) | `state/runs.log`, `review/T002.md` |

> [!info]
> The report of review [number withheld] was overwritten by review [number withheld] (`review/T002.md` holds only the latest). Three worker lines in `runs.log` within [number withheld] minutes are recorded as-is; the sources do not explain each run individually.

## Why criterion [number withheld] failed

`review.sh` listed these files as modified since the first worker run, outside the write scope:
`Daten/__pycache__/akshare_coverage_test.cpython-314.pyc`, `Daten/akshare_output/delisted_a_balance.csv`, `delisted_a_income.csv`, `delisted_hk_balance.csv`, `delisted_hk_income.csv`, `Team_Ablauf.pdf`, `Team_Ablauf.png`, `agents/Team_Ablauf.tex`, `agents/candidate.sh`, `agents/lib.sh`, `agents/review.sh`, `agents/worker.sh`, `output/tables/wind_nachholliste.csv`.

Co-PI attribution (in the card):
- The worker could not write outside `proposal/`: called with `--permission-mode dontAsk`, only `Edit(./proposal/**)`, no Bash.
- `agents/*.sh`, `agents/Team_Ablauf.tex`, `Team_Ablauf.pdf/.png`: changed/created by the Co-PI during the task (script fixes, overview graphic for the PI).
- `Daten/akshare_output/delisted_*.csv`, `Daten/__pycache__/`, `output/tables/wind_nachholliste.csv`: parallel data work outside the team (origin not checked by the Co-PI).

Reviewer's objection: this is only an explanation. `agents/worker.sh` (showing the restricted call) was itself modified after the task began, so the historic call is not evidenced; `tasks/T002_worker.log` is empty and `state/runs.log` entries for T002 contain no tool permissions.

## Results (local, not yet in Overleaf)

- `proposal/main.tex` – skeleton with preamble, title page, six sections with TODOs, bibliography block, AI-Use appendix. TODO count per section (worker report): Introduction [number withheld], Related Literature [number withheld] (incl. focal paper), Theoretical Framework [number withheld], Empirical Model [number withheld] (equations, identification, confounders), Context and Data [number withheld] (institutional background, data sources, summary statistics, descriptive table), Preliminary Analysis [number withheld] (at least summary statistics, ideally first estimates).
- `proposal/references.bib` – comment line only.
- No numbers in the text.

## Pending

- [ ] **`agents/overleaf.sh check`** — listed as outstanding in the worker report (the writer has no Bash). Review [number withheld] cites a clean compile in `review/T002_latex.txt` produced by `candidate.sh`; a manual check confirms it before any push.
- [ ] **PI decision** on criterion [number withheld], either:
  - re-freeze and re-review with better evidence: `agents/candidate.sh T002` → `agents/review.sh T002`, or
  - accept despite REWORK: `agents/pi.sh override T002 "reason"` (Anton only; reason logged in `state/approvals.log`).
- [ ] After `DELIVERED`: `agents/overleaf.sh push T002`; AI log entry; update `PROJEKT_STAND.md` (§[number withheld] currently lists only T001).
- [ ] Worker's open questions to the PI:
  - [ ] Working title OK? ("Real or Cosmetic Deleveraging? China's Three Red Lines and Property Developers' Balance Sheets")
  - [ ] Citation style: `natbib` with `plainnat` (author-year) as default; syllabus names none — ask Zhuang if a style is expected.
  - [ ] Paper size: preamble sets `a4paper`; card only requires [number withheld]-inch margins — A4 or US Letter?
  - [ ] Theoretical Framework: `PROJEKT_STAND.md` lists no mandatory content; the TODO says so — Anton decides what goes there.

> [!idea] Suggestion (not decided)
> For future writing tasks, the evidence gap could be closed by having `worker.sh` log the permission line (now done for Claude) and by keeping parallel data work out of the project folder while a task is open. Whether to override T002 is the PI's call.

Related: [[Task Board]] · [[Run Log]] · [[Task Workflow]] · [[Safeguards]] · [[Overleaf Sync]] · [[Decisions and Open Questions]] · [[To-Do]]

Source: `tasks/T002.md`; `tasks/T002_report.md`; `review/T002.md`; `state/runs.log`; `state/approvals.log`; `agents/worker.sh`; `agents/review.sh`; `PROJEKT_STAND.md` §[number withheld].
