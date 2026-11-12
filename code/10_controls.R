# T028: all six approved predetermined-control specifications, no search.
# Run from replication/: Rscript code/10_controls.R
# Financial controls use only 2017H1--2019H2, including actual report-date gates.
# C5 uses post outcomes ONLY for the approved D22 exclusion, never as controls.
# Identification: conditional parallel counterfactual trends by dose, no anticipation,
# and no other dose-correlated shocks after conditioning; controls do not prove these.
source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(stringsAsFactors = FALSE, digits = 10, width = 180)
invisible(Sys.setlocale("LC_NUMERIC", "C"))
for (pkg in c("fixest", "ggplot2"))
  if (!requireNamespace(pkg, quietly = TRUE)) stop("Missing local package: ", pkg)
fixest::setFixest_nthreads(1)
inputs <- c("data/processed/panel_firm_halfyear.csv", "code/02_estimate.R",
            "code/04_robustness.R", "outputs/tables/t009_did_main.csv",
            "../state/LIMITATIONS.md", "../state/STATE.md")
input_hash <- tools::sha256sum(inputs)
protected <- list.files("outputs", recursive = TRUE, full.names = TRUE)
protected <- protected[!dir.exists(protected) & !startsWith(basename(protected), "t028_")]
protected_hash <- tools::sha256sum(protected)
write_out <- function(x, name) mtpa_write_csv(x, paste0("outputs/tables/t028_", name, ".csv"), row.names = FALSE)
write_tex <- function(x, name) mtpa_write_lines(x, paste0("outputs/tables/t028_", name, ".tex"))
outcomes <- c("rl1", "rl2", "rl2_gap", "mi_share", "jv_ta")
labels <- c(rl1 = "RL1", rl2 = "RL2", rl2_gap = "RL2 gap", mi_share = "Minority share", jv_ta = "JV / assets")
reference <- "2020-06-30"
p <- read.csv(inputs[1], na.strings = "NA", colClasses = c(firm_id = "character", date = "character", report_date = "character"))
p <- p[!is.na(p$sample_main) & p$sample_main & !is.na(p$dose_pre), ]
stopifnot(!anyDuplicated(p[c("firm_id", "date")]), !anyNA(p[c("firm_id", "date", "post")]))
dates <- sort(unique(p$date))
ids <- sort(unique(p$firm_id))
f <- p[match(ids, p$firm_id), c("firm_id", "dose_pre", "soe_final", "market")]
rownames(f) <- NULL
for (v in c("dose_pre", "soe_final", "market"))
  stopifnot(all(vapply(split(p[[v]], p$firm_id), function(x) length(unique(x)) == 1L, logical(1))))
stopifnot(all(is.na(f$soe_final) | f$soe_final %in% 0:1), all(f$market %in% c("A", "HK")))
# Ownership and market are the card-prescribed static panel categories. Ownership
# is not re-dated: the inherited 2020 snapshot/later coding is a D9/D18 limitation.
f$soe_category <- factor(ifelse(is.na(f$soe_final), "missing", as.character(f$soe_final)), levels = c("0", "1", "missing"))
f$market_category <- factor(f$market, levels = c("A", "HK"))
f$dose_rounded <- floor(f$dose_pre + 0.5) # T005/T012 convention: half values round upward.

# Establish and assert the financial-control input window BEFORE any calculation.
# Two mapped December-2019 rows actually refer to March 2020: exclude them here.
pre_window <- p$date >= "2017-06-30" & p$date <= "2019-12-31"
future_mapped_rows <- sum(pre_window & !is.na(p$report_date) & p$report_date > "2019-12-31")
pre <- p[pre_window & !is.na(p$report_date) & p$report_date <= "2019-12-31", ]
stopifnot(nrow(pre) > 0L, all(pre$date <= "2019-12-31"), all(pre$report_date <= "2019-12-31"),
          all(pre$date >= "2017-06-30"))
ratio <- function(a, b) ifelse(is.finite(a) & is.finite(b) & b > 0, a / b, NA_real_)
pre$size <- pre$log_ta
pre$roa <- ratio(pre$ni, pre$ta)
pre$liquidity <- ratio(pre$cash, pre$ta)
pre$inventory <- ratio(pre$inv, pre$ta)
pre$sales <- ratio(pre$rev, pre$ta)
continuous <- c("size", "roa", "liquidity", "inventory", "sales")
control_labels <- c(size = "Log assets", roa = "ROA (annual)", liquidity = "Cash / assets",
                    inventory = "Inventory / assets", sales = "Revenue / assets (annual)")
