# T023: descriptive diagnostics of threshold targeting, not causal evidence of evasion.
# Run from replication/: Rscript code/06_bunching_tests.R
# Read-only inputs; all published files have the t023_ prefix.
source("code/00_setup.R", local = TRUE)
suppressPackageStartupMessages(library(ggplot2))
set.seed(20261016)
options(digits = 17)
B <- 999L
input <- "data/processed/panel_firm_halfyear.csv"
reference <- "outputs/tables/t005_bunching_counts.csv"
input_hash <- tools::sha256sum(c(input, reference))
protected <- list.files("outputs", recursive = TRUE, full.names = TRUE, all.files = TRUE)
protected <- protected[!grepl("^t023_", basename(protected)) & !dir.exists(protected)]
protected_hash <- tools::sha256sum(protected)
d <- read.csv(input, stringsAsFactors = FALSE, na.strings = c("", "NA"))
required <- c("firm_id", "date", "sample_main", "rl1", "rl1_alt", "rl2", "rl2_adj",
              "ibd", "cash", "ta", "te", "mi_share", "perp_te", "jv_ta",
              "adv", "adv_missing", "perp_missing", "fye_flag")
if (length(setdiff(required, names(d)))) stop("STOP: required panel columns absent.")
panel_fye_firms <- unique(d$firm_id[!is.na(d$fye_flag) & d$fye_flag])
d <- d[!is.na(d$sample_main) & d$sample_main, ]
d$date <- as.Date(d$date)
d <- d[order(d$firm_id, d$date), ]
stopifnot(!anyDuplicated(d[c("firm_id", "date")]),
          all(format(d$date, "%m-%d") %in% c("06-30", "12-31")))
d$period <- ifelse(d$date >= as.Date("2017-06-30") & d$date <= as.Date("2019-12-31"),
                   "pre", ifelse(d$date >= as.Date("2020-12-31") &
                                   d$date <= as.Date("2022-12-31"), "post", NA_character_))
d$halfyear <- as.integer(format(d$date, "%Y")) * 2L +
  as.integer(format(d$date, "%m") == "12")
firms <- sort(unique(d$firm_id))
G <- length(firms)
firm_index <- match(d$firm_id, firms)
# One common set of firm resamples keeps paired definitions and periods paired.
# Multiplicity weights are equivalent to concatenating all rows of sampled firms.
boot_weights <- replicate(B, tabulate(sample.int(G, G, replace = TRUE), nbins = G))
coverage <- list()
for (v in c("rl1", "rl2")) for (p in c("pre", "post")) {
  alt <- if (v == "rl1") "rl1_alt" else "rl2_adj"
  use <- !is.na(d$period) & d$period == p & is.finite(d[[v]])
  n <- sum(use); missing <- sum(use & !is.finite(d[[alt]]))
  coverage[[length(coverage) + 1L]] <- data.frame(ratio = v, placebo = alt,
    period = p, n_regulated = n, missing_placebo = missing, missing_share = missing/n)
  if (!n || missing/n > .10) stop("STOP: placebo definition missing for over 10%: ", v, " ", p)
}
coverage <- do.call(rbind, coverage)

# Reviewed restrictions: no zero-imputed perpetuals in the adjusted-RL2 check;
# positive observed advances for the descriptive alternative-RL1 comparison.
adv_observed <- !is.na(d$adv_missing) & !d$adv_missing & is.finite(d$adv) & d$adv > 0
perp_observed <- !is.na(d$perp_missing) & !d$perp_missing
fye_firms <- unique(d$firm_id[!is.na(d$fye_flag) & d$fye_flag])
no_fye <- !d$firm_id %in% fye_firms
rl1_pair <- adv_observed & is.finite(d$rl1) & is.finite(d$rl1_alt)
rl2_pair <- perp_observed & is.finite(d$rl2) & is.finite(d$rl2_adj)
pre_pair <- rl1_pair & !is.na(d$period) & d$period == "pre"
stopifnot(any(pre_pair))
# ECDF rank at 0.70 and R type-7 quantile, both in the paired pre sample.
# Keep this pre-estimated cutoff fixed in every period and bootstrap draw.
matched_rank <- mean(d$rl1[pre_pair] <= .70)
matched_cutoff <- unname(quantile(d$rl1_alt[pre_pair], matched_rank, type = 7))
# Conservative descriptive-only rule for the small observed-perpetual subsample:
# require >=30 firms in each period before displaying definition-contrast inference.
rl2_period_firms <- vapply(c("pre", "post"), function(p)
  length(unique(d$firm_id[rl2_pair & !is.na(d$period) & d$period == p])), integer(1))
rl2_inference <- all(rl2_period_firms >= 30L)
write_coverage <- coverage
write_coverage$perp_missing <- vapply(seq_len(nrow(coverage)), function(i) {
  use <- !is.na(d$period) & d$period == coverage$period[i] & is.finite(d[[coverage$ratio[i]]])
  sum(use & !perp_observed)
}, integer(1))
write_coverage$adv_missing <- vapply(seq_len(nrow(coverage)), function(i) {
  use <- !is.na(d$period) & d$period == coverage$period[i] & is.finite(d[[coverage$ratio[i]]])
  sum(use & (is.na(d$adv_missing) | d$adv_missing))
}, integer(1))

