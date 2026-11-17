# Meeting the Red Lines: Threshold Targeting and Minority Equity among Chinese Property Developers

RL1 denotes the first of China's Three Red Lines, the liability-to-assets cap adjusted for advance receipts. I investigate whether developers targeted the RL1 threshold and which balance-sheet adjustments and capital terms underlie their reported compliance. The answer matters because ratio-based rules work only if reported ratios track risk. I link a test of threshold targeting to accounting counterfactuals and contract evidence.

Archive documentation updated November 17, 2026. Summary wording and research payload follow accepted task card T076, with build interfaces from task card T082. The results map follows the proposal snapshot indexed on November 16, 2026; task card T081 text revisions had not been reviewed or accepted at that date.

Wind is a licensed financial-data terminal. Task cards record project work; the principal investigator (PI) approves it. See the [research-process guide](process/README.md).

[Reader start page](docs/index.html) · [Citation](CITATION.cff)

```text
code/       analysis scripts and downloads
data/       public inputs and reduced inspection panel
outputs/    accepted tables and figures
docs/       results map, reproduction guide, exclusions and start page
process/    research decisions, reviews and AI-use record
release/    manifest, validation, software and release tools
```

## Quick start

From the release folder, with Python available (standard library only; offline, read-only):

```bash
python3 release/release_tools/inspect_release.py
```

This checks every manifest hash, results-map target and local documentation link. It does not rerun estimates. For an isolated run of the available public raw audit, simulation and theme checks, install the recorded Python/R dependencies separately; see [reproduction](docs/REPRODUCIBILITY.md) and [measured blockers](release/validation/DRY_RUN.md).

## Results map

Proposal labels cover the main text and Online Appendix. Manual/inline displays have no associated script; their project-only source paths are marked in the [machine-readable map](docs/RESULTS_MAP.csv). A linked exclusion record means the display itself is withheld. [Script index](code/README.md) · [Output index](outputs/README.md).

