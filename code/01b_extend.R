# T030: separate extension through 2024H2; no estimates and no network access.
# Run from replication/: Rscript code/01b_extend.R
suppressPackageStartupMessages({library(data.table); library(readxl)})
source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(width = 160)
main_path <- "data/processed/panel_firm_halfyear.csv"
protected <- c(main_path, list.files("data/raw", recursive = TRUE, full.names = TRUE),
               list.files("outputs", recursive = TRUE, full.names = TRUE))
protected <- protected[!dir.exists(protected) & !startsWith(basename(protected), "t030_")]
protected_hash <- tools::sha256sum(protected)
main <- fread(main_path, na.strings = "NA", colClasses = c(firm_id = "character"))
main[, `:=`(date = as.IDate(date), report_date = as.IDate(report_date))]
stopifnot(nrow(main) == 2279L, ncol(main) == 89L, uniqueN(main$firm_id) == 184L,
          !anyDuplicated(main[, .(firm_id, date)]), all(main$has_row))
cutoff <- as.IDate("2022-12-31")
target_dates <- as.IDate(c("2016-12-31", as.vector(rbind(
  paste0(2017:2024, "-06-30"), paste0(2017:2024, "-12-31")))))
new_dates <- target_dates[target_dates > cutoff]

# Cleaning below is copied VERBATIM from 01_clean.R, without its publication
# code or treatment/ownership re-estimation. Assert the full copied block equals
# the current original before running it. Only target_dates changes (above).
original_lines <- readLines("code/01_clean.R", warn = FALSE)
this_lines <- readLines("code/01b_extend.R", warn = FALSE)
start_marker <- "# Actual calendar-day distance, including candidates outside the target window."
end_marker <- "# T012: construct treatments once, on the same published source rows as T011."
original_block <- original_lines[seq.int(match(start_marker, original_lines),
                                       match(end_marker, original_lines) - 1L)]
copy_start <- match("# BEGIN VERBATIM CLEANING", this_lines) + 1L
copy_end <- match("# END VERBATIM CLEANING", this_lines) - 1L
if (!identical(original_block, this_lines[seq.int(copy_start, copy_end)]))
  stop("STOP T030: copied cleaning block differs from 01_clean.R.")
cat("T030 ASSERT: copied cleaning block is identical to 01_clean.R.\n")

# BEGIN VERBATIM CLEANING
# Actual calendar-day distance, including candidates outside the target window.
# Do not restrict the candidates to target_dates: that would pull out-of-window
# reports into the sample. Among equally distant candidates choose the earlier one.
nearest_halfyear <- function(report_date) {
  d <- as.IDate(substr(as.character(report_date), 1L, 10L))
  if (anyNA(d)) stop("Unparseable HK REPORT_DATE.", call. = FALSE)
  years <- seq.int(as.integer(format(min(d), "%Y")) - 1L,
                   as.integer(format(max(d), "%Y")) + 1L)
  candidates <- sort(as.IDate(c(paste0(years, "-06-30"),
                                paste0(years, "-12-31"))))
  unique_days <- unique(d)
  mapped <- vapply(as.integer(unique_days), function(day) {
    distance <- abs(as.integer(candidates) - day)
    min(as.integer(candidates)[distance == min(distance)])
  }, integer(1))
  as.IDate(mapped[match(d, unique_days)], origin = "1970-01-01")
}

# Read every listed input locally and without modifying it. Character code
# columns preserve leading zeroes. readxl is mandatory; there is no fallback.
csv_files <- c(
  "raw_a_balance.csv", "raw_a_income.csv", "raw_hk_balance.csv",
  "raw_hk_income.csv", "delisted_hk_balance.csv", "delisted_hk_income.csv",
  "firm_list.csv"
)
raw <- setNames(lapply(csv_files, function(f) {
  fread(file.path("data/raw/eastmoney", f),
        colClasses = list(character = "code"))
}), csv_files)
delisted <- fread("data/raw/wind/delistete_immobilienfirmen.csv",
                  colClasses = list(character = "code"))
