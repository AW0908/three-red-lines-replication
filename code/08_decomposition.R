# T027: descriptive accounting decomposition. Run from replication/.
# No downloads, package installations, currency conversion, or causal estimates.
set.seed(20261016)
options(digits = 17)
B <- 999L
input <- "data/processed/panel_firm_halfyear.csv"
input_hash <- tools::sha256sum(input)
protected <- list.files("outputs", recursive=TRUE, full.names=TRUE)
protected <- protected[!dir.exists(protected) & !grepl("^t027_",basename(protected))]
protected_hash <- tools::sha256sum(protected)
write_csv <- function(x,name) {
  con <- file(paste0("outputs/tables/t027_",name,".csv"),"wb")
  on.exit(close(con)); write.csv(x,con,row.names=FALSE,na="",eol="\n")
}
write_text <- function(x,name) {
  con <- file(paste0("outputs/tables/t027_",name),"wb")
  on.exit(close(con)); writeLines(x,con,useBytes=TRUE)
}
safe_log <- function(x) {
  z <- rep(NA_real_,length(x)); ok <- is.finite(x)&x>0; z[ok]<-log(x[ok]); z
}
safe_logit <- function(x) {
  z <- rep(NA_real_,length(x)); ok<-is.finite(x)&x>0&x<1
  z[ok]<-qlogis(x[ok]); z
}
safe_div <- function(x,y) {
  z <- x/y; z[!is.finite(z)|!is.finite(y)|y==0]<-NA_real_; z
}
clean <- function(x) { x[!is.finite(x)]<-NA_real_; x }
max_abs <- function(x) if(any(is.finite(x)))max(abs(x[is.finite(x)])) else NA_real_
nf <- function(x)length(unique(x))
d <- read.csv(input,stringsAsFactors=FALSE,na.strings=c("","NA"))
required <- c("firm_id","date","market","source","sample_main","ta","tl","te","mi",
              "perp","perp_missing","adv","ibd","cash","rl1","rl2","fye_flag")
stopifnot(all(required %in% names(d)),!anyDuplicated(d[c("firm_id","date")]))

# 1. Identity gates. Source mappings in 01_clean.R define total equity including
# minorities: EastMoney A TOTAL_EQUITY, HK 总权益, Wind A/HK 股东权益合计.
# Numerically compare with the rival hypothesis that te excludes mi.
checks <- list()
for(s in c("panel","main")) {
  z <- if(s=="main")d[!is.na(d$sample_main)&d$sample_main,] else d
  for(g in c("all",sort(unique(z$source[!is.na(z$source)])))) {
    x <- if(g=="all")z else z[!is.na(z$source)&z$source==g,]
    ok <- with(x,is.finite(ta)&ta>0&is.finite(tl)&is.finite(te))
    residual <- with(x,abs(ta-tl-te)/ta)
    mi_ok <- ok & is.finite(x$mi) & abs(x$mi)/x$ta>.01
    rival <- with(x,abs(ta-tl-te-mi)/ta)
    checks[[length(checks)+1L]] <- data.frame(sample=s,source=g,rows=nrow(x),
      evaluated=sum(ok),missing_identity=sum(!ok),violations=sum(residual[ok]>.01),
      violation_share=mean(residual[ok]>.01),max_relative_residual=max_abs(residual[ok]),
      informative_mi_rows=sum(mi_ok),rival_excluding_mi_violations=sum(rival[mi_ok]>.01),
      max_rl1_identity_difference=max_abs((x$tl-x$adv)/(x$tl-x$adv+x$te)-x$rl1))
  }
}
checks <- do.call(rbind,checks)
identity <- c("T027 identity checks; no bootstrap tests at this gate.",
  apply(checks,1,function(x)paste(names(checks),x,sep="=",collapse="; ")),
  "te provenance: 01_clean.R maps total equity including minorities, not parent equity.",
  "Rival identity subtracts mi again; informative rows have abs(mi)/ta > 0.01.",
  "Evidence is accounting consistency plus item mappings; contracts are not observed.",
  "RL1 events use stored rl1. Decomposition uses Rstar=N/(N+te), N=tl-adv.",
  "Stored RL1=(tl-adv)/(ta-adv); tiny balance-rounding differences are audited.")
write_text(identity,"identity_checks.txt")
stopifnot(all(checks$violation_share[checks$source=="all"]<=.05))
mi_check <- checks[checks$sample=="main"&checks$source=="all",]
if(mi_check$informative_mi_rows==0L ||
   mi_check$rival_excluding_mi_violations<=mi_check$informative_mi_rows/2)
  stop("STOP step 1: inclusion of mi in te is not supported.")

