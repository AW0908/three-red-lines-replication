# T008: pre-policy placebo precision and minimum detectable effects.
# Run from replication/: Rscript code/t008_power.R
# No placebo point estimates are exported. No post-policy outcomes are used.
source("code/00_setup.R", local = TRUE)
set.seed(8008)
options(digits = 17)
stopifnot(requireNamespace("fixest", quietly = TRUE))
fixest::setFixest_nthreads(1)

outcomes <- c("rl1", "rl2", "rl2_adj", "rl3", "rl2_gap", "mi_share",
              "mi_gap", "jv_ta", "perp_te", "inv_ta")
heterogeneity <- c("rl1", "rl2", "rl2_gap", "mi_share")
panel <- read.csv("data/processed/panel_firm_halfyear.csv",
                  stringsAsFactors = FALSE)
stopifnot(all(c("sample_main", "dose", "dose_pre", "date", "firm_id", "soe",
                outcomes) %in% names(panel)))
panel$date <- as.Date(panel$date)
keep <- !is.na(panel$sample_main) & panel$sample_main == TRUE &
  !is.na(panel$dose) & !is.na(panel$date) &
  panel$date >= as.Date("2016-12-31") & panel$date <= as.Date("2020-06-30")
pre <- panel[keep, c("firm_id", "date", "dose", "soe", outcomes)]
# T019: same pre-policy dates and placebo design, selected by dose_pre.
keep_main_pre <- !is.na(panel$sample_main) & panel$sample_main == TRUE &
  !is.na(panel$dose_pre) & !is.na(panel$date) &
  panel$date >= as.Date("2016-12-31") & panel$date <= as.Date("2020-06-30")
main_pre <- panel[keep_main_pre, c("firm_id", "date", "dose_pre", "soe", outcomes)]
main_pre <- main_pre[order(main_pre$firm_id, main_pre$date), ]
rownames(main_pre) <- NULL
stopifnot(identical(sort(unique(main_pre$date)),
                    sort(unique(pre$date))),
          !anyNA(main_pre$firm_id), !anyDuplicated(main_pre[c("firm_id", "date")]),
          all(main_pre$dose_pre >= 0 & main_pre$dose_pre <= 3),
          length(unique(main_pre$firm_id)) >= 100L)
main_pre$placebo_post <- as.integer(main_pre$date >= as.Date("2018-12-31"))
rm(panel, keep, keep_main_pre)
pre <- pre[order(pre$firm_id, pre$date), ]
rownames(pre) <- NULL
expected_dates <- as.Date(c("2016-12-31", "2017-06-30", "2017-12-31",
                            "2018-06-30", "2018-12-31", "2019-06-30",
                            "2019-12-31", "2020-06-30"))
stopifnot(identical(sort(unique(pre$date)), expected_dates),
          !anyNA(pre$firm_id), !anyDuplicated(pre[c("firm_id", "date")]),
          all(pre$dose %in% 0:3), all(na.omit(pre$soe) %in% 0:1))
pre_firms <- length(unique(pre$firm_id))
if (pre_firms < 100L) stop("Stop condition: fewer than 100 firms in placebo sample.")
pre$placebo_post <- as.integer(pre$date >= as.Date("2018-12-31"))

estimate_precision <- function(outcome, heterogeneous = FALSE,
                               pre_data = pre, treatment = "dose", design = "main") {
  dat <- if (heterogeneous) pre_data[!is.na(pre_data$soe), ] else pre_data
  # Assertion immediately before EVERY regression, including the SOE subset.
  stopifnot(all(dat$date <= as.Date("2020-06-30")),
            all(dat$date >= as.Date("2016-12-31")))
  rhs <- if (heterogeneous) {
    "dose:placebo_post + dose:placebo_post:soe"
  } else paste0(treatment, ":placebo_post")
  target <- if (heterogeneous) "dose:placebo_post:soe" else paste0(treatment, ":placebo_post")
  fit <- fixest::feols(
    as.formula(paste(outcome, "~", rhs, "| firm_id + date")),
    data = dat, cluster = ~firm_id, notes = FALSE
  )
  # fixest::obs accounts for missing outcomes and any removed FE singletons.
  used <- dat[fixest::obs(fit), ]
  stopifnot(nrow(used) == nobs(fit), all(used$date <= as.Date("2020-06-30")),
            target %in% names(fixest::se(fit)))
  y <- used[[outcome]]
  # Joint FE projection, rather than one-pass double demeaning: unbalanced panel.
  within_y <- as.numeric(fixest::demean(
    y, f = list(used$firm_id, used$date), tol = 1e-10, iter = 10000,
    nthreads = 1
  ))
  stopifnot(max(abs(tapply(within_y, used$firm_id, mean))) < 1e-7,
            max(abs(tapply(within_y, used$date, mean))) < 1e-7)
  se <- unname(fixest::se(fit)[target])
  pooled_sd <- sd(y)
  within_sd <- sd(within_y) # sample SD (N-1), after removing both FEs
  mde <- 2.8 * se
  stopifnot(is.finite(se), se > 0, pooled_sd > 0, within_sd > 0)
  data.frame(outcome = outcome,
             design = if (heterogeneous) "soe_interaction" else design,
             N = nrow(used), firms = length(unique(used$firm_id)),
             SE = se, SD = pooled_sd, within_SD = within_sd, MDE = mde,
             MDE_SD = mde / pooled_sd, MDE_within_SD = mde / within_sd,
             MDE_0_to_3 = 3 * mde)
}

