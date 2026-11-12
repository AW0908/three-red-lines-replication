# T024: supplementary RL1 RD. Run from replication/: Rscript code/07_rd.R
# Approved amendment 2026-10-21: primary h=0.10; MSE gate >=10 each side.
# Read-only panel; equity-problem exclusion only in the approved robustness rows.
# No dose_pre restriction, imputation or downloads.
source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(stringsAsFactors = FALSE, digits = 10, width = 160)
invisible(Sys.setlocale("LC_NUMERIC", "C"))
for (pkg in c("rdrobust", "rddensity", "ggplot2"))
  if (!requireNamespace(pkg, quietly = TRUE))
    stop("STOP T024: local package unavailable: ", pkg, "; no network installation attempted.")
input <- "data/processed/panel_firm_halfyear.csv"
input_hash <- tools::sha256sum(input)
protected <- list.files("outputs", recursive = TRUE, full.names = TRUE, all.files = TRUE)
protected <- protected[!dir.exists(protected) & !grepl("^t024_", basename(protected))]
protected_hash <- tools::sha256sum(protected)
p <- read.csv(input, na.strings = "NA", colClasses = c(firm_id = "character", date = "character"))
required <- c("firm_id", "date", "sample_main", "market", "listing", "rl1", "rl2", "rl3",
              "rl2_gap", "mi_share", "jv_ta", "ibd", "log_ta", "te", "mi")
stopifnot(all(required %in% names(p)), !anyDuplicated(p[c("firm_id", "date")]))
p <- p[!is.na(p$sample_main) & p$sample_main, ]
stopifnot(!anyNA(p[c("firm_id", "date", "market", "listing")]))
# Absolute amounts are comparable only for A-shares (unresolved HK currencies, D7).
p$log_ibd <- NA_real_
k <- p$market == "A" & is.finite(p$ibd) & p$ibd > 0
p$log_ibd[k] <- log(p$ibd[k])
outcomes <- c("rl1", "rl2", "rl2_gap", "mi_share", "jv_ta", "log_ibd")
labels <- c(rl1 = "RL1", rl2 = "RL2", rl2_gap = "RL2 gap", mi_share = "Minority share",
            jv_ta = "JV / assets", log_ibd = "Log debt (A-shares)")
ids <- sort(unique(p$firm_id))
# Retain even firms without an end-2019 row in the firm audit.
f <- data.frame(firm_id = ids)
at_date <- function(variable, date) {
  z <- p[p$date == date, ]
  z[[variable]][match(ids, z$firm_id)]
}
f$market <- p$market[match(ids, p$firm_id)]
f$listing <- p$listing[match(ids, p$firm_id)]
f$x <- at_date("rl1", "2019-12-31") - 0.70
f$D <- as.integer(at_date("rl1", "2020-06-30") > 0.70)
stopifnot(!any(f$x == 0, na.rm = TRUE)) # rdrobust puts equality on right; policy requires x>0.
pre <- p[p$date >= "2017-06-30" & p$date <= "2019-12-31", ]
post <- p[p$date >= "2020-12-31" & p$date <= "2022-12-31", ]
stopifnot(setequal(unique(post$date), c("2020-12-31", "2021-06-30", "2021-12-31",
                                     "2022-06-30", "2022-12-31")))
mean_by_firm <- function(data, variable) {
  vapply(ids, function(id) {
    v <- data[[variable]][data$firm_id == id]
    if (!any(is.finite(v))) NA_real_ else mean(v[is.finite(v)])
  }, numeric(1))
}
n_by_firm <- function(data, variable) {
  vapply(ids, function(id) sum(is.finite(data[[variable]][data$firm_id == id])), integer(1))
}
f$n_pre_rl1 <- n_by_firm(pre, "rl1")
f$x_mean <- mean_by_firm(pre, "rl1") - 0.70
f$x_mean[f$n_pre_rl1 < 3L] <- NA_real_
stopifnot(!any(f$x_mean == 0, na.rm = TRUE))
for (y in c(outcomes, "rl3")) {
  f[[paste0("base_", y)]] <- at_date(y, "2019-12-31")
  f[[paste0("post_", y)]] <- mean_by_firm(post, y)
  f[[paste0("n_post_", y)]] <- n_by_firm(post, y)
  # Available-date mean; no post observation means no outcome, never a zero.
  f[[paste0("delta_", y)]] <- f[[paste0("post_", y)]] - f[[paste0("base_", y)]]
}
# Audit all post dates, including dates with undefined equity-denominated ratios.
count_post_condition <- function(condition) {
  vapply(ids, function(id) sum(condition[post$firm_id == id], na.rm = TRUE), integer(1))
}
f$n_post_te_nonpos <- count_post_condition(post$te <= 0)
f$n_post_mi_gt_te <- count_post_condition(post$mi > post$te)
post_rl2_extreme <- count_post_condition(post$rl2 > 5) > 0L
f$flag_equity_problem <- f$n_post_te_nonpos > 0L | f$n_post_mi_gt_te > 0L | post_rl2_extreme
stopifnot(!anyNA(f$flag_equity_problem),
          all(f$n_post_te_nonpos >= 0L & f$n_post_te_nonpos <= length(unique(post$date))),
          all(f$n_post_mi_gt_te >= 0L & f$n_post_mi_gt_te <= length(unique(post$date))))