# 01_clean.R source maps and dictionary: EastMoney A NETPROFIT/TOTAL_OPERATE_INCOME,
# EastMoney HK after-tax profit/turnover, Wind A net profit/total operating revenue,
# Wind HK after-tax net profit/total operating revenue are all reported YTD.
# June six-month and December twelve-month numerators are not comparable as-is.
# Use the card's December-only fallback for BOTH flows, consistently across sources.
# Require actual December reports too, excluding mapped non-calendar reports.
flow_gate <- substr(pre$date, 6, 10) == "12-31" & substr(pre$report_date, 6, 10) == "12-31"
pre$roa[!flow_gate] <- NA_real_
pre$sales[!flow_gate] <- NA_real_
flow_audit <- do.call(rbind, lapply(split(pre, list(pre$market, pre$source), drop = TRUE), function(d) {
  do.call(rbind, lapply(c("roa", "sales"), function(v) data.frame(market = d$market[1], source = d$source[1],
    variable = v, convention = "YTD; December annual reports only; no annual/half-year pooling",
    eligible_rows = sum(is.finite(d[[v]])), eligible_firms = length(unique(d$firm_id[is.finite(d[[v]])])))))
}))
control_summary <- list()
for (v in continuous) {
  f[[paste0("n_", v)]] <- vapply(ids, function(id) sum(is.finite(pre[[v]][pre$firm_id == id])), integer(1))
  f[[v]] <- vapply(ids, function(id) {
    x <- pre[[v]][pre$firm_id == id]; x <- x[is.finite(x)]
    if (length(x) >= 3L) mean(x) else NA_real_
  }, numeric(1))
  included <- !v %in% c("roa", "sales") || sum(!is.na(f[[v]])) >= 100L
  mu <- mean(f[[v]], na.rm = TRUE); sigma <- sd(f[[v]], na.rm = TRUE)
  stopifnot(is.finite(mu), is.finite(sigma), sigma > 0)
  f[[paste0("m_", v)]] <- as.integer(is.na(f[[v]]))
  z <- (f[[v]] - mu) / sigma
  stopifnot(abs(mean(z, na.rm = TRUE)) < 1e-12, abs(sd(z, na.rm = TRUE) - 1) < 1e-12)
  z[is.na(z)] <- 0
  f[[paste0("z_", v)]] <- z
  control_summary[[v]] <- data.frame(variable = v, included = included, n_firms = nrow(f),
    n_observed = sum(!is.na(f[[v]])), n_missing = sum(is.na(f[[v]])), mean = mu, sd = sigma,
    correlation_with_dose = cor(f[[v]], f$dose_pre, use = "complete.obs"),
    n_correlation = sum(!is.na(f[[v]])), max_date = max(pre$date[is.finite(pre[[v]])]),
    max_report_date = max(pre$report_date[is.finite(pre[[v]])]),
    convention = if (v %in% c("roa", "sales")) "December annual reports only; at least 3 dates" else "Half-year-end stocks; at least 3 dates")
  if (!included) cat("DROP CONTROL (approved <100-firm December fallback): ", v, "\n", sep = "")
}
summary_controls <- do.call(rbind, control_summary)
active <- summary_controls$variable[summary_controls$included]
continuous_terms <- as.vector(rbind(paste0("z_", active), paste0("m_", active)))
size_terms <- c("z_size", "m_size")
# D22 rule copied exactly from T024, with missing comparisons ignored.
post <- p[p$post == 1L, ]
stopifnot(all(post$date >= "2020-12-31"))
for (v in c("te_nonpos", "mi_gt_te", "rl2_extreme")) {
  condition <- switch(v, te_nonpos = post$te <= 0, mi_gt_te = post$mi > post$te, rl2_extreme = post$rl2 > 5)
  f[[paste0("n_post_", v)]] <- vapply(ids, function(id) sum(condition[post$firm_id == id], na.rm = TRUE), integer(1))
}
f$flag_equity_problem <- f$n_post_te_nonpos > 0 | f$n_post_mi_gt_te > 0 | f$n_post_rl2_extreme > 0
stopifnot(!anyNA(f$flag_equity_problem))
for (v in setdiff(names(f), c("firm_id", "dose_pre", "soe_final", "market"))) p[[v]] <- f[[v]][match(p$firm_id, f$firm_id)]

