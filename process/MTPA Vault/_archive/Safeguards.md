---
tags: [mtpa, agents, governance]
status: reference
updated: 2026-10-14
---

# Safeguards

> "Local interface ≠ local inference. A prompt rule ≠ a technical security boundary." (guest lecture, slide [number withheld])

`agents/TEAM.md` separates what is **technically enforced** from what is **only a rule**. The table below repeats that split and cross-checks each claim against the scripts.

## Technically enforced (per TEAM.md)

| Safeguard | Where in the scripts | Cross-check |
|---|---|---|
| Approval gate: worker and review scripts check the card status | `worker.sh`: `require_status APPROVED REWORK EXECUTED`; `review.sh`: `require_status CANDIDATE` | ✔ consistent |
| Worker runs in the Codex sandbox: writes only in the project folder, no network | `worker.sh`: `codex exec … -s workspace-write` | ✔ (network-off is the property of Codex's `workspace-write` sandbox, not set explicitly in the script) |
| Reviewer can only read: Antigravity may not run commands; Codex as reviewer runs `read-only` | `review.sh`: `agy … --mode plan`; `codex exec … -s read-only` | ✔ for Codex; for Antigravity the restriction relies on its `plan` mode |
| Claude as text worker writes only in `proposal/`, runs no commands | `worker.sh`: `--permission-mode dontAsk --allowedTools "Read" "Glob" "Grep" "Edit(./proposal/**)"`; refuses Claude for non-`proposal/` tasks | ✔ consistent |
| Upload to Overleaf only at status `DELIVERED` | `overleaf.sh push`: `require_status DELIVERED`, then compile check | ✔ status gate; compile gate see warning below |
| Freeze: SHA-[number withheld] of candidate files; review compares before and after | `candidate.sh` writes `review/T###_frozen.sha256`; `review.sh` refuses if changed before review, forces `ESCALATE` if changed during review | ✔ consistent |
| Inputs: hashes stored before first worker run; review reports whether unchanged | `worker.sh` writes `review/T###_baseline.sha256` once; `review.sh` compares (inputs that are also in write scope may change) | ✔ consistent |
| Worker ≠ reviewer | `review.sh`: dies if `worker` == `reviewer` | ✔ consistent |
| Claude Code may not run `agents/pi.sh` | stated as set in `.claude/settings.json` | ⚠ not verifiable from the copied project folder (file not included) |

Additionally (in the scripts, not listed in TEAM.md): `review.sh` reports all project files modified (by mtime) outside the write scope since the first worker run, excluding `tasks/`, `review/`, `state/`, `proposal/.git/`, `Daten/.venv/`. This check was added during [[T002 LaTeX Skeleton]].

## Rule only, not enforced

- The worker should write only into the card's write scope — the Codex sandbox allows the whole project folder.
- Claude Code could change `status:` in a card by hand. It is instructed not to; `state/approvals.log` shows which approvals really went through `agents/pi.sh`.
- Several models can share the same wrong assumption. The review does not replace Anton's own check.
- No tool runs `git push` in `proposal/` itself; credentials are in no project file (macOS keychain).
- Confidential material (other students' proposals and referee reports) never goes into a task card.

> [!warning] Gaps found when cross-checking the scripts
> - **Compile gate can pass silently.** `overleaf.sh`'s `compile_check` returns success with "latexmk fehlt, Übersetzung nicht geprüft" (latexmk missing, not checked) if `latexmk` is not installed. Then `push` proceeds without a compile check, although TEAM.md says upload only "bei fehlerfreier Übersetzung".
> - **`push` commits everything in `proposal/`** (`git add -A`), not only the files in the card's write scope.
> - **Out-of-scope detection is time-based**, so it also lists files changed by the Co-PI or by unrelated parallel work; attribution is not automatic (the root cause of the T002 `REWORK`).
> - **Status edits by hand** are only detectable through `state/approvals.log`, which is itself a plain text file.

> [!idea] Suggestion (not decided)
> Make `compile_check` fail when `latexmk` is missing during `push`, and have `worker.sh` log the tool permissions for every worker type (it currently writes a "Rechte" line only for Claude). Both are script changes for the PI to decide.

Related: [[Agent Team Overview]] · [[Task Workflow]] · [[Scripts Reference]] · [[Overleaf Sync]] · [[Lecture [number withheld] Guest - AI Agent Organization]]

Source: `agents/TEAM.md` (Was technisch abgesichert ist und was nur Regel ist; Grenzen); `agents/lib.sh`; `agents/worker.sh`; `agents/candidate.sh`; `agents/review.sh`; `agents/pi.sh`; `agents/overleaf.sh`; `review/T002.md`; guest lecture `Lecture Note/Lecture02_SlidesGuest.pdf` slide [number withheld].
