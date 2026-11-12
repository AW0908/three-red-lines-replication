# T031: robustness of descriptive Q1 targeting evidence; run from replication/.
# No causal interpretation: smooth counterfactual density and reporting selection
# remain assumptions. No data downloads or changes to the panel or T023 code.
source("code/00_setup.R", local = TRUE)
suppressPackageStartupMessages(library(ggplot2))
options(digits = 17)
seed <- 20261016L
B <- 999L
inputs <- c("data/processed/panel_firm_halfyear.csv", "code/06_bunching_tests.R",
            list.files("outputs/tables", "^t023_", full.names = TRUE),
            "../state/STATE.md", "../state/LIMITATIONS.md")
input_hash <- tools::sha256sum(inputs)
protected <- list.files("outputs", recursive = TRUE, full.names = TRUE)
protected <- protected[!dir.exists(protected) & !grepl("^t031_", basename(protected))]
protected_hash <- tools::sha256sum(protected)
d <- read.csv(inputs[1], stringsAsFactors = FALSE, na.strings = c("", "NA"))
d <- d[!is.na(d$sample_main) & d$sample_main, ]
d$date <- as.Date(d$date)
d <- d[order(d$firm_id, d$date), ]
rownames(d) <- NULL
stopifnot(!anyDuplicated(d[c("firm_id", "date")]), length(unique(d$date)) == 13L)
d$halfyear <- as.integer(format(d$date, "%Y")) * 2L +
  as.integer(format(d$date, "%m") == "12")
