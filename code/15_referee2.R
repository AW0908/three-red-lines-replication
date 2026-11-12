# T043: pre-specified descriptive referee checks. Offline; run from replication/.
# No causal identification: smooth counterfactual density, reporting selection,
# empirical-error transportability and accounting comparability are assumptions.
source('code/00_setup.R', local = TRUE)
options(digits = 17)
seed <- 20261016L
B <- 999L
inputs <- c('data/processed/panel_firm_halfyear.csv',
 'code/00_setup.R', 'code/06_bunching_tests.R', 'code/11_mechanism.R',
 'code/13_rl1_validation.R', 'code/14_core_robustness.R',
 'outputs/tables/t023_excess_mass.csv', 'outputs/tables/t029_compliance.csv',
 'outputs/tables/t040_matched_observations.csv', 'outputs/tables/t040_validation.csv',
 'data/raw/manual/handcollect/nci_cashflow.csv', '../state/handcollect/pilot_purposive.csv',
 '../state/STATE.md')
stopifnot(all(file.exists(inputs)))
input_hash <- tools::sha256sum(inputs)
protected <- list.files('outputs', recursive = TRUE, full.names = TRUE, all.files = TRUE)
protected <- protected[!dir.exists(protected) & !grepl('^t043_', basename(protected))]
protected_hash <- tools::sha256sum(protected)
read <- function(p) read.csv(p, stringsAsFactors = FALSE, na.strings = c('', 'NA', '--'))
nf <- function(x) length(unique(x[!is.na(x)]))
d <- read(inputs[1]); d <- d[!is.na(d$sample_main) & d$sample_main, ]
d$date <- as.Date(d$date); d <- d[order(d$firm_id, d$date), ]; rownames(d) <- NULL
stopifnot(!anyDuplicated(d[c('firm_id', 'date')]))
pre <- d$date >= as.Date('2017-06-30') & d$date <= as.Date('2019-12-31')
post <- d$date >= as.Date('2020-12-31') & d$date <= as.Date('2022-12-31')
firms <- sort(unique(d$firm_id)); G <- length(firms)
make_weights <- function(ids) {
 set.seed(seed)
 replicate(B, tabulate(sample.int(length(ids), length(ids), replace = TRUE), nbins = length(ids)))
}
w <- make_weights(firms)
edges <- round(seq(.40, 1, .01), 10); mid <- (head(edges, -1) + tail(edges, -1))/2
specs <- data.frame(specification = c('main', 'degree4', 'degree7', 'narrow', 'wide'),
 degree = c(5L, 4L, 7L, 5L, 5L), left = c(.04, .04, .04, .03, .04), right = c(0, 0, 0, 0, .02))
summary_boot <- function(x) {
 good <- is.finite(x); q <- if (any(good)) quantile(x[good], c(.025, .975), names = FALSE) else c(NA, NA)
 c(se = if (sum(good) > 1L) sd(x[good]) else NA_real_, ci_low = q[1], ci_high = q[2],
   bootstrap_valid = sum(good), bootstrap_failed = sum(!good))
}
status <- function(point, draws) if (!is.finite(point)) 'invalid_point' else
 if (sum(is.finite(draws)) < .9*B) 'unreliable_below_90pct' else
 if (any(!is.finite(draws))) 'conditional_on_valid_draws' else 'all_draws_valid'
counts <- function(use, x = d$rl1, ids = firms, weights = w) {
 use <- use & d$firm_id %in% ids & is.finite(x)
 ix <- findInterval(x, edges, rightmost.closed = TRUE)
 inside <- use & !is.na(ix) & ix > 0L & ix < length(edges)
 a <- matrix(0, length(ids), length(mid))
 for (i in which(inside)) a[match(d$firm_id[i], ids), ix[i]] <- a[match(d$firm_id[i], ids), ix[i]] + 1
 list(y = colSums(a), yb = t(a) %*% weights, n = sum(use), firms = nf(d$firm_id[use]),
      n_in_range = sum(inside), n_outside = sum(use & !inside), ids = unique(d$firm_id[use]))
}
fit_counts <- function(y, threshold = .7, sp = specs[1, ]) {
 # Supports a matrix of separately re-estimated histogram regressions.
 y <- as.matrix(y)
 mass <- mid >= round(threshold-sp$left, 10) & mid < threshold
 excluded <- mid >= round(threshold-sp$left, 10) & mid < round(threshold+sp$right, 10)
 if (threshold != .7) excluded <- excluded | (mid >= .66 & mid < .72)
 X <- cbind(1, poly(mid, degree = sp$degree)); q <- qr(X[!excluded, , drop = FALSE])
 stopifnot(q$rank == ncol(X))
 pred <- X %*% qr.coef(q, y[!excluded, , drop = FALSE])
 good <- colSums(!is.finite(pred[mass, , drop = FALSE]) | pred[mass, , drop = FALSE] <= 0) == 0
 cf <- colSums(pred[mass, , drop = FALSE]); obs <- colSums(y[mass, , drop = FALSE])
 list(b = ifelse(good, (obs-cf)/(cf/sum(mass)), NA_real_), pred = pred,
      observed = obs, cf = cf, good = good, mass = mass, excluded = excluded)
}
fit <- function(c, threshold = .7, sp = specs[1, ]) {
 a <- fit_counts(cbind(c$y, c$yb), threshold, sp)
 list(b = a$b[1], draws = a$b[-1], pred = a$pred[, 1], pred_boot = a$pred[, -1, drop = FALSE], count = c,
      observed = a$observed[1], cf = a$cf[1])
}
pc <- counts(pre); qc <- counts(post)
a0 <- fit(pc); b0 <- fit(qc)
N <- d$tl-d$adv
valid <- is.finite(N) & N > 0 & is.finite(d$te) & d$te > 0
official <- ifelse(valid, N/(N+d$te), NA_real_)
mi0 <- d$mi[match(paste(d$firm_id, '2019-12-31'), paste(d$firm_id, d$date))]
den <- N+d$te-d$mi+mi0
frozen <- ifelse(valid & is.finite(d$mi) & is.finite(mi0) & is.finite(den) & den > 0, N/den, NA_real_)
pair <- post & is.finite(official) & is.finite(frozen)
Dy <- as.numeric(official <= .7)-as.numeric(frozen <= .7)
D <- mean(Dy[pair])
stopifnot(round(b0$b, 2) == 3.14, round(a0$b, 2) == -.88, round(D, 4) == .1146)
ref <- read('outputs/tables/t023_excess_mass.csv')
ref <- ref[ref$ratio == 'rl1' & ref$sample_rule == 'main_sample', ]
dr <- read('outputs/tables/t029_compliance.csv')
dr <- dr[dr$window == 'post' & dr$date == 'pooled' & dr$variant == 'all' & dr$metric == 'D', ]
stopifnot(nrow(dr) == 1L, abs(D-dr$estimate) < 1e-12)
cat(sprintf('T043 reproduction PASS: b_post=%.12f; b_pre=%.12f; D=%.12f.\n', b0$b, a0$b, D))