| Proposal table / figure | Script | Output / source | Needs Wind |
|---|---|---|---|
| fig:toc_nef | [24_figures.R](code/24_figures.R) | [f_toc_nef.pdf](outputs/figures/f_toc_nef.pdf) | yes |
| tab:summary | not applicable (inline) | `proposal/sections/05_context_data.tex (not in release)` | not applicable |
| tab:identification | not applicable (inline) | `proposal/sections/04_empirical_model.tex (not in release)` | not applicable |
| fig:bunching_date | [24_figures.R](code/24_figures.R) | [f_by_date.pdf](outputs/figures/f_by_date.pdf) | yes |
| tab:robustness | not applicable (inline) | `proposal/tables/t051_robustness.tex (not in release)` | not applicable |
| fig:bunching_frozen | [24_figures.R](code/24_figures.R) | [f_frozen_mi.pdf](outputs/figures/f_frozen_mi.pdf) | yes |
| tab:frozen | not applicable (inline) | `proposal/tables/t050_counterfactuals.tex (not in release)` | not applicable |
| tab:substance | not applicable (inline) | `proposal/sections/06_preliminary_analysis.tex (not in release)` | not applicable |
| tab:threats | not applicable (inline) | `proposal/tables/t049_threats.tex (not in release)` | not applicable |
| tab:variables | not applicable (inline) | `proposal/appendix/variables.tex (not in release)` | not applicable |
| tab:sample_composition | not applicable (inline) | `proposal/tables/t049_sample_composition.tex (not in release)` | not applicable |
| tab:summary_full | [03_figures.R](code/03_figures.R) | [t005_summary_stats.tex](outputs/tables/t005_summary_stats.tex) | yes |
| fig:excess_mass | [24_figures.R](code/24_figures.R) | [f_excess_mass.pdf](outputs/figures/f_excess_mass.pdf) | yes |
| tab:falsification | [19_referee3.R](code/19_referee3.R) | [t055_falsification.tex](outputs/tables/t055_falsification.tex) | yes |
| tab:t040_validation | [13_rl1_validation.R](code/13_rl1_validation.R) | [t040_validation.tex](outputs/tables/t040_validation.tex) | yes |
| fig:t040_scatter | [24_figures.R](code/24_figures.R) | [WITHHELD.md](docs/WITHHELD.md) | yes |
| tab:t040_robustness | [13_rl1_validation.R](code/13_rl1_validation.R) | [t040_robustness.tex](outputs/tables/t040_robustness.tex) | yes |
| tab:t031_samples | [12_q1_robustness.R](code/12_q1_robustness.R) | [t031_samples.tex](outputs/tables/t031_samples.tex) | yes |
| tab:t031_timing | [12_q1_robustness.R](code/12_q1_robustness.R) | [t031_timing.tex](outputs/tables/t031_timing.tex) | yes |
| tab:t043_delta | [15_referee2.R](code/15_referee2.R) | [t043_delta_b.tex](outputs/tables/t043_delta_b.tex) | yes |
| tab:t043_integration | [15_referee2.R](code/15_referee2.R) | [t043_integration.tex](outputs/tables/t043_integration.tex) | yes |
| tab:t043_error | [15_referee2.R](code/15_referee2.R) | [t043_meas_error.tex](outputs/tables/t043_meas_error.tex) | yes |
| fig:t043_error | [24_figures.R](code/24_figures.R) | [f_measurement_error.pdf](outputs/figures/f_measurement_error.pdf) | yes |
| tab:t063_noise | [22_referee5.R](code/22_referee5.R) | [t063_noise.tex](outputs/tables/t063_noise.tex) | yes |
| tab:t061_control | [21_diff_bunching.R](code/21_diff_bunching.R) | [t061_results.tex](outputs/tables/t061_results.tex) | yes |
| fig:t061_control | [24_figures.R](code/24_figures.R) | [f_control_density.pdf](outputs/figures/f_control_density.pdf) | yes |
| tab:t063_window | [22_referee5.R](code/22_referee5.R) | [t063_window.tex](outputs/tables/t063_window.tex) | yes |
| tab:t063_suppliers | [22_referee5.R](code/22_referee5.R) | [t063_control_sens.tex](outputs/tables/t063_control_sens.tex) | yes |
| tab:t063_one_obs | [22_referee5.R](code/22_referee5.R) | [t063_one_obs.tex](outputs/tables/t063_one_obs.tex) | yes |
| fig:t063_dates | [24_figures.R](code/24_figures.R) | [f_distributions_by_date.pdf](outputs/figures/f_distributions_by_date.pdf) | yes |
| fig:t063_dates_control | [24_figures.R](code/24_figures.R) | [f_distributions_by_date.pdf](outputs/figures/f_distributions_by_date.pdf) | yes |
| tab:t076_hk_control | [25_hk_control.R](code/25_hk_control.R) | [t076_hk_control.tex](outputs/tables/t076_hk_control.tex) | yes |
| fig:t076_hk_density | [25_hk_control.R](code/25_hk_control.R) | [f_hk_control_density.pdf](outputs/figures/f_hk_control_density.pdf) | yes |
| tab:t076_hk_roster | [25_hk_control.R](code/25_hk_control.R) | [t076_hk_roster_summary.tex](outputs/tables/t076_hk_roster_summary.tex) | yes |
| tab:t058_pilot | [20_referee4.R](code/20_referee4.R) | [WITHHELD.md](docs/WITHHELD.md) | yes |
| tab:t058_notch | [20_referee4.R](code/20_referee4.R) | [t058_notch.tex](outputs/tables/t058_notch.tex) | yes |
| tab:t058_symmetric | [20_referee4.R](code/20_referee4.R) | [t058_symmetric.tex](outputs/tables/t058_symmetric.tex) | yes |
| tab:t058_attrition | [20_referee4.R](code/20_referee4.R) | [t058_attrition.tex](outputs/tables/t058_attrition.tex) | yes |
| tab:t058_above | [20_referee4.R](code/20_referee4.R) | [t058_above.tex](outputs/tables/t058_above.tex) | yes |
| tab:t058_checks | [20_referee4.R](code/20_referee4.R) | [t058_window.csv](outputs/tables/t058_window.csv) | yes |
| tab:t058_grid | [20_referee4.R](code/20_referee4.R) | [t058_grid.tex](outputs/tables/t058_grid.tex) | yes |
| fig:t058_grid | [24_figures.R](code/24_figures.R) | [f_specification_curve.pdf](outputs/figures/f_specification_curve.pdf) | yes |
| fig:t027_decomposition | [24_figures.R](code/24_figures.R) | [f_crossing_decomposition.pdf](outputs/figures/f_crossing_decomposition.pdf) | yes |
| tab:t041_horizons | [14_core_robustness.R](code/14_core_robustness.R) | [t041_frozen_horizons.tex](outputs/tables/t041_frozen_horizons.tex) | yes |
| tab:t045_rl2 | not applicable (inline) | `proposal/appendix/results.tex (not in release)` | not applicable |
| tab:mi_shift | [19_referee3.R](code/19_referee3.R) | [t055_mi_shift.tex](outputs/tables/t055_mi_shift.tex) | yes |
| fig:kappa | [24_figures.R](code/24_figures.R) | [f_kappa.pdf](outputs/figures/f_kappa.pdf) | yes |
| tab:t043_trend | [15_referee2.R](code/15_referee2.R) | [t043_trend_cf.tex](outputs/tables/t043_trend_cf.tex) | yes |
| tab:t043_heterogeneity | [15_referee2.R](code/15_referee2.R) | [t043_heterogeneity.tex](outputs/tables/t043_heterogeneity.tex) | yes |
| tab:t046_cash | [17_cash_backing_all.R](code/17_cash_backing_all.R) | [t046_cash_backing_all.tex](outputs/tables/t046_cash_backing_all.tex) | yes |
| tab:t045_shares | not applicable (inline) | `proposal/tables/t070_crosser_shares.tex (not in release)` | not applicable |
| tab:t044_comparison | not applicable (inline) | `proposal/appendix/results.tex (not in release)` | not applicable |
| tab:did_main | [02_estimate.R](code/02_estimate.R) | [t009_did_main.tex](outputs/tables/t009_did_main.tex) | yes |
| tab:pretrend | [19_referee3.R](code/19_referee3.R) | [t055_pretrend_tests.tex](outputs/tables/t055_pretrend_tests.tex) | yes |
| tab:t024_rd_main | [07_rd.R](code/07_rd.R) | [t024_rd_main.tex](outputs/tables/t024_rd_main.tex) | yes |
| tab:t066_dr | [23_drdid.R](code/23_drdid.R) | [t066_drdid.csv](outputs/tables/t066_drdid.csv) | yes |
| tab:t066_dr_2 | [23_drdid.R](code/23_drdid.R) | [t066_drdid.csv](outputs/tables/t066_drdid.csv) | yes |
| tab:t066_dr_3 | [23_drdid.R](code/23_drdid.R) | [t066_drdid.csv](outputs/tables/t066_drdid.csv) | yes |
| tab:t066_dr_4 | [23_drdid.R](code/23_drdid.R) | [t066_drdid.csv](outputs/tables/t066_drdid.csv) | yes |
| tab:t066_dr_5 | [23_drdid.R](code/23_drdid.R) | [t066_drdid.csv](outputs/tables/t066_drdid.csv) | yes |
| tab:t066_balance | [23_drdid.R](code/23_drdid.R) | [t066_balance.csv](outputs/tables/t066_balance.csv) | yes |
| tab:t066_balance_2 | [23_drdid.R](code/23_drdid.R) | [t066_balance.csv](outputs/tables/t066_balance.csv) | yes |
| tab:t066_balance_3 | [23_drdid.R](code/23_drdid.R) | [t066_balance.csv](outputs/tables/t066_balance.csv) | yes |
| tab:t066_owner | [23_drdid.R](code/23_drdid.R) | [t066_ownership_bunching.csv](outputs/tables/t066_ownership_bunching.csv) | yes |
| tab:t066_first | [23_drdid.R](code/23_drdid.R) | [t066_first_stage.csv](outputs/tables/t066_first_stage.csv) | yes |
| tab:t066_first_2 | [23_drdid.R](code/23_drdid.R) | [t066_first_stage.csv](outputs/tables/t066_first_stage.csv) | yes |
| tab:t066_heckman | [23_drdid.R](code/23_drdid.R) | [t066_heckman.csv](outputs/tables/t066_heckman.csv) | yes |
| tab:t066_reporting | [23_drdid.R](code/23_drdid.R) | [t066_reporting_same_sample_bunching.csv](outputs/tables/t066_reporting_same_sample_bunching.csv) | yes |
| tab:t066_lee | [09_selection.R](code/09_selection.R) | [t025_lee_bounds.csv](outputs/tables/t025_lee_bounds.csv) | yes |
| fig:t066_overlap_1 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_2 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_3 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_4 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_5 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_6 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_7 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_8 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_9 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_overlap_10 | [24_figures.R](code/24_figures.R) | [f_overlap.pdf](outputs/figures/f_overlap.pdf) | yes |
| fig:t066_pretrends_1 | [24_figures.R](code/24_figures.R) | [f_pretrends.pdf](outputs/figures/f_pretrends.pdf) | yes |
| fig:t066_pretrends_2 | [24_figures.R](code/24_figures.R) | [f_pretrends.pdf](outputs/figures/f_pretrends.pdf) | yes |
| fig:t066_pretrends_3 | [24_figures.R](code/24_figures.R) | [f_pretrends.pdf](outputs/figures/f_pretrends.pdf) | yes |
| fig:t066_pretrends_4 | [24_figures.R](code/24_figures.R) | [f_pretrends.pdf](outputs/figures/f_pretrends.pdf) | yes |
| fig:t066_pretrends_5 | [24_figures.R](code/24_figures.R) | [f_pretrends.pdf](outputs/figures/f_pretrends.pdf) | yes |
| fig:prisma | [24_figures.R](code/24_figures.R) | [f_prisma.pdf](outputs/figures/f_prisma.pdf) | yes |
| tab:wos_queries | not applicable (manual) | `state/litsearch/search_log.csv (not in release)` | not applicable |
| tab:cnki_queries | not applicable (manual) | `state/litsearch/search_log.csv (not in release)` | not applicable |
| tab:further_outputs | not applicable (inline) | `proposal/appendix/results.tex (not in release)` | not applicable |
| tab:ai_use | not applicable (manual) | [AI_USAGE_LOG.md](process/AI_USAGE_LOG.md); [runs.log](process/state/runs.log); [approvals.log](process/state/approvals.log) | not applicable |

