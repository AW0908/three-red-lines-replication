# T004: reproducible firm-half-year panel.
# Run: cd replication && Rscript code/01_clean.R
# Apply the approved HK date, item, advance and observed-row coverage rules.
# Diagnostics go to stdout; no partial panel is published on a failed gate.

suppressPackageStartupMessages({
  library(data.table)
  library(readxl)
})
source("code/00_setup.R", local = TRUE)
set.seed(20261016)
options(width = 160)

# T003/T004 were delivered before T012; runtime uses only replication/ and
# read-only raw inputs in data/raw/. Approved dates are embedded below (T004).

target_dates <- as.IDate(c(
  "2016-12-31",
  as.vector(rbind(paste0(2017:2022, "-06-30"),
                  paste0(2017:2022, "-12-31")))
))

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

# T012: construct treatments once, on the same published source rows as T011.
# Ratios are averaged separately before distance is computed (>=3 dates each).
# Match the CSV precision consumed by T011, without changing existing columns.
treatment_input <- tempfile(fileext = ".csv")
fwrite(panel, treatment_input, na = "NA", logical01 = FALSE, eol = mtpa_eol())
treatment_panel <- read.csv(treatment_input, na.strings = "NA",
                            colClasses = c(firm_id = "character", date = "character"))
unlink(treatment_input)
treatments <- do.call(rbind, lapply(split(treatment_panel, treatment_panel$firm_id), function(d) {
  pre <- d[d$date >= "2017-06-30" & d$date <= "2019-12-31", ]
  mean3 <- function(x) if (sum(!is.na(x)) >= 3L) mean(x, na.rm = TRUE) else NA_real_
  value2018 <- d$n_breached[d$date == "2018-12-31"]
  means <- vapply(pre[c("rl1", "rl2", "rl3")], mean3, numeric(1))
  distance <- if (anyNA(means)) NA_real_ else
    max(means["rl1"] - 0.70, 0) / 0.10 +
    max(means["rl2"] - 1.00, 0) / 0.50 +
    max(1.00 - means["rl3"], 0) / 0.50
  data.frame(firm_id = d$firm_id[1],
             dose2018 = if (length(value2018)) value2018 else NA_real_,
             dose_pre = mean3(pre$n_breached), distance = unname(distance))
}))
new_treatments <- c("dose2018", "dose_pre", "distance")
for (v in new_treatments)
  panel[, (v) := treatments[[v]][match(firm_id, treatments$firm_id)]]
stopifnot(nrow(panel) == 2279L,
          all(is.na(panel$dose_pre) | (panel$dose_pre >= 0 & panel$dose_pre <= 3)),
          all(is.na(panel$distance) | panel$distance >= 0),
          all(is.na(panel$dose2018) | panel$dose2018 %in% 0:3))
for (v in new_treatments) stopifnot(all(panel[, uniqueN(get(v)), by = firm_id]$V1 == 1L))

# Long-format counts make each denominator and sample explicit.
count_rows <- function(x, stage, sample = "all", source_value = "all") {
  z <- x[, .(n_firms = uniqueN(firm_id), n_firm_dates = .N), by = .(market, listing)]
  z <- merge(unique(universe[, .(market, listing)]), z, by = c("market", "listing"), all.x = TRUE)
  z[is.na(n_firms), `:=`(n_firms = 0L, n_firm_dates = 0L)]
  z[, `:=`(stage = stage, sample = sample, source = source_value, value = as.numeric(n_firm_dates))]
  setcolorder(z, c("market", "listing", "stage", "sample", "source", "n_firms", "n_firm_dates", "value"))
  z
}
counts <- rbindlist(list(count_rows(register, "01_universe"),
  count_rows(register[has_row == FALSE], "01_dropped_register_periods"),
  count_rows(register[has_financials == FALSE], "01_firms_without_financials"),
  count_rows(panel, "02_has_data"),
  count_rows(panel[is.na(excl_reason)], "03_minus_exclusions"),
  count_rows(panel[sample_broad == TRUE], "04_sample_broad_has_data", "sample_broad"),
  count_rows(panel[sample_main == TRUE], "05_sample_main_has_data", "sample_main")))