# Stage new outputs; never source scripts that would rebuild previous outputs.
staged <- list()
stage <- function(path, target) {
 stopifnot(grepl('^t043_', basename(target)))
 staged[[length(staged)+1L]] <<- c(path = path, target = target)
}
csv <- function(x, name) {
 f <- tempfile(fileext = '.csv'); mtpa_write_csv(x, f, row.names = FALSE, na = 'NA')
 stage(f, paste0('outputs/tables/t043_', name, '.csv'))
}
fmt <- function(x) ifelse(is.finite(x), sprintf('%.4f', x), '--')
esc <- function(x) gsub('_', '\\_', x, fixed = TRUE)
ci <- function(lo, hi) paste0('[', fmt(lo), ', ', fmt(hi), ']')
texrow <- function(x) paste0(paste(x, collapse = ' & '), ' \\\\')
tex <- function(name, header, rows, align, note, chunk = 15L) {
 panels <- split(rows, ceiling(seq_along(rows)/chunk)); out <- character()
 for (r in panels) out <- c(out, '\\begingroup\\scriptsize\\setlength{\\tabcolsep}{3pt}', '\\begin{threeparttable}',
  paste0('\\begin{tabular}{', align, '}'), '\\toprule', texrow(header), '\\midrule', r,
  '\\bottomrule', '\\end{tabular}', '\\begin{tablenotes}[flushleft]\\footnotesize',
  paste0('\\item[] ', note), '\\end{tablenotes}', '\\end{threeparttable}', '\\endgroup', '\\par\\medskip')
 f <- tempfile(fileext = '.tex'); mtpa_write_lines(out, f)
 stage(f, paste0('outputs/tables/t043_', name, '.tex'))
}
note <- paste('Main sample. Pre: 2017H1--2019H2; post: 2020H2--2022H2.',
 'Seed 20261016; 999 whole-firm draws, complete re-estimation, pointwise percentile intervals.',
 'Invalid draws are counted without replacement; fewer than 90 percent valid draws is unreliable.',
 'Smooth density and stable reporting selection are assumptions. Descriptive, no causal or evasion inference.')

# 1. All 3 thresholds x 5 specifications, same firm draw in both periods.
delta <- list(); delta_draws <- list()
for (threshold in c(.7, .6, .8)) for (s in seq_len(nrow(specs))) {
 sp <- specs[s, ]; a <- fit(pc, threshold, sp); b <- fit(qc, threshold, sp)
 for (period in c('pre', 'post')) {
  z <- ref[ref$period == period & ref$threshold == threshold & ref$specification == sp$specification, ]
  est <- if (period == 'pre') a$b else b$b
  stopifnot(nrow(z) == 1L, is.na(est) == is.na(z$b), is.na(est) || abs(est-z$b) < 1e-10)
 }
 db <- b$draws-a$draws; good <- is.finite(db)
 delta[[length(delta)+1L]] <- data.frame(threshold = threshold, specification = sp$specification,
  degree = sp$degree, mass_lower = round(threshold-sp$left, 10), mass_upper = threshold,
  exclusion_upper = round(threshold+sp$right, 10), excludes_regulated_region = threshold != .7,
  b_pre = a$b, b_post = b$b, delta_b = b$b-a$b, as.list(summary_boot(db)),
  share_positive_valid = if (any(good)) mean(db[good] > 0) else NA_real_,
  share_positive_all = sum(db > 0, na.rm = TRUE)/B, bootstrap_draws = B,
  n_pre = pc$n, firms_pre = pc$firms, n_post = qc$n, firms_post = qc$firms,
  firms_union = length(union(pc$ids, qc$ids)), bootstrap_universe_firms = G,
  inference_status = status(b$b-a$b, db), row.names = NULL)
 delta_draws[[length(delta_draws)+1L]] <- data.frame(threshold = threshold,
  specification = sp$specification, draw = seq_len(B), b_pre = a$draws, b_post = b$draws, delta_b = db)
}
delta <- do.call(rbind, delta); csv(delta, 'delta_b'); csv(do.call(rbind, delta_draws), 'delta_draws')
tex('delta_b', c('Cutoff / fit', 'N pre/post', 'Firms pre/post', 'Pre b', 'Post b', 'Change (SE)', '95\\% CI', 'Share $>0$'),
 vapply(seq_len(nrow(delta)), function(i) {z <- delta[i, ]; texrow(c(
 paste(fmt(z$threshold), z$specification), paste(z$n_pre,z$n_post,sep='/'),
 paste(z$firms_pre,z$firms_post,sep='/'), fmt(z$b_pre), fmt(z$b_post),
 paste0(fmt(z$delta_b),' (',fmt(z$se),')'), ci(z$ci_low,z$ci_high),fmt(z$share_positive_valid)))}, character(1)),
 'lrrrrrrr', paste(note, 'T023 grid [0.40,1.00], width 0.01. Placebos additionally exclude [0.66,0.72).',
 'Share positive conditions on valid paired draws (denominators and failures in CSV); it is not a p-value.',
 'N includes finite RL1 outside the histogram range.'))
cat('T043 direct change: all 15 prespecified cells reproduce T023 period estimates.\n')