pre <- d$date >= as.Date("2017-06-30") & d$date <= as.Date("2019-12-31")
post <- d$date >= as.Date("2020-12-31") & d$date <= as.Date("2022-12-31")
firms <- sort(unique(d$firm_id))
inside <- function(x, lo, hi) is.finite(x) & x >= lo & x < hi
make_weights <- function(ids) {
  # Reset to the T023 seed for each prespecified firm universe. Whole histories
  # are resampled, with fixed sample-specific G; periods share the same draws.
  set.seed(seed)
  replicate(B, tabulate(sample.int(length(ids), length(ids), replace = TRUE),
                        nbins = length(ids)))
}
weights <- make_weights(firms)
summarize <- function(x) {
  good <- is.finite(x)
  c(se = if (sum(good) > 1L) sd(x[good]) else NA_real_,
    ci_low = if (any(good)) unname(quantile(x[good], .025, type = 7)) else NA_real_,
    ci_high = if (any(good)) unname(quantile(x[good], .975, type = 7)) else NA_real_,
    bootstrap_valid = sum(good), bootstrap_failed = sum(!good))
}
firm_counts <- function(use, ids, edges) {
  ix <- findInterval(d$rl1, edges, rightmost.closed = TRUE)
  use <- use & d$firm_id %in% ids & is.finite(d$rl1)
  in_range <- use & !is.na(ix) & ix > 0L & ix < length(edges)
  z <- matrix(0, nrow(d), length(edges) - 1L)
  z[cbind(which(in_range), ix[in_range])] <- 1
  a <- rowsum(z, match(d$firm_id, firms), reorder = FALSE)
  all <- matrix(0, length(firms), ncol(z))
  all[as.integer(rownames(a)), ] <- a
  list(counts = all[match(ids, firms), , drop = FALSE], n = sum(use),
       n_in_range = sum(in_range), n_outside = sum(use & !in_range),
       firms_observed = length(unique(d$firm_id[use])))
}
mass_fit <- function(use, ids = firms, w = weights, width = .01, lower = .66,
                     upper = .70, degree = 5L, fit_lower = .40, fit_upper = 1) {
  edges <- round(seq(fit_lower, fit_upper, width), 10)
  mid <- (head(edges, -1L) + tail(edges, -1L))/2
  # T023 assigns exclusion and mass by bin midpoint. For nominal bounds not
  # aligned to a 0.02 grid, publish the realized edges rather than conceal them.
  excluded <- mid >= lower - 1e-12 & mid < upper - 1e-12
  mass <- excluded & mid < .70 - 1e-12
  stopifnot(any(mass), all(diff(edges) > 0), all(mid[mass] < .70))
  counts <- firm_counts(use, ids, edges)
  y <- colSums(counts$counts)
  y_boot <- t(counts$counts) %*% w
  X <- cbind(1, poly(mid, degree = degree))
  q <- qr(X[!excluded, , drop = FALSE])
  stopifnot(q$rank == ncol(X))
  fitted <- drop(X %*% qr.coef(q, y[!excluded]))
  # Linear least squares on a fixed basis: all bootstrap coefficients and
  # counterfactuals are re-estimated jointly, not held at their point values.
  fitted_boot <- X %*% qr.coef(q, y_boot[!excluded, , drop = FALSE])
  valid <- all(is.finite(fitted[mass]) & fitted[mass] > 0)
  cf <- sum(fitted[mass]); obs <- sum(y[mass])
  b <- if (valid) (obs - cf)/mean(fitted[mass]) else NA_real_
  cf_boot <- colSums(fitted_boot[mass, , drop = FALSE])
  good <- colSums(!is.finite(fitted_boot[mass, , drop = FALSE]) |
                    fitted_boot[mass, , drop = FALSE] <= 0) == 0L
  draws <- ifelse(good, (colSums(y_boot[mass, , drop = FALSE]) - cf_boot)/
                   (cf_boot/sum(mass)), NA_real_)
  s <- summarize(draws)
  if (!valid) s[c("se", "ci_low", "ci_high")] <- NA_real_
  status <- if (!valid) "invalid_counterfactual" else
    if (s["bootstrap_valid"]/B < .9) "unreliable_bootstrap_below_90pct" else
      if (s["bootstrap_failed"] > 0) "conditional_bootstrap" else "all_draws_valid"
  row <- data.frame(b = b, as.list(s), bootstrap_draws = B,
    valid_counterfactual = valid, bootstrap_meets_90pct = s["bootstrap_valid"]/B >= .9,
    inference_status = status, ci_excludes_zero = is.finite(s["ci_low"]) &&
      (s["ci_low"] > 0 || s["ci_high"] < 0),
    positive_supported = valid && s["bootstrap_valid"]/B >= .9 && is.finite(s["ci_low"]) &&
      s["ci_low"] > 0, n = counts$n, firms = counts$firms_observed,
    bootstrap_universe_firms = length(ids), n_in_range = counts$n_in_range,
    n_outside = counts$n_outside, observed_window = obs, counterfactual_window = cf,
    window_bins = sum(mass), negative_fitted_bins = sum(fitted < 0),
    actual_mass_lower = min(head(edges, -1L)[mass]),
    actual_mass_upper = max(tail(edges, -1L)[mass]),
    actual_exclusion_lower = min(head(edges, -1L)[excluded]),
    actual_exclusion_upper = max(tail(edges, -1L)[excluded]),
    excess_fraction = if (valid) (obs - cf)/cf else NA_real_,
    b_in_001_bins = b * width/.01, row.names = NULL)
  list(row = row, draws = draws)
}

# Mandatory first gate: no T031 output is published if T023 is not reproduced.
reference <- read.csv("outputs/tables/t023_excess_mass.csv", na.strings = "--")
ref <- reference[reference$ratio == "rl1" & reference$sample_rule == "main_sample" &
                   reference$threshold == .7 & reference$specification == "main", ]
baseline <- lapply(list(pre, post), mass_fit)
baseline_rows <- do.call(rbind, lapply(seq_along(baseline), function(i)
  cbind(period = c("pre", "post")[i], baseline[[i]]$row)))
