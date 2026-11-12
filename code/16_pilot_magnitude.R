# T044, approved Rework 3. Offline mechanism evidence, purposive pilot only.
# Run from replication/: Rscript code/16_pilot_magnitude.R
# Coding is a hand-collected INPUT. This script never rewrites it or PI decisions.
# No causal estimand, prevalence estimate, or economic-debt reclassification is made.
options(stringsAsFactors = FALSE, digits = 17, scipen = 999, OutDec = ".")
set.seed(20261028L)
stopifnot(file.exists("replication.Rproj"), requireNamespace("jsonlite", quietly = TRUE),
          requireNamespace("digest", quietly = TRUE))
raw <- "data/raw/manual/handcollect/"
out <- "outputs/tables/"
read <- function(p) read.csv(p, colClasses = "character", na.strings = NULL,
                            check.names = FALSE, fileEncoding = "UTF-8-BOM")
write <- function(x, name) write.csv(x, paste0(out, "t044_", name, ".csv"),
                                    row.names = FALSE, na = "NA", fileEncoding = "UTF-8")
num <- function(x) suppressWarnings(as.numeric(gsub(",", "", x, fixed = TRUE)))
units <- function(x) ifelse(grepl("10,000", x, fixed = TRUE), 10000,
                          ifelse(grepl("1,000", x, fixed = TRUE), 1000, 1))
strict_sum <- function(x) if (!length(x) || anyNA(x)) NA_real_ else sum(x)
split_ids <- function(x) unique(Filter(nzchar, unlist(strsplit(x, ";", fixed = TRUE))))
coding <- read(paste0(raw, "pilot_coding.csv"))
pilot <- read("../state/handcollect/pilot_purposive.csv")
panel <- read("data/processed/panel_firm_halfyear.csv")
cf <- read(paste0(raw, "nci_cashflow.csv"))
subs <- read(paste0(raw, "nci_subsidiaries.csv"))
verification <- read(paste0(raw, "case_notes_verification.csv"))
# Hand-collected links to append-only case-note lines; values are read afresh below.
component_links <- read.csv(text = r"---(firm_id,statistic,statement_id
600325.SH,mi_opening,600325.SH:L176
600325.SH,mi_closing,600325.SH:L177
600325.SH,profit_nci_2021,600325.SH:L178
600325.SH,capital_from_nci_2021,600325.SH:L133
600325.SH,dividends_to_nci_2021,
000517.SZ,mi_opening,000517.SZ:L181
000517.SZ,mi_closing,000517.SZ:L182
000517.SZ,profit_nci_2021,000517.SZ:L183
000517.SZ,capital_from_nci_2021,000517.SZ:L136
000517.SZ,dividends_to_nci_2021,
1966.HK,mi_opening,1966.HK:L139
1966.HK,mi_closing,1966.HK:L140
1966.HK,profit_nci_2020,1966.HK:L186
1966.HK,capital_from_nci_2020,1966.HK:L141
1966.HK,dividends_to_nci_2020,1966.HK:L142
1638.HK,mi_opening,1638.HK:L189
1638.HK,mi_closing,1638.HK:L190
1638.HK,profit_nci_2020,1638.HK:L221
1638.HK,capital_from_nci_2020,1638.HK:L145
1638.HK,dividends_to_nci_2020,1638.HK:L146
600208.SH,mi_opening,600208.SH:L193
600208.SH,mi_closing,600208.SH:L194
600208.SH,profit_nci_2020,600208.SH:L149
600208.SH,capital_from_nci_2020,600208.SH:L150
600208.SH,dividends_to_nci_2020,
000838.SZ,mi_opening,000838.SZ:L197
000838.SZ,mi_closing,000838.SZ:L198
000838.SZ,profit_nci_2021,000838.SZ:L199
000838.SZ,capital_from_nci_2021,
000838.SZ,dividends_to_nci_2021,000838.SZ:L153
3900.HK,mi_opening,3900.HK:L202
3900.HK,mi_closing,3900.HK:L203
3900.HK,profit_nci_2021,3900.HK:L204
3900.HK,capital_from_nci_2021,3900.HK:L156
3900.HK,dividends_to_nci_2021,3900.HK:L157
002314.SZ,mi_opening,002314.SZ:L224
002314.SZ,mi_closing,002314.SZ:L207
002314.SZ,profit_nci_2021,002314.SZ:L208
002314.SZ,capital_from_nci_2021,002314.SZ:L160
002314.SZ,dividends_to_nci_2021,002314.SZ:L161
001979.SZ,mi_opening,001979.SZ:L211
001979.SZ,mi_closing,001979.SZ:L212
001979.SZ,profit_nci_2019,001979.SZ:L213
001979.SZ,capital_from_nci_2019,001979.SZ:L164
001979.SZ,dividends_to_nci_2019,001979.SZ:L165
600565.SH,mi_opening,600565.SH:L216
600565.SH,mi_closing,600565.SH:L217
600565.SH,profit_nci_2018,600565.SH:L168
600565.SH,capital_from_nci_2018,600565.SH:L169
600565.SH,dividends_to_nci_2018,600565.SH:L170
)---", colClasses = "character", na.strings = NULL)
stopifnot(nrow(pilot) == 10L, !anyDuplicated(coding$transaction_id),
          setequal(unique(coding$firm_id), pilot$firm_id),
          all(coding$category %in% c("D", "G", "H", "E", "U")))

# Bind PI decisions to the actual current statement text as well as its line ID.
lines <- readLines(paste0(raw, "case_notes.md"), encoding = "UTF-8", warn = FALSE)
statements <- list(); firm <- NULL
for (i in seq_along(lines)) {
  if (startsWith(lines[i], "## ")) { firm <- substring(lines[i], 4); next }
  if (is.null(firm) || !firm %in% pilot$firm_id || !nzchar(trimws(lines[i])) ||
      startsWith(lines[i], "#")) next
  txt <- trimws(gsub("\\[[^][]+\\]", "", lines[i]))
  id <- paste0(firm, ":L", i)
  v <- verification[verification$statement_id == id, , drop = FALSE]
  bound <- nrow(v) == 1L && v$status == "yes" && v$verified_by == "PI" && v$statement == txt
  meaning <- bound && v$level == "meaning"
  numeric_ok <- bound && v$level %in% c("strings", "meaning")
  # Same numeric-statement rule as the PI verification helper (2026-10-28).
  numeric_head <- if (grepl("records", txt, fixed = TRUE)) strsplit(txt, "records", fixed = TRUE)[[1]][1] else txt
  numeric_item <- grepl("^(The (FY|H1)[0-9]{4} (annual |interim )?(report|cash-flow statement|statement|balance sheet|income statement)[^.]*records|The proposed [^.]* contribution by [^.]* is [0-9]|[^.]{0,80} is to contribute cash of [0-9])", txt) &&
    !grepl("subsidiar|related|repurchase|may require|option|guarantee|loan|identif|controll(ing|er) shareholder|creditor", numeric_head, ignore.case = TRUE)
  statements[[length(statements) + 1L]] <- data.frame(
    statement_id = id, firm_id = firm, line = i, statement = txt,
    status = if (nrow(v)) v$status[1] else "not checked",
    level = if (nrow(v)) v$level[1] else "",
    required_level = if (numeric_item) "strings or meaning" else "meaning",
    verified_numeric = numeric_ok, verified_meaning = meaning,
    verified = if (numeric_item) numeric_ok else meaning)
}
statements <- do.call(rbind, statements)
verified <- function(ids, kind = "meaning") {
  ii <- split_ids(ids)
  if (!length(ii)) return("unverified")
  z <- match(ii, statements$statement_id)
  flag <- if (kind == "numeric") statements$verified_numeric else statements$verified_meaning
  if (all(!is.na(z)) && all(flag[z])) "verified" else "unverified"
}
combine_state <- function(x) if (length(x) && all(x == "verified")) "verified" else "unverified"
write(statements[!statements$verified, ], "pending_statements")

# Validate the fixed, ordered rubric from the FEATURES, not an inherited label.
features <- c("investor_put", "mandatory_buyback_redemption", "fixed_guaranteed_return",
              "issuer_shortfall_makeup", "preset_exit_not_project_value", "own_group",
              "issuer_call", "preferred_dividends", "profit_target", "market_value_exit",
              "substantial_minority_loans", "unrelated_prorata", "issuer_call_preset_price")
