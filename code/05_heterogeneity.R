# T015: approved ownership coding and dose_pre x post heterogeneity.
# Run from replication/: Rscript code/05_heterogeneity.R
# Inputs are local and read-only; no imputation or additional sample filters.
source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(stringsAsFactors = FALSE, digits = 7, width = 160)
invisible(Sys.setlocale("LC_NUMERIC", "C"))
for (pkg in c("fixest", "kableExtra", "ggplot2")) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop("Required local package unavailable: ", pkg, ". No network installation attempted.")
}
fixest::setFixest_nthreads(1)
outcomes <- c("rl1", "rl2", "rl2_gap", "mi_share", "jv_ta")
panel <- read.csv("data/processed/panel_firm_halfyear.csv", na.strings = "NA",
                  colClasses = c(firm_id = "character", date = "character"))
manual <- read.csv("data/raw/manual/ownership_manual_coding.csv", na.strings = c("", "NA"),
                   colClasses = c(firm_id = "character"))
required <- c("firm_id", "date", "sample_main", "dose_pre", "post", "soe",
              "owner_class_final", "soe_final", "soe_source", outcomes)
stopifnot(all(required %in% names(panel)), is.logical(panel$sample_main),
          !anyDuplicated(panel[c("firm_id", "date")]),
          !anyNA(manual$firm_id), !anyDuplicated(manual$firm_id),
          all(is.na(panel$soe_final) | panel$soe_final %in% 0:1))
for (v in c("sample_main", "soe", "owner_class_final", "soe_final", "soe_source", "dose_pre"))
  stopifnot(all(vapply(split(panel[[v]], panel$firm_id), function(x) length(unique(x)) == 1L, logical(1))))
firms <- panel[!duplicated(panel$firm_id), ]
main_firms <- firms[firms$sample_main, ]
if (any(vapply(0:1, function(g) sum(main_firms$soe_final == g, na.rm = TRUE), integer(1)) < 30L))
  stop("STOP: fewer than 30 firms in an ownership group within sample_main.")
manual_row <- match(firms$firm_id, manual$firm_id)
wind <- !is.na(firms$soe)
stopifnot(all(firms$soe_final[wind] == firms$soe[wind]), all(firms$soe_source[wind] == "wind"),
          identical(firms$soe_final[!wind], as.integer(manual$soe_final[manual_row[!wind]])),
          identical(firms$owner_class_final[!wind], manual$owner_class[manual_row[!wind]]),
          all(is.na(firms$soe_final[firms$owner_class_final %in%
                                     c("state_no_controller", "other", "unknown", "conflict")])))
ignored <- sort(setdiff(manual$firm_id, firms$firm_id))
if (length(setdiff(ignored, c("0283.HK", "600515.SH", "600620.SH"))))
  stop("STOP: unexpected manual firm_id missing in panel.")

# One auditable counts file: main-sample counts, Wind/final cross-tab, individual
# firm provenance, and the three PI-approved manual IDs without panel rows.
counts <- list()
add_count <- function(record_type, sample = "sample_main", owner_class_final = NA_character_,
                      wind_soe = NA_integer_, soe_final = NA_integer_, soe_source = NA_character_,
                      firm_id = NA_character_, n_firms = 1L, note = "") {
  counts[[length(counts) + 1L]] <<- data.frame(record_type, sample, owner_class_final,
    wind_soe, soe_final, soe_source, firm_id, n_firms, note)
}
for (cl in sort(unique(main_firms$owner_class_final), na.last = TRUE)) {
  idx <- if (is.na(cl)) is.na(main_firms$owner_class_final) else main_firms$owner_class_final == cl
  add_count("owner_class_count", owner_class_final = cl, n_firms = sum(idx, na.rm = TRUE))
}
for (g in c(0L, 1L, NA_integer_)) {
  idx <- if (is.na(g)) is.na(main_firms$soe_final) else main_firms$soe_final == g
  add_count("soe_final_count", soe_final = g, n_firms = sum(idx, na.rm = TRUE))
}
for (w in c(0L, 1L, NA_integer_)) for (g in c(0L, 1L, NA_integer_)) {
  idx_w <- if (is.na(w)) is.na(main_firms$soe) else !is.na(main_firms$soe) & main_firms$soe == w
  idx_g <- if (is.na(g)) is.na(main_firms$soe_final) else !is.na(main_firms$soe_final) & main_firms$soe_final == g
  add_count("wind_final_crosstab", wind_soe = w, soe_final = g, n_firms = sum(idx_w & idx_g))
}
for (i in order(firms$firm_id)) {
  m <- manual_row[i]
  add_count("firm_audit", sample = if (firms$sample_main[i]) "sample_main" else "outside_sample_main",
    owner_class_final = firms$owner_class_final[i], wind_soe = firms$soe[i],
    soe_final = firms$soe_final[i], soe_source = firms$soe_source[i], firm_id = firms$firm_id[i],
    note = if (wind[i]) "Wind value retained" else if (!is.na(m)) manual$source[m] else "no ownership coding")
}
for (id in ignored) {
  m <- match(id, manual$firm_id)
  add_count("manual_not_in_panel", sample = "not_in_panel", owner_class_final = manual$owner_class[m],
    soe_final = manual$soe_final[m], soe_source = "manual", firm_id = id, note = "not in panel, ignored")
}
ownership_counts <- do.call(rbind, counts)
cat("T015 sample_main owner classes:\n")
print(ownership_counts[ownership_counts$record_type == "owner_class_count", c("owner_class_final", "n_firms")], row.names = FALSE)
cat("T015 sample_main Wind/final cross-tab (firms):\n")
print(ownership_counts[ownership_counts$record_type == "wind_final_crosstab", c("wind_soe", "soe_final", "n_firms")], row.names = FALSE)

