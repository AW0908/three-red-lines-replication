# T009: prespecified pooled dose-response (dose_pre) DiD and event studies.
# Run from replication/: Rscript code/02_estimate.R
# Read-only input: data/processed/panel_firm_halfyear.csv.
# No imputation, winsorisation, extra filters, or robustness specifications.

source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(stringsAsFactors = FALSE, digits = 7, width = 140)
invisible(Sys.setlocale("LC_NUMERIC", "C"))
for (pkg in c("fixest", "modelsummary", "ggplot2", "kableExtra")) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop("Required local package is unavailable: ", pkg, ". No network installation attempted.")
  }
}
fixest::setFixest_nthreads(1)

outcomes <- c("rl1", "rl2", "rl2_gap", "mi_share", "jv_ta")
reference <- "2020-06-30"
dates <- sort(c("2016-12-31", paste0(rep(2017:2022, each = 2),
                                   rep(c("-06-30", "-12-31"), 6))))
pre_dates <- dates[dates < reference]
expected_terms <- paste0("date::", dates[dates != reference], ":dose_pre")
pre_terms <- paste0("date::", pre_dates, ":dose_pre")
pre_pattern <- paste0("^date::(", paste(pre_dates, collapse = "|"), "):dose_pre$")

panel <- read.csv("data/processed/panel_firm_halfyear.csv", na.strings = "NA",
                  colClasses = c(firm_id = "character", date = "character"))
required <- c("firm_id", "date", "sample_main", "dose_pre", "post", outcomes)
stopifnot(all(required %in% names(panel)), is.logical(panel$sample_main))
# The sole ex-ante sample restriction; outcome NAs and FE singletons are
# subsequently removed by fixest, separately for each outcome.
sample_data <- panel[!is.na(panel$sample_main) & panel$sample_main & !is.na(panel$dose_pre), ]
stopifnot(nrow(sample_data) > 0L, !anyNA(sample_data[c("firm_id", "date", "post")]),
          !anyDuplicated(sample_data[c("firm_id", "date")]),
          identical(sort(unique(sample_data$date)), dates),
          all(sample_data$dose_pre >= 0 & sample_data$dose_pre <= 3),
          all(sample_data$post == as.integer(sample_data$date >= "2020-12-31")),
          all(vapply(split(sample_data$dose_pre, sample_data$firm_id),
                     function(x) length(unique(x)) == 1L, logical(1))))
for (y in outcomes) {
  stopifnot(is.numeric(sample_data[[y]]),
            all(is.na(sample_data[[y]]) | is.finite(sample_data[[y]])))
}
base_n <- nrow(sample_data)
base_firms <- length(unique(sample_data$firm_id))
if (base_firms < 100L) stop("STOP: fewer than 100 firms in the base regression sample.")
cat(sprintf("T009 base sample: %d firm-half-years; %d firms.\n", base_n, base_firms))
cat("dose_pre: mean breaches over 2017H1-2019H2 (at least 3 dates); post: date >= 2020-12-31.\n")
cat("All models: firm and half-year FE; firm-clustered SE; fixest default small-sample correction.\n")