# T012 rework: freeze the T003 catalogue names (diagnostics only) and the
# complete set of flagged fiscal-year codes used by delivered T004.
# t003_hk_items.csv SHA-256: 8db025e91346eb625e23680dd1ae03897f81bbc2581302a90b249d5ba209e8e3
# t003_hk_fiscal_year_ends.csv SHA-256: f1546b8f4f6574a8ea480cd58a23e9d2e74271828fe7928268a6bdb91bc47a63
hk_items <- data.table(STD_ITEM_NAME = c(
  "固定资产",
  "物业厂房及设备",
  "投资物业",
  "无形资产",
  "商誉",
  "负商誉",
  "土地使用权",
  "在建工程",
  "递延税项资产",
  "预付款项",
  "长期应收款",
  "开发支出",
  "联营公司权益",
  "附属公司权益",
  "合营公司权益",
  "长期投资",
  "证券投资",
  "其他投资",
  "其他非流动资产",
  "指定以公允价值记账之金融资产",
  "衍生金融工具-资产",
  "持有至到期投资",
  "贷款及垫款",
  "可供出售投资",
  "长期待摊费用",
  "现金及等价物(非流动)",
  "中长期存款",
  "其他金融资产(非流动)",
  "非流动资产其他项目",
  "非流动资产合计",
  "存货",
  "发展中及待售物业",
  "应收帐款",
  "应收票据",
  "预付款按金及其他应收款",
  "应收关联方款项",
  "预缴及应收税项",
  "短期投资",
  "受限制存款及现金",
  "现金及等价物",
  "短期存款",
  "其他流动资产",
  "指定以公允价值记账之金融资产(流动)",
  "交易性金融资产(流动)",
  "衍生金融工具-资产(流动)",
  "持有至到期投资(流动)",
  "可供出售投资(流动)",
  "持作出售的资产(流动)",
  "贷款及垫款(流动)",
  "生产性生物资产",
  "其他金融资产(流动)",
  "合同资产",
  "流动资产其他项目",
  "流动资产合计",
  "资产其他项目",
  "总资产",
  "应付帐款",
  "应付票据",
  "应付税项",
  "应付股利",
  "应付关联方款项(流动)",
  "融资租赁负债(流动)",
  "递延收入(流动)",
  "其他应付款及应计费用",
  "预收款项",
  "短期贷款",
  "拨备(流动)",
  "其他流动负债",
  "交易性金融负债(流动)",
  "指定以公允价值记账之金融负债(流动)",
  "衍生金融工具-负债(流动)",
  "持作出售的负债(流动)",
  "财务担保合同及负债(流动)",
  "职工薪酬及福利(流动)",
  "应付债券",
  "其他金融负债(流动)",
  "合同负债",
  "流动负债其他项目",
  "流动负债合计",
  "净流动资产",
  "总资产减流动负债",
  "总资产减总负债合计",
  "长期贷款",
  "递延税项负债",
  "应付关联方款项(非流动)",
  "融资租赁负债(非流动)",
  "递延收入(非流动)",
  "可转换票据及债券",
  "拨备(非流动)",
  "长期应付款",
  "其他非流动负债",
  "指定以公允价值记账之金融负债",
  "衍生金融工具-负债",
  "预收账款(非流动)",
  "财务担保合同及负债(非流动)",
  "职工薪酬及福利(非流动)",
  "预计负债",
  "应付票据(非流动)",
  "其他金融负债(非流动)",
  "可转换可赎回优先股",
  "非流动负债其他项目",
  "非流动负债合计",
  "负债其他项目",
  "总负债",
  "少数股东权益",
  "净资产",
  "股本",
  "储备",
  "股本溢价",
  "保留溢利(累计亏损)",
  "公积金",
  "拟派股息",
  "汇兑储备",
  "其他储备",
  "可转换债券及票据",
  "库存股",
  "其他综合性收益",
  "外币报表折算差额",
  "其他权益工具",
  "永久资本证券",
  "股东权益其他项目",
  "股东权益",
  "其他权益",
  "总权益",
  "总权益及非流动负债",
  "总权益及总负债",
  "非运算项目"
))
fye <- data.table(code = c("00207", "00221", "00275", "00278", "00283", "00459", "00495", "00996", "01246", "01329", "01730"))
wind_files <- c(
  "wind_A_delistet_v2.xlsx", "wind_HK_delistet_v2.xlsx",
  "wind_A_gelistet_eigentum.xlsx", "Sicherung_A_1.xlsx",
  "sicherung_HK_3.xlsx", "sicherung_HK_1.xlsx", "sicherung_HK_2.xlsx"
)
wind <- setNames(lapply(wind_files, function(f) {
  x <- tryCatch(
    read_excel(file.path("data/raw/wind", f),
               col_types = "text", .name_repair = "minimal"),
    error = function(e) stop("STOP: readxl cannot read ", f, ": ",
                              conditionMessage(e), call. = FALSE)
  )
  code <- x[[1L]]
  x[!is.na(code) & nzchar(trimws(code)) &
      !grepl("数据来源", code, fixed = TRUE), , drop = FALSE]
}), wind_files)
cat("Preflight: all CSV inputs and all 7 Wind workbooks read successfully.\n")
cat("Wind firm counts:", paste(vapply(wind, nrow, integer(1)), collapse = ", "), "\n")

# Detect collisions separately for each input, before any join or source
# priority. All these rows are EastMoney; EastMoney/Wind priority cannot resolve
# two different REPORT_DATE values from the same source.
hk_files <- c("raw_hk_balance.csv", "raw_hk_income.csv",
              "delisted_hk_balance.csv", "delisted_hk_income.csv")
report_map <- rbindlist(lapply(hk_files, function(f) {
  x <- unique(raw[[f]][as.integer(DATE_TYPE_CODE) %in% c(1L, 2L),
                       .(code, SECURITY_NAME_ABBR, REPORT_DATE)])
  x[, report_date := as.IDate(substr(as.character(REPORT_DATE), 1L, 10L))]
  x[, date := nearest_halfyear(report_date)]
  x[, input_file := f]
  x[date %in% target_dates & code != "02768"]
}))
report_map[, firm_id := sprintf("%04d.HK", as.integer(code))]
collisions <- report_map[, .(
  n_reports = uniqueN(report_date),
  report_dates = paste(sort(unique(report_date)), collapse = ";")
), by = .(input_file, firm_id, date)][n_reports > 1L]
setorder(collisions, input_file, firm_id, date)

if (nrow(collisions)) {
  print(collisions, nrows = nrow(collisions))
  stop("STOP: firm x date is not unique after the revised HK date rule.",
       call. = FALSE)
}
cat("HK revised date rule: 0 within-file report-date collisions.\n")
cat("HK balance firm-dates on target dates:", uniqueN(
  report_map[input_file %in% c("raw_hk_balance.csv", "delisted_hk_balance.csv")],
  by = c("firm_id", "date")), "\n")

# Wind headers encode the financial year and half (e.g. 2016中报), rather
# than an ISO date in these exports. Parse only the explicit report-period
# field, never the ownership observation date. Currency is kept as exported.
wind_assets <- function(x, market, input_file) {
  headers <- names(x)
  item <- trimws(sub("[\r\n].*", "", headers))
  columns <- which(item == "资产总计")
  if (!length(columns)) stop("STOP: Wind total-assets item missing: ", input_file)
  rbindlist(lapply(columns, function(j) {
    header <- headers[j]
    period <- regmatches(header, regexpr("(?<=\\[报告期\\] )[^\\r\\n]+",
                                        header, perl = TRUE))
    currency <- regmatches(header, regexpr("(?<=\\[币种\\] )[^\\r\\n]+",
                                          header, perl = TRUE))
    if (length(period) != 1L || length(currency) != 1L)
      stop("STOP: Wind report period or currency unparseable: ", input_file)
    if (grepl("^[0-9]{4}(中报|年报)$", period)) {
      date <- as.IDate(paste0(substr(period, 1L, 4L),
                             if (grepl("中报$", period)) "-06-30" else "-12-31"))
    } else if (grepl("^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$", period)) {
      date <- as.IDate(period)
    } else {
      stop("STOP: unsupported Wind report period: ", period)
    }
    if (market == "HK") date <- nearest_halfyear(date)
    value <- suppressWarnings(as.numeric(x[[j]]))
    if (any(!is.na(x[[j]]) & nzchar(trimws(x[[j]])) & is.na(value)))
      stop("STOP: nonnumeric Wind total assets: ", input_file)
    data.table(firm_id = x[[1L]], name_wind = x[[2L]], date = date,
               ta_wind = value, currency_wind = currency,
               wind_file = input_file)
  }))[date %in% target_dates]
}
wa <- rbindlist(list(
  wind_assets(wind[["wind_A_delistet_v2.xlsx"]], "A", "wind_A_delistet_v2.xlsx"),
  wind_assets(wind[["wind_HK_delistet_v2.xlsx"]], "HK", "wind_HK_delistet_v2.xlsx")
))
if (anyDuplicated(wa[, .(firm_id, date)]))
  stop("STOP: Wind firm x date is not unique after date mapping.", call. = FALSE)