f$placebo_pre_rl1 <- at_date("rl1", "2019-12-31") - at_date("rl1", "2017-12-31")
f$hk_listing <- as.integer(f$market == "HK")
# Panel listing is a register flag, not a delisting date or a predetermined covariate.
f$delisted_later <- as.integer(f$listing == "delisted")
f$log_ta_2019 <- at_date("log_ta", "2019-12-31")
f$log_ta_2019[f$market != "A"] <- NA_real_
f$mi_share_2019 <- at_date("mi_share", "2019-12-31")

# One estimator helper: fixed h implies b=h explicitly, including for bias correction.
# MSE selects both h and b; no covariates, one independent observation per firm.
fit_rd <- function(y, x, D = NULL, h = NULL, p_order = 1L, cutoff = 0) {
  args <- list(y = y, x = x, c = cutoff, p = p_order, q = p_order + 1L,
               kernel = "triangular", bwselect = "mserd", masspoints = "adjust",
               vce = "nn", nnmatch = 3L, level = 95)
  if (!is.null(D)) args$fuzzy <- D
  if (!is.null(h)) { args$h <- h; args$b <- h }
  do.call(rdrobust::rdrobust, args)
}
# Explicit fields distinguish conventional point estimates from RBC inference.
extract_rd <- function(r, outcome, design, specification, running, gate) {
  fs <- design == "fuzzy"
  data.frame(outcome = outcome, design = design, specification = specification,
    running = running, cutoff = r$c, p = r$p, q = r$q, kernel = "triangular", vce = "nn",
    h_left = r$bws["h", 1], h_right = r$bws["h", 2],
    b_left = r$bws["b", 1], b_right = r$bws["b", 2],
    N_left = r$N[1], N_right = r$N[2], N_eff_left = r$N_h[1], N_eff_right = r$N_h[2],
    N_bias_left = r$N_b[1], N_bias_right = r$N_b[2],
    estimate = r$coef[1, 1], estimate_bc = r$coef[3, 1], se_robust = r$se[3, 1],
    ci_lower = r$ci[3, 1], ci_upper = r$ci[3, 2], z_robust = r$z[3, 1], p_robust = r$pv[3, 1],
    first_stage = if (fs) r$tau_T[1] else NA_real_,
    first_stage_bc = if (fs) r$tau_T[3] else NA_real_,
    first_stage_se_robust = if (fs) r$se_T[3] else NA_real_,
    first_stage_ci_lower = if (fs) r$ci_T[3, 1] else NA_real_,
    first_stage_ci_upper = if (fs) r$ci_T[3, 2] else NA_real_,
    first_stage_z_robust = if (fs) r$z_T[3] else NA_real_,
    first_stage_p_robust = if (fs) r$pv_T[3] else NA_real_,
    first_stage_z2_robust = if (fs) r$z_T[3]^2 else NA_real_,
    weak_first_stage_ci_contains_zero = if (fs) r$ci_T[3, 1] <= 0 & r$ci_T[3, 2] >= 0 else NA,
    gate_mse_h_left = gate$bws["h", 1], gate_mse_h_right = gate$bws["h", 2],
    gate_mse_N_left = gate$N_h[1], gate_mse_N_right = gate$N_h[2],
    status = "estimated",
    note = if (min(r$N_h) < 20L) sprintf("Few firms near cutoff: n left=%d, right=%d; low power", r$N_h[1], r$N_h[2]) else "Low-powered supplementary RD",
    row.names = NULL)
}
main_rows <- robustness_rows <- list()
models <- list()
for (running in c("x", "x_mean")) for (y in outcomes) for (design in c("sharp", "fuzzy")) {
  ok <- is.finite(f[[running]]) & is.finite(f[[paste0("delta_", y)]])
  if (design == "fuzzy") ok <- ok & !is.na(f$D)
  dat <- f[ok, ]
  D <- if (design == "fuzzy") dat$D else NULL
  gate <- fit_rd(dat[[paste0("delta_", y)]], dat[[running]], D)
  specifications <- if (running == "x") c("fixed_0.10_primary", "mse_optimal", "fixed_0.05", "fixed_0.15", "quadratic_0.10") else "mean_running_0.10"
  for (spec in specifications) {
    order <- if (spec == "quadratic_0.10") 2L else 1L
    h <- switch(spec, mse_optimal = NULL, fixed_0.05 = 0.05, fixed_0.15 = 0.15, 0.10)
    if (min(gate$N_h) < 10L) {
      # Approved gate: counts only for this outcome/design/running variable.
      row <- extract_rd(gate, y, design, spec, running, gate)
      infer <- c("estimate", "estimate_bc", "se_robust", "ci_lower", "ci_upper", "z_robust", "p_robust",
                 "first_stage", "first_stage_bc", "first_stage_se_robust", "first_stage_ci_lower",
                 "first_stage_ci_upper", "first_stage_z_robust", "first_stage_p_robust", "first_stage_z2_robust")
      row[infer] <- NA_real_
      row$weak_first_stage_ci_contains_zero <- NA
      row$status <- "counts_only_mse_below_10"
      row$note <- "MSE gate below 10 on at least one side; bandwidth/count columns describe the MSE gate only"
    } else {
      r <- if (spec == "mse_optimal") gate else fit_rd(dat[[paste0("delta_", y)]], dat[[running]], D, h, order)
      row <- extract_rd(r, y, design, spec, running, gate)
      models[[paste(y, design, spec, sep = "/")]] <- r
    }
    # Base and missingness counts all use the same candidate running variable.
    eligible <- is.finite(f[[running]]) & (y != "log_ibd" | f$market == "A")
    row$base_N_left <- sum(eligible & f[[running]] < 0)
    row$base_N_right <- sum(eligible & f[[running]] > 0)
    row$missing_outcome_left <- sum(eligible & f[[running]] < 0 & !is.finite(f[[paste0("delta_", y)]]))
    row$missing_outcome_right <- sum(eligible & f[[running]] > 0 & !is.finite(f[[paste0("delta_", y)]]))
    row$missing_D_left <- if (design == "fuzzy") sum(eligible & f[[running]] < 0 & is.finite(f[[paste0("delta_", y)]]) & is.na(f$D)) else 0L
    row$missing_D_right <- if (design == "fuzzy") sum(eligible & f[[running]] > 0 & is.finite(f[[paste0("delta_", y)]]) & is.na(f$D)) else 0L
    stopifnot(row$base_N_left - row$missing_outcome_left - row$missing_D_left == row$N_left,
              row$base_N_right - row$missing_outcome_right - row$missing_D_right == row$N_right)
    key <- paste(running, y, design, spec, sep = "/")
    if (spec == "fixed_0.10_primary") main_rows[[key]] <- row else robustness_rows[[key]] <- row
  }
}
# Round 4: exactly two additional sharp h=b=0.10 rows; main results unchanged.
for (y in c("rl2", "mi_share")) {
  eligible <- is.finite(f$x) & !f$flag_equity_problem
  ok <- eligible & is.finite(f[[paste0("delta_", y)]])
  dat <- f[ok, ]
  gate <- fit_rd(dat[[paste0("delta_", y)]], dat$x)
  r <- if (min(gate$N_h) < 10L) gate else fit_rd(dat[[paste0("delta_", y)]], dat$x, h = 0.10)
  row <- extract_rd(r, y, "sharp", "exclude_equity_problem_0.10", "x", gate)
  if (min(gate$N_h) < 10L) {
    row <- extract_rd(gate, y, "sharp", "exclude_equity_problem_0.10", "x", gate)
    row[c("estimate", "estimate_bc", "se_robust", "ci_lower", "ci_upper", "z_robust", "p_robust")] <- NA_real_
    row$status <- "counts_only_mse_below_10"
    row$note <- "MSE gate below 10 on at least one side; bandwidth/count columns describe the MSE gate only"
  }
  row$base_N_left <- sum(eligible & f$x < 0)
  row$base_N_right <- sum(eligible & f$x > 0)
  row$missing_outcome_left <- sum(eligible & f$x < 0 & !is.finite(f[[paste0("delta_", y)]]))
  row$missing_outcome_right <- sum(eligible & f$x > 0 & !is.finite(f[[paste0("delta_", y)]]))
  row$missing_D_left <- row$missing_D_right <- 0L
  stopifnot(row$base_N_left - row$missing_outcome_left == row$N_left,
            row$base_N_right - row$missing_outcome_right == row$N_right)
  row$note <- paste(row$note, sprintf(paste0(
    "Exclude firms with any post te <= 0, mi > te or rl2 > 5 (LIMITATIONS D22); ",
    "flagged baseline firms within +/-0.10: %d left, %d right; outcome construction unchanged"),
    sum(is.finite(f$x) & f$x >= -0.10 & f$x < 0 & f$flag_equity_problem),
    sum(is.finite(f$x) & f$x > 0 & f$x <= 0.10 & f$flag_equity_problem)), sep = "; ")
  robustness_rows[[paste(y, "exclude_equity_problem_0.10", sep = "/")]] <- row
}
main <- do.call(rbind, main_rows); robustness <- do.call(rbind, robustness_rows)
rownames(main) <- rownames(robustness) <- NULL
stopifnot(nrow(main) == 12L, nrow(robustness) == 62L)
weak_label <- "weak first stage -- CI not interpretable"
for (object in c("main", "robustness")) {
  rows <- get(object)
  weak <- rows$design == "fuzzy" & rows$status == "estimated"
  stopifnot(all(rows$weak_first_stage_ci_contains_zero[weak]))
  rows$note[weak] <- paste(rows$note[weak], weak_label, sep = "; ")
  assign(object, rows)
}
rl1_mse <- models[["rl1/sharp/mse_optimal"]]
stopifnot(!is.null(rl1_mse), rl1_mse$N_h[1] == 14L, rl1_mse$N_h[2] == 22L)
robustness_note <- sprintf(paste0("The MSE-bandwidth RL1 sharp robustness has few firms left of the cutoff, n = %d (%d right); ",
  "the approved minimum is %d per side. Low-powered RD, supplementary to the bunching and decomposition evidence."),
  rl1_mse$N_h[1], rl1_mse$N_h[2], 10L)
