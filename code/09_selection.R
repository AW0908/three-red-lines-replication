# T025: approved pooled-post selection corrections and Lee sensitivity bounds.
# Run from replication/: Rscript --vanilla code/09_selection.R
# Offline; only T025 outputs are written. Both stages use whole-firm bootstrap draws.
source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(stringsAsFactors = FALSE, digits = 17, width = 160)
invisible(Sys.setlocale("LC_NUMERIC", "C"))
stopifnot(requireNamespace("fixest", quietly = TRUE))
fixest::setFixest_nthreads(1)
B <- 499L
inputs <- c("data/processed/panel_firm_halfyear.csv", "code/02_estimate.R",
            "outputs/tables/t009_did_main.csv", "../state/LIMITATIONS.md",
            "../state/STATE.md", "../tasks/T025.md")
input_hash <- tools::sha256sum(inputs)
protected <- list.files("outputs", recursive = TRUE, full.names = TRUE)
protected <- protected[!dir.exists(protected) & !startsWith(basename(protected), "t025_")]
protected_hash <- tools::sha256sum(protected)
outcomes <- c("rl1", "rl2", "mi_share", "rl2_gap", "jv_ta")
dates <- sort(c("2016-12-31", paste0(rep(2017:2022, each = 2),
                                     rep(c("-06-30", "-12-31"), 6))))
p <- read.csv("data/processed/panel_firm_halfyear.csv", na.strings = "NA",
              colClasses = c(firm_id = "character", date = "character"))
p <- p[!is.na(p$sample_main) & p$sample_main & !is.na(p$dose_pre), ]
ids <- sort(unique(p$firm_id))
stopifnot(!anyDuplicated(p[c("firm_id", "date")]), length(ids) == 124L,
          all(p$date %in% dates), all(p$post == as.integer(p$date >= "2020-12-31")))

# Recompute the entire T009 baseline row, including outcome-specific FE removal.
ref <- read.csv("outputs/tables/t009_did_main.csv")
checks <- list()
for (y in outcomes) {
  m <- fixest::feols(as.formula(paste(y, "~ dose_pre:post | firm_id + date")),
                    data = p, cluster = ~firm_id, fixef.rm = "singleton", notes = FALSE)
  used <- p[fixest::obs(m), ]
  ci <- confint(m)
  actual <- c(coefficient = unname(coef(m)["dose_pre:post"]),
              std_error = unname(fixest::se(m)["dose_pre:post"]),
              ci_lower = ci[1, 1], ci_upper = ci[1, 2], N = nobs(m),
              n_firms = length(unique(used$firm_id)),
              pre_mean = mean(used[[y]][used$post == 0]), base_N = nrow(p),
              missing_outcome = sum(is.na(p[[y]])),
              singleton_rows = nrow(p) - sum(is.na(p[[y]])) - nobs(m),
              dropped_share = (nrow(p) - nobs(m)) / nrow(p))
  expected <- unlist(ref[ref$outcome == y, names(actual)], use.names = FALSE)
  delta <- abs(actual - expected)
  stopifnot(all(is.finite(delta)), all(delta <= 1e-12))
  checks[[y]] <- data.frame(outcome = y, max_absolute_difference = max(delta),
                            coefficient = actual["coefficient"],
                            std_error = actual["std_error"], N = nobs(m))
}
checks <- do.call(rbind, checks)
rownames(checks) <- NULL
mtpa_write_csv(checks, "outputs/tables/t025_baseline_validation.csv", row.names = FALSE)

# All 124 firms and all 13 dates remain in the risk set, even absent panel rows.
f <- do.call(rbind, lapply(ids, function(id) {
  d <- p[p$firm_id == id, ]
  pre <- d[d$date <= "2019-12-31", ]
  stopifnot(length(unique(d$dose_pre)) == 1L, length(unique(d$market)) == 1L)
  r <- data.frame(firm_id = id, dose_pre = d$dose_pre[1], market = d$market[1],
                  Z = sum(!is.na(pre$ta)) / 7,
                  pre_log_ta = mean(pre$log_ta, na.rm = TRUE),
                  reported_2020h1 = as.integer(any(d$date == "2020-06-30" & !is.na(d$ta))),
                  balanced = all(dates %in% d$date[d$has_row]))
  for (y in outcomes) r[[paste0("pre_", y)]] <- mean(pre[[y]], na.rm = TRUE)
  r
}))
g <- expand.grid(firm_id = ids, date = dates, stringsAsFactors = FALSE)
idx <- match(paste(g$firm_id, g$date), paste(p$firm_id, p$date))
for (y in outcomes) g[[y]] <- p[[y]][idx]
g <- merge(g, f, by = "firm_id", sort = FALSE)
g <- g[order(g$firm_id, g$date), ]
g$post <- as.integer(g$date >= "2020-12-31")
g$dose_group <- floor(g$dose_pre + 0.5) # nearest integer, half ties upward
stopifnot(nrow(g) == 124L * 13L, !anyNA(g$Z), length(unique(f$Z)) > 1L)