for (sn in c("sample_broad", "sample_main")) counts <- rbind(counts,
  count_rows(register[get(sn) == TRUE], "01_universe_sample", sn))
for (s in c("eastmoney", "wind")) counts <- rbind(counts,
  count_rows(panel[source == s], "06_source", source_value = s))
for (s in c("eastmoney", "wind")) counts <- rbind(counts,
  count_rows(panel[source == s & adv_missing == TRUE], "06_adv_missing", source_value = s))
for (sample_name in c("all", "sample_broad", "sample_main")) {
  z <- if (sample_name == "all") panel else panel[get(sample_name) == TRUE]
  for (v in c("rl1", "rl1_alt", "rl2", "rl2_adj", "rl3")) {
    d <- switch(v, rl1 = z$ta - z$adv, rl1_alt = z$ta, rl2 = z$te,
                rl2_adj = z$te - z$perp, rl3 = z$std)
    counts <- rbind(counts, count_rows(z[is.na(get(v))], paste0("07_na_", v), sample_name),
      count_rows(z[which(!is.na(d) & d <= 0)], paste0("08_nonpositive_denom_", v), sample_name))
  }
}
counts <- rbind(counts, data.table(market = "HK", listing = "all", stage = "09_hk_balance_keys",
  sample = "all", source = "eastmoney", n_firms = uniqueN(hb$firm_id), n_firm_dates = nrow(hb), value = nrow(hb)),
  data.table(market = "HK", listing = "all", stage = "09_hk_assets_present",
  sample = "all", source = "eastmoney", n_firms = uniqueN(hb[!is.na(总资产)]$firm_id),
  n_firm_dates = sum(!is.na(hb$总资产)), value = sum(!is.na(hb$总资产))),
  data.table(market = "HK", listing = "all", stage = "09_hk_balance_vs_card_804",
    sample = "all", source = "eastmoney", n_firms = uniqueN(hb$firm_id),
    n_firm_dates = nrow(hb), value = nrow(hb) - 804))
for (sn in c("all", "sample_broad", "sample_main")) counts <- rbind(counts,
  count_rows(if (sn == "all") panel else panel[get(sn) == TRUE], "10_final_panel", sn))
setorder(counts, stage, sample, market, listing, source)
coverage <- rbindlist(lapply(c("sample_broad", "sample_main"), function(sn) {
  z <- panel[get(sn) == TRUE]
  z[, adv_reported := fifelse(adv_missing, NA_real_, adv)]
  ans <- melt(z, id.vars = c("market", "source"), measure.vars = c(items, "adv_reported"), variable.name = "item")[,
    .(n_present = sum(!is.na(value)), n_total = .N, share = mean(!is.na(value))), by = .(item, market, source)]
  ans[, sample := sn]
  ans
}))
setorder(coverage, sample, item, market, source)
unresolved <- universe[sample_broad == TRUE & is.na(soe), .(firm_id, name, owner_type_raw, owner_name)]
setorder(unresolved, firm_id)