is_rl1_mse <- robustness$outcome == "rl1" & robustness$design == "sharp" & robustness$specification == "mse_optimal"
stopifnot(sum(is_rl1_mse) == 1L, robustness$N_eff_left[is_rl1_mse] == rl1_mse$N_h[1])
robustness$note[is_rl1_mse] <- paste(robustness$note[is_rl1_mse], robustness_note, sep = "; ")

# Full baseline density sample, independent of post-policy outcome availability.
x <- f$x[is.finite(f$x)]
density <- rddensity::rddensity(X = x, c = 0, p = 2, q = 3,
  kernel = "triangular", fitselect = "unrestricted", vce = "jackknife", bwselect = "comb")
stopifnot(length(x) == 135L, length(x) == density$N$left + density$N$right,
          length(x) == sum(is.finite(f$x)))
density_note <- sprintf(paste0("Density uses all %d end-2019 RL1 observations, local quadratic density with cubic bias correction, ",
  "jackknife SE and package-selected bandwidths."), length(x))
valid_row <- function(test, outcome, cutoff = 0, estimate = NA_real_, estimate_bc = NA_real_,
                      se = NA_real_, lower = NA_real_, upper = NA_real_, statistic = NA_real_,
                      p_value = NA_real_, N_left, N_right, eff_left, eff_right, h_left, h_right,
                      note, p_order = 1L, q_order = 2L) {
  data.frame(test = test, outcome = outcome, cutoff = cutoff, estimate = estimate,
    estimate_bc = estimate_bc, se_robust = se, ci_lower = lower, ci_upper = upper,
    statistic = statistic, p_robust = p_value, N_left = N_left, N_right = N_right,
    N_eff_left = eff_left, N_eff_right = eff_right, h_left = h_left, h_right = h_right,
    p = p_order, q = q_order, null_in_95_ci = if (is.finite(lower)) lower <= 0 & upper >= 0 else NA,
    rejects_at_0.05_unadjusted = p_value < 0.05, note = note)
}
valid_rows <- list(valid_row("density_rddensity", "2019 RL1 density", estimate_bc = density$hat$diff,
  se = density$sd_jk$diff, lower = density$hat$diff - qnorm(0.975) * density$sd_jk$diff,
  upper = density$hat$diff + qnorm(0.975) * density$sd_jk$diff,
  statistic = density$test$t_jk, p_value = density$test$p_jk,
  N_left = density$N$left, N_right = density$N$right,
  eff_left = density$N$eff_left, eff_right = density$N$eff_right,
  h_left = density$h$left, h_right = density$h$right, p_order = 2L, q_order = 3L,
  note = "RBC density difference right minus left; jackknife SE; no outcome filtering"))
