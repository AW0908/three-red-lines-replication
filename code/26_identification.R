#!/usr/bin/env Rscript
# T077: outcome-informed extension, approved by PI. Run from replication/.
# Verify that saved RL1 follows the original accounting identity, before projection.
# Multinomial multiplicities resample full firm histories, jointly across outcomes.
# Independent reconstruction from SAVED group/date means.
# Independently average each primary firm's pre/post change, then groups.
# Distribution bins: integer bin indexing avoids floating-point bin gaps/overlaps.

options(stringsAsFactors = FALSE, scipen = 999)

B <- 999L

seed <- 20261113L

set.seed(seed)

stopifnot(any(grepl("^status: (APPROVED|REWORK|EXECUTED|CANDIDATE|PASS|DELIVERED)$", readLines("../tasks/T077.md"))))

paths <- sort(unique(unlist(lapply(c("data", "outputs", "code", "../Daten", "../proposal", "../presentation", 
    "../public_release", "../state", "../protocols"), list.files, recursive = TRUE, full.names = TRUE, 
    all.files = TRUE))))

paths <- paths[!dir.exists(paths) & !grepl("(^|/)t077_|code/26_identification[.]R$", paths)]

before <- tools::md5sum(paths)

wr <- function(x, n) write.csv(x, paste0("outputs/tables/t077_", n, ".csv"), row.names = FALSE, na = "NA", 
    eol = "\n")

read <- function(p) read.csv(p, check.names = FALSE)

source("code/theme_proposal.R")

dates <- c("2016-12-31", as.vector(rbind(paste0(2017:2022, "-06-30"), paste0(2017:2022, "-12-31"))))

pre <- dates[2:7]

post <- dates[9:13]

ref <- "2019-12-31"

dyn <- c(pre[pre != ref], post)

stopifnot(length(dyn) == 10L)

win <- function(r, l, u) as.numeric(r >= l & r < u)

yfun <- function(r) {
    L <- win(r, 0.66, 0.7)
    U <- win(r, 0.7, 0.74)
    P60 <- win(r, 0.56, 0.6)
    P80 <- win(r, 0.76, 0.8)
    cbind(L = L, U = U, S = L + U, P60 = P60, P80 = P80, Z = L - (P60 + P80)/2, Z60 = L - P60, Z80 = L - 
        P80, RL1 = r)
}

metrics <- colnames(yfun(0.7))

ep <- yfun(c(0.56, 0.6, 0.66, 0.7, 0.74, 0.76, 0.8))

stopifnot(all(ep[, "L"] == c(0, 0, 1, 0, 0, 0, 0)), all(ep[, "U"] == c(0, 0, 0, 1, 0, 0, 0)), all(ep[, 
    "P60"] == c(1, 0, 0, 0, 0, 0, 0)), all(ep[, "P80"] == c(0, 0, 0, 0, 0, 1, 0)))

d <- read("data/processed/panel_firm_halfyear.csv")

d <- d[!is.na(d$sample_main) & d$sample_main & d$date %in% dates, ]

a <- read.csv("outputs/tables/t061_control_panel.csv", colClasses = c(code = "character"))

a <- a[a$date %in% dates, ]

a$market <- "A"

h <- read.csv("outputs/tables/t076_hk_panel.csv", colClasses = c(code = "character"))

m <- read.csv("outputs/tables/t076_hk_membership.csv", colClasses = c(code = "character"))

stopifnot(!anyDuplicated(m$code), all(h$code %in% m$code[m$eligible]))

h <- h[h$code %in% m$code[m$eligible & m$balanced_13] & h$date %in% dates, ]

h$market <- "HK"

norm <- function(x, g) {
    stopifnot(!anyDuplicated(x[c("firm_id", "date")]), !anyNA(x$adv_missing))
    data.frame(firm_id = x$firm_id, date = x$date, market = x$market, group = g, rl1 = x$rl1, adv_missing = x$adv_missing)
}

ratio_errors <- c(developer = max(abs(d$rl1 - (d$tl - d$adv)/(d$ta - d$adv)), na.rm = TRUE), A_control = max(abs(a$rl1 - 
    (a$TOTAL_LIABILITIES - a$adv)/(a$TOTAL_ASSETS - a$adv)), na.rm = TRUE), HK_control = max(abs(h$rl1 - 
    (h$TOTAL_LIABILITIES - h$adv)/(h$TOTAL_ASSETS - h$adv)), na.rm = TRUE))

stopifnot(all(is.finite(ratio_errors)), all(ratio_errors < 1e-10))

wr(data.frame(group = names(ratio_errors), max_absolute_error = unname(ratio_errors)), "ratio_validation")

d <- norm(d, "developer")

a <- norm(a, "control")