# All output is staged; no partial T023 tables are published on a failed gate.
staged <- list()
stage <- function(path, target) {
  stopifnot(grepl("^t023_", basename(target)))
  staged[[length(staged) + 1L]] <<- c(path = path, target = target)
}
write_csv <- function(x, name, na = "NA") {
  f <- tempfile(fileext = ".csv")
  mtpa_write_csv(x, f, row.names = FALSE, na = na)
  stage(f, paste0("outputs/tables/t023_", name, ".csv"))
}
write_tex <- function(name, header, rows, note, align, panel_size = length(rows)) {
  f <- tempfile(fileext = ".tex")
  # No raw identifiers are used in notes. Escape identifiers in table bodies.
  panels <- split(rows, ceiling(seq_along(rows)/panel_size))
  contents <- lapply(seq_along(panels), function(i) c(
    "\\begin{threeparttable}", paste0("\\begin{tabular}{", align, "}"),
    "\\toprule", paste0(paste(header, collapse = " & "), " \\\\"), "\\midrule", panels[[i]],
    "\\bottomrule", "\\end{tabular}",
    if (i == length(panels)) c("\\begin{tablenotes}[flushleft]", "\\footnotesize",
      paste0("\\item ", note), "\\end{tablenotes}"), "\\end{threeparttable}"))
  mtpa_write_lines(unlist(lapply(seq_along(contents), function(i)
    c(if (i > 1L) "\\par\\medskip", contents[[i]])), use.names = FALSE), f)
  stage(f, paste0("outputs/tables/t023_", name, ".tex"))
}
escape <- function(x) gsub("_", "\\_", x, fixed = TRUE)
fmt <- function(x) ifelse(is.finite(x), formatC(x, digits = 4, format = "f"), "--")
texrow <- function(x) paste0(paste(x, collapse = " & "), " \\\\")
ci_text <- function(lo, hi) paste0("[", fmt(lo), ", ", fmt(hi), "]")
summarise_boot <- function(x) {
  valid <- is.finite(x)
  c(se = if (sum(valid) > 1L) sd(x[valid]) else NA_real_,
    ci_low = if (any(valid)) unname(quantile(x[valid], .025, type = 7)) else NA_real_,
    ci_high = if (any(valid)) unname(quantile(x[valid], .975, type = 7)) else NA_real_,
    bootstrap_valid = sum(valid), bootstrap_failed = sum(!valid))
}
aggregate_firm <- function(values) {
  # rowsum omits absent firms, so restore all firms explicitly.
  z <- rowsum(as.matrix(values), firm_index, reorder = FALSE, na.rm = FALSE)
  out <- matrix(0, nrow = G, ncol = ncol(z))
  out[as.integer(rownames(z)), ] <- z
  out
}
boot_mean <- function(value, eligible) {
  use <- eligible & is.finite(value)
  num <- aggregate_firm(ifelse(use, value, 0))
  den <- aggregate_firm(as.integer(use))
  drop(crossprod(num, boot_weights) / crossprod(den, boot_weights))
}
bin_member <- function(x, lower, upper) is.finite(x) & x >= lower & x < upper
shares <- function(variable, period, threshold, width, month = NULL,
                   restriction = rep(TRUE, nrow(d)), inference = TRUE) {
  use <- !is.na(d$period) & d$period == period & restriction
  if (!is.null(month)) use <- use & format(d$date, "%m-%d") == month
  x <- d[[variable]]; available <- use & is.finite(x)
  below <- as.numeric(bin_member(x, round(threshold - width, 10), threshold))
  above <- as.numeric(bin_member(x, threshold, round(threshold + width, 10)))
  bb <- boot_mean(below, available); ba <- boot_mean(above, available)
  sb <- summarise_boot(bb); sa <- summarise_boot(ba)
  if (!inference) {
    sb[c("se", "ci_low", "ci_high")] <- NA_real_
    sa[c("se", "ci_low", "ci_high")] <- NA_real_
  }
  row <- data.frame(ratio = variable, period = period, threshold = threshold, width = width,
    n = sum(available), firms = length(unique(d$firm_id[available])), missing = sum(use & !is.finite(x)),
    count_below = sum(below[available]), count_above = sum(above[available]),
    share_below = mean(below[available]), share_above = mean(above[available]),
    below_se = sb["se"], below_ci_low = sb["ci_low"], below_ci_high = sb["ci_high"],
    above_se = sa["se"], above_ci_low = sa["ci_low"], above_ci_high = sa["ci_high"],
    bootstrap_draws = B, bootstrap_valid_below = sb["bootstrap_valid"],
    bootstrap_valid_above = sa["bootstrap_valid"], inference_reported = inference, row.names = NULL)
  list(row = row, below_boot = bb, above_boot = ba)
}