write_out <- function(x, name) mtpa_write_csv(x, paste0("outputs/tables/t025_", name, ".csv"), row.names = FALSE)
write_note <- function(x, name) mtpa_write_lines(x, paste0("outputs/tables/t025_", name))

# All rows of the prescribed risk set remain in both selection models. An all-zero
# missingness indicator is algebraically redundant, so omit it in that case only.
prepare <- function(d, y) {
  d$s <- as.integer(!is.na(d[[y]]))
  d$pre_y <- d[[paste0("pre_", y)]]
  d$pre_mean_missing <- as.integer(!is.finite(d$pre_y))
  d$pre_y[d$pre_mean_missing == 1L] <- 0
  stopifnot(!anyNA(d[c("dose_pre", "market", "Z", "reported_2020h1")]),
            all(is.finite(d$pre_log_ta)), all(is.finite(d$pre_y)))
  d
}
selection_fit <- function(d, link, stop_on_failure = TRUE) {
  terms <- c("dose_pre", "pre_y", "pre_log_ta", "market")
  if (any(d$pre_mean_missing != 0)) terms <- c(terms, "pre_mean_missing")
  # IPW follows step 3: pooled post logit on pre-treatment characteristics only.
  terms <- c(terms, if (link == "probit") c("factor(date)", "Z") else "reported_2020h1")
  warns <- character()
  model <- withCallingHandlers(glm(reformulate(terms, "s"), data = d,
    family = binomial(link), na.action = na.fail, control = glm.control(maxit = 100)),
    warning = function(w) { warns <<- c(warns, conditionMessage(w)); invokeRestart("muffleWarning") })
  if (!isTRUE(model$converged) && stop_on_failure) {
    write_out(data.frame(term = names(coef(model)), coefficient = unname(coef(model)),
      link = link, converged = model$converged, iterations = model$iter,
      risk_rows = nrow(d), selected_rows = sum(d$s), rank = model$rank,
      min_fitted = min(fitted(model)), max_fitted = max(fitted(model)),
      warnings = paste(unique(warns), collapse = "; ")), "failed_probit")
    write_out(d[c("firm_id", "date", "s", "dose_pre", "pre_y", "pre_log_ta", "market",
                  "pre_mean_missing", "Z", "reported_2020h1")], "failed_probit_risk")
    stop("T025 STOP: pooled post ", link, " failed to converge.", call. = FALSE)
  }
  stopifnot(nobs(model) == nrow(d))
  list(model = model, warnings = paste(unique(warns), collapse = "; "))
}
cluster_z <- function(m, d) {
  # Rank-deficient columns (e.g. a constant missing indicator in a bootstrap draw)
  # do not enter the score sandwich. Firms, rather than firm-dates, are clusters.
  keep <- names(coef(m))[!is.na(coef(m))]
  X <- model.matrix(m)[, keep, drop = FALSE]
  score <- X * as.vector(residuals(m, type = "working") * m$weights)
  U <- rowsum(score, d$firm_id, reorder = FALSE)
  bread <- summary(m)$cov.unscaled
  G <- nrow(U); N <- nrow(d); K <- m$rank
  V <- (G / (G - 1)) * ((N - 1) / (N - K)) * bread %*% crossprod(U) %*% bread
  se <- if ("Z" %in% rownames(V)) sqrt(V["Z", "Z"]) else NA_real_
  c(coefficient = unname(coef(m)["Z"]), se = se,
    z = unname(coef(m)["Z"]) / se)
}
main_model <- function(d, y, heckman = FALSE, weighted = FALSE) {
  fixest::feols(as.formula(paste(y, "~ dose_pre:post", if (heckman) "+ lambda" else "",
                               "| firm_id + date")), data = d, cluster = ~firm_id,
                weights = if (weighted) ~ipw else NULL, fixef.rm = "singleton", notes = FALSE,
                warn = FALSE)
}
heckman_fit <- function(d, y, bootstrap = FALSE) {
  dp <- d[d$post == 1L, ]
  # Approved rule: a present missing-indicator group without an observed post
  # row is separated by construction, irrespective of glm's numerical flag.
  if (bootstrap && any(dp$pre_mean_missing == 1L) &&
      !any(dp$s == 1L & dp$pre_mean_missing == 1L))
    return(list(valid = FALSE, converged = NA, warnings = "",
                reason = "missing-indicator group has no observed post row"))
  fit <- selection_fit(dp, "probit", stop_on_failure = !bootstrap)
  if (!isTRUE(fit$model$converged))
    return(list(valid = FALSE, converged = FALSE, warnings = fit$warnings,
                reason = "pooled probit did not converge"))
  # E[u | s=1] uses phi(eta)/Phi(eta), evaluated on the log scale even when
  # fitted probabilities round to 0 or 1. No arbitrary clipping of Mills ratios.
  eta <- predict(fit$model, newdata = dp, type = "link")
  d$lambda <- 0
  d$lambda[d$post == 1L] <- exp(dnorm(eta, log = TRUE) - pnorm(eta, log.p = TRUE))
  stopifnot(all(is.finite(d$lambda)), all(d$lambda[d$post == 0L] == 0))
  list(first = fit, second = main_model(d, y, heckman = TRUE), data = d,
       valid = TRUE, converged = TRUE, warnings = fit$warnings, reason = "")
}
ipw_fit <- function(d, y) {
  dp <- d[d$post == 1L, ]
  fit <- selection_fit(dp, "logit")
  pp <- fitted(fit$model)
  # Type-7 percentiles over observed post rows only, refitted in every draw.
  raw_w <- 1 / pp[dp$s == 1L]
  stopifnot(all(is.finite(raw_w)), all(raw_w >= 1))
  limits <- quantile(raw_w, c(.01, .99), type = 7, names = FALSE)
  d$ipw <- 1
  post_observed <- d$post == 1L & d$s == 1L
  d$ipw[post_observed] <- pmin(limits[2], pmax(limits[1], raw_w))
  list(first = fit, second = main_model(d, y, weighted = TRUE), data = d,
       probability = pp, limits = limits)
}
# Exactly retain the requested mass with fractional boundary observations; no
# integer rounding of the Lee trimming fraction, including tied outcomes.
tail_mean <- function(x, mass, upper = FALSE) {
  stopifnot(length(x) > 0L, mass > 0, mass <= 1 + 1e-12)
  x <- sort(x, decreasing = upper)
  n_keep <- min(length(x), length(x) * mass)
  w <- pmax(0, pmin(1, n_keep - (seq_along(x) - 1)))
  sum(w * x) / sum(w)
}
lee_fit <- function(d) {
  # A change requires a pre observation. Define the risk population explicitly:
  # firms in the dose bins with >=1 pre outcome; selection is >=1 post outcome.
  eligible <- d$lee_group != "middle" & is.finite(d$pre_mean)
  q <- d[eligible, ]
  hi <- q$lee_group == "high"
  n1 <- sum(hi); n0 <- sum(!hi)
  x1 <- q$change[hi & is.finite(q$change)]
  x0 <- q$change[!hi & is.finite(q$change)]
  p1 <- length(x1) / n1; p0 <- length(x0) / n0
  if (any(!is.finite(c(p1, p0))) || min(p1, p0) <= 0)
    return(c(lower = NA_real_, upper = NA_real_, untrimmed = NA_real_,
             rate_high = p1, rate_low = p0, trim_fraction = NA_real_))
  if (p1 <= p0) {
    keep <- p1 / p0
    lo <- mean(x1) - tail_mean(x0, keep, upper = TRUE)
    up <- mean(x1) - tail_mean(x0, keep, upper = FALSE)
  } else {
    keep <- p0 / p1
    lo <- tail_mean(x1, keep, upper = FALSE) - mean(x0)
    up <- tail_mean(x1, keep, upper = TRUE) - mean(x0)
  }
  stopifnot(lo <= up + 1e-12)
  c(lower = lo, upper = up, untrimmed = mean(x1) - mean(x0),
    rate_high = p1, rate_low = p0, trim_fraction = 1 - keep)
}

