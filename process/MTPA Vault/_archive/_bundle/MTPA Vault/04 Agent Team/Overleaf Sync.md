---
tags: [mtpa, agents, overleaf]
status: reference
updated: 2026-10-14
---

# Overleaf Sync

`proposal/` is a **git clone of the Overleaf project** holding the research proposal LaTeX. Access credentials are in the macOS keychain, never in a project file. Syncing happens **only** through `agents/overleaf.sh`; no tool runs `git push` in `proposal/` itself.

## Commands

| Command | Effect | Who / when |
|---|---|---|
| `agents/overleaf.sh pull` | `git pull --ff-only --autostash` from Overleaf; aborts if local and Overleaf changes conflict | runs automatically in `agents/worker.sh` before every writing task |
| `agents/overleaf.sh check` | test-compiles `proposal/main.tex` with `latexmk -pdf -halt-on-error` | run by `agents/candidate.sh` for writing tasks (output → `review/T###_latex.txt`); may be run manually |
| `agents/overleaf.sh push T###` | requires status `DELIVERED`; compile check; `git add -A`, commit `"T###: <title>"`, `pull --rebase`, `push` | Co-PI after the PI's acceptance |

## Rules

- Until the PI accepts, changes stay local.
- If Anton writes directly in Overleaf while a writing task is open, syncing may fail; the script then aborts instead of overwriting anything.
- The writer ([[Role - Writer]]) never runs git and cannot run the check itself (no Bash).

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

> [!warning]
> If `latexmk` is not installed, `check` prints "latexmk fehlt, Übersetzung nicht geprüft" and returns success, so `push` would not block on compile errors. See [[Safeguards]].

## Current state (2026-10-14)

- [[T002 LaTeX Skeleton]] changed `proposal/main.tex` and created `proposal/references.bib` locally. Status `REWORK` → **nothing pushed to Overleaf yet** (push requires `DELIVERED`).

Related: [[Task Workflow]] · [[Scripts Reference]] · [[Proposal Outline]] · [[Agent Team Overview]]

Source: `agents/overleaf.sh`; `agents/TEAM.md` (Overleaf); `agents/worker.sh`; `agents/candidate.sh`; `AGENTS.md` (Ordner, Agenten-Team); `tasks/T002.md`.