# 1. Full regulated reference cells retain the T005 sample. All definition
# contrasts use exactly the same paired observations for both definitions.
definition_rows <- list(); definition_tex <- character(); definitions <- list()
for (v in c("rl1", "rl2")) for (p in c("pre", "post")) {
  z <- shares(v, p, if (v == "rl1") .7 else 1, if (v == "rl1") .02 else .05)$row
  z$comparison <- "regulated_reference"; z$sample_rule <- "main_sample"
  z$descriptive <- TRUE; z$matched_pre_rank <- NA_real_; z$cutoff_pre_n <- NA_integer_
  definition_rows[[paste("reference", v, p)]] <- z
}
for (v in c("rl1", "rl2")) {
  alt <- if (v == "rl1") "rl1_alt" else "rl2_adj"
  restriction <- if (v == "rl1") rl1_pair else rl2_pair
  comparison <- if (v == "rl1") "rl1_quantile_matched" else "rl2_observed_perpetuals"
  sample_rule <- if (v == "rl1") "observed_adv_positive_paired" else "observed_perpetual_item_paired"
  inference <- if (v == "rl1") TRUE else rl2_inference
  threshold <- if (v == "rl1") .70 else 1
  width <- if (v == "rl1") .02 else .05
  cell <- list()
  for (z in c(v, alt)) for (p in c("pre", "post")) {
    cutoff <- if (z == "rl1_alt") matched_cutoff else threshold
    ss <- shares(z, p, cutoff, width, restriction = restriction, inference = inference)
    ss$row$comparison <- comparison; ss$row$sample_rule <- sample_rule
    ss$row$descriptive <- TRUE
    ss$row$matched_pre_rank <- if (v == "rl1") matched_rank else NA_real_
    ss$row$cutoff_pre_n <- if (v == "rl1") sum(pre_pair) else NA_integer_
    key <- paste(z, p); cell[[key]] <- ss
    definition_rows[[paste(comparison, key)]] <- ss$row
    definition_tex <- c(definition_tex, texrow(c(escape(z), p, ss$row$n,
      fmt(ss$row$share_below), fmt(ss$row$share_above), "--")))
  }
  rpre <- cell[[paste(v, "pre")]]; rpost <- cell[[paste(v, "post")]]
  apre <- cell[[paste(alt, "pre")]]; apost <- cell[[paste(alt, "post")]]
  estimate <- (rpost$row$share_below - rpre$row$share_below) -
              (apost$row$share_below - apre$row$share_below)
  draws <- (rpost$below_boot - rpre$below_boot) - (apost$below_boot - apre$below_boot)
  info <- summarise_boot(draws)
  if (!inference) info[c("se", "ci_low", "ci_high")] <- NA_real_
  definitions[[v]] <- c(estimate = estimate, info)
  definition_tex <- c(definition_tex, texrow(c(paste0(escape(v), " minus ", escape(alt)),
    "Change", "--", fmt(estimate), "--", ci_text(info["ci_low"], info["ci_high"]))))
}
placebo <- do.call(rbind, definition_rows)
placebo$difference_in_bunching <- placebo$difference_se <- placebo$difference_ci_low <-
  placebo$difference_ci_high <- placebo$difference_bootstrap_valid <- NA_real_
for (v in names(definitions)) {
  i <- which(placebo$ratio == v & placebo$period == "post" & placebo$comparison != "regulated_reference")
  placebo[i, c("difference_in_bunching", "difference_se", "difference_ci_low",
                "difference_ci_high", "difference_bootstrap_valid")] <-
    as.list(unname(definitions[[v]][c("estimate", "se", "ci_low", "ci_high", "bootstrap_valid")]))
}
old <- read.csv(reference, stringsAsFactors = FALSE)
for (p in c("pre", "post")) {
  a <- placebo[placebo$ratio == "rl1" & placebo$period == p & placebo$comparison == "regulated_reference", ]
  b <- old[old$ratio == "rl1" & old$period == p & old$row_type == "threshold_below", ]
  stopifnot(nrow(a) == 1L, nrow(b) == 1L, a$count_below == b$count,
            a$n == b$n_nonmissing, a$count_below == if (p == "pre") 36 else 78,
            a$n == if (p == "pre") 797 else 630)
}
write_csv(write_coverage, "coverage")
write_csv(placebo, "placebo_definitions")
common_note <- paste("Main sample. Pre: 2017H1--2019H2; post: 2020H2--2022H2.",
  "Bins include the lower edge and exclude the upper edge.")
write_tex("placebo_definitions", c("Definition", "Period", "N", "Below", "Above", "95\\% CI for change"),
  definition_tex, paste(common_note,
    sprintf("RL1 comparison requires observed positive advances and both definitions; RL1 cutoff 0.70, alternative cutoff %.6f, width 0.02.", matched_cutoff),
    sprintf("The alternative cutoff is the type-7 pre-period quantile at the RL1 percentile of 0.70 (rank %.6f; N = %d).", matched_rank, sum(pre_pair)),
    "This is a descriptive distribution-position comparison, not an economic-leverage test. Its intervals condition on the fixed estimated cutoff.",
    "RL2 comparison requires an observed perpetual item and both ratios; cutoff 1.00, width 0.05. Zero-imputed perpetuals are excluded.",
    sprintf("RL2 has %d pre-period and %d post-period firms. No RL2 inference is shown unless each period has at least 30 firms; the CSV gives coverage exclusions.", rl2_period_firms[1], rl2_period_firms[2]),
    "Change is the regulated post minus pre share change minus the alternative change. Firms are resampled jointly (999 draws).",
    "Reference counts on the unrestricted main sample are provided separately in the CSV. All intervals are pointwise; no multiple-testing adjustment."),
  "llrrrr")