# 2. Integration constraint. Main (Co-PI rework 3, textbook Chetty et al. 2011):
# fit degree five outside [0.66,0.74); B_net = sum_[0.66,0.74)(y-f), i.e. the
# part below 0.70 plus the part in [0.70,0.74); multiply counts in bins >= 0.74
# by 1+B_net/sum_{>=0.74} y; refit; repeat until |change| < 1e-6 (at most 200
# iterations). b_net = B_net / mean fitted count per bin in [0.66,0.70) (T023
# normalization). The full-grid residual is then zero by an OLS identity.
# Secondary (rework 2): the same fixed point with B on [0.66,0.70) only.
# No free scale, no renormalization. Negative B is reported, not truncated.
# Boundary cases (appendix only, not mass-conserving): the earlier free-scale
# literal-s search and its globally normalized version, both below.
# Literal-s: at scale s>=0, fit y_j*(1+s*1[mid>=.70]) outside [0.66,0.74);
# B(s)=sum_L(y-f_s); M(s)=sum_R(f_s-y); bracket upward, bisect B(s)=M(s)>=0.
# Normalized: same, with each predicted full grid rescaled to the observed total.
# This adds a finite-source-window assumption; it is not T023's unconstrained fit.
L <- mid >= .66 & mid < .70; R <- mid >= .70 & mid < .74; U <- mid >= .74
stopifnot(!any(d$rl1[is.finite(d$rl1)] == .74)) # no endpoint ambiguity in these data
X <- cbind(1, poly(mid, degree = 5)); iq <- qr(X[!(L | R), , drop = FALSE])
chetty_fit <- function(y, keep_trace = FALSE, net = FALSE) {
 tol <- 1e-6; maxit <- 200L; su <- sum(y[U]); trace <- list()
 evaluate <- function(Bm, it, change) {
  scale <- Bm/su
  p <- drop(X %*% qr.coef(iq, (y*(1+scale*as.numeric(U)))[!(L | R)]))
  # Iterated quantity: B_net on [0.66,0.74) (net) or B on [0.66,0.70).
  excess <- sum(y[L]-p[L]); missing <- sum(p[R]-y[R])
  target <- if (net) excess-missing else excess
  if (keep_trace) trace[[length(trace)+1L]] <<- data.frame(iteration = it,
   scale = scale, excess = excess, missing = missing, residual = excess-missing,
   total_observed = sum(y), total_predicted = sum(p), total_residual = sum(p)-sum(y),
   excess_change = change)
  list(p = p, excess = excess, missing = missing, scale = scale, target = target)
 }
 reason <- 'max_iterations'; it <- 0L
 if (!(su > 0)) {z <- list(p = rep(NA_real_, length(y)), excess = NA_real_, missing = NA_real_,
  scale = NA_real_, target = NA_real_); reason <- 'no_counts_above_window'; initial <- z} else {
  z <- evaluate(0, 0L, NA_real_); initial <- z
  repeat {
   if (!is.finite(z$target)) {reason <- 'nonfinite_fit'; break}
   if (it >= maxit) break
   it <- it+1L; old <- z$target; z <- evaluate(old, it, NA_real_)
   change <- z$target-old
   if (keep_trace) trace[[length(trace)]]$excess_change <- change
   if (is.finite(change) && abs(change) < tol) {reason <- 'converged'; break}
  }
 }
 converged <- identical(reason, 'converged')
 if (converged && !(1+z$scale > 0)) reason <- 'nonpositive_shift_factor'
 if (converged && !all(is.finite(z$p[L | R]) & z$p[L | R] > 0)) reason <- 'invalid_local_counterfactual'
 good <- identical(reason, 'converged')
 list(b = if (good) z$target/mean(z$p[L]) else NA_real_,
  missing_mass = if (good) z$missing else NA_real_, excess_mass = if (good) z$excess else NA_real_,
  converged = good, numeric_convergence = converged, reason = reason, iterations = it,
  scale = z$scale, residual = z$excess-z$missing,
  total_residual = if (all(is.finite(z$p))) sum(z$p)-sum(y) else NA_real_, tolerance = tol,
  initial_excess = initial$excess, initial_missing = initial$missing,
  initial_residual = initial$excess-initial$missing,
  initial_total_residual = if (all(is.finite(initial$p))) sum(initial$p)-sum(y) else NA_real_,
  diagnostic_excess = z$excess, diagnostic_missing = z$missing,
  trace = if (keep_trace) do.call(rbind, trace) else NULL)
}
integration_fit <- function(y, keep_trace = FALSE, normalized = FALSE) {
 tol <- 1e-8 * max(1, sum(y[L | R])); maxit <- 200L; trace <- list()
 evaluate <- function(s) {
  adjusted <- y*(1+s*as.numeric(mid >= .70))
  p <- drop(X %*% qr.coef(iq, adjusted[!(L | R)]))
  if (normalized) p <- if (is.finite(sum(p)) && sum(p)>0) p*sum(y)/sum(p) else rep(NA_real_,length(p))
  excess <- sum(y[L]-p[L]); missing <- sum(p[R]-y[R]); residual <- excess-missing
  if (keep_trace) trace[[length(trace)+1L]] <<- data.frame(iteration = length(trace),
   scale = s, excess = excess, missing = missing, residual = residual,
   total_observed = sum(y), total_predicted = sum(p), total_residual = sum(p)-sum(y),
   excess_change = NA_real_)
  list(p = p, excess = excess, missing = missing, residual = residual, scale = s,
       total_residual = sum(p)-sum(y))
 }
 z <- evaluate(0); initial <- z; it <- 0L; reason <- 'not_converged'
 if (!is.finite(z$residual)) reason <- 'nonfinite_initial_fit' else
 if (z$residual < -tol) reason <- 'upward_shift_cannot_balance' else {
  lo <- 0; hi <- 1
  if (abs(z$residual) > tol) {
   zhi <- evaluate(hi)
   while (is.finite(zhi$residual) && zhi$residual > tol && hi < 2^20) {
    hi <- hi*2; zhi <- evaluate(hi)
   }
   if (!is.finite(zhi$residual) || zhi$residual > tol) {
    reason <- 'no_upward_bracket'; z <- zhi
   } else {
    repeat {
     it <- it+1L; z <- evaluate((lo+hi)/2)
     if (!is.finite(z$residual) || abs(z$residual) <= tol || it >= maxit) break
     if (z$residual > 0) lo <- z$scale else hi <- z$scale
    }
   }
  }
  if (is.finite(z$residual) && abs(z$residual) <= tol) reason <- 'balanced'
 }
 numeric_convergence <- identical(reason, 'balanced')
 if (numeric_convergence && (!all(is.finite(z$p[L | R]) & z$p[L | R] > 0))) reason <- 'invalid_local_counterfactual'
 if (numeric_convergence && (z$excess < -tol || z$missing < -tol)) reason <- 'negative_excess_or_missing_mass'
 good <- identical(reason, 'balanced')
 list(b = if (good) z$excess/mean(z$p[L]) else NA_real_,
  missing_mass = if (good) z$missing else NA_real_, excess_mass = if (good) z$excess else NA_real_,
  converged = good, numeric_convergence = numeric_convergence, reason = reason, iterations = it,
  evaluations = if (keep_trace) length(trace) else NA_integer_, scale = z$scale,
  residual = z$residual, total_residual = z$total_residual, tolerance = tol,
  initial_excess = initial$excess, initial_missing = initial$missing,
  initial_residual = initial$residual, initial_total_residual = initial$total_residual,
  diagnostic_excess = z$excess, diagnostic_missing = z$missing,
  trace = if (keep_trace) do.call(rbind, trace) else NULL)
}
integ <- list(); integ_draws <- list(); traces <- list(); net_draws <- list(); net_point <- list()
for (period in c('pre', 'post')) {
 c <- if (period == 'pre') pc else qc; base <- if (period == 'pre') a0 else b0
 base_missing <- summary_boot(colSums(base$pred_boot[R,,drop=FALSE]-c$yb[R,,drop=FALSE]))
 integ[[length(integ)+1L]] <- data.frame(period = period, method = 'T023_baseline',
  normalized = FALSE, main_integration = FALSE,
  b = base$b, as.list(summary_boot(base$draws)), missing_mass = sum(base$pred[R]-c$y[R]),
  missing_ci_low = base_missing['ci_low'], missing_ci_high = base_missing['ci_high'], converged = NA,
  numeric_convergence = NA, convergence_status = 'unconstrained', iterations = 0L,
  scale = 0, mass_balance_residual = sum(c$y[L]-base$pred[L])-sum(base$pred[R]-c$y[R]),
  total_mass_residual = sum(base$pred)-sum(c$y),
  diagnostic_excess = sum(c$y[L]-base$pred[L]), diagnostic_missing = sum(base$pred[R]-c$y[R]),
  initial_excess = NA_real_, initial_missing = NA_real_, initial_residual = NA_real_,
  initial_total_residual = NA_real_,
  tolerance = NA_real_, n = c$n, firms = c$firms, bootstrap_draws = B,
  bootstrap_converged = NA_integer_, inference_status = status(base$b,base$draws), row.names = NULL)
 for (method in c('chetty_net', 'chetty_below_only', 'boundary_literal_s', 'boundary_normalized')) {
 normalized <- method == 'boundary_normalized'
 fitter <- switch(method, chetty_net = function(y, tr = FALSE) chetty_fit(y, tr, net = TRUE),
  chetty_below_only = function(y, tr = FALSE) chetty_fit(y, tr),
  function(y, tr = FALSE) integration_fit(y, tr, normalized))
 z <- fitter(c$y, TRUE)
 bs <- lapply(seq_len(B), function(i) fitter(c$yb[, i]))
 db <- vapply(bs, `[[`, numeric(1), 'b'); dm <- vapply(bs, `[[`, numeric(1), 'missing_mass')
 st <- summary_boot(db); sm <- summary_boot(dm)
 if (!z$converged) st[c('se','ci_low','ci_high')] <- NA_real_
 integ[[length(integ)+1L]] <- data.frame(period = period, method = method,
  normalized = normalized, main_integration = method == 'chetty_net',
  b = z$b, as.list(st), missing_mass = z$missing_mass, missing_ci_low = if(z$converged) sm['ci_low'] else NA_real_,
  missing_ci_high = if(z$converged) sm['ci_high'] else NA_real_, converged = z$converged,
  numeric_convergence = z$numeric_convergence, convergence_status = z$reason, iterations = z$iterations,
  scale = z$scale, mass_balance_residual = z$residual, tolerance = z$tolerance,
  total_mass_residual = z$total_residual, diagnostic_excess = z$diagnostic_excess,
  diagnostic_missing = z$diagnostic_missing,
  initial_excess = z$initial_excess, initial_missing = z$initial_missing,
  initial_residual = z$initial_residual, initial_total_residual = z$initial_total_residual,
  n = c$n, firms = c$firms, bootstrap_draws = B, bootstrap_converged = sum(is.finite(db)),
  inference_status = status(z$b,db), row.names = NULL)
 traces[[paste(period,method)]] <- cbind(period = period, method = method, z$trace)
 integ_draws[[paste(period,method)]] <- data.frame(period = period, method = method,
  draw = seq_len(B), b = db, missing_mass = dm,
  convergence_status = vapply(bs, `[[`, character(1), 'reason'),
  scale = vapply(bs, `[[`, numeric(1), 'scale'), residual = vapply(bs, `[[`, numeric(1), 'residual'),
  total_mass_residual = vapply(bs, `[[`, numeric(1), 'total_residual'),
  tolerance = vapply(bs, `[[`, numeric(1), 'tolerance'), iterations = vapply(bs, `[[`, integer(1), 'iterations'))
 if (method == 'chetty_net') {net_draws[[period]] <- db; net_point[[period]] <- z$b}
 if (z$converged) {
  if (method == 'chetty_net') {
   # Fixed point with B_net on [0.66,0.74): fitted counts outside the window sum
   # to the observed ones plus B_net (OLS with intercept), fitted counts inside
   # sum to observed minus B_net, so the full-grid residual is zero.
   stopifnot(abs(z$total_residual) < 1e-6*max(1, sum(c$y)),
    abs(z$scale*sum(c$y[U])-z$residual) < 1e-5)
  } else if (method == 'chetty_below_only') {
   # Same identity with B on [0.66,0.70) only: total residual = missing mass.
   stopifnot(abs(z$total_residual-z$missing_mass) < 1e-6*max(1, sum(c$y)))
  } else {
   stopifnot(abs(z$residual) <= z$tolerance, z$scale >= 0)
   if (normalized) stopifnot(abs(z$total_residual) <= z$tolerance)
  }
 }
 }
}
# Delta b_net with the joint firm bootstrap of step 1 (pc and qc share weights w).
dn <- net_draws$post-net_draws$pre; dnp <- net_point$post-net_point$pre
integ[[length(integ)+1L]] <- data.frame(period = 'post_minus_pre', method = 'chetty_net',
 normalized = FALSE, main_integration = TRUE, b = dnp, as.list(summary_boot(dn)),
 missing_mass = NA_real_, missing_ci_low = NA_real_, missing_ci_high = NA_real_,
 converged = is.finite(dnp), numeric_convergence = NA, convergence_status = 'joint_difference',
 iterations = NA_integer_, scale = NA_real_, mass_balance_residual = NA_real_, tolerance = NA_real_,
 total_mass_residual = NA_real_, diagnostic_excess = NA_real_, diagnostic_missing = NA_real_,
 initial_excess = NA_real_, initial_missing = NA_real_, initial_residual = NA_real_,
 initial_total_residual = NA_real_, n = pc$n+qc$n, firms = length(union(pc$ids, qc$ids)),
 bootstrap_draws = B, bootstrap_converged = sum(is.finite(dn)), inference_status = status(dnp, dn),
 row.names = NULL)