# Rework 3: an issuer call at a preset price is an H feature (issuer option, not an investor exit).
h_features <- features[c(7:11, 13)]
stopifnot(all(vapply(coding[features], function(x) all(x %in% c("yes", "no", "not stated")), logical(1))))
stopifnot(all(coding$undecided_feature %in% c("", features)))
for (i in seq_len(nrow(coding))) {
  r <- coding[i, ]
  # A feature that is mentioned but cannot be decided yes/no blocks every later step (rubric U).
  und <- r$undecided_feature
  if (nzchar(und)) stopifnot(r[[und]] == "not stated", nzchar(r$undecided_feature_file),
                             nzchar(r$undecided_feature_page), nzchar(r$undecided_feature_excerpt))
  d <- any(unlist(r[features[1:5]]) == "yes")
  h <- any(unlist(r[h_features]) == "yes")
  expected <- if (d) "D" else if (und %in% features[1:5]) "U" else
    if (r$own_group == "yes") "G" else if (und == "own_group") "U" else
    if (h) "H" else if (und %in% h_features) "U" else
    if (r$unrelated_prorata == "yes" && r$own_group == "no") "E" else "U"
  stopifnot(r$category == expected, nzchar(r$reason))
  if (r$category == "D") {
    subtype <- if (any(unlist(r[c("fixed_guaranteed_return", "issuer_shortfall_makeup", "preset_exit_not_project_value")]) == "yes")) "D1" else
      if (r$market_value_exit == "yes") "D2" else "D-unspecified"
    stopifnot(r$debt_subtype == subtype, nzchar(r$debt_subtype_reason))
  } else stopifnot(!nzchar(r$debt_subtype))
  for (f in features) if (r[[f]] != "not stated")
    stopifnot(nzchar(r[[paste0(f, "_file")]]), nzchar(r[[paste0(f, "_page")]]),
              nzchar(r[[paste0(f, "_excerpt")]]))
  if (nzchar(r$minority_contribution_rmb))
    stopifnot(nzchar(r$amount_file), nzchar(r$amount_page), nzchar(r$amount_original))
  if (nzchar(r$equity_transfer_price_rmb))
    stopifnot(nzchar(r$equity_transfer_price_file), nzchar(r$equity_transfer_price_page))
}

# Read full PDFs into memory only. Every evidence page is a PHYSICAL PDF page.
pdf_cache <- new.env(parent = emptyenv())
pdf_pages <- function(path) {
  key <- path
  if (!exists(key, envir = pdf_cache, inherits = FALSE)) {
    stopifnot(file.exists(file.path("..", path)))
    z <- system2("pdftotext", c("-layout", shQuote(file.path("..", path)), "-"), stdout = TRUE)
    stopifnot(is.null(attr(z, "status")))
    p <- strsplit(paste(z, collapse = "\n"), "\f", fixed = TRUE)[[1]]
    assign(key, p, envir = pdf_cache)
  }
  get(key, envir = pdf_cache, inherits = FALSE)
}
normalize <- function(x) gsub("[[:space:]]", "", x)
evidence_check <- list()
add_check <- function(id, field, file, page, excerpt) {
  pp <- pdf_pages(file); pg <- as.integer(page)
  ok <- length(pg) == 1L && !is.na(pg) && pg > 0 && pg <= length(pp) &&
    nzchar(excerpt) && grepl(normalize(excerpt), normalize(pp[pg]), fixed = TRUE)
  evidence_check[[length(evidence_check) + 1L]] <<- data.frame(
    transaction_id = id, field = field, file = file, physical_page = page,
    excerpt = excerpt, text_match = ok)
}
for (i in seq_len(nrow(coding))) {
  r <- coding[i, ]
  for (f in features) if (r[[f]] != "not stated")
    add_check(r$transaction_id, f, r[[paste0(f, "_file")]], r[[paste0(f, "_page")]], r[[paste0(f, "_excerpt")]])
  if (nzchar(r$undecided_feature))
    add_check(r$transaction_id, paste0("undecided:", r$undecided_feature), r$undecided_feature_file,
              r$undecided_feature_page, r$undecided_feature_excerpt)
  if (nzchar(r$minority_contribution_rmb))
    add_check(r$transaction_id, "minority_contribution", r$amount_file, r$amount_page, r$amount_excerpt)
  if (nzchar(r$paid_contribution_rmb))
    add_check(r$transaction_id, "paid_contribution", r$paid_file, r$paid_page, r$paid_excerpt)
  if (nzchar(r$equity_transfer_price_rmb)) {
    token <- regmatches(r$equity_transfer_price_original,
                        regexpr("[0-9][0-9,.]*", r$equity_transfer_price_original))
    add_check(r$transaction_id, "equity_transfer_price", r$equity_transfer_price_file,
              r$equity_transfer_price_page, token)
  }
}
evidence_check <- do.call(rbind, evidence_check)
write(evidence_check, "evidence_checks")
stopifnot(all(evidence_check$text_match))
# Stratified check sample: every D, G and H row plus five random U rows (fixed seed).
set.seed(20261028L)
is_tx <- coding$record_type == "transaction"
u_rows <- which(is_tx & coding$category == "U")
check_ix <- c(which(is_tx & coding$category %in% c("D", "G", "H")), sort(sample(u_rows, 5L, replace = FALSE)))
check_sample <- coding[check_ix, c("transaction_id", "transaction_group_id", "firm_id", "category",
  "debt_subtype", "file", "page", "subsidiary", "partner", "reason")]
check_sample$stratum <- ifelse(check_sample$category == "U", "random U (seed 20261028)", "all D/G/H")
check_sample$evidence_checks <- vapply(check_sample$transaction_id, function(id)
  sum(evidence_check$transaction_id == id), integer(1))
check_sample$evidence_text_match <- vapply(check_sample$transaction_id, function(id) {
  m <- evidence_check$text_match[evidence_check$transaction_id == id]
  if (length(m)) all(m) else NA }, logical(1))
write(check_sample, "check_sample")

# Annual windows from reports_needed. Never sum cumulative H1 and FY profits.
ys <- regmatches(pilot$reports_needed, gregexpr("FY[0-9]{4}", pilot$reports_needed))
pilot$fy0 <- vapply(ys, function(x) as.integer(sub("FY", "", x[1])), integer(1))
pilot$fy1 <- vapply(ys, function(x) as.integer(sub("FY", "", tail(x, 1))), integer(1))
pilot$window_start <- paste0(pilot$fy0, "-12-31")
pilot$window_end <- paste0(pilot$fy1, "-12-31")
component_state <- function(f, stat) {
  l <- ledger[ledger$firm_id == f & ledger$statistic %in% stat, ]
  if (nrow(l) != length(stat) || any(!nzchar(l$statement_id))) return("unverified")
  verified(l$statement_id, kind = "numeric")
}
cash_value <- function(f, y, metric) {
  z <- cf[cf$firm_id == f & cf$report == paste0("FY", y) & cf$metric == metric, ]
  stopifnot(nrow(z) == 1L)
  v <- z$value
  if (v %in% c("-", "–", "—")) return(0)
  if (!nzchar(v)) return(NA_real_)
  # Cash outflows in parentheses are converted to positive dividends, then subtracted.
  abs(num(gsub("[()]", "", v))) * units(z$currency_unit)
}
get_panel <- function(f, dt, col) {
  z <- panel[panel$firm_id == f & panel$date == dt, ]
  stopifnot(nrow(z) == 1L)
  num(z[[col]])
}
# Rebuild the component ledger from permitted inputs and the fixed source links.
# Opening Nanshan MI is the restated FY2020 comparative in FY2021.
ledger <- list()
for (i in seq_len(nrow(pilot))) {
  p <- pilot[i, ]; f <- p$firm_id; years <- seq.int(p$fy0 + 1L, p$fy1)
  stats <- c("mi_opening", "mi_closing", paste0("profit_nci_", years),
             paste0("capital_from_nci_", years), paste0("dividends_to_nci_", years))
  for (stat in stats) {
    mi <- stat %in% c("mi_opening", "mi_closing")
    profit <- startsWith(stat, "profit_nci_")
    year <- if (mi) if (stat == "mi_opening") p$fy0 else p$fy1 else as.integer(sub(".*_", "", stat))
    file <- paste0("Daten/annual_reports/", f, "/", f, "_FY", year, ".pdf")
    if (f == "002314.SZ" && stat == "mi_opening")
      file <- "Daten/annual_reports/002314.SZ/002314.SZ_FY2021.pdf"
    if (mi || profit) {
      col <- if (mi) "mi" else "ni_mi"
      value <- get_panel(f, paste0(year, "-12-31"), col)
      input <- "replication/data/processed/panel_firm_halfyear.csv"
      filter <- paste0("firm_id=", f, "; date=", year, "-12-31; column=", col)
      note <- "Source pointer only; PI status yes and strings or meaning required for numeric verification."
      if (f == "002314.SZ" && stat == "mi_opening")
        note <- "FY2021 comparative for 2020-12-31; common-control combination adds RMB 285,664,366.60 to prior closing NCI (FY2021 physical p. 111; statement 002314.SZ:L225, meaning check pending)."
      page <- ""
    } else {
      metric <- sub("_[0-9]{4}$", "", stat)
      value <- cash_value(f, year, metric)
      z <- cf[cf$firm_id == f & cf$report == paste0("FY", year) & cf$metric == metric, ]
      page <- z$pdf_page
      note <- if (z$value %in% c("-", "–", "—")) "printed dash = nil" else z$status
      input <- "replication/data/raw/manual/handcollect/nci_cashflow.csv"
      filter <- paste0("firm_id=", f, "; report=FY", year, "; metric=", metric)
    }
    link <- component_links[component_links$firm_id == f & component_links$statistic == stat, ]
    stopifnot(nrow(link) == 1L)
    id <- link$statement_id; excerpt <- ""
    if (nzchar(id)) {
      idx <- match(id, statements$statement_id); stopifnot(!is.na(idx))
      ln <- lines[statements$line[idx]]
      page <- sub(".*p\\. ([0-9]+).*", "\\1", ln)
      excerpt <- statements$statement[idx]
      # Reject stale source links if a statement's amount or year changes.
      expected <- formatC(value, format = "f", digits = 2, big.mark = ",")
      stopifnot((grepl(paste0("FY", year), excerpt, fixed = TRUE) ||
                   (f == "002314.SZ" && stat == "mi_opening" && grepl("December 31, 2020", excerpt, fixed = TRUE))),
                grepl(paste0("RMB ", expected), excerpt, fixed = TRUE),
                grepl(file, ln, fixed = TRUE))
    } else if (!is.na(value)) note <- "Panel/PDF amount not reconciled; no verified source statement."
    ledger[[length(ledger) + 1L]] <- data.frame(firm_id = f, statistic = stat,
      value_rmb = value, input_file = input, input_filter = filter,
      source_file = file, source_page = page, source_excerpt = excerpt,
      statement_id = id, notes = note)
  }
}
ledger <- do.call(rbind, ledger)
write(ledger, "component_statements")
coding$category_verification <- vapply(coding$decisive_statement_ids, verified, character(1))
coding$amount_verification <- vapply(coding$amount_statement_ids, verified, character(1), kind = "numeric")
coding$paid_verification <- vapply(seq_len(nrow(coding)), function(i)
  combine_state(c(coding$category_verification[i], verified(coding$paid_statement_ids[i], kind = "numeric"))), character(1))