cat("Wind: 0 firm-date collisions after date mapping.\n")

ea <- raw[["raw_a_balance.csv"]][
  as.IDate(substr(REPORT_DATE, 1L, 10L)) %in% target_dates,
  .(firm_id = SECUCODE, name_em = SECURITY_NAME_ABBR,
    report_date_em = as.IDate(substr(REPORT_DATE, 1L, 10L)),
    date = as.IDate(substr(REPORT_DATE, 1L, 10L)),
    ta_em = TOTAL_ASSETS, eastmoney_file = "raw_a_balance.csv")]
eh <- rbindlist(lapply(c("raw_hk_balance.csv", "delisted_hk_balance.csv"), function(f) {
  x <- raw[[f]][as.integer(DATE_TYPE_CODE) %in% c(1L, 2L) &
                  code != "02768" & STD_ITEM_NAME == "总资产",
               .(firm_id = sprintf("%04d.HK", as.integer(code)),
                 name_em = SECURITY_NAME_ABBR,
                 report_date_em = as.IDate(substr(REPORT_DATE, 1L, 10L)),
                 ta_em = AMOUNT)]
  x[, date := nearest_halfyear(report_date_em)]
  x[, eastmoney_file := f]
  x[date %in% target_dates]
}))
em <- rbindlist(list(ea, eh), use.names = TRUE)
# Report cross-source differences; final Co-PI feedback retains only unreadable
# inputs and duplicate keys as stop conditions. EastMoney keeps row priority.
compared <- merge(em, wa, by = c("firm_id", "date"), allow.cartesian = TRUE)
compared <- compared[!is.na(ta_em) & !is.na(ta_wind)]
compared[, relative_difference := fifelse(
  ta_em == 0, fifelse(ta_wind == 0, 0, Inf), abs(ta_wind - ta_em) / abs(ta_em))]
conflicts <- compared[relative_difference > 0.01]
setorder(conflicts, firm_id, date, eastmoney_file)
cat("EastMoney/Wind total-assets comparisons:", nrow(compared), "\n")
cat("Total-assets differences >1%:", nrow(conflicts), "\n")
if (nrow(conflicts)) {
  print(conflicts, nrows = nrow(conflicts))
  cat("Distinct conflicting firm-dates:",
      uniqueN(conflicts, by = c("firm_id", "date")), "\n")
  cat("Conflicting firms:", paste(sort(unique(conflicts$firm_id)), collapse = ", "), "\n")
  cat("Asset discrepancies documented; proceeding under final Co-PI feedback.\n")
}

# The Co-PI feedback of 2026-10-16 supplies the income mapping independently
# of the balance-only T003 item catalogue. Check the approved exact names locally.
hk_income_map <- list(
  rev = "营业额",
  ni = "除税后溢利",
  ni_mi = "少数股东损益",
  jv_inc = c("应占联营公司溢利", "应占合营公司溢利")
)
income_names <- unique(c(raw[["raw_hk_income.csv"]]$STD_ITEM_NAME,
                         raw[["delisted_hk_income.csv"]]$STD_ITEM_NAME))
missing_income_names <- setdiff(unlist(hk_income_map), income_names)
if (length(missing_income_names))
  stop("STOP: approved HK income items absent: ",
       paste(missing_income_names, collapse = ", "), call. = FALSE)
cat("HK income mapping: all 5 approved item names exist (4 variables).\n")

# Only the seven authorised exports are used. Duplicate ownership columns in
# two HK exports must agree; retain the original string, including unknowns.
hk_id <- function(code) sprintf("%04d.HK", as.integer(code))
base_item <- function(h) trimws(sub("[\r\n].*", "", h))
owner_column <- function(x, item) {
  js <- which(base_item(names(x)) == item)
  if (!length(js)) return(rep(NA_character_, nrow(x)))
  z <- as.data.table(x[, js, drop = FALSE]); setnames(z, paste0("v", seq_along(js)))
  if (any(apply(z, 1L, function(v) uniqueN(v[!is.na(v)]) > 1L)))
    stop("Contradictory duplicate ownership columns: ", item)
  apply(z, 1L, function(v) {v <- v[!is.na(v)]; if (length(v)) v[1L] else NA_character_})
}
owners <- rbindlist(lapply(names(wind), function(f) {
  x <- wind[[f]]
  data.table(firm_id = x[[1L]], owner_type_raw = owner_column(x, "实际控制人属性"),
             owner_name = owner_column(x, "实际控制人名称"))
}))
owners <- owners[, lapply(.SD, function(v) {
  v <- unique(v[!is.na(v) & nzchar(v)])
  if (length(v) > 1L) stop("Contradictory ownership exports for one firm")
  if (length(v)) v else NA_character_
}), by = firm_id]
norm_sub <- function(x) fcase(x == "房地产开发", "开发",
  x %in% c("多样化房地产活动", "多元化房地产业务"), "多元化",
  x == "房地产经营公司", "经营", default = x)
wind_firms <- function(f, market, sub, listing) {
  x <- wind[[f]]
  data.table(firm_id = x[[1L]], name = x[[2L]], market = market,
             listing = listing, wind_sub = sub)
}
a_universe <- rbindlist(list(
  wind_firms("wind_A_gelistet_eigentum.xlsx", "A", "开发", "listed"),
  wind_firms("Sicherung_A_1.xlsx", "A", "经营/多元化", "listed")))