h <- norm(h, "control")

stopifnot(all(d$market %in% c("A", "HK")), !any(a$firm_id %in% d$firm_id), !any(h$firm_id %in% d$firm_id))

bal <- function(x) {
    z <- split(x, x$firm_id)
    sort(names(z)[vapply(z, function(q) nrow(q) == 13L && setequal(q$date, dates) && all(is.finite(q$rl1)), 
        logical(1))])
}

stopifnot(setequal(bal(a), unique(a$firm_id)), setequal(bal(h), unique(h$firm_id)))

primary <- rbind(d[d$firm_id %in% bal(d), ], a, h)

ni <- function(x) {
    ids <- names(which(vapply(split(x$adv_missing, x$firm_id), function(z) all(!z), logical(1))))
    x[x$firm_id %in% ids, ]
}

sc <- list(primary = primary, unbalanced_developers = rbind(d[is.finite(d$rl1), ], a, h), HK_no_imputation = ni(primary[primary$market == 
    "HK", ]))

analysis <- do.call(rbind, lapply(names(sc), function(s) {
    x <- sc[[s]]
    x$scenario <- s
    x
}))

analysis <- analysis[order(analysis$scenario, analysis$market, analysis$group, analysis$firm_id, analysis$date), 
    ]

rownames(analysis) <- NULL

wr(analysis, "analysis_panel")

wr(data.frame(key = c("status", "seed", "B", "reference", "pre", "post", "outcome", "population", "windows", 
    "known_results", "dynamic_order", "unbalanced_weights", "Holm_family"), value = c("outcome-informed extension; fixed before T077 execution", 
    seed, B, ref, paste(pre, collapse = ";"), paste(post, collapse = ";"), "Z=L-(P60+P80)/2; developer change minus control change, pp", 
    "finite RL1 at all 13 endpoints; reporting-complete survivors", "L=[.66,.70);U=[.70,.74);P60=[.56,.60);P80=[.76,.80)", 
    "T066/T076 and 0.60/0.80 placebos known at design", paste(dyn, collapse = ";"), "equal dates; equal observed-firm weights within date; changing composition", 
    "two primary market contrasts")), "specification")

support <- list()

components <- list()

membership <- list()

k <- 0L

for (s in names(sc)) for (mkt in sort(unique(sc[[s]]$market))) for (g in c("developer", "control")) {
    x <- sc[[s]]
    x <- x[x$market == mkt & x$group == g, ]
    membership[[length(membership) + 1L]] <- data.frame(scenario = s, market = mkt, group = g, firms = length(unique(x$firm_id)), 
        rows = nrow(x), balanced = all(table(x$firm_id) == 13L))
    for (dt in dates) {
        q <- x[x$date == dt & is.finite(x$rl1), ]
        y <- yfun(q$rl1)
        for (v in metrics) {
            k <- k + 1L
            cnt <- if (v %in% c("L", "U", "S", "P60", "P80")) 
                sum(y[, v])
            else NA_real_
            support[[k]] <- data.frame(scenario = s, market = mkt, group = g, date = dt, outcome = v, 
                n = nrow(q), firms = length(unique(q$firm_id)), window_observations = cnt, window_unique_firms = cnt, 
                sparse = if (is.na(cnt)) 
                  NA
                else cnt < 10, zero_cell = if (is.na(cnt)) 
                  NA
                else cnt == 0, adv_missing = sum(q$adv_missing), below_plot = sum(q$rl1 < 0.4), above_plot = sum(q$rl1 > 
                  1))
            components[[k]] <- data.frame(scenario = s, market = mkt, group = g, date = dt, outcome = v, 
                mean = if (nrow(q)) 
                  mean(y[, v])
                else NA_real_)
        }
    }
}

support <- do.call(rbind, support)

components <- do.call(rbind, components)

wr(support, "support")

wr(components, "components")

wr(do.call(rbind, membership), "membership")

build <- function(x, W = NULL) {
    ids <- sort(unique(x$firm_id))
    n <- length(ids)
    if (!n) 
        return(NULL)
    Y <- array(NA_real_, c(n, 13, length(metrics)), dimnames = list(ids, dates, metrics))
    yy <- yfun(x$rl1)
    for (j in seq_along(metrics)) Y[cbind(match(x$firm_id, ids), match(x$date, dates), j)] <- yy[, j]
    if (is.null(W)) W <- cbind(rep(1, n), rmultinom(B, n, rep(1/n, n)))
    stopifnot(nrow(W) == n, all(is.finite(W)), all(W >= 0), all(W == floor(W)))
    stopifnot(all(colSums(W) == n))
    den <- crossprod(W, 1 * is.finite(Y[, , 1]))
    mu <- array(NA_real_, c(ncol(W), 13, length(metrics)))
    for (j in seq_along(metrics)) {
        z <- Y[, , j]
        z[!is.finite(z)] <- 0
        mu[, , j] <- crossprod(W, z)/den
    }
    # Check an actual resampled history, including missing dates and every outcome.
    # This is additional validation only; it consumes no random numbers.
    b <- min(2L, ncol(W))
    expanded <- Y[rep(seq_len(n), W[, b]), , , drop = FALSE]
    explicit <- apply(expanded, c(2, 3), mean, na.rm = TRUE)
    history_check <- isTRUE(all.equal(unname(mu[b, , ]), unname(explicit),
                                     tolerance = 1e-12, check.attributes = FALSE))
    list(Y = Y, mu = mu, n = n, W = W, history_check = history_check)
}