real <- coding[coding$record_type == "transaction", ]
# Economic transactions = transaction_group_id. A group takes its most severe row category
# in rubric order (D, G, H, E, U); counts and amounts in the compact table are by group category.
rubric_order <- c("D", "G", "H", "E", "U")
group_key <- paste(real$firm_id, real$transaction_group_id)
real$group_category <- ave(real$category, group_key, FUN = function(x)
  rubric_order[min(match(x, rubric_order))])
groups <- unique(real[c("firm_id", "transaction_group_id", "group_category")])
stopifnot(!anyDuplicated(paste(groups$firm_id, groups$transaction_group_id)))
gi <- match(paste(groups$firm_id, groups$transaction_group_id), group_key)
groups$rows <- vapply(seq_len(nrow(groups)), function(i) paste(real$transaction_id[group_key == group_key[gi[i]]], collapse = ";"), character(1))
groups$row_categories <- vapply(seq_len(nrow(groups)), function(i) paste(real$category[group_key == group_key[gi[i]]], collapse = ";"), character(1))
groups$n_rows <- vapply(seq_len(nrow(groups)), function(i) sum(group_key == group_key[gi[i]]), integer(1))
groups$debt_subtypes <- vapply(seq_len(nrow(groups)), function(i) {
  s <- real$debt_subtype[group_key == group_key[gi[i]]]; paste(unique(s[nzchar(s)]), collapse = ";") }, character(1))
groups$window_membership <- vapply(seq_len(nrow(groups)), function(i)
  if (any(real$window_membership[group_key == group_key[gi[i]]] == "within")) "within" else "boundary-uncertain", character(1))
write(groups, "transaction_groups")
merged <- data.frame(firm_id = pilot$firm_id,
  rows = vapply(pilot$firm_id, function(f) sum(real$firm_id == f), integer(1)),
  groups = vapply(pilot$firm_id, function(f) sum(groups$firm_id == f), integer(1)), row.names = NULL)
merged$rows_merged <- merged$rows - merged$groups
write(merged, "group_merges")
compact <- list(); magnitude <- list(); numbers <- list()
for (j in seq_len(nrow(pilot))) {
  p <- pilot[j, ]; f <- p$firm_id
  tx <- real[real$firm_id == f, ]; certain <- tx[tx$window_membership == "within", ]
  years <- seq.int(p$fy0 + 1L, p$fy1)
  opening <- get_panel(f, p$window_start, "mi"); closing <- get_panel(f, p$window_end, "mi")
  delta <- closing - opening
  profit <- strict_sum(vapply(years, function(y) get_panel(f, paste0(y, "-12-31"), "ni_mi"), numeric(1)))
  cash <- strict_sum(vapply(years, function(y) cash_value(f, y, "capital_from_nci"), numeric(1)))
  dividends <- strict_sum(vapply(years, function(y) cash_value(f, y, "dividends_to_nci"), numeric(1)))
  allocated <- setNames(numeric(5), c("D", "G", "H", "E", "U"))
  paid <- certain[nzchar(certain$paid_contribution_rmb) & certain$paid_period %in% paste0("FY", years), ]
  paid$category <- paid$group_category
  if (nrow(paid)) for (k in names(allocated))
    allocated[k] <- sum(num(paid$paid_contribution_rmb[paid$category == k]))
  # A transaction must have explicit paid-period evidence. An announced sum never enters this allocation.
  unattributed <- if (is.na(cash)) NA_real_ else cash - sum(allocated)
  stopifnot(is.na(unattributed) || unattributed >= -0.005)
  residual <- delta - profit + dividends - cash
  miss <- c(if (is.na(delta)) "delta_mi", if (is.na(profit)) "profit_nci",
            if (is.na(dividends)) "dividends_to_nci", if (is.na(cash)) "capital_from_nci")
  state <- c(mi_opening = component_state(f, "mi_opening"), mi_closing = component_state(f, "mi_closing"),
             profit_nci = component_state(f, paste0("profit_nci_", years)),
             dividends_to_nci = component_state(f, paste0("dividends_to_nci_", years)),
             capital_from_nci = component_state(f, paste0("capital_from_nci_", years)))
  m <- data.frame(firm_id = f, group = p$group, row_type = "firm", n_firms = 1L,
    window_start = p$window_start, window_end = p$window_end,
    mi_opening = opening, mi_closing = closing, delta_mi = delta,
    profit_nci = profit, dividends_to_nci = dividends, capital_from_nci = cash,
    cash_D = allocated["D"], cash_G = allocated["G"], cash_H = allocated["H"],
    cash_E = allocated["E"], cash_U = allocated["U"], cash_not_attributed = unattributed,
    residual = residual, decomposition_status = if (length(miss))
      paste0("decomposition incomplete (missing: ", paste(miss, collapse = ", "), ")") else "complete",
    coding_status = "U: full transaction coverage unresolved; see coverage-gap row",
    verification = combine_state(state), stringsAsFactors = FALSE, row.names = NULL)
  for (k in names(state)) m[[paste0(k, "_verification")]] <- state[k]
  m$delta_mi_verification <- combine_state(state[1:2])
  m$residual_verification <- combine_state(state)
  for (k in names(allocated)) {
    pk <- paid[paid$category == k, ]
    # No observed allocation is not a verified zero amount of D/G/H/E/U financing.
    m[[paste0("cash_", k, "_verification")]] <- if (nrow(pk)) combine_state(pk$paid_verification) else "unverified"
  }
  # Only actual allocations are operands; absent allocations are not evidence of zero financing.
  allocated_categories <- unique(paid$category)
  allocation_states <- if (length(allocated_categories))
    unlist(m[paste0("cash_", allocated_categories, "_verification")], use.names = FALSE) else character()
  m$cash_not_attributed_verification <- combine_state(c(state["capital_from_nci"],
    allocation_states))
  m$verification <- combine_state(unlist(m[grep("_verification$", names(m), value = TRUE)]))
  magnitude[[length(magnitude) + 1L]] <- m
  for (cat in c("D", "G", "H", "E", "U")) {
    z <- certain[certain$group_category == cat, ]
    zz <- tx[tx$group_category == cat & !tx$transaction_group_id %in% certain$transaction_group_id, ]
    g <- groups[groups$firm_id == f & groups$transaction_group_id %in% z$transaction_group_id, ]
    proposal <- grepl("minority cash subscription", z$amount_basis, fixed = TRUE) & !nzchar(z$paid_contribution_rmb)
    inkind <- z$amount_basis == "in-kind minority contribution"
    # PI rule (Rework 3): annual-report consideration stays separate from announcement amounts.
    ar_row <- startsWith(z$file, "Daten/annual_reports/")
    compact[[length(compact) + 1L]] <- data.frame(firm_id = f, group = p$group, category = cat,
      lookback_start = paste0(as.integer(substr(p$date0, 1, 4)) - 1, substr(p$date0, 5, 10)),
      coding_window_end = p$date1, participant_rows = nrow(z),
      transaction_count = nrow(g),
      rows_merged = nrow(z) - nrow(g),
      debt_D1_count = sum(g$group_category == "D" & grepl("D1", g$debt_subtypes, fixed = TRUE)),
      debt_D2_count = sum(g$group_category == "D" & grepl("D2", g$debt_subtypes, fixed = TRUE)),
      debt_unspecified_count = sum(g$group_category == "D" & g$debt_subtypes == "D-unspecified"),
      boundary_uncertain_candidates = length(unique(zz$transaction_group_id)),
      group_ids = paste(g$transaction_group_id, collapse = ";"),
      boundary_uncertain_group_ids = paste(unique(zz$transaction_group_id), collapse = ";"),
      proposed_cash_rmb = sum(num(z$minority_contribution_rmb[proposal]), na.rm = TRUE),
      paid_cash_rmb = sum(num(z$paid_contribution_rmb), na.rm = TRUE),
      in_kind_rmb = sum(num(z$minority_contribution_rmb[inkind]), na.rm = TRUE),
      transfer_consideration_rmb = sum(num(z$equity_transfer_price_rmb[!ar_row]), na.rm = TRUE),
      ar_consideration_rmb = sum(num(z$equity_transfer_price_rmb[ar_row]), na.rm = TRUE),
      missing_contribution_amounts = sum(!nzchar(z$minority_contribution_rmb)),
      verification = if (nrow(z)) combine_state(c(z$category_verification, z$amount_verification)) else "unverified",
      notes = "Counts are distinct transaction groups by most severe row category (D, G, H, E, U); amounts sum all rows of those groups. Amounts are separate bases, not additive. Transfer consideration may be issuer outflow; annual-report consideration is the separate ar_consideration_rmb; empty amount is not zero. transaction_count, participant_rows, group_ids and all amounts cover in-window groups only (at least one row with window_membership=within); groups whose rows are all uncertain_boundary are excluded from them and from cash allocation and are shown only in boundary_uncertain_candidates (ids in boundary_uncertain_group_ids). Coverage markers are excluded from all counts.")
  }
}
magnitude <- do.call(rbind, magnitude); compact <- do.call(rbind, compact)
# Pools are ratios of sums over exactly the named group, never means of firm ratios.
# A missing firm component makes that pooled component and pooled residual missing.
amount_cols <- c("mi_opening", "mi_closing", "delta_mi", "profit_nci", "dividends_to_nci", "capital_from_nci",
                 "cash_D", "cash_G", "cash_H", "cash_E", "cash_U", "cash_not_attributed", "residual")