# 2. Reporting snapshots: full regulated references plus restricted comparisons;
# exclude all rows of any fiscal-year-flag firm in the robustness variant.
reporting <- list()
for (variant in c("all_firms", "exclude_fye_firms")) {
  keep <- if (variant == "all_firms") rep(TRUE, nrow(d)) else no_fye
  for (comparison in c("regulated_reference", "rl1_quantile_matched", "rl2_observed_perpetuals")) {
    variables <- switch(comparison, regulated_reference = c("rl1", "rl2"),
      rl1_quantile_matched = c("rl1", "rl1_alt"), rl2_observed_perpetuals = c("rl2", "rl2_adj"))
    restriction <- switch(comparison, regulated_reference = rep(TRUE, nrow(d)),
      rl1_quantile_matched = rl1_pair, rl2_observed_perpetuals = rl2_pair)
    for (v in variables) for (p in c("pre", "post")) for (month in c("06-30", "12-31")) {
      is_rl1 <- grepl("rl1", v, fixed = TRUE)
      cutoff <- if (v == "rl1_alt") matched_cutoff else if (is_rl1) .7 else 1
      row <- shares(v, p, cutoff, if (is_rl1) .02 else .05, month,
        restriction & keep, comparison != "rl2_observed_perpetuals" || rl2_inference)$row
      eligible <- !is.na(d$period) & d$period == p & format(d$date, "%m-%d") == month & restriction
      row$reporting_date <- month; row$variant <- variant; row$comparison <- comparison
      row$flagged_firms_in_main_sample <- length(fye_firms)
      row$flagged_firms_in_cell <- length(unique(d$firm_id[eligible & !no_fye]))
      row$flagged_rows_in_cell <- sum(eligible & !no_fye & is.finite(d[[v]]))
      row$flagged_rows_excluded <- if (variant == "all_firms") 0L else row$flagged_rows_in_cell
      row$aligned_panel_dates <- TRUE
      reporting[[length(reporting) + 1L]] <- row
    }
  }
}
reporting <- do.call(rbind, reporting)
write_csv(reporting, "reporting_dates")

# Exact adjacent scheduled dates: never bridge a missing half-year.
key <- paste(d$firm_id, d$halfyear)
next_row <- match(paste(d$firm_id, d$halfyear + 1L), key)
prev_row <- match(paste(d$firm_id, d$halfyear - 1L), key)

# 3. Reversal. Period labels refer to the origin; 2019H2 may lead to 2020H1.
# RL2 control uses two bins, mirroring the specified RL1 control: [0.85,0.95).
reversal_rows <- list(); reversal_tex <- character()
for (v in c("rl1", "rl2")) {
  threshold <- if (v == "rl1") .7 else 1
  width <- if (v == "rl1") .02 else .05
  x <- d[[v]]; next_x <- x[next_row]
  cell <- list()
  for (p in c("pre", "post")) for (group in c("near", "control")) {
    lower <- round(threshold - if (group == "near") width else 3 * width, 10)
    upper <- round(threshold - if (group == "near") 0 else width, 10)
    origin <- !is.na(d$period) & d$period == p & bin_member(x, lower, upper)
    eligible <- origin & is.finite(next_x)
    outcome <- ifelse(is.finite(next_x), as.numeric(next_x > threshold), NA_real_)
    point <- mean(outcome[eligible]); draws <- boot_mean(outcome, eligible)
    info <- summarise_boot(draws)
    cell[[paste(p, group)]] <- list(point = point, draws = draws)
    row <- data.frame(ratio = v, row_type = "share", period = p, group = group,
      lower = lower, upper = upper, threshold = threshold,
      origins = sum(origin), n = sum(eligible), firms = length(unique(d$firm_id[eligible])),
      next_date_absent = sum(origin & is.na(next_row)),
      next_ratio_missing = sum(origin & !is.na(next_row) & !is.finite(next_x)),
      followup_outside_origin_period = sum(eligible &
        (is.na(d$period[next_row]) | d$period[next_row] != p)),
      reversals = sum(outcome[eligible]), estimate = point, as.list(info),
      bootstrap_draws = B, row.names = NULL)
    reversal_rows[[length(reversal_rows) + 1L]] <- row
    reversal_tex <- c(reversal_tex, texrow(c(v, p, group, row$n, fmt(point),
      ci_text(info["ci_low"], info["ci_high"]))))
  }
  contrasts <- list(pre = c("pre near", "pre control"),
    post = c("post near", "post control"),
    post_minus_pre_near = c("post near", "pre near"))
  for (label in names(contrasts)) {
    pair <- contrasts[[label]]; a <- cell[[pair[1]]]; b <- cell[[pair[2]]]
    point <- a$point - b$point; info <- summarise_boot(a$draws - b$draws)
    row <- reversal_rows[[length(reversal_rows)]]
    row[1, ] <- NA
    row$ratio <- v; row$row_type <- "difference"; row$period <- label
    row$group <- if (label == "post_minus_pre_near") "near post minus pre" else "near minus control"
    row$threshold <- threshold; row$estimate <- point; row$bootstrap_draws <- B
    row[names(info)] <- as.list(info)
    reversal_rows[[length(reversal_rows) + 1L]] <- row
    reversal_tex <- c(reversal_tex, texrow(c(v,
      if (label == "post_minus_pre_near") "Post minus pre" else label,
      if (label == "post_minus_pre_near") "near" else row$group, "--",
      fmt(point), ci_text(info["ci_low"], info["ci_high"]))))
  }
}
reversal <- do.call(rbind, reversal_rows)
write_csv(reversal, "reversal")
write_tex("reversal", c("Ratio", "Period", "Group or contrast", "N", "Share or difference", "95\\% CI"),
  reversal_tex, paste(common_note,
    "Near is [0.68,0.70) for RL1 and [0.95,1.00) for RL2; controls are [0.64,0.68) and [0.85,0.95).",
    "Reversal means a ratio strictly above its threshold at the next scheduled half-year, with no bridging of gaps.",
    "Periods refer to origin dates: pre origins at end-2019 may have follow-up in June 2020; end-2022 is right-censored.",
    "N counts available next ratios; the CSV reports missing follow-up separately. Differences and shares use percentile firm-cluster bootstrap intervals (999 draws).",
    "These selected transitions are descriptive and subject to attrition and mean reversion. Intervals are pointwise, with no multiple-testing adjustment."), "lllrrr")