for (p in c("pre", "post")) {
  a <- baseline_rows[baseline_rows$period == p, ]
  b <- ref[ref$period == p, ]
  fields <- c("b", "se", "ci_low", "ci_high", "bootstrap_valid", "n", "firms")
  if (nrow(b) != 1L || any(abs(unlist(a[fields]) - unlist(b[fields])) > 1e-10))
    stop("STOP T031: T023 estimate or inference not reproduced: ", p)
}
if (round(baseline[[2]]$row$b, 2) != 3.14)
  stop("STOP T031: main estimate does not round to b_post = 3.14.")
cat(sprintf("T031: T023 assertion PASS: b_post = %.12f, CI [%.12f, %.12f].\n",
            baseline_rows$b[2], baseline_rows$ci_low[2], baseline_rows$ci_high[2]))

# Stage outputs until all computations and read-only guards pass.
staged <- list()
stage <- function(f, target) {
  stopifnot(grepl("^t031_", basename(target)))
  staged[[length(staged) + 1L]] <<- c(path = f, target = target)
}
csv <- function(x, name) {
  f <- tempfile(fileext = ".csv")
  mtpa_write_csv(x, f, row.names = FALSE, na = "NA")
  stage(f, paste0("outputs/tables/t031_", name, ".csv"))
}
fmt <- function(x) ifelse(is.finite(x), formatC(x, digits = 3, format = "f"), "--")
ci <- function(lo, hi) paste0("[", fmt(lo), ", ", fmt(hi), "]")
texrow <- function(x) paste0(paste(x, collapse = " & "), " \\\\")
tex <- function(name, header, rows, note, align) {
  f <- tempfile(fileext = ".tex")
  mtpa_write_lines(c("\\begin{threeparttable}", paste0("\\begin{tabular}{", align, "}"),
    "\\toprule", texrow(header), "\\midrule", rows, "\\bottomrule", "\\end{tabular}",
    "\\begin{tablenotes}[flushleft]", "\\footnotesize", paste0("\\item ", note),
    "\\end{tablenotes}", "\\end{threeparttable}"), f)
  stage(f, paste0("outputs/tables/t031_", name, ".tex"))
}
pdf_plot <- function(p, name, width, height) {
  f <- tempfile(fileext = ".pdf")
  grDevices::pdf(f, width = width, height = height, useDingbats = FALSE,
                timestamp = FALSE, title = "T031 Q1 robustness")
  print(p); invisible(dev.off())
  stage(f, paste0("outputs/figures/t031_", name, ".pdf"))
}
csv(baseline_rows, "baseline")

# 1. Distinct firms, repeat contributions and two explicit entry definitions.
window <- inside(d$rl1, .66, .70)
pre_window_firms <- unique(d$firm_id[pre & window])
pre_observed_firms <- unique(d$firm_id[pre & is.finite(d$rl1)])
prev <- match(paste(d$firm_id, d$halfyear - 1L), paste(d$firm_id, d$halfyear))
entered <- window & !is.na(prev) & is.finite(d$rl1[prev]) & !window[prev]
support <- do.call(rbind, lapply(c("pre", "post"), function(p) {
  period <- if (p == "pre") pre else post
  ids <- d$firm_id[period & window]
  data.frame(period = p, lower = .66, upper = .70, firm_dates = length(ids),
    distinct_firms = length(unique(ids)),
    firms_not_in_pre_window = if (p == "post") length(setdiff(unique(ids), pre_window_firms)) else NA_integer_,
    entrants_without_pre_rl1 = if (p == "post") length(setdiff(unique(ids), pre_observed_firms)) else NA_integer_,
    distinct_adjacent_entrants = length(unique(d$firm_id[period & entered])),
    max_firm_dates_per_firm = max(c(0L, table(ids))))
}))
csv(support, "support")