# Dictionary includes every derived column and the exact four source maps.
definitions <- c(firm_id = "Wind-style permanent security identifier; reused HK codes retain ! suffix",
  date = "Mapped target half-year end (13 dates, 2016H2-2022H2)", name = "Firm name as exported",
  market = "A or HK", listing = "listed/delisted; delisted list takes precedence",
  wind_sub = "Wind industry; combined A board retained as 经营/多元化",
  wind_sub_imputed = "PI-imputed developer classification for 3333, 2019, real Jiayuan",
  excl_reason = "Exclusion reason; blank means no explicit exclusion",
  sample_main = "Developer industry and no explicit exclusion; firm register counts also retain firms without data",
  sample_broad = "Developer/operating/diversified industry and no exclusion; register counts also retain firms without data",
  owner_type_raw = "Wind actual-controller type at 2020-06-30, unmodified",
  owner_name = "Wind actual-controller name at 2020-06-30 if exported",
  soe = "1: approved state categories; 0: individual; otherwise missing",
  fye_flag = "Firm appears in T003 fiscal-year table; mapping is recalculated from REPORT_DATE",
  has_financials = "Firm has at least one target-period financial row",
  report_date = "Original balance-sheet reporting date; Wind header financial period",
  currency = "RMB for A; reported for HK (original currency not yet resolved)",
  source = "Whole-row priority eastmoney then wind",
  has_row = "An actual financial source row exists; always TRUE in published panel",
  ta = "Total assets", tl = "Total liabilities", adv = "Advance receipts plus contract liabilities; all components missing -> 0 (PI decision 2026-10-16)",
  adv_missing = "Advance receipts and contract liabilities both missing before PI-authorised zero imputation",
  cash = "Cash as reported", rcash = "Restricted cash; unavailable for A",
  std = "Short-term interest-bearing debt", ltd = "Long-term interest-bearing debt",
  lease = "Lease liabilities, robustness", notes = "A bills payable, robustness; absent for HK",
  perp = "Equity perpetuals; A perpetual-specific item with row-level other-equity fallback; ta present and all perpetual items missing -> 0",
  perp_mi = "Perpetuals attributable to minorities (HK Wind only); ta present and all perpetual items missing -> 0",
  perp_missing = "ta present and both perp/perp_mi missing before authorised zero imputation; component counts retain raw missingness",
  te = "Total equity including minorities",
  mi = "Minority equity", jv = "Associate and JV investments", inv = "Inventory and separate HK development/sale properties",
  rev = "Revenue, YTD", ni = "Net income, YTD", ni_mi = "Minority income, YTD",
  jv_inc = "Income from associates/JVs, YTD",
  ibd = "std + ltd; all missing -> NA, otherwise missing components zero",
  ibd_ext = "ibd + lease + notes; same partial-sum rule",
  rl1 = "[unverified] (tl-adv)/(ta-adv)", rl1_alt = "[unverified] (tl-adv)/ta",
  rl2 = "(ibd-cash)/te; perpetuals remain equity", rl2_adj = "(ibd+perp-cash)/(te-perp)",
  rl3 = "(cash-rcash)/std; missing rcash replaced by 0", rl3_upper_bound = "Restricted cash missing, so rl3 uses all cash",
  b1 = "1 if rl1 > 0.70", b2 = "1 if rl2 > 1.00", b3 = "1 if rl3 < 1.00",
  n_breached = "b1+b2+b3; NA if any ratio missing", dose = "n_breached on 2019-12-31, firm-constant",
  dose2018 = "n_breached on 2018-12-31, firm-constant; missing if date unavailable",
  dose_pre = "Mean n_breached over 2017-06-30 through 2019-12-31; at least 3 nonmissing dates; firm-constant",
  distance = "max(mean(rl1)-0.70,0)/0.10 + max(mean(rl2)-1,0)/0.50 + max(1-mean(rl3),0)/0.50; separate 2017H1-2019H2 means with at least 3 dates each; firm-constant",
  dose_2020h1 = "n_breached on 2020-06-30, firm-constant", post = "1 for date >= 2020-12-31",
  mi_share = "mi/te", mi_gap = "mi/te - ni_mi/ni; NA for ni<=0", jv_ta = "jv/ta",
  perp_te = "perp/te", rl2_gap = "rl2_adj-rl2", inv_ta = "inv/ta", log_ta = "Natural logarithm of positive ta")
dictionary <- data.table(column = names(panel))
dictionary[, definition := vapply(column, function(v) {
  if (grepl("_n_components_present$", v)) {
    if (v == "perp_n_components_present") return("Number selected after A fallback (0/1); HK count of present mapped components")
    return(paste("Number of nonmissing components in", sub("_n_components_present$", "", v)))
  }
  unname(definitions[v])
}, character(1))]
if (anyNA(dictionary$definition)) stop("Dictionary definition missing")
dictionary[, unit := fcase(column %in% c(items, "ibd", "ibd_ext"), "reported currency, units (no conversion)",
  column %in% c("date", "report_date"), "ISO date",
  grepl("_n_components_present$", column) | column %in% c("dose", "dose2018", "dose_2020h1", "n_breached"), "count",
  column %in% c("sample_main", "sample_broad", "wind_sub_imputed", "fye_flag", "has_financials", "has_row", "rl3_upper_bound", "adv_missing", "perp_missing"), "boolean",
  column %in% c("soe", "post", "b1", "b2", "b3"), "0/1", column %in% c("rl1", "rl1_alt", "rl2", "rl2_adj", "rl3", "mi_share", "mi_gap", "jv_ta", "perp_te", "rl2_gap", "inv_ta"), "ratio",
  column == "dose_pre", "mean count (continuous 0-3)",
  column == "distance", "scaled threshold distance",
  column == "log_ta", "log reported currency units", default = "text")]