d <- d[!is.na(d$sample_main)&d$sample_main,]
d$date <- as.Date(d$date); d <- d[order(d$firm_id,d$date),]
stopifnot(all(format(d$date,"%m-%d") %in% c("06-30","12-31")))
d$h <- as.integer(format(d$date,"%Y"))*2L+as.integer(format(d$date,"%m")=="12")
d$period <- ifelse(d$date>=as.Date("2017-06-30")&d$date<=as.Date("2019-12-31"),"pre",
                   ifelse(d$date>=as.Date("2020-12-31")&d$date<=as.Date("2022-12-31"),"post",NA))
fye_firms <- unique(d$firm_id[!is.na(d$fye_flag)&d$fye_flag])
key <- paste(d$firm_id,d$h)
cells <- c("post_crossings","pre_crossings","post_stayers")

# 2. Event counts before any log-domain or perpetual-coverage restrictions.
events <- function(ratio,lag=1L) {
  j <- match(paste(d$firm_id,d$h-lag),key)
  prev <- d[[ratio]][j]; now <- d[[ratio]]
  threshold <- if(ratio=="rl1").70 else 1
  eligible <- !is.na(j)&is.finite(prev)&is.finite(now)&prev>=threshold
  if(lag==2L) {
    mid <- match(paste(d$firm_id,d$h-1L),key)
    # Do not bridge an absent or financially missing intermediate snapshot.
    eligible <- eligible & !is.na(mid)&is.finite(d[[ratio]][mid])
  }
  cell <- rep(NA_character_,nrow(d))
  pre <- !is.na(d$period)&d$period=="pre"
  post <- !is.na(d$period)&d$period=="post"
  cell[eligible&pre&now<threshold]<-"pre_crossings"
  cell[eligible&post&now<threshold]<-"post_crossings"
  # Benchmark B is explicitly defined for RL1 only.
  if(ratio=="rl1")cell[eligible&post&now>=threshold]<-"post_stayers"
  i <- which(!is.na(cell)); j<-j[i]
  # HK-Wind total perpetuals may already include minority perpetuals (D21).
  # Check either endpoint, including two-period robustness events, before splits.
  observed_wind_hk <- function(k) !is.na(d$perp_missing[k]) & !d$perp_missing[k] &
    !is.na(d$source[k]) & d$source[k]=="wind" & d$market[k]=="HK"
  if(any(observed_wind_hk(i) | observed_wind_hk(j),na.rm=TRUE))
    stop("STOP: observed perpetual event endpoint from HK-Wind may overlap mi (perp_mi).")
  e <- data.frame(ratio=ratio,lag=lag,firm_id=d$firm_id[i],market=d$market[i],
    date0=d$date[j],date1=d$date[i],cell=cell[i],ratio0=prev[i],ratio1=now[i],
    fye_firm=d$firm_id[i] %in% fye_firms,
    perp_observed=!is.na(d$perp_missing[i])&!d$perp_missing[i]&
      !is.na(d$perp_missing[j])&!d$perp_missing[j],stringsAsFactors=FALSE)
  for(v in c("ta","tl","adv","te","mi","perp","ibd","cash")) {
    e[[paste0(v,"0")]]<-d[[v]][j]; e[[paste0(v,"1")]]<-d[[v]][i]
  }
  e
}
e1<-events("rl1"); e2<-events("rl2")
counts <- function(e)do.call(rbind,lapply(if(e$ratio[1]=="rl1")cells else cells[1:2],
  function(c) { z<-e[e$cell==c,]; data.frame(ratio=e$ratio[1],cell=c,events=nrow(z),
    firms=nf(z$firm_id),perp_observed_events=sum(z$perp_observed),
    perp_observed_firms=nf(z$firm_id[z$perp_observed])) }))
event_counts<-rbind(counts(e1),counts(e2)); write_csv(event_counts,"events")
cat("T027 event counts:\n"); print(event_counts,row.names=FALSE)
if(sum(e1$cell=="post_crossings")<20L)stop("STOP step 2: fewer than 20 post-period RL1 crossings.")