# 2. Leave one firm out. Eligibility uses all 13 dates and closed [0.60,0.80].
loo_ids <- sort(unique(d$firm_id[is.finite(d$rl1) & d$rl1 >= .60 & d$rl1 <= .80]))
loo <- do.call(rbind, lapply(loo_ids, function(id) {
  ids <- setdiff(firms, id)
  r <- mass_fit(post, ids, make_weights(ids))$row
  cbind(firm_id = id, r, delta_b = r$b - baseline_rows$b[2])
}))
loo$influence_rank <- rank(-abs(loo$delta_b), ties.method = "first")
loo$top_five <- loo$influence_rank <= 5L
csv(loo, "leave_one_out")
cat(sprintf("T031: leave-one-out completed for %d firms.\n", nrow(loo)))

# 3. Frozen sample restrictions, applied to entire firm histories.
n_all <- vapply(firms, function(id) sum(d$firm_id == id & is.finite(d$rl1)), integer(1))
n_pre <- vapply(firms, function(id) sum(d$firm_id == id & pre & is.finite(d$rl1)), integer(1))
n_post <- vapply(firms, function(id) sum(d$firm_id == id & post & is.finite(d$rl1)), integer(1))
sample_ids <- list(A_all = firms, B_balanced13 = firms[n_all == 13L],
                   C_pre3_post3 = firms[n_pre >= 3L & n_post >= 3L])
sample_rows <- list()
for (s in names(sample_ids)) {
  ids <- sample_ids[[s]]; w <- make_weights(ids)
  for (p in c("pre", "post")) sample_rows[[length(sample_rows) + 1L]] <-
    cbind(sample = s, period = p, mass_fit(if (p == "pre") pre else post, ids, w)$row)
}
samples <- do.call(rbind, sample_rows)
csv(samples, "samples")
mass_note <- paste("Main sample; pre: 2017H1--2019H2; post: 2020H2--2022H2.",
  "T023 estimator: degree 5, 0.01 bins on [0.40,1.00], excluding [0.66,0.70).",
  "Excess mass b is measured in bins. Whole firms are resampled 999 times using seed 20261016;",
  "the counterfactual is refitted in every draw. Each restricted sample resamples its own fixed firm universe.",
  "Intervals are pointwise percentile intervals. Nonpositive fitted mass-bin counts invalidate a draw;",
  "intervals condition on valid draws, and fewer than 90 percent valid draws are unreliable.",
  "Smooth density and polynomial shape are assumed. This is descriptive evidence, not a causal policy effect.")
sample_tex <- vapply(names(sample_ids), function(s) {
  a <- samples[samples$sample == s & samples$period == "pre", ]
  b <- samples[samples$sample == s & samples$period == "post", ]
  texrow(c(switch(s, A_all = "A: All", B_balanced13 = "B: All 13 dates",
                 C_pre3_post3 = "C: At least 3 per period"), length(sample_ids[[s]]),
           fmt(a$b), ci(a$ci_low, a$ci_high), fmt(b$b), ci(b$ci_low, b$ci_high)))
}, character(1))
tex("samples", c("Sample", "Firms", "Pre b", "95\\% CI", "Post b", "95\\% CI"),
    sample_tex, paste(mass_note, "B requires observed RL1 at all 13 scheduled dates, 2016H2--2022H2; C requires at least three observed RL1 dates in each T023 period. See the CSV for cell counts and draw validity."), "lrrrrr")

# 4. Full Cartesian grid. Stable nesting: width, exclusion, degree, fitting range.
windows <- data.frame(lower = c(.67, .66, .65, .66), upper = c(.70, .70, .70, .72))
ranges <- data.frame(lower = c(.40, .50), upper = c(1, .90))
grid_rows <- list(); index <- 0L
for (bw in c(.005, .01, .02)) for (j in seq_len(nrow(windows)))
  for (degree in c(3L, 5L, 7L)) for (k in seq_len(nrow(ranges))) {
    index <- index + 1L
    r <- mass_fit(post, width = bw, lower = windows$lower[j], upper = windows$upper[j],
                  degree = degree, fit_lower = ranges$lower[k], fit_upper = ranges$upper[k])$row
    grid_rows[[index]] <- cbind(specification_index = index, bin_width = bw,
      exclusion_lower = windows$lower[j], exclusion_upper = windows$upper[j], degree = degree,
      fit_lower = ranges$lower[k], fit_upper = ranges$upper[k], baseline = bw == .01 &&
        j == 2L && degree == 5L && k == 1L, r)
}
grid <- do.call(rbind, grid_rows)
stopifnot(nrow(grid) == 72L, sum(grid$baseline) == 1L,
          abs(grid$b[grid$baseline] - baseline_rows$b[2]) < 1e-12)