for (mn in names(maps)) dictionary[, (paste0("items_", mn)) := vapply(column, function(v) {
  v <- sub("_n_components_present$", "", v)
  if (v %in% items) paste(maps[[mn]][[v]], collapse = if (v == "perp" && mn %in% c("a_em", "a_wind")) " ELSE " else " + ") else ""
}, character(1))]
dictionary[, source_items := fifelse(column %in% items | grepl("_n_components_present$", column),
  "Exact raw mappings in items_* columns; partial sums: all missing NA; otherwise missing zero",
  fifelse(column %in% c("owner_type_raw", "owner_name", "soe"), "Wind ownership export 2020-06-30",
  fifelse(column %in% c("firm_id", "name", "market", "listing", "wind_sub", "wind_sub_imputed", "excl_reason", "sample_main", "sample_broad"),
    "Step 2 firm lists and PI exclusions", definition)))]
dictionary[column %in% c("rl1", "rl1_alt", "rl2", "rl2_adj", "rl3", "mi_share", "mi_gap", "jv_ta", "perp_te", "inv_ta"),
           definition := paste0(definition, "; denominator <=0 -> NA")]
dictionary[column == "adv", source_items := paste0(source_items,
  "; exception: all advance components missing -> 0, adv_missing=TRUE")]
dictionary[column %in% c("perp", "perp_mi"), source_items := paste0(source_items,
  "; exception: ta present and all perpetual items missing -> perp=perp_mi=0, perp_missing=TRUE")]

# Required acceptance checks operate on the serialised panel as consumed later.
stopifnot(!anyDuplicated(panel[, .(firm_id, date)]), uniqueN(panel$date) == 13L,
          all(panel$has_row), all(panel$source %in% c("eastmoney", "wind")),
          all(panel[perp_missing == TRUE]$perp == 0),
          all(panel[perp_missing == TRUE]$perp_mi == 0),
          all(!is.na(panel[perp_missing == TRUE]$ta)),
          all(panel$date %in% target_dates), all(is.na(panel$n_breached) | panel$n_breached %in% 0:3),
          all(panel[market == "A"]$rl3_upper_bound), all(!panel[!is.na(rcash)]$rl3_upper_bound),
          !any(panel[market == "A" & grepl("^(200|900)", firm_id)]$sample_broad),
          !any(panel[firm_id == "600173.SH" | wind_sub == "房地产服务"]$sample_broad),
          !"2768.HK" %in% panel$firm_id, any(panel[firm_id == "2768!2.HK"]$source == "wind", na.rm = TRUE))
# T015: append ownership only after the frozen T004/T012 diagnostics/dictionary.
# Preserve the original column order and match permanent firm_id only.
new_ownership <- c("owner_class_final", "soe_final", "soe_source")
stopifnot(ncol(panel) == 86L, !any(new_ownership %in% names(panel)))
manual <- fread("data/raw/manual/ownership_manual_coding.csv",
                colClasses = c(firm_id = "character", soe_final = "integer"),
                na.strings = c("", "NA"))
stopifnot(identical(names(manual), c("firm_id", "name", "owner_class", "soe_final", "source")))
if (anyNA(manual$firm_id) || anyDuplicated(manual$firm_id))
  stop("STOP: missing or duplicated manual ownership firm_id.")
if (any(!manual$firm_id %in% universe$firm_id))
  stop("STOP: manual ownership firm_id outside the approved universe.")
ignored_manual <- setdiff(manual$firm_id, panel$firm_id)
approved_absent <- c("0283.HK", "600515.SH", "600620.SH")
if (length(setdiff(ignored_manual, approved_absent)))
  stop("STOP: unexpected manual ownership firm_id missing in panel: ",
       paste(setdiff(ignored_manual, approved_absent), collapse = ", "))