sample_data <- panel[panel$sample_main & !is.na(panel$dose_pre) & !is.na(panel$soe_final), ]
stopifnot(nrow(sample_data) > 0L, !anyNA(sample_data[c("firm_id", "date", "post")]),
          all(sample_data$post == as.integer(sample_data$date >= "2020-12-31")),
          all(sample_data$dose_pre >= 0 & sample_data$dose_pre <= 3))
for (y in outcomes)
  stopifnot(is.numeric(sample_data[[y]]), all(is.na(sample_data[[y]]) | is.finite(sample_data[[y]])))
audit <- function(model, data, y, specification, expected_fe = c("firm_id", "date")) {
  used <- data[fixest::obs(model), ]
  groups <- vapply(0:1, function(g) length(unique(used$firm_id[used$soe_final == g])), integer(1))
  required_groups <- unique(data$soe_final)
  if (any(groups[required_groups + 1L] < 30L))
    stop("STOP: fewer than 30 firms in an estimation ownership group: ", y, " / ", specification)
  stopifnot(nrow(used) == stats::nobs(model), !anyNA(used[[y]]),
            identical(model$fixef_vars, expected_fe),
            grepl("firm_id", attr(model$cov.scaled, "type"), fixed = TRUE))
  missing <- sum(is.na(data[[y]]))
  singleton <- nrow(data) - missing - nrow(used)
  stopifnot(singleton >= 0L)
  cat(sprintf("T015 SAMPLE %s / %s: N=%d; private=%d; SOE=%d; missing y=%d; singleton rows=%d.\n",
              y, specification, nrow(used), groups[1], groups[2], missing, singleton))
  list(N = nrow(used), n_private = groups[1], n_soe = groups[2],
       base_N = nrow(data), missing_outcome = missing, singleton_rows = singleton)
}

