# T011: the prespecified S0-S13 robustness checks; no specification search.
# Run from replication/: Rscript code/04_robustness.R
# Read-only: processed panel and T009 results (baseline validation).
# Identification requires parallel counterfactual trends across treatment levels;
# these checks do not establish that assumption or remove concurrent policies.

source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(stringsAsFactors = FALSE, digits = 7, width = 180)
invisible(Sys.setlocale("LC_NUMERIC", "C"))
for (pkg in c("fixest", "ggplot2")) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop("Required local package unavailable: ", pkg, "; no installation attempted.")
}
fixest::setFixest_nthreads(1)

outcomes <- c("rl1", "rl2", "rl2_gap", "mi_share", "jv_ta")
dates <- sort(c("2016-12-31", paste0(rep(2017:2022, each = 2),
                                   rep(c("-06-30", "-12-31"), 6))))
reference <- "2020-06-30"
pre_dates <- dates[dates < reference]
panel <- read.csv("data/processed/panel_firm_halfyear.csv", na.strings = "NA",
                  colClasses = c(firm_id = "character", date = "character"))
required <- c("firm_id", "date", "sample_main", "sample_broad", "has_row",
              "dose", "dose2018", "dose_pre", "distance", "dose_2020h1", "post", "n_breached", "rl3", "rl1_alt",
              "adv_missing", "fye_flag", "market", outcomes)
stopifnot(all(required %in% names(panel)), !anyDuplicated(panel[c("firm_id", "date")]),
          !anyNA(panel[c("firm_id", "date", "post", "has_row", "adv_missing", "fye_flag")]),
          identical(sort(unique(panel$date)), dates),
          all(panel$post == as.integer(panel$date >= "2020-12-31")))
panel$t_index <- match(panel$date, dates)
for (y in c(outcomes, "rl3", "rl1_alt", "n_breached"))
  stopifnot(all(is.na(panel[[y]]) | is.finite(panel[[y]])))

# T012: treatments come exclusively from 01_clean.R's published panel.
# These auxiliary sample flags retain the T011 definitions.
firm_rows <- lapply(split(panel, panel$firm_id), function(d) {
  data.frame(firm_id = d$firm_id[1], sample_main = d$sample_main[1], dose = d$dose[1],
             dose2018 = d$dose2018[1], dose_pre = d$dose_pre[1], distance = d$distance[1],
             balanced = all(dates %in% d$date[d$has_row]),
             no_adv_missing = !any(d$adv_missing), no_fye_flag = !any(d$fye_flag))
})
firms <- do.call(rbind, firm_rows)
rownames(firms) <- NULL
for (v in c("balanced", "no_adv_missing", "no_fye_flag"))
  panel[[v]] <- firms[[v]][match(panel$firm_id, firms$firm_id)]
for (v in c("dose", "dose2018", "dose_pre", "distance", "dose_2020h1"))
  stopifnot(all(vapply(split(panel[[v]], panel$firm_id),
                       function(x) length(unique(x)) == 1L, logical(1))))
stopifnot(all(is.na(firms$distance) | firms$distance >= 0),
          all(is.na(firms$dose_pre) | (firms$dose_pre >= 0 & firms$dose_pre <= 3)),
          all(is.na(firms$dose2018) | firms$dose2018 %in% 0:3))

# Summaries refer to main-sample firms with the respective treatment available.
# Correlations use pairwise complete firms; n_corr makes that denominator explicit.
definitions <- do.call(rbind, lapply(c("dose2018", "dose_pre", "distance"), function(v) {
  d <- firms[!is.na(firms$sample_main) & firms$sample_main, ]
  x <- d[[v]]
  ok <- !is.na(x)
  paired <- ok & !is.na(d$dose)
  qs <- stats::quantile(x[ok], c(0, .01, .25, .5, .75, .99, 1), type = 7)
  data.frame(treatment = v, sample = "sample_main", n_firms = sum(ok),
             n_missing = sum(!ok), mean = mean(x[ok]), sd = stats::sd(x[ok]),
             min = qs[1], p01 = qs[2], p25 = qs[3], median = qs[4], p75 = qs[5],
             p99 = qs[6], max = qs[7], n_0 = sum(x[ok] == 0),
             n_1 = sum(x[ok] == 1), n_2 = sum(x[ok] == 2), n_3 = sum(x[ok] == 3),
             n_corr = sum(paired), correlation_with_dose = stats::cor(x[paired], d$dose[paired]))
}))
rownames(definitions) <- NULL