state_cols <- grep("_verification$", names(magnitude), value = TRUE)
for (grp in c("A_mi_crossing", "B_mi_increase_no_crossing")) {
  z <- magnitude[magnitude$group == grp & magnitude$row_type == "firm", ]
  m <- z[1, ]; m$firm_id <- paste0("pooled_", substr(grp, 1, 1)); m$row_type <- "pooled"; m$n_firms <- nrow(z)
  m$window_start <- "firm-specific annual windows"; m$window_end <- "firm-specific annual windows"
  for (k in amount_cols) m[[k]] <- strict_sum(z[[k]])
  for (k in state_cols) m[[k]] <- combine_state(z[[k]])
  m$verification <- combine_state(z$verification)
  m$decomposition_status <- if (anyNA(m[amount_cols])) "decomposition incomplete (one or more firm components missing)" else "complete"
  magnitude <- rbind(magnitude, m)
}
for (k in c("profit_nci", "dividends_to_nci", "cash_D", "cash_G", "cash_H", "cash_E", "cash_U", "cash_not_attributed", "residual")) {
  magnitude[[paste0(k, "_share_delta_mi")]] <- ifelse(magnitude$delta_mi == 0, NA_real_,
    magnitude[[k]] / magnitude$delta_mi * if (k == "dividends_to_nci") -1 else 1)
  magnitude[[paste0(k, "_share_delta_mi_verification")]] <- vapply(seq_len(nrow(magnitude)),
    function(i) combine_state(c(magnitude$delta_mi_verification[i],
                                 magnitude[[paste0(k, "_verification")]][i])), character(1))
}
# Shares of a negative or zero delta MI are not meaningful ("n.m." in the TeX table).
magnitude$shares_meaningful <- !is.na(magnitude$delta_mi) & magnitude$delta_mi > 0
complete <- magnitude$decomposition_status == "complete"
reconstructed <- magnitude$profit_nci - magnitude$dividends_to_nci + magnitude$capital_from_nci + magnitude$residual
gap <- magnitude$delta_mi - reconstructed
stopifnot(all(abs(gap[complete]) < 0.005))
shares <- grep("_share_delta_mi$", names(magnitude), value = TRUE)
stopifnot(all(abs(rowSums(magnitude[complete, shares, drop = FALSE]) - 1) < 0.00000001))
write(compact, "pilot_coding"); write(magnitude, "magnitude")
write(data.frame(firm_id = magnitude$firm_id, complete = complete, accounting_gap_rmb = gap), "accounting_checks")
# Rework 3: capital from NCI attributed to a coded category vs. not attributed, over the ten firms.
# Firms with missing capital from NCI are excluded from both totals (named), never set to zero.
fr <- magnitude[magnitude$row_type == "firm", ]
has_cash <- !is.na(fr$capital_from_nci)
attributed_rmb <- sum(as.matrix(fr[has_cash, c("cash_D", "cash_G", "cash_H", "cash_E", "cash_U")]))
not_attributed_rmb <- sum(fr$cash_not_attributed[has_cash])
total_cash_rmb <- sum(fr$capital_from_nci[has_cash])
stopifnot(abs(attributed_rmb + not_attributed_rmb - total_cash_rmb) < 0.005)
attribution <- data.frame(scope = "ten pilot firms, firm rows",
  firms_with_capital_from_nci = sum(has_cash),
  firms_missing_capital_from_nci = paste(fr$firm_id[!has_cash], collapse = ";"),
  capital_from_nci_rmb = total_cash_rmb, attributed_rmb = attributed_rmb,
  not_attributed_rmb = not_attributed_rmb, attributed_share = attributed_rmb / total_cash_rmb,
  not_attributed_share = not_attributed_rmb / total_cash_rmb,
  attributed_firms = paste(fr$firm_id[has_cash & rowSums(as.matrix(fr[c("cash_D", "cash_G", "cash_H", "cash_E", "cash_U")])) > 0], collapse = ";"),
  verification = combine_state(c(fr$capital_from_nci_verification[has_cash], fr$cash_not_attributed_verification[has_cash])))
write(attribution, "attribution_totals")

# Every numeric table column gets a number -> file -> filter/formula audit row.
source_rows <- list()
for (i in seq_len(nrow(magnitude))) for (k in c(amount_cols, shares)) {
  r <- magnitude[i, ]; v <- if (paste0(k, "_verification") %in% names(r)) r[[paste0(k, "_verification")]] else r$verification
  if (grepl("_share_delta_mi$", k)) {
    base <- sub("_share_delta_mi$", "", k); v <- combine_state(c(r$delta_mi_verification, r[[paste0(base, "_verification")]]))
  }
  source_rows[[length(source_rows) + 1L]] <- data.frame(table = "t044_magnitude.csv", row_id = r$firm_id,
    statistic = k, value = r[[k]], unit = if (k %in% shares) "fraction of signed delta_mi" else "RMB",
    input_file = if (r$row_type == "pooled") "t044_magnitude.csv" else
      "panel_firm_halfyear.csv; nci_cashflow.csv; pilot_coding.csv; t044_component_statements.csv",
    filter_or_formula = if (r$row_type == "pooled") paste0("group=", r$group, "; row_type=firm; strict sum; shares=ratio of sums") else
      paste0("firm_id=", r$firm_id, "; window=(", r$window_start, ",", r$window_end,
             "]; annual ni_mi only; residual=delta-profit+dividends-cash; category cash=explicit paid period; shares=component/delta (dividends negative)"),
    verification = v)
}
for (i in seq_len(nrow(compact))) for (k in c("participant_rows", "transaction_count", "rows_merged", "debt_D1_count", "debt_D2_count", "debt_unspecified_count", "boundary_uncertain_candidates", "proposed_cash_rmb", "paid_cash_rmb", "in_kind_rmb", "transfer_consideration_rmb", "ar_consideration_rmb", "missing_contribution_amounts")) {
  r <- compact[i, ]; source_rows[[length(source_rows) + 1L]] <- data.frame(table = "t044_pilot_coding.csv",
    row_id = paste(r$firm_id, r$category, sep = ":"), statistic = k, value = r[[k]],
    unit = if (grepl("rmb$", k)) "RMB" else "count", input_file = "data/raw/manual/handcollect/pilot_coding.csv",
    filter_or_formula = paste0("firm_id=", r$firm_id, "; group_category=", r$category,
       "; record_type=transaction; window_membership=within except boundary_uncertain_candidates; group_category=most severe row category in transaction_group_id (D,G,H,E,U); count distinct transaction_group_id; separate monetary bases"),
    verification = r$verification)
}
for (k in c("capital_from_nci_rmb", "attributed_rmb", "not_attributed_rmb", "attributed_share", "not_attributed_share"))
  source_rows[[length(source_rows) + 1L]] <- data.frame(table = "t044_attribution_totals.csv",
    row_id = "ten_firms", statistic = k, value = attribution[[k]],
    unit = if (grepl("share$", k)) "fraction of capital_from_nci" else "RMB", input_file = "t044_magnitude.csv",
    filter_or_formula = "row_type=firm; capital_from_nci not NA; attributed=sum cash_D..cash_U; not attributed=sum cash_not_attributed",
    verification = attribution$verification)
write(do.call(rbind, source_rows), "number_sources")