# Delta method for all contrasts, using the complete firm-clustered vcov.
# In particular Var(private + difference) includes 2*Cov(private,difference).
contrast <- function(model, weights, y, specification, effect, a) {
  b <- stats::coef(model)
  stopifnot(identical(names(weights), names(b)))
  V <- stats::vcov(model)
  beta <- sum(weights * b)
  variance <- as.numeric(t(weights) %*% V %*% weights)
  stopifnot(is.finite(variance), variance >= 0)
  se <- sqrt(variance)
  df <- fixest::degrees_freedom(model, type = "t")
  critical <- stats::qt(0.975, df = df)
  data.frame(outcome = y, specification, effect, coefficient = beta, std_error = se,
    ci_lower = beta - critical * se, ci_upper = beta + critical * se, df_t = df,
    N = a$N, n_firms = a$n_private + a$n_soe, n_private = a$n_private, n_soe = a$n_soe,
    base_N = a$base_N, missing_outcome = a$missing_outcome, singleton_rows = a$singleton_rows)
}
results <- list()
equivalence_checks <- list()
for (y in outcomes) {
  model <- fixest::feols(stats::as.formula(paste(y,
    "~ dose_pre:post + dose_pre:post:soe_final | firm_id + date^soe_final")),
    data = sample_data, cluster = ~firm_id, fixef.rm = "singleton")
  a <- audit(model, sample_data, y, "interaction", c("firm_id", "date^soe_final"))
  terms <- c("dose_pre:post", "dose_pre:post:soe_final")
  stopifnot(identical(names(stats::coef(model)), terms))
  for (effect in c("private", "soe_minus_private", "soe_implied")) {
    weights <- setNames(switch(effect, private = c(1, 0), soe_minus_private = c(0, 1), soe_implied = c(1, 1)), terms)
    results[[length(results) + 1L]] <- contrast(model, weights, y, "interaction", effect, a)
  }
  cat("T015 INTERACTION coefficient table: ", y, "\n", sep = "")
  print(fixest::coeftable(model), digits = 17)
  for (g in 0:1) {
    split_data <- sample_data[sample_data$soe_final == g, ]
    split_model <- fixest::feols(stats::as.formula(paste(y, "~ dose_pre:post | firm_id + date")),
      data = split_data, cluster = ~firm_id, fixef.rm = "singleton")
    split_audit <- audit(split_model, split_data, y, paste0("split_", g))
    stopifnot(identical(names(stats::coef(split_model)), "dose_pre:post"))
    results[[length(results) + 1L]] <- contrast(split_model, c("dose_pre:post" = 1),
      y, "split", if (g == 0L) "private" else "soe", split_audit)
    # With ownership-specific time FE the interaction is a reparameterisation
    # of the two split regressions. Check coefficients AND the exact used rows.
    interaction_beta <- sum(stats::coef(model) * c(1, g))
    split_beta <- unname(stats::coef(split_model)[[1L]])
    used_interaction <- sample_data[fixest::obs(model), ]
    used_interaction <- used_interaction[used_interaction$soe_final == g, c("firm_id", "date")]
    used_split <- split_data[fixest::obs(split_model), c("firm_id", "date")]
    same_rows <- identical(unname(as.matrix(used_interaction)), unname(as.matrix(used_split)))
    error <- abs(interaction_beta - split_beta)
    stopifnot(same_rows, is.finite(error), error <= 1e-10)
    equivalence_checks[[length(equivalence_checks) + 1L]] <- data.frame(
      outcome = y, group = if (g == 0L) "private" else "soe",
      interaction_coefficient = interaction_beta, split_coefficient = split_beta,
      absolute_difference = error, tolerance = 1e-10, identical_estimation_rows = same_rows)
    cat(sprintf("T015 ASSERT %s / group %d: interaction-split absolute difference %.17g <= 1e-10; identical rows.\n",
                y, g, error))
  }
  # Previous restricted model is retained solely as a labelled robustness check.
  restricted <- fixest::feols(stats::as.formula(paste(y,
    "~ dose_pre:post + dose_pre:post:soe_final | firm_id + date")),
    data = sample_data, cluster = ~firm_id, fixef.rm = "singleton")
  restricted_audit <- audit(restricted, sample_data, y, "robustness_common_time_fe")
  stopifnot(identical(names(stats::coef(restricted)), terms),
            identical(fixest::obs(model), fixest::obs(restricted)))
  for (effect in c("private", "soe_minus_private", "soe_implied")) {
    weights <- setNames(switch(effect, private = c(1, 0), soe_minus_private = c(0, 1), soe_implied = c(1, 1)), terms)
    results[[length(results) + 1L]] <- contrast(restricted, weights, y,
      "robustness_common_time_fe", effect, restricted_audit)
  }
}
heterogeneity <- do.call(rbind, results)
rownames(heterogeneity) <- rownames(ownership_counts) <- NULL
equivalence_checks <- do.call(rbind, equivalence_checks)
rownames(equivalence_checks) <- NULL
stopifnot(nrow(heterogeneity) == 40L, all(table(heterogeneity$outcome) == 8L),
          nrow(equivalence_checks) == 10L)