integ <- do.call(rbind, integ)
# B_net decomposition for every row: part below 0.70 plus part in [0.70,0.74).
integ$excess_below_070 <- integ$diagnostic_excess
integ$excess_070_074 <- -integ$diagnostic_missing
integ$net_excess <- integ$excess_below_070+integ$excess_070_074
integ$share_positive_valid <- ifelse(integ$period == 'post_minus_pre', mean(dn[is.finite(dn)] > 0), NA_real_)
csv(integ,'integration')
csv(do.call(rbind,integ_draws),'integration_draws'); csv(do.call(rbind,traces),'integration_iterations')
tex('integration', c('Period / method', 'N', 'Firms', 'b', '95\\% CI', '$B_{net}$', 'Below 0.70', '[0.70,0.74)', 'Mass resid.', 'Iter.', 'Valid draws'),
 vapply(seq_len(nrow(integ)),function(i) {z<-integ[i,];delta_row<-z$period=='post_minus_pre';texrow(c(
 if (delta_row) 'post minus pre: Chetty net, $\\Delta b_{net}$' else paste(z$period,
 switch(z$method,T023_baseline='T023 baseline',chetty_net='Chetty net (main)',
 chetty_below_only='Chetty, $B$ below 0.70 only (secondary)',
 boundary_literal_s='Boundary: literal $s$',boundary_normalized='Boundary: normalized')),
 if (delta_row) paste(pc$n,qc$n,sep='/') else z$n,z$firms,fmt(z$b),paste0(ci(z$ci_low,z$ci_high),
  if(z$inference_status %in% c('conditional_on_valid_draws','unreliable_below_90pct') && is.finite(z$b))'$^{\\dagger}$' else ''),
 # T023 baseline fit does not exclude [0.70,0.74): B_net and that column are not comparable.
 if (z$method=='T023_baseline') '--' else fmt(z$net_excess),fmt(z$excess_below_070),
 if (z$method=='T023_baseline') '--' else fmt(z$excess_070_074),fmt(z$total_mass_residual),
 if (is.na(z$iterations)) '--' else z$iterations,
 paste0(z$bootstrap_valid,'/',z$bootstrap_draws)))},character(1)),
 'lrrrrrrrrrr',paste(note,'Degree five; integration rows exclude [0.66,0.74), the T023 baseline only [0.66,0.70). T023 baseline rows show -- for $B_{net}$ and [0.70,0.74): their fit does not exclude [0.70,0.74), so these columns are not comparable with the integration rows (values in CSV). $B_{net}$ = observed minus fitted counts over [0.66,0.74) = Below 0.70 (over [0.66,0.70)) + [0.70,0.74) (observed minus fitted there; negative = missing mass above 0.70).',
 'Mass resid. = full-grid fitted minus observed total over [0.40,1.00], shown for every row. Decomposition and residual are the final values of each search, also where the point estimate is unavailable.',
 'Chetty net (main; textbook Chetty et al. 2011): counts in bins at or above 0.74 are multiplied by 1 + $B_{net}$ / (their sum), the polynomial is refitted and $B_{net}$ recomputed until it changes by less than 1e-6 (at most 200 iterations); no free scale, no renormalization. Its mass residual is zero by an OLS identity (asserted).',
 '$b_{net}$ = $B_{net}$ divided by the mean fitted count per bin in [0.66,0.70), the T023 normalization of b.',
 '$\\Delta b_{net}$ = post minus pre $b_{net}$, joint firm bootstrap as in the change table (same firm draw in both periods); N pre/post, firms = union. Share of valid draws with $\\Delta b_{net} > 0$ in CSV; not a p-value.',
 'Secondary (rework 2): same fixed point with $B$ measured on [0.66,0.70) only, b = that $B$ over the same denominator; its mass residual equals minus the [0.70,0.74) column (observed minus fitted there) by the same identity.',
 'Boundary cases (appendix): literal $s$ multiplies all counts at or above 0.70 by 1+s with free s chosen so that local excess equals local missing; normalized additionally rescales each fitted full grid to the observed total. Neither case conserves mass in the sense of the fixed point: literal $s$ leaves the full-grid residual shown; normalized forces it to zero only by rescaling the left side.',
 'Boundary tolerance 1e-8 times max(1, local observed count); upward bracket at most 2 to the power 20, at most 200 bisections. No clipping or forced result.',
 '$\\dagger$: interval conditional on valid bootstrap draws only (see Valid draws); conditioning can narrow it. Unavailable estimates and nonconvergence are shown as --; CSVs retain reasons, starting fits, scales, traces and all draws.',
 esc(paste(paste(integ$period,integ$method,integ$convergence_status,sep=': '),collapse='; '))))
cat('T043 integration: ',paste(integ$convergence_status,collapse=', '),'.\n',sep='')

# 3. Retain raw constructed-minus-published errors; add the Co-PI-approved
# centered sensitivity variant. Reset the seed per variant so sampled error
# indices match: raw minus centered perturbation equals the empirical mean.
# iid firm-date perturbations; original firms and dates remain fixed. No nested
# firm bootstrap: simulation percentiles are perturbation intervals, not CIs.
matched <- read('outputs/tables/t040_matched_observations.csv')
matched <- matched[matched$ratio == 'rl1' & is.finite(matched$constructed) & is.finite(matched$published), ]
stopifnot(!anyDuplicated(matched[c('firm_id','date')]),
 all(abs(matched$error-(matched$constructed-matched$published)) < 1e-12))