for (v in c("placebo_pre_rl1", "hk_listing", "delisted_later", "log_ta_2019", "mi_share_2019")) {
  ok <- is.finite(f$x) & is.finite(f[[v]])
  r <- fit_rd(f[[v]][ok], f$x[ok], h = 0.10)
  note <- switch(v, delisted_later = "Later-delisted panel register flag; timing not dated in panel; post-treatment diagnostic, not predetermined balance",
    log_ta_2019 = "A-shares only; HK reporting currencies unresolved",
    placebo_pre_rl1 = "RL1 on 2019-12-31 minus RL1 on 2017-12-31; may reflect mean reversion",
    "End-2019 covariate; no added controls")
  valid_rows[[length(valid_rows) + 1L]] <- valid_row("placebo_or_balance", v, estimate = r$coef[1, 1],
    estimate_bc = r$coef[3, 1], se = r$se[3, 1], lower = r$ci[3, 1], upper = r$ci[3, 2],
    statistic = r$z[3, 1], p_value = r$pv[3, 1], N_left = r$N[1], N_right = r$N[2],
    eff_left = r$N_h[1], eff_right = r$N_h[2], h_left = r$bws[1, 1], h_right = r$bws[1, 2], note = note)
}
# Same primary RL1 change and h=0.10 at all four approved placebo cutoffs.
# Negative cutoffs use x<0 only, positive cutoffs x>0 only. The nominal
# h=b=0.10 is unchanged; support (including bias estimation) stops at zero.
for (cutoff in c(-0.10, -0.05, 0.05, 0.10)) {
  ok <- is.finite(f$x) & is.finite(f$delta_rl1)
  ok <- ok & if (cutoff < 0) f$x < 0 else f$x > 0
  stopifnot(all(f$x[ok] * cutoff > 0))
  r <- fit_rd(f$delta_rl1[ok], f$x[ok], h = 0.10, cutoff = cutoff)
  stopifnot(r$N_h[1] == sum(ok & f$x >= cutoff - 0.10 & f$x < cutoff),
            r$N_h[2] == sum(ok & f$x >= cutoff & f$x <= cutoff + 0.10))
  valid_rows[[length(valid_rows) + 1L]] <- valid_row("placebo_cutoff", "delta_rl1", cutoff,
    estimate = r$coef[1, 1], estimate_bc = r$coef[3, 1], se = r$se[3, 1],
    lower = r$ci[3, 1], upper = r$ci[3, 2], statistic = r$z[3, 1], p_value = r$pv[3, 1],
    N_left = r$N[1], N_right = r$N[2], eff_left = r$N_h[1], eff_right = r$N_h[2],
    h_left = r$bws[1, 1], h_right = r$bws[1, 2],
    note = paste0("Primary RL1 change; fixed h=b=0.10; ", if (cutoff < 0) "x<0 only" else "x>0 only",
                  "; estimation and bias windows truncated at true cutoff 0; effective N reported"))
}
for (j in seq_along(density$bino$pval)) {
  valid_rows[[length(valid_rows) + 1L]] <- valid_row("density_binomial", paste("Window", j),
    p_value = density$bino$pval[j], N_left = density$N$left, N_right = density$N$right,
    eff_left = density$bino$LeftN[j], eff_right = density$bino$RightN[j],
    h_left = density$bino$LeftWindow[j], h_right = density$bino$RightWindow[j],
    p_order = NA_integer_, q_order = NA_integer_,
    note = "Supplementary rddensity exact binomial test; null right-side probability 0.5; unadjusted multiple windows")
}
validity <- do.call(rbind, valid_rows)
stopifnot(nrow(validity) == 20L, sum(validity$test == "placebo_cutoff") == 4L)