# Shared production contrast path, also exercised by the known-answer fixtures.
period_contrast <- function(diff, j) {
    rowMeans(diff[, match(post, dates), j]) - rowMeans(diff[, match(pre, dates), j])
}

reference_contrast <- function(diff, j) {
    diff[, , j] - diff[, match(ref, dates), j]
}

ci <- function(z) {
    z <- z[is.finite(z)]
    if (!length(z)) 
        c(NA_real_, NA_real_)
    else as.numeric(quantile(z, c(0.025, 0.975)))
}

pboot <- function(z, e) {
    z <- z[is.finite(z)]
    if (!length(z)) 
        NA_real_
    else (1 + sum(abs(z - e) >= abs(e)))/(length(z) + 1)
}

est <- list()

dynamic <- list()

draws <- list()

covs <- list()

diagout <- list()

sens <- list()

for (s in names(sc)) for (mkt in sort(unique(sc[[s]]$market))) {
    x <- sc[[s]]
    x <- x[x$market == mkt, ]
    dv <- build(x[x$group == "developer", ])
    ct <- build(x[x$group == "control", ])
    if (is.null(dv) || is.null(ct)) {
        est[[length(est) + 1L]] <- data.frame(scenario = s, market = mkt, outcome = metrics, estimate_pp = NA_real_, 
            se_pp = NA_real_, ci_low_pp = NA_real_, ci_high_pp = NA_real_, p_raw = NA_real_, valid_draws = 0L, 
            failed_draws = B, status = "NOT ESTIMABLE: empty group")
        next
    }
    diff <- dv$mu - ct$mu
    for (j in seq_along(metrics)) {
        z <- period_contrast(diff, j)
        ii <- ci(z[-1])
        good <- is.finite(z[-1])
        est[[length(est) + 1L]] <- data.frame(scenario = s, market = mkt, outcome = metrics[j], estimate_pp = 100 * 
            z[1], se_pp = 100 * sd(z[-1][good]), ci_low_pp = 100 * ii[1], ci_high_pp = 100 * ii[2], p_raw = pboot(z[-1], 
            z[1]), valid_draws = sum(good), failed_draws = sum(!good), status = if (all(good)) 
            "OK"
        else "FAILED DRAWS DISCLOSED")
        dd <- reference_contrast(diff, j)
        for (t in seq_along(dates)) {
            it <- ci(dd[-1, t])
            dynamic[[length(dynamic) + 1L]] <- data.frame(scenario = s, market = mkt, outcome = metrics[j], 
                date = dates[t], estimate_pp = 100 * dd[1, t], se_pp = 100 * sd(dd[-1, t], na.rm = TRUE), 
                ci_low_pp = 100 * it[1], ci_high_pp = 100 * it[2], sim_low_pp = NA_real_, sim_high_pp = NA_real_, 
                role = if (dates[t] %in% dyn) 
                  "inference_family"
                else if (dates[t] == ref) 
                  "reference"
                else "descriptive", valid_draws = sum(is.finite(dd[-1, t])))
        }
        draws[[length(draws) + 1L]] <- data.frame(scenario = s, market = mkt, outcome = metrics[j], draw = 1:B, 
            contrast_pp = 100 * z[-1])
        if (metrics[j] == "Z") {
            dy <- dd[, match(dyn, dates), drop = FALSE]
            colnames(dy) <- dyn
            wr(data.frame(scenario = s, market = mkt, draw = 1:B, 100 * dy[-1, , drop = FALSE], check.names = FALSE), 
                paste0("dynamic_draws_", s, "_", mkt))
            vb <- cov(dy[-1, , drop = FALSE], use = "complete.obs")
            ses <- sqrt(diag(vb))
            ok <- apply(dy[-1, , drop = FALSE], 1, function(z) all(is.finite(z)))
            crit <- NA_real_
            if (all(is.finite(ses) & ses > 0) && any(ok)) {
                centered <- sweep(dy[-1, , drop = FALSE], 2, dy[1, ], "-")
                mx <- apply(abs(sweep(centered[ok, , drop = FALSE], 2, ses, "/")), 1, max)
                crit <- unname(quantile(mx, 0.95))
                for (i in seq_along(dynamic)) if (dynamic[[i]]$scenario == s && dynamic[[i]]$market == 
                  mkt && dynamic[[i]]$outcome == "Z" && dynamic[[i]]$date %in% dyn) {
                  t <- match(dynamic[[i]]$date, dyn)
                  dynamic[[i]]$sim_low_pp <- 100 * (dy[1, t] - crit * ses[t])
                  dynamic[[i]]$sim_high_pp <- 100 * (dy[1, t] + crit * ses[t])
                }
            }
            vl <- matrix(NA_real_, 10, 10)
            if (all(is.finite(dv$Y)) && all(is.finite(ct$Y)) && dv$n > 1 && ct$n > 1) {
                dz <- dv$Y[, , "Z"]
                cz <- ct$Y[, , "Z"]
                fd <- dz[, match(dyn, dates), drop = FALSE] - dz[, match(ref, dates)]
                fc <- cz[, match(dyn, dates), drop = FALSE] - cz[, match(ref, dates)]
                vl <- cov(fd)/dv$n + cov(fc)/ct$n
            }
            for (kind in c("bootstrap", "linear_firm")) {
                v <- if (kind == "bootstrap") 
                  vb
                else vl
                cv <- expand.grid(row_date = dyn, col_date = dyn, stringsAsFactors = FALSE)
                cv$scenario <- s
                cv$market <- mkt
                cv$kind <- kind
                cv$covariance_probability_squared <- as.vector(v)
                covs[[length(covs) + 1L]] <- cv
            }
            eig <- if (all(is.finite(vl))) 
                eigen(vl, symmetric = TRUE, only.values = TRUE)$values
            else rep(NA_real_, 10)
            vp <- vb[1:5, 1:5, drop = FALSE]
            bp <- dy[1, 1:5]
            rk <- if (all(is.finite(vp))) 
                qr(vp)$rank
            else NA_integer_
            wald <- if (!is.na(rk) && rk == 5) 
                as.numeric(crossprod(bp, solve(vp, bp)))
            else NA_real_
            diagout[[length(diagout) + 1L]] <- data.frame(scenario = s, market = mkt, n_developer = dv$n, 
                n_control = ct$n, sim_valid = sum(ok), sim_critical = crit, pre_rank = rk, pre_wald = wald, 
                pre_p = if (is.finite(wald)) 
                  pchisq(wald, 5, lower.tail = FALSE)
                else NA_real_, linear_cov_rank = if (all(is.finite(vl))) 
                  qr(vl)$rank
                else NA_integer_, linear_cov_min_eigen = min(eig), firm_histories_resampled = dv$history_check && 
                  ct$history_check)
            sens[[length(sens) + 1L]] <- data.frame(scenario = s, market = mkt, Mbar = c(0, 0.5, 1, 1.5, 
                2), target = "mean five post Z coefficients vs 2019H2", status = "NOT RUN", reason = if (!requireNamespace("HonestDiD", 
                quietly = TRUE)) 
                "HonestDiD not installed locally; no worker downloads"
            else "Separate method validation required", ci_low_pp = NA_real_, ci_high_pp = NA_real_)
        }
    }
    cat("T077 estimated", s, mkt, "firms", dv$n, ct$n, "\n")
}

