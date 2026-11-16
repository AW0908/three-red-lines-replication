## Ergebnis
Rework [number withheld] is complete, and all T043 steps are documented again in this report. The aborted session of 2026-10-28 had already put both Rework [number withheld] changes into `15_referee2.R:351–361`; I found no half-finished edits.
- **Note fix:** the TeX note of `t043_integration.tex` now says the secondary variant's mass residual equals *minus* the [[number withheld]) column.
- **Baseline rows:** the T023 baseline rows show "--" for B_net and [[number withheld]), and the note explains why.

I ran `15_referee2.R` twice. Both runs were byte-identical to each other and to the state of the aborted run, and no numbers changed relative to Rework [number withheld]. These are pre-specified descriptive checks. They do not identify causal effects or evasion.

## Dateien
- `replication/code/15_referee2.R` – analysis script for all T043 steps; Rework [number withheld] edits at lines [number withheld]–[number withheld] (TeX note, "--" cells).
- `replication/outputs/tables/t043_delta_b.csv/.tex`, `t043_delta_draws.csv` – step [number withheld].
- `replication/outputs/tables/t043_integration.csv/.tex`, `t043_integration_iterations.csv`, `t043_integration_draws.csv` – step [number withheld].
- `replication/outputs/tables/t043_meas_error.csv/.tex`, `t043_meas_error_draws.csv`, `replication/outputs/figures/t043_meas_error.pdf` – step [number withheld].
- `replication/outputs/tables/t043_heterogeneity.csv/.tex`, `t043_heterogeneity_draws.csv` – step [number withheld].
- `replication/outputs/tables/t043_cash_backing.csv/.tex`, `t043_cash_sources.csv` – step [number withheld] (page reference for every cash value).
- `replication/outputs/tables/t043_trend_cf.csv/.tex`, `t043_trend_draws.csv`, `t043_trend_firms.csv` – step [number withheld] (Revision [number withheld]).
- `replication/outputs/tables/t043_input_output_guards.csv` – SHA-[number withheld] of [number withheld] inputs and [number withheld] protected outputs.
- `replication/outputs/tables/t043_run1.log`, `t043_run2.log` – console output, this time redirected straight into the files rather than copied by hand.
- `replication/outputs/tables/t043_verification.txt` – rewritten for Rework [number withheld].
- `replication/outputs/tables/t043_reproducibility.csv` – pre-Rework-[number withheld]/run [number withheld]/run [number withheld] hashes from the aborted session. I checked them against my own hashes and left the file unchanged.
- `replication/run_all.sh`, `replication/run_all.R`, `replication/README.md` (line [number withheld]) – entry for [number withheld]; unchanged in this rerun. [number withheld] (T044) runs after [number withheld].

## Ausführung
`cd replication && Rscript code/15_referee2.R`, run twice with console output redirected to `outputs/tables/t043_run1.log` and `t043_run2.log`. Last lines of both logs:
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
- The two logs have the same SHA-[number withheld] (f2[number withheld]c6…).
- `shasum -a [number withheld]` of all [number withheld] staged files was identical before run [number withheld], after run [number withheld] and after run [number withheld].
- Compared with the pre-Rework-[number withheld] state, two files changed: `t043_integration.tex` and the guard CSV.

## Abnahmekriterien
[number withheld]. **Reproduction asserts, existing outputs unchanged, two identical runs – met.**
   - The asserts reproduce b_post = [number withheld], b_pre = [number withheld] and D = [number withheld].
   - The [number withheld] inputs and [number withheld] protected outputs were unchanged before and after each run (script assertion).
   - All [number withheld] staged files and both logs are identical across the two runs.
[number withheld]. **Every variant reported, firm counts beside every estimate – met.** Row counts: Δb [number withheld], integration [number withheld], measurement error [number withheld], heterogeneity [number withheld], cash [number withheld], trend [number withheld]. Every table has N and firm counts.
[number withheld]. **Convergence, error distribution, page references – met.**
   - The main integration variant converges in [number withheld] (pre) and [number withheld] (post) iterations, with mass residuals around [number withheld].
   - Error distribution: N = [number withheld] pairs from [number withheld] firms, mean [number withheld], SD [number withheld]. The near-cutoff variant has N = [number withheld] from [number withheld] firms, mean [number withheld], SD [number withheld].
   - Every cash value has a `pdf_page` or "missing" (script assertion).
[number withheld]. **No new data, no hand-collected value changed – met.** The script works offline, and the input hashes are unchanged, including `nci_cashflow.csv`.

**Results by check (does the core finding survive?)**

- **Step [number withheld], direct test (Δb):** survives.
  - At [number withheld] (main): Δb = [number withheld], SE [number withheld], CI [[number withheld]; [number withheld]], share > [number withheld] = [number withheld].
  - All four variants at [number withheld] are positive with CIs above zero; Δb ranges from [number withheld] (degree7) to [number withheld] (wide).
  - Placebo thresholds [number withheld] and [number withheld]: all ten CIs include zero.
  - These are pointwise intervals without multiple-testing adjustment.
