---
tags: [mtpa, agents]
status: reference
updated: 2026-10-14
---

# Model Tiers

The Co-PI sets `priority:` in every task card; the scripts translate it into a model tier, identically for worker and reviewer. The mapping lives in one place: function `tier` in `agents/lib.sh`. If the field is missing, `priority` defaults to `normal`; any other value than `high`/`normal`/`low` aborts the script.

## Mapping (exact values from `agents/lib.sh`)

| `priority` | Claude (text worker) `--model` | Codex `model_reasoning_effort` | Antigravity `--model` |
|---|---|---|---|
| `high` | `opus` | `high` | `gemini-[number withheld]-flash-high` |
| `normal` (default) | `sonnet` | `medium` | `gemini-[number withheld]-flash-medium` |
| `low` | `haiku` | `low` | `gemini-[number withheld]-flash-low` |

Notes:
- For Codex only the reasoning effort is set; the model itself is the Codex CLI default. `AI_USAGE_LOG.md` records it for T001 as "GPT-[number withheld]-Sol, Aufwand medium".
- Claude values are model aliases passed to `claude --model`.
- The Co-PI's own model is set by Anton in Claude Code via `/model`; the scripts do not touch it. `AI_USAGE_LOG.md` lists the Co-PI as Claude Code (Opus [number withheld]).
- Every run is logged with tool, tier and priority in `state/runs.log` → [[Run Log]].

## When to use which priority (`agents/roles/co-pi.md`)

| Priority | Use for |
|---|---|
| `high` | the result carries a claim of the proposal or is hard to undo: sample definition, computation of the red-line metrics, estimations, identification, Introduction, Empirical Model |
| `normal` | default: audits, data preparation, descriptive tables and figures, other text sections |
| `low` | mechanical and easy to check: formatting, renaming, moving tables to LaTeX, setting bibliography entries |

When in doubt, the higher tier. The PI can change the field before approval.

## Used so far

| Task | Priority | Worker tier | Reviewer tier |
|---|---|---|---|
| [[T001 A-Share Audit]] | normal (field absent in card → default) | codex medium | agy gemini-[number withheld]-flash-medium |
| [[T002 LaTeX Skeleton]] | normal | claude sonnet | codex medium |

Related: [[Agent Team Overview]] · [[Role - Co-PI]] · [[Scripts Reference]]

Source: `agents/lib.sh` (functions `priority`, `tier`); `agents/TEAM.md` (Wichtigkeit und Modellwahl); `agents/roles/co-pi.md`; `state/runs.log`; `AI_USAGE_LOG.md`; `tasks/T001.md`; `tasks/T002.md`.
