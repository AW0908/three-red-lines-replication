# Writing rules for all writing cards (T034–T038), Co-PI 2026-10-26

- Research question, title, framing: `state/STATE.md` entries 2026-10-23 (FORSCHUNGSFRAGE FINAL, TITEL FINAL, external review) and 2026-10-25/26 (T029, T031 results). The central claim, phrased exactly this way: "after the policy, compliance at the RL1 threshold depends mechanically on minority-interest growth since 2019". It is NOT a causal policy effect and NOT a statement about economic leverage. Minority interests may be genuine equity.
- Do not write "cosmetic deleveraging was proven" or "the policy was effective". Write that firms responded and that we document the form of the response.
- Three levels of evidence (external review): (1) threshold targeting, (2) composition of adjustment, (3) economic substance (pilot evidence only).
- American English; abbreviations defined at first use; ``quotes''; `~\citep`/`~\citet`; "June 30, 2020"; percentages "11.5 percent" in prose, "\%" in tables.
- Hand-collected facts (Section 6.3) only from statements with status "yes" AND level "meaning" in `replication/data/raw/manual/handcollect/case_notes_verification.csv`; the text must state that Chinese documents were read via machine translation (DeepL) and checked by the PI (PI-verified via state/handcollect/verify_cases.py).
- Numbers only from `replication/outputs/tables/*.csv` (or the T032/T033 CSVs). Round sensibly and identically everywhere. Every number in the text must be findable in an output.
- Citations only with existing keys in `proposal/references.bib`. Literature that is needed but missing: `[CITE: author year – PI to verify]` as a LaTeX comment plus a visible `\textbf{[cite]}`. Never invent BibTeX.
- Main text tables: compact, hand-built from CSV values (at most 6 rows each). Full output tables go to the appendix via `\input{tables/...}`. Figures via `\includegraphics` from `figures/`.
- Limits: main text (Sections 1–7) at most 15 pages under the preamble settings. Each section has a word budget in its card. No section may exceed its budget by more than 10%.
- Every main-text section ends without bullet lists; prose only.

- Amendment (PI, 2026-10-28): numerical hand-collected statements (balances, cash-flow lines, profit shares, amounts) may be used at status yes and level strings (number found verbatim on the cited page); qualitative statements (relations, contract clauses, categories) still require level meaning.