# 4. Composition: post-period destinations; the first lag may be 2020H1.
previous_rl1 <- d$rl1[prev_row]
post <- !is.na(d$period) & d$period == "post"
entrant <- post & is.finite(previous_rl1) & previous_rl1 > .70 & bin_member(d$rl1, .68, .70)
stay <- post & is.finite(previous_rl1) & previous_rl1 > .70 & is.finite(d$rl1) & d$rl1 > .70
safe_log <- function(x) { out <- rep(NA_real_, length(x)); ok <- is.finite(x) & x > 0
  out[ok] <- log(x[ok]); out }
values <- list(log_ibd = safe_log(d$ibd), cash_ta = ifelse(is.finite(d$ta) & d$ta > 0, d$cash/d$ta, NA_real_),
               mi_share = d$mi_share, perp_te = d$perp_te, jv_ta = d$jv_ta, log_ta = safe_log(d$ta))
composition <- list()
for (v in names(values)) {
  delta <- values[[v]] - values[[v]][prev_row]
  # Both ends must have an observed perpetual item for its change to be informative.
  restriction <- if (v == "perp_te") perp_observed & !is.na(prev_row) &
    !is.na(perp_observed[prev_row]) & perp_observed[prev_row] else rep(TRUE, nrow(d))
  use <- (entrant | stay) & restriction & is.finite(delta)
  y <- delta[use]; group <- as.integer(entrant[use]); id <- d$firm_id[use]
  n1 <- sum(group == 1); n0 <- sum(group == 0); clusters <- length(unique(id))
  g1 <- length(unique(id[group == 1])); g0 <- length(unique(id[group == 0]))
  # Preserve existing inference for other outcomes. Small observed-perpetual groups
  # are descriptive only: at least 30 total firms and 10 per group are required.
  inference <- n1 >= 2L && n0 >= 2L && clusters >= 2L &&
    (v != "perp_te" || (clusters >= 30L && g1 >= 10L && g0 >= 10L))
  m1 <- if (n1) mean(y[group == 1]) else NA_real_
  m0 <- if (n0) mean(y[group == 0]) else NA_real_
  difference <- m1 - m0
  se <- statistic <- df <- p_value <- ci_low <- ci_high <- NA_real_
  if (inference) {
    X <- cbind(1, group)
    fit <- lm.fit(X, y); bread <- solve(crossprod(X))
    score <- rowsum(X * as.numeric(fit$residuals), id, reorder = FALSE)
    correction <- clusters/(clusters - 1) * (length(y) - 1)/(length(y) - 2)
    vcov <- correction * bread %*% crossprod(score) %*% bread
    se <- sqrt(vcov[2, 2]); statistic <- difference/se
    df <- clusters - 1L; critical <- qt(.975, df)
    p_value <- 2 * pt(-abs(statistic), df)
    ci_low <- difference - critical * se; ci_high <- difference + critical * se
    stopifnot(abs(difference - unname(fit$coefficients[2])) < 1e-12)
  }
  composition[[v]] <- data.frame(variable = v, descriptive = TRUE,
    sample_rule = if (v == "perp_te") "observed_perpetual_both_dates" else "available_change",
    inference_reported = inference, multiplicity_adjusted = FALSE,
    entrants_total = sum(entrant), stayers_total = sum(stay), n_entrants = n1, n_stayers = n0,
    restriction_excluded_entrants = sum(entrant & !restriction),
    restriction_excluded_stayers = sum(stay & !restriction),
    missing_entrants = sum(entrant & restriction) - n1,
    missing_stayers = sum(stay & restriction) - n0,
    firms = clusters, firms_entrants = g1, firms_stayers = g0,
    mean_change_entrants = m1, mean_change_stayers = m0, difference = difference,
    clustered_se = se, t_statistic = statistic, df = df, p_value = p_value,
    ci_low = ci_low, ci_high = ci_high)
}
composition <- do.call(rbind, composition)
write_csv(composition, "composition")

# 5. Polynomial counterfactual (Kleven 2016, section 4.1, equation 17).
# Equal-width 0.01 bins; retain zero bins. The excluded-bin dummy formulation
# is equivalent to fitting the polynomial only outside the excluded window.
# b has units of bins: total excess / mean counterfactual count per window bin.
# Also publish the distinct relative excess (total excess / total counterfactual).
# No integration constraint, nonnegative clipping, elasticity or evasion claim.
edges <- round(seq(.40, 1, .01), 10)
mid <- (head(edges, -1) + tail(edges, -1))/2
bin_counts <- function(variable, period, sample_rule) {
  use <- !is.na(d$period) & d$period == period & is.finite(d[[variable]])
  if (sample_rule == "observed_adv_positive_paired") use <- use & rl1_pair
  ix <- findInterval(d[[variable]], edges, rightmost.closed = TRUE)
  inside <- use & !is.na(ix) & ix > 0L & ix < length(edges)
  z <- matrix(0, nrow(d), length(mid))
  z[cbind(which(inside), ix[inside])] <- 1
  counts_firm <- aggregate_firm(z)
  list(count = colSums(counts_firm), boot = t(counts_firm) %*% boot_weights,
    n = sum(use), n_in_range = sum(inside), n_outside = sum(use & !inside),
    firms = length(unique(d$firm_id[use])))
}
specs <- data.frame(specification = c("main", "degree4", "degree7", "narrow", "wide"),
  degree = c(5L, 4L, 7L, 5L, 5L), left = c(.04, .04, .04, .03, .04),
  right = c(0, 0, 0, 0, .02))