est <- do.call(rbind, est)

est$p_holm_primary <- NA_real_

ix <- which(est$scenario == "primary" & est$outcome == "Z")

stopifnot(length(ix) == 2)

est$p_holm_primary[ix] <- p.adjust(est$p_raw[ix], "holm", n = 2)

dynamic <- do.call(rbind, dynamic)

draws <- do.call(rbind, draws)

diagout <- do.call(rbind, diagout)

wr(est, "estimates")

wr(dynamic, "dynamics")

wr(draws, "bootstrap_draws")

wr(do.call(rbind, covs), "covariance")

wr(diagout, "diagnostics")

wr(do.call(rbind, sens), "trend_sensitivity")

cells <- read("outputs/tables/t077_components.csv")

validation <- list()

for (i in seq_len(nrow(est))) {
    e <- est[i, ]
    q <- cells[cells$scenario == e$scenario & cells$market == e$market & cells$outcome == e$outcome, 
        ]
    gm <- function(g, t) mean(q$mean[q$group == g & q$date %in% t])
    ind <- 100 * ((gm("developer", post) - gm("developer", pre)) - (gm("control", post) - gm("control", 
        pre)))
    err <- abs(ind - e$estimate_pp)
    validation[[i]] <- data.frame(check = "saved_cell_reconstruction", scenario = e$scenario, market = e$market, 
        outcome = e$outcome, value = err, pass = if (is.na(err)) 
            is.na(e$estimate_pp)
        else err < 1e-10)
}

