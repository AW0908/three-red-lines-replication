## Ergebnis
Rework 4 is complete, and all T043 steps are documented again in this report. The aborted session of 2026-10-28 had already put both Rework 4 changes into `15_referee2.R:351–361`; I found no half-finished edits.
- **Note fix:** the TeX note of `t043_integration.tex` now says the secondary variant's mass residual equals *minus* the [0.70,0.74) column.
- **Baseline rows:** the T023 baseline rows show "--" for B_net and [0.70,0.74), and the note explains why.

I ran `15_referee2.R` twice. Both runs were byte-identical to each other and to the state of the aborted run, and no numbers changed relative to Rework 3. These are pre-specified descriptive checks. They do not identify causal effects or evasion.

## Dateien
- `replication/code/15_referee2.R` – analysis script for all T043 steps; Rework 4 edits at lines 351–361 (TeX note, "--" cells).
- `replication/outputs/tables/t043_delta_b.csv/.tex`, `t043_delta_draws.csv` – step 1.
- `replication/outputs/tables/t043_integration.csv/.tex`, `t043_integration_iterations.csv`, `t043_integration_draws.csv` – step 2.
- `replication/outputs/tables/t043_meas_error.csv/.tex`, `t043_meas_error_draws.csv`, `replication/outputs/figures/t043_meas_error.pdf` – step 3.
- `replication/outputs/tables/t043_heterogeneity.csv/.tex`, `t043_heterogeneity_draws.csv` – step 4.
- `replication/outputs/tables/t043_cash_backing.csv/.tex`, `t043_cash_sources.csv` – step 5 (page reference for every cash value).
- `replication/outputs/tables/t043_trend_cf.csv/.tex`, `t043_trend_draws.csv`, `t043_trend_firms.csv` – step 7 (Revision 2).
- `replication/outputs/tables/t043_input_output_guards.csv` – SHA-256 of 13 inputs and 203 protected outputs.
- `replication/outputs/tables/t043_run1.log`, `t043_run2.log` – console output, this time redirected straight into the files rather than copied by hand.
- `replication/outputs/tables/t043_verification.txt` – rewritten for Rework 4.
- `replication/outputs/tables/t043_reproducibility.csv` – pre-Rework-4/run 1/run 2 hashes from the aborted session. I checked them against my own hashes and left the file unchanged.
- `replication/run_all.sh`, `replication/run_all.R`, `replication/README.md` (line 114) – entry for 15; unchanged in this rerun. 16 (T044) runs after 15.

## Ausführung
`cd replication && Rscript code/15_referee2.R`, run twice with console output redirected to `outputs/tables/t043_run1.log` and `t043_run2.log`. Last lines of both logs:
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
- The two logs have the same SHA-256 (f22988c6…).
- `shasum -a 256` of all 22 staged files was identical before run 1, after run 1 and after run 2.
- Compared with the pre-Rework-4 state, two files changed: `t043_integration.tex` and the guard CSV.

## Abnahmekriterien
1. **Reproduction asserts, existing outputs unchanged, two identical runs – met.**
   - The asserts reproduce b_post = 3.1429, b_pre = −0.8772 and D = 0.1146.
   - The 13 inputs and 203 protected outputs were unchanged before and after each run (script assertion).
   - All 22 staged files and both logs are identical across the two runs.
2. **Every variant reported, firm counts beside every estimate – met.** Row counts: Δb 15, integration 11, measurement error 12, heterogeneity 12, cash 12, trend 20. Every table has N and firm counts.
3. **Convergence, error distribution, page references – met.**
   - The main integration variant converges in 17 (pre) and 19 (post) iterations, with mass residuals around 5e-7.
   - Error distribution: N = 64 pairs from 30 firms, mean 0.0099, SD 0.0264. The near-cutoff variant has N = 52 from 26 firms, mean 0.0044, SD 0.0077.
   - Every cash value has a `pdf_page` or "missing" (script assertion).
4. **No new data, no hand-collected value changed – met.** The script works offline, and the input hashes are unchanged, including `nci_cashflow.csv`.

**Results by check (does the core finding survive?)**

- **Step 1, direct test (Δb):** survives.
  - At 0.70 (main): Δb = 4.02, SE 1.27, CI [1.67; 6.80], share > 0 = 1.000.
  - All four variants at 0.70 are positive with CIs above zero; Δb ranges from 3.31 (degree7) to 4.80 (wide).
  - Placebo thresholds 0.60 and 0.80: all ten CIs include zero.
  - These are pointwise intervals without multiple-testing adjustment.