sim <- list(); sim_rows <- list()
for (scope in c('all','published_rl1_060_080')) {
 e <- matched
 if (scope != 'all') e <- e[e$published >= .60 & e$published <= .80, ]
 errors <- e$constructed-e$published; stopifnot(length(errors)>1)
 for (error_variant in c('uncentered','centered')) {
 applied_errors <- errors-if(error_variant=='centered')mean(errors) else 0
 if(error_variant=='centered')stopifnot(abs(mean(applied_errors))<1e-14)
 set.seed(seed)
 draws <- matrix(NA_real_,B,3,dimnames=list(NULL,c('b_post','b_pre','delta_b')))
 use <- (pre | post) & is.finite(d$rl1)
 for (i in seq_len(B)) {
  x <- d$rl1; x[use] <- x[use]+sample(applied_errors,sum(use),replace=TRUE)
  # Point fits alone; every simulation refits pre and post on new bin counts.
  a <- fit_counts(counts(pre,x,weights=matrix(1,G,1))$y)$b
  b <- fit_counts(counts(post,x,weights=matrix(1,G,1))$y)$b
  draws[i, ] <- c(b,a,b-a)
 }
 sim[[paste(scope,error_variant)]] <- data.frame(scope=scope,error_variant=error_variant,draw=seq_len(B),draws,
  n_pre=pc$n,firms_pre=pc$firms,n_post=qc$n,firms_post=qc$firms)
 for (metric in colnames(draws)) {
  x <- draws[,metric]; good <- is.finite(x); q <- if(any(good))quantile(x[good],c(.025,.975),names=FALSE) else c(NA,NA)
  sim_rows[[length(sim_rows)+1L]] <- data.frame(scope=scope,error_variant=error_variant,metric=metric,
   baseline=switch(metric,b_post=b0$b,b_pre=a0$b,delta_b=b0$b-a0$b),
   mean=if(any(good))mean(x[good]) else NA_real_,p025=q[1],p975=q[2],
   share_positive_valid=if(any(good))mean(x[good]>0) else NA_real_,share_positive_all=sum(x>0,na.rm=TRUE)/B,
   simulation_draws=B,valid=sum(good),failed=sum(!good),error_n=length(errors),error_firms=nf(e$firm_id),
   error_mean=mean(errors),error_sd=sd(errors),applied_error_mean=mean(applied_errors),
   applied_error_sd=sd(applied_errors),centering_shift=if(error_variant=='centered')mean(errors) else 0,
   n_pre=pc$n,firms_pre=pc$firms,n_post=qc$n,firms_post=qc$firms,
   inference='iid_error_perturbation_not_sampling_CI',row.names=NULL)
 }
 }
}
sim <- do.call(rbind,sim); sim_rows <- do.call(rbind,sim_rows)
for(scope in unique(sim_rows$scope))for(metric in unique(sim_rows$metric)) {
 ix <- which(sim_rows$scope==scope & sim_rows$metric==metric)
 raw <- sim_rows$mean[ix[sim_rows$error_variant[ix]=='uncentered']]
 centered <- sim_rows$mean[ix[sim_rows$error_variant[ix]=='centered']]
 baseline <- sim_rows$baseline[ix[1]]
 # Exact descriptive decomposition of mean attenuation on matched simulations:
 # baseline - raw = (baseline - centered) + (centered - raw).
 sim_rows$attenuation_from_baseline[ix] <- baseline-sim_rows$mean[ix]
 sim_rows$mean_shift_attenuation[ix] <- centered-raw
 sim_rows$centered_attenuation[ix] <- baseline-centered
 sim_rows$mean_shift_share_of_uncentered_attenuation[ix] <-
  if(is.finite(baseline-raw) && baseline!=raw)(centered-raw)/(baseline-raw) else NA_real_
}
csv(sim_rows,'meas_error'); csv(sim,'meas_error_draws')
tex('meas_error',c('Sample / variant / statistic','Error N (firms)','Applied mean (SD)','Sim. mean','2.5/97.5 pct.','Share $>0$'),
 vapply(seq_len(nrow(sim_rows)),function(i){z<-sim_rows[i,];texrow(c(paste(if(z$scope=='all')'All pairs' else 'Near cutoff',
 if(z$error_variant=='uncentered')'raw' else 'centered',
 switch(z$metric,b_post='post b',b_pre='pre b',delta_b='change b')),
 paste0(z$error_n,' (',z$error_firms,')'),paste0(fmt(z$applied_error_mean),' (',fmt(z$applied_error_sd),')'),
 fmt(z$mean),ci(z$p025,z$p975),fmt(z$share_positive_valid)))},character(1)),'lrrrrr',
 paste('999 measurement-error perturbations per sample and variant; seed 20261016. Raw errors are constructed minus published RL1; centered errors subtract their empirical mean before addition to original RL1.',
 'Raw and centered variants use identical sampled error indices. Centering is an approved additional sensitivity check, not a correction of the original ratios.',
 'CSV error-mean and error-SD describe raw empirical errors; applied-error columns describe the distribution actually added.',
 'Mean-shift attenuation = centered minus raw simulation mean; baseline minus raw = centered attenuation plus mean-shift attenuation. The CSV reports this contrast and its share of raw attenuation; this is a descriptive decomposition, not a causal attribution.',
 'Empirical errors are transported iid across pre/post firm-dates; the selected validation sample need not represent population errors.',
 'No nested bootstrap: intervals are simulation percentiles, not sampling confidence intervals.',
 sprintf('Fixed analysis observations/firms: pre %d/%d; post %d/%d. Error sample counts, means, SDs and validity denominators are in CSV.',pc$n,pc$firms,qc$n,qc$firms)))
f <- tempfile(fileext='.pdf')
grDevices::pdf(f,width=10,height=8.5,useDingbats=FALSE,timestamp=FALSE,title='T043 measurement-error perturbations')
par(mfrow=c(2,2),mar=c(4,4,3,1),oma=c(2,0,0,0))
for(scope in unique(sim$scope))for(error_variant in c('uncentered','centered')) {
 x<-sim$b_post[sim$scope==scope & sim$error_variant==error_variant]; x<-x[is.finite(x)]
 limits <- range(c(sim$b_post[sim$scope==scope],b0$b),finite=TRUE)
 hist(x,breaks=25,col='#86B5C4',border='white',
  xlab='Simulated post b',xlim=limits,
  main=paste(if(scope=='all')'All pairs' else 'Published RL1 [0.60, 0.80]',
   if(error_variant=='uncentered')'raw errors' else 'centered errors',sep=': '))
 abline(v=b0$b,col='#B44E31',lwd=2,lty=2)
 legend('topleft',legend=sprintf('Baseline %.2f',b0$b),col='#B44E31',lty=2,bty='n',cex=.8)
}
mtext('Added empirical errors; 999 perturbations per panel. Percentiles describe simulation uncertainty.',outer=TRUE,side=1,cex=.8)
invisible(dev.off()); stage(f,'outputs/figures/t043_meas_error.pdf')
cat('T043 measurement error: two empirical distributions x raw/centered variants x 999 perturbations completed.\n')

# 4. Predetermined firm classes; do not condition on RL1 at classification date.
firm_class <- function(v) vapply(firms,function(id) {
 z<-unique(d[[v]][d$firm_id==id & !is.na(d[[v]])]);stopifnot(length(z)<=1L)
 if(length(z))as.character(z) else NA_character_
},character(1))
own <- firm_class('soe_final'); own <- ifelse(own=='1','SOE',ifelse(own=='0','private',NA))
market <- firm_class('market'); stopifnot(all(market %in% c('A','HK')))
at <- match(paste(firms,'2020-06-30'),paste(d$firm_id,d$date))
r2 <- d$rl2[at]; r3 <- d$rl3[at]
other <- ifelse(is.finite(r2)&is.finite(r3),
 ifelse(r2<=1 & r3>=1,'both_met','at_least_one_breached'),NA_character_)