# Subsidiary coverage: compare matched names/units, never set absent opening to zero.
coverage <- list()
clean_name <- function(x) gsub("[[:space:]（）()]|合并", "", x)
for (i in seq_len(nrow(pilot))) {
  p <- pilot[i, ]; f <- p$firm_id
  a <- subs[subs$firm_id == f & subs$report == paste0("FY", p$fy0), ]
  b <- subs[subs$firm_id == f & subs$report == paste0("FY", p$fy1), ]
  if (!nrow(b)) {
    coverage[[length(coverage) + 1L]] <- data.frame(firm_id = f, subsidiary = "not separately disclosed in input", opening_nci_rmb = NA_real_, closing_nci_rmb = NA_real_, change_rmb = NA_real_, opening_file = "", opening_page = "", closing_file = "", closing_page = "", coding_ids = "", coverage = "U; no subsidiary NCI balance table")
    next
  }
  for (j in seq_len(nrow(b))) {
    r <- b[j, ]; old <- a[clean_name(a$subsidiary_name) == clean_name(r$subsidiary_name), ]
    ov <- if (nrow(old) == 1L) num(old$nci_balance_end) * units(old$currency_unit) else NA_real_
    cv <- num(r$nci_balance_end) * units(r$currency_unit)
    tx <- real[real$firm_id == f & vapply(real$subsidiary, function(x)
      grepl(clean_name(r$subsidiary_name), clean_name(x), fixed = TRUE), logical(1)), ]
    coverage[[length(coverage) + 1L]] <- data.frame(firm_id = f, subsidiary = r$subsidiary_name,
      opening_nci_rmb = ov, closing_nci_rmb = cv, change_rmb = cv - ov,
      opening_file = if (nrow(old)) paste0("Daten/annual_reports/", f, "/", f, "_", old$report[1], ".pdf") else "",
      opening_page = if (nrow(old)) old$pdf_page[1] else "",
      closing_file = paste0("Daten/annual_reports/", f, "/", f, "_", r$report, ".pdf"), closing_page = r$pdf_page,
      coding_ids = paste(tx$transaction_id, collapse = ";"), coverage = if (nrow(tx)) "coded candidate(s); no full reconciliation established" else "U; no matched transaction",
      stringsAsFactors = FALSE)
  }
}
coverage <- do.call(rbind, coverage)
coverage$largest_comparable_increase <- FALSE
for (f in pilot$firm_id) {
  ix <- which(coverage$firm_id == f & is.finite(coverage$change_rmb))
  if (length(ix)) coverage$largest_comparable_increase[ix[which.max(coverage$change_rmb[ix])]] <- TRUE
}
coverage$verification <- "unverified"
write(coverage, "subsidiary_coverage")

# Compact English LaTeX; no hand-copied numerical results.
esc <- function(x) gsub("_", "\\_", x, fixed = TRUE)
# Rounded zeros print as 0.00, never -0.00.
fmt <- function(x, scale = 1) {
  s <- ifelse(is.na(x), "NA", sprintf("%.2f", x / scale))
  sub("^-(0\\.00)$", "\\1", s)
}
tex <- c("% T044; amounts RMB million; missing values are NA, not zero.",
         "\\begingroup\\scriptsize", "\\noindent Monetary amounts: RMB million.", "\\begin{longtable}{llrrrrrrrrrl}",
         "Firm & Cat. & N & Rows & Bound.-unc. & Proposed cash & Paid cash & In kind & Transfer & AR cons. & Missing amt. & State \\\\ \\hline")
for (i in seq_len(nrow(compact))) {
  r <- compact[i, ]; tex <- c(tex, paste0(paste(c(esc(r$firm_id), r$category, r$transaction_count, r$participant_rows,
    r$boundary_uncertain_candidates,
    fmt(r$proposed_cash_rmb, 1e6), fmt(r$paid_cash_rmb, 1e6), fmt(r$in_kind_rmb, 1e6),
    fmt(r$transfer_consideration_rmb, 1e6), fmt(r$ar_consideration_rmb, 1e6), r$missing_contribution_amounts, r$verification), collapse = " & "), " \\\\"))
}
tex <- c(tex, "\\end{longtable}",
 "\\noindent Cat.: rubric category D (debt-like), G (group equity), H (hybrid), E (outside equity), U (unclear).",
 "N: distinct transactions (transaction groups); a group takes its most severe row category in the order D, G, H, E, U.",
 "Rows: coded participant/source rows in those groups. Proposed cash: announced minority cash subscriptions without evidenced payment.",
 "Paid cash: minority contributions with explicit paid-period evidence. In kind: in-kind minority contributions.",
 "Transfer: equity transfer consideration in announcements (may be an issuer outflow).",
 "AR cons.: equity transfer consideration from annual-report rows; an annual-report row belongs to the announcement chain of the same subsidiary in the same fiscal year (PI rule), but its amount is kept separate and not added to Transfer.",
 "Missing amt.: rows without a stated minority contribution.",
 "State: verified only if every category and amount statement is PI-verified (amounts: strings or meaning; categories: meaning).",
 "N, Rows and all amounts cover in-window groups only. Bound.-unc.: groups whose dates are all uncertain relative to the window boundary; they are not in N, Rows or the amounts and receive no cash allocation (ids in the CSV).",
 "The ten firm coverage markers are excluded from all counts.",
 "Announced subscriptions, in-kind assets and transfer consideration are separate bases, not additive.",
 "Unallocated zeros mean no documented allocation, not absence of that financing category.",
 "D subtypes (CSV): D1 fixed return/price or shortfall make-up; D2 market-value exit; D-unspecified where the exit-pricing feature is not stated.",
 "An issuer call at a preset price is an H feature (issuer option), not an investor exit at a preset price.", "\\endgroup")
writeLines(tex, paste0(out, "t044_pilot_coding.tex"), useBytes = TRUE)
tex <- c("% T044; signed changes; RMB million. Requires longtable.", "\\begingroup\\scriptsize",
 "\\noindent First panel monetary amounts: RMB million.",
 "\\begin{longtable}{lllrrrrr}", "Firm & Start & End & $\\Delta MI$ & Profit & Dividends & Capital from NCI & Residual \\\\ \\hline")
for (i in seq_len(nrow(magnitude))) {
  r <- magnitude[i, ]; tex <- c(tex, paste0(paste(c(esc(r$firm_id), if (r$row_type == "pooled") "various" else r$window_start,
    if (r$row_type == "pooled") "various" else r$window_end, fmt(unlist(r[c("delta_mi", "profit_nci", "dividends_to_nci", "capital_from_nci", "residual")]), 1e6)), collapse = " & "), " \\\\"))
}
tex <- c(tex, "\\end{longtable}", "\\begin{longtable}{lrrrrrrrrrl}",
 "Firm & D & G & H & E & U & Unattrib. & Profit & $-$Div. & Residual & State \\\\ \\hline")
order_shares <- paste0(c("cash_D", "cash_G", "cash_H", "cash_E", "cash_U", "cash_not_attributed", "profit_nci", "dividends_to_nci", "residual"), "_share_delta_mi")
for (i in seq_len(nrow(magnitude))) {
  r <- magnitude[i, ]
  sh <- if (r$shares_meaningful) fmt(unlist(r[order_shares]) * 100) else rep("n.m.", length(order_shares))
  tex <- c(tex, paste0(paste(c(esc(r$firm_id), sh, r$verification), collapse = " & "), " \\\\"))
}
nm <- esc(magnitude$firm_id[!magnitude$shares_meaningful])
dash <- ledger[ledger$notes == "printed dash = nil", ]
dash_note <- if (nrow(dash)) paste0("Printed dash = nil (coded 0): ", paste(paste0(esc(dash$firm_id), " ",
  sub("^([a-z_]+)_([0-9]{4})$", "FY\\2 \\1", dash$statistic)), collapse = "; "), " (cash-flow statement).") else ""
dash_note <- gsub("_", "\\_", dash_note, fixed = TRUE)
pooled_na <- magnitude$row_type == "pooled" & !complete & magnitude$shares_meaningful
pooled_note <- if (any(pooled_na)) paste0("Pooled rows with NA components (", paste(esc(magnitude$firm_id[pooled_na]), collapse = ", "),
  "): the shown shares do not sum to 100 percent.") else ""
attribution_note <- sprintf(paste0("Over the ten firms (%d with reported capital from NCI; missing: %s), capital from NCI attributed to a coded category is RMB %s million (%.2f percent);",
  " not attributed is RMB %s million (%.2f percent)."), attribution$firms_with_capital_from_nci,
  if (nzchar(attribution$firms_missing_capital_from_nci)) esc(attribution$firms_missing_capital_from_nci) else "none",
  fmt(attribution$attributed_rmb, 1e6), 100 * attribution$attributed_share,
  fmt(attribution$not_attributed_rmb, 1e6), 100 * attribution$not_attributed_share)