grid$share_ci_excludes_zero_all_cells <- mean(grid$ci_excludes_zero)
grid$share_positive_supported_all_cells <- mean(grid$positive_supported)
csv(grid, "grid")
theme_q1 <- theme_minimal(base_size = 10) + theme(legend.position = "top",
  panel.grid.minor = element_blank(), plot.caption = element_text(size = 8, hjust = 0))
pg <- ggplot(grid, aes(specification_index, b)) + geom_hline(yintercept = 0, linetype = "dashed") +
  geom_linerange(aes(ymin = ci_low, ymax = ci_high), linewidth = .4, color = "#426987") +
  geom_point(aes(shape = baseline, color = baseline), size = 1.8) +
  scale_color_manual(values = c("FALSE" = "#426987", "TRUE" = "#BB4729"),
                     labels = c("Grid specification", "T023 baseline")) +
  scale_shape_manual(values = c("FALSE" = 16, "TRUE" = 18),
                     labels = c("Grid specification", "T023 baseline")) +
  facet_wrap(~bin_width, ncol = 1, scales = "free_x", labeller = label_both) +
  labs(title = "Q1: all 72 prespecified density specifications", x = "Specification index (prespecified order)",
       y = "Post excess mass b (units: bins of the panel's width)", color = NULL, shape = NULL,
       caption = paste("999 whole-firm bootstrap draws; pointwise 95% percentile intervals; no multiplicity adjustment.",
         "Order: bin width, exclusion window, degree, fitting range. Only the registered T023 baseline is marked.",
         "Windows use bin midpoints as in T023; realized edges and validity are reported in the CSV.",
         "Bin units change across panels; common 0.01-bin units and relative excess are also provided in the CSV.", sep = "\n")) + theme_q1
pdf_plot(pg, "grid", 9, 9)