# Only the excess-mass cutoff is rounded to the nearest 0.01 (R round,
# ties to even). The definition-share check keeps its original exact quantile.
mass_matched_cutoff <- round(matched_cutoff/.01) * .01
mass_samples <- data.frame(ratio = c("rl1", "rl1", "rl1_alt"),
  sample_rule = c("main_sample", rep("observed_adv_positive_paired", 2)),
  table_sample = c("Full", "Paired", "Paired"))
excess <- list(); bin_audit <- list(); main_prediction <- NULL
for (k in seq_len(nrow(mass_samples))) for (p in c("pre", "post")) {
  v <- mass_samples$ratio[k]; sample_rule <- mass_samples$sample_rule[k]
  counts <- bin_counts(v, p, sample_rule)
  regulated_cutoff <- if (v == "rl1") .70 else mass_matched_cutoff
  regulated_lower <- round(regulated_cutoff - .04, 10)
  regulated_upper <- round(regulated_cutoff + .02, 10)
  regulated_region <- mid >= regulated_lower & mid < regulated_upper
  for (threshold in c(regulated_cutoff, .60, .80)) for (s in seq_len(nrow(specs))) {
    spec <- specs[s, ]; lower <- round(threshold - spec$left, 10)
    upper <- round(threshold + spec$right, 10)
    test_window <- mid >= lower & mid < upper
    is_placebo <- threshold != regulated_cutoff
    # Keep true-threshold bunching out of the placebo counterfactual fit.
    # Mass remains confined to the placebo's own below-cutoff window.
    excluded <- test_window | (is_placebo & regulated_region)
    mass <- test_window & mid < threshold
    above_mass <- test_window & mid >= threshold
    stopifnot(sum(mass) == round(spec$left/.01),
              !is_placebo || all(excluded[regulated_region]))
    # Orthogonal basis on the fixed full grid improves conditioning and spans
    # exactly the same degree-p polynomial as raw powers with an intercept.
    X <- cbind(1, poly(mid, degree = spec$degree))
    qr_fit <- qr(X[!excluded, , drop = FALSE])
    stopifnot(qr_fit$rank == ncol(X))
    predicted <- drop(X %*% qr.coef(qr_fit, counts$count[!excluded]))
    predicted_boot <- X %*% qr.coef(qr_fit, counts$boot[!excluded, , drop = FALSE])
    observed_window <- sum(counts$count[mass])
    counterfactual <- sum(predicted[mass]); per_bin <- mean(predicted[mass])
    valid_point <- all(is.finite(predicted[mass])) && all(predicted[mass] > 0)
    b <- if (valid_point) (observed_window - counterfactual)/per_bin else NA_real_
    observed_boot <- colSums(counts$boot[mass, , drop = FALSE])
    cf_boot <- colSums(predicted_boot[mass, , drop = FALSE])
    valid_boot <- colSums(!is.finite(predicted_boot[mass, , drop = FALSE]) |
                           predicted_boot[mass, , drop = FALSE] <= 0) == 0
    b_boot <- ifelse(valid_boot, (observed_boot - cf_boot)/(cf_boot/sum(mass)), NA_real_)
    info <- summarise_boot(b_boot)
    valid_share <- unname(info["bootstrap_valid"])/B
    bootstrap_meets_90pct <- valid_share >= .90
    inference_status <- if (!valid_point) "invalid_counterfactual" else
      if (!bootstrap_meets_90pct) "unreliable_bootstrap_below_90pct" else
        if (valid_share < 1) "conditional_bootstrap" else "all_draws_valid"
    # An undefined point estimate has no interpretable SE or interval.
    if (!valid_point) info[c("se", "ci_low", "ci_high")] <- NA_real_
    excess[[length(excess) + 1L]] <- data.frame(ratio = v, period = p,
      threshold = threshold, threshold_type = if (v == "rl1" && threshold == .7) "regulated" else
        if (v == "rl1_alt" && threshold == mass_matched_cutoff) "quantile_matched_descriptive" else "placebo",
      sample_rule = sample_rule, table_sample = mass_samples$table_sample[k],
      descriptive = TRUE, cutoff_conditioned = v == "rl1_alt" && !is_placebo,
      matched_cutoff_unrounded = if (v == "rl1_alt") matched_cutoff else NA_real_,
      matched_cutoff_grid = if (v == "rl1_alt") mass_matched_cutoff else NA_real_,
      specification = spec$specification, degree = spec$degree, window_lower = lower,
      window_upper = threshold, exclusion_upper = upper, bin_width = .01, window_bins = sum(mass),
      excludes_regulated_region = is_placebo, regulated_region_lower = regulated_lower,
      regulated_region_upper = regulated_upper,
      exclusion_bins = sum(excluded), above_observed = sum(counts$count[above_mass]),
      above_counterfactual = sum(predicted[above_mass]),
      above_excess_count = sum(counts$count[above_mass] - predicted[above_mass]),
      n = counts$n, n_in_range = counts$n_in_range, n_outside = counts$n_outside,
      firms = counts$firms, observed_window = observed_window,
      counterfactual_window = counterfactual, counterfactual_per_bin = per_bin,
      excess_count = observed_window - counterfactual, b = b,
      excess_fraction = if (valid_point) (observed_window - counterfactual)/counterfactual else NA_real_,
      as.list(info), bootstrap_draws = B, bootstrap_valid_share = valid_share,
      bootstrap_meets_90pct = bootstrap_meets_90pct, inference_status = inference_status,
      valid_counterfactual = valid_point,
      negative_fitted_bins = sum(predicted < 0), row.names = NULL)
    bin_audit[[length(bin_audit) + 1L]] <- data.frame(ratio = v, period = p,
      sample_rule = sample_rule,
      threshold = threshold, specification = spec$specification, degree = spec$degree,
      lower = head(edges, -1), upper = tail(edges, -1), midpoint = mid,
      excluded = excluded, test_window = test_window, regulated_region = regulated_region,
      mass_window = mass, observed = counts$count, counterfactual = predicted)
    if (v == "rl1" && sample_rule == "main_sample" && p == "post" &&
        threshold == .7 && spec$specification == "main")
      main_prediction <- tail(bin_audit, 1L)[[1L]]
  }
}
excess <- do.call(rbind, excess)
stopifnot(nrow(excess) == 90L,
          all(!is.finite(excess$se[!excess$valid_counterfactual])))