tex <- c(tex, "\\end{longtable}",
 "\\noindent First panel: MI = minority (non-controlling) interests in equity; $\\Delta MI$ = closing minus opening MI over the annual window (Start, End].",
 "Profit: profit attributable to NCI in the window. Dividends: dividends paid to NCI (cash-flow statement, positive outflow).",
 "Capital from NCI: cash capital contributions received from NCI (cash-flow statement). Residual = $\\Delta MI$ $-$ Profit + Dividends $-$ Capital from NCI.",
 "Second panel: percent of signed $\\Delta MI$; pools are ratios of sums. D, G, H, E, U: Capital from NCI allocated to that rubric category via explicit paid-period evidence.",
 "Unattrib.: Capital from NCI not attributed to a coded transaction. $-$Div.: minus dividends as a share. State: verification of all row components.",
 paste0("Shares are not meaningful when $\\Delta MI \\le 0$ and are shown as n.m. (", paste(nm, collapse = ", "), ")."),
 "Numeric components require all linked PI statements yes at strings or meaning; categories and clauses require meaning.",
 "Shares also require verified delta MI. Unattributed cash depends on total cash and every actual category allocation.",
 "A missing component makes residual NA.", dash_note, pooled_note, attribution_note,
 "Full transaction coverage is unresolved (U); see the coding input and source audits.",
 "Purposive pilot: mechanism evidence only; no prevalence or causal claim.", "\\endgroup")
writeLines(tex, paste0(out, "t044_magnitude.tex"), useBytes = TRUE)