# 5. Exact scheduled next-date reversal: no bridging and no extension data.
next_row <- match(paste(d$firm_id, d$halfyear + 1L), paste(d$firm_id, d$halfyear))
next_rl1 <- d$rl1[next_row]
distance <- .70 - d$rl1
origin <- inside(d$rl1, .60, .70)
eligible <- origin & is.finite(next_rl1)
y <- as.numeric(next_rl1 > .70)
rl1_bin <- findInterval(d$rl1, round(seq(.60, .70, .01), 10))
distance_bin <- 11L - rl1_bin
design <- function(dist, bin, post_indicator, model) {
  f <- if (model == "linear") cbind(intercept = 1, distance = dist) else
    outer(bin, 1:10, `==`) * 1
  cbind(f, f * post_indicator)
}
rev_fit <- function(post_mask, model) {
  use <- eligible & (pre | post_mask)
  X <- design(distance[use], distance_bin[use], as.numeric(post_mask[use]), model)
  yy <- y[use]; ids <- d$firm_id[use]
  fit <- lm.fit(X, yy)
  # Keep empty bins explicit. Estimability is checked for every prediction and
  # contrast; unavailable cells are NA, never extrapolated from a different bin.
  keep <- fit$qr$pivot[seq_len(fit$rank)]
  XX <- X[, keep, drop = FALSE]
  bread <- solve(crossprod(XX))
  scores <- rowsum(XX * as.numeric(fit$residuals), ids, reorder = FALSE)
  G <- length(unique(ids)); N <- length(yy); K <- fit$rank
  V <- G/(G - 1) * (N - 1)/(N - K) * bread %*% crossprod(scores) %*% bread
  coef <- fit$coefficients[keep]
  # X is full column rank except when a period/bin is unobserved. Projection
  # checks protect both contrasts and period predictions under rank deficiency.
  relation <- qr.coef(qr(XX), X)
  contrast <- function(L) {
    l <- L[keep]
    estimable <- max(abs(drop(l %*% relation) - L)) < 1e-9
    estimate <- se <- lo <- hi <- NA_real_
    if (estimable && G > 1 && N > K) {
      estimate <- sum(l * coef)
      se <- sqrt(max(0, drop(l %*% V %*% l)))
      lo <- estimate - qt(.975, G - 1) * se
      hi <- estimate + qt(.975, G - 1) * se
    }
    data.frame(estimate = estimate, se = se, ci_low = lo, ci_high = hi,
      estimable = estimable, ci_excludes_zero = is.finite(lo) && (lo > 0 || hi < 0),
      n = N, firms = G, rank = K, design_columns = ncol(X), df = G - 1L,
      n_pre = sum(pre[use]), n_post = sum(post_mask[use]),
      origins_pre = sum(origin & pre), origins_post = sum(origin & post_mask),
      missing_followup_pre = sum(origin & pre & !is.finite(next_rl1)),
      missing_followup_post = sum(origin & post_mask & !is.finite(next_rl1)))
  }
  predict_at <- function(dist, period) {
    bin <- pmin(10L, pmax(1L, ceiling(round(dist/.01, 10))))
    a <- drop(design(dist, bin, 0, model)); b <- drop(design(dist, bin, 1, model))
    L <- switch(period, pre = a, post = b, post_minus_pre = b - a)
    r <- contrast(L)
    in_bin <- eligible & distance_bin == bin
    cbind(model = model, distance = dist, period = period,
      distance_bin = bin, bin_n_pre = sum(in_bin & pre), bin_n_post = sum(in_bin & post_mask),
      bin_firms_pre = length(unique(d$firm_id[in_bin & pre])),
      bin_firms_post = length(unique(d$firm_id[in_bin & post_mask])), r)
  }
  predict_at
}
distances <- round(seq(.005, .095, .01), 10)
rev_rows <- list()
for (model in c("bins001", "linear")) {
  pred <- rev_fit(post, model)
  for (dist in distances) for (p in c("pre", "post", "post_minus_pre"))
    rev_rows[[length(rev_rows) + 1L]] <- pred(dist, p)
}
reversal <- do.call(rbind, rev_rows)
reversal$requested_distance <- reversal$distance %in% c(.005, .015, .025)
csv(reversal, "reversal_distance")
rev_note <- paste("Main-sample origins with RL1 in [0.60,0.70); outcome equals one if RL1 is strictly above 0.70 at the next scheduled half-year.",
  "Missing follow-up is excluded without bridging. Periods refer to origins; 2019H2 may lead to 2020H1, and 2022H2 is right-censored.",
  "The LPM includes a full interaction of post with distance: ten 0.01 RL1 bins, or an intercept and linear distance to 0.70.",
  "The nearest bin is [0.69,0.70), corresponding to distance (0,0.01]; requested distances are bin centers.",
  "SEs use the firm-clustered CR1 sandwich, G/(G-1) times (N-1)/(N-K), and t critical values with G-1 degrees of freedom.",
  "These LPM intervals are not bootstrap intervals. All intervals are pointwise without multiple-testing adjustment.",
  "Unobserved period-bin contrasts are not estimable. LPM predictions are not clipped to [0,1].",
  "Comparison at the same distance addresses distance composition only; reporting attrition, mean reversion and calendar effects remain.")
rr <- reversal[reversal$period == "post_minus_pre" & reversal$requested_distance, ]
tex("reversal_distance", c("Model", "Distance", "Post minus pre", "Cluster SE", "95\\% CI"),
  apply(rr, 1, function(z) texrow(c(z["model"], fmt(as.numeric(z["distance"])),
    fmt(as.numeric(z["estimate"])), fmt(as.numeric(z["se"])),
    ci(as.numeric(z["ci_low"]), as.numeric(z["ci_high"]))))), rev_note, "lrrrr")