# Rework 1: hard known-answer tests through the production functions.
# All estimation above is complete. These deterministic fixtures do not use RNG.
add_validation <- function(check, value, pass, outcome = "Z", scenario = "synthetic", market = "NA") {
    validation[[length(validation) + 1L]] <<- data.frame(check = check, scenario = scenario,
        market = market, outcome = outcome, value = value, pass = pass)
}
zd <- rbind(c(0,0,1,0,-.5,1,-.5,1,1,0,1,-.5,1),
            c(1,0,0,-.5,0,0,1,0,1,1,0,1,0),
            c(-.5,1,-.5,1,0,-.5,0,-.5,0,-.5,1,1,1))
zc <- rbind(c(0,0,0,0,0,0,0,1,0,0,0,0,0),
            c(0,0,-.5,0,-.5,0,0,0,0,0,1,0,-.5),
            c(0,1,0,0,0,0,0,-.5,-.5,0,0,0,0))
fixture <- function(z, prefix) {
    q <- expand.grid(firm_id = paste0(prefix, 1:3), date = dates)
    q$rl1 <- ifelse(as.vector(z) == 1, .68, ifelse(as.vector(z) == -.5, .58, .72))
    # Exercise both placebo regions, without changing the known Z values.
    q$rl1[as.vector(z) == -.5 & seq_len(nrow(q)) %% 2 == 0] <- .78
    q
}
sdpanel <- fixture(zd, "D")
scpanel <- fixture(zc, "C")
Wd <- cbind(c(1,1,1), c(2,1,0), c(0,1,2))
Wc <- cbind(c(1,1,1), c(0,2,1), c(1,0,2))
sdresult <- build(sdpanel, Wd)
scresult <- build(scpanel, Wc)
sdiff <- sdresult$mu - scresult$mu
# Independent hand-tallied rational answers; rows are the original and two draws.
expected_theta <- c(71/180, 11/36, 103/180)
expected_dynamic <- rbind(c(-1/6,1/6,0,-1/6,0,2/3,0,1/6,1/3,2/3),
                          c(-1/3,1,-1/6,0,2/3,7/6,1/3,0,0,1),
                          c(-1/3,-2/3,1/6,-1/3,-2/3,1/3,-1/3,1/3,2/3,1/3))
jz <- match("Z", metrics)
err <- max(abs(period_contrast(sdiff, jz) - expected_theta))
add_validation("synthetic_known_contrast", err, err < 1e-12)
sdynamic <- reference_contrast(sdiff, jz)
err <- max(abs(sdynamic[, match(dyn, dates)] - expected_dynamic))
add_validation("synthetic_known_dynamic", err, err < 1e-12)
err <- max(abs(sdynamic[, match(ref, dates)]))
add_validation("synthetic_reference_zero", err, err < 1e-12)

# Explicitly copy complete histories with new identities, then rebuild with unit weights.
copy_histories <- function(x, w) {
    ids <- sort(unique(x$firm_id))
    chosen <- rep(ids, w)
    do.call(rbind, lapply(seq_along(chosen), function(i) {
        q <- x[x$firm_id == chosen[i], ]
        q$firm_id <- paste0("copy", i)
        q
    }))
}
for (population in c("balanced", "missing_dates")) {
    xd <- sdpanel
    xc <- scpanel
    if (population == "missing_dates") {
        xd <- xd[!(xd$firm_id == "D1" & xd$date %in% dates[c(3, 10)]), ]
        xc <- xc[!(xc$firm_id == "C3" & xc$date == ref), ]
    }
    bd <- build(xd, Wd)
    bc <- build(xc, Wc)
    maxerr <- 0
    for (k in seq_len(ncol(Wd))) {
        ed <- build(copy_histories(xd, Wd[, k]), matrix(1, 3, 2))
        ec <- build(copy_histories(xc, Wc[, k]), matrix(1, 3, 2))
        maxerr <- max(maxerr, abs(bd$mu[k, , ] - ed$mu[1, , ]),
                      abs(bc$mu[k, , ] - ec$mu[1, , ]))
        fd <- bd$mu - bc$mu
        fe <- ed$mu - ec$mu
        for (j in seq_along(metrics)) {
            maxerr <- max(maxerr, abs(period_contrast(fd, j)[k] - period_contrast(fe, j)[1]),
                abs(reference_contrast(fd, j)[k, ] - reference_contrast(fe, j)[1, ]))
        }
    }
    add_validation("firm_histories_resampled", maxerr,
        maxerr < 1e-12 && bd$history_check && bc$history_check,
        outcome = "all outcomes and dates", scenario = population)
}
# A date-specific switch of multiplicities must be detected by this fixture.
wrong <- sdresult$mu[2, , ]
wrong[2, ] <- sdresult$mu[3, 2, ]
gap <- max(abs(wrong - sdresult$mu[2, , ]))
add_validation("datewise_resampling_negative_control", gap, gap > 1e-6)