stopifnot(all(is.na(manual$soe_final) | manual$soe_final %in% 0:1),
          all(is.na(manual[owner_class %in% c("state_no_controller", "other", "unknown", "conflict")]$soe_final)))
manual_row <- match(panel$firm_id, manual$firm_id)
panel[, owner_class_final := fifelse(!is.na(soe), fifelse(soe == 1L, "SOE", "private"),
                                    manual$owner_class[manual_row])]
panel[, soe_final := fcoalesce(soe, manual$soe_final[manual_row])]
panel[, soe_source := fifelse(!is.na(soe), "wind",
                              fifelse(!is.na(manual_row), "manual", NA_character_))]
stopifnot(identical(tail(names(panel), 3L), new_ownership),
          all(panel[!is.na(soe)]$soe_final == panel[!is.na(soe)]$soe))
ownership_firms <- unique(panel[sample_main == TRUE], by = "firm_id")
if (any(vapply(0:1, function(g) sum(ownership_firms$soe_final == g, na.rm = TRUE), integer(1)) < 30L))
  stop("STOP: fewer than 30 sample_main firms in an ownership group.")
cat("T015 ownership counts (sample_main firms):\n")
print(ownership_firms[, .N, by = .(owner_class_final, soe_final)][order(owner_class_final)])
cat("T015 Wind-to-final cross-tab (sample_main firms):\n")
print(ownership_firms[, .N, by = .(soe, soe_final, soe_source)][order(soe, soe_final)])
cat("T015 not in panel, ignored: ", paste(sort(ignored_manual), collapse = ", "), "\n", sep = "")

# Independent frozen T012 hash: all first 86 columns must remain byte-identical
# after normalising line endings, including when no prior panel is present.
prefix_panel <- tempfile(fileext = ".csv")
fwrite(panel[, seq_len(86L), with = FALSE], prefix_panel, na = "NA", logical01 = FALSE, eol = mtpa_eol())
prefix_hash <- mtpa_sha256(prefix_panel)
unlink(prefix_panel)
if (!identical(prefix_hash, "e1a5e2be4647641c666215c5e5447b93656d2f98e8c88996bf3b9f53a767fadb"))
  stop("STOP: T015 changes an existing panel column (first 86 columns SHA-256 mismatch).")
cat("T015 ASSERT: first 86 columns SHA-256 ", prefix_hash, "; three ownership columns appended.\n", sep = "")

out_files <- c("data/processed/panel_firm_halfyear.csv", "outputs/tables/t004_panel_counts.csv",
  "outputs/tables/t004_item_coverage.csv", "outputs/tables/t004_ownership_unresolved.csv",
  "outputs/tables/t004_variable_dictionary.csv")
for (d in unique(dirname(out_files))) dir.create(d, recursive = TRUE, showWarnings = FALSE)
# Stage every file and validate all gates before publishing. The legacy panel
# checksum below is hard-coded from the delivered T004 CSV, independent
# of any current output. Preserve original types and fwrite serialization.
staged <- vapply(out_files, function(x) tempfile(fileext = ".csv"), character(1))
for (i in seq_along(out_files)) fwrite(list(panel, counts, coverage, unresolved, dictionary)[[i]],
  staged[i], na = "NA", logical01 = FALSE, eol = mtpa_eol())
old_columns <- setdiff(names(panel), c(new_treatments, new_ownership))
stopifnot(length(old_columns) == 83L)
legacy_panel <- tempfile(fileext = ".csv")
fwrite(panel[, ..old_columns], legacy_panel, na = "NA", logical01 = FALSE, eol = mtpa_eol())
legacy_hash <- mtpa_sha256(legacy_panel)
unlink(legacy_panel)
mtpa_guard(identical(legacy_hash, "b3bf2b5c2b21c215ed7eddbf7eecbfc0d4d8007e4e95bb2d4a1b9c82deaea5f1"),
  "STOP: T012 changes an existing panel value (normalised T004 SHA-256 mismatch).")