balance_vars <- c(continuous, "soe_1", "soe_missing", "market_HK")
f$soe_1 <- ifelse(is.na(f$soe_final), NA_real_, f$soe_final)
f$soe_missing <- as.integer(is.na(f$soe_final))
f$market_HK <- as.integer(f$market == "HK")
balance <- do.call(rbind, lapply(balance_vars, function(v) do.call(rbind, lapply(c("all", as.character(0:3)), function(g) {
  d <- if (g == "all") f else f[f$dose_rounded == as.integer(g), ]
  x <- d[[v]]; ok <- is.finite(x)
  data.frame(variable = v, rounded_dose = g, n_firms = nrow(d), n_observed = sum(ok), n_missing = sum(!ok),
    mean = if (any(ok)) mean(x[ok]) else NA_real_, sd = if (sum(ok) > 1) sd(x[ok]) else NA_real_,
    correlation_with_dose = if (sum(ok) > 1 && sd(x[ok]) > 0 && sd(d$dose_pre[ok]) > 0) cor(x[ok], d$dose_pre[ok]) else NA_real_)
}))))
rownames(balance) <- NULL

# Missing indicators accompany every included continuous control; constants are
# structurally collinear and may be removed. Factor interactions omit references.
interact <- function(vars, flexible = FALSE) {
  vapply(vars, function(v) {
    if (v %in% c("soe_category", "market_category")) {
      ref <- if (v == "soe_category") "0" else "A"
      if (flexible) paste0('i(date, i.', v, ', ref = "', reference, '", ref2 = "', ref, '")')
      else paste0('i(', v, ', post, ref = "', ref, '")')
    } else if (flexible) paste0('i(date, ', v, ', ref = "', reference, '")') else paste0(v, ":post")
  }, character(1))
}
all_terms <- c(continuous_terms, "soe_category", "market_category")
spec_terms <- list(C0 = character(), C1 = interact(size_terms), C2 = interact(continuous_terms),
                   C3 = interact(all_terms), C4 = interact(all_terms, TRUE), C5 = interact(all_terms))