# Compact booktabs fragment: the same five outcome columns, precision, SE/CI
# rows, scale-down wrapper and line-width notes as t009_did_main.tex.
table_rows <- list()
add_row <- function(label, values) {
  table_rows[[length(table_rows) + 1L]] <<- setNames(as.list(c(label, values)), c(" ", outcomes))
}
block_ends <- integer()
for (spec in c("interaction", "split", "robustness_common_time_fe")) {
  effects <- switch(spec, interaction = c("private", "soe_minus_private", "soe_implied"),
                    split = c("private", "soe"), robustness_common_time_fe = "soe_minus_private")
  add_row(switch(spec, interaction = "(a) Interaction: ownership-specific half-year FE",
                 split = "(b) Split samples: separate half-year FE",
                 robustness_common_time_fe = "(c) Robustness only: common half-year FE"), rep("", 5L))
  for (effect in effects) {
    rows <- heterogeneity[heterogeneity$specification == spec & heterogeneity$effect == effect, ]
    rows <- rows[match(outcomes, rows$outcome), ]
    label <- switch(effect, private = "Private effect", soe_minus_private = "SOE - private difference",
                    soe_implied = "Implied SOE effect", soe = "SOE effect")
    add_row(label, sprintf("%.6f", rows$coefficient))
    add_row(" ", sprintf("(%.6f)", rows$std_error))
    add_row(" ", sprintf("[%.6f, %.6f]", rows$ci_lower, rows$ci_upper))
    if (spec == "split" || effect == "soe_implied") {
      add_row("N (firm-half-years)", as.character(rows$N))
      if (spec == "interaction" || effect == "private")
        add_row("Private firms", as.character(rows$n_private))
      if (spec == "interaction" || effect == "soe")
        add_row("SOE firms", as.character(rows$n_soe))
    }
    block_ends <- c(block_ends, length(table_rows))
  }
}
table_data <- do.call(rbind, lapply(table_rows, as.data.frame, check.names = FALSE))
latex <- kableExtra::kbl(table_data, format = "latex", booktabs = TRUE, escape = TRUE, linesep = "",
                        align = c("l", rep("c", 5L)), row.names = FALSE)
latex <- as.character(kableExtra::kable_styling(latex, latex_options = "scale_down"))
# Spacing only after complete effect blocks, never between an estimate and SE.
latex_lines <- strsplit(as.character(latex), "\n", fixed = TRUE)[[1L]]
body_start <- which(latex_lines == "\\midrule")
stopifnot(length(body_start) == 1L)
spacing_after <- body_start + head(block_ends, -1L)
latex <- paste(unlist(lapply(seq_along(latex_lines), function(i)
  c(latex_lines[i], if (i %in% spacing_after) "\\addlinespace"))), collapse = "\n")
# T019: add metadata inside the existing table float.
latex <- sub("\\begin{table}\n", paste0("\\begin{table}\n",
  "\\caption{Heterogeneity by ownership: SOE vs. private developers}\n",
  "\\label{tab:soe_het}\n"), latex, fixed = TRUE)
manual_main <- sort(main_firms$firm_id[main_firms$soe_source == "manual" & !is.na(main_firms$soe_source)])
notes <- paste(
  "Sample: sample_main = TRUE, non-missing dose_pre and soe_final; available outcomes; FE singletons removed.",
  "dose_pre is mean breaches over 2017H1-2019H2 (at least 3 dates); post begins 2020H2. Ratios are in levels.",
  "Firm and half-year fixed effects; SEs clustered by firm (parentheses); 95% CIs use cluster-based t critical values and fixest default small-sample correction.",
  "Panel (a) uses ownership-specific half-year FE; private = baseline, difference = triple interaction, implied SOE = their sum with the full covariance matrix. The difference with firm-clustered SE is the main heterogeneity test; N and firm counts apply to all three effects.",
  "Panel (b) fits the pooled specification separately by ownership; point estimates equal (a) within 1e-10 (asserted in code). SEs can differ because joint and split models use different cluster counts and small-sample corrections.",
  "Panel (c) reports only the SOE - private difference from the old restricted interaction with common half-year FE, as robustness; its sample counts equal (a). All three restricted-model effects and CIs are in the CSV.",
  "Identification requires parallel untreated trends across dose levels within ownership groups and no confounding dose-by-post shocks; only (c) additionally restricts half-year effects to be common across ownership groups.",
  "Wind soe values take priority. Manual coding applies only where Wind soe is missing; foreign is coded 0. state_no_controller, other, unknown and conflict remain NA and are excluded.",
  paste0("Manually coded sample_main firms (including NA classifications): ", paste(manual_main, collapse = ", "), "."),
  "The counts CSV contains a firm-by-firm source audit; 0283.HK, 600515.SH and 600620.SH have no panel rows and are ignored under the approved rule.",
  "No multiple-testing adjustment or mechanism/causal claim is made. RL1 definition remains unverified against a primary policy source.")