# Validate immutable input bytes / append-only prefixes against pre-work snapshot.
baseline_json <- r"---([
  {
    "file": "replication/data/raw/manual/handcollect/case_notes.md",
    "bytes": 14612,
    "sha256": "4d3bc86dae8c0fa09a17b725b4b0d13033b0eb38e0bfa456d05583fd365fcfda",
    "mode": "append_only"
  },
  {
    "file": "replication/data/raw/manual/handcollect/case_notes_verification.csv",
    "bytes": 13344,
    "sha256": "3ad479691d3d16b9fb58d15a32faf77304d3028a2573d87743d8376b01f743ae",
    "mode": "row_identity_PI_updates"
  },
  {
    "file": "state/handcollect/pilot_purposive.csv",
    "bytes": 1311,
    "sha256": "9c96de8a953e3875c5d9693d66e9ea137b79529a7ff4c4c0c01291e08acad666",
    "mode": "unchanged"
  },
  {
    "file": "replication/data/raw/manual/handcollect/nci_cashflow.csv",
    "bytes": 10649,
    "sha256": "be8489524d5f4f38a1815eb68c6ac9efda9f06f9931e2e237ac19ce7a7853f99",
    "mode": "unchanged"
  },
  {
    "file": "replication/data/processed/panel_firm_halfyear.csv",
    "bytes": 1517469,
    "sha256": "9b868659fbc52d2a5d67efb6a1889ca1bbd695731ca30bf17a0a5c3c54c1cb26",
    "mode": "unchanged"
  },
  {
    "file": "replication/data/raw/manual/handcollect/transactions.csv",
    "bytes": 1549420,
    "sha256": "479340ca5f4469b4ee0e1f3cca0791e4ab180179ada20ba8174dccb181d17c76",
    "mode": "unchanged"
  }
])---"
writeLines(baseline_json, paste0(out, "t044_input_integrity.json"), useBytes = TRUE)
baseline <- jsonlite::fromJSON(baseline_json)
# Historic file hash is retained; the old CSV body was not retained. Recover the
# original 46 ID/text pairs from the SHA-validated original case_notes prefix.
# Metadata below is the frozen approved-rework checkpoint, not invented old bytes.
verification_baseline_json <- r"---({
  "historical_sha256": "3ad479691d3d16b9fb58d15a32faf77304d3028a2573d87743d8376b01f743ae",
  "checkpoint_sha256": "bc103ca78a849542cc7efceff8b46d7a37b84ebe426f730152b2683a7c102dd0",
  "provenance": "Original 46 row identities recovered from immutable 14612-byte case_notes.md prefix and surviving CSV row order. Mutable metadata captured at start of approved rework; original metadata bytes were not retained. Prior PI updates are authorized by T044 Rework 1.",
  "original_rows": [
    {
      "statement_id": "600325.SH:L6",
      "firm": "600325.SH",
      "line": "6",
      "status": "yes",
      "level": "meaning",
      "auto_found": "495,025.00; 4,975.00; 珠海华发城市运营投资控股有限公司; 珠海城市建设集团有限公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:44",
      "statement": "The May 2021 Haichuan proposal allocates cash contributions of 495,025.00万元 each to the issuer and 珠海华发城市运营投资控股有限公司 and 4,975.00万元 to 珠海城市建设集团有限公司, at unchanged ownership percentages."
    },
    {
      "statement_id": "600325.SH:L7",
      "firm": "600325.SH",
      "line": "7",
      "status": "yes",
      "level": "meaning",
      "auto_found": "1,980,099.5025; 19,900.4975",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-27 12:44",
      "statement": "The October 2021 Haichuan proposal allocates 1,980,099.5025万元 each to the first two parties and 19,900.4975万元 to the third party, with surplus-fund draws at negotiated market rates and a ten-working-day payment deadline after notice."
    },
    {
      "statement_id": "600325.SH:L8",
      "firm": "600325.SH",
      "line": "8",
      "status": "yes",
      "level": "meaning",
      "auto_found": "华发集团",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:45",
      "statement": "The two minority participants are subsidiaries of 华发集团, the controlling shareholder, and the document identifies the transaction as related-party investment."
    },
    {
      "statement_id": "600325.SH:L9",
      "firm": "600325.SH",
      "line": "9",
      "status": "yes",
      "level": "meaning",
      "auto_found": "54,412.1629; 49.75%; 50.2000%",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-27 12:45",
      "statement": "The March 2022 Haichuan proposal is issuer-only: 54,412.1629万元, with minority holders explicitly not participating and the issuer stake rising from 49.75% to 50.2000%."
    },
    {
      "statement_id": "600325.SH:L10",
      "firm": "600325.SH",
      "line": "10",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:46",
      "statement": "The March announcement retains consolidation and permits surplus-fund draws at negotiated market rates; equity buyback, guaranteed investor return and investor put clauses are not documented in the disclosed agreement summary."
    },
    {
      "statement_id": "600325.SH:L11",
      "firm": "600325.SH",
      "line": "11",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "032; 3,201,194,129.84; 44,823,409,959.97; 41,622,215,830.13",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:46",
      "statement": "The T032 Haichuan balance increases from RMB3,201,194,129.84 at FY2020 to RMB44,823,409,959.97 at FY2021 (difference RMB41,622,215,830.13); the announcements do not provide a reconciliation of this balance change ."
    },
    {
      "statement_id": "600325.SH:L12",
      "firm": "600325.SH",
      "line": "12",
      "status": "yes",
      "level": "meaning",
      "auto_found": "90%",
      "auto_missing": "深圳市润陇投资有限公司",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:47",
      "statement": "Separately, the Wuxi investment discloses 深圳市润陇投资有限公司’s right to require a buyback after the specified 90% residential-sales threshold, with price based on an agreed independent market valuation."
    },
    {
      "statement_id": "002314.SZ:L52",
      "firm": "002314.SZ",
      "line": "52",
      "status": "yes",
      "level": "meaning",
      "auto_found": "350,000; 31.40%; 53.07%",
      "auto_missing": "杭州萧山平安基石贰号股权投资有限公司; 宝湾物流控股有限公司",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-27 12:47",
      "statement": "杭州萧山平安基石贰号股权投资有限公司 subscribes RMB350,000万元 into 宝湾物流控股有限公司 for a resulting 31.40% interest, while the listed issuer retains 53.07%."
    },
    {
      "statement_id": "002314.SZ:L53",
      "firm": "002314.SZ",
      "line": "53",
      "status": "yes",
      "level": "meaning",
      "auto_found": "99.99667%; 中国平安人寿保险股份有限公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-27 12:47",
      "statement": "The investment vehicle’s disclosed ownership is 99.99667% 中国平安人寿保险股份有限公司; the vehicle is coded asset_mgmt and the document states no related relationship to the issuer."
    },
    {
      "statement_id": "002314.SZ:L54",
      "firm": "002314.SZ",
      "line": "54",
      "status": "yes",
      "level": "meaning",
      "auto_found": "2.1",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-27 12:47",
      "statement": "The agreement discloses a qualified best-efforts annual distributable-profit target of RMB2.1亿元, priority dividends, and four of seven board appointments by the listed issuer."
    },
    {
      "statement_id": "002314.SZ:L55",
      "firm": "002314.SZ",
      "line": "55",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-27 12:48",
      "statement": "The 南山方 call option has alternative price formulas if valuation cannot be agreed; if the call is not exercised, the investor may demand more dividends, governance changes or drag-along, while an investor put and unconditional guaranteed yield are not stated."
    },
    {
      "statement_id": "002314.SZ:L56",
      "firm": "002314.SZ",
      "line": "56",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "032; 1,060,250,627.37; 3,943,397,471.92; 2,883,146,844.55; 宝湾物流",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-27 12:48",
      "statement": "T032 records 宝湾物流 NCI rising from RMB1,060,250,627.37 to RMB3,943,397,471.92 between FY2020 and FY2021 (difference RMB2,883,146,844.55), without allocating consolidated NCI cash to that subsidiary ."
    },
    {
      "statement_id": "002314.SZ:L57",
      "firm": "002314.SZ",
      "line": "57",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-27 12:48",
      "statement": "The separate 海城锦 subscription newly brings that entity into consolidation; its minority balance therefore must not be treated as proof of new external minority cash."
    },
    {
      "statement_id": "600208.SH:L33",
      "firm": "600208.SH",
      "line": "33",
      "status": "yes",
      "level": "strings",
      "auto_found": "35%; 190,000; 517,372,740.78; 上海中瀚置业有限公司; 绿城房地产集团有限公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:33",
      "statement": "The 上海中瀚置业有限公司 deal transfers 35% equity to 绿城房地产集团有限公司 with total investment/consideration of 190,000万元, of which the equity price is RMB517,372,740.78."
    },
    {
      "statement_id": "600208.SH:L34",
      "firm": "600208.SH",
      "line": "34",
      "status": "open",
      "level": "strings",
      "auto_found": "浙江启智实业有限公司; 南通新湖置业有限公司",
      "auto_missing": "Other Greentown",
      "comment": "da steht nur chinesisches drin und kein englisch [Co-PI: Sprachproblem, kein Fehlerbefund → offen]",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:38",
      "statement": "Other Greentown transactions cover 浙江启智实业有限公司 and 南通新湖置业有限公司; consideration and development funding are distinguished from equity purchase prices."
    },
    {
      "statement_id": "600208.SH:L35",
      "firm": "600208.SH",
      "line": "35",
      "status": "yes",
      "level": "strings",
      "auto_found": "35%; 新湖地产",
      "auto_missing": "浙江启辉实业有限公司; 上海甚鹏企业管理有限公司",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:38",
      "statement": "For 浙江启辉实业有限公司, 上海甚鹏企业管理有限公司 has an exit right by transferring its 35% equity and shareholder debt to 新湖地产 under the agreement."
    },
    {
      "statement_id": "600208.SH:L36",
      "firm": "600208.SH",
      "line": "36",
      "status": "yes",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:33",
      "statement": "The exit provision includes the condition of three years after equity delivery; a full reconciliation of the pilot NCI change is not documented in this transaction."
    },
    {
      "statement_id": "000517.SZ:L15",
      "firm": "000517.SZ",
      "line": "15",
      "status": "yes",
      "level": "meaning",
      "auto_found": "188,435; 台州荣宁企业管理咨询有限公司; 杭州弘誉房地产开发有限公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:05",
      "statement": "The issuer proposes 188,435万元 of additional cash for 台州荣宁企业管理咨询有限公司, whose existing other shareholder is 杭州弘誉房地产开发有限公司; the disclosed equity proportions remain unchanged."
    },
    {
      "statement_id": "000517.SZ:L16",
      "firm": "000517.SZ",
      "line": "16",
      "status": "yes",
      "level": "meaning",
      "auto_found": "宁波旭禾企业管理咨询有限公司; 宁波锦官置业有限公司",
      "auto_missing": "50,949",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:05",
      "statement": "For 宁波旭禾企业管理咨询有限公司 the listed group contributes 50,949万元 and the other shareholder is 宁波锦官置业有限公司, again with unchanged equity proportions."
    },
    {
      "statement_id": "000517.SZ:L17",
      "firm": "000517.SZ",
      "line": "17",
      "status": "yes",
      "level": "meaning",
      "auto_found": "40%; 宁波荣港置业有限公司; 宁波开晟投资有限公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:05",
      "statement": "The 宁波荣港置业有限公司 capital increase names 宁波开晟投资有限公司 as the existing 40% shareholder; its incremental minority contribution is not separately stated."
    },
    {
      "statement_id": "000517.SZ:L18",
      "firm": "000517.SZ",
      "line": "18",
      "status": "yes",
      "level": "meaning",
      "auto_found": "宁波荣安资产管理有限公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:05",
      "statement": "A separate proposed 51:49 JV names 宁波荣安资产管理有限公司, a wholly owned subsidiary of the controlling shareholder, as the minority participant; the JV legal name awaits registration."
    },
    {
      "statement_id": "000517.SZ:L19",
      "firm": "000517.SZ",
      "line": "19",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "绍安企管",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:06",
      "statement": "The 绍安企管 purchase includes seller compensation if eventual project net assets fall below the agreed equity price; this clause concerns compensation to the issuer in that purchase."
    },
    {
      "statement_id": "000517.SZ:L20",
      "firm": "000517.SZ",
      "line": "20",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:06",
      "statement": "A reconciliation connecting these proposed contributions to the main consolidated NCI increase is not documented in this capital-increase announcement."
    },
    {
      "statement_id": "3900.HK:L46",
      "firm": "3900.HK",
      "line": "46",
      "status": "yes",
      "level": "strings",
      "auto_found": "7.5%; Harbin Metro RED; CCCC Northeast Investment; Harbin Greentown Real Estate",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:34",
      "statement": "The Harbin project discloses shareholder-loan commitments at 7.5% per annum, including Harbin Metro RED, CCCC Northeast Investment and Harbin Greentown Real Estate; these are loans rather than equity subscriptions."
    },
    {
      "statement_id": "3900.HK:L47",
      "firm": "3900.HK",
      "line": "47",
      "status": "yes",
      "level": "strings",
      "auto_found": "46%; 10%; 44%; CCCC Northeast Investment; Harbin Metro RED",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:34",
      "statement": "The Company, CCCC Northeast Investment and Harbin Metro RED hold 46%, 10% and 44% respectively of the project company."
    },
    {
      "statement_id": "3900.HK:L48",
      "firm": "3900.HK",
      "line": "48",
      "status": "yes",
      "level": "strings",
      "auto_found": "Greentown Real Estate",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The WZ disclosure lists bank guarantees and ABS/ABN shortfall support by Greentown Real Estate, rather than new minority-equity contributions."
    },
    {
      "statement_id": "3900.HK:L49",
      "firm": "3900.HK",
      "line": "49",
      "status": "yes",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "Minority-equity contributions explaining the main pilot NCI change are not documented in this shareholder-loan disclosure."
    },
    {
      "statement_id": "000838.SZ:L39",
      "firm": "000838.SZ",
      "line": "39",
      "status": "open",
      "level": "strings",
      "auto_found": "721.21; 339.4; 35%; 32%",
      "auto_missing": "垫江丰厚; 重庆财信弘业房地产开发有限公司; 重庆宏耀盛科技发展有限公司",
      "comment": "da stehen viel längere wörter aber mit den selben buchstaben drin keine Ahnung [Co-PI: Sprachproblem, kein Fehlerbefund → offen]",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:39",
      "statement": "The 垫江丰厚 capital increase assigns 721.21万元 to 重庆财信弘业房地产开发有限公司 and 339.4万元 to 重庆宏耀盛科技发展有限公司, resulting in 35% and 32% respectively."
    },
    {
      "statement_id": "000838.SZ:L40",
      "firm": "000838.SZ",
      "line": "40",
      "status": "yes",
      "level": "strings",
      "auto_found": "122,547,513,; 宏耀盛公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The announcement states that 宏耀盛公司 has no related relationship with the listed firm and separately discloses an assumed debt of RMB122,547,513, which is not coded as equity capital."
    },
    {
      "statement_id": "000838.SZ:L41",
      "firm": "000838.SZ",
      "line": "41",
      "status": "yes",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The introduction and the numbered agreement allocation differ on the contributor label; the coding follows the numbered allocation and flags this inconsistency rather than inferring a correction."
    },
    {
      "statement_id": "000838.SZ:L42",
      "firm": "000838.SZ",
      "line": "42",
      "status": "yes",
      "level": "strings",
      "auto_found": "6,000; 中航国际租赁有限公司; 财信弘业公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "A separate RMB6,000万元 finance lease names 中航国际租赁有限公司 and discloses a three-year term with guarantees by the issuer and 财信弘业公司."
    },
    {
      "statement_id": "000838.SZ:L43",
      "firm": "000838.SZ",
      "line": "43",
      "status": "yes",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "A reconciliation explaining the main pilot NCI balance change is not documented in the capital-increase announcement."
    },
    {
      "statement_id": "1638.HK:L26",
      "firm": "1638.HK",
      "line": "26",
      "status": "open",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "Mr Kwok Ying Shing",
      "comment": "only on behalf of  Mr Kwok Ying Shing [Co-PI: Sprachproblem, kein Fehlerbefund → offen]",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:40",
      "statement": "The acquisition vendors are controlled by chairman, executive director and substantial shareholder Mr Kwok Ying Shing."
    },
    {
      "statement_id": "1638.HK:L27",
      "firm": "1638.HK",
      "line": "27",
      "status": "yes",
      "level": "strings",
      "auto_found": "3.2%",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The acquired target groups enter consolidation on completion; the disclosure includes the chairman’s retained indirect 3.2% interest in Target C."
    },
    {
      "statement_id": "1638.HK:L28",
      "firm": "1638.HK",
      "line": "28",
      "status": "yes",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The acquisition includes shareholder debts defined as non-interest bearing; the purchase consideration is not coded as new minority cash."
    },
    {
      "statement_id": "1638.HK:L29",
      "firm": "1638.HK",
      "line": "29",
      "status": "yes",
      "level": "strings",
      "auto_found": "Eagle Legend",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The April 2021 Eagle Legend completion update states that Eagle Legend becomes a subsidiary through the disclosed offeror/concert arrangements."
    },
    {
      "statement_id": "1638.HK:L30",
      "firm": "1638.HK",
      "line": "30",
      "status": "yes",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "These acquisition disclosures are dated 2021 and do not document the counterparties or terms of a 2020 minority-equity injection explaining the pilot-period change."
    },
    {
      "statement_id": "001979.SZ:L60",
      "firm": "001979.SZ",
      "line": "60",
      "status": "yes",
      "level": "meaning",
      "auto_found": "72,908,360,000; 50%; 前海投控",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:08",
      "statement": "The completed Qianhai recapitalisation records 前海投控 contributing RMB72,908,360,000 of equity in kind, with each shareholder retaining 50% of the JV."
    },
    {
      "statement_id": "001979.SZ:L61",
      "firm": "001979.SZ",
      "line": "61",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:08",
      "statement": "The listed company explicitly retains control after the Qianhai transaction."
    },
    {
      "statement_id": "001979.SZ:L62",
      "firm": "001979.SZ",
      "line": "62",
      "status": "yes",
      "level": "meaning",
      "auto_found": "242,212.82; 849,995.71",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:08",
      "statement": "The separate funding-source amendment redirects 242,212.82万元 of already raised proceeds into the 849,995.71万元 issuer-side cash contribution to the same JV."
    },
    {
      "statement_id": "001979.SZ:L63",
      "firm": "001979.SZ",
      "line": "63",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:08",
      "statement": "The four disclosed project companies allow shareholder surplus-cash borrowings with individual ceilings of 14/12/23/26亿元, no interest, and unconditional early repayment on demand by the project company."
    },
    {
      "statement_id": "001979.SZ:L64",
      "firm": "001979.SZ",
      "line": "64",
      "status": "yes",
      "level": "meaning",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-28 16:08",
      "statement": "The Qianhai disclosure distinguishes the in-kind contribution from issuer-side cash; a full reconciliation to the main consolidated pilot NCI change is not documented on this completion disclosure page."
    },
    {
      "statement_id": "600565.SH:L67",
      "firm": "600565.SH",
      "line": "67",
      "status": "yes",
      "level": "strings",
      "auto_found": "2019,; 20,000; 23,000; 100%; 55.56%; 江苏农华智慧农业科技股份有限公司; 重庆迪马睿升实业有限公司",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "In January 2019, 江苏农华智慧农业科技股份有限公司 contributes RMB20,000万元 and the issuer contributes RMB23,000万元 to 重庆迪马睿升实业有限公司, reducing the issuer’s ownership from 100% to 55.56%."
    },
    {
      "statement_id": "600565.SH:L68",
      "firm": "600565.SH",
      "line": "68",
      "status": "yes",
      "level": "strings",
      "auto_found": "农华智慧",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The document identifies 农华智慧 and the issuer as enterprises controlled by the same actual controller, so the incoming equity participant is coded group_affiliate."
    },
    {
      "statement_id": "600565.SH:L69",
      "firm": "600565.SH",
      "line": "69",
      "status": "yes",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The agreement gives the minority holder a same-terms tag-along right when the issuer sells equity to a third party, at no less than fair value."
    },
    {
      "statement_id": "600565.SH:L70",
      "firm": "600565.SH",
      "line": "70",
      "status": "yes",
      "level": "strings",
      "auto_found": "",
      "auto_missing": "",
      "comment": "",
      "verified_by": "PI",
      "timestamp": "2026-10-26 20:35",
      "statement": "The announcement retains consolidation and states no debt or guarantee dealings between the issuer and the related party; it does not reconcile this transaction to the pilot’s main consolidated NCI change."
    }
  ]
})---"
writeLines(verification_baseline_json, paste0(out, "t044_verification_baseline.json"), useBytes = TRUE)
verification_baseline <- jsonlite::fromJSON(verification_baseline_json)
original_rows <- verification_baseline$original_rows
stopifnot(nrow(original_rows) == 46L, !anyDuplicated(verification$statement_id))
row_audit <- list()
original_note_lines <- readLines(textConnection(rawToChar(head(
  readBin(paste0(raw, "case_notes.md"), "raw", n = 14612L), 14612L))), warn = FALSE)