models <- list(); rows <- list(); validation <- list()
baseline <- read.csv(inputs[4])
# C0 is estimated and checked for all outcomes BEFORE controlled estimation/output.
for (y in outcomes) {
  m <- fixest::feols(as.formula(paste(y, "~ dose_pre:post | firm_id + date")), data = p,
                     cluster = ~firm_id, fixef.rm = "singleton")
  b <- baseline[baseline$outcome == y, ]
  used <- p[fixest::obs(m), ]; ci <- confint(m)
  actual <- c(coefficient = unname(coef(m)[1]), std_error = unname(fixest::se(m)[1]),
    ci_lower = unname(ci[1, 1]), ci_upper = unname(ci[1, 2]), N = nobs(m),
    n_firms = length(unique(used$firm_id)), pre_mean = mean(used[[y]][used$post == 0]),
    base_N = nrow(p), missing_outcome = sum(is.na(p[[y]])),
    singleton_rows = nrow(p) - sum(is.na(p[[y]])) - nobs(m), dropped_share = (nrow(p) - nobs(m)) / nrow(p))
  delta <- abs(actual - unlist(b[names(actual)], use.names = FALSE))
  if (any(!is.finite(delta)) || any(delta > 1e-12)) stop("STOP: C0 does not reproduce T009: ", y)
  validation[[y]] <- data.frame(outcome = y, field = names(actual), actual = unname(actual),
                               reference = unlist(b[names(actual)], use.names = FALSE), absolute_difference = unname(delta))
  models[[paste(y, "C0")]] <- m
}
cat("C0 ASSERT: every T009 numeric field reproduced within 1e-12 for all five outcomes.\n")
for (y in outcomes) for (s in names(spec_terms)) {
  d <- if (s == "C5") p[!p$flag_equity_problem, ] else p
  formula <- as.formula(paste(y, "~", paste(c("dose_pre:post", spec_terms[[s]]), collapse = " + "), "| firm_id + date"))
  m <- if (s == "C0") models[[paste(y, s)]] else tryCatch(
    fixest::feols(formula, data = d, cluster = ~firm_id, fixef.rm = "singleton"),
    error = function(e) { if (s != "C4") stop(e); structure(list(message = conditionMessage(e)), class = "t028_failed") })
  r <- data.frame(outcome = y, specification = s, coefficient = NA_real_, std_error = NA_real_,
    ci_lower = NA_real_, ci_upper = NA_real_, p_value = NA_real_, N = NA_integer_, n_firms = NA_integer_,
    within_r2 = NA_real_, slope_df = NA_integer_, control_df = NA_integer_, model_parameters_including_fe = NA_integer_,
    residual_df = NA_integer_, inference_df_t = NA_integer_,
    excluded_firms_base = if (s == "C5") sum(f$flag_equity_problem) else 0L,
    excluded_firms_from_C3 = 0L, collinear_terms = "", formula = paste(deparse(formula), collapse = " "), status = "estimated")
  if (inherits(m, "t028_failed") || !"dose_pre:post" %in% names(coef(m))) {
    if (s != "C4") stop("Missing dose coefficient outside C4")
    r$status <- if (inherits(m, "t028_failed")) paste0("not_estimable: ", m$message) else "not_estimable: dose collinear"
  } else {
    models[[paste(y, s)]] <- m
    term <- "dose_pre:post"; ci <- confint(m)[term, , drop = FALSE]
    r$coefficient <- unname(coef(m)[term]); r$std_error <- unname(fixest::se(m)[term])
    r$ci_lower <- unname(ci[1, 1]); r$ci_upper <- unname(ci[1, 2]); r$p_value <- unname(fixest::pvalue(m)[term])
    r$N <- nobs(m); r$n_firms <- length(unique(d$firm_id[fixest::obs(m)]))
    r$within_r2 <- unname(fixest::fitstat(m, "wr2")[[1]])
    r$slope_df <- length(coef(m)); r$control_df <- r$slope_df - 1L
    r$model_parameters_including_fe <- m$nparams
    r$residual_df <- nobs(m) - m$nparams
    r$inference_df_t <- attr(m$cov.scaled, "df.t")
    # Use the original-data RHS so all-zero columns survive matrix construction.
    # collin.var alone omits missing indicators silently removed before fitting.
    requested <- colnames(model.matrix(m, data = d, type = "rhs", sample = "original", collin.rm = FALSE))
    estimated <- names(coef(m))
    stopifnot(!anyDuplicated(requested), all(estimated %in% requested))
    dropped <- setdiff(requested, estimated)
    stopifnot(length(requested) == r$slope_df + length(dropped), all(m$collin.var %in% dropped))
    r$collinear_terms <- paste(dropped, collapse = ";")
    stopifnot(grepl("firm_id", attr(m$cov.scaled, "type"), fixed = TRUE))
    if (s %in% c("C1", "C2", "C3", "C4")) stopifnot(identical(fixest::obs(m), fixest::obs(models[[paste(y, "C0")]])))
    if (s == "C5") {
      c3 <- models[[paste(y, "C3")]]
      r$excluded_firms_from_C3 <- sum(unique(p$firm_id[fixest::obs(c3)]) %in% f$firm_id[f$flag_equity_problem])
    }
  }
  rownames(r) <- NULL
  rows[[paste(y, s)]] <- r
}
result <- do.call(rbind, unname(rows)); rownames(result) <- NULL
stopifnot(nrow(result) == 30L, all(table(result$specification) == 5L))
stability <- do.call(rbind, lapply(outcomes, function(y) {
  d <- result[result$outcome == y, ]; b <- d[d$specification == "C0", ]
  do.call(rbind, lapply(c("C3", "C4"), function(s) {
    c <- d[d$specification == s, ]
    data.frame(outcome = y, specification = s, baseline_coefficient = b$coefficient, coefficient = c$coefficient,
      baseline_se = b$std_error, change_in_baseline_se = (c$coefficient - b$coefficient) / b$std_error,
      within_r2_C0 = b$within_r2, within_r2_controls = c$within_r2, status = c$status)
  }))
}))