# Audit counts do not assume the outcome is available.
count_rows <- list()
for (y in c("rl1", "rl2", "rl3")) for (h in c(0.05, 0.10, 0.15, 0.50)) {
  threshold <- if (y == "rl1") 0.70 else 1
  xx <- f[[paste0("base_", y)]] - threshold
  for (sample in c("all_baseline", "available_change")) {
    ok <- is.finite(xx)
    if (sample == "available_change") ok <- ok & is.finite(f[[paste0("delta_", y)]])
    count_rows[[length(count_rows) + 1L]] <- data.frame(ratio = y, sample = sample, threshold = threshold,
      half_window = h, N_left = sum(ok & xx < 0), N_right = sum(ok & xx > 0), N_at_cutoff = sum(ok & xx == 0),
      N_near_left = sum(ok & xx >= -h & xx < 0), N_near_right = sum(ok & xx > 0 & xx <= h))
  }
}
counts <- do.call(rbind, count_rows)
co_pi <- counts[counts$ratio == "rl1" & counts$sample == "all_baseline" & counts$half_window == 0.10, ]
stopifnot(co_pi$N_near_left == 28L, co_pi$N_near_right == 45L, co_pi$N_at_cutoff == 0L)

# Stage every T024 artifact, then publish only after all checks pass.
stage <- tempfile("t024_stage_"); dir.create(stage)
write_csv <- function(d, name) mtpa_write_csv(d, file.path(stage, name), row.names = FALSE)
write_csv(main, "t024_rd_main.csv")
write_csv(robustness, "t024_rd_robustness.csv")
write_csv(validity, "t024_rd_validity.csv")
write_csv(counts, "t024_sample_counts.csv")
write_csv(f, "t024_firm_audit.csv")

# Escape all ordinary text; table structure alone contains TeX commands.
escape_tex <- function(s) {
  s <- gsub("\\", "\\textbackslash{}", s, fixed = TRUE)
  for (char in c("&", "%", "$", "#", "_", "{", "}")) s <- gsub(char, paste0("\\", char), s, fixed = TRUE)
  s <- gsub("<", "\\textless{}", s, fixed = TRUE)
  s <- gsub(">", "\\textgreater{}", s, fixed = TRUE)
  s
}
fmt <- function(z) ifelse(is.finite(z), sprintf("%.4f", z), "--")
ci <- function(l, u) ifelse(is.finite(l) & is.finite(u), paste0("[", fmt(l), ", ", fmt(u), "]"), "--")
tex_table <- function(caption, label, headers, rows, notes) {
  c("\\begin{table}[!htbp]", "\\centering\\small", paste0("\\caption{", escape_tex(caption), "}"),
    paste0("\\label{", label, "}"), "\\resizebox{\\ifdim\\width>\\linewidth\\linewidth\\else\\width\\fi}{!}{%",
    paste0("\\begin{tabular}{l", paste(rep("r", length(headers) - 1L), collapse = ""), "}"),
    "\\toprule", paste0(paste(escape_tex(headers), collapse = " & "), " \\\\"), "\\midrule",
    rows, "\\bottomrule", "\\end{tabular}}", "\\par\\smallskip",
    "\\begin{minipage}{\\linewidth}\\footnotesize", escape_tex(paste(notes, collapse = " ")),
    "\\end{minipage}", "\\end{table}")
}
row_tex <- function(values) paste0(paste(escape_tex(values), collapse = " & "), " \\\\")
common_notes <- c("Low-powered RD, supplementary to the bunching and decomposition evidence.",
  "One observation per main-sample firm; positive running variable means breaching side.",
  "Primary local linear fit: triangular kernel, h = b = 0.10, quadratic bias correction, nearest-neighbor robust SE.",
  "Point is the conventional estimate; BC and 95% CI use robust bias correction. No significance stars; p-values unadjusted.",
  "Changes are available-date means over 2020H2-2022H2 minus end-2019, with no imputation or outlier trimming.",
  "RL2 and the minority share are undefined for nonpositive equity and extreme for small positive equity; results for these outcomes may be driven by few firms (see robustness and LIMITATIONS D22).",
  "Log debt is undefined for zero debt.",
  "Absolute levels (log debt and log assets) use A-shares only because HK currencies are unresolved.",
  "Missing post means or baseline values are dropped separately for each outcome; missing June-2020 RL1 is additionally dropped for fuzzy RD.",
  "RL2 gap often equals zero mechanically when perpetual items are missing (D19); RL1 is not economic leverage (D20).")