# 3-4. Exact decompositions. Zero-change shares are NA, never arbitrary zeros.
decompose <- function(e) {
  n0<-e$tl0-e$adv0; n1<-e$tl1-e$adv1; dn<-n1-n0; de<-e$te1-e$te0
  dibd<-e$ibd1-e$ibd0; dmi<-e$mi1-e$mi0; dp<-e$perp1-e$perp0
  e$dln_n<-safe_log(n1)-safe_log(n0); e$dln_te<-safe_log(e$te1)-safe_log(e$te0)
  e$dln_ibd<-safe_log(e$ibd1)-safe_log(e$ibd0)
  e$ibd_falling<-ifelse(is.finite(e$dln_ibd),as.numeric(e$dln_ibd<0),NA_real_)
  e$ibd_rising<-ifelse(is.finite(e$ibd0)&is.finite(e$ibd1),as.numeric(dibd>0),NA_real_)
  e$debt_change_rmb<-ifelse(e$market=="A",dibd,NA_real_)
  e$equity_mi_perp_share<-safe_div(dmi+dp,de)
  e$equity_mi_perp_share[!e$perp_observed]<-NA_real_
  e$equity_mi_share<-safe_div(dmi,de)
  e$numerator_zero<-dn==0; e$equity_zero<-de==0
  if(e$ratio[1]=="rl1") {
    e$total<-e$dln_n-e$dln_te
    e$reported_total<-safe_logit(e$ratio1)-safe_logit(e$ratio0)
    e$numerator<-e$dln_n; e$equity<--e$dln_te
    e$ibd<-e$dln_n*safe_div(dibd,dn)
    e$other_liabilities<-e$dln_n*safe_div(dn-dibd,dn); e$cash<-NA_real_
    # An individual log change may exist even when the logit does not.
    # Keep it as a separate statistic, but do not label it a logit contribution.
    invalid<-!is.finite(e$total)
    for(v in c("numerator","equity","ibd","other_liabilities"))e[[v]][invalid]<-NA_real_
  } else {
    net0<-e$ibd0-e$cash0; net1<-e$ibd1-e$cash1
    positive_net<-is.finite(net0)&is.finite(net1)&net0>0&net1>0
    e$dln_n<-safe_log(net1)-safe_log(net0)
    e$numerator_zero<-ifelse(positive_net,net1-net0==0,NA)
    e$total<-clean(net1/e$te1-net0/e$te0); e$reported_total<-e$ratio1-e$ratio0
    e$ibd<-clean(dibd/e$te1); e$cash<-clean(-(e$cash1-e$cash0)/e$te1)
    e$numerator<-e$ibd+e$cash; e$equity<-clean(-net0*de/(e$te0*e$te1))
    e$other_liabilities<-NA_real_
  }
  no_equity_term<-!is.finite(e$equity)|e$equity==0
  e$equity_mi_share[no_equity_term]<-NA_real_
  e$equity_mi_perp_share[no_equity_term]<-NA_real_
  e$rounding_residual<-e$reported_total-e$total
  e$parent_including_perp<-e$equity*safe_div(de-dmi,de)
  e$mi<-e$equity*safe_div(dmi,de)
  e$parent_excluding_perp<-e$equity*safe_div(de-dmi-dp,de)
  e$perp<-e$equity*safe_div(dp,de); e$mi_perp<-e$mi+e$perp
  for(v in c("parent_excluding_perp","perp","mi_perp"))e[[v]][!e$perp_observed]<-NA_real_
  parts<-if(e$ratio[1]=="rl1")e$ibd+e$other_liabilities else e$ibd+e$cash
  e$item_sum<-parts+e$parent_including_perp+e$mi
  e$item_sum_perp<-parts+e$parent_excluding_perp+e$mi+e$perp
  # Top-level identity also covers zero changes; each available item split must
  # match the total. Missing shares/logs are separately counted, never imputed.
  assert_equal<-function(a,b) {
    ok<-is.finite(a)&is.finite(b); stopifnot(all(abs(a[ok]-b[ok])<=1e-10))
  }
  assert_equal(e$numerator+e$equity,e$total)
  assert_equal(parts,e$numerator)
  assert_equal(e$parent_including_perp+e$mi,e$equity)
  assert_equal(e$parent_excluding_perp+e$mi_perp,e$equity)
  assert_equal(e$item_sum,e$total); assert_equal(e$item_sum_perp,e$total)
  e$equity_over_half_decline<-ifelse(is.finite(e$total)&e$total<0&is.finite(e$equity),
    as.numeric(-e$equity>.5*(-e$total)),NA_real_)
  e
}
e1<-decompose(e1); e2<-decompose(e2)
audit<-rbind(e1,e2); write_csv(audit,"event_audit")
for(r in c("rl1","rl2")) {
  z<-audit[audit$ratio==r,]
  identity<-c(identity,sprintf(paste0("%s: events=%d; valid totals=%d; invalid totals=%d; ",
    "numerator=%s; zero numerator changes=%d; unavailable numerator-zero flags=%d; zero equity changes=%d; full item sums=%d; observed-perp item sums=%d; ",
    "max full sum error=%.17g; max perp sum error=%.17g; max stored-vs-identity change difference=%.17g"),
    r,nrow(z),sum(is.finite(z$total)),sum(!is.finite(z$total)),
    if(r=="rl1")"tl-adv" else "ibd-cash (zero flags require positive net debt at both dates)",
    sum(z$numerator_zero,na.rm=TRUE),sum(is.na(z$numerator_zero)),sum(z$equity_zero,na.rm=TRUE),
    sum(is.finite(z$item_sum)),sum(is.finite(z$item_sum_perp)),
    max_abs(z$item_sum-z$total),max_abs(z$item_sum_perp-z$total),max_abs(z$rounding_residual)))
}
identity<-c(identity,"All available event-level component sums asserted within 1e-10.",
  "Missing log domains or zero-change denominators remain NA; see event audit and summary coverage.")