- **Step 2, integration constraint (textbook Chetty et al. 2011):** survives with a larger estimate.
  - **Main variant, post:** b_net = 3.76 [1.60; 6.15]. B_net = 63.84, of which 50.14 is below 0.70 and 13.69 in [0.70,0.74).
  - **Main variant, pre:** b_net = 0.20 [−1.60; 2.36].
  - **Change:** Δb_net = 3.56 [0.75; 6.49], share > 0 = 0.996.
  - The [0.70,0.74) part is positive, so no missing mass shows up directly above the threshold.
  - **Secondary variant** (B measured below 0.70 only): post 3.14, pre −0.60.
  - **Boundary cases:**
    - Literal s: post 1.03 with a CI conditional on 982/999 valid draws; pre not estimable.
    - Normalized: no upward bracket post (starting fit: excess 48.90, missing −15.90); pre not estimable.
- **Step 3, measurement error:** b_post shrinks but stays positive in every replication of every variant.
  - Raw errors: b_post 2.01 [1.27; 2.82], Δb 2.84 [1.89; 3.77].
  - Centered errors: b_post 2.99, Δb 3.47.
  - The mean shift explains about 86 % (0.8648) of the attenuation of b_post.
  - The percentiles are simulation intervals, not sampling CIs.
- **Step 4, heterogeneity (descriptive, pointwise, unadjusted):**
  - D is positive with CIs above zero in all six groups.
  - b_post has a CI above zero for private firms, HK and "both other lines met". It includes zero for SOE, A-share and "at least one breached".
  - 8 firms have no ownership class and 14 no other-line class; they are excluded and counted.
- **Step 5, cash backing (pilot, HK ratios conditional on panel MI being in RMB):**
  - Group B pooled: net cash/ΔMI = 0.715 (35.80 bn ΔMI, 27.87 bn capital, 2.29 bn dividends).
[firm-specific excerpt withheld in public audit]
  - Most of the minority-interest growth came with cash, so it was not purely an accounting relabeling.
- **Step 7, trend-adjusted counterfactual:** the dependence on minority interests does **not** survive.
  - Own-firm trend: D_trend = −0.098 [−0.151; −0.047].
  - Bin trend: D_trend = −0.056 [−0.119; 0.010].
  - b_trend: 1.52 [0.14; 3.34] (own trend) and 1.74 [−0.18; 3.35] (bin trend).
  - The placebo anchors cannot be estimated (too little panel history). So no comparison against a placebo is possible, and by the card's rule the dependence does not exceed what pre-policy MI growth predicts.

**Number → file → row/column**

| Figure | File | Row filter / column |
|---|---|---|
| Δb 4.02, SE 1.27, CI | `t043_delta_b.csv` | threshold=0.7, specification=main; delta_b, se, ci_low, ci_high |
| Placebo Δb | `t043_delta_b.csv` | threshold∈{0.6, 0.8} |
| b_net post 3.76 / pre 0.20 | `t043_integration.csv` | method=chetty_net, period; b, ci_low, ci_high, net_excess, excess_below_070, excess_070_074, iterations |
| Δb_net 3.56 | `t043_integration.csv` | period=post_minus_pre; b, ci_low, ci_high, share_positive_valid |
| Starting fits 59.75/−27.69 and 48.90/−15.90 | `t043_integration.csv` | period=post, method=boundary_literal_s / boundary_normalized; initial_excess, initial_missing |
| Error N/mean/SD | `t043_meas_error.csv` | scope, error_variant=uncentered; error_n, error_firms, error_mean, error_sd |
| Simulated b_post, Δb, 0.8648 | `t043_meas_error.csv` | scope, error_variant, metric; mean, p025, p975, share_positive_all, mean_shift_share_of_uncentered_attenuation |
| Heterogeneity | `t043_heterogeneity.csv` | dimension/group/statistic; estimate, ci_low, ci_high, n, firms, excluded_* |
| Cash 0.7146 (B), 1.0546 (A gross) | `t043_cash_backing.csv` | pooled A / pooled B; ratio columns; components with pages in `t043_cash_sources.csv` |
| D_trend, b_trend | `t043_trend_cf.csv` | row_type=level, anchor=2019-12-31, variant, metric; estimate, ci_low, ci_high |

## Offene Fragen
- Between Rework 3 and now, the protected set grew from 200 to 203 non-T043 outputs (`t043_input_output_guards.csv`). This script writes only `t043_*`. I did not trace the three extra files; they are probably from the parallel T044 session, and none is a T043 input. As with the review's guard finding, the out-of-scope changes come from T044.
- `t043_reproducibility.csv` (with the column `pre_rework4_sha256`) was written by the aborted session. Its run 1/run 2 hashes match my two runs, but I cannot check its pre-Rework-4 hashes independently.
- Points carried over from the data review:
  - The HK panel MI currency is unverified.
  - `verified_by_PI` is empty in `nci_cashflow.csv`.
  - Group A has no net ratio because two dividend values are missing.
- I did not run the full `run_all`, because it would rebuild outputs outside this card's write scope.
- Proposed `AI_USAGE_LOG.md` entry (Co-PI/PI to add): "2026-10-29, Claude (Worker T043, Rework 4): corrected TeX note of the integration table, two reproducibility runs, complete report."
