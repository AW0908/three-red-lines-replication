---
tags: [mtpa, agents, scripts, governance]
status: reference
updated: 2026-10-16
---

Hub: [[Agent Team Overview]]

# Scripts and Safeguards

All scripts live in `agents/`, run from the project folder and `source agents/lib.sh` (`cd` to root, `set -euo pipefail`). Task IDs: `T` + three digits. Terminal output of the runs is logged to `state/terminal.log`.

## Scripts

| Script | Purpose | Usage | Who |
|---|---|---|---|
| `pi.sh` | PI decisions → `state/approvals.log` (with card SHA-[number withheld] prefix) | `approve` · `accept` · `return` · `override T### "reason"` | **Anton only** |
| `worker.sh` | Runs the worker on an approved card; saves report; first run hashes inputs (baseline) | `agents/worker.sh T###` | Co-PI |
| `candidate.sh` | Freezes candidate (SHA-[number withheld]); text tasks: diff + compile check | `agents/candidate.sh T###` | Co-PI |
| `review.sh` | Independent review of the frozen candidate; sets verdict | `agents/review.sh T###` | Co-PI |
| `status.sh` | Table of all cards (ID, status, priority, tools, title) | `agents/status.sh` | anyone |
| `overleaf.sh` | Sync `proposal/` with Overleaf | `pull` · `check` · `push T###` | see below |
| `dashboard.py` | Live dashboard of cards, reviews and logs; **reads only** `tasks/`, `review/`, `state/` | `python3 agents/dashboard.py` → http://localhost:8765 | anyone |
| `lib.sh` | Shared functions (`field`, `set_status`, `require_status`, `priority`, `tier`, `scope_paths`, `touched_since_start` …) | `source` | – |

Worker calls: Codex `codex exec -c model_reasoning_effort=<tier> -s workspace-write`; Claude `claude -p … --model <tier> --permission-mode dontAsk --allowedTools Read Glob Grep Edit(./proposal/**)` (text tasks only). Codex workers can run `Rscript` (R [number withheld]); code and data now live in `replication/` → [[Replication Package]].

## Model tiers (`priority:` → `tier` in `lib.sh`)

| `priority` | Claude | Codex reasoning effort | Antigravity | Used for |
|---|---|---|---|---|
| `high` | `opus` | `high` | `gemini-[number withheld]-flash-high` | claims of the proposal, hard to undo: sample, red-line metrics, estimation – T004 |
| `normal` (default) | `sonnet` | `medium` | `gemini-[number withheld]-flash-medium` | audits, data prep, descriptives – T001, T002, T003 |
| `low` | `haiku` | `low` | `gemini-[number withheld]-flash-low` | mechanical, easy to check – T006, T007 |

Missing field → `normal`; other values abort. When in doubt, the higher tier.

## Overleaf sync

`proposal/` is a git clone of the Overleaf project (credentials in the macOS keychain). Only `overleaf.sh` syncs.

| Command | Effect | When |
|---|---|---|
| `pull` | `git pull --ff-only --autostash`; aborts on conflict | automatically before every text task |
| `check` | `latexmk -pdf -halt-on-error` on `main.tex` | by `candidate.sh` → `review/T###_latex.txt` |
| `push T###` | requires `DELIVERED`; check; commit `"T###: <title>"`; push | Co-PI after acceptance |

State: modular structure from T002 + T006 in Overleaf since commit `[number withheld]`; copy script for tables/figures from `replication/outputs/` still open.

## Enforced vs rule-only

| Technically enforced | Where |
|---|---|
| Approval gate (`worker.sh` needs `APPROVED`/`REWORK`/`EXECUTED`; `review.sh` needs `CANDIDATE`) | `require_status` |
| Worker ≠ reviewer | `review.sh` aborts |
| Codex worker sandbox: project folder only, no network | `-s workspace-write` |
| Reviewer read-only | `agy --mode plan`; `codex -s read-only` |
| Claude writer only in `proposal/`, no Bash | `--allowedTools … Edit(./proposal/**)` |
| Freeze; change during review forces `ESCALATE` | `candidate.sh` / `review.sh` |
| Overleaf push only at `DELIVERED` | `overleaf.sh push` |
| `pi.sh` blocked for Claude Code | per `TEAM.md` via `.claude/settings.json` (not verifiable from the copied folder) |

**Rule only:** worker writes only its write scope (sandbox allows the whole project folder); Co-PI never edits `status:` by hand (detectable only via `approvals.log`); parallel-session rule (→ [[Task Workflow]]); no confidential material in cards; several models can share one wrong assumption – the review does not replace Anton's own check.

> [!warning] Known script gaps (from the scripts and the reviews)
> - **Compile gate can pass silently:** `check` returns success with "latexmk fehlt" if `latexmk` is missing.
> - **`push` commits all of `proposal/`** (`git add -A`), not only the write scope.
> - **Out-of-scope detection is time-based**: flags Co-PI and parallel edits → cause of the T002, T006, T007 overrides.
> - **T003 review header** listed T003's own write-scope files (`replication/…`) as "outside the write scope" and "no baseline stored" for inputs; cause not established in the sources.
> - **Permissions line** in `runs.log` only for Claude workers (since T006), not for Codex.
> - Claude ignores an added `Write(./proposal/**)` rule because `Edit(...)` already covers all write tools (T006).
> - Fixed 2026-10-16: `lib.sh` `input_files` failed silently on cards without inputs (first T007 start).

> [!idea] Suggestion (not decided)
> Fail `check` when `latexmk` is missing; log permissions for every worker type; compare out-of-scope files against a whitelist of Co-PI files. Script changes are the PI's call.

Siblings: [[Roles]] · [[Task Workflow]] · Agent Org Chart.canvas

Source: `agents/TEAM.md`; `agents/lib.sh`; `agents/pi.sh`; `agents/worker.sh`; `agents/candidate.sh`; `agents/review.sh`; `agents/overleaf.sh`; `agents/dashboard.py`; `state/runs.log`; `review/T002.md`, `review/T003.md`, `review/T006.md`; `tasks/T006.md`, `tasks/T007.md`; `PROJEKT_STAND.md` §[number withheld].
