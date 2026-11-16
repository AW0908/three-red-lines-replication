#!/bin/bash
# Automated build: from permitted raw data to final outputs.
set -euo pipefail
cd "$(dirname "$0")"

for step in 00_setup.R 01_clean.R 01b_extend.R t008_power.R 02_estimate.R 04_robustness.R 05_heterogeneity.R 06_bunching_tests.R 07_rd.R 08_decomposition.R 09_selection.R 10_controls.R 11_mechanism.R 12_q1_robustness.R 14_core_robustness.R 13_rl1_validation.R 15_referee2.R 16_pilot_magnitude.R 17_cash_backing_all.R 18_crossers_coding.R 19_referee3.R 20_referee4.R 21_diff_bunching.R 22_referee5.R 23_drdid.R 03_figures.R 24_figures.R 25_hk_control.R; do
  echo "Running $step"
  start=$SECONDS
  args=()
  if [[ "$step" == "03_figures.R" ]]; then args+=(--embed-proposal-fonts); fi
  Rscript --vanilla "code/$step" "${args[@]}"
  echo "$step: $((SECONDS - start)) seconds"
done

echo "Done: outputs/ rebuilt."