write_csv(excess, "excess_mass", na = "--")
write_csv(do.call(rbind, bin_audit), "excess_mass_bins")
# Compact TEX panels: each row contains paired pre/post estimates and SEs.
mass_tex <- character()
for (k in seq_len(nrow(mass_samples))) for (threshold in c(if (mass_samples$ratio[k] == "rl1") .7 else mass_matched_cutoff, .6, .8)) for (s in specs$specification) {
  v <- mass_samples$ratio[k]
  z <- excess[excess$ratio == v & excess$sample_rule == mass_samples$sample_rule[k] &
                excess$threshold == threshold & excess$specification == s, ]
  a <- z[z$period == "pre", ]; b <- z[z$period == "post", ]
  mark_se <- function(z) if (!z$valid_counterfactual) "--" else
    paste0(fmt(z$se), if (!z$bootstrap_meets_90pct) "$^{\\dagger}$" else "")
  mass_tex <- c(mass_tex, texrow(c(escape(v), mass_samples$table_sample[k], sprintf("%.2f", threshold), s,
    fmt(a$b), mark_se(a), fmt(b$b), mark_se(b))))
}
write_tex("excess_mass", c("Ratio", "Sample", "Cutoff", "Spec.", "Pre b", "SE", "Post b", "SE"),
  mass_tex, paste(common_note,
    "Kleven (2016, Section 4.1, equation 17) polynomial counterfactual; 0.01 bins over [0.40,1.00], including zero bins and the final right edge.",
    "Main: degree 5, excluding [cutoff minus 0.04,cutoff). Robustness: degree 4 or 7, lower bound cutoff minus 0.03 (narrow), or upper bound cutoff plus 0.02 (wide).",
    "Every 0.60/0.80 placebo additionally excludes [0.66,0.72) for RL1 or [0.49,0.55) for alternative RL1 from fitting, keeping true-threshold mass out of its counterfactual.",
    "Mass always uses only below-cutoff bins; above-cutoff excess in wide fits is separate in the CSV.",
    "b is total excess divided by the mean fitted count per mass-window bin. SE: 999 whole-firm resamples, refitting each time.",
    "Nonpositive fitted mass-bin counts invalidate a draw. Invalid point estimates and their SEs are shown as -- in both CSV and TEX.",
    "A dagger flags fewer than 90 percent valid draws: the displayed conditional SE is unreliable for inference. No significance stars are used; valid-draw counts and status are in the CSV.",
    "Full uses all available main-sample RL1 (pre/post N = 797/630); Paired uses the same observed-positive-advance firm-dates for both definitions (N = 711/599).",
    sprintf("For excess mass only, the pre-period quantile-matched alternative cutoff %.8f is rounded to the nearest 0.01 (ties to even): %.2f, held fixed. Its main mass window is exactly [0.49,0.53). The definition-share check retains the unrounded cutoff.", matched_cutoff, mass_matched_cutoff),
    "Alternative RL1 is not economic leverage; its fixed 0.60/0.80 placebos are descriptive distribution checks.",
    "Smoothness and polynomial shape are assumed; windows may miss responses. No clipping, integration correction or structural elasticity interpretation.",
    "Inference is pointwise, without multiple-testing adjustment; pre/post b differences are not formally tested."),
    "llllrrrr", panel_size = 15L)

# 6. Figures, deterministic PDF metadata and vector output.
save_pdf <- function(plot, name, width, height) {
  f <- tempfile(fileext = ".pdf")
  grDevices::pdf(f, width = width, height = height, useDingbats = FALSE,
                 timestamp = FALSE, title = "T023 descriptive bunching diagnostics")
  print(plot); invisible(dev.off())
  stage(f, paste0("outputs/figures/t023_", name, ".pdf"))
}
base_theme <- theme_minimal(base_size = 10) + theme(legend.position = "top",
  legend.title = element_blank(), panel.grid.minor = element_blank(),
  plot.caption = element_text(size = 8, hjust = 0), strip.text = element_text(face = "bold"))
hist_edges <- round(seq(.30, 1.10, .02), 10)
hist_rows <- list()
for (v in c("rl1", "rl1_alt")) for (p in c("pre", "post")) {
  x <- d[[v]][!is.na(d$period) & d$period == p & rl1_pair]; x <- x[is.finite(x)]
  ix <- findInterval(x, hist_edges, rightmost.closed = TRUE)
  counts <- tabulate(ix[ix > 0L & ix < length(hist_edges)], nbins = length(hist_edges) - 1L)
  hist_rows[[length(hist_rows) + 1L]] <- data.frame(ratio = v, period = p,
    lower = head(hist_edges, -1), upper = tail(hist_edges, -1),
    midpoint = (head(hist_edges, -1) + tail(hist_edges, -1))/2,
    count = counts, n = length(x), share = counts/length(x), n_outside = length(x) - sum(counts),
    sample_rule = "observed_adv_positive_paired")
}
hist_rows <- do.call(rbind, hist_rows)
write_csv(hist_rows, "histogram_bins")
hist_rows$period <- factor(hist_rows$period, levels = c("pre", "post"),
  labels = c("Pre: 2017H1-2019H2", "Post: 2020H2-2022H2"))
