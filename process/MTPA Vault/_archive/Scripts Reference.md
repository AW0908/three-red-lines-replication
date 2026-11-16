---
tags: [mtpa, agents, scripts]
status: reference
updated: 2026-10-14
---

# Scripts Reference

All scripts live in `agents/`, are run from the project folder, and `source agents/lib.sh` (which `cd`s to the project root and sets `set -euo pipefail`). Task IDs must match `T` + three digits.

| Script | Purpose | Usage | Who may run it |
|---|---|---|---|
| `lib.sh` | Shared functions (not run directly) | `source` | – |
| `pi.sh` | PI decisions; logs to `state/approvals.log` | `approve T###` · `accept T###` · `return T###` · `override T### "reason"` | **Anton only.** Claude Code is blocked from it (per TEAM.md via `.claude/settings.json`) |
| `worker.sh` | Starts the worker on an approved card; saves report | `agents/worker.sh T###` | Co-PI (Claude Code) |
| `candidate.sh` | Freezes the candidate (SHA-[number withheld]); for writing tasks also diff + compile check | `agents/candidate.sh T###` | Co-PI |
| `review.sh` | Independent review of the frozen candidate | `agents/review.sh T###` | Co-PI |
| `status.sh` | Overview table of all cards (ID, status, priority, worker, reviewer, title) | `agents/status.sh` | anyone |
| `overleaf.sh` | Sync `proposal/` with Overleaf | `pull` · `check` · `push T###` | `pull` auto via `worker.sh`; `check` via `candidate.sh` or manually; `push` Co-PI after `DELIVERED` |

## `lib.sh` functions

| Function | Does |
|---|---|
| `load_task` | validates ID, sets paths `CARD`, `REPORT`, `REVIEW`, `FROZEN`, `BASELINE`, `TEXDIFF`, `TEXBUILD` |
| `field <name>` | reads a front-matter field from the card |
| `set_status` | rewrites `status:` in the card (`sed -i ''`, macOS syntax) |
| `require_status …` | aborts unless current status is one of the given |
| `listed_files` | existing files named in backticks in given markdown files |
| `input_files` | existing files in backticks in section *Eingaben* |
| `priority` | `priority:` field, default `normal`, validated |
| `tier <claude\|codex\|agy>` | model tier → [[Model Tiers]] |
| `scope_paths` / `outside_scope` | paths in *Schreibbereich*; filters paths outside it |
| `touched_since_start` | project files newer than the baseline file (excl. `proposal/.git`, `Daten/.venv`, `tasks/`, `review/`, `state/`, `.DS_Store`) |

## `pi.sh`

`approve` (`PLAN`→`APPROVED`), `accept` (`PASS`→`DELIVERED`), `return` (any→`PLAN`), `override` (`REWORK`/`ESCALATE`→`DELIVERED`, reason mandatory). Appends `date ID STATUS (PI, sha2[number withheld] Karte: <[number withheld] hex>)[ OVERRIDE: reason]` to `state/approvals.log`.

## `worker.sh`

[number withheld]. Requires `APPROVED`, `REWORK` or `EXECUTED`.
[number withheld]. First run only: hashes the card's inputs → `review/T###_baseline.sha256`.
[number withheld]. Builds the prompt from `agents/roles/worker.md` + card; adds `review/T###.md` if present.
[number withheld]. If the write scope contains `proposal/`: runs `agents/overleaf.sh pull` and appends `agents/roles/writer.md`.
[number withheld]. `worker: claude` → `claude -p … --model <tier> --permission-mode dontAsk --allowedTools Read Glob Grep Edit(./proposal/**)` (only for writing tasks); logs a permissions line to `state/runs.log`.
   `worker: codex` → `codex exec -c model_reasoning_effort=<tier> -s workspace-write -o tasks/T###_report.md`.
   Other worker → prints the prompt for a manual run.
[number withheld]. Requires a non-empty report, logs `T### worker <tool> <tier> (priority …)`, sets `EXECUTED`.

## `candidate.sh`

Requires `EXECUTED`, `CANDIDATE` or `REWORK` and a report. Hashes every existing file named in backticks in card + report (except `tasks/`, `review/`, `state/`) → `review/T###_frozen.sha256`. Writing tasks: `git -C proposal diff` → `review/T###_proposal.diff`; `agents/overleaf.sh check` → `review/T###_latex.txt`. Sets `CANDIDATE`.

## `review.sh`

Requires `CANDIDATE`, worker ≠ reviewer, intact freeze. Computes input changes vs. baseline and out-of-scope modified files; passes them plus diff/compile result to the reviewer (`agy --mode plan` or `codex -s read-only`). Extracts `VERDICT:`; if none, saves `review/T###_ohne_urteil.md` and aborts. Re-checks the freeze afterwards (changed → `ESCALATE`). Writes `review/T###.md`, logs to `state/runs.log`, sets the verdict as status.

## `overleaf.sh`

See [[Overleaf Sync]].

Related: [[Task Workflow]] · [[Safeguards]] · [[Role - PI]] · [[Role - Co-PI]] · [[Run Log]] · [[Scripts and Environment]]

Source: `agents/lib.sh`; `agents/pi.sh`; `agents/worker.sh`; `agents/candidate.sh`; `agents/review.sh`; `agents/status.sh`; `agents/overleaf.sh`; `agents/TEAM.md`.