attrition <- missing <- stages <- selection <- audits <- lee <- list()
point_heck <- point_ipw <- list()
lee_data <- list()
for (y in outcomes) {
  d <- prepare(g, y)
  dp <- d[d$post == 1L, ]
  for (dt in dates) for (group in c("all", as.character(0:3))) {
    a <- d[d$date == dt & (group == "all" | d$dose_group == group), ]
    attrition[[length(attrition) + 1L]] <- data.frame(outcome = y, date = dt,
      dose_group = group, firms = nrow(a), observed = sum(a$s), missing = sum(1L - a$s),
      observation_rate = mean(a$s))
  }
  for (id in f$firm_id[!is.finite(f[[paste0("pre_", y)]])]) {
    a <- d[d$firm_id == id, ]
    missing[[length(missing) + 1L]] <- data.frame(outcome = y, firm_id = id,
      pre_observed = sum(a$s[a$date <= "2019-12-31"]), post_observed = sum(a$s[a$post == 1L]))
  }
  h <- heckman_fit(d, y)
  point_heck[[y]] <- h
  z <- cluster_z(h$first$model, dp)
  probs <- fitted(h$first$model)
  weak <- !is.finite(z["z"]) || 2 * pnorm(-abs(z["z"])) >= .10 ||
    any(probs <= .Machine$double.eps | probs >= 1 - .Machine$double.eps)
  stages[[y]] <- data.frame(outcome = y, risk_rows = nrow(dp), risk_firms = nrow(f),
    missing_pre_mean_firms = sum(!is.finite(f[[paste0("pre_", y)]])),
    missing_predictor_rows = sum(dp$pre_mean_missing),
    observed_post_rows_missing_pre_mean = sum(dp$s * dp$pre_mean_missing),
    n_Z_below_one = sum(f$Z < 1), converged = h$first$model$converged,
    Z_coefficient = z["coefficient"], Z_cluster_se = z["se"], Z_z = z["z"],
    Z_p = 2 * pnorm(-abs(z["z"])), min_fitted = min(probs), max_fitted = max(probs),
    weak_exclusion = weak,
    label = if (weak) "identified mainly by functional form (weak exclusion restriction)" else "exclusion unverified",
    warnings = h$first$warnings)
  ip <- ipw_fit(d, y)
  pp <- ip$probability
  limits <- ip$limits
  weighted_d <- ip$data
  im <- ip$second
  point_ipw[[y]] <- im
  # Neither selection method is allowed to change a second-stage observation.
  bm <- main_model(p, y)
  used_key <- function(data, m) paste(data$firm_id[fixest::obs(m)], data$date[fixest::obs(m)])
  stopifnot(setequal(used_key(p, bm), used_key(d, h$second)),
            setequal(used_key(p, bm), used_key(weighted_d, im)))
  balanced_d <- p[p$firm_id %in% f$firm_id[f$balanced], ]
  sm <- main_model(balanced_d, y)
  # S6 matches the existing definition: a source row at all 13 dates, with
  # available-case outcomes. It need not be balanced for every individual item.
  for (method in c("baseline", "Heckman", "IPW", "S6")) {
    m <- switch(method, baseline = bm, Heckman = h$second, IPW = im, S6 = sm)
    b0 <- checks$coefficient[checks$outcome == y]
    se0 <- checks$std_error[checks$outcome == y]
    used <- if (method == "S6") balanced_d[fixest::obs(m), ] else if (method == "baseline")
      p[fixest::obs(m), ] else d[fixest::obs(m), ]
    selection[[length(selection) + 1L]] <- data.frame(outcome = y, method = method,
      coefficient = unname(coef(m)["dose_pre:post"]),
      std_error = if (method %in% c("Heckman", "IPW")) NA_real_ else unname(fixest::se(m)["dose_pre:post"]),
      clustered_std_error = if (method == "Heckman") NA_real_ else unname(fixest::se(m)["dose_pre:post"]),
      ci_lower = if (method %in% c("Heckman", "IPW")) NA_real_ else confint(m)["dose_pre:post", 1],
      ci_upper = if (method %in% c("Heckman", "IPW")) NA_real_ else confint(m)["dose_pre:post", 2],
      se_method = if (method %in% c("Heckman", "IPW")) "whole-firm bootstrap, both stages" else "firm clustered",
      N = nobs(m), n_firms = length(unique(used$firm_id)),
      shift_in_baseline_se = (unname(coef(m)["dose_pre:post"]) - b0) / se0,
      bootstrap_draws = if (method %in% c("Heckman", "IPW")) B else 0L,
      bootstrap_valid = if (method %in% c("Heckman", "IPW")) NA_integer_ else 0L,
      bootstrap_failed = if (method %in% c("Heckman", "IPW")) NA_integer_ else 0L,
      inference_status = if (method %in% c("Heckman", "IPW")) "pending" else "cluster t intervals",
      lambda_coefficient = if (method == "Heckman") unname(coef(m)["lambda"]) else NA_real_)
  }
  post_n <- vapply(ids, function(id) sum(d$s[d$firm_id == id & d$post == 1L]), integer(1))
  pre_n <- vapply(ids, function(id) sum(d$s[d$firm_id == id & d$date <= "2019-12-31"]), integer(1))
  post_mean <- vapply(ids, function(id) mean(d[[y]][d$firm_id == id & d$post == 1L], na.rm = TRUE), numeric(1))
  ld <- data.frame(firm_id = ids, dose_pre = f$dose_pre[match(ids, f$firm_id)],
    pre_mean = f[[paste0("pre_", y)]][match(ids, f$firm_id)], post_mean = post_mean,
    n_pre = pre_n, n_post = post_n)
  ld$change <- ld$post_mean - ld$pre_mean
  ld$lee_group <- ifelse(ld$dose_pre >= 2, "high", ifelse(ld$dose_pre < 1, "low", "middle"))
  lee_data[[y]] <- ld
  l <- lee_fit(ld)
  lee[[y]] <- data.frame(outcome = y, lower = l["lower"], upper = l["upper"],
    untrimmed = l["untrimmed"], rate_high = l["rate_high"], rate_low = l["rate_low"],
    trimmed_group = if (l["rate_high"] <= l["rate_low"]) "low" else "high",
    trim_fraction = l["trim_fraction"], high_risk = sum(ld$lee_group == "high" & is.finite(ld$pre_mean)),
    low_risk = sum(ld$lee_group == "low" & is.finite(ld$pre_mean)),
    high_observed = sum(ld$lee_group == "high" & is.finite(ld$change)),
    low_observed = sum(ld$lee_group == "low" & is.finite(ld$change)),
    excluded_no_pre_high = sum(ld$lee_group == "high" & !is.finite(ld$pre_mean)),
    excluded_no_pre_low = sum(ld$lee_group == "low" & !is.finite(ld$pre_mean)),
    excluded_middle = sum(ld$lee_group == "middle"))
  # Full-risk-set firm-date audit: imputation, fitted probabilities, correction
  # and weights can be reconstructed without accessing an R model object.
  audit <- d[c("firm_id", "date", "dose_pre", "market", "post", "s", "Z",
               "pre_y", "pre_mean_missing", "pre_log_ta", "reported_2020h1")]
  audit$outcome <- y
  audit$lambda <- h$data$lambda
  audit$probit_probability <- audit$logit_probability <- NA_real_
  audit$probit_probability[d$post == 1L] <- probs
  audit$logit_probability[d$post == 1L] <- pp
  audit$weight <- weighted_d$ipw
  audit$ipw_lower <- limits[1]; audit$ipw_upper <- limits[2]
  audit$ipw_logit_converged <- ip$first$model$converged
  audit$ipw_logit_warnings <- ip$first$warnings
  audit$second_stage_used <- paste(d$firm_id, d$date) %in% used_key(p, bm)
  audits[[y]] <- audit
  cat(sprintf("T025 point estimates complete: %s; probit converged; Z z=%.6f; IPW N=%d.\n", y, z["z"], nobs(im)))
}
write_out(do.call(rbind, attrition), "attrition")
write_out(do.call(rbind, missing), "missing_predictors")
write_out(do.call(rbind, stages), "first_stage_diagnostics")
write_out(do.call(rbind, audits), "selection_audit")