plot_rev <- reversal[reversal$period %in% c("pre", "post"), ]
pr <- ggplot(plot_rev, aes(distance, estimate, color = period, fill = period)) +
  geom_ribbon(aes(ymin = ci_low, ymax = ci_high), alpha = .13, color = NA) +
  geom_line(linewidth = .7) + geom_point(size = 1.4) +
  facet_wrap(~model, ncol = 1) +
  scale_color_manual(values = c(pre = "#426987", post = "#BB4729")) +
  scale_fill_manual(values = c(pre = "#426987", post = "#BB4729")) +
  scale_x_continuous(breaks = distances, labels = function(x) sprintf("%.3f", x)) +
  scale_y_continuous(labels = function(x) sprintf("%.1f", x)) +
  labs(title = "Reversal probability at the same distance from RL1 = 0.70",
    x = "Distance below 0.70", y = "Predicted next-date reversal probability", color = NULL, fill = NULL,
    caption = paste("Pre: 2017H1-2019H2; post: 2020H2-2022H2. Origins require an observed next-date RL1.",
      "Pointwise 95% firm-cluster CR1 intervals; unbounded linear probability predictions.",
      "Bin centers shown; nearest RL1 bin [0.69,0.70) corresponds to distance (0,0.01].",
      "Selected transitions are descriptive; calendar timing and reporting selection remain possible explanations.", sep = "\n")) + theme_q1
pdf_plot(pr, "reversal_distance", 8, 8)

# 6. Timing: same pre period, three prespecified post-origin windows.
timing_masks <- list(i_2020H2_2022H2 = post,
  ii_2021H1_2022H2 = post & d$date >= as.Date("2021-06-30"),
  iii_2020H2_only = d$date == as.Date("2020-12-31"))