escaped_notes <- gsub("%", "\\%", gsub("_", "\\_", notes, fixed = TRUE), fixed = TRUE)
latex <- paste0(sub("\\end{table}", "", latex, fixed = TRUE),
  "\n\\par\\smallskip\n\\begin{minipage}{\\linewidth}\\footnotesize\n",
  escaped_notes, "\n\\end{minipage}\n\\end{table}")
stopifnot(grepl("\\toprule", latex, fixed = TRUE), grepl("\\bottomrule", latex, fixed = TRUE),
          !grepl("\\documentclass", latex, fixed = TRUE))
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
mtpa_write_csv(heterogeneity, "outputs/tables/t015_soe_heterogeneity.csv", row.names = FALSE)
mtpa_write_lines(latex, "outputs/tables/t015_soe_heterogeneity.tex")
mtpa_write_csv(ownership_counts, "outputs/tables/t015_ownership_counts.csv", row.names = FALSE)
mtpa_write_csv(equivalence_checks, "outputs/tables/t015_specification_checks.csv", row.names = FALSE)
cat("\nT015 FINAL SUMMARY (ratio units; firm-clustered SE):\n")
print(heterogeneity[c("outcome", "specification", "effect", "coefficient", "std_error", "N", "n_private", "n_soe")], row.names = FALSE, digits = 10)
cat("T015 completed: 5 unrestricted interaction models, 10 split-sample models, 5 restricted robustness models; 40 effect rows.\n")
cat("Outputs: t015_soe_heterogeneity.csv/.tex; t015_ownership_counts.csv; t015_specification_checks.csv.\n")

# T019: plot the existing split-sample rows; no additional estimation.
plot_data <- heterogeneity[heterogeneity$specification == "split", ]
stopifnot(nrow(plot_data) == 10L, all(table(plot_data$outcome) == 2L),
          !anyDuplicated(plot_data[c("outcome", "effect")]))
plot_data$outcome <- factor(plot_data$outcome, levels = outcomes,
  labels = c("RL1 (definition unverified)", "Reported net gearing (RL2)",
             "RL2 gap", "Minority interests / equity", "JV and associates / assets"))
plot_data$ownership <- factor(plot_data$effect, levels = c("private", "soe"),
                              labels = c("Private", "SOE"))
p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = ownership, y = coefficient)) +
  ggplot2::geom_hline(yintercept = 0, colour = "grey55", linewidth = 0.4) +
  ggplot2::geom_errorbar(ggplot2::aes(ymin = ci_lower, ymax = ci_upper),
                        width = 0.14, colour = "#245577", linewidth = 0.6) +
  ggplot2::geom_point(colour = "#245577", size = 2.2) +
  ggplot2::facet_wrap(~outcome, scales = "free_y", ncol = 3) +
  ggplot2::labs(title = "Pooled dose-response estimates by ownership",
    subtitle = "dose_pre: mean breaches 2017H1-2019H2 (>=3 dates); post begins 2020H2",
    x = "Ownership", y = "Effect per additional mean pre-policy breach (ratio units)",
    caption = paste0("95% CIs; split samples with firm and half-year FE; SEs clustered by firm.\n",
                     "Exploratory estimates; no multiple-testing adjustment.")) +
  ggplot2::theme_minimal(base_size = 11) +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
    panel.grid.minor = ggplot2::element_blank(),
    plot.title = ggplot2::element_text(size = 13),
    plot.subtitle = ggplot2::element_text(size = 10),
    plot.caption = ggplot2::element_text(size = 9, hjust = 0),
    plot.margin = ggplot2::margin(12, 14, 12, 24))
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
ggplot2::ggsave("outputs/figures/t019_soe_coefficients.pdf", plot = p,
  device = grDevices::pdf, width = 8.5, height = 5.2, units = "in", timestamp = FALSE)
cat("T019: coefficient plot uses the 10 existing split-sample effect/95% CI rows.\n")