bounds <- list(L = c(.66,.70), U = c(.70,.74), S = c(.66,.74),
               P60 = c(.56,.60), P80 = c(.76,.80))
for (v in names(bounds)) {
    lo <- bounds[[v]][1]; hi <- bounds[[v]][2]
    actual <- yfun(c(lo - 1e-8, lo, lo + 1e-8, hi - 1e-8, hi, hi + 1e-8))[, v]
    err <- max(abs(actual - c(0,1,1,1,0,0)))
    add_validation("half_open_boundaries", err, err == 0, outcome = v,
                   scenario = "all", market = "all")
}

for (mkt in c("A", "HK")) for (v in metrics) {
    x <- primary[primary$market == mkt, ]
    x$y <- yfun(x$rl1)[, v]
    byfirm <- lapply(split(x, x$firm_id), function(q) data.frame(group = q$group[1], change = mean(q$y[q$date %in% 
        post]) - mean(q$y[q$date %in% pre])))
    z <- do.call(rbind, byfirm)
    e <- est$estimate_pp[est$scenario == "primary" & est$market == mkt & est$outcome == v]
    error <- abs(100 * (mean(z$change[z$group == "developer"]) - mean(z$change[z$group == "control"])) - 
        e)
    validation[[length(validation) + 1L]] <- data.frame(check = "independent_equal_firm_weighting", scenario = "primary", 
        market = mkt, outcome = v, value = error, pass = error < 1e-10)
}

validation <- do.call(rbind, validation)

stopifnot(all(validation$pass))

wr(validation, "validation")

bins <- list()

for (s in names(sc)) for (mkt in unique(sc[[s]]$market)) for (g in c("developer", "control")) for (p in c("pre", 
    "post")) for (dt in get(p)) {
    x <- sc[[s]]
    r <- x$rl1[x$market == mkt & x$group == g & x$date == dt]
    n <- length(r)
    inside <- r >= 0.4 & r <= 1
    bin <- pmin(60L, findInterval(r[inside], seq(0.4, 1, length.out = 61), rightmost.closed = TRUE))
    cnt <- tabulate(bin, nbins = 60)
    stopifnot(sum(cnt) + sum(r < 0.4) + sum(r > 1) == n)
    bins[[length(bins) + 1L]] <- data.frame(scenario = s, market = mkt, group = g, period = p, date = dt, 
        lower = 0.4 + (0:59) * 0.01, count = cnt, n = n, probability = if (n) 
            cnt/n
        else NA_real_, below = sum(r < 0.4), above = sum(r > 1))
}

bins <- do.call(rbind, bins)

wr(bins, "density_bins")