# Sharp-table wording omits the fuzzy-only sample rule and the validity-only covariate.
sharp_notes <- sub("log debt and log assets", "log debt", common_notes, fixed = TRUE)
sharp_notes <- sub("; missing June-2020 RL1 is additionally dropped for fuzzy RD", "", sharp_notes, fixed = TRUE)
sharp <- main[main$design == "sharp", ]
main_tex <- tex_table("Supplementary RL1 sharp regression discontinuity (ITT): primary fixed bandwidth", "tab:t024_rd_main",
  c("Outcome / design", "Point", "BC", "Robust 95% CI", "N left", "N right"),
  vapply(seq_len(nrow(sharp)), function(i) {
    z <- sharp[i, ]; row_tex(c(paste(labels[[z$outcome]], z$design), fmt(z$estimate), fmt(z$estimate_bc),
                              ci(z$ci_lower, z$ci_upper), z$N_eff_left, z$N_eff_right))
  }, character(1)), c(sharp_notes,
    "N left/right are effective counts in the estimation window; complete-sample and dropped counts are in the CSV.",
    "Sharp estimates are local ITT contrasts for end-2019 threshold position.",
    "Causal interpretation requires continuous potential outcomes, no precise sorting and no other discontinuity at 0.70.",
    "Fuzzy estimates and first-stage diagnostics are reported separately because the first stage is weak."))
fs <- main[main$design == "fuzzy", ]
fs_tex <- tex_table("Fuzzy RD: first-stage jump in the June-2020 breach indicator", "tab:t024_rd_first_stage",
  c("Outcome sample", "Point", "BC", "Robust 95% CI", "Robust p", "Robust z squared"),
  vapply(seq_len(nrow(fs)), function(i) {
    z <- fs[i, ]; row_tex(c(labels[[z$outcome]], fmt(z$first_stage), fmt(z$first_stage_bc),
      ci(z$first_stage_ci_lower, z$first_stage_ci_upper), fmt(z$first_stage_p_robust), fmt(z$first_stage_z2_robust)))
  }, character(1)), c("Same firms, kernel and bandwidths as each fuzzy outcome regression.",
    "Robust z squared is a one-parameter Wald strength diagnostic, not a conventional first-stage F statistic or a weak-instrument-robust test.",
    "A CI containing zero signals weak evidence of a first-stage jump; do not interpret a large fuzzy point estimate as a precise effect.",
    "All corresponding fuzzy estimates are labeled weak first stage -- CI not interpretable."))
fuzzy_tex <- tex_table("Supplementary fuzzy RD: weak first stage", "tab:t024_rd_fuzzy",
  c("Outcome / warning", "Point", "BC", "Robust 95% CI", "N left", "N right"),
  vapply(seq_len(nrow(fs)), function(i) {
    z <- fs[i, ]
    label <- paste0("\\shortstack[l]{", escape_tex(paste(labels[[z$outcome]], "fuzzy")),
                    "\\\\", escape_tex(weak_label), "}")
    paste0(label, " & ", row_tex(c(fmt(z$estimate), fmt(z$estimate_bc),
      ci(z$ci_lower, z$ci_upper), z$N_eff_left, z$N_eff_right)))
  }, character(1)), c(common_notes,
    "Every first-stage robust CI contains zero; normal-approximation fuzzy CIs and p-values are not interpretable as valid inference.",
    "Displayed intervals are not weak-instrument robust; no weak-IV-robust CI is calculated in this card.",
    "Fuzzy targets the June-2020 breach-status effect for local compliers only under relevance, exclusion, monotonicity and the RD continuity assumptions."))
mtpa_write_lines(main_tex, file.path(stage, "t024_rd_main.tex"))
mtpa_write_lines(c(fs_tex, "", fuzzy_tex), file.path(stage, "t024_rd_fuzzy.tex"))
mtpa_write_lines(c("\\par\\noindent\\begin{minipage}{\\linewidth}\\footnotesize", escape_tex(robustness_note),
                   "\\end{minipage}\\par"), file.path(stage, "t024_rd_robustness_note.tex"))
valid_labels <- c(placebo_pre_rl1 = "Pre-policy RL1 change", hk_listing = "HK listing",
  delisted_later = "Later-delisted register flag", log_ta_2019 = "Log assets (A-shares)", mi_share_2019 = "Minority share 2019")