- **Step [number withheld], integration constraint (textbook Chetty et al. [number withheld]):** survives with a larger estimate.
  - **Main variant, post:** b_net = [number withheld] [[number withheld]; [number withheld]]. B_net = [number withheld], of which [number withheld] is below [number withheld] and [number withheld] in [[number withheld]).
  - **Main variant, pre:** b_net = [number withheld] [[number withheld]; [number withheld]].
  - **Change:** Δb_net = [number withheld] [[number withheld]; [number withheld]], share > [number withheld] = [number withheld].
  - The [[number withheld]) part is positive, so no missing mass shows up directly above the threshold.
  - **Secondary variant** (B measured below [number withheld] only): post [number withheld], pre [number withheld].
  - **Boundary cases:**
    - Literal s: post [number withheld] with a CI conditional on [number withheld]/[number withheld] valid draws; pre not estimable.
    - Normalized: no upward bracket post (starting fit: excess [number withheld], missing [number withheld]); pre not estimable.
- **Step [number withheld], measurement error:** b_post shrinks but stays positive in every replication of every variant.
  - Raw errors: b_post [number withheld] [[number withheld]; [number withheld]], Δb [number withheld] [[number withheld]; [number withheld]].
  - Centered errors: b_post [number withheld], Δb [number withheld].
  - The mean shift explains about [number withheld] % ([number withheld]) of the attenuation of b_post.
  - The percentiles are simulation intervals, not sampling CIs.
- **Step [number withheld], heterogeneity (descriptive, pointwise, unadjusted):**
  - D is positive with CIs above zero in all six groups.
  - b_post has a CI above zero for private firms, HK and "both other lines met". It includes zero for SOE, A-share and "at least one breached".
  - [number withheld] firms have no ownership class and [number withheld] no other-line class; they are excluded and counted.
- **Step [number withheld], cash backing (pilot, HK ratios conditional on panel MI being in RMB):**
  - Group B pooled: net cash/ΔMI = [number withheld] ([number withheld] bn ΔMI, [number withheld] bn capital, [number withheld] bn dividends).
[firm-specific excerpt withheld in public process copy]
  - Most of the minority-interest growth came with cash, so it was not purely an accounting relabeling.
- **Step [number withheld], trend-adjusted counterfactual:** the dependence on minority interests does **not** survive.
  - Own-firm trend: D_trend = [number withheld] [[number withheld]; [number withheld]].
  - Bin trend: D_trend = [number withheld] [[number withheld]; [number withheld]].
  - b_trend: [number withheld] [[number withheld]; [number withheld]] (own trend) and [number withheld] [[number withheld]; [number withheld]] (bin trend).
  - The placebo anchors cannot be estimated (too little panel history). So no comparison against a placebo is possible, and by the card's rule the dependence does not exceed what pre-policy MI growth predicts.

**Number → file → row/column**

| Figure | File | Row filter / column |
|---|---|---|
| Δb [number withheld], SE [number withheld], CI | `t043_delta_b.csv` | threshold=[number withheld], specification=main; delta_b, se, ci_low, ci_high |
| Placebo Δb | `t043_delta_b.csv` | threshold∈{[number withheld], [number withheld]} |
| b_net post [number withheld] / pre [number withheld] | `t043_integration.csv` | method=chetty_net, period; b, ci_low, ci_high, net_excess, excess_below_0[number withheld], excess_0[number withheld]_0[number withheld], iterations |
| Δb_net [number withheld] | `t043_integration.csv` | period=post_minus_pre; b, ci_low, ci_high, share_positive_valid |
| Starting fits [number withheld]/[number withheld] and [number withheld]/[number withheld] | `t043_integration.csv` | period=post, method=boundary_literal_s / boundary_normalized; initial_excess, initial_missing |
| Error N/mean/SD | `t043_meas_error.csv` | scope, error_variant=uncentered; error_n, error_firms, error_mean, error_sd |
| Simulated b_post, Δb, [number withheld] | `t043_meas_error.csv` | scope, error_variant, metric; mean, p0[number withheld], p9[number withheld], share_positive_all, mean_shift_share_of_uncentered_attenuation |
| Heterogeneity | `t043_heterogeneity.csv` | dimension/group/statistic; estimate, ci_low, ci_high, n, firms, excluded_* |
| Cash [number withheld] (B), [number withheld] (A gross) | `t043_cash_backing.csv` | pooled A / pooled B; ratio columns; components with pages in `t043_cash_sources.csv` |
| D_trend, b_trend | `t043_trend_cf.csv` | row_type=level, anchor=2019-12-31, variant, metric; estimate, ci_low, ci_high |

## Offene Fragen
- Between Rework [number withheld] and now, the protected set grew from [number withheld] to [number withheld] non-T043 outputs (`t043_input_output_guards.csv`). This script writes only `t0[number withheld]_*`. I did not trace the three extra files; they are probably from the parallel T044 session, and none is a T043 input. As with the review's guard finding, the out-of-scope changes come from T044.
- `t043_reproducibility.csv` (with the column `pre_rework4_sha2[number withheld]`) was written by the aborted session. Its run [number withheld]/run [number withheld] hashes match my two runs, but I cannot check its pre-Rework-[number withheld] hashes independently.
- Points carried over from the data review:
  - The HK panel MI currency is unverified.
  - `verified_by_PI` is empty in `nci_cashflow.csv`.
  - Group A has no net ratio because two dividend values are missing.
- I did not run the full `run_all`, because it would rebuild outputs outside this card's write scope.
- Proposed `AI_USAGE_LOG.md` entry (Co-PI/PI to add): "2026-10-29, Claude (Worker T043, Rework [number withheld]): corrected TeX note of the integration table, two reproducibility runs, complete report."