hetero <- list(); hetero_draws <- list()
for (dimension in c('ownership','market','other_lines_2020h1')) {
 cl <- switch(dimension,ownership=own,market=market,other_lines_2020h1=other)
 for(group in sort(unique(cl[!is.na(cl)]))) {
  ids <- firms[!is.na(cl)&cl==group]; wg <- make_weights(ids)
  use <- post & d$firm_id %in% ids; c <- counts(use,ids=ids,weights=wg); z <- fit(c)
  u <- use & is.finite(Dy); a <- b <- numeric(length(ids))
  for(i in which(u)) {j<-match(d$firm_id[i],ids);a[j]<-a[j]+Dy[i];b[j]<-b[j]+1}
  Ddraw <- drop(crossprod(a,wg)/crossprod(b,wg))
  for(metric in c('b_post','D')) {
   point <- if(metric=='b_post')z$b else if(sum(b))sum(a)/sum(b) else NA_real_
   draws <- if(metric=='b_post')z$draws else Ddraw
   n <- if(metric=='b_post')c$n else sum(u)
   nfirm <- if(metric=='b_post')c$firms else nf(d$firm_id[u])
   s<-summary_boot(draws); if(!is.finite(point))s[c('se','ci_low','ci_high')]<-NA_real_
   hetero[[length(hetero)+1L]]<-data.frame(dimension=dimension,group=group,metric=metric,
    estimate=point,as.list(s),n=n,firms=nfirm,n_in_range=if(metric=='b_post')c$n_in_range else NA_integer_,
    cell_universe_firms=length(ids),excluded_unclassified_firms=sum(is.na(cl)),
    excluded_unclassified_post_dates=sum(post & d$firm_id %in% firms[is.na(cl)]),
    excluded_missing_outcome=sum(use)-n,descriptive=TRUE,descriptive_small_cell=nfirm<30L,
    bootstrap_draws=B,inference_status=status(point,draws),row.names=NULL)
   hetero_draws[[length(hetero_draws)+1L]]<-data.frame(dimension=dimension,group=group,
    metric=metric,draw=seq_len(B),estimate=draws)
  }
 }
}
hetero<-do.call(rbind,hetero);csv(hetero,'heterogeneity');csv(do.call(rbind,hetero_draws),'heterogeneity_draws')
tex('heterogeneity',c('Dimension / group / statistic','N','Firms','Estimate','95\\% CI','Cell $<30$'),
 vapply(seq_len(nrow(hetero)),function(i){z<-hetero[i,];texrow(c(paste(
 switch(z$dimension,ownership='Ownership:',market='Market:',other_lines_2020h1='Other lines:'),
 gsub('_',' ',z$group,fixed=TRUE),if(z$metric=='b_post')'post b' else 'D'),
 z$n,z$firms,fmt(z$estimate),ci(z$ci_low,z$ci_high),if(z$descriptive_small_cell)'Yes' else 'No'))},character(1)),
 'p{0.32\\linewidth}rrrrr',paste(note,'All heterogeneity is descriptive, with cells below 30 observed unique firms flagged.',
 'Each fixed subgroup resamples its own firms uniformly with replacement, preserving whole histories.',
 'SOE uses soe-final; missing final classifications are excluded. Other-line class requires both finite RL2 and RL3 at 2020-06-30; missing stays unclassified.',
 'Both met: RL2 at most 1 and RL3 at least 1. No RL1 selection. CSV counts all classification and outcome exclusions.',
 'D is official minus end-2019-frozen compliance on eligible $N>0$, $E>0$ pairs with positive frozen denominator; MI may be genuine equity.'))
cat('T043 heterogeneity: 12 descriptive estimate cells, subgroup firm-bootstrap CIs.\n')

# 5. Fiscal-year windows from reports_needed, as specified in revision 2.
# Sum only annual reports strictly after the earlier FY endpoint through the
# later one. A printed dash is zero; an empty cell remains missing.
pilot <- read('../state/handcollect/pilot_purposive.csv')
cash <- read('data/raw/manual/handcollect/nci_cashflow.csv')
stopifnot(nrow(pilot)==10L,!anyDuplicated(pilot$firm_id),
 !anyDuplicated(cash[c('firm_id','date','metric')]))
parse_amount <- function(x, status) {
 x <- gsub(',','',trimws(x),fixed=TRUE)
 x <- sub('^\\((.*)\\)$','-\\1',x)
 out <- suppressWarnings(as.numeric(x))
 dash <- !is.na(x) & x %in% c('-', '\u2013', '\u2014') & status=='printed dash'
 out[dash] <- 0
 out
}
cash$value_numeric <- parse_amount(cash$value,cash$status)
cash$unit_multiplier <- ifelse(cash$currency_unit=='RMB 1',1,
 ifelse(cash$currency_unit=='RMB 1,000',1000,NA_real_))