hk_boards <- rbindlist(list(
  wind_firms("sicherung_HK_3.xlsx", "HK", "开发", "listed"),
  wind_firms("sicherung_HK_1.xlsx", "HK", "多元化", "listed"),
  wind_firms("sicherung_HK_2.xlsx", "HK", "经营", "listed")))
if (anyDuplicated(hk_boards$firm_id)) stop("Overlapping Wind HK industry boards")
hk_universe <- raw[["firm_list.csv"]][market == "HK" & code != "02768",
  .(firm_id = hk_id(code), name, market, listing = "listed")]
hk_universe <- merge(hk_universe, hk_boards[, .(firm_id, wind_sub)],
                     by = "firm_id", all.x = TRUE)
# Keep the entire delisted list as a firm register, including the 7 unexported
# low-priority firms, with explicit exclusions; never fetch missing data.
du <- delisted[, .(firm_id = code, name, market, listing = "delisted",
                   wind_sub = norm_sub(sub))]
universe <- rbindlist(list(du, a_universe, hk_universe), use.names = TRUE)
# Delisted status and the delisted industry list take precedence for overlaps
# 2019/3333; all firms still appear exactly once.
universe <- unique(universe, by = "firm_id")
universe[, wind_sub_imputed := firm_id %in% c("3333.HK", "2019.HK", "2768!2.HK")]
universe[wind_sub_imputed == TRUE, wind_sub := "开发"]
available_delisted <- unique(c(wa$firm_id, eh$firm_id,
  hk_id(raw[["delisted_hk_balance.csv"]]$code),
  hk_id(raw[["delisted_hk_income.csv"]]$code)))
universe[, excl_reason := NA_character_]
universe[listing == "delisted" & !firm_id %in% available_delisted,
         excl_reason := "low_priority_not_exported"]
universe[wind_sub == "房地产服务", excl_reason := "property_services"]
universe[market == "A" & grepl("^(200|900)", firm_id), excl_reason := "B_share"]
universe[firm_id == "600173.SH", excl_reason := "non_developer_PI"]
universe[, sample_main := is.na(excl_reason) & !is.na(wind_sub) & wind_sub == "开发"]
universe[, sample_broad := is.na(excl_reason) & !is.na(wind_sub) &
           wind_sub %in% c("开发", "经营", "多元化", "经营/多元化")]
universe <- merge(universe, owners, by = "firm_id", all.x = TRUE)
universe[, soe := fcase(owner_type_raw %in% c("国资委", "地方国资委", "中央国有企业",
  "地方国有企业", "中央国家机关", "地方政府"), 1L, owner_type_raw == "个人", 0L,
  default = NA_integer_)]
universe[, fye_flag := firm_id %in% hk_id(fye$code)]

# Explicit maps, approved in final Co-PI feedback. No inferred name matching.
maps <- list(
  a_em = list(ta = "TOTAL_ASSETS", tl = "TOTAL_LIABILITIES",
    adv = c("ADVANCE_RECEIVABLES", "CONTRACT_LIAB"), cash = "MONETARYFUNDS",
    rcash = character(), std = c("SHORT_LOAN", "NONCURRENT_LIAB_1YEAR"),
    ltd = c("LONG_LOAN", "BOND_PAYABLE"), lease = "LEASE_LIAB", notes = "NOTE_PAYABLE",
    perp = c("PERPETUAL_BOND", "OTHER_EQUITY_TOOL"), perp_mi = character(),
    te = "TOTAL_EQUITY", mi = "MINORITY_EQUITY", jv = "LONG_EQUITY_INVEST",
    inv = "INVENTORY", rev = "TOTAL_OPERATE_INCOME", ni = "NETPROFIT",
    ni_mi = "MINORITY_INTEREST", jv_inc = "INVEST_JOINT_INCOME"),
  hk_em = c(list(ta = "总资产", tl = "总负债", adv = c("预收款项", "合同负债"),
    cash = "现金及等价物", rcash = "受限制存款及现金",
    std = c("短期贷款", "应付票据"),
    ltd = c("长期贷款", "应付票据(非流动)", "应付债券", "可转换票据及债券", "可转换债券及票据"),
    lease = c("融资租赁负债(流动)", "融资租赁负债(非流动)"), notes = character(),
    perp = "永久资本证券", perp_mi = character(), te = "总权益", mi = "少数股东权益",
    jv = c("联营公司权益", "合营公司权益"), inv = c("存货", "发展中及待售物业")), hk_income_map),
  a_wind = list(ta = "资产总计", tl = "负债合计", adv = c("预收账款", "合同负债"),
    cash = "货币资金", rcash = character(), std = c("短期借款", "一年内到期的非流动负债"),
    ltd = c("长期借款", "应付债券"), lease = character(), notes = character(),
    perp = c("其他权益工具:永续债", "其他权益工具"), perp_mi = character(),
    te = "股东权益合计", mi = "少数股东权益", jv = "长期股权投资", inv = "存货",
    rev = "营业总收入", ni = "净利润", ni_mi = "少数股东损益",
    jv_inc = "对联营企业和合营企业的投资收益"),
  hk_wind = list(ta = "资产总计", tl = "负债合计", adv = c("预收款项", "合同负债"),
    cash = "现金及现金等价物", rcash = "受限资金", std = "短期借贷及长期借贷当期到期部分",
    ltd = "长期借贷", lease = character(), notes = character(), perp = "永续债_合计",
    perp_mi = "永续债_归属于少数股东", te = "股东权益合计", mi = "少数股东权益",
    jv = c("对联营公司投资", "对共同发展公司投资"), inv = "存货", rev = "营业总收入",
    ni = "除税后利润(净利润)", ni_mi = "少数股东损益", jv_inc = "权益性投资损益"))
items <- names(maps$a_em)
balance_names <- unlist(maps$hk_em[setdiff(items, names(hk_income_map))])
cat("Approved HK balance names absent from T003:",
    paste(setdiff(balance_names, hk_items$STD_ITEM_NAME), collapse = ";"), "\n")
for (mn in c("a_wind", "hk_wind")) {
  wf <- if (mn == "a_wind") "wind_A_delistet_v2.xlsx" else "wind_HK_delistet_v2.xlsx"
  cat("Mapped Wind names absent from", wf, ":",
      paste(setdiff(unlist(maps[[mn]]), base_item(names(wind[[wf]]))), collapse = ";"), "\n")
}