events <- list(); pretrends <- list()
pre_dates <- dates[dates < reference]
pre_pattern <- paste0("^date::(", paste(pre_dates, collapse = "|"), "):dose_pre$")
for (y in c("rl1", "mi_share")) for (s in c("C0", "C3-date")) {
  # C3-date uses the pooled C3 control SET, all interacted with date as in C4.
  rhs <- c(paste0('i(date, dose_pre, ref = "', reference, '")'), if (s == "C3-date") interact(all_terms, TRUE))
  m <- fixest::feols(as.formula(paste(y, "~", paste(rhs, collapse = " + "), "| firm_id + date")),
                     data = p, cluster = ~firm_id, fixef.rm = "singleton")
  stopifnot(identical(fixest::obs(m), fixest::obs(models[[paste(y, "C0")]])))
  terms <- grep("^date::.*:dose_pre$", names(coef(m)), value = TRUE)
  stopifnot(setequal(terms, paste0("date::", dates[dates != reference], ":dose_pre")))
  ci <- confint(m)[terms, , drop = FALSE]
  events[[paste(y, s)]] <- data.frame(outcome = y, specification = s,
    date = sub(":dose_pre$", "", sub("^date::", "", terms)), coefficient = unname(coef(m)[terms]),
    std_error = unname(fixest::se(m)[terms]), ci_lower = ci[, 1], ci_upper = ci[, 2],
    N = nobs(m), n_firms = length(unique(p$firm_id[fixest::obs(m)])),
    control_df = length(coef(m)) - length(terms))
  selected <- grep(pre_pattern, names(coef(m)), value = TRUE)
  stopifnot(setequal(selected, paste0("date::", pre_dates, ":dose_pre")), length(selected) == 7L)
  w <- fixest::wald(m, keep = pre_pattern, print = FALSE)
  stopifnot(w$df1 == 7L, is.finite(w$p))
  pretrends[[paste(y, s)]] <- data.frame(outcome = y, specification = s, statistic = unname(w$stat),
    df = unname(w$df1), df_denom = unname(w$df2), p_value = unname(w$p), test = "Joint Wald F",
    tested_dates = paste(pre_dates, collapse = ";"), N = nobs(m), n_firms = length(unique(p$firm_id[fixest::obs(m)])))
}
events <- do.call(rbind, events); pretrends <- do.call(rbind, pretrends)
rownames(events) <- rownames(pretrends) <- NULL
stopifnot(nrow(events) == 48L, nrow(pretrends) == 4L)
write_out(balance, "balance"); write_out(result, "controls_did")
write_out(summary_controls, "control_summary"); write_out(f, "firm_controls")
write_out(flow_audit, "flow_conventions"); write_out(do.call(rbind, validation), "baseline_validation")
write_out(stability, "coefficient_stability")
write_out(events, "event_study_controls"); write_out(pretrends, "pretrend_controls")

fmt <- function(x) ifelse(is.na(x), "NA", sprintf("%.6f", x))
notes <- paste0(
  "Controls are pre-period means from 2017H1 through 2019H2 interacted with time, chosen before estimation. ",
  "Contemporaneous controls are excluded because the policy can itself change these balance-sheet variables. ",
  "Continuous controls: log assets, annual ROA, cash over assets, inventory over assets, and annual revenue over assets. ",
  "Each requires at least three dates; observed firm means are standardized across the 124 baseline firms, then missing values are set to zero with a separate missing indicator. ",
  "June income statements cover six months and December statements twelve months in both EastMoney and Wind. ",
  "ROA and revenue intensity therefore use December annual reports only, with at least three annual dates. ",
  "Actual and mapped report dates are at or before December 31, 2019; ", future_mapped_rows, " mapped rows with later actual dates are excluded from control construction. ",
  "Ownership uses the prescribed fixed panel SOE category (0, 1, or missing) and market uses A-share or HK. ",
  "The inherited ownership snapshot is June 2020 with some later disclosure coding (D9 and D18); its pre-2020 status cannot be verified from this panel. ",
  "Log assets retain reported currency units; unresolved HK currencies limit comparability (D7). ",
  "Firm and half-year fixed effects; standard errors clustered by firm, with default small-sample corrections. ",
  "Identification requires conditional parallel counterfactual trends across exposure levels, no anticipation, and no remaining dose-correlated shocks. ",
  "Pre-trend tests do not establish these assumptions; both exposure and the pre-period control means overlap the pre-test window (I9).")