near_difference <- function(mask) {
  near <- inside(d$rl1, .68, .70)
  mean_boot <- function(period) {
    use <- near & eligible & period
    sums <- vapply(firms, function(id) sum(y[use & d$firm_id == id]), numeric(1))
    ns <- vapply(firms, function(id) sum(use & d$firm_id == id), integer(1))
    list(point = mean(y[use]), draws = drop(crossprod(sums, weights)/crossprod(ns, weights)),
         n = sum(use), firms = length(unique(d$firm_id[use])))
  }
  a <- mean_boot(pre); b <- mean_boot(mask)
  z <- summarize(b$draws - a$draws)
  c(estimate = b$point - a$point, z, n_pre = a$n, n_post = b$n,
    firms_pre = a$firms, firms_post = b$firms)
}
timing_rows <- list()
for (s in names(timing_masks)) {
  mask <- timing_masks[[s]]
  r <- mass_fit(mask)$row
  nb <- near_difference(mask)
  timing_rows[[length(timing_rows) + 1L]] <- data.frame(timing = s, statistic = "b_post",
    model = "T023", distance = NA_real_, estimate = r$b, se = r$se, ci_low = r$ci_low,
    ci_high = r$ci_high, n_pre = baseline_rows$n[1], n_post = r$n,
    firms_pre = baseline_rows$firms[1], firms_post = r$firms,
    bootstrap_draws = B, bootstrap_valid = r$bootstrap_valid,
    inference = r$inference_status, estimable = r$valid_counterfactual)
  timing_rows[[length(timing_rows) + 1L]] <- data.frame(timing = s,
    statistic = "reversal_post_minus_pre", model = "T023_near", distance = NA_real_,
    estimate = nb["estimate"], se = nb["se"], ci_low = nb["ci_low"], ci_high = nb["ci_high"],
    n_pre = nb["n_pre"], n_post = nb["n_post"], firms_pre = nb["firms_pre"],
    firms_post = nb["firms_post"], bootstrap_draws = B, bootstrap_valid = nb["bootstrap_valid"],
    inference = "percentile_firm_bootstrap", estimable = is.finite(nb["estimate"]), row.names = NULL)
  for (m in c("bins001", "linear")) {
    predict <- rev_fit(mask, m)
    for (dist in c(.005, .015, .025)) {
      z <- predict(dist, "post_minus_pre")
      timing_rows[[length(timing_rows) + 1L]] <- data.frame(timing = s,
        statistic = "reversal_post_minus_pre", model = m, distance = dist,
        estimate = z$estimate, se = z$se, ci_low = z$ci_low, ci_high = z$ci_high,
        n_pre = z$n_pre, n_post = z$n_post, firms_pre = z$bin_firms_pre,
        firms_post = z$bin_firms_post, bootstrap_draws = NA_integer_, bootstrap_valid = NA_integer_,
        inference = "firm_cluster_CR1_t", estimable = z$estimable)
    }
  }
}
timing <- do.call(rbind, timing_rows)
timing$ci_excludes_zero <- is.finite(timing$ci_low) & (timing$ci_low > 0 | timing$ci_high < 0)
csv(timing, "timing")
timing_tex <- vapply(seq_len(nrow(timing)), function(i) {
  z <- timing[i, ]
  texrow(c(match(z$timing, names(timing_masks)),
    if (z$statistic == "b_post") "Post b" else if (z$model == "T023_near") "Near reversal" else z$model,
    if (is.finite(z$distance)) fmt(z$distance) else "--", fmt(z$estimate), ci(z$ci_low, z$ci_high)))
}, character(1))
tex("timing", c("Window", "Statistic/model", "Distance", "Estimate", "95\\% CI"),
  timing_tex, paste("Windows: (1) 2020H2--2022H2; (2) 2021H1--2022H2, excluding announcement-period origins in 2020H2; (3) 2020H2 alone. Pre is always 2017H1--2019H2.",
    "Post b follows T023. Near reversal is post minus pre for origins in [0.68,0.70), using the T023 999-draw whole-firm percentile bootstrap.",
    "The other reversal rows compare the same exact distances using the fully interacted binned or linear LPM and firm-clustered CR1 t intervals.",
    "Timing defines origin dates; follow-up can be outside that origin window (2020H2 alone follows to 2021H1).",
    "Excluding 2020H2 origins does not censor pre-2020 follow-up. End-2022 origins have no next date in the main panel.",
    "Calendar composition differs: 2020H2 alone is a December snapshot, whereas the other windows pool June and December.",
    "The CSV reports estimability, coverage and inference type. Intervals are pointwise. No causal timing interpretation is identified."), "llrrr")

# Read-only and coverage assertions before publishing any staged outputs.
stopifnot(nrow(samples) == 6L, nrow(reversal) == 60L, nrow(timing) == 24L,
          nrow(loo) == length(loo_ids), all(diff(grid$specification_index) == 1L),
          identical(input_hash, tools::sha256sum(inputs)),
          identical(protected_hash, tools::sha256sum(protected)))
for (f in staged) stopifnot(file.copy(f[["path"]], f[["target"]], overwrite = TRUE))
unlink(vapply(staged, `[[`, character(1), "path"))
cat(sprintf("T031: support pre/post: %d/%d firm-dates; %d/%d distinct firms.\n",
            support$firm_dates[1], support$firm_dates[2], support$distinct_firms[1], support$distinct_firms[2]))
cat(sprintf("T031: LOO b_post range [%.6f, %.6f]; positive supported %d/%d.\n",
            min(loo$b), max(loo$b), sum(loo$positive_supported), nrow(loo)))
cat(sprintf("T031: grid CI excludes zero %d/72 (%.6f); positive supported %d/72.\n",
            sum(grid$ci_excludes_zero), mean(grid$ci_excludes_zero), sum(grid$positive_supported)))
cat(sprintf("T031: %d outputs; %d protected output hashes and %d input hashes unchanged.\n",
            length(staged), length(protected), length(inputs)))