stopifnot(all(is.finite(cash$unit_multiplier)))
cash$value_rmb <- cash$value_numeric*cash$unit_multiplier
sources <- list(); backing <- list()
annual_cash <- function(id,date,metric) {
 z <- cash[cash$firm_id==id & cash$date==date & cash$metric==metric,]
 if(!nrow(z)) {
  sources[[length(sources)+1L]] <<- data.frame(firm_id=id,date=date,metric=metric,
   report='missing',pdf_page='missing',raw_value='missing',currency_unit='missing',
   value_rmb=NA_real_,value_used_rmb=NA_real_,status='missing required annual report',
   source_reference='missing',verified_by_PI='missing')
  return(NA_real_)
 }
 stopifnot(nrow(z)==1L,grepl('^FY',z$report))
 value <- if(metric=='dividends_to_nci')abs(z$value_rmb) else z$value_rmb
 page <- ifelse(is.na(z$pdf_page),'missing',as.character(z$pdf_page))
 sources[[length(sources)+1L]] <<- data.frame(firm_id=id,date=date,metric=metric,
  report=z$report,pdf_page=page,raw_value=ifelse(is.na(z$value),'missing',z$value),
  currency_unit=z$currency_unit,value_rmb=z$value_rmb,value_used_rmb=value,
  status=ifelse(z$status=='printed dash','printed dash = 0 (revision 2)',
   ifelse(is.finite(value),z$status,paste('missing:',z$status))),
  source_reference=paste(id,z$report,paste0('pdf_page=',page)),
  verified_by_PI=ifelse(is.na(z$verified_by_PI),'missing',as.character(z$verified_by_PI)))
 if(is.finite(value))stopifnot(page!='missing')
 value
}
for(i in seq_len(nrow(pilot))) {
 z <- pilot[i,]; id <- z$firm_id
 years <- sort(unique(as.integer(sub('FY','',regmatches(z$reports_needed,
  gregexpr('FY[0-9]{4}',z$reports_needed))[[1]]))))
 stopifnot(length(years)>=2L)
 date0 <- paste0(min(years),'-12-31'); date1 <- paste0(max(years),'-12-31')
 flow_dates <- paste0(seq.int(min(years)+1L,max(years)),'-12-31')
 k0 <- match(paste(id,date0),paste(d$firm_id,d$date)); k1 <- match(paste(id,date1),paste(d$firm_id,d$date))
 delta_mi <- d$mi[k1]-d$mi[k0]
 vals <- vapply(c('capital_from_nci','dividends_to_nci'),function(metric)
  sum(vapply(flow_dates,function(date)annual_cash(id,date,metric),numeric(1))),numeric(1))
 net <- vals[1]-vals[2]
 used <- do.call(rbind,sources); used <- used[used$firm_id==id,]
 currency0 <- d$currency[k0]; currency1 <- d$currency[k1]
 currency_verified <- !is.na(currency0)&!is.na(currency1)&currency0=='RMB'&currency1=='RMB'
 # Preserve nominal panel MI; never invent an FX conversion. HK ratios are
 # explicitly conditional on panel stocks sharing the statements' RMB unit.
 complete <- is.finite(delta_mi)&all(is.finite(vals))
 backing[[i]] <- data.frame(row_type='firm',group=z$group,firm_id=id,market=z$market,
  date0=date0,date1=date1,reports_needed=z$reports_needed,n=sum(is.finite(c(d$mi[k0],d$mi[k1]))),firms=1L,
  mi0=d$mi[k0],mi1=d$mi[k1],delta_mi=delta_mi,
  panel_currency0=currency0,panel_currency1=currency1,currency_verified=currency_verified,
  capital_from_nci=unname(vals[1]),dividends_to_nci=unname(vals[2]),net_cash=unname(net),
  cash_delta_mi=if(complete && delta_mi!=0)unname(net/delta_mi) else NA_real_,
  capital_delta_mi=if(is.finite(vals[1]) && is.finite(delta_mi) && delta_mi!=0)
   unname(vals[1]/delta_mi) else NA_real_,complete=complete,
  status=paste(c(if(any(!is.finite(vals)))'incomplete: missing annual cash component',
   if(!is.finite(delta_mi))'incomplete: missing MI endpoint',
   if(!currency_verified)'ratios conditional on panel MI being RMB; currency unverified',
   if(complete)'complete cash components'),collapse='; '),
  source_references=paste(paste0(used$metric,' ',used$date,': ',used$source_reference,
   ifelse(is.finite(used$value_used_rmb),'',' [missing]')),collapse='; '),row.names=NULL)
}
backing <- do.call(rbind,backing)
for(group in c('A_mi_crossing','B_mi_increase_no_crossing')) {
 z <- backing[backing$group==group,]; complete <- all(z$complete)
 r <- z[1,]; r$row_type <- 'pooled'; r$firm_id <- 'pooled'; r$market <- 'mixed'
 r$date0 <- NA; r$date1 <- NA; r$reports_needed <- 'firm-specific annual windows'
 r$n <- sum(z$n); r$firms <- nrow(z); r$mi0 <- NA; r$mi1 <- NA
 r$panel_currency0 <- 'mixed; RMB assumed for reported'; r$panel_currency1 <- r$panel_currency0
 r$currency_verified <- all(z$currency_verified)
 r$delta_mi <- sum(z$delta_mi)
 r$capital_from_nci <- sum(z$capital_from_nci)
 r$dividends_to_nci <- sum(z$dividends_to_nci)
 r$net_cash <- sum(z$net_cash)
 r$cash_delta_mi <- if(complete && r$delta_mi!=0)r$net_cash/r$delta_mi else NA_real_
 r$capital_delta_mi <- if(is.finite(r$capital_from_nci)&&is.finite(r$delta_mi)&&r$delta_mi!=0)
  r$capital_from_nci/r$delta_mi else NA_real_
 r$complete <- complete
 r$status <- paste(if(complete)'complete cash components' else
  'incomplete: full-group net ratio unavailable; no complete-case substitution',
  if(!r$currency_verified)'ratios conditional on all panel MI being RMB; currency unverified' else '')
 r$source_references <- paste(z$source_references,collapse=' | ')
 backing <- rbind(backing,r)
}
sources <- do.call(rbind,sources); csv(backing,'cash_backing'); csv(sources,'cash_sources')
tex('cash_backing',c('Group / firm','Firms','FY endpoints','Change MI (bn)','Capital (bn)','Dividends (bn)','Cash / change MI'),
 vapply(seq_len(nrow(backing)),function(i){z<-backing[i,];texrow(c(esc(paste(substr(z$group,1,1),z$firm_id)),
 z$firms,if(z$row_type=='firm')paste(substr(z$date0,1,4),substr(z$date1,1,4),sep='/') else 'pooled',
 fmt(z$delta_mi/1e9),fmt(z$capital_from_nci/1e9),fmt(z$dividends_to_nci/1e9),fmt(z$cash_delta_mi)))},character(1)),
 'lrrrrrr',paste('Purposive ten-firm pilot; annual windows from the earlier to later FY in reports-needed; cash flows are FYs strictly after the origin through the endpoint.',
 'Printed dash = zero as instructed in revision 2; empty cells stay missing. Capital minus absolute dividend outflows; no other NCI transactions added.',
 'Cash is converted from disclosed RMB units to RMB. HK panel MI currency is reported, unverified: all HK and pooled ratios and MI sums involving HK are conditional on panel MI being RMB; no FX conversion was invented.',
 'Full-group A/B ratios require all cash components; available capital and dividends are retained separately, with no complete-case substitution.',
 'CSV retains unique firm counts, fiscal endpoints, every page reference and missing flag; t043-cash-sources CSV retains original values including printed dashes.'))
cat(sprintf('T043 pilot: %d firms; %d complete annual-window net-cash ratios (%d conditional on HK currency).\n',
 sum(backing$row_type=='firm'),sum(backing$complete[backing$row_type=='firm']),
 sum(backing$complete & !backing$currency_verified & backing$row_type=='firm')))