bl <- c("% T028 balance fragment; requires booktabs and graphicx.", "\\begingroup\\small",
  "\\noindent\\resizebox{\\linewidth}{!}{%", "\\begin{tabular}{lrrrrrr}", "\\toprule",
  "Characteristic & Dose 0 & Dose 1 & Dose 2 & Dose 3 & Missing & Corr. with dose \\\\", "\\midrule")
bal_labels <- c(control_labels, soe_1 = "SOE share among known", soe_missing = "Missing SOE share", market_HK = "HK share")
for (v in balance_vars) {
  a <- balance[balance$variable == v & balance$rounded_dose == "all", ]
  d <- balance[balance$variable == v & balance$rounded_dose != "all", ]
  bl <- c(bl, paste0(bal_labels[[v]], " & ", paste(c(fmt(d$mean), a$n_missing, fmt(a$correlation_with_dose)), collapse = " & "), " \\\\"))
}
bl <- c(bl, paste0("Firms & ", paste(as.integer(table(factor(f$dose_rounded, levels = 0:3))), collapse = " & "), " & & \\\\"),
  "\\bottomrule\\end{tabular}}", "\\par\\smallskip\\noindent\\begin{minipage}{\\linewidth}\\footnotesize",
  paste0("\\textit{Notes:} Entries are means in original units, before standardization. Rounded exposure uses floor(exposure + 0.5), so half values round upward, as in T005 and T012. ",
    "Correlations use observed firm means and continuous exposure, without zero imputation. Missing counts refer to all 124 firms. ", notes),
  "\\end{minipage}\\par\\endgroup")
write_tex(bl, "balance")
tl <- c("% T028 DiD fragment; requires booktabs and graphicx.", "\\begingroup\\small",
  "\\noindent\\resizebox{\\linewidth}{!}{%", "\\begin{tabular}{lrrrrrr}", "\\toprule",
  "Outcome & C0 & C1 & C2 & C3 & C4 & C5 \\\\", "\\midrule")
for (y in outcomes) {
  d <- result[result$outcome == y, ]; d <- d[match(names(spec_terms), d$specification), ]
  se_cells <- paste0("(", fmt(d$std_error), ")")
  # Presentation only: retain every model value in the CSV, but suppress the
  # unreliable CR1 SE where C4 has more slope parameters than firm clusters.
  if (y == "jv_ta") se_cells[d$specification == "C4"] <- "--"
  tl <- c(tl, paste0(labels[[y]], " & ", paste(fmt(d$coefficient), collapse = " & "), " \\\\"),
    paste0(" & ", paste(se_cells, collapse = " & "), " \\\\"),
    paste0("N / Firms & ", paste(paste0(d$N, " / ", d$n_firms), collapse = " & "), " \\\\"),
    paste0("Control df & ", paste(d$control_df, collapse = " & "), " \\\\\\addlinespace"))
}
tl <- c(tl, "\\bottomrule\\end{tabular}}", "\\par\\smallskip\\noindent\\begin{minipage}{\\linewidth}\\footnotesize",
  paste0("\\textit{Notes:} All six prespecified specifications are retained without significance stars. ",
    "C0: baseline. C1: size and its missing indicator times post. C2: all included continuous controls and their missing indicators times post. ",
    "C3: C2 plus SOE categories and market times post. C4: the C3 control set times each date, reference June 30, 2020. ",
    "C5: C3 excluding ", sum(f$flag_equity_problem), " firms with any post-policy date having nonpositive total equity, minority equity above total equity, or RL2 above 5 (D22). ",
    "This post-period exclusion is a sensitivity analysis and can select on policy outcomes. ",
    "Control df counts retained control coefficients; residual df is N less all estimated parameters including fixed effects. ",
    "The CSV additionally reports cluster-t inference df, within R-squared, and every requested slope term absent from the estimated coefficient vector, including all-zero missing indicators. ",
    "Constant or redundant missing-indicator interactions are collinear and omitted. ",
    "For RL1, the larger coefficient magnitude under C2 through C4 coincides with a conditional pre-trend: the joint pre-test under controls times date has p = ",
    sprintf("%.6f", pretrends$p_value[pretrends$outcome == "rl1" & pretrends$specification == "C3-date"]),
    ". It must not be interpreted as a stronger policy effect. ",
    "C4 uses 109 slope parameters for 124 clusters (122 for minority share); the controlled event studies use 120 slopes for 124 or 122 clusters. ",
    "These counts approach the number of clusters, making CR1 standard errors and joint tests unreliable. ",
    "For JV over assets, C4 uses 106 slopes for 101 clusters; its CR1 standard error is displayed as --. ",
    "The CSV preserves the unmodified model standard errors, intervals, and p-values for audit only in these specifications. ", notes),
  "\\end{minipage}\\par\\endgroup")