# Shared nonparametric whole-firm draws across all outcomes and Lee bounds.
# Copy all 13 risk rows, preserving within-firm dependence and predictors.
# Replicated firms receive distinct fixed-effect IDs; no row bootstrap is used.
set.seed(20261016)
draws <- replicate(B, sample.int(length(ids), length(ids), replace = TRUE))
by_firm <- lapply(ids, function(id) which(g$firm_id == id))
boot <- vector("list", B * length(outcomes))
for (b in seq_len(B)) {
  ii <- draws[, b]
  gd <- g[unlist(by_firm[ii], use.names = FALSE), ]
  gd$firm_id <- rep(paste0("draw_", seq_along(ii)), each = length(dates))
  for (j in seq_along(outcomes)) {
    y <- outcomes[j]
    dd <- prepare(gd, y)
    hb <- heckman_fit(dd, y, bootstrap = TRUE)
    bh <- if (hb$valid) unname(coef(hb$second)["dose_pre:post"]) else NA_real_
    if (hb$valid) stopifnot(is.finite(bh))
    # Neither IPW nor Lee is conditional on a successful Heckman fit.
    ib <- ipw_fit(dd, y)
    bi <- unname(coef(ib$second)["dose_pre:post"])
    stopifnot(is.finite(bi))
    lb <- lee_fit(lee_data[[y]][ii, ])
    boot[[(b - 1L) * length(outcomes) + j]] <- data.frame(draw = b, outcome = y,
      heckman_coefficient = bh, heckman_valid = hb$valid,
      heckman_failure_reason = hb$reason, probit_converged = hb$converged,
      probit_warnings = hb$warnings, ipw_coefficient = bi,
      ipw_logit_converged = ib$first$model$converged,
      ipw_logit_warnings = ib$first$warnings,
      lee_lower = lb["lower"], lee_upper = lb["upper"],
      lee_rate_high = lb["rate_high"], lee_rate_low = lb["rate_low"],
      lee_trimmed_group = if (is.finite(lb["rate_high"]) && is.finite(lb["rate_low"]))
        if (lb["rate_high"] <= lb["rate_low"]) "low" else "high" else "undefined")
  }
  if (b %% 50L == 0L || b == B) {
    cat(sprintf("T025 whole-firm bootstrap: %d/%d draws.\n", b, B)); flush.console()
  }
}
boot <- do.call(rbind, boot)
sel <- do.call(rbind, selection)
lb <- do.call(rbind, lee)
for (y in outcomes) {
  a <- boot[boot$outcome == y, ]
  for (method in c("Heckman", "IPW")) {
    values <- a[[if (method == "Heckman") "heckman_coefficient" else "ipw_coefficient"]]
    ok <- is.finite(values)
    row <- sel$outcome == y & sel$method == method
    sel$bootstrap_valid[row] <- sum(ok)
    sel$bootstrap_failed[row] <- sum(!ok)
    unstable <- method == "Heckman" && mean(!ok) > .10
    sel$inference_status[row] <- if (unstable) "bootstrap unstable (separation)" else
      "bootstrap SE and percentile intervals; failed draws excluded without replacement"
    if (!unstable) {
      stopifnot(sum(ok) > 1L)
      sel$std_error[row] <- sd(values[ok])
      ci <- quantile(values[ok], c(.025, .975), type = 7, names = FALSE)
      sel$ci_lower[row] <- ci[1]; sel$ci_upper[row] <- ci[2]
    }
  }
  row <- lb$outcome == y
  for (end in c("lower", "upper")) {
    v <- a[[paste0("lee_", end)]]
    v <- v[is.finite(v)]
    ci <- if (length(v) > 1L) quantile(v, c(.025, .975), type = 7, names = FALSE) else c(NA, NA)
    lb[[paste0(end, "_ci_lower")]][row] <- ci[1]
    lb[[paste0(end, "_ci_upper")]][row] <- ci[2]
  }
  lb$bootstrap_draws[row] <- B
  lb$valid_draws[row] <- sum(is.finite(a$lee_lower) & is.finite(a$lee_upper))
  lb$direction_switch_draws[row] <- sum(a$lee_trimmed_group != lb$trimmed_group[row])
}
lb$ci_status <- ifelse(lb$valid_draws >= ceiling(.9 * B), "percentile endpoint intervals",
                       "conditional intervals: fewer than 90 percent valid draws")