# 7. Trend-adjusted MI counterfactual. No post-policy information enters trends.
# Firm-history sufficient statistics (log increments and elapsed half-years)
# are invariant when a whole firm is duplicated. Each bootstrap draw re-estimates
# every bin median from its resampled donor firms and refits the density.
h <- as.integer(format(d$date,'%Y'))*2L+as.integer(format(d$date,'%m')=='12')
fi <- match(d$firm_id,firms)
trend_setup <- function(anchor) {
 anchor <- as.Date(anchor)
 ah <- as.integer(format(anchor,'%Y'))*2L+as.integer(format(anchor,'%m')=='12')
 ai <- match(paste(firms,anchor),paste(d$firm_id,d$date))
 rl <- d$rl1[ai]
 bin <- ifelse(is.finite(rl)&rl>=.60&rl<.66,'060_066',
  ifelse(is.finite(rl)&rl>=.66&rl<.74,'066_074',
   ifelse(is.finite(rl)&rl>=.74&rl<=.80,'074_080','other')))
 own_rate <- rep(NA_real_,G); npre <- integer(G); bad <- logical(G)
 first <- last <- rep(NA_character_,G)
 for(j in seq_len(G)) {
  ix <- which(fi==j & h>=ah-6L & h<=ah & is.finite(d$mi))
  npre[j] <- length(ix); bad[j] <- any(d$mi[ix]<=0)
  if(length(ix)) {first[j]<-as.character(min(d$date[ix]));last[j]<-as.character(max(d$date[ix]))}
  if(npre[j]>=4L && !bad[j]) {
   # Time-weighted average half-year log growth; gaps use elapsed half-years.
   own_rate[j] <- sum(diff(log(d$mi[ix])))/sum(diff(h[ix]))
  }
 }
 list(anchor=anchor,ah=ah,ai=ai,bin=bin,own_rate=own_rate,npre=npre,bad=bad,
  first=first,last=last,use=h>=ah+2L & h<=ah+6L,mi_anchor=d$mi[ai],rl_anchor=rl)
}
trend_rates <- function(z,weights,variant) {
 common <- rep(NA_real_,G)
 for(bin in unique(z$bin)) {
  donors <- z$bin==bin & is.finite(z$own_rate) & weights>0
  if(any(donors))common[z$bin==bin] <- median(rep(z$own_rate[donors],weights[donors]))
 }
 if(variant=='firm_trend')ifelse(is.finite(z$own_rate),z$own_rate,common) else common
}
trend_estimate <- function(z,weights,variant) {
 rate <- trend_rates(z,weights,variant)
 mi_hat <- z$mi_anchor[fi]*exp(rate[fi]*(h-z$ah))
 td <- N+d$te-d$mi+mi_hat
 cf <- ifelse(valid & is.finite(d$mi) & is.finite(mi_hat) & is.finite(td) & td>0,N/td,NA_real_)
 use <- z$use & is.finite(official) & is.finite(cf) & weights[fi]>0
 ww <- weights[fi[use]]
 D <- if(any(use))weighted.mean(as.numeric(official[use]<=.7)-as.numeric(cf[use]<=.7),ww) else NA_real_
 density <- function(x) {
  ix <- findInterval(x,edges,rightmost.closed=TRUE)
  inside <- use & is.finite(x) & !is.na(ix) & ix>0 & ix<length(edges)
  y <- numeric(length(mid))
  for(j in which(inside))y[ix[j]] <- y[ix[j]]+weights[fi[j]]
  fit_counts(y)$b[1]
 }
 list(D_trend=D,b_trend=if(any(use))density(cf) else NA_real_,
  b_official_paired=if(any(use))density(official) else NA_real_,
  rate=rate,cf=cf,use=use,n=sum(weights[fi[use]]),firms=nf(d$firm_id[use]),
  n_in_range=sum(weights[fi[use & cf>=.4 & cf<=1]]),
  fallback_firms=sum(!is.finite(z$own_rate)&weights>0),
  missing_trend_firms=sum(!is.finite(rate)&weights>0))
}
trend_rows <- trend_draws <- trend_audit <- list(); trend_results <- list()
for(anchor in c('2019-12-31','2016-12-31','2017-06-30')) {
 z <- trend_setup(anchor)
 for(variant in c('firm_trend','bin_trend')) {
  point <- trend_estimate(z,rep(1L,G),variant)
  boot <- lapply(seq_len(B),function(j)trend_estimate(z,w[,j],variant))
  key <- paste(anchor,variant)
  trend_results[[key]] <- list(point=point,boot=boot,z=z)
  reason <- if(!any(is.finite(z$own_rate)))'unavailable_no_firm_with_four_positive_pre_MI_observations' else
   if(!point$n)'unavailable_no_eligible_counterfactual_pairs' else 'estimated'
  for(metric in c('D_trend','b_trend')) {
   draws <- vapply(boot,function(a)a[[metric]],numeric(1)); st <- summary_boot(draws)
   if(!is.finite(point[[metric]]))st[c('se','ci_low','ci_high')] <- NA_real_
   trend_rows[[length(trend_rows)+1L]] <- data.frame(row_type='level',anchor=anchor,
    variant=variant,metric=metric,estimate=point[[metric]],as.list(st),
    n=point$n,firms=point$firms,n_in_range=if(metric=='b_trend')point$n_in_range else NA_integer_,
    b_official_paired=point$b_official_paired,benchmark_anchor=NA_character_,benchmark_n=NA_integer_,
    benchmark_firms=NA_integer_,candidate_dates=sum(z$use),candidate_firms=nf(d$firm_id[z$use]),
    trend_donor_firms=sum(is.finite(z$own_rate)),fallback_firms=point$fallback_firms,
    fallback_firms_in_window=sum(!is.finite(z$own_rate)&firms %in% d$firm_id[z$use]),
    missing_trend_firms=point$missing_trend_firms,
    max_pre_observations=max(z$npre),bootstrap_draws=B,status=reason,
    inference_status=status(point[[metric]],draws),row.names=NULL)
   trend_draws[[length(trend_draws)+1L]] <- data.frame(anchor=anchor,variant=variant,metric=metric,
    draw=seq_len(B),estimate=draws,n=vapply(boot,`[[`,numeric(1),'n'),
    firms=vapply(boot,`[[`,integer(1),'firms'),
    missing_trend_firms=vapply(boot,`[[`,integer(1),'missing_trend_firms'))
  }
  trend_audit[[length(trend_audit)+1L]] <- data.frame(anchor=anchor,variant=variant,firm_id=firms,
   rl1_anchor=z$rl_anchor,rl1_bin=z$bin,mi_anchor=z$mi_anchor,
   pre_observations=z$npre,pre_nonpositive=z$bad,first_pre_date=z$first,last_pre_date=z$last,
   own_halfyear_log_trend=z$own_rate,used_halfyear_log_trend=point$rate,
   fallback=!is.finite(z$own_rate),missing_trend=!is.finite(point$rate),
   post_eligible_dates=vapply(firms,function(id)sum(point$use & d$firm_id==id),integer(1)))
  cat(sprintf('T043 trend: anchor=%s; variant=%s; donors=%d; fallback=%d; pairs=%d/%d firms; D=%.6f; b=%.6f; %s.\n',
   anchor,variant,sum(is.finite(z$own_rate)),point$fallback_firms,point$n,point$firms,
   point$D_trend,point$b_trend,reason))
 }
}
trend <- do.call(rbind,trend_rows)
for(anchor in c('2016-12-31','2017-06-30'))for(variant in c('firm_trend','bin_trend')) {
 main <- trend_results[[paste('2019-12-31',variant)]]
 placebo <- trend_results[[paste(anchor,variant)]]
 for(metric in c('D_trend','b_trend')) {
  draws <- vapply(main$boot,function(a)a[[metric]],numeric(1))-
   vapply(placebo$boot,function(a)a[[metric]],numeric(1))
  r <- trend[trend$row_type=='level' & trend$anchor=='2019-12-31' & trend$variant==variant & trend$metric==metric,]
  r$row_type <- 'post_minus_placebo'; r$benchmark_anchor <- anchor
  r$benchmark_n <- placebo$point$n; r$benchmark_firms <- placebo$point$firms
  r$estimate <- main$point[[metric]]-placebo$point[[metric]]
  st <- summary_boot(draws)
  for(nm in names(st))r[[nm]] <- st[[nm]]
  r$status <- if(is.finite(r$estimate))'estimated' else 'unavailable_placebo_trend_not_identified_from_available_history'
  r$inference_status <- status(r$estimate,draws)
  trend <- rbind(trend,r)
 }
}
csv(trend,'trend_cf'); csv(do.call(rbind,trend_draws),'trend_draws'); csv(do.call(rbind,trend_audit),'trend_firms')
tex('trend_cf',c('Anchor / variant / statistic','N','Firms','Estimate','95\\% CI','Fallback'),
 vapply(seq_len(nrow(trend)),function(i){z<-trend[i,];texrow(c(
  paste(if(z$row_type=='level')z$anchor else paste('Post minus',z$benchmark_anchor),
   if(z$variant=='firm_trend')'own' else 'bin',if(z$metric=='D_trend')'D' else 'b'),
  z$n,z$firms,fmt(z$estimate),ci(z$ci_low,z$ci_high),z$fallback_firms))},character(1)),
 'lrrrrr',paste('Main sample; 999 whole-firm draws, seed 20261016; pointwise percentile CIs. Descriptive, no causal interpretation.',
 'MI counterfactual = anchor MI times exp(g times elapsed half-years). D is official minus trend-adjusted compliance; b is adjusted-RL1 excess mass.',
 'Firm g = total log MI change / elapsed half-years over the inclusive preceding three years; at least four finite MI observations and no observed nonpositive MI required.',
 'Failed firm trends use the median eligible firm trend in the anchor RL1 bin. The bin variant uses that median for all firms.',
 'Bins: [0.60,0.66), [0.66,0.74), [0.74,0.80], other (including missing RL1). No bin donor means missing; no global fallback.',
 'Each draw re-estimates bin medians with firm multiplicities, eligible pairs and polynomial fits. Own-history sufficient statistics are invariant to firm duplication.',
 'Outcome horizons: anchor+2 through +6 half-years. Panel begins end-2016: placebo anchors have at most one/two pre observations; estimates and contrasts are unavailable, not zero.',
 'Fallback counts are full-universe firms failing the own-trend rule. CSVs retain paired official b, coverage, exclusions and all draws.',
 'Extrapolation, smooth density, reporting selection and stable within-firm currency are assumptions. The unavailable placebo prevents a post-minus-pre inference.'),chunk=12L)

# Guards and reproducible evidence, covering all pre-existing non-T043 outputs.
stopifnot(nrow(delta)==15L,nrow(integ)==11L,nrow(sim_rows)==12L,nrow(hetero)==12L,nrow(backing)==12L,nrow(trend)==20L,
 all(sources$pdf_page[is.finite(sources$value_used_rmb)]!='missing'),
 identical(input_hash,tools::sha256sum(inputs)),identical(protected_hash,tools::sha256sum(protected)))
csv(data.frame(kind=c(rep('input',length(inputs)),rep('protected_output',length(protected))),
 path=c(inputs,protected),sha256=c(unname(input_hash),unname(protected_hash)),unchanged=TRUE),'input_output_guards')
for(z in staged)stopifnot(file.copy(z[['path']],z[['target']],overwrite=TRUE))
unlink(vapply(staged,`[[`,character(1),'path'))
cat(sprintf('T043 guards PASS: %d inputs and %d protected outputs byte-identical.\n',length(inputs),length(protected)))
cat(sprintf('T043 complete: %d staged files; seed=%d; draws=%d.\n',length(staged),seed,B))