valid_tex <- tex_table("RL1 RD validity checks", "tab:t024_rd_validity",
  c("Test", "Cutoff", "BC", "Robust 95% CI", "p", "N left", "N right"),
  vapply(seq_len(10L), function(i) {
    z <- validity[i, ]; label <- if (z$test == "density_rddensity") "Density (jackknife)" else
      if (z$test == "placebo_cutoff") "Placebo cutoff: RL1 change" else valid_labels[[z$outcome]]
    row_tex(c(label, fmt(z$cutoff), fmt(z$estimate_bc), ci(z$ci_lower, z$ci_upper), fmt(z$p_robust), z$N_eff_left, z$N_eff_right))
  }, character(1)), c("RD rows use local linear triangular fits with h = b = 0.10 and robust bias-corrected 95% CIs; counts are effective N.",
    density_note,
    "Pre-policy RL1 change is end-2019 minus end-2017; its baseline construction can induce mean reversion.",
    "Later-delisted is the panel register indicator; the panel supplies no delisting date. It is a post-treatment diagnostic, not a predetermined covariate.",
    "Log assets uses A-shares only; minority share is end-2019. Negative placebo cutoffs use only x < 0, positive cutoffs only x > 0; nominal h = b = 0.10 windows are truncated at zero, including bias estimation.",
    "All requested checks are reported whether their CIs contain zero or not. Unadjusted multiple tests and low power limit interpretation; non-rejection does not establish validity."))
bin <- validity[validity$test == "density_binomial", ]
bin_tex <- tex_table("Supplementary exact binomial density checks", "tab:t024_rd_binomial",
  c("Window", "Width left", "Width right", "N left", "N right", "p"),
  vapply(seq_len(nrow(bin)), function(i) {
    z <- bin[i, ]; row_tex(c(i, fmt(z$h_left), fmt(z$h_right), z$N_eff_left, z$N_eff_right, fmt(z$p_robust)))
  }, character(1)), c("All ten default rddensity windows are shown; null probability on each side is 0.5.",
    "Exact binomial tests supplement the primary robust density test; p-values are unadjusted across overlapping windows."))
mtpa_write_lines(c(valid_tex, "", bin_tex), file.path(stage, "t024_rd_validity.tex"))

# Graphical bins and fits: visualization ranges do not restrict estimation samples.
plot_bins <- list(); plot_fits <- list()
for (y in c("rl1", "rl2", "rl3")) {
  threshold <- if (y == "rl1") 0.70 else 1
  window <- if (y == "rl1") 0.15 else 0.50
  width <- if (y == "rl1") 0.02 else 0.10
  xx <- f[[paste0("base_", y)]] - threshold; yy <- f[[paste0("delta_", y)]]
  ok <- is.finite(xx) & is.finite(yy) & abs(xx) <= window
  z <- data.frame(x = xx[ok], y = yy[ok])
  z$bin <- floor(z$x / width)
  bins <- do.call(rbind, lapply(split(z, z$bin), function(v) data.frame(
    ratio = y, bin = v$bin[1], x = mean(v$x), change = mean(v$y), N = nrow(v))))
  rownames(bins) <- NULL; plot_bins[[y]] <- bins
  nr <- counts[counts$ratio == y & counts$sample == "available_change" & counts$half_window == 0.10, ]
  caption <- sprintf("One point per nonempty bin; point area reflects firms. Bin width %.2f; displayed window +/-%.2f.\nNear cutoff (+/-0.10), outcome available: %d below / %d above.", width, window, nr$N_near_left, nr$N_near_right)
  g <- ggplot2::ggplot(bins, ggplot2::aes(x, change)) +
    ggplot2::geom_vline(xintercept = 0, linetype = "dashed", colour = "grey45") +
    ggplot2::geom_point(ggplot2::aes(size = N), colour = "#245577", alpha = 0.85) +
    ggplot2::scale_size_area(max_size = 5, name = "Firms in bin") +
    ggplot2::scale_x_continuous(limits = c(-window, window)) +
    ggplot2::labs(title = paste0(toupper(y), ": change at the end-2019 threshold"),
      subtitle = if (y == "rl1") "Binned scatter with local linear fits; supplementary, low-powered RD" else
        "Graphical only: few firms near the cutoff; no RD estimates or fitted discontinuity",
      x = sprintf("End-2019 %s minus %.2f", toupper(y), threshold),
      y = "Mean 2020H2-2022H2 minus end-2019 (ratio units)", caption = caption) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
      plot.caption = ggplot2::element_text(hjust = 0, size = 9),
      plot.subtitle = ggplot2::element_text(size = 10), plot.margin = ggplot2::margin(12, 16, 12, 14))
  if (y == "rl1") {
    # Directly use conventional local-linear coefficients of the main sharp model.
    r <- models[["rl1/sharp/fixed_0.10_primary"]]
    stopifnot(!is.null(r))
    fit <- do.call(rbind, lapply(c("left", "right"), function(side) {
      grid <- if (side == "left") seq(-0.10, 0, length.out = 101) else seq(0, 0.10, length.out = 101)
      beta <- if (side == "left") r$beta_Y_p_l else r$beta_Y_p_r
      data.frame(side = side, x = grid, change = beta[1] + beta[2] * grid)
    }))
    stopifnot(abs((fit$change[102] - fit$change[101]) - r$coef[1, 1]) < 1e-12)
    plot_fits[[y]] <- fit
    g <- g + ggplot2::geom_line(data = fit, ggplot2::aes(x, change, group = side),
      inherit.aes = FALSE, colour = "#B65D29", linewidth = 0.8) +
      ggplot2::labs(caption = paste0(caption, "\nLines: triangular local linear fits within +/-0.10; displayed point jump is conventional, not BC."))
  }
  ggplot2::ggsave(file.path(stage, paste0("t024_rdplot_", y, ".pdf")), g,
    device = grDevices::pdf, width = 9.5, height = 5.8, timestamp = FALSE, useDingbats = FALSE)
}
write_csv(do.call(rbind, plot_bins), "t024_plot_bins.csv")
write_csv(plot_fits[["rl1"]], "t024_plot_fits.csv")
dp <- rddensity::rdplotdensity(density, x, plotRange = c(-0.20, 0.20), plotN = 25,
  noPlot = TRUE, title = "RL1 end-2019 density around the cutoff",
  xlabel = "End-2019 RL1 minus 0.70", ylabel = "Density")