# Return the actual model sample, not just observations with non-missing y.
# Explicit singleton removal is the OLS FE default and is accounted for below.
audit_sample <- function(model, y, specification) {
  used <- fixest::obs(model)
  data_used <- sample_data[used, ]
  n_firms <- length(unique(data_used$firm_id))
  missing <- sum(is.na(sample_data[[y]]))
  singleton <- base_n - missing - stats::nobs(model)
  stopifnot(length(used) == stats::nobs(model), singleton >= 0L,
            !anyNA(data_used[[y]]),
            identical(model$fixef_vars, c("firm_id", "date")),
            grepl("firm_id", attr(model$cov.scaled, "type"), fixed = TRUE))
  if (n_firms < 100L) stop("STOP: ", y, " / ", specification, " has fewer than 100 firms.")
  loss_share <- (base_n - stats::nobs(model)) / base_n
  cat(sprintf("SAMPLE %s / %s: N=%d; firms=%d; missing y=%d; singleton rows=%d; loss=%.6f%%.\n",
              y, specification, stats::nobs(model), n_firms, missing, singleton, 100 * loss_share))
  if (loss_share > 0.05) {
    # The card permits >5% attrition only with an explanation in the report.
    # For jv_ta, missing JV inputs explain every missing outcome in this panel.
    # If that explanation no longer covers the data, stop rather than proceed.
    if (y != "jv_ta" || !all(is.na(sample_data$jv[is.na(sample_data[[y]])]))) {
      stop("STOP: >5% attrition lacks the prespecified, verifiable missing-JV explanation.")
    }
    cat(sprintf("ATTRITION EXPLANATION: all %d missing jv_ta outcomes have missing jv; %d additional singleton rows.\n",
                missing, singleton))
    cat("REPORT REQUIRED: disclose this >5% loss, without imputing JV values or changing the sample.\n")
  }
  list(data = data_used, n_firms = n_firms, missing = missing,
       singleton = singleton, loss_share = loss_share)
}

pooled_models <- event_models <- list()
main_rows <- event_rows <- pretrend_rows <- list()
for (y in outcomes) {
  pooled <- fixest::feols(
    stats::as.formula(paste(y, "~ dose_pre:post | firm_id + date")),
    data = sample_data, cluster = ~firm_id, fixef.rm = "singleton")
  event <- fixest::feols(
    stats::as.formula(paste(y, '~ i(date, dose_pre, ref = "2020-06-30") | firm_id + date')),
    data = sample_data, cluster = ~firm_id, fixef.rm = "singleton")
  pooled_audit <- audit_sample(pooled, y, "pooled")
  event_audit <- audit_sample(event, y, "event study")
  stopifnot(identical(fixest::obs(pooled), fixest::obs(event)),
            identical(names(stats::coef(pooled)), "dose_pre:post"),
            setequal(names(stats::coef(event)), expected_terms),
            length(stats::coef(event)) == 12L)

  # confint.fixest uses the cluster-based t reference distribution, not 1.96.
  ci <- stats::confint(pooled, level = 0.95)
  main_rows[[y]] <- data.frame(
    outcome = y, term = "dose_pre:post", coefficient = unname(stats::coef(pooled)[1]),
    std_error = unname(fixest::se(pooled)[1]), ci_lower = unname(ci[1, 1]),
    ci_upper = unname(ci[1, 2]), N = stats::nobs(pooled), n_firms = pooled_audit$n_firms,
    pre_mean = mean(pooled_audit$data[[y]][pooled_audit$data$post == 0]),
    base_N = base_n, missing_outcome = pooled_audit$missing,
    singleton_rows = pooled_audit$singleton, dropped_share = pooled_audit$loss_share)
  event_ci <- stats::confint(event, level = 0.95)
  terms <- names(stats::coef(event))
  event_rows[[y]] <- data.frame(
    outcome = y, date = sub(":dose_pre$", "", sub("^date::", "", terms)),
    coefficient = unname(stats::coef(event)), std_error = unname(fixest::se(event)),
    ci_lower = unname(event_ci[, 1]), ci_upper = unname(event_ci[, 2]))

  # One JOINT Wald F-test of the seven strictly pre-reference coefficients.
  # The reference and every post-policy coefficient are excluded by construction.
  selected <- grep(pre_pattern, terms, value = TRUE)
  stopifnot(setequal(selected, pre_terms), length(selected) == 7L)
  w <- fixest::wald(event, keep = pre_pattern, print = FALSE)
  stopifnot(w$df1 == length(pre_dates), is.finite(w$stat), is.finite(w$p))
  pretrend_rows[[y]] <- data.frame(
    outcome = y, statistic = unname(w$stat), df = unname(w$df1),
    df_denom = unname(w$df2), p_value = unname(w$p), test = "Joint Wald F",
    tested_dates = paste(pre_dates, collapse = ";"))
  pooled_models[[y]] <- pooled
  event_models[[y]] <- event

  # Full model-object printouts for every outcome let the reviewer freely
  # choose which coefficient/SE to reproduce; no additional log file is written.
  cat("\nPOOLED MODEL OBJECT: ", y, "\n", sep = "")
  print(summary(pooled))
  cat("MODEL OBJECT COEFFICIENT TABLE (17 significant digits):\n")
  print(fixest::coeftable(pooled), digits = 17)
  stopifnot(isTRUE(all.equal(main_rows[[y]]$coefficient, unname(stats::coef(pooled)[1]), tolerance = 0)),
            isTRUE(all.equal(main_rows[[y]]$std_error, unname(fixest::se(pooled)[1]), tolerance = 0)))
  cat("JOINT PRE-TREND TEST: ", y, "; dates: ", paste(pre_dates, collapse = ", "), "\n", sep = "")
  print(w)
}