# Protected T004 tables: create when absent; compare before any publication
# when present. Identical targets retain their contents and modification times.
for (i in 2:4) {
  if (file.exists(out_files[i]))
    mtpa_guard(identical(mtpa_sha256(staged[i]), mtpa_sha256(out_files[i])),
               paste0("STOP: protected T004 output differs: ", out_files[i]))
}
for (i in seq_along(out_files)) {
  # A warning never authorises overwriting an existing protected target.
  if (i %in% 2:4 && file.exists(out_files[i])) next
  if (!file.exists(out_files[i]) ||
      !identical(mtpa_sha256(staged[i]), mtpa_sha256(out_files[i])))
    stopifnot(file.copy(staged[i], out_files[i], overwrite = i %in% c(1L, 5L)))
}
unlink(staged)
cat("T012 ASSERT: 2279 rows; all 83 previous panel columns match T004 SHA-256 ", legacy_hash,
    "; protected T004 outputs checked (see any guard warnings).\n", sep = "")
p <- fread(out_files[1L]); set.seed(20261016)
check <- p[sample.int(nrow(p), 10L)]
for (v in c("rl1", "rl2", "rl3")) {
  actual <- switch(v, rl1 = safe_ratio(check$tl-check$adv, check$ta-check$adv),
    rl2 = safe_ratio(check$ibd-check$cash, check$te),
    rl3 = safe_ratio(check$cash-fcoalesce(check$rcash, 0), check$std))
  stopifnot(identical(is.na(actual), is.na(check[[v]])), all(abs(actual-check[[v]]) <= 1e-9, na.rm = TRUE))
}
stopifnot(all(p[, uniqueN(dose), by = firm_id]$V1 == 1L),
  all(p[, uniqueN(dose_2020h1), by = firm_id]$V1 == 1L),
  all(p$post == as.integer(p$date >= as.IDate("2020-12-31"))))
for (sn in c("all", "sample_broad", "sample_main")) {
  z <- if (sn == "all") p else p[get(sn) == TRUE]
  actual <- count_rows(z, "10_final_panel", sn)
  expected <- counts[stage == "10_final_panel" & sample == sn]
  setorder(actual, market, listing); setorder(expected, market, listing)
  stopifnot(identical(actual$n_firms, expected$n_firms),
            identical(actual$n_firm_dates, expected$n_firm_dates))
}
cat("Random recomputation rows (seed 20261016; tolerance 1e-9):\n")
print(check[, .(firm_id, date, rl1, rl2, rl3)])
cat("Firm register sample counts (including firms without financial rows):\n"); print(universe[,
  .(firms = .N, main = sum(sample_main), broad = sum(sample_broad),
     broad_soe_known = sum(sample_broad & !is.na(soe))), by = .(market, listing)])
cat("Published panel firm sample counts:\n"); print(unique(p, by = "firm_id")[,
  .(firms = .N, main = sum(sample_main), broad = sum(sample_broad),
    broad_soe_known = sum(sample_broad & !is.na(soe))), by = .(market, listing)])
cat("Balance identity deviations above 1e-6 of assets (diagnostic only):\n")
print(p[!is.na(ta) & ta > 0 & !is.na(tl) & !is.na(te),
  .(n_checked = .N, n_deviations = sum(abs(ta - tl - te) / ta > 1e-6)), by = .(market, source)])
cat("Dose distribution by sample (firms):\n")
for (sn in c("sample_main", "sample_broad")) {
  cat(sn, ": all firms\n")
  print(unique(p[get(sn) == TRUE], by = "firm_id")[, .N, by = dose][order(dose)])
  # Exclude any firm with imputed advances in any target period; keep the
  # definition explicit so the robustness summary can be reproduced.
  no_imputed_adv <- p[get(sn) == TRUE, .(any_adv_missing = any(adv_missing)), by = firm_id][any_adv_missing == FALSE, firm_id]
  cat(sn, ": firms without adv_missing in any target period\n")
  print(unique(p[firm_id %in% no_imputed_adv], by = "firm_id")[, .N, by = dose][order(dose)])
}
cat("Outputs:", nrow(p), "rows;", uniqueN(p$firm_id), "firms;", ncol(p), "columns.\n")
cat("PASS: key, date, exclusion, dose, post, restricted-cash and random ratio checks.\n")