p <- ggplot(hist_rows, aes(midpoint, share, fill = period, colour = period)) +
  geom_col(position = "identity", width = .019, alpha = .40, linewidth = .25) +
  geom_vline(data = data.frame(ratio = c("rl1", "rl1_alt"),
    cutoff = c(.7, matched_cutoff)), aes(xintercept = cutoff), linetype = "dashed") +
  facet_wrap(~ratio, ncol = 1) +
  scale_fill_manual(values = c("#3574A5", "#B44E31")) +
  scale_colour_manual(values = c("#3574A5", "#B44E31")) +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  scale_x_continuous(breaks = seq(.3, 1.1, .1), labels = function(x) sprintf("%.1f", x)) +
  labs(title = "Reported and alternative RL1: pre/post distributions", x = "Ratio", y = "Share of available observations",
    caption = paste("Main sample with observed positive advances and both RL1 definitions. Bin width 0.02.",
      sprintf("Dashed cutoffs: RL1 0.70; alternative %.4f (pre-period quantile matched).", matched_cutoff),
      sprintf("Paired N: pre %d, post %d; denominators include tails outside [0.30,1.10].",
        sum(rl1_pair & !is.na(d$period) & d$period == "pre"),
        sum(rl1_pair & !is.na(d$period) & d$period == "post")),
      "Reported RL1 definition unverified; alternative RL1 is not complete economic leverage.", sep = "\n")) + base_theme
save_pdf(p, "bunching_rl1_vs_alt", 7.5, 7)
p <- ggplot(main_prediction, aes(midpoint, observed)) +
  annotate("rect", xmin = .66, xmax = .70, ymin = -Inf, ymax = Inf, fill = "#E8CBAF", alpha = .45) +
  geom_col(width = .009, fill = "grey65") +
  geom_line(aes(y = counterfactual, colour = "Degree-5 counterfactual"), linewidth = .8) +
  geom_vline(xintercept = .7, linetype = "dashed") + scale_colour_manual(values = "#245B85") +
  scale_x_continuous(breaks = seq(.4, 1, .1), labels = function(x) sprintf("%.1f", x)) +
  labs(title = "RL1 excess mass: post-policy", x = "Reported RL1", y = "Firm-half-year count per 0.01 bin",
    caption = paste("Main sample, 2020H2-2022H2. Shaded exclusion/mass window: [0.66,0.70).",
      "Polynomial fitted outside the window over [0.40,1.00], including zero-count bins.",
      "Descriptive counterfactual; smoothness assumed; reported RL1 definition unverified.", sep = "\n")) + base_theme
save_pdf(p, "excess_mass_rl1", 7.5, 4.8)

# Guards: protect every pre-existing non-T023 output, plus both read-only inputs.
stopifnot(identical(input_hash, tools::sha256sum(c(input, reference))),
          identical(protected_hash, tools::sha256sum(protected)))
for (x in staged) {
  dir.create(dirname(x[["target"]]), recursive = TRUE, showWarnings = FALSE)
  stopifnot(file.copy(x[["path"]], x[["target"]], overwrite = TRUE))
}
unlink(vapply(staged, `[[`, character(1), "path"))
for (i in seq_len(nrow(coverage))) cat(sprintf("T023: %s %s placebo missing %d/%d.\n",
  coverage$ratio[i], coverage$period[i], coverage$missing_placebo[i], coverage$n_regulated[i]))
cat("T023: RL1 below-threshold counts verified: pre 36/797; post 78/630.\n")
cat(sprintf("T023: alternative RL1 cutoff %.8f; pre rank %.8f, N=%d; descriptive only.\n", matched_cutoff, matched_rank, sum(pre_pair)))
cat(sprintf("T023: excess-mass alternative cutoff rounded to %.2f; main window [%.2f,%.2f).\n",
  mass_matched_cutoff, mass_matched_cutoff - .04, mass_matched_cutoff))
cat(sprintf("T023: RL2 observed-perpetual firms pre/post %s; inference reported: %s.\n", paste(rl2_period_firms, collapse = "/"), rl2_inference))
cat(sprintf("T023: fiscal-year-flag firms: %d main-sample (%d panel-wide); reporting-date exclusion variant written.\n", length(fye_firms), length(panel_fye_firms)))
for (v in names(definitions)) cat(sprintf("T023: %s difference-in-bunching %.8f, 95%% CI [%.8f, %.8f].\n",
  v, definitions[[v]]["estimate"], definitions[[v]]["ci_low"], definitions[[v]]["ci_high"]))
cat(sprintf("T023: %d polynomial specifications; bootstrap valid draws %d--%d of %d.\n",
  nrow(excess), min(excess$bootstrap_valid), max(excess$bootstrap_valid), B))
cat(sprintf("T023: %d invalid point estimates; %d fits below 90%% valid draws; no significance stars.\n",
  sum(!excess$valid_counterfactual), sum(!excess$bootstrap_meets_90pct)))
cat(sprintf("T023: wrote %d staged CSV/TEX/PDF outputs; input and %d existing-output hashes unchanged.\n",
  length(staged), length(protected)))