main <- do.call(rbind, main_rows)
events <- do.call(rbind, event_rows)
pretrends <- do.call(rbind, pretrend_rows)
rownames(main) <- rownames(events) <- rownames(pretrends) <- NULL
stopifnot(nrow(main) == 5L, nrow(events) == 60L, nrow(pretrends) == 5L,
          !reference %in% events$date, all(table(events$outcome) == 12L),
          all(pretrends$df == 7L))

dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
mtpa_write_csv(main, "outputs/tables/t009_did_main.csv", row.names = FALSE)
mtpa_write_csv(events, "outputs/tables/t009_event_study.csv", row.names = FALSE)
mtpa_write_csv(pretrends, "outputs/tables/t009_pretrend_tests.csv", row.names = FALSE)

notes <- c(
  "Sample: sample_main = TRUE and non-missing dose_pre; available outcomes; FE singletons removed.",
  "dose_pre: mean red-line breaches over 2017H1-2019H2 (continuous 0-3; at least 3 dates). Post begins 2020H2.",
  "Firm and half-year fixed effects; standard errors clustered by firm (in parentheses).",
  "95% CIs use cluster-based t critical values and fixest default small-sample correction.",
  "Identification: parallel outcome trends across dose_pre levels absent the policy.",
  "Pre-period mean: post = 0 observations in each model's estimation sample; ratios in levels.",
  "RL1 definition is unverified against a primary policy source; no outlier trimming.",
  sprintf("JV/TA: %d/%d rows lost (%.2f%%): %d missing JV values and %d singleton rows.",
          main$base_N[5] - main$N[5], main$base_N[5], 100 * main$dropped_share[5],
          main$missing_outcome[5], main$singleton_rows[5]))
extra_rows <- data.frame(term = c("N (firm-half-years)", "Number of firms", "Pre-period mean"))
for (y in outcomes) {
  row <- main[main$outcome == y, ]
  extra_rows[[y]] <- c(as.character(row$N), as.character(row$n_firms), sprintf("%.6f", row$pre_mean))
}
options(modelsummary_factory_latex = "kableExtra", modelsummary_format_numeric_latex = "plain")
latex <- modelsummary::modelsummary(
  pooled_models, output = "latex", fmt = 6, stars = FALSE,
  estimate = "{estimate}", statistic = c("({std.error})", "[{conf.low}, {conf.high}]"),
  conf_level = 0.95, coef_map = c("dose_pre:post" = "Mean pre-policy dose x Post"),
  gof_omit = ".*", add_rows = extra_rows, escape = TRUE, booktabs = TRUE)
# Scale the numerical table, then wrap notes at the document line width.
# threeparttable's natural-width notes can overflow when only its table is scaled.
latex <- kableExtra::kable_styling(latex, latex_options = "scale_down")
latex <- as.character(latex)
# T019: float metadata only; preserve all numerical and note bytes.
latex <- sub("\\centering\\centering", "\\centering", latex, fixed = TRUE)
latex <- sub("\\begin{table}\n", paste0("\\begin{table}\n",
  "\\caption{Pooled difference-in-differences estimates: pre-policy dose $\\times$ post}\n",
  "\\label{tab:did_main}\n"), latex, fixed = TRUE)