write_text(identity,"identity_checks.txt")

# 5. Each statistic reports its denominator; medians are primary.
metrics<-c("total","reported_total","rounding_residual","numerator","equity","dln_n","dln_te","dln_ibd",
  "ibd","other_liabilities","cash","parent_including_perp","mi","parent_excluding_perp","perp","mi_perp",
  "ibd_falling","equity_over_half_decline","equity_mi_share","equity_mi_perp_share")
meaning<-c(
 total="Negative: ratio declined; compatible with either adjustment channel.",
 reported_total="Stored ratio change; compare with identity-implied total for rounding.",
 rounding_residual="Accounting rounding, not an adjustment channel.",
 numerator="Negative: lower non-advance liabilities (RL1), or lower net debt (RL2).",
 equity="Negative: equity lowers the ratio; economic meaning depends on its source.",
 dln_n="Negative: less non-advance liabilities; not all are interest-bearing debt.",
 dln_te="Positive: equity expanded; only debt-like partners and equity-booked perpetuals are cosmetic-leaning.",
 dln_ibd="Negative: interest-bearing debt actually fell, supporting real debt reduction.",
 ibd="Negative contribution: interest-bearing debt reduction lowers the ratio.",
 other_liabilities="Negative: other non-advance liabilities fell; not necessarily financial debt.",
 cash="Negative: cash growth lowers net gearing; not gross debt reduction.",
 parent_including_perp="Negative: non-minority equity lowers the ratio; includes unresolved perpetuals.",
 mi="Negative: minority equity lowers the ratio; cosmetic-leaning only for debt-like partners.",
 parent_excluding_perp="Negative: parent equity excluding perpetuals lowers the ratio; not itself cosmetic evidence.",
 perp="Negative: perpetual growth lowers the ratio; cosmetic-leaning under theory measurement assumptions.",
 mi_perp="Negative: minority plus perpetual equity lowers the ratio under theory measurement assumptions.",
 ibd_falling="Higher proportion: more events with actual interest-bearing debt reduction.",
 equity_over_half_decline="Higher proportion: equity dominates ratio declines; equity need not be cosmetic.",
 equity_mi_share="Higher signed share: more equity change from minorities; debt-like partner assumption required.",
 equity_mi_perp_share="Higher signed share: more equity change from minorities plus observed perpetuals; theory assumptions required.")
split_metrics<-c("parent_excluding_perp","perp","mi_perp","equity_mi_perp_share")
summary_table<-function(e,winsor=FALSE) {
  rows<-list()
  for(cell in if(e$ratio[1]=="rl1")cells else cells[1:2])for(s in c("all_events","perp_observed_both_dates")) {
    z<-e[e$cell==cell & (s=="all_events"|e$perp_observed),]
    for(m in metrics) {
      if(s=="all_events"&m %in% split_metrics)next
      if(e$ratio[1]=="rl1"&m=="cash")next
      if(e$ratio[1]=="rl2"&m=="other_liabilities")next
      x<-z[[m]]; ok<-is.finite(x); x<-x[ok]
      med<-if(length(x))median(x) else NA_real_
      if(winsor&length(x)>0) {
        q<-quantile(x,c(.01,.99),names=FALSE,type=7); x<-pmax(q[1],pmin(q[2],x))
      }
      rows[[length(rows)+1L]]<-data.frame(ratio=e$ratio[1],cell=cell,sample=s,metric=m,
        n_events=nrow(z),n_firms=nf(z$firm_id),n_available=length(x),firms_available=nf(z$firm_id[ok]),
        n_missing=sum(!ok),median=med,mean=if(length(x))mean(x) else NA_real_,
        interpretation=if(m=="reported_total"&e$ratio[1]=="rl1")
          "logit change of the stored ratio" else if(m=="dln_n"&e$ratio[1]=="rl2")
          "Negative: lower net debt (ibd minus cash); unavailable if net debt is nonpositive at either date." else
          unname(meaning[m]))
    }
  }
  do.call(rbind,rows)
}
s1<-summary_table(e1); s2<-summary_table(e2)
write_csv(s1,"decomposition_rl1"); write_csv(s2,"decomposition_rl2")

