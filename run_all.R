# Windows/macOS/Linux: Rscript run_all.R, or source("run_all.R") in replication.Rproj.
(function() {
  # source() supplies ofile; Rscript supplies --file=. Prefer the sourced file
  # when called from another R script. RStudio's project directory is a fallback.
  source_files <- Filter(Negate(is.null), lapply(sys.frames(), function(x) x$ofile))
  args <- commandArgs(trailingOnly = FALSE)
  script_arg <- grep("^--file=", args, value = TRUE)
  script <- if (length(source_files)) tail(source_files, 1L)[[1L]] else
    if (length(script_arg)) sub("^--file=", "", script_arg[[1L]]) else NULL
  if (!is.null(script)) setwd(dirname(normalizePath(script, mustWork = TRUE)))
  if (!file.exists("replication.Rproj") || !file.exists("code/00_setup.R"))
    stop("Working directory must be the replication/ package folder (found: ", getwd(),
         "). Open replication.Rproj and source('run_all.R'), or cd replication and run Rscript run_all.R.")
  set.seed(20261016)
  # system2 quotes the executable path itself and resolves .exe on Windows;
  # shQuote below protects script paths, including project paths with spaces.
  rscript <- file.path(R.home("bin"), "Rscript")
  steps <- c("00_setup.R", "01_clean.R", "01b_extend.R", "03_figures.R", "t008_power.R",
             "02_estimate.R", "04_robustness.R", "05_heterogeneity.R", "06_bunching_tests.R",
             "07_rd.R", "08_decomposition.R", "09_selection.R", "10_controls.R", "11_mechanism.R",
             "12_q1_robustness.R", "14_core_robustness.R", "13_rl1_validation.R", "15_referee2.R", "16_pilot_magnitude.R", "17_cash_backing_all.R", "18_crossers_coding.R", "19_referee3.R", "20_referee4.R", "21_diff_bunching.R", "22_referee5.R", "23_drdid.R", "24_figures.R")
  start <- proc.time()[["elapsed"]]
  for (step in steps) {
    cat("\nRunning", step, "\n")
    flush.console()
    step_start <- proc.time()[["elapsed"]]
    status <- system2(rscript, c("--vanilla", shQuote(file.path("code", step))))
    cat(sprintf("%s: exit %d, %.2f seconds\n", step, status,
                proc.time()[["elapsed"]] - step_start))
    if (status != 0L) stop("Build stopped at ", step, " (exit ", status, ").")
  }
  cat(sprintf("Done: outputs/ rebuilt. Total elapsed: %.2f seconds.\n",
              proc.time()[["elapsed"]] - start))
})()