# The outer endpoints are a bootstrap uncertainty envelope, not an exact joint
# confidence set for the partially identified parameter.
lb$outer_ci_lower <- lb$lower_ci_lower
lb$outer_ci_upper <- lb$upper_ci_upper
stopifnot(nrow(sel) == 20L, nrow(lb) == 5L, nrow(boot) == B * 5L,
          all(is.finite(sel$coefficient)),
          all(is.finite(sel$std_error) | sel$inference_status == "bootstrap unstable (separation)"),
          all(sel$bootstrap_valid + sel$bootstrap_failed == sel$bootstrap_draws),
          all(sel$bootstrap_valid[sel$method == "IPW"] == B),
          all(boot$ipw_logit_converged),
          all(boot$heckman_valid == is.finite(boot$heckman_coefficient)))
write_out(sel, "selection")
write_out(lb, "lee_bounds")
write_out(boot, "bootstrap_draws")
# Firm-level changes and eligibility audit, including missing pre means (never
# imputed for Lee changes or for the second-stage outcomes).
write_out(do.call(rbind, lapply(outcomes, function(y) cbind(outcome = y, lee_data[[y]]))), "lee_audit")

# Plain text notes: escape all LaTeX special characters in data labels and notes.
esc <- function(x) {
  x <- gsub("_", "\\_", x, fixed = TRUE)
  x <- gsub("%", "\\%", x, fixed = TRUE)
  x <- gsub("&", "\\&", x, fixed = TRUE)
  x <- gsub("#", "\\#", x, fixed = TRUE)
  x
}
fmt <- function(x) ifelse(is.finite(x), sprintf("%.6f", x), "--")
notes <- c(
  "Primary attrition checks are IPW and Lee bounds; Heckman is an instructor-suggested complement.",
  "Dose is mean breaches over 2017H1--2019H2. All DiD models use firm and date fixed effects and require parallel trends absent the policy.",
  "Baseline reproduces T009 within 1e-12. Heckman and IPW retain exactly the baseline outcome observations, including FE singleton removal.",
  "S6 restricts to firms with a financial source row on all 13 dates; outcome-specific missing items remain excluded.",
  "Selection risk set: 124 main-sample firms with defined dose, each at all 13 dates; selection means the outcome is observed.",
  "Only the five post dates (2020H2--2022H2) enter the pooled probit and logit. Pre characteristics use 2016H2--2019H2 only.",
  "Missing pre-outcome means are set to zero with an outcome-specific missing indicator in both selection models. Outcomes are never imputed.",
  "Two firms for minority share and 22 for JV/TA lack pre means, affecting respectively two and two observed post rows. Other outcomes have none.",
  "Probit controls: dose, pre-outcome mean, pre-log-assets mean, market, date dummies, reporting frequency Z and the missing indicator when relevant.",
  "Z is the share of the seven pre dates with nonmissing total assets; only seven firms have Z below one. Nonmissing assets proxy balance-sheet filing.",
  "The exclusion requires pre reporting frequency to affect post observation but not conditional outcome innovations. Reporting frequency may proxy governance, distress or reporting quality, so this restriction is weak.",
  "Heckman is identified mainly by functional form (weak exclusion restriction). Z is negative and not significant; no substantive interpretation is attached to its sign.",
  "A single inverse Mills ratio enters the outcome model; it equals zero on every non-post row, including 2020H1. Numerical fitted probabilities of zero or one do not stop estimation.",
  "Heckman and IPW SEs and percentile intervals use 499 whole-firm bootstrap draws of both stages, seed 20261016. Baseline and S6 use firm-clustered SEs and cluster-t intervals. IPW firm-clustered SEs conditional on fitted weights are separately recorded in the CSV.",
  "A Heckman draw fails if its pooled probit does not converge or a present missing-indicator group has no observed post row. Failed draws are counted per outcome, excluded only from that outcome and never replaced. Above 10 percent failures, Heckman SE and CI are suppressed as bootstrap unstable (separation). IPW and Lee run on all 499 draws independently of Heckman failures.",
  "Lambda is a nonlinear function of firm-constant regressors including dose, and is close to collinear with dose by post after fixed effects. Heckman shifts indicate fragility, not evidence of attrition bias.",
  "IPW logit uses dose, pre-outcome mean, pre-log-assets mean, market and the missing indicator, plus reporting at 2020H1 in place of unavailable dated listing status. This last pre-announcement indicator is defined by nonmissing assets; present listing status is not used.",
  "IPW uses inverse fitted post observation probabilities, clipped at type-7 1st and 99th percentiles among observed post rows. IPW reweights rows within firms: pre rows have weight one and observed post rows have truncated inverse-probability weights.",
  "IPW requires observation to be independent of outcome innovations conditional on these pre characteristics and positive observation probabilities. Neither IPW nor Heckman removes unobserved selection without its assumptions.",
  "Outcome missingness mixes firm attrition, missing items and invalid equity denominators. JV/TA in particular includes firms that never report the item. Cross-market log assets retain unresolved reporting-currency differences.")
