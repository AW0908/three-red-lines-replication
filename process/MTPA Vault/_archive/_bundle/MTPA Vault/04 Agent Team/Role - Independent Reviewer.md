---
tags: [mtpa, agents, role]
status: reference
updated: 2026-10-14
---

# Role - Independent Reviewer

**Who:** Antigravity CLI (Gemini, `reviewer: agy`) for data/code tasks; Codex CLI (`reviewer: codex`, read-only) for text tasks. Never the same tool as the worker of that task.

> "Test the result, not the story. Start from evidence and criteria — not from the worker's explanation." (guest lecture, slide [number withheld])

The reviewer checks a **frozen** candidate against the acceptance criteria. It was not involved in execution and is not now.

## Inputs (passed by `agents/review.sh`)

- Task card with acceptance criteria; worker report (only as a pointer to the files).
- List of frozen files (SHA-[number withheld] in `review/T###_frozen.sha256`).
- Script-computed facts: whether the card's inputs are unchanged since execution began (SHA-[number withheld] vs. baseline), and which project files outside the write scope were modified since execution began (by modification time; excluding `tasks/`, `review/`, `state/`).
- For writing tasks: `review/T###_proposal.diff` (changes vs. last Overleaf state) and `review/T###_latex.txt` (test compile with pdfLaTeX).

## Minimum checks

[number withheld]. **Meaning of variables:** definition, sign, unit, direction; endpoints tested mentally against the code (min, max, zero, missing).
[number withheld]. **Sample:** case counts before and after each filter match the card; nothing silently excluded or added.
[number withheld]. **Reproducibility:** the execution command visibly produces exactly the stored files; relative paths, fixed seed, no manual steps.
[number withheld]. **Scope:** writes only within the write scope; question unchanged.
[number withheld]. **Every single acceptance criterion** of the card.

"The code ran" is not evidence of correctness. No invented findings; anything not checkable goes under "Nicht geprüft" (not checked).

## Verdicts

| Verdict | Meaning | Goes to |
|---|---|---|
| `PASS` | all criteria evidenced as met; no substantive errors | PI for acceptance |
| `REWORK` | fixable shortcomings within the card | Co-PI |
| `ESCALATE` | affects research question, estimand, sample, data integrity, or the card itself is wrong | directly to the PI |

## Output format

The answer is saved unchanged as the review. First line exactly `VERDICT: PASS|REWORK|ESCALATE`, then sections *Befunde* (findings, numbered, most severe first, with evidence), *Abnahmekriterien* (each: evidenced met / not met / not checkable), *Nicht geprüft*.

## Writes to

Nothing. The script writes `review/T###.md` (header + verdict text) and logs to `state/runs.log`.

## Must never

- Change any file or run commands — it only reads.
- Invent findings.

## Technical setup

| Reviewer | Call | Restriction |
|---|---|---|
| Antigravity | `agy --model gemini-[number withheld]-flash-<tier> --mode plan -p=…` | plan mode: no commands |
| Codex | `codex exec -s read-only -c model_reasoning_effort=<tier>` | read-only sandbox |

If the frozen files change during the review, the script overrides the verdict to `ESCALATE` ("changed during review – verdict invalid").

Examples: [[T001 A-Share Audit]] (PASS) · [[T002 LaTeX Skeleton]] (REWORK).

Related: [[Agent Team Overview]] · [[Task Workflow]] · [[Safeguards]] · [[Model Tiers]]

Source: `agents/roles/reviewer.md`; `agents/review.sh`; `agents/TEAM.md` (Rollen, Was technisch abgesichert ist); guest lecture `Lecture Note/Lecture02_SlidesGuest.pdf` slide [number withheld].