baseline <- read.csv("outputs/tables/t009_did_main.csv")
baseline_pre <- read.csv("outputs/tables/t009_pretrend_tests.csv")
stopifnot(setequal(baseline$outcome, outcomes), setequal(baseline_pre$outcome, outcomes))
rows <- list()
events <- list()
legacy_validation <- TRUE

# Every call below starts from panel and changes only its named element.
# Replacing treatment also replaces the non-missing-treatment requirement;
# the original dose is NOT an additional selection filter for S1-S3 or S8.
# S5 quantiles are within date in the S0 sample (available y, type = 7).
run_spec <- function(spec, treatment = default_treatment, sample = "sample_main", trends = FALSE,
                     winsor = FALSE, keep = NULL, alternative_rl1 = FALSE) {
  d <- panel[!is.na(panel[[sample]]) & panel[[sample]] & !is.na(panel[[treatment]]), ]
  if (!is.null(keep)) d <- d[!is.na(d[[keep]]) & d[[keep]], ]
  for (y in outcomes) {
    source_y <- if (alternative_rl1 && y == "rl1") "rl1_alt" else y
    r <- data.frame(spec = spec, outcome = y, outcome_variable = source_y,
                    treatment = treatment, coefficient = NA_real_, std_error = NA_real_,
                    ci_lower = NA_real_, ci_upper = NA_real_, p_value = NA_real_,
                    N = NA_integer_, n_firms = NA_integer_, pretrend_p = NA_real_,
                    pretrend_p_before_2019 = NA_real_, pretrend_df = NA_integer_,
                    pretrend_df_before_2019 = NA_integer_, n_winsorised = 0L,
                    status = "estimated")
    if (alternative_rl1 && y != "rl1") {
      r$status <- "not_applicable"
      r$outcome_variable <- NA_character_
      rows[[length(rows) + 1L]] <<- r
      next
    }
    work <- d
    if (winsor) {
      # No treatment or flag is winsorised. Keep NAs and audit every date.
      for (date in dates) {
        idx <- which(work$date == date & !is.na(work[[y]]))
        if (!length(idx)) next
        original <- work[[y]][idx]
        cuts <- stats::quantile(original, c(.01, .99), type = 7, names = FALSE)
        clipped <- pmax(cuts[1], pmin(cuts[2], original))
        stopifnot(all(clipped >= cuts[1] & clipped <= cuts[2]))
        r$n_winsorised <- r$n_winsorised + sum(original != clipped)
        work[[y]][idx] <- clipped
      }
      stopifnot(identical(is.na(work[[y]]), is.na(d[[y]])))
      cat(sprintf("WINSORISED %s: %d values (within date, 1/99%%, type 7).\n", y, r$n_winsorised))
    }
    fe <- if (trends) "firm_id[t_index] + date" else "firm_id + date"
    # Estimate once to obtain the actual outcome-specific sample, with singleton
    # removal identical to T009. S4 includes firm intercepts AND linear slopes.
    model <- fixest::feols(
      stats::as.formula(paste(source_y, "~", paste0(treatment, ":post"), "|", fe)),
      data = work, cluster = ~firm_id, fixef.rm = "singleton")
    r$N <- stats::nobs(model)
    r$n_firms <- length(unique(work$firm_id[fixest::obs(model)]))
    stopifnot(identical(names(stats::coef(model)), paste0(treatment, ":post")),
              grepl("firm_id", attr(model$cov.scaled, "type"), fixed = TRUE))
    if (r$n_firms < 30L) {
      msg <- sprintf("%s / %s: N=%d, firms=%d (<30)", spec, y, r$N, r$n_firms)
      if (!spec %in% c("S11", "S13")) stop("STOP: ", msg)
      r$status <- "skipped_fewer_than_30_firms"
      cat("SKIP: ", msg, "\n", sep = "")
      rows[[length(rows) + 1L]] <<- r
      next
    }
    ci <- stats::confint(model, level = .95)
    r$coefficient <- unname(stats::coef(model)[1])
    r$std_error <- unname(fixest::se(model)[1])
    r$ci_lower <- unname(ci[1, 1])
    r$ci_upper <- unname(ci[1, 2])
    r$p_value <- unname(fixest::pvalue(model)[1])
    if (spec == "S0" && !legacy_validation) {
      b <- baseline[baseline$outcome == y, ]
      delta <- abs(c(r$coefficient - b$coefficient, r$std_error - b$std_error))
      if (any(delta > 1e-12)) stop("STOP: S0 does not reproduce T009 for ", y)
      stopifnot(r$N == b$N, r$n_firms == b$n_firms)
      cat(sprintf("S0 ASSERT %s: coefficient difference %.17g; SE difference %.17g.\n", y, delta[1], delta[2]))
    }
    if (!trends) {
      event <- fixest::feols(
        stats::as.formula(paste0(source_y, ' ~ i(date, ', treatment,
                                 ', ref = "', reference, '") | firm_id + date')),
        data = work, cluster = ~firm_id, fixef.rm = "singleton")
      stopifnot(identical(fixest::obs(model), fixest::obs(event)),
                setequal(names(stats::coef(event)), paste0("date::", dates[dates != reference], ":", treatment)))
      joint_test <- function(test_dates) {
        pattern <- paste0("^date::(", paste(test_dates, collapse = "|"), "):", treatment, "$")
        selected <- grep(pattern, names(stats::coef(event)), value = TRUE)
        stopifnot(setequal(selected, paste0("date::", test_dates, ":", treatment)))
        w <- fixest::wald(event, keep = pattern, print = FALSE)
        stopifnot(w$df1 == length(test_dates), is.finite(w$stat), is.finite(w$p))
        w
      }
      test <- joint_test(pre_dates)
      r$pretrend_p <- unname(test$p)
      r$pretrend_df <- unname(test$df1)
      if (spec == "S1") {
        # Additional test requested by T011: strictly before 2018-12-31.
        test_early <- joint_test(dates[dates < "2018-12-31"])
        r$pretrend_p_before_2019 <- unname(test_early$p)
        r$pretrend_df_before_2019 <- unname(test_early$df1)
      }
      if (spec == "S0" && !legacy_validation)
        stopifnot(abs(r$pretrend_p - baseline_pre$p_value[baseline_pre$outcome == y]) <= 1e-12)
      if (spec %in% c("S1", "S3") && y %in% c("rl1", "mi_share")) {
        ci_event <- stats::confint(event, level = .95)
        events[[paste(spec, y, sep = "_")]] <<- data.frame(
          date = dates[dates != reference][match(names(stats::coef(event)),
                   paste0("date::", dates[dates != reference], ":", treatment))],
          coefficient = unname(stats::coef(event)), ci_lower = ci_event[, 1], ci_upper = ci_event[, 2])
      }
    }
    rows[[length(rows) + 1L]] <<- r
  }
}