result <- do.call(rbind, c(lapply(outcomes, estimate_precision),
                          lapply(heterogeneity, estimate_precision,
                                 heterogeneous = TRUE),
                          lapply(outcomes, estimate_precision, pre_data = main_pre,
                                 treatment = "dose_pre", design = "main_dose_pre")))
stopifnot(nrow(result) == 24L, all(result$MDE == 2.8 * result$SE),
          all(result$MDE_SD == result$MDE / result$SD),
          all(result$MDE_within_SD == result$MDE / result$within_SD))
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
# Explicit 17-digit serialization permits recomputation at double precision.
csv <- result
numeric_columns <- vapply(csv, is.numeric, logical(1))
csv[numeric_columns] <- lapply(csv[numeric_columns], function(x) sprintf("%.17g", x))
mtpa_write_table(csv, "outputs/tables/t008_mde.csv", sep = ",", row.names = FALSE,
            col.names = TRUE, quote = FALSE)

escape_tex <- function(x) gsub("_", "\\_", x, fixed = TRUE)
tex_rows <- vapply(seq_len(nrow(result)), function(i) {
  r <- result[i, ]
  label <- paste0(escape_tex(r$outcome),
                  if (r$design == "soe_interaction") " (SOE interaction)" else
                    if (r$design == "main_dose_pre") escape_tex(" (main_dose_pre)") else "")
  paste0(label, " & ", r$N, " & ", r$firms, " & ",
         paste(sprintf("%.6f", unlist(r[c("SE", "MDE", "MDE_SD",
                                                 "MDE_within_SD", "MDE_0_to_3")])),
               collapse = " & "), " ", strrep(intToUtf8(92), 2))
}, character(1))
tex <- c(
  "% Requires booktabs. All effects are in the original outcome ratio units.",
  "\\begingroup\\scriptsize\\setlength{\\tabcolsep}{3pt}",
  "\\noindent",
  "\\begin{tabular}{lrrrrrrr}", "\\toprule",
  paste0("Outcome & $N$ & Firms & SE & MDE & MDE/SD & MDE/within-SD & $3\\times$MDE ",
         strrep(intToUtf8(92), 2)),
  "\\midrule", tex_rows[1:10], "\\midrule", tex_rows[11:14], "\\midrule", tex_rows[15:24],
  "\\bottomrule", "\\end{tabular}\\endgroup",
  "\\par\\smallskip",
  "\\noindent\\begin{minipage}{\\linewidth}\\footnotesize",
  paste0("Notes: Main-sample firms with nonmissing dose; dates 2016-12-31 to ",
         "2020-06-30 only. Placebo post begins 2018-12-31. Firm and date fixed ",
         "effects; standard errors clustered by firm. No post-policy outcomes ",
         "or placebo point estimates are reported."),
  paste0("MDE $=(1.96+0.84)\\times\\mathrm{SE}=2.8\\times\\mathrm{SE}$ ",
         "approximates 80\\% power at a two-sided 5\\% level per additional ",
         "breached line; $3\\times$MDE is the dose 0-to-3 contrast."),
  paste0("SD is the pooled sample SD on each regression's estimation sample. ",
         "Within-SD is the sample SD after jointly removing firm and date ",
         "fixed effects (both SDs use $N-1$). SOE rows use known ownership ",
         "and measure the SOE-minus-private difference in the dose effect, ",
         "controlling for the main dose-by-placebo-post interaction."),
  paste0("All effects are in ratio units (multiply by 100 for percentage ",
         "points). Precision from this placebo period is a planning assumption ",
         "for the policy period; MDE/within-SD above 0.5 signals weak power."),
  paste0("Rows labelled main\\_dose\\_pre use nonmissing dose\\_pre in sample\\_main ",
         "with the same dates, placebo cutoff, fixed effects and clustering as the legacy dose rows. ",
         "dose\\_pre averages breaches over 2017H1--2019H2 (at least 3 dates); ",
         "its construction overlaps the placebo period, so this is a precision exercise, ",
         "not an independent test of parallel trends."),
  "\\end{minipage}"
)
mtpa_write_lines(tex, "outputs/tables/t008_mde.tex")
cat(sprintf("Placebo sample: %d observations, %d firms, 8 dates; latest 2020-06-30.\n",
            nrow(pre), pre_firms))
cat("Wrote 24 rows (10 legacy main, 4 legacy SOE interactions, 10 main_dose_pre); no point estimates exported.\n")
cat("MDE = 2.8 * SE; both SD ratios verified for every row.\n")
cat("Weakly powered (MDE/within-SD > 0.5): ",
    paste(paste(result$design, result$outcome, sep = ":")[result$MDE_within_SD > 0.5],
          collapse = ", "), "\n", sep = "")