dg <- dp$Estplot + ggplot2::geom_vline(xintercept = 0, linetype = "dashed", colour = "grey45") + ggplot2::labs(subtitle = "Local polynomial density; robust pointwise 95% confidence regions",
  caption = sprintf("All %d baseline firms; jackknife robust density test p = %.4f.\nCurves: order 2; CI centering and test: order 3 bias correction.\nNon-rejection does not establish absence of sorting; supplementary binomial tests are reported in full.", length(x), density$test$p_jk)) +
  ggplot2::theme(plot.caption = ggplot2::element_text(hjust = 0, size = 9),
    plot.subtitle = ggplot2::element_text(size = 10), plot.margin = ggplot2::margin(12, 16, 12, 14))
ggplot2::ggsave(file.path(stage, "t024_density_rl1.pdf"), dg,
  device = grDevices::pdf, width = 9.5, height = 5.8, timestamp = FALSE, useDingbats = FALSE)
write_csv(rbind(data.frame(side = "left", dp$Estl$Estimate), data.frame(side = "right", dp$Estr$Estimate)), "t024_density_grid.csv")

stopifnot(identical(input_hash, tools::sha256sum(input)),
          identical(protected_hash, tools::sha256sum(protected)))
files <- sort(list.files(stage, full.names = TRUE))
for (path in files) {
  target_dir <- if (tools::file_ext(path) == "pdf") "outputs/figures" else "outputs/tables"
  stopifnot(file.copy(path, file.path(target_dir, basename(path)), overwrite = TRUE))
}
unlink(stage, recursive = TRUE)
cat(sprintf("T024: %d main-sample firms; %d finite end-2019 RL1; %d available RL1 changes.\n",
  nrow(f), sum(is.finite(f$x)), sum(is.finite(f$x) & is.finite(f$delta_rl1))))
cat(sprintf("RL1 within +/-0.10 (baseline): %d below / %d above; equality: %d.\n",
  co_pi$N_near_left, co_pi$N_near_right, co_pi$N_at_cutoff))
cat("Primary: h=b=0.10; all estimates supplementary and low-powered; no weak-IV-robust fuzzy inference.\n")
print(main[c("outcome", "design", "estimate", "estimate_bc", "ci_lower", "ci_upper", "N_eff_left", "N_eff_right", "first_stage_z2_robust")], row.names = FALSE)
cat(sprintf("EQUITY AUDIT: %d/%d firms flagged; %d with post te <= 0; %d with post mi > te; %d with post rl2 > 5.\n",
  sum(f$flag_equity_problem), nrow(f), sum(f$n_post_te_nonpos > 0L),
  sum(f$n_post_mi_gt_te > 0L), sum(post_rl2_extreme)))
cat("APPROVED EQUITY-EXCLUSION ROBUSTNESS:\n")
print(robustness[robustness$specification == "exclude_equity_problem_0.10",
  c("outcome", "status", "estimate", "estimate_bc", "ci_lower", "ci_upper", "p_robust",
    "N_eff_left", "N_eff_right", "gate_mse_N_left", "gate_mse_N_right")], row.names = FALSE)
cat("VALIDITY CHECKS (all tests, unadjusted):\n")
print(validity[c("test", "outcome", "cutoff", "ci_lower", "ci_upper", "p_robust", "N_eff_left", "N_eff_right")], row.names = FALSE)
cat(sprintf("T024 completed: %d primary rows; %d robustness rows (%d counts-only); %d validity rows; %d PDFs.\n",
  nrow(main), nrow(robustness), sum(robustness$status != "estimated"), nrow(validity),
  sum(tools::file_ext(files) == "pdf")))
cat(sprintf("T024 guards: read-only panel and %d protected non-T024 outputs byte-identical.\n", length(protected)))