for (i in seq_len(nrow(original_rows))) {
  r <- original_rows[i, ]; now <- verification[verification$statement_id == r$statement_id, , drop = FALSE]
  original_statement <- trimws(gsub("\\[[^][]+\\]", "", original_note_lines[as.integer(r$line)]))
  recovered_ok <- r$statement == original_statement && r$statement_id == paste0(r$firm, ":L", r$line)
  changed <- if (nrow(now) == 1L) names(r)[vapply(names(r), function(k) now[[k]] != r[[k]], logical(1))] else names(r)
  allowed <- c("status", "level", "verified_by", "timestamp", "comment", grep("^auto_", names(r), value = TRUE))
  permitted <- nrow(now) == 1L && all(changed %in% allowed) &&
    (!length(changed) || now$verified_by == "PI")
  row_audit[[i]] <- data.frame(statement_id = r$statement_id, original_statement_preserved = recovered_ok &&
    nrow(now) == 1L && now$statement == r$statement,
    changed_since_rework_checkpoint = paste(changed, collapse = ";"),
    metadata_change_permitted = permitted, pass = recovered_ok && permitted)
}
row_audit <- do.call(rbind, row_audit)
write(row_audit, "verification_row_checks")
integrity <- baseline
for (i in seq_len(nrow(baseline))) {
  p <- file.path("..", baseline$file[i]); full <- readBin(p, "raw", n = file.info(p)$size)
  integrity$current_file_sha256[i] <- digest::digest(full, algo = "sha256", serialize = FALSE)
  integrity$old_file_sha256[i] <- baseline$sha256[i]
  b <- if (baseline$mode[i] == "append_only") head(full, baseline$bytes[i]) else full
  integrity$observed_sha256[i] <- digest::digest(b, algo = "sha256", serialize = FALSE)
  integrity$pass[i] <- if (baseline$mode[i] == "row_identity_PI_updates") all(row_audit$pass) else
    integrity$observed_sha256[i] == baseline$sha256[i]
}
write(integrity, "input_integrity_checks"); stopifnot(all(integrity$pass))
summaries <- character()
for (f in pilot$firm_id) {
  z <- compact[compact$firm_id == f, ]; m <- magnitude[magnitude$firm_id == f, ]
  summaries <- c(summaries, paste0(f, ": in-window transactions ", sum(z$transaction_count), " (", sum(z$participant_rows),
      " rows, ", sum(z$rows_merged), " merged into groups); boundary-uncertain groups (not counted) ", sum(z$boundary_uncertain_candidates), "; firm coverage U."),
    paste0("In-window categories: ", paste(paste0(z$category, "=", z$transaction_count), collapse = ", "),
      "; D1=", sum(z$debt_D1_count), "; D2=", sum(z$debt_D2_count), "; D-unspecified=", sum(z$debt_unspecified_count), "."),
    paste0("Magnitude ", m$window_start, " to ", m$window_end, ": delta MI RMB million ", fmt(m$delta_mi, 1e6),
      "; allocated H cash ", fmt(m$cash_H, 1e6), "; residual ", fmt(m$residual, 1e6), "; ", m$decomposition_status, "; ", m$verification, "."))
}
writeLines(summaries, paste0(out, "t044_firm_summaries.txt"), useBytes = TRUE)
cat(sprintf("T044 coding: %d transaction/participant rows in %d transaction groups; %d U coverage markers; %d evidence checks PASS.\n",
            nrow(real), nrow(groups), sum(coding$record_type == "coverage_gap"), nrow(evidence_check)))
cat(sprintf("T044 check sample: %d rows (all D/G/H plus 5 random U, seed 20261028).\n", nrow(check_sample)))
cat(sprintf("T044 annual decomposition: %d/10 firms complete; %d incomplete; accounting identities PASS to RMB 0.005.\n",
            sum(complete[magnitude$row_type == "firm"]), sum(!complete[magnitude$row_type == "firm"])))
cat(sprintf("T044 capital from NCI (%d firms): attributed RMB %s million (%.2f%%), not attributed RMB %s million (%.2f%%).\n",
            attribution$firms_with_capital_from_nci, fmt(attribution$attributed_rmb, 1e6), 100 * attribution$attributed_share,
            fmt(attribution$not_attributed_rmb, 1e6), 100 * attribution$not_attributed_share))
cat(sprintf("T044 verification: %d statements awaiting required PI check (numeric: strings/meaning; qualitative: meaning); no unverified figure labelled verified.\n", sum(!statements$verified)))
cat("T044 input preservation: note prefix, 46 original verification ID/text rows, PI-only metadata updates and protected inputs PASS.\n")
cat("T044 outputs: t044_pilot_coding.csv/.tex; t044_magnitude.csv/.tex; source, sample and verification audits.\n")