# Exactly one call per specification in each pass; only the baseline treatment changes.
run_all <- function(baseline_treatment, s2_treatment) {
  run_spec("S0", treatment = baseline_treatment)
  run_spec("S1", treatment = "dose2018")
  run_spec("S2", treatment = s2_treatment)
  run_spec("S3", treatment = "distance")
  run_spec("S4", trends = TRUE)
  run_spec("S5", winsor = TRUE)
  run_spec("S6", keep = "balanced")
  run_spec("S7", sample = "sample_broad")
  run_spec("S8", treatment = "dose_2020h1")
  run_spec("S9", keep = "no_adv_missing")
  run_spec("S10", keep = "no_fye_flag")
  run_spec("S11", alternative_rl1 = TRUE)
  run_spec("S12", keep = "a_only")
  run_spec("S13", keep = "hk_only")

}
panel$a_only <- panel$market == "A"
panel$hk_only <- panel$market == "HK"

# Frozen delivered T011 fixture, taken before T012 from t011_robustness.csv.
# Source SHA256: 354a1d845412aed2e4358d6b4b3d971c0a2958b36e05ad1bd8c97ac6f11fc3ff
# Embedded because T012 replaces that CSV; assertions must survive subsequent runs.
t011_reference <- read.csv(text = "spec,outcome,coefficient,std_error,N,n_firms,status
S0,rl1,0.0110157444883784,0.0130127476335023,1575,126,estimated
S0,rl2,-0.00820334101656406,0.189083025064365,1544,126,estimated
S0,rl2_gap,0.00731960297171713,0.0290851131365948,1544,126,estimated
S0,mi_share,0.0247862004651177,0.0127821294805479,1519,124,estimated
S0,jv_ta,0.00173819246693968,0.00316927071694156,1251,103,estimated
S1,rl1,-0.00713648316768925,0.0096456945306195,1562,125,estimated
S1,rl2,-0.202380799748872,0.13193748535213,1532,124,estimated
S1,rl2_gap,0.00892585152363467,0.0291620808725371,1532,124,estimated
S1,mi_share,0.0134205472959811,0.0131758611291936,1506,123,estimated
S1,jv_ta,0.003609840081186,0.00259966703633606,1251,103,estimated
S2,rl1,-0.0149093371792449,0.0100678250066809,1544,124,estimated
S2,rl2,-0.28381372211109,0.144772126530166,1523,124,estimated
S2,rl2_gap,0.0107679785118401,0.0352316918059112,1523,124,estimated
S2,mi_share,0.0210167370720617,0.014713399098435,1484,122,estimated
S2,jv_ta,0.00250590823463017,0.00313208655467141,1225,101,estimated
S3,rl1,-0.00577256157784425,0.00304708471532436,1544,124,estimated
S3,rl2,-0.192639989333367,0.0822222383054783,1523,124,estimated
S3,rl2_gap,0.0172949764655237,0.0255256986308459,1523,124,estimated
S3,mi_share,0.00899775186581758,0.00611870913487742,1484,122,estimated
S3,jv_ta,0.000421664695272967,0.00090125355494635,1225,101,estimated
S4,rl1,0.00146339518419277,0.0126322675927005,1575,126,estimated
S4,rl2,-0.0436910777006976,0.195944392006131,1544,126,estimated
S4,rl2_gap,-0.0082540072295365,0.0184774271218698,1544,126,estimated
S4,mi_share,0.0128456118296273,0.0102460531014056,1519,124,estimated
S4,jv_ta,0.00270271673158315,0.00210648095471499,1251,103,estimated
S5,rl1,0.0021795283475338,0.00943691712236364,1575,126,estimated
S5,rl2,-0.0296229172473832,0.146021503611181,1544,126,estimated
S5,rl2_gap,-0.00793453067436639,0.0135002698047676,1544,126,estimated
S5,mi_share,0.0263312277064759,0.010970138437669,1519,124,estimated
S5,jv_ta,0.00247003065102376,0.00276830103534431,1251,103,estimated
S6,rl1,0.00819611713417043,0.0110061961869466,1391,107,estimated
S6,rl2,0.13884898616463,0.20319315179837,1363,107,estimated
S6,rl2_gap,0.0090257799060562,0.0336425689950959,1363,107,estimated
S6,mi_share,0.0237370983698928,0.0138478727452115,1370,107,estimated
S6,jv_ta,0.00081629530101342,0.0032771528349954,1182,94,estimated
S7,rl1,0.0102112939529,0.013084527093419,1936,156,estimated
S7,rl2,0.0632710598438336,0.175019669733145,1877,156,estimated
S7,rl2_gap,0.00670150973437737,0.0255186815974049,1877,156,estimated
S7,mi_share,0.0305630742942666,0.0115489277976251,1819,151,estimated
S7,jv_ta,-9.47940161218588e-05,0.00373408714703074,1517,127,estimated
S8,rl1,0.0248203208781771,0.0135756336070312,1544,122,estimated
S8,rl2,0.368156460106685,0.255021675365069,1514,122,estimated
S8,rl2_gap,0.00772168005315492,0.0303809108125362,1514,122,estimated
S8,mi_share,0.0616007570410718,0.0237941274098332,1495,121,estimated
S8,jv_ta,0.00170690291909051,0.00272355741305428,1220,99,estimated
S9,rl1,0.00576920965237538,0.0107495904563593,1297,102,estimated
S9,rl2,0.052453018309015,0.193832962303275,1282,102,estimated
S9,rl2_gap,0.00798473486524639,0.0310740503624558,1282,102,estimated
S9,mi_share,0.0312566447284713,0.0123792659978944,1269,101,estimated
S9,jv_ta,0.00133147094185376,0.00327911520410887,1125,92,estimated
S10,rl1,0.0116482929673861,0.0130081825887676,1542,123,estimated
S10,rl2,0.0298472832481921,0.183278780392443,1511,123,estimated
S10,rl2_gap,0.00749953230790577,0.0290578308696873,1511,123,estimated
S10,mi_share,0.0290333481225632,0.0115977612490088,1493,122,estimated
S10,jv_ta,0.00171936875685262,0.00317110631239376,1236,101,estimated
S11,rl1,0.00626821614448046,0.0122696719166681,1575,126,estimated
S11,rl2,NA,NA,NA,NA,not_applicable
S11,rl2_gap,NA,NA,NA,NA,not_applicable
S11,mi_share,NA,NA,NA,NA,not_applicable
S11,jv_ta,NA,NA,NA,NA,not_applicable
S12,rl1,0.00966851730455993,0.0119766140872699,1014,78,estimated
S12,rl2,0.259328521044345,0.247805312688048,1004,78,estimated
S12,rl2_gap,0.0155306021133517,0.042236867224396,1004,78,estimated
S12,mi_share,0.0269247334502194,0.0158723556616967,996,78,estimated
S12,jv_ta,0.000122766228337732,0.00363629844090898,933,73,estimated
S13,rl1,0.0145747750015406,0.0341369960990609,561,48,estimated
S13,rl2,-1.02335002496578,0.558763452134396,540,48,estimated
S13,rl2_gap,-0.0067885828061984,0.0105738806828642,540,48,estimated
S13,mi_share,-0.0214730828271142,0.0510676509191335,523,46,estimated
S13,jv_ta,0.0102103264127332,0.00466685644494611,318,30,estimated")
default_treatment <- "dose"
run_all("dose", "dose_pre")
legacy <- do.call(rbind, rows)
stopifnot(nrow(legacy) == 70L,
          identical(legacy$spec, t011_reference$spec),
          identical(legacy$outcome, t011_reference$outcome),
          identical(legacy$status, t011_reference$status),
          identical(legacy$N, t011_reference$N),
          identical(legacy$n_firms, t011_reference$n_firms))
for (v in c("coefficient", "std_error")) {
  stopifnot(identical(is.na(legacy[[v]]), is.na(t011_reference[[v]])))
  delta <- abs(legacy[[v]] - t011_reference[[v]])
  if (any(delta > 1e-12, na.rm = TRUE)) stop("STOP: cannot reproduce T011 ", v)
  cat(sprintf("T011 ASSERT all 70 cells / %s: maximum difference %.17g (tolerance 1e-12).\n",
              v, max(delta, na.rm = TRUE)))
}
# Only after the mandatory T011 reproduction succeeds, rebase and publish.
legacy_validation <- FALSE
rows <- list()
events <- list()
default_treatment <- "dose_pre"
run_all("dose_pre", "dose")
# T019: S14 uses the main treatment and sample, excluding only the two IDs.
panel$without_likely_non_developers <- !panel$firm_id %in% c("2292.HK", "3992.HK")
for (id in c("2292.HK", "3992.HK"))
  cat(sprintf("T019 membership %s: in panel=%s; in sample_main=%s.\n", id,
    id %in% firms$firm_id, id %in% firms$firm_id[firms$sample_main]))
run_spec("S14", treatment = "dose_pre", keep = "without_likely_non_developers")

result <- do.call(rbind, rows)
rownames(result) <- NULL
stopifnot(nrow(result) == 75L, !anyDuplicated(result[c("spec", "outcome")]),
          all(is.na(result$pretrend_p[result$spec == "S4"])),
          all(result$status[result$spec == "S11" & result$outcome != "rl1"] == "not_applicable"),
          length(events) == 4L)

# T019 expected values: both excluded IDs are already outside sample_main.
# Extend the embedded fixtures only for S14; retain every T011 assertion above.
t019_reference <- read.csv(text = "spec,outcome,coefficient,std_error,N,n_firms,status
S14,rl1,-0.0149093371792449,0.0100678250066808,1544,124,estimated
S14,rl2,-0.28381372211109,0.144772126530166,1523,124,estimated
S14,rl2_gap,0.01076797851184,0.0352316918059112,1523,124,estimated
S14,mi_share,0.0210167370720617,0.014713399098435,1484,122,estimated
S14,jv_ta,0.00250590823463016,0.00313208655467141,1225,101,estimated")
s14 <- result[result$spec == "S14", ]
for (v in c("spec", "outcome", "N", "n_firms", "status"))
  stopifnot(identical(s14[[v]], t019_reference[[v]]))
for (v in c("coefficient", "std_error"))
  stopifnot(all(abs(s14[[v]] - t019_reference[[v]]) <= 1e-12))
for (v in setdiff(names(result), "spec"))
  stopifnot(identical(s14[[v]], result[result$spec == "S0", v]))
cat("T019 ASSERT: five S14 rows equal S0 in every cell except spec.\n")

# Write only after all mandatory cells have passed the stop conditions.
mtpa_write_csv(result, "outputs/tables/t011_robustness.csv", row.names = FALSE)
mtpa_write_csv(definitions, "outputs/tables/t011_treatment_definitions.csv", row.names = FALSE)

spec_notes <- c(
  S0 = "T009 baseline: dose\\_pre, mean breaches 2017H1--2019H2, at least 3 dates; main sample.",
  S1 = "Treatment: breaches at 2018-12-31 (dose2018).",
  S2 = "dose at 2019-12-31.",
  S3 = "Treatment: scaled threshold distance of pre-period mean ratios; at least 3 dates per ratio.",
  S4 = "Add firm-specific linear trends over the full period (t = 1,...,13).",
  S5 = "Winsorise each outcome at 1/99 percent within each date of the S0 sample (type 7).",
  S6 = "Restrict to firms with a financial source row on all 13 dates.",
  S7 = "Replace main sample with broad sample.",
  S8 = "Treatment: breaches at 2020-06-30.",
  S9 = "Exclude firms with any missing-advance-receipts flag over the full panel.",
  S10 = "Exclude firms with any non-calendar-fiscal-year flag.",
  S11 = "Replace RL1 with alternative RL1; other outcomes not applicable.",
  S12 = "Restrict to A-shares.",
  S13 = "Restrict to HK firms; skip cells with fewer than 30 firms.",
  S14 = "Main specification excluding 2292.HK and 3992.HK (both already outside the main sample).")
fmt <- function(x) ifelse(is.na(x), "NA", sprintf("%.6f", x))
latex <- c("% T011: booktabs fragment; requires booktabs and graphicx.",
           "\\begingroup", "\\setlength{\\tabcolsep}{4pt}", "\\scriptsize",
           "\\par\\noindent\\resizebox{\\linewidth}{!}{%", "\\begin{tabular}{l*{5}{rr}}", "\\toprule",
           paste0("Spec. & ", paste(paste0("\\multicolumn{2}{c}{", c("RL1", "RL2", "RL2 gap", "MI share", "JV/TA"), "}"), collapse = " & "), " \\\\"),
           paste0(" & ", paste(rep("Coefficient & Pre-trend $p$", 5), collapse = " & "), " \\\\"),
           "\\midrule")
for (s in names(spec_notes)) {
  d <- result[result$spec == s, ]
  d <- d[match(outcomes, d$outcome), ]
  latex <- c(latex,
    paste0(s, " & ", paste(paste(fmt(d$coefficient), fmt(d$pretrend_p), sep = " & "), collapse = " & "), " \\\\"),
    paste0(" & ", paste(paste0("(", fmt(d$std_error), ") & "), collapse = " & "), " \\\\"),
    paste0("$N$/firms & ", paste(paste0("\\multicolumn{2}{c}{", ifelse(is.na(d$N), "NA", paste0(d$N, "/", d$n_firms)), "}"), collapse = " & "), " \\\\"))
  if (s == "S1")
    latex <- c(latex, paste0("Early pre-trend $p$ & ",
      paste(paste0("\\multicolumn{2}{c}{", fmt(d$pretrend_p_before_2019), "}"), collapse = " & "), " \\\\"))
}
latex <- c(latex, "\\bottomrule", "\\end{tabular}%", "}%", "\\par\\smallskip",
           "\\noindent\\begin{minipage}{\\linewidth}\\scriptsize",
           paste0("\\textit{Notes:} SEs in parentheses, clustered by firm; firm and date FE. ",
                  "Post begins 2020H2. Parallel counterfactual trends across treatment levels are required. ",
                  "Joint Wald F-test of seven dates before 2020-06-30 (reference); S4: NA. ",
                  "S1 early test: four dates strictly before 2018-12-31. ",
                  "95 percent CIs use cluster-based t critical values and are supplied in the CSV. ",
                  "NA: not applicable or skipped (fewer than 30 firms; counts retained). ",
                  "All rows use dose\\_pre unless another treatment is specified. ",
                  "Alternative treatments replace the non-missing-treatment requirement. ",
                  "RL1 policy formula remains unverified against a primary source.\\par"),
           paste0(names(spec_notes), ": ", spec_notes, "\\par"),
           paste0("S5 values changed (RL1, RL2, RL2 gap, MI share, JV/TA): ",
                  paste(result$n_winsorised[result$spec == "S5"], collapse = ", "), ".\\par"),
           "\\end{minipage}\\par", "\\endgroup")
stopifnot(any(grepl("\\toprule", latex, fixed = TRUE)),
          any(grepl("\\bottomrule", latex, fixed = TRUE)),
          !any(grepl("\\documentclass", latex, fixed = TRUE)))
mtpa_write_lines(latex, "outputs/tables/t011_robustness.tex")

# Rebuild the four prespecified S1/S3 event studies from the estimated cells.
# No additional models or changes to the published tables.
titles <- c(rl1 = "Reported leverage (RL1)", mi_share = "Minority interests / total equity")
date_labels <- paste0(substr(dates, 1, 4), ifelse(substr(dates, 6, 7) == "06", "H1", "H2"))
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
for (spec in c("S1", "S3")) for (y in c("rl1", "mi_share")) {
  treatment <- if (spec == "S1") "dose2018" else "distance"
  plot_data <- events[[paste(spec, y, sep = "_")]]
  stopifnot(nrow(plot_data) == 12L, !reference %in% plot_data$date)
  plot_data$period <- match(plot_data$date, dates)
  row <- result[result$spec == spec & result$outcome == y, ]
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
                  subtitle = paste0(spec, ": ", treatment, "; reference: 2020-06-30"),
                  x = "Reporting half-year", y = paste0("Effect per unit of ", treatment, " (ratio units)"),
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
  ggplot2::ggsave(paste0("outputs/figures/t011_es_", y, "_", treatment, ".pdf"), plot = p,
                  device = grDevices::pdf, width = 8.5, height = 5.2, units = "in", timestamp = FALSE)
}

cat("\nTREATMENT DEFINITIONS (main-sample firms):\n")
print(definitions, row.names = FALSE, digits = 10)
cat("\nFULL SPECIFICATION TABLE (ratio units; cluster-t 95% CIs):\n")
print(result[c("spec", "outcome", "coefficient", "ci_lower", "ci_upper", "pretrend_p",
               "pretrend_p_before_2019", "N", "n_firms", "status")], row.names = FALSE, digits = 10)
cat("\nT019 completed: 75 re-based spec-outcome rows; 3 treatment summaries; four T011 figures rebuilt.\n")
cat("S0 coefficient, SE and pre-trend assertions against T009 passed (tolerance 1e-12).\n")
cat("Winsorised values (rl1, rl2, rl2_gap, mi_share, jv_ta): ",
    paste(result$n_winsorised[result$spec == "S5"], collapse = ", "), ".\n", sep = "")
cat("Estimated cells: ", sum(result$status == "estimated"),
    "; skipped <30 firms: ", sum(result$status == "skipped_fewer_than_30_firms"),
    "; not applicable: ", sum(result$status == "not_applicable"), ".\n", sep = "")