# Rework 1: sparse and zero markers derive only from saved support definitions.
# Z/dynamic flags are unions of their constituent cells, not counts of Z itself.
flag_cells <- function(mkt, groups, outcomes, timepoints) {
    q <- support[support$scenario == "primary" & support$market == mkt &
        support$group %in% groups & support$outcome %in% outcomes & support$date %in% timepoints, ]
    stopifnot(nrow(q) == length(groups) * length(outcomes) * length(timepoints),
              !anyNA(q$sparse), !anyNA(q$zero_cell))
    c(sparse = any(q$sparse), zero = any(q$zero_cell))
}
flag_symbol <- function(flags, group = "developer") {
    if (flags["zero"]) 4 else if (flags["sparse"]) {
        if (group == "developer") 1 else 2
    } else if (group == "developer") 16 else 17
}
figure_key <- function(distribution = FALSE, dynamic_plot = FALSE) {
    par(oma = c(0, 0, 0, 0), fig = c(0, 1, .01, .105),
        mar = c(0, 0, 0, 0), new = TRUE)
    plot.new()
    if (distribution) {
        legend("center", c("Pre", "Post", "Sparse window (1-9)", "Zero window"),
            col = c("grey50", proposal_col["primary"], "grey30", "grey30"),
            lty = c(2,1,NA,NA), pch = c(NA,NA,1,4), ncol = 4, bty = "n", cex = .85)
    } else if (dynamic_plot) {
        legend("center", c("Pointwise 95%", "Simultaneous 95%", ">=10", "Sparse (1-9)", "Zero cell"),
            col = c(proposal_col["primary"], "grey65", rep(proposal_col["primary"], 3)),
            lty = c(1,1,NA,NA,NA), lwd = c(1,3,1,1,1), pch = c(NA,NA,16,1,4),
            ncol = 5, bty = "n", cex = .8)
    } else {
        legend("center", c("Developers", "Controls", ">=10", "Sparse (1-9)", "Zero cell"),
            col = c(proposal_col["primary"], proposal_col["grey"], rep("grey30", 3)),
            lty = c(1,2,NA,NA,NA), pch = c(NA,NA,16,1,4), ncol = 5, bty = "n", cex = .85)
    }
}
pc <- components[components$scenario == "primary", ]
prob_max <- max(100 * pc$mean[pc$outcome %in% c("L", "U", "S")]) * 1.1
z_range <- range(100 * pc$mean[pc$outcome == "Z"]) * 1.15
pd <- dynamic[dynamic$scenario == "primary" & dynamic$outcome == "Z", ]
dynamic_range <- range(c(pd$ci_low_pp, pd$ci_high_pp, pd$sim_low_pp, pd$sim_high_pp), na.rm = TRUE)
pb <- bins[bins$scenario == "primary", ]
agg <- aggregate(probability ~ market + group + period + lower, pb, mean)
density_max <- max(agg$probability) * 100 * 1.1
notes <- list()
for (mkt in c("A", "HK")) {
    dc <- pc[pc$market == mkt, ]
    ns <- diagout[diagout$scenario == "primary" & diagout$market == mkt, ]
    count_title <- paste0(mkt, " | Developers n=", ns$n_developer, "; controls n=", ns$n_control)
    sample_note <- paste0("Primary fixed panel: ", ns$n_developer, " developers and ", ns$n_control,
        " controls with finite RL1 at all 13 endpoints (2016H2-2022H2). Reporting-complete survivors; ",
        "controls selected from current listings. These populations do not represent all developers or delisted controls.")
    file <- paste0("t077_probabilities_", mkt, ".pdf")
    proposal_pdf(paste0("outputs/figures/", file), width = 10, height = 7.8)
    par(mfrow = c(2, 2), oma = c(3.2, 0, 0, 0), mar = c(4.3, 4.3, 3.6, 1))
    for (v in c("L", "U", "S", "Z")) {
        q <- dc[dc$outcome == v, ]
        yl <- if (v == "Z") z_range else c(0, prob_max)
        label <- switch(v, L = "Below: [0.66,0.70)", U = "Above: [0.70,0.74)",
            S = "Around: [0.66,0.74)", Z = "Target minus mean placebo probability")
        plot(1:13, rep(NA_real_, 13), type = "n", ylim = yl, xlim = c(.4,13.6), xaxt = "n",
            xlab = "", ylab = if (v == "Z") "Percentage points" else "Probability (%)",
            main = paste(count_title, label, sep = "\n"), cex.main = .87)
        axis(1, at = c(1,3,5,7,9,11,13), labels = proposal_halflabel(dates[c(1,3,5,7,9,11,13)]), cex.axis = .8)
        abline(v = 8.5, lty = 2, col = "grey60")
        for (g in c("developer", "control")) {
            z <- q[q$group == g, ]; z <- z[match(dates, z$date), ]
            color <- if (g == "developer") proposal_col["primary"] else proposal_col["grey"]
            outcomes <- if (v == "Z") c("L", "P60", "P80") else v
            symbols <- vapply(dates, function(dt) flag_symbol(flag_cells(mkt, g, outcomes, dt), g), numeric(1))
            lines(1:13, 100 * z$mean, col = color, lty = if (g == "developer") 1 else 2)
            points(1:13, 100 * z$mean, col = color, pch = symbols, cex = .9)
        }
    }
    figure_key(); dev.off()
    notes[[length(notes) + 1L]] <- data.frame(figure = file,
        caption = paste0("Equal-weight date probabilities; Z=L-(P60+P80)/2 is a probability contrast, not polynomial excess mass. ",
            "Markers: filled >=10 firms, hollow 1-9, cross zero. L/U/S flags use their own group/date window; ",
            "Z flags use any L/P60/P80 constituent window. Zero takes priority over sparse. ",
            "The same probability and Z scales are used across A and HK. The dashed line separates 2020H1 and 2020H2."),
        sample_note = sample_note)

    q <- pd[pd$market == mkt, ]; q <- q[match(dates, q$date), ]
    file <- paste0("t077_dynamic_", mkt, ".pdf")
    proposal_pdf(paste0("outputs/figures/", file), width = 9.5, height = 5.5)
    par(oma = c(3,0,0,0), mar = c(5,5,3.3,1))
    plot(1:13, q$estimate_pp, type = "n", ylim = dynamic_range, xlim = c(.7,13.3), xaxt = "n",
        xlab = "", ylab = "Z contrast vs 2019H2 (percentage points)", main = count_title, cex.main = .95)
    abline(h = 0, col = "grey60"); abline(v = 8.5, lty = 2, col = "grey60")
    segments(1:13, q$sim_low_pp, 1:13, q$sim_high_pp, col = "grey65", lwd = 3)
    segments(1:13, q$ci_low_pp, 1:13, q$ci_high_pp, col = proposal_col["primary"])
    symbols <- vapply(dates, function(dt) flag_symbol(flag_cells(mkt, c("developer", "control"),
        c("L", "P60", "P80"), unique(c(dt, ref)))), numeric(1))
    points(1:13, q$estimate_pp, pch = symbols, col = proposal_col["primary"])
    axis(1, at = 1:13, labels = proposal_halflabel(dates), las = 2, cex.axis = .78)
    figure_key(dynamic_plot = TRUE); dev.off()
    notes[[length(notes) + 1L]] <- data.frame(figure = file,
        caption = paste0("Developer-minus-control Z dynamics relative to 2019H2. Thin intervals are pointwise percentile 95%; ",
            "thick intervals are simultaneous 95% bands over five pre and five post dates. 2016H2 and 2020H1 are descriptive; ",
            "2019H2 is the zero reference. Markers flag any L/P60/P80 cell in either group at the displayed date OR reference: ",
            "filled >=10, hollow 1-9, cross zero (zero priority). Common scale across markets. ",
            "Bootstrap B=999, whole firms; intervals do not identify an economic-leverage or financing effect."),
        sample_note = sample_note)

    file <- paste0("t077_distributions_", mkt, ".pdf")
    proposal_pdf(paste0("outputs/figures/", file), width = 9.5, height = 7)
    par(mfrow = c(2,1), oma = c(3,0,0,0), mar = c(4,4.5,2.8,1))
    for (g in c("developer", "control")) {
        n <- if (g == "developer") ns$n_developer else ns$n_control
        plot(c(.4,1), c(0,density_max), type = "n", xlab = "RL1", ylab = "Mean date probability (%)",
            main = paste0(mkt, " | ", if (g == "developer") "Developers" else "Controls", " n=", n))
        abline(v = .7, lty = 2, col = proposal_col["dark"])
        for (p in c("pre", "post")) {
            z <- agg[agg$market == mkt & agg$group == g & agg$period == p, ]
            color <- if (p == "post") proposal_col["primary"] else "grey50"
            lines(z$lower + .005, 100 * z$probability, col = color, lty = if (p == "post") 1 else 2)
            # Mark all displayed bins in a sparse/zero defined window, rather than
            # mistaking bin counts for the per-date window counts in support.csv.
            for (i in seq_len(nrow(z))) {
                mid <- z$lower[i] + .005
                ww <- names(bounds)[vapply(bounds, function(b) mid >= b[1] && mid < b[2], logical(1))]
                if (!length(ww)) next
                flags <- flag_cells(mkt, g, ww, get(p))
                if (flags["sparse"]) points(mid, 100 * z$probability[i], col = color,
                    pch = if (flags["zero"]) 4 else 1, cex = .8)
            }
        }
    }
    figure_key(distribution = TRUE); dev.off()
    notes[[length(notes) + 1L]] <- data.frame(figure = file,
        caption = paste0("Fixed 0.01 RL1 bins on [0.40,1.00], date probabilities averaged equally over pre 2017H1-2019H2 ",
            "and post 2020H2-2022H2. All finite-RL1 firms form the denominator, including tails outside the display; ",
            "tail counts are saved in t077_density_bins.csv and t077_support.csv. Common scale for both groups and markets. ",
            "Within L/U/S/P60/P80 windows, hollow markers flag any contributing group/date window with 1-9 firms; ",
            "crosses flag any zero window, taking priority. They describe window support, not individual bin counts. ",
            "Solid green is post; dashed grey is pre. Distributions are descriptive, not fitted excess mass."),
        sample_note = sample_note)
}
wr(do.call(rbind, notes), "figure_notes")

after <- tools::md5sum(paths)

stopifnot(identical(before, after))

wr(data.frame(path = names(before), md5_before = unname(before), md5_after = unname(after), unchanged = before == 
    after), "protected_files")

cat("T077 protected files unchanged:", length(paths), "\n")

cat("T077 cell reconstructions PASS; maximum error:", max(validation$value[validation$check == "saved_cell_reconstruction"]), 
    "\n")

print(est[ix, c("market", "estimate_pp", "ci_low_pp", "ci_high_pp", "p_raw", "p_holm_primary")], row.names = FALSE)

cat("T077 HonestDiD NOT RUN: verified local dependency unavailable; independent review pending.\n")