unique_key <- function(x, keys, label) {
  if (anyDuplicated(x[, ..keys])) stop("STOP: duplicate ", label, " keys")
  invisible(x)
}
# Harmonise all mapped items. Missing summands count as zero only when at least
# one component is observed; perpetuals for A use fallback rather than summing.
harmonise <- function(x, map_name) {
  map <- maps[[map_name]]
  for (v in items) {
    components <- map[[v]]
    missing_columns <- setdiff(components, names(x))
    for (j in missing_columns) set(x, j = j, value = NA_real_)
    if (!length(components)) {
      x[, (v) := NA_real_]; x[, (paste0(v, "_n_components_present")) := 0L]
    } else {
      z <- as.matrix(x[, ..components]); n <- rowSums(!is.na(z))
      value <- rowSums(z, na.rm = TRUE); value[n == 0L] <- NA_real_
      if (v == "perp" && map_name %in% c("a_em", "a_wind")) {
        value <- fcoalesce(z[, 1L], z[, 2L]); n <- as.integer(!is.na(value))
      }
      set(x, j = v, value = value)
      set(x, j = paste0(v, "_n_components_present"), value = as.integer(n))
    }
  }
  x[, c("firm_id", "date", "report_date", "currency", items,
         paste0(items, "_n_components_present")), with = FALSE]
}
a_balance <- copy(raw[["raw_a_balance.csv"]])
a_balance[, `:=`(firm_id = SECUCODE, date = as.IDate(substr(REPORT_DATE, 1L, 10L)))]
a_balance <- a_balance[date %in% target_dates]
a_balance[, `:=`(report_date = date, currency = "RMB")]
a_income <- copy(raw[["raw_a_income.csv"]])
a_income[, `:=`(firm_id = SECUCODE, date = as.IDate(substr(REPORT_DATE, 1L, 10L)))]
a_income <- a_income[date %in% target_dates, c("firm_id", "date", unlist(maps$a_em[names(hk_income_map)])), with = FALSE]
unique_key(a_balance, c("firm_id", "date"), "A balance")
unique_key(a_income, c("firm_id", "date"), "A income")
a_em <- harmonise(merge(a_balance, a_income, by = c("firm_id", "date"), all.x = TRUE), "a_em")

hk_wide <- function(files) {
  x <- rbindlist(lapply(files, function(f) {
    z <- copy(raw[[f]][as.integer(DATE_TYPE_CODE) %in% c(1L, 2L) & code != "02768"])
    z[, `:=`(firm_id = hk_id(code), date = nearest_halfyear(REPORT_DATE),
              report_date = as.IDate(substr(REPORT_DATE, 1L, 10L)))]
    z[date %in% target_dates, .(firm_id, date, report_date, STD_ITEM_NAME, AMOUNT)]
  }))
  x <- unique(x)
  unique_key(x, c("firm_id", "date", "STD_ITEM_NAME"), "HK item")
  w <- dcast(x, firm_id + date + report_date ~ STD_ITEM_NAME, value.var = "AMOUNT")
  unique_key(w, c("firm_id", "date"), "HK report")
}
hb <- hk_wide(c("raw_hk_balance.csv", "delisted_hk_balance.csv"))
hi <- hk_wide(c("raw_hk_income.csv", "delisted_hk_income.csv"))
cat("HK balance mapped row keys:", nrow(hb), "; total-assets present:", sum(!is.na(hb$总资产)), "\n")
cat("HK balance keys without total assets:\n"); print(hb[is.na(总资产), .(firm_id, date)])
hi <- hi[, c("firm_id", "date", unlist(hk_income_map)), with = FALSE]
hk_em <- merge(hb, hi, by = c("firm_id", "date"), all.x = TRUE)
hk_em[, currency := "reported"]
hk_em <- harmonise(hk_em, "hk_em")

wind_wide <- function(f, market) {
  x <- wind[[f]]; headers <- names(x)
  js <- which(grepl("[报告期]", headers, fixed = TRUE))
  z <- rbindlist(lapply(js, function(j) {
    period <- regmatches(headers[j], regexpr("(?<=\\[报告期\\] )[^\\r\\n]+", headers[j], perl = TRUE))
    curr <- regmatches(headers[j], regexpr("(?<=\\[币种\\] )[^\\r\\n]+", headers[j], perl = TRUE))
    if (grepl("^[0-9]{4}(中报|年报)$", period)) {
      date <- as.IDate(paste0(substr(period, 1L, 4L), if (grepl("中报$", period)) "-06-30" else "-12-31"))
    } else date <- as.IDate(period)
    if (is.na(date) || length(curr) != 1L) stop("Unparseable Wind period/currency")
    value <- suppressWarnings(as.numeric(x[[j]]))
    if (any(!is.na(x[[j]]) & nzchar(trimws(x[[j]])) & is.na(value))) stop("Nonnumeric Wind item")
    data.table(firm_id = x[[1L]], report_date = date,
      date = if (market == "HK") nearest_halfyear(date) else date,
      # Card fixes A reporting currency to RMB. Its export headers mix
      # 人民币 and 原始币种 across items; these are not separate reports.
      currency = if (market == "A") "RMB" else if (curr == "原始币种") "reported" else curr,
      item = base_item(headers[j]), value = value)
  }))[date %in% target_dates]
  unique_key(z, c("firm_id", "date", "item"), "Wind item")
  z <- dcast(z, firm_id + date + report_date + currency ~ item, value.var = "value")
  unique_key(z, c("firm_id", "date"), "Wind report")
  # Entirely blank export periods are not financial observations.
  financial <- setdiff(names(z), c("firm_id", "date", "report_date", "currency"))
  z[rowSums(!is.na(as.matrix(z[, ..financial]))) > 0L]
}
w_a <- harmonise(wind_wide("wind_A_delistet_v2.xlsx", "A"), "a_wind")
w_hk <- harmonise(wind_wide("wind_HK_delistet_v2.xlsx", "HK"), "hk_wind")
em_panel <- rbindlist(list(a_em, hk_em)); em_panel[, source := "eastmoney"]
wind_panel <- rbindlist(list(w_a, w_hk)); wind_panel[, source := "wind"]
fin <- rbindlist(list(em_panel, wind_panel))
fin <- unique(fin, by = c("firm_id", "date")) # entire-row EastMoney priority
fin <- fin[firm_id %in% universe$firm_id]
unique_key(fin, c("firm_id", "date"), "source-selected financial")
universe[, has_financials := firm_id %in% fin$firm_id]
# Build the full register temporarily for universe counts and baseline joins.
# Only observed financial rows are published, per final Co-PI feedback.
panel <- merge(universe[, .(date = target_dates), by = firm_id], universe, by = "firm_id")
panel <- merge(panel, fin, by = c("firm_id", "date"), all.x = TRUE)
panel[, has_row := !is.na(source)]
panel[is.na(currency), currency := fifelse(market == "A", "RMB", "reported")]
for (v in items) panel[is.na(get(paste0(v, "_n_components_present"))),
                       (paste0(v, "_n_components_present")) := 0L]