st <- do.call(rbind, stages)
row_end <- " \\\\"
lines <- c("\\begin{table}[htbp]", "\\centering\\small", "\\caption{Attrition checks for the dose by post estimates}",
  "\\label{tab:selection}", "\\begin{tabular}{lrrrr}", "\\toprule",
  paste0("Outcome & Baseline & Heckman & IPW & S6", row_end), "\\midrule")
for (y in outcomes) {
  a <- sel[sel$outcome == y, ]
  a <- a[match(c("baseline", "Heckman", "IPW", "S6"), a$method), ]
  counts <- ifelse(a$bootstrap_draws > 0, paste0(a$bootstrap_valid, "/", a$bootstrap_failed), "--")
  lines <- c(lines, paste0(esc(y), " & ", paste(fmt(a$coefficient), collapse = " & "), row_end),
    paste0("SE & ", paste(ifelse(is.finite(a$std_error), paste0("(", fmt(a$std_error), ")"), "--"), collapse = " & "), row_end),
    paste0("95 percent CI low & ", paste(fmt(a$ci_lower), collapse = " & "), row_end),
    paste0("95 percent CI high & ", paste(fmt(a$ci_upper), collapse = " & "), row_end),
    paste0("N / Firms & ", paste(paste0(a$N, "/", a$n_firms), collapse = " & "), row_end),
    paste0("Draws valid / failed & ", paste(counts, collapse = " & "), row_end))
}
lines <- c(lines, "\\midrule", paste0("\\multicolumn{5}{l}{Pooled probit exclusion diagnostic}", row_end),
  paste0("Outcome & Z coefficient & Cluster SE & z & p", row_end))