# 6. Shared whole-firm resamples preserve within-firm, cross-period dependence.
# Repetition weights duplicate observations, including R's even-N median rule.
firms<-sort(unique(d$firm_id)); G<-length(firms)
boot<-replicate(B,tabulate(sample.int(G,G,replace=TRUE),nbins=G))
stat<-function(z,metric,statistic,weights=rep(1L,nrow(z))) {
  ok<-is.finite(z[[metric]])&weights>0
  if(!any(ok))return(NA_real_)
  x<-rep(z[[metric]][ok],times=weights[ok])
  if(statistic=="mean")mean(x) else median(x)
}
specs<-data.frame(metric=c("dln_n","dln_te","ibd_falling","equity_mi_perp_share","dln_ibd",
                          "equity_mi_share","equity_mi_share"),
  statistic=c("median","median","mean","median","median","median","mean"),
  comparison=c(rep("post_crossings_minus_pre_crossings",4),"post_crossings_minus_post_stayers",
               rep("post_crossings_minus_pre_crossings",2)))
tests<-list()
for(i in seq_len(nrow(specs))) {
  sp<-specs[i,]; a<-e1[e1$cell=="post_crossings",]
  b<-e1[e1$cell==if(sp$comparison=="post_crossings_minus_post_stayers")"post_stayers" else "pre_crossings",]
  ia<-match(a$firm_id,firms); ib<-match(b$firm_id,firms)
  av<-stat(a,sp$metric,sp$statistic); bv<-stat(b,sp$metric,sp$statistic)
  draws<-vapply(seq_len(B),function(j)stat(a,sp$metric,sp$statistic,boot[ia,j])-
    stat(b,sp$metric,sp$statistic,boot[ib,j]),numeric(1))
  valid<-is.finite(draws)
  ci<-if(any(valid))quantile(draws[valid],c(.025,.975),names=FALSE,type=7) else c(NA,NA)
  tests[[i]]<-data.frame(ratio="rl1",comparison=sp$comparison,metric=sp$metric,statistic=sp$statistic,
    sample=if(sp$metric %in% split_metrics)"perp_observed_both_dates" else "all_events",
    post_value=av,benchmark_value=bv,estimate=av-bv,ci_low=ci[1],ci_high=ci[2],
    post_n=sum(is.finite(a[[sp$metric]])),benchmark_n=sum(is.finite(b[[sp$metric]])),
    post_firms=nf(a$firm_id[is.finite(a[[sp$metric]])]),benchmark_firms=nf(b$firm_id[is.finite(b[[sp$metric]])]),
    bootstrap_draws=B,bootstrap_valid=sum(valid),bootstrap_failed=sum(!valid),
    inference_status=if(mean(valid)>=.9)"pointwise_descriptive" else "conditional_unreliable",
    interpretation=unname(meaning[sp$metric]))
}
tests<-do.call(rbind,tests); write_csv(tests,"tests")

# 7. Pooled within-firm log changes; RMB levels only for A shares.
growth<-list()
for(scope in c("pooled_within_firm_logs","A_share_RMB"))for(cell in cells) {
  z<-e1[e1$cell==cell & (scope!="A_share_RMB"|e1$market=="A"),]
  for(metric in c("dln_ibd","ibd_rising","ibd_falling",if(scope=="A_share_RMB")"debt_change_rmb")) {
    ok<-is.finite(z[[metric]]); x<-z[[metric]][ok]
    growth[[length(growth)+1L]]<-data.frame(cell=cell,sample=scope,metric=metric,n_events=nrow(z),
      n_available=length(x),firms_available=nf(z$firm_id[ok]),median=if(length(x))median(x) else NA_real_,
      mean=if(length(x))mean(x) else NA_real_,note=if(scope=="A_share_RMB")
        "A-share levels in RMB; no HK levels pooled." else
        "HK and A within-firm logs and direction shares pooled; assumes unchanged reporting currency within firm (D7 unresolved).")
  }
}
write_csv(do.call(rbind,growth),"debt_growth")