write_tex(tl, "controls_did")

for (y in c("rl1", "mi_share")) {
  d <- events[events$outcome == y, ]; d$period <- match(d$date, dates)
  d$period <- d$period + ifelse(d$specification == "C0", -.09, .09)
  normal <- data.frame(period = match(reference, dates) + c(-.09, .09), coefficient = 0, specification = c("C0", "C3-date"))
  plot <- ggplot2::ggplot(d, ggplot2::aes(period, coefficient, color = specification, shape = specification)) +
    ggplot2::geom_hline(yintercept = 0, color = "grey60", linewidth = .4) +
    ggplot2::geom_vline(xintercept = match(reference, dates) + .5, linetype = "dashed", color = "grey50") +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = ci_lower, ymax = ci_upper), width = .12, linewidth = .5) +
    ggplot2::geom_point(size = 2) + ggplot2::geom_point(data = normal, shape = 1, size = 2.5, show.legend = FALSE) +
    ggplot2::scale_color_manual(values = c(C0 = "#245577", "C3-date" = "#BC5B35"), labels = c("C0: baseline", "C3-date: controls x date")) +
    ggplot2::scale_shape_manual(values = c(C0 = 16, "C3-date" = 17), labels = c("C0: baseline", "C3-date: controls x date")) +
    ggplot2::scale_x_continuous(breaks = seq_along(dates), labels = paste0(substr(dates, 1, 4), ifelse(substr(dates, 6, 7) == "06", "H1", "H2"))) +
    ggplot2::labs(title = labels[[y]], subtitle = "Dose event study; C3-date uses pre-period firm controls interacted with each date",
      x = "Reporting half-year", y = "Coefficient per additional pre-policy breach (ratio units)", color = NULL, shape = NULL,
      caption = paste0("95% cluster-t intervals; firm and date fixed effects. Reference: 2020H1 (hollow points).\n",
        "Dashed line: policy starts in 2020H2. Same outcome sample in both models; N = ", unique(d$N), "; firms = ", unique(d$n_firms), ".")) +
    ggplot2::theme_minimal(base_size = 11) + ggplot2::theme(legend.position = "top", panel.grid.minor = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1), plot.caption = ggplot2::element_text(hjust = 0, size = 9),
      plot.margin = ggplot2::margin(12, 16, 12, 20))
  ggplot2::ggsave(paste0("outputs/figures/t028_es_", y, "_controls.pdf"), plot, device = grDevices::pdf,
                  width = 9, height = 5.5, units = "in", timestamp = FALSE)
}
stopifnot(identical(unname(tools::sha256sum(inputs)), unname(input_hash)),
          identical(unname(tools::sha256sum(protected)), unname(protected_hash)))
cat("FINANCIAL CONTROL DATE ASSERT: mapped and actual dates <= 2019-12-31; later mapped rows excluded: ", future_mapped_rows, ".\n", sep = "")
cat("CONTROL MISSINGNESS AND CORRELATIONS:\n"); print(summary_controls, row.names = FALSE)
cat("C5 flagged baseline firms: ", sum(f$flag_equity_problem), "/", nrow(f), "; IDs: ", paste(f$firm_id[f$flag_equity_problem], collapse = ", "), "\n", sep = "")
cat("ALL SIX SPECIFICATIONS:\n"); print(result[c("outcome", "specification", "coefficient", "std_error", "N", "n_firms", "control_df", "residual_df", "status")], row.names = FALSE)
cat("COEFFICIENT STABILITY (signed changes in baseline SE units; no dichotomous threshold):\n"); print(stability, row.names = FALSE)
cat("JOINT PRE-TREND TESTS (seven coefficients strictly before reference):\n"); print(pretrends, row.names = FALSE)
cat("T028 completed: 30 pooled cells, 48 event coefficients, 4 joint tests, 2 figures.\n")
cat("Input and all pre-existing non-T028 output SHA-256 assertions passed.\n")