## Reproduction levels and limits

**Rerunnable offline:** manifest/link checks; the isolated components documented above require installed dependencies. **Needs licensed Wind:** the full pipeline and developer-panel estimates. **Inspection only:** published aggregate results and the reduced public panel; do not rename it or use it as a replacement sample. A full standalone rebuild is unverified and currently blocked. Obtain your own Wind license and the exact exports in `code/01_clean.R`; additional sibling inputs, later EastMoney exports, external PDFs and literature files remain required. Do not weaken historical integrity gates or fabricate inputs. Full runtime is unmeasured; bootstrap stages can take hours. Fetchers require network/provider access and are not run. Install prerequisites separately: setup may otherwise install packages.

The accepted runners build figures after the doubly robust difference-in-differences (DR-DiD) stage, then embed fonts; `MTPA_INTEGRATE_PROPOSAL` and `MTPA_INTEGRATE_SLIDES` default off and must stay off here. T082 acceptance by PI override addressed historical input drift; it did not certify full reproduction. See the [internal README snapshot](process/replication_README.md) and [approvals](process/state/approvals.log).

Hong Kong (HK) public raw inputs have manifest checks; full HK estimation also needs the licensed developer panel and upstream results. The controls include only firms still listed when the roster was collected and with complete reports. The frequency of missing advance-receipt and contract-liability items differs between controls and developers. Same-market contrasts do not remove developer-specific shocks; support and imputation limits remain in [the limitations record](process/state/LIMITATIONS.md).