setorder(panel, firm_id, date)
# PI decision 2026-10-16: missing advances are zero, with an explicit flag.
# Component counts retain the original missingness.
panel[, adv_missing := is.na(adv)]
panel[adv_missing == TRUE, adv := 0]
# Co-PI correction after run 6: an observed balance sheet with no perpetual
# items is treated as having no perpetuals. Keep other missing items unchanged.
panel[, perp_missing := !is.na(ta) & is.na(perp) & is.na(perp_mi)]
panel[perp_missing == TRUE, `:=`(perp = 0, perp_mi = 0)]
cat("Perpetual imputation by market/source (financial rows only):\n")
print(panel[has_row == TRUE, .(n_imputed = sum(perp_missing), n_total = .N,
  share_imputed = mean(perp_missing)), by = .(market, source)])
cat("Advance imputation by market/source (financial rows only):\n")
print(panel[has_row == TRUE, .(n_missing = sum(adv_missing), n_total = .N,
  share_missing = mean(adv_missing)), by = .(market, source)])
core <- c("ta", "tl", "te", "cash", "std")
missing_core <- melt(panel[sample_main == TRUE & has_row == TRUE], id.vars = c("source", "market"),
                     measure.vars = core, variable.name = "item")[,
  .(n_missing = sum(is.na(value)), n_total = .N, share_missing = mean(is.na(value))), by = .(market, source, item)]
cat("Red-line item missingness (main sample, financial rows only; reporting, no coverage gate):\n")
print(missing_core, nrows = nrow(missing_core))
cat("HK EastMoney missing cash (main-sample flag shown):\n")
print(panel[market == "HK" & source == "eastmoney" & is.na(cash),
  .(firm_id, date, sample_main, sample_broad)], nrows = nrow(panel))
cat("T003 cash-related item names (diagnostic only; no substitution):\n")
print(hk_items[grepl("现金|存款|货币", STD_ITEM_NAME)], nrows = nrow(hk_items))
cash_candidates <- intersect(c("现金及等价物(非流动)", "中长期存款", "短期存款", "受限制存款及现金"), names(hb))
cash_diagnostic <- merge(panel[market == "HK" & source == "eastmoney" &
  sample_main == TRUE & is.na(cash), .(firm_id, date)],
  hb[, c("firm_id", "date", cash_candidates), with = FALSE], by = c("firm_id", "date"))
cat("Other cash/deposit items present on main-sample missing-cash rows (no substitution):\n")
print(cash_diagnostic[, lapply(.SD, function(v) sum(!is.na(v))), .SDcols = cash_candidates])

safe_ratio <- function(n, d) fifelse(!is.na(d) & d > 0, n / d, NA_real_)
sum_parts <- function(...) {z <- cbind(...); n <- rowSums(!is.na(z)); v <- rowSums(z, na.rm = TRUE); v[n == 0] <- NA_real_; v}
panel[, `:=`(ibd = sum_parts(std, ltd), ibd_n_components_present = as.integer(!is.na(std)) + as.integer(!is.na(ltd)))]
panel[, `:=`(ibd_ext = sum_parts(ibd, lease, notes),
  ibd_ext_n_components_present = as.integer(!is.na(ibd)) + as.integer(!is.na(lease)) + as.integer(!is.na(notes)))]
panel[, `:=`(rl1 = safe_ratio(tl - adv, ta - adv), rl1_alt = safe_ratio(tl - adv, ta),
  rl2 = safe_ratio(ibd - cash, te), rl2_adj = safe_ratio(ibd + perp - cash, te - perp),
  rl3 = safe_ratio(cash - fcoalesce(rcash, 0), std), rl3_upper_bound = is.na(rcash))]
panel[, `:=`(b1 = as.integer(rl1 > .70), b2 = as.integer(rl2 > 1), b3 = as.integer(rl3 < 1))]
panel[, n_breached := b1 + b2 + b3]
dose <- panel[date == as.IDate("2019-12-31"), .(firm_id, dose = n_breached)]
dose_h1 <- panel[date == as.IDate("2020-06-30"), .(firm_id, dose_2020h1 = n_breached)]
panel <- merge(merge(panel, dose, by = "firm_id"), dose_h1, by = "firm_id")
panel[, `:=`(post = as.integer(date >= as.IDate("2020-12-31")), mi_share = safe_ratio(mi, te),
  mi_gap = safe_ratio(mi, te) - safe_ratio(ni_mi, ni), jv_ta = safe_ratio(jv, ta),
  perp_te = safe_ratio(perp, te), rl2_gap = rl2_adj - rl2, inv_ta = safe_ratio(inv, ta),
  log_ta = fifelse(ta > 0, log(ta), NA_real_))]
setorder(panel, firm_id, date)
register <- panel
panel <- panel[has_row == TRUE]

# END VERBATIM CLEANING

# Stop on new HK labels, without expanding the approved item mapping.
item_audit <- rbindlist(lapply(hk_files, function(f) {
  x <- copy(raw[[f]][as.integer(DATE_TYPE_CODE) %in% c(1L, 2L) & code != "02768"])
  x[, date := nearest_halfyear(REPORT_DATE)]
  old <- unique(x[date %in% target_dates & date <= cutoff, STD_ITEM_NAME])
  z <- x[date %in% new_dates, .(n_rows = .N), by = STD_ITEM_NAME]
  z[, `:=`(input_file = f, present_in_main_window = STD_ITEM_NAME %in% old,
           mapped = STD_ITEM_NAME %in% unlist(maps$hk_em))]
  z
}))
unmapped <- item_audit[present_in_main_window == FALSE]
if (nrow(unmapped)) {
  print(unmapped, nrows = nrow(unmapped))
  stop("STOP T030: new EastMoney 2023-2024 item names; no ad-hoc mapping.")
}
setorder(item_audit, input_file, STD_ITEM_NAME)
cat("T030 item gate: no new HK balance/income labels in 2023-2024.\n")

