---
tags: [mtpa, proposal, hub]
status: in-progress
updated: 2026-10-16
---

# Proposal Outline (hub)

Hub: [[[number withheld] Home]] · Requirements: [[Course Overview]] · Due: **[number withheld]** ([number withheld]–[number withheld] pages, [number withheld] spacing, [number withheld] inch, [number withheld]pt Times)

> [!info] LaTeX structure (since T006, [number withheld])
> `proposal/main.tex` (title page + `\input`) · `preamble.tex` · `sections/01_introduction.tex` … `06_preliminary_analysis.tex` ·
> `appendix/ai_use.tex` · `figures/`, `tables/` · `references.bib` (empty). Synced with Overleaf only via `agents/overleaf.sh`.
> All sections still contain only `% TODO(PI)` placeholders.

| # | Section | What goes in | Ready? | Blocked by |
|---|---|---|---|---|
| [number withheld] | Title page, abstract ≤ [number withheld] words, [number withheld]–[number withheld] keywords | final question | ⬜ | question final ([number withheld]) |
| [number withheld] | Introduction (question + method, motivation, contribution) | RQ, policy, gap | ⬜ | gap claim narrowed → [[Literature Overview]] |
| [number withheld] | Related literature incl. focal paper | [number withheld] papers + press evidence | ⬜ | full texts, focal paper choice |
| [number withheld] | Theoretical framework (graph allowed) | thresholds → incentive to manage reported ratios | ⬜ | caps unverified → [[Research Question]] |
| [number withheld] | Empirical model (equations, identification, confounders) | bunching + dose-response DiD, event study | 🟡 design + definitions decided [number withheld] | course week [number withheld] ([number withheld]) |
| [number withheld] | Context and data (institutions, sources, summary stats, **descriptive table**) | sources, sample flow, panel | 🟡 panel delivered (T004) | T005 (approved) → [[Task Board]] |
| [number withheld] | Preliminary analysis (summary stats, ideally first estimates) | bunching histograms, first DiD | ⬜ | T005, then estimate card |
| [number withheld] | Bibliography | verified entries only | ⬜ | BibTeX via DOI |
| [number withheld] | AI-use appendix | from `AI_USAGE_LOG.md` | 🟡 log is current | translate to English → [[To-Do]] |

## How numbers get into the text
`replication/outputs/` → copy to `proposal/tables|figures` → `\input{}` / `\includegraphics{}` with `% source:` comment → writer card (Claude) → review (Codex checks every number against the files). → [[Replication Package]] · [[Agent Team Overview]]

Source: `tasks/T006.md`, `PROJEKT_STAND.md` §[number withheld] and §[number withheld], `AGENTS.md`.