# 8. One-at-a-time robustness, descriptive summaries, no additional tests.
rob<-list()
for(v in c("narrow_RL1_066_070","exclude_fye_firms","winsorized_means_01_99","two_period_crossings"))
  for(r in c("rl1","rl2")) {
    if(v=="narrow_RL1_066_070"&r=="rl2")next
    z<-if(v=="two_period_crossings")decompose(events(r,2L)) else if(r=="rl1")e1 else e2
    # Narrow restriction changes crossing destinations only, not benchmark B.
    if(v=="narrow_RL1_066_070")z<-z[z$cell=="post_stayers"|z$ratio1>=.66,]
    if(v=="exclude_fye_firms")z<-z[!z$fye_firm,]
    s<-summary_table(z,winsor=v=="winsorized_means_01_99"); s$variant<-v
    rob[[length(rob)+1L]]<-s
  }
write_csv(do.call(rbind,rob),"robustness")

# Plain American English TeX notes; labels do not expose CSV underscores.
fmt<-function(x)ifelse(is.finite(x),sprintf("%.4f",ifelse(round(x,4)==0,0,x)),"--")
binary_metrics<-c("ibd_falling","equity_over_half_decline")
rl1_units<-"Change in logit(RL1) = $\\Delta\\ln N - \\Delta\\ln te$; all components in log-odds units."
post_logit<-median(e1$total[e1$cell=="post_crossings"],na.rm=TRUE)
post_pp<-100*.70*(1-.70)*post_logit
rl1_translation<-sprintf(paste0("Near RL1 = 0.70, $\\Delta RL1 \\approx RL1(1-RL1)\\cdot\\Delta\\mathrm{logit}(RL1)$; ",
  "the post-crossing median %.4f log-odds corresponds to approximately %.2f percentage points."),post_logit,post_pp)
labels<-c(total="Total change",numerator="Numerator term",equity="Equity term",ibd="Interest-bearing debt",
 other_liabilities="Other non-advance liabilities",cash="Cash",
 parent_including_perp="Parent equity including unresolved perpetuals",mi="Minority equity",
 parent_excluding_perp="Parent equity excluding perpetuals",perp="Perpetual instruments",
 mi_perp="Minority plus perpetual equity",dln_n="Log non-advance liabilities change",
 dln_te="Log equity change",dln_ibd="Log interest-bearing debt change",
 ibd_falling="Share with interest-bearing debt falling",equity_over_half_decline="Share with equity over half of decline",
 equity_mi_share="Minority share of equity change",equity_mi_perp_share="Minority plus perpetual share of equity change")
common_note<-paste(
 "Descriptive selected transitions; these identities do not identify a causal policy effect or full economic leverage.",
 "Pre destinations are 2017H1--2019H2; post destinations are 2020H2--2022H2, using consecutive half-year endpoints.",
 "Minority interests and perpetuals are cosmetic-leaning only under the theory note's measurement assumptions: debt-like partner equity, and perpetuals booked as equity.",
 "Existing stocks are not new cosmetic adjustment; changes, rather than pre-existing wedges, are decomposed.",
 "Contributions and equity-change shares are signed, may offset, and are not clipped to the unit interval.",
 "Zero total changes make the corresponding item shares unavailable.",
 "HK log changes assume unchanged reporting currency within each firm; currency metadata remain unresolved.")