# Freeze register, membership, exposure and ownership to the delivered panel.
frozen <- unique(main, by = "firm_id")
static_columns <- c("name", "market", "listing", "wind_sub", "wind_sub_imputed",
  "excl_reason", "sample_main", "sample_broad", "owner_type_raw", "owner_name",
  "soe", "fye_flag", "has_financials", "dose", "dose_2020h1", "dose2018",
  "dose_pre", "distance", "owner_class_final", "soe_final", "soe_source")
for (v in static_columns)
  stopifnot(all(main[, uniqueN(get(v)), by = firm_id]$V1 == 1L))
inherited <- c("dose2018", "dose_pre", "distance", "owner_class_final", "soe_final", "soe_source")
panel <- panel[firm_id %in% frozen$firm_id]
for (v in inherited) panel[, (v) := frozen[[v]][match(firm_id, frozen$firm_id)]]
setcolorder(panel, names(main))

# Compare independently re-cleaned overlap at downstream CSV precision.
serialise <- function(x) {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path))
  fwrite(x, path, na = "NA", logical01 = FALSE, eol = mtpa_eol())
  fread(path, na.strings = "NA", colClasses = c(firm_id = "character"))
}
assert_overlap <- function(candidate) {
  actual <- serialise(candidate[date <= cutoff, names(main), with = FALSE])
  expected <- serialise(main)
  setorder(actual, firm_id, date); setorder(expected, firm_id, date)
  if (!identical(actual[, .(firm_id, date)], expected[, .(firm_id, date)]))
    stop("STOP T030: overlap assert fails; differing firm_id/date keys.")
  checks <- rbindlist(lapply(names(main), function(v) {
    a <- actual[[v]]; b <- expected[[v]]
    missing_equal <- identical(is.na(a), is.na(b))
    observed <- !is.na(a) & !is.na(b)
    numeric <- is.numeric(a) && is.numeric(b) && !inherits(a, "Date")
    difference <- if (numeric && any(observed)) max(abs(a[observed] - b[observed])) else 0
    equal <- missing_equal && if (numeric) isTRUE(difference <= 1e-12) else
      identical(a[observed], b[observed])
    data.table(column = v, n_rows = nrow(actual), numeric_comparison = numeric,
               missingness_equal = missing_equal, max_absolute_difference = difference, equal = equal)
  }))
  if (any(!checks$equal)) {
    print(checks[equal == FALSE])
    stop("STOP T030: overlap assert fails; differing columns: ",
         paste(checks[equal == FALSE, column], collapse = ", "))
  }
  checks
}
overlap_checks <- assert_overlap(panel)
cat("T030 ASSERT: overlap passes, 2279 rows x 89 columns; numeric tolerance 1e-12.\n")

# Complete the frozen register ONLY for the four new dates. Impute on actual
# financial rows exactly as in 01; absent rows have no financial imputations.
extension <- register[date %in% new_dates & firm_id %in% frozen$firm_id]
for (v in static_columns) extension[, (v) := frozen[[v]][match(firm_id, frozen$firm_id)]]
setcolorder(extension, names(main))
financial_columns <- setdiff(names(main), c("firm_id", "date", static_columns,
  "currency", "source", "has_row", "post"))
for (v in financial_columns) {
  if (grepl("_n_components_present$", v)) extension[has_row == FALSE, (v) := 0L]
  else extension[has_row == FALSE, (v) := NA]
}
extension[has_row == FALSE, `:=`(source = NA_character_, report_date = as.IDate(NA))]
source_history <- main[, .(wind_only = all(source == "wind")), by = firm_id]
wind_ids <- source_history[wind_only == TRUE, firm_id]
stopifnot(!any(extension[firm_id %in% wind_ids]$has_row),
          nrow(extension) == 4L * nrow(frozen),
          all(is.na(as.matrix(extension[has_row == FALSE, ..items]))),
          all(is.na(extension[has_row == FALSE]$rl1)),
          all(is.na(extension[has_row == FALSE]$ibd)))
ext <- rbindlist(list(panel[date <= cutoff], extension), use.names = TRUE)
ext[, post2 := as.integer(date >= as.IDate("2023-06-30"))]
setorder(ext, firm_id, date)
stopifnot(!anyDuplicated(ext[, .(firm_id, date)]), uniqueN(ext$date) == 17L,
          identical(sort(unique(ext$firm_id)), sort(frozen$firm_id)),
          all(ext$post == as.integer(ext$date >= as.IDate("2020-12-31"))))
for (v in static_columns)
  stopifnot(all(ext[, uniqueN(get(v)), by = firm_id]$V1 == 1L))
overlap_checks <- assert_overlap(ext)

# Source on missing coverage rows denotes historical availability, not an
# imputed financial row. Published source stays NA when has_row=FALSE.
z <- copy(ext[sample_main == TRUE])
z[, source_group := fifelse(has_row, source,
                            fifelse(firm_id %in% wind_ids, "wind", "eastmoney"))]
coverage <- z[, .(n_balance_sheet = sum(has_row),
  n_ta = sum(has_row & !is.na(ta)), n_rl1 = sum(has_row & !is.na(rl1)),
  n_rl2 = sum(has_row & !is.na(rl2)), n_mi = sum(has_row & !is.na(mi)),
  n_ibd = sum(has_row & !is.na(ibd)),
  n_wind_only_no_export = sum(!has_row & firm_id %in% wind_ids)),
  by = .(date, market, source = source_group)]