escaped_notes <- gsub("%", "\\%", gsub("_", "\\_", paste(notes, collapse = " "), fixed = TRUE), fixed = TRUE)
latex <- paste0(sub("\\end{table}", "", latex, fixed = TRUE),
                "\n\\par\\smallskip\n\\begin{minipage}{\\linewidth}\\footnotesize\n",
                escaped_notes, "\n\\end{minipage}\n\\end{table}")
stopifnot(grepl("\\toprule", latex, fixed = TRUE),
          grepl("\\bottomrule", latex, fixed = TRUE),
          !grepl("\\documentclass", latex, fixed = TRUE))
mtpa_write_lines(latex, "outputs/tables/t009_did_main.tex")

titles <- c(rl1 = "Reported leverage (RL1; definition unverified)",
            rl2 = "Reported net gearing (RL2)",
            rl2_gap = "Adjusted minus reported net gearing (RL2 gap)",
            mi_share = "Minority interests / total equity",
            jv_ta = "JV and associate investments / total assets")
date_labels <- paste0(substr(dates, 1, 4), ifelse(substr(dates, 6, 7) == "06", "H1", "H2"))
for (y in outcomes) {
  plot_data <- events[events$outcome == y, ]
  plot_data$period <- match(plot_data$date, dates)
  row <- main[main$outcome == y, ]
  # The hollow point is a normalisation, not a thirteenth estimated coefficient.
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = period, y = coefficient)) +
    ggplot2::geom_hline(yintercept = 0, colour = "grey55", linewidth = 0.4) +
    ggplot2::geom_vline(xintercept = match(reference, dates) + 0.5,
                      linetype = "dashed", colour = "grey40", linewidth = 0.5) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = ci_lower, ymax = ci_upper),
                          width = 0.14, colour = "#245577", linewidth = 0.6) +
    ggplot2::geom_point(colour = "#245577", size = 2.2) +
    ggplot2::annotate("point", x = match(reference, dates), y = 0,
                      shape = 1, size = 2.6, colour = "#245577") +
    ggplot2::scale_x_continuous(breaks = seq_along(dates), labels = date_labels,
                               limits = c(0.7, 13.3)) +
    ggplot2::labs(title = titles[[y]],
                  subtitle = "dose_pre: mean breaches 2017H1-2019H2 (>=3 dates); reference: 2020-06-30",
                  x = "Reporting half-year", y = "Effect per additional mean pre-policy breach (ratio units)",
                  caption = sprintf(paste0("95%% CIs; firm and half-year FE; SEs clustered by firm. N = %d; firms = %d.\n",
                                           "Hollow point: normalized reference. Dashed line: policy begins in 2020H2."),
                                    row$N, row$n_firms)) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
                   panel.grid.minor = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(size = 13),
                   plot.subtitle = ggplot2::element_text(size = 10),
                   plot.caption = ggplot2::element_text(size = 9, hjust = 0),
                   plot.margin = ggplot2::margin(12, 14, 12, 24))
  ggplot2::ggsave(paste0("outputs/figures/t009_es_", y, ".pdf"), plot = p,
                  device = grDevices::pdf, width = 8.5, height = 5.2, units = "in", timestamp = FALSE)
}

cat("\nFINAL SUMMARY (ratio units; 95% confidence intervals):\n")
report <- merge(main[c("outcome", "coefficient", "std_error", "ci_lower", "ci_upper", "N", "n_firms")],
                pretrends[c("outcome", "p_value")], by = "outcome", sort = FALSE)
print(report[match(outcomes, report$outcome), ], row.names = FALSE, digits = 10)
cat("T009 completed: 5 pooled models; 60 event-study coefficients; 5 joint pre-trend tests.\n")
cat("All regression samples have >=100 firms; JV attrition explanation printed above.\n")