**Additional accepted analyses, not yet in the proposal:** T077 is separately accepted by PI override, uses window-probability/triple contrasts rather than the proposal excess-mass estimand, is outcome-informed (see the [integration memo](process/state/integration_memo_2026-11-14.md)), and has pretrend and sparse-support limits. HonestDiD sensitivity analysis was not run; runner integration needs a separate decision. Firm-level panels/membership and potentially licensed inventories remain withheld. Later research code/results are excluded; their process records are historical, not endorsements.

## Data, licenses and research process

[Data guide](data/README.md) · [Data license and provider terms](LICENSE-data.md) · [MIT code license](LICENSE) · [Withheld files](docs/WITHHELD.md) · [Output inventory](release/OUTPUT_INVENTORY.csv). Wind raw files, full/extended panels, Wind-derived firm observations and validation scatterplots are withheld. Aggregates follow the PI release decision; no new provider rights are asserted. Hand-coding source/page and pending verification flags remain as recorded; ownership coding with incomplete primary provenance is withheld.

[Research process and AI use](process/README.md) includes cards, scripts, reviews, decisions and historical diagrams; the T073 audit is merged here with a [path ledger](release/PATH_MAP.csv). Numerical process prose is conservatively redacted; exact results belong to the accepted outputs. Public sanitization removes personal paths, email/credential literals, code-block excerpts and firm-specific excerpts; originals remain unchanged and hashes document differences. Third-party PDFs and other students' work are excluded; [the document register](process/THIRD_PARTY_DOCUMENTS.csv) marks missing URLs.

This named archive is not automatically anonymous. Mirror word replacement does not sanitize image text or Git authors; anonymous use requires inspection of identifiers and Git metadata. See the [identity inventory](release/validation/T084_ANONYMITY.md). Git metadata is excluded from payload scans and the [manifest](release/MANIFEST.csv). The manifest excludes itself and records withheld source hashes explicitly.

## Cite

Anton Wilhelmi (2026), *Meeting the Red Lines: Threshold Targeting and Minority Equity among Chinese Property Developers*, https://github.com/AW0908/three-red-lines-replication. Cite the archive release/commit and access date; no DOI is assigned. Release tags identify accepted archive states.