# Historical absent rows stay absent in ext but enter coverage denominators.
coverage_grid <- frozen[sample_main == TRUE, .(date = target_dates), by = .(firm_id, market)]
coverage_grid[, source_group := fifelse(firm_id %in% wind_ids, "wind", "eastmoney")]
denominators <- coverage_grid[, .(n_sample_main = .N), by = .(date, market, source = source_group)]
coverage <- merge(denominators, coverage, by = c("date", "market", "source"), all.x = TRUE)
for (v in setdiff(names(coverage), c("date", "market", "source", "n_sample_main")))
  coverage[is.na(get(v)), (v) := 0L]
coverage[, n_missing_rows := n_sample_main - n_balance_sheet]
setorder(coverage, date, market, source)
by_date <- coverage[, .(n_sample_main = sum(n_sample_main), n_balance_sheet = sum(n_balance_sheet),
                       n_rl1 = sum(n_rl1)), by = date]
stopifnot(all(by_date$n_sample_main == 136L))

baseline_ids <- main[date == cutoff & sample_main == TRUE & has_row == TRUE, firm_id]
a <- copy(z[date %in% new_dates & firm_id %in% baseline_ids])
a[, dose_pre_rounded := floor(dose_pre + 0.5)] # T005/T012 convention (ties upward).
attrition <- a[, .(n_present_2022h2 = .N, n_present = sum(has_row), n_missing = sum(!has_row),
  n_wind_only_no_export = sum(!has_row & firm_id %in% wind_ids),
  n_eastmoney_missing = sum(!has_row & !firm_id %in% wind_ids)), by = .(date, dose_pre_rounded)]
setorder(attrition, date, dose_pre_rounded)
missing_firms <- a[has_row == FALSE, .(date, firm_id, name, market, dose_pre, dose_pre_rounded,
  reason = fifelse(firm_id %in% wind_ids, "wind_only_no_export_after_2022h2", "eastmoney_no_report"))]
setorder(missing_firms, date, firm_id)
wind_audit <- frozen[firm_id %in% wind_ids, .(firm_id, name, market, listing, wind_sub,
  sample_main, sample_broad, dose_pre, present_2022h2 = firm_id %in% main[date == cutoff, firm_id])]
wind_audit[, `:=`(n_missing_extension_dates = 4L, reason = "wind_only_no_export_after_2022h2")]
setorder(wind_audit, firm_id)

# Counts only. Require adjacent TARGET dates with two observed RL1 values;
# never bridge gaps or apply the decomposition log-domain restrictions of T027.
z[, half_index := match(date, target_dates)]
setorder(z, firm_id, date)
z[, `:=`(previous_rl1 = shift(rl1), previous_index = shift(half_index)), by = firm_id]
z[, eligible := !is.na(previous_rl1) & !is.na(rl1) & previous_index == half_index - 1L]
z[, downward := eligible & previous_rl1 >= 0.70 & rl1 < 0.70]
crossings <- z[date > min(target_dates), .(n_adjacent_rl1_pairs = sum(eligible),
  n_at_risk = sum(eligible & previous_rl1 >= 0.70), n_downward_crossings = sum(downward)), by = date]
crossings[, window := fcase(date >= as.IDate("2023-06-30"), "extension_2023_2024",
  date >= as.IDate("2020-12-31"), "main_2020h2_2022h2", default = "pre_through_2020h1")]
setorder(crossings, date)
stopifnot(nrow(crossings) == 16L, !anyNA(crossings))

addendum <- data.table(column = c("date", "has_row", "source", "post", "post2", "dose / dose_pre / soe_final",
  "missing-row financial fields", "sample_main / sample_broad"), definition = c(
  "17 target dates 2016H2-2024H2; original observed-row support through 2022H2, full frozen firm register for four extension dates",
  "TRUE only for actual financial source rows; FALSE for missing extension rows, including Wind-only firms without post-2022 exports",
  "Actual source eastmoney/wind; NA on absent extension rows. Coverage-table source falls back to historical source class for absent rows",
  "Unchanged mechanical date indicator >=2020-12-31; NOT evidence original policy rules remained in force in 2023-2024",
  "1 for date >=2023-06-30; separate 2023-2024 window, not labelled post-policy pending PI verification of relaxation",
  "Copied from main panel by permanent firm_id; no reclassification or post-2022 treatment information",
  "NA when has_row=FALSE, including advances/perpetuals and imputation flags; component-present counts 0. Existing imputation rules apply only to actual rows",
  "Frozen main-panel membership: 136 main / 172 broad among 184 firms; no new firms"))

stopifnot(identical(protected_hash, tools::sha256sum(protected)))
out <- list("data/processed/panel_firm_halfyear_ext.csv" = ext,
  "outputs/tables/t030_coverage.csv" = coverage,
  "outputs/tables/t030_attrition_2023_2024.csv" = attrition,
  "outputs/tables/t030_crossings_preview.csv" = crossings,
  "outputs/tables/t030_dictionary_addendum.csv" = addendum,
  "outputs/tables/t030_rl1_by_date.csv" = by_date,
  "outputs/tables/t030_wind_only_firms.csv" = wind_audit,
  "outputs/tables/t030_missing_firms.csv" = missing_firms,
  "outputs/tables/t030_item_mapping_audit.csv" = item_audit,
  "outputs/tables/t030_overlap_assert.csv" = overlap_checks)
for (path in names(out)) {
  dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
  fwrite(out[[path]], path, na = "NA", logical01 = FALSE, eol = mtpa_eol())
}
published <- fread(names(out)[1L], na.strings = "NA")
published[, `:=`(date = as.IDate(date), report_date = as.IDate(report_date))]
invisible(assert_overlap(published))
stopifnot(identical(protected_hash, tools::sha256sum(protected)))
cat("T030 sample_main coverage by date:\n"); print(by_date, nrows = 17L)
cat("T030 Wind-only firms (data availability, not inferred reporting attrition):\n")
print(wind_audit, nrows = nrow(wind_audit))
cat("T030 Wind-only counts by market and main-sample membership:\n")
print(wind_audit[, .(n_firms = .N, n_missing_firm_dates = 4L * .N), by = .(market, sample_main)])
cat(sprintf("T030 completed: %d rows; %d firms; %d dates; %d columns. No estimates.\n",
            nrow(ext), uniqueN(ext$firm_id), uniqueN(ext$date), ncol(ext)))
cat("T030 PASS: overlap, fixed universe, Wind-only no-imputation and protected SHA-256 assertions.\n")
