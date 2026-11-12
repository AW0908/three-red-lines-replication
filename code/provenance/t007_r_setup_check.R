# T007: environment and estimation check using simulated data only.
# Run from replication/: Rscript code/provenance/t007_r_setup_check.R
required_packages <- c("fixest", "did", "data.table", "ggplot2", "modelsummary")
for (pkg in required_packages) {
  tryCatch(
    suppressPackageStartupMessages(library(pkg, character.only = TRUE)),
    error = function(e) {
      message(sprintf("STOP: package '%s' is missing or cannot be loaded: %s",
                      pkg, conditionMessage(e)))
      quit(save = "no", status = 1L)
    }
  )
}

set.seed(20261016)
dir.create("docs/provenance", recursive = TRUE, showWarnings = FALSE)
dir.create("docs/provenance", recursive = TRUE, showWarnings = FALSE)
versions <- data.frame(
  package = c("R", required_packages),
  version = c(as.character(getRversion()),
              vapply(required_packages, function(pkg) as.character(packageVersion(pkg)),
                     character(1)))
)
write.csv(versions, "docs/provenance/t007_r_packages.csv", row.names = FALSE)

# Independent firm-level intensity, firm effects, time effects, and errors.
n_firms <- 150L
n_periods <- 13L
dose <- sample(0:3, n_firms, replace = TRUE)
firm_effect <- rnorm(n_firms)
period_effect <- rnorm(n_periods)
panel <- data.table::CJ(firm = seq_len(n_firms), period = seq_len(n_periods))
panel[, dose := dose[firm]]
panel[, post := as.integer(period >= 8L)]
panel[, y := firm_effect[firm] + period_effect[period] -
        0.5 * dose * post + rnorm(.N)]

twfe <- fixest::feols(y ~ dose:post | firm + period, data = panel, cluster = ~firm)
ci <- confint(twfe, level = 0.95)
result <- data.frame(
  term = names(coef(twfe)), coefficient = unname(coef(twfe)),
  std_error = unname(se(twfe)), ci_lower = ci[, 1], ci_upper = ci[, 2],
  N = nobs(twfe), row.names = NULL
)
write.csv(result, "docs/provenance/t007_twfe_check.csv", row.names = FALSE)
options(modelsummary_factory_latex = "kableExtra",
        modelsummary_format_numeric_latex = "plain")
modelsummary::modelsummary(
  list("Simulated TWFE" = twfe), output = "docs/provenance/t007_twfe_check.tex",
  fmt = 6, stars = FALSE, escape = TRUE, booktabs = TRUE)

event <- fixest::feols(y ~ i(period, dose, ref = 7) | firm + period,
                       data = panel, cluster = ~firm)
event_ci <- confint(event, level = 0.95)
event_data <- data.frame(
  period = as.integer(sub("period::([0-9]+):dose", "\\1", names(coef(event)))),
  estimate = unname(coef(event)), lower = event_ci[, 1], upper = event_ci[, 2]
)
event_data <- rbind(event_data, data.frame(period = 7L, estimate = 0, lower = 0, upper = 0))
event_data <- event_data[order(event_data$period), ]
plot <- ggplot2::ggplot(event_data, ggplot2::aes(period, estimate)) +
  ggplot2::geom_hline(yintercept = 0, colour = "grey50") +
  ggplot2::geom_vline(xintercept = 7.5, linetype = "dashed", colour = "grey50") +
  ggplot2::geom_errorbar(ggplot2::aes(ymin = lower, ymax = upper), width = 0.15) +
  ggplot2::geom_point() + ggplot2::scale_x_continuous(breaks = 1:13) +
  ggplot2::labs(x = "Half-year period", y = "Effect per unit of dose (95% CI)",
                title = "Simulated event study", subtitle = "Reference: period 7; policy begins in period 8") +
  ggplot2::theme_minimal(base_size = 11)
ggplot2::ggsave("docs/provenance/t007_event_study_check.pdf", plot,
                width = 8, height = 5, units = "in", device = "pdf")

stopifnot(nrow(versions) == 6L, all(nzchar(versions$version)),
          result$N == 1950L, result$ci_lower <= -0.5, result$ci_upper >= -0.5)
pre <- subset(event_data, period <= 6L)
print(result, row.names = FALSE)
print(pre, row.names = FALSE)
stopifnot(nrow(pre) == 6L)
if (!all(pre$lower <= 0 & pre$upper >= 0)) {
  message("Acceptance criterion 5 NOT met: zero excluded in pre-policy period(s): ",
          paste(pre$period[pre$lower > 0 | pre$upper < 0], collapse = ", "),
          ". Simulation retained without seed selection or resampling.")
}
message("T007 completed: simulated estimates and environment versions exported.")