bs<-intToUtf8(92); rowend<-paste0(" ",bs,bs)
tex_table<-function(lines,name,title,note,columns) {
  result<-c("\\begin{table}[!htbp]\\centering\\scriptsize",paste0("\\caption{",title,"}"),
    "\\begin{threeparttable}",paste0("\\begin{tabular}{",columns,"}"),"\\toprule",lines,
    "\\bottomrule","\\end{tabular}","\\begin{tablenotes}[flushleft]\\footnotesize",
    paste0("\\item[] ",note),"\\end{tablenotes}","\\end{threeparttable}","\\end{table}")
  if(!is.null(name))write_text(result,paste0(name,".tex"))
  invisible(result)
}
for(r in c("rl1","rl2")) {
  s<-if(r=="rl1")s1 else s2
  document<-character()
  # Each cell has its own float, including the complete measurement notes.
  shown<-c("total","ibd",if(r=="rl1")"other_liabilities" else "cash",
           "parent_including_perp","mi","parent_excluding_perp","mi_perp",
           "ibd_falling","equity_over_half_decline","equity_mi_perp_share")
  for(cell in if(r=="rl1")cells else cells[1:2]) {
  lines<-c(paste0("Component & N & Firms & Median & Mean",rowend),"\\midrule")
  for(scope in c("all_events","perp_observed_both_dates")) {
    show<-if(scope=="all_events")setdiff(shown,split_metrics) else
      c("total","ibd",if(r=="rl1")"other_liabilities" else "cash",
        "parent_excluding_perp","mi","perp","mi_perp","equity_mi_perp_share")
    z<-s[s$cell==cell&s$sample==scope&s$metric %in% show,]
    title<-paste(gsub("_"," ",cell),if(scope=="all_events")"(all events)" else "(perpetuals observed at both dates)")
    lines<-c(lines,paste0("\\multicolumn{5}{l}{",title,"}",rowend))
    for(i in seq_len(nrow(z)))lines<-c(lines,paste0(paste(labels[z$metric[i]],z$n_available[i],
      z$firms_available[i],if(z$metric[i] %in% binary_metrics)"--" else fmt(z$median[i]),
      fmt(z$mean[i]),sep=" & "),rowend))
  }
  note<-paste(common_note,if(r=="rl1")
    paste(rl1_units,rl1_translation,
      "RL1 uses identity-implied N/(N+te); stored-ratio rounding differences are audited.") else
    "RL2 is decomposed in levels using end-period equity in the numerator term and initial net debt in the equity term.",
    "Negative components lower the ratio. N counts available event statistics; full medians, means and exclusions are in the CSV.",
    "Equity dominance is conditional on a ratio decline. Binary-share means are proportions; their medians are shown as --.",
    "The minority plus perpetual share is the signed event-level equity contribution divided by the equity term; zero equity changes are unavailable.",
    if(r=="rl1"&cell=="pre_crossings")
      "The perpetual-observed pre-period panel has 2 events from 1 firm and is not interpretable as a pre/post comparison." else "",
    "Component medians generally do not sum to the median total. Shares are dimensionless; separate log changes are not item contributions. No significance stars.")
  document<-c(document,tex_table(lines,NULL,paste("Accounting decomposition of",toupper(r),gsub("_"," ",cell),
    if(r=="rl1")rl1_units else ""),
    note,"p{0.56\\linewidth}rrrr"),"")
  }
  write_text(document,paste0("decomposition_",r,".tex"))
}
lines<-c(paste0("Statistic and comparison & Difference & Lower & Upper",rowend),"\\midrule")
for(i in seq_len(nrow(tests))) {
  t<-tests[i,]; label<-paste(labels[t$metric],paste0("(",t$statistic,"; ",
    if(t$comparison=="post_crossings_minus_post_stayers")"post minus stayers" else "post minus pre",
    if(t$metric=="equity_mi_perp_share")"; conditional/unreliable" else "", ")"))
  lines<-c(lines,paste0(paste(label,fmt(t$estimate),fmt(t$ci_low),fmt(t$ci_high),sep=" & "),rowend))
}
tex_table(lines,"tests",paste("RL1 crossing contrasts with firm-cluster bootstrap intervals.",rl1_units),
  paste(common_note,rl1_units,rl1_translation,
    "All seven contrasts are reported, with percentile 95 percent intervals from 999 whole-firm resamples shared across groups.",
    "Log changes and the minority plus perpetual equity-change share use medians; debt-falling proportions use means. Shares are dimensionless.",
    sprintf("The all-events minority share contrast reports both median and mean, with %d post and %d pre available events; missing post minority observations: %d.",
      tests$post_n[6],tests$benchmark_n[6],sum(e1$cell=="post_crossings")-tests$post_n[6]),
    "Only the minority plus perpetual share requires perpetual items observed at both endpoints. All equity-change shares require nonzero equity changes. CSV reports coverage and valid draws.",
    sprintf("For this contrast, the pre group has %d events from %d firm; only %d of %d draws are valid. This conditional interval is unreliable for inference.",
      tests$benchmark_n[4],tests$benchmark_firms[4],tests$bootstrap_valid[4],B),
    "The perpetual-observed pre-period subsample is not interpretable as a pre/post comparison. Intervals are pointwise and unadjusted for multiple testing; no significance stars."),
  "p{0.62\\linewidth}rrr")