for (j in seq_len(nrow(st))) lines <- c(lines, paste0(esc(st$outcome[j]), " & ",
  paste(fmt(as.numeric(st[j, c("Z_coefficient", "Z_cluster_se", "Z_z", "Z_p")])), collapse = " & "), row_end))
# Long notes follow the float so the tabular and notes can occupy separate pages.
lines <- c(lines, "\\bottomrule", "\\end{tabular}", "\\end{table}", "\\par\\smallskip",
  "\\noindent\\begin{minipage}{\\linewidth}\\footnotesize", esc(paste(notes, collapse = " ")),
  "\\end{minipage}")
write_note(lines, "selection.tex")
lee_notes <- c(
  "Lee bounds are a primary sensitivity check, separate from the continuous-dose DiD estimates. High dose means at least two; low dose means less than one. Intermediate-dose firms are excluded only from this binary comparison.",
  "Change is the available post mean (2020H2--2022H2) minus the available pre mean (2016H2--2019H2); 2020H1 is excluded. Unequal reporting horizons remain.",
  "The risk population comprises firms in these dose bins with at least one pre outcome. A firm is selected if it has at least one post outcome. Firms lacking pre means are disclosed in the CSV, with no imputation.",
  "The group with the higher observation rate is trimmed at each tail to match the lower rate; fractional boundary mass is retained exactly. The trimmed group for each outcome is reported in the CSV.",
  "Causal Lee bounds require monotone individual selection in the stated direction and an exogenous binary contrast (or a defensible parallel-trends assumption for these changes). Nonrandom dose, missing items and invalid equity denominators make these assumptions substantive and unverified; the reported intervals are sensitivity bounds, not established causal effects.",
  "Bounds describe high-minus-low changes among always-observed firms under those assumptions; they are not per-unit-dose effects and cannot be compared numerically to the main coefficient.",
  "There are 499 shared whole-firm resamples, seed 20261016. CSV reports 95 percent percentile intervals for each endpoint, valid draws and trimming-direction changes. The displayed outer envelope uses the lower endpoint's 2.5th and upper endpoint's 97.5th percentile; it is not an exact joint confidence set.")