# All-events split: no perpetual-observation restriction. Each median uses its
# available events, as in the all_events CSV panel; report component coverage.
# Positive and negative stacks separate; dots show actual median totals.
fig<-list(); parts<-c("ibd","other_liabilities","parent_including_perp","mi")
for(cell in cells) {
  z<-e1[e1$cell==cell,]
  stopifnot(nrow(z)>0L)
  fig[[cell]]<-list(n=nrow(z),firms=nf(z$firm_id),
    available=vapply(z[parts],function(x)sum(is.finite(x)),integer(1)),
    med=vapply(z[parts],median,numeric(1),na.rm=TRUE),total=median(z$total,na.rm=TRUE))
}
m<-do.call(cbind,lapply(fig,function(x)x$med))
lo<-min(0,colSums(pmin(m,0)),vapply(fig,function(x)x$total,numeric(1)))
hi<-max(0,colSums(pmax(m,0)),vapply(fig,function(x)x$total,numeric(1)))
grDevices::pdf("outputs/figures/t027_decomposition_rl1.pdf",width=9,height=8.5,
  useDingbats=FALSE,timestamp=FALSE,title="T027 descriptive accounting decomposition")
par(mar=c(15,4.5,8,1),las=1)
plot(NA,xlim=c(.4,3.6),ylim=c(lo-.1*(hi-lo),hi+.15*(hi-lo)),xaxt="n",xlab="",
  ylab="Contribution to change in RL1 log-odds")
title("RL1 crossing decomposition (descriptive)",line=6)
abline(h=0,col="grey50"); cols<-c("#2C6E9B","#8AB1C2","#C69250","#9C4C61")
for(j in 1:3) {
  pos<-neg<-0
  for(i in 1:4) {
    v<-m[i,j]; base<-if(v>=0)pos else neg
    rect(j-.25,base,j+.25,base+v,col=cols[i],border="white")
    if(v>=0)pos<-pos+v else neg<-neg+v
  }
  points(j,fig[[j]]$total,pch=18,cex=1.2)
}
axis(1,at=1:3,labels=vapply(seq_along(cells),function(j)
  paste(gsub("_"," ",cells[j]),sprintf("N = %d; firms = %d",fig[[j]]$n,fig[[j]]$firms),sep="\n"),character(1)))
legend("top",inset=c(0,-.22),ncol=2,xpd=NA,
  c("Interest-bearing debt","Other liabilities","Parent equity including perpetuals",
  "Minority equity","Median total (not sum of medians)"),
  fill=c(cols,NA),pch=c(NA,NA,NA,NA,18),bty="n",cex=.70)
figure_note<-c(
 "Change in logit(RL1) = delta ln N - delta ln te; all components in log-odds units.",
 sprintf("Near 0.70: delta RL1 approx. 0.70(1-0.70) x delta logit; median %.4f approx. %.2f percentage points.",post_logit,post_pp),
 "All events; each component median uses available values, without a perpetual restriction.",
 paste0("Available N (debt/other/parent/minority): ",paste(vapply(fig,function(x)
   paste(x$available,collapse="/"),character(1)),collapse="; ")," (bar order)."),
 "Negative contributions lower RL1. Component medians need not add to the median total.",
 "Minority and perpetual equity are cosmetic-leaning only under the theory assumptions:",
 "debt-like partner equity and perpetuals booked as equity. Descriptive selected transitions.",
 "Perpetual-observed pre subsample (2 events, 1 firm) is not interpretable; omitted here.",
 "Pre: 2017H1-2019H2; post: 2020H2-2022H2. Identity-implied RL1; rounding audited.")
for(k in seq_along(figure_note))mtext(figure_note[k],side=1,
  line=5.6+(k-1)*.85,adj=0,cex=.73)
invisible(dev.off())
stopifnot(identical(input_hash,tools::sha256sum(input)),
          identical(protected_hash,tools::sha256sum(protected)))
cat(sprintf("T027: exact available component sums asserted <= 1e-10; %d event audit rows.\n",nrow(audit)))
cat(sprintf("T027: all %d contrasts use %d firm-cluster draws; valid draws %d--%d.\n",
  nrow(tests),B,min(tests$bootstrap_valid),max(tests$bootstrap_valid)))
cat(sprintf("T027: wrote identity, counts, audit, summaries, tests, debt growth, robustness and figure; input and %d protected outputs unchanged.\n",length(protected)))