lee_lines <- c("\\begin{table}[htbp]", "\\centering", "\\caption{Lee sensitivity bounds: high versus low pre-policy dose}",
  "\\label{tab:lee_bounds}", "\\begin{tabular}{lrrrr}", "\\toprule",
  paste0("Outcome & Lower & Upper & Envelope low & Envelope high", row_end), "\\midrule")
for (j in seq_len(nrow(lb))) lee_lines <- c(lee_lines, paste0(esc(lb$outcome[j]), " & ",
  paste(fmt(as.numeric(lb[j, c("lower", "upper", "outer_ci_lower", "outer_ci_upper")])), collapse = " & "), " \\\\"))
lee_lines <- c(lee_lines, "\\midrule", paste0("Outcome & High risk & Low risk & High rate & Low rate", row_end))
for (j in seq_len(nrow(lb))) lee_lines <- c(lee_lines, paste0(esc(lb$outcome[j]), " & ",
  lb$high_risk[j], " & ", lb$low_risk[j], " & ", fmt(lb$rate_high[j]), " & ", fmt(lb$rate_low[j]), " \\\\"))
lee_lines <- c(lee_lines, "\\bottomrule", "\\end{tabular}", "\\end{table}", "\\par\\smallskip",
  "\\noindent\\begin{minipage}{\\linewidth}\\footnotesize", esc(paste(lee_notes, collapse = " ")),
  "\\end{minipage}")
write_note(lee_lines, "lee_bounds.tex")
# Remove superseded stop/partial artifacts only after the completed outputs exist.
stale <- c("bootstrap_partial.csv", "point_estimates_incomplete.csv", "lee_points_incomplete.csv",
           "failed_probit.csv", "failed_probit_risk.csv", "input_stop.txt", "stop_diagnostics.txt")
unlink(paste0("outputs/tables/t025_", stale))
stopifnot(identical(input_hash, tools::sha256sum(inputs)),
          identical(protected_hash, tools::sha256sum(protected)))
cat("\nT025 comparison (coefficient, SE, shift divided by baseline SE):\n")
print(sel[c("outcome", "method", "coefficient", "std_error", "shift_in_baseline_se")], row.names = FALSE)
cat("T025 Lee bounds (binary high-minus-low changes):\n")
print(lb[c("outcome", "lower", "upper", "outer_ci_lower", "outer_ci_upper", "valid_draws")], row.names = FALSE)
cat("T025 bootstrap counts (failed Heckman draws never replaced):\n")
print(sel[sel$method %in% c("Heckman", "IPW"),
          c("outcome", "method", "bootstrap_valid", "bootstrap_failed", "inference_status")], row.names = FALSE)
cat(sprintf("T025 completed: 5 outcomes; 499 seeded whole-firm draws; failed Heckman draws counted; %d existing outputs unchanged.\n", length(protected)))
