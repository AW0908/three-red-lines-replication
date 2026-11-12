# T047 Revision 2. Offline coding, 33 crossing events / 31 firms.
# Run from replication/: Rscript code/18_crossers_coding.R
# Hand coding and source links are inputs; this script never edits them or PI decisions.
options(stringsAsFactors=FALSE, digits=17, scipen=999, OutDec='.')
set.seed(20261029L)
stopifnot(file.exists('replication.Rproj'), requireNamespace('digest',quietly=TRUE))
audit <- 'outputs/audit/T047/'; raw <- 'data/raw/manual/handcollect/'
read <- function(p) read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE,fileEncoding='UTF-8-BOM')
write <- function(x,n) write.csv(x,paste0('outputs/tables/t047_',n,'.csv'),row.names=FALSE,na='NA',fileEncoding='UTF-8')
wa <- function(x,n) write.csv(x,paste0(audit,n,'.csv'),row.names=FALSE,na='NA',fileEncoding='UTF-8')
num <- function(x) suppressWarnings(as.numeric(gsub(',','',x,fixed=TRUE)))
strict_sum <- function(x) if(!length(x)||anyNA(x)) NA_real_ else sum(x)
split_ids <- function(x) unique(Filter(nzchar,unlist(strsplit(x,';',fixed=TRUE))))
state <- function(x) if(length(x)&&all(x=='verified')) 'verified' else 'unverified'
crossers <- read('../state/handcollect/crossers_post.csv'); pilot <- read('../state/handcollect/pilot_purposive.csv')
original <- read(paste0(raw,'pilot_coding.csv')); fresh <- read(paste0(raw,'crossers_coding.csv'))
cf <- read(paste0(raw,'nci_cashflow_all.csv')); panel <- read('data/processed/panel_firm_halfyear.csv')
ann <- read('../Daten/announcements/manifest_crossers.csv'); ars <- read('../Daten/annual_reports_all/manifest.csv')
links <- read(paste0(audit,'component_sources_input.csv'))
stopifnot(identical(names(original),names(fresh)),!anyDuplicated(fresh$transaction_id))
map <- crossers[c('rank','firm_id','name','date0','date1')]
map$event_id <- paste(map$firm_id,map$date0,map$date1,sep=':')
p <- match(map$firm_id,pilot$firm_id)
map$pilot_window_exact_match <- !is.na(p)&map$date0==pilot$date0[p]&map$date1==pilot$date1[p]
map$coding_source <- ifelse(map$pilot_window_exact_match,'T044 exact window reuse','T047 new event')
map$lookback_start <- paste0(as.integer(substr(map$date0,1,4))-1,substr(map$date0,5,10))
map$fy0 <- as.integer(substr(map$date0,1,4))-as.integer(substr(map$date0,6,10)!='12-31')
map$fy1 <- as.integer(substr(map$date1,1,4))
map$window_start <- paste0(map$fy0,'-12-31');map$window_end <- paste0(map$fy1,'-12-31')
map$closing_report_local <- vapply(seq_len(nrow(map)),function(i) any(ars$firm_id==map$firm_id[i]&ars$report==paste0('FY',map$fy1[i])&file.exists(file.path('..',ars$file))),logical(1))
stopifnot(nrow(map)==33L,length(unique(map$firm_id))==31L,sum(map$pilot_window_exact_match)==6L,sum(!map$pilot_window_exact_match)==27L,
 setequal(fresh$firm_id,map$firm_id[!map$pilot_window_exact_match]),!anyDuplicated(map$event_id))
wa(map,'sample_mapping')
# Only T044 windows explicitly authorized for reuse enter the coding pool.
coding <- rbind(original[original$firm_id%in%map$firm_id[map$pilot_window_exact_match],],fresh)
stopifnot(!anyDuplicated(coding$transaction_id))

# PI rule 2026-10-28, bound to exact current text and immutable line number.
lines <- readLines(paste0(raw,'case_notes.md'),encoding='UTF-8',warn=FALSE)
verification <- read(paste0(raw,'case_notes_verification.csv')); statements <- list();f <- ''
for(i in seq_along(lines)) {
 if(startsWith(lines[i],'## ')) {f<-substring(lines[i],4);next}
 if(!f%in%map$firm_id||!nzchar(trimws(lines[i]))||startsWith(lines[i],'#')) next
 txt <- trimws(gsub('\\[[^][]+\\]','',lines[i]));id<-paste0(f,':L',i)
 v<-verification[verification$statement_id==id,,drop=FALSE]
 bound<-nrow(v)==1L&&v$status=='yes'&&v$verified_by=='PI'&&v$statement==txt
 head<-if(grepl('records',txt,fixed=TRUE)) strsplit(txt,'records',fixed=TRUE)[[1]][1] else txt
 numeric_item<-grepl('^(The (FY|H1)[0-9]{4} (annual |interim )?(report|cash-flow statement|statement|balance sheet|income statement)[^.]*records|The proposed [^.]* contribution by [^.]* is [0-9]|[^.]{0,80} is to contribute cash of [0-9])',txt)&&
 !grepl('subsidiar|related|repurchase|may require|option|guarantee|loan|identif|controll(ing|er) shareholder|creditor',head,ignore.case=TRUE)
 statements[[length(statements)+1L]]<-data.frame(statement_id=id,firm_id=f,line=i,statement=txt,
  required_level=if(numeric_item)'strings or meaning' else 'meaning',
  verified_numeric=bound&&v$level%in%c('strings','meaning'),verified_meaning=bound&&v$level=='meaning')
}
statements<-do.call(rbind,statements)
verified <- function(ids,kind='meaning') {
 z<-match(split_ids(ids),statements$statement_id)
 flag<-if(kind=='numeric') statements$verified_numeric else statements$verified_meaning
 if(length(z)&&all(!is.na(z))&&all(flag[z])) 'verified' else 'unverified'
}

# Exact T044 Rework-3 feature order. No transaction-ID or text exceptions.
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
wa(evidence_check, "evidence_checks")
stopifnot(all(evidence_check$text_match))
# Stratified check sample: every D, G and H row plus five random U rows (fixed seed).
set.seed(20261029L)
is_tx <- coding$record_type == "transaction"
u_rows <- which(is_tx & coding$category == "U")
check_ix <- c(which(is_tx & coding$category %in% c("D", "G", "H")), sort(sample(u_rows, 5L, replace = FALSE)))
check_sample <- coding[check_ix, c("transaction_id", "transaction_group_id", "firm_id", "category",
  "debt_subtype", "file", "page", "subsidiary", "partner", "reason")]
check_sample$stratum <- ifelse(check_sample$category == "U", "random U (seed 20261029)", "all D/G/H")
check_sample$evidence_checks <- vapply(check_sample$transaction_id, function(id)
  sum(evidence_check$transaction_id == id), integer(1))
check_sample$evidence_text_match <- vapply(check_sample$transaction_id, function(id) {
  m <- evidence_check$text_match[evidence_check$transaction_id == id]
  if (length(m)) all(m) else NA }, logical(1))
wa(check_sample, "check_sample")


evidence_check <- split(evidence_check, seq_len(nrow(evidence_check)))

review_sample<-read(paste0(audit,'check_sample_review.csv'))
stopifnot(setequal(review_sample$transaction_id,check_sample$transaction_id),all(review_sample$check=='PASS'))

# Recompute every magnitude operand from its original input filter. Source links are
# locators, not replacement values. Missing/blank cash-flow cells remain NA.
ledger <- links
ledger$live_value_rmb <- NA_real_; ledger$verification <- 'unverified'
for(i in seq_len(nrow(ledger))) {
 r<-ledger[i,]; value<-num(r$value_rmb)
 if(!is.na(value)) {
  if(r$metric%in%c('mi','ni_mi')) {
   z<-panel[panel$firm_id==r$firm_id&panel$date==paste0(r$year,'-12-31'),]
   stopifnot(nrow(z)==1L,abs(num(z[[r$metric]])-value)<.005)
  } else if(grepl('nci_cashflow_all.csv',r$input_file,fixed=TRUE)) {
   z<-cf[cf$firm_id==r$firm_id&cf$fiscal_year==r$year&cf$metric==r$metric,]
   stopifnot(nrow(z)==1L,abs(num(z$value_rmb)-value)<.005)
  } else {
   oldcf<-read(paste0(raw,'nci_cashflow.csv'))
   z<-oldcf[oldcf$firm_id==r$firm_id&oldcf$report==paste0('FY',r$year)&oldcf$metric==r$metric,]
   stopifnot(nrow(z)==1L)
   mul<-if(grepl('1,000',z$currency_unit,fixed=TRUE))1000 else if(grepl('10,000',z$currency_unit,fixed=TRUE))10000 else 1
   live<-if(z$value%in%c('-','–','—'))0 else abs(num(gsub('[()]','',z$value)))*mul
   stopifnot(abs(live-value)<.005)
  }
  stopifnot(nzchar(r$source_file),nzchar(r$physical_page),nzchar(r$excerpt),nzchar(r$statement_id))
  # Chinese NCI profit must name the profit row, never comprehensive income.
  if(r$metric=='ni_mi'&&!grepl('HK$',r$firm_id))
   stopifnot(grepl('少数股东损益',r$excerpt,fixed=TRUE),!grepl('综合收益',r$excerpt,fixed=TRUE))
  add_check(paste(r$firm_id,r$year,r$metric,sep=':'),'magnitude_operand',r$source_file,r$physical_page,r$excerpt)
  s<-statements$statement[match(r$statement_id,statements$statement_id)]
  stopifnot(length(s)==1L,!is.na(s),grepl(formatC(value,format='f',digits=2,big.mark=','),s,fixed=TRUE))
  ledger$live_value_rmb[i]<-value;ledger$verification[i]<-verified(r$statement_id,'numeric')
 }
}
wa(ledger,'component_ledger')
verification_audit<-data.frame(firm_id=ledger$firm_id,year=ledger$year,metric=ledger$metric,statement_id=ledger$statement_id,label=ledger$verification,pass=vapply(seq_len(nrow(ledger)),function(i)ledger$verification[i]!='verified'||verified(ledger$statement_id[i],'numeric')=='verified',logical(1)))
wa(verification_audit,'verification_checks');stopifnot(all(verification_audit$pass))
evidence_check<-do.call(rbind,evidence_check);wa(evidence_check,'evidence_checks');stopifnot(all(evidence_check$text_match))
get<-function(f,y,k) {z<-ledger[ledger$firm_id==f&ledger$year==as.character(y)&ledger$metric==k,];stopifnot(nrow(z)==1L);z$live_value_rmb}
get_state<-function(f,y,k) {z<-ledger[ledger$firm_id==f&ledger$year%in%as.character(y)&ledger$metric==k,];if(nrow(z)!=length(y))'unverified' else state(z$verification)}

# Explicit event-to-row membership, preserving T044 coding for exact-match windows.
event_rows<-list()
for(i in seq_len(nrow(map))) {
 e<-map[i,]; z<-if(e$pilot_window_exact_match) original[original$firm_id==e$firm_id,] else fresh[fresh$firm_id==e$firm_id,]
 member<-if(e$pilot_window_exact_match) z$window_membership else ifelse(z$date_lower>=e$lookback_start&z$date_upper<=e$date1,'within',ifelse(z$date_upper>=e$lookback_start&z$date_lower<=e$date1,'uncertain_boundary','outside'))
 # A firm coverage marker belongs only to the event whose end date it documents.
 if(!e$pilot_window_exact_match) member[z$record_type=='coverage_gap'&z$date_upper!=e$date1]<-'outside'
 event_rows[[i]]<-data.frame(event_id=e$event_id,firm_id=e$firm_id,transaction_id=z$transaction_id,transaction_group_id=z$transaction_group_id,record_type=z$record_type,category=z$category,debt_subtype=z$debt_subtype,membership=member,coding_source=e$coding_source)
}
er<-do.call(rbind,event_rows);wa(er,'event_transactions')
real<-coding[coding$record_type=='transaction',];order<-c('D','G','H','E','U')
keys<-paste(real$firm_id,real$transaction_group_id)
real$group_category<-ave(real$category,keys,FUN=function(x)order[min(match(x,order))])
groups<-unique(real[c('firm_id','transaction_group_id','group_category')])
groups$transaction_ids<-vapply(groups$transaction_group_id,function(g)paste(real$transaction_id[real$transaction_group_id==g],collapse=';'),character(1))
groups$debt_subtypes<-vapply(groups$transaction_group_id,function(g)paste(unique(Filter(nzchar,real$debt_subtype[real$transaction_group_id==g])),collapse=';'),character(1))
groups$n_rows<-vapply(groups$transaction_group_id,function(g)sum(real$transaction_group_id==g),integer(1))
groups$verification<-vapply(groups$transaction_group_id,function(g)
 state(vapply(real$decisive_statement_ids[real$transaction_group_id==g],verified,character(1))),character(1))
groups$note<-vapply(groups$transaction_group_id,function(g) {
 z<-real[real$transaction_group_id==g,]
 if(any(z$firm_id=='0813.HK'&z$debt_subtype=='D1'))
  'Historical D1 terms: buyback undertaking transferred from the Group to Mr. Hui; lapses on Shimao Services listing. No outstanding year-end Group D1 position inferred.' else ''
},character(1))
wa(groups,'transaction_groups')
# Count categories by economic agreement chain. Coverage gaps are never transactions.
count_rows<-function(z,scope,id,firm='ALL') {
 certain<-unique(z$transaction_group_id[z$record_type=='transaction'&z$membership=='within'])
 boundary<-setdiff(unique(z$transaction_group_id[z$record_type=='transaction'&z$membership=='uncertain_boundary']),certain)
 do.call(rbind,lapply(order,function(cat) {
  g<-groups[groups$transaction_group_id%in%certain&groups$group_category==cat,]
  b<-groups[groups$transaction_group_id%in%boundary&groups$group_category==cat,]
  data.frame(scope=scope,row_id=id,firm_id=firm,category=cat,transaction_count=nrow(g),
   D1_count=sum(grepl('D1',g$debt_subtypes,fixed=TRUE)),D2_count=sum(grepl('D2',g$debt_subtypes,fixed=TRUE)),
   D_unspecified_count=sum(grepl('D-unspecified',g$debt_subtypes,fixed=TRUE)),
   boundary_uncertain=nrow(b),group_ids=paste(g$transaction_group_id,collapse=';'),
   boundary_group_ids=paste(b$transaction_group_id,collapse=';'),verification=state(g$verification),
   note=paste(unique(Filter(nzchar,g$note)),collapse='; '))
 }))
}
compact<-do.call(rbind,lapply(seq_len(nrow(map)),function(i)count_rows(er[er$event_id==map$event_id[i],],'event',map$event_id[i],map$firm_id[i])))
for(f in unique(map$firm_id)) compact<-rbind(compact,count_rows(er[er$firm_id==f,],'firm_union',f,f))
new_ids<-map$event_id[!map$pilot_window_exact_match]
compact<-rbind(compact,count_rows(er,'pooled','all_33_events_31_firms'),count_rows(er[er$event_id%in%new_ids,],'pooled','new_27_events_26_firms'))
write(compact,'coding')

# Paid cash enters a category only in the evidenced fiscal year, never from a
# commitment or transfer price. Subtypes are separate cash buckets within D.
buckets<-c('D1','D2','D_unspecified','G','H','E','U')
make_money<-function(f,years,events,row_type,id) {
 years<-sort(unique(years)); stopifnot(length(years)>0L,all(diff(years)==1L))
 fy0<-min(years)-1L;fy1<-max(years)
 opening<-get(f,fy0,'mi');closing<-get(f,fy1,'mi');profit<-strict_sum(vapply(years,function(y)get(f,y,'ni_mi'),numeric(1)))
 cash<-strict_sum(vapply(years,function(y)get(f,y,'capital_from_nci'),numeric(1)));div<-strict_sum(vapply(years,function(y)get(f,y,'dividends_to_nci'),numeric(1)))
 delta<-closing-opening;residual<-delta-profit+div-cash
 ids<-unique(er$transaction_id[er$event_id%in%events&er$record_type=='transaction'&er$membership=='within'])
 tx<-real[real$transaction_id%in%ids&real$paid_period%in%paste0('FY',years)&nzchar(real$paid_contribution_rmb),]
 if(nrow(tx)) stopifnot(!anyDuplicated(paste(tx$transaction_group_id,tx$paid_period,tx$paid_file,tx$paid_page,tx$paid_contribution_rmb)))
 alloc<-setNames(numeric(length(buckets)),buckets)
 for(j in seq_len(nrow(tx))) {
  cat<-tx$group_category[j]
  b<-if(cat=='D')gsub('-','_',tx$debt_subtype[j],fixed=TRUE) else cat
  stopifnot(b%in%buckets);alloc[b]<-alloc[b]+num(tx$paid_contribution_rmb[j])
 }
 na_cash<-if(is.na(cash))NA_real_ else cash-sum(alloc);stopifnot(is.na(na_cash)||na_cash>=-.005)
 local_end<-any(ars$firm_id==f&ars$report==paste0('FY',fy1)&file.exists(file.path('..',ars$file)))
 complete<-all(!is.na(c(opening,closing,profit,cash,div)))
 status<-if(!local_end)'incomplete (closing report missing)' else if(complete)'complete' else 'incomplete (one or more components unavailable or source mismatch)'
 m<-data.frame(row_type=row_type,row_id=id,firm_id=f,n_firms=1L,n_events=length(events),fiscal_years=paste(years,collapse=';'),window_start=paste0(fy0,'-12-31'),window_end=paste0(fy1,'-12-31'),mi_opening=opening,mi_closing=closing,delta_mi=delta,profit_nci=profit,capital_from_nci=cash,dividends_to_nci=div,residual=residual,decomposition_status=status,verification='unverified')
 m$mi_opening_verification<-get_state(f,fy0,'mi');m$mi_closing_verification<-get_state(f,fy1,'mi')
 m$delta_mi_verification<-state(c(m$mi_opening_verification,m$mi_closing_verification))
 m$profit_nci_verification<-get_state(f,years,'ni_mi');m$capital_from_nci_verification<-get_state(f,years,'capital_from_nci');m$dividends_to_nci_verification<-get_state(f,years,'dividends_to_nci')
 m$residual_verification<-state(c(m$delta_mi_verification,m$profit_nci_verification,m$capital_from_nci_verification,m$dividends_to_nci_verification))
 for(b in buckets) {
  m[[paste0('cash_',b)]]<-if(is.na(cash))NA_real_ else alloc[b]
  tt<-tx[if(b%in%c('D1','D2','D_unspecified')) gsub('-','_',tx$debt_subtype,fixed=TRUE)==b&tx$group_category=='D' else tx$group_category==b,]
  m[[paste0('cash_',b,'_verification')]]<-if(!is.na(cash)&&nrow(tt))state(c(vapply(tt$decisive_statement_ids,verified,character(1)),vapply(tt$paid_statement_ids,verified,character(1),kind='numeric'))) else 'unverified'
 }
 m$cash_attributed<-if(is.na(cash))NA_real_ else sum(alloc);m$cash_not_attributed<-na_cash
 # An absent allocation is a coding zero, never a verified zero of financing.
 st<-if(any(alloc!=0))unlist(m[paste0('cash_',buckets[alloc!=0],'_verification')],use.names=FALSE) else character()
 m$cash_attributed_verification<-if(!is.na(cash)&&length(st))state(st) else 'unverified'
 # Capital minus allocation also depends on every category in this firm-window.
 # Unknown U/boundary categories and an empty allocation cannot verify the remainder.
 selected<-unique(er$transaction_group_id[er$event_id%in%events&er$record_type=='transaction'&er$membership%in%c('within','uncertain_boundary')])
 category_states<-groups$verification[groups$transaction_group_id%in%selected]
 m$cash_not_attributed_verification<-state(c(m$capital_from_nci_verification,m$cash_attributed_verification,
  if(length(category_states))category_states else 'unverified'))
 m$verification<-state(unlist(m[grepl('_verification$',names(m))],use.names=FALSE))
 m
}
magnitude<-do.call(rbind,lapply(seq_len(nrow(map)),function(i)make_money(map$firm_id[i],seq.int(map$fy0[i]+1,map$fy1[i]),map$event_id[i],'event',map$event_id[i])))
for(f in unique(map$firm_id)) {
 es<-map[map$firm_id==f,];years<-sort(unique(unlist(lapply(seq_len(nrow(es)),function(i)seq.int(es$fy0[i]+1,es$fy1[i])))))
 magnitude<-rbind(magnitude,make_money(f,years,es$event_id,'firm_union',f))
}
# New-only firm union, needed to pool new events separately without FY duplication.
new_firm_money<-do.call(rbind,lapply(unique(map$firm_id[!map$pilot_window_exact_match]),function(f) {
 es<-map[map$firm_id==f&!map$pilot_window_exact_match,];ys<-sort(unique(unlist(lapply(seq_len(nrow(es)),function(i)seq.int(es$fy0[i]+1,es$fy1[i])))))
 make_money(f,ys,es$event_id,'new_firm_union',f)
}))
magnitude<-rbind(magnitude,new_firm_money)
amounts<-c('mi_opening','mi_closing','delta_mi','profit_nci','capital_from_nci','dividends_to_nci','residual',paste0('cash_',buckets),'cash_attributed','cash_not_attributed')
pool<-function(z,id) {
 r<-z[1,];r$row_type<-'pooled';r$row_id<-id;r$firm_id<-'ALL';r$n_firms<-nrow(z);r$n_events<-sum(z$n_events);r$fiscal_years<-'union within each firm; then strict sum';r$window_start<-'';r$window_end<-''
 for(k in amounts) {r[[k]]<-strict_sum(z[[k]]);r[[paste0(k,'_verification')]]<-state(z[[paste0(k,'_verification')]])}
 r$decomposition_status<-if(all(z$decomposition_status=='complete'))'complete' else 'incomplete (strict pool includes missing firm components)';r$verification<-state(z$verification);r
}
magnitude<-rbind(magnitude,pool(magnitude[magnitude$row_type=='firm_union',],'all_33_events_31_firms'),pool(new_firm_money,'new_27_events_26_firms'))
# Shares use the signed delta; negative/zero deltas are not interpreted as positive shares.
for(k in c('profit_nci','dividends_to_nci','residual',paste0('cash_',buckets),'cash_not_attributed')) {
 magnitude[[paste0(k,'_share_delta_mi')]]<-ifelse(magnitude$delta_mi==0,NA_real_,magnitude[[k]]/magnitude$delta_mi*if(k=='dividends_to_nci')-1 else 1)
 magnitude[[paste0(k,'_share_verification')]]<-vapply(seq_len(nrow(magnitude)),function(i)state(c(magnitude$delta_mi_verification[i],magnitude[[paste0(k,'_verification')]][i])),character(1))
}
magnitude$shares_meaningful<-!is.na(magnitude$delta_mi)&magnitude$delta_mi>0
write(magnitude,'magnitude')
allocation_checks<-do.call(rbind,lapply(seq_len(nrow(magnitude)),function(i) {
 r<-magnitude[i,];keys<-c(paste0('cash_',buckets),'cash_attributed','cash_not_attributed')
 missing_ok<-!is.na(r$capital_from_nci)||all(is.na(unlist(r[keys])))
 empty_ok<-is.na(r$cash_attributed)||r$cash_attributed!=0||
  (r$cash_attributed_verification=='unverified'&&r$cash_not_attributed_verification=='unverified')
 remainder_ok<-r$cash_not_attributed_verification!='verified'||
  (r$capital_from_nci_verification=='verified'&&r$cash_attributed_verification=='verified')
 data.frame(row_type=r$row_type,row_id=r$row_id,missing_capital_allocations_NA=missing_ok,
  empty_allocation_unverified=empty_ok,remainder_requires_verified_operands=remainder_ok,
  pass=missing_ok&&empty_ok&&remainder_ok)
}))
wa(allocation_checks,'allocation_checks');stopifnot(all(allocation_checks$pass))
gap<-magnitude$delta_mi-(magnitude$profit_nci-magnitude$dividends_to_nci+magnitude$capital_from_nci+magnitude$residual)
complete<-magnitude$decomposition_status=='complete';stopifnot(all(abs(gap[complete])<.005))
wa(data.frame(row_type=magnitude$row_type,row_id=magnitude$row_id,complete=complete,gap_rmb=gap),'accounting_checks')
# Partial attribution headline uses exactly the firm-years with observed capital,
# including FY2021 of a firm whose FY2022 is missing. Never a complete-31 total.
fyrows<-unique(ledger[ledger$metric=='capital_from_nci',c('firm_id','year','live_value_rmb','verification')]);headlines<-list()
for(scope in c('all_33_events_31_firms','new_27_events_26_firms')) {
 mm<-if(scope=='all_33_events_31_firms')map else map[!map$pilot_window_exact_match,]
 fykeys<-unique(do.call(rbind,lapply(seq_len(nrow(mm)),function(i)data.frame(firm_id=mm$firm_id[i],year=as.character(seq.int(mm$fy0[i]+1,mm$fy1[i]))))))
 z<-merge(fykeys,fyrows,by=c('firm_id','year'),all.x=TRUE,sort=TRUE);has<-!is.na(z$live_value_rmb)
 evs<-mm$event_id;paidids<-unique(er$transaction_id[er$event_id%in%evs&er$membership=='within'&er$record_type=='transaction'])
 tx<-real[real$transaction_id%in%paidids&nzchar(real$paid_contribution_rmb),]
 attributed<-0
 if(nrow(tx)) {
  tx$year<-sub('FY','',tx$paid_period,fixed=TRUE)
  eligible<-paste(tx$firm_id,tx$year)%in%paste(z$firm_id[has],z$year[has])
  attributed<-sum(num(tx$paid_contribution_rmb[eligible]))
 }
 total<-sum(z$live_value_rmb[has]);unattributed<-total-attributed;stopifnot(unattributed>=-.005)
 headlines[[scope]]<-data.frame(scope=scope,observed_firm_years=sum(has),required_firm_years=nrow(z),observed_firms=length(unique(z$firm_id[has])),missing_firm_years=paste(paste(z$firm_id[!has],z$year[!has],sep=':'),collapse=';'),capital_from_nci_observed_rmb=total,attributed_rmb=attributed,not_attributed_rmb=unattributed,attributed_share=attributed/total,verification='unverified',note='Observed firm-years only; this is not the strict complete-sample capital total. No missing cell set to zero. Transactions are counted through date1, while cash flows extend to fiscal year-end; the attributed share is a lower bound for the fiscal-year window.')
 wa(z,paste0('capital_firm_years_',if(scope=='all_33_events_31_firms')'all' else 'new'))
}
headlines<-do.call(rbind,headlines);rownames(headlines)<-NULL;write(headlines,'attribution_totals')

# Only statements used by the selected transactions or magnitude operands are pending.
used_ids<-unique(c(split_ids(paste(c(coding$decisive_statement_ids,coding$amount_statement_ids,coding$paid_statement_ids),collapse=';')),Filter(nzchar,ledger$statement_id)))
authored<-read(paste0(audit,'appended_statements.csv'))
used_ids<-unique(c(used_ids,authored$statement_id))
revisions<-read(paste0(audit,'statement_revisions.csv'))
stopifnot(!anyDuplicated(revisions$statement_id),all(revisions$superseded_by%in%statements$statement_id),
 all(links$statement_id[links$firm_id%in%revisions$firm_id&links$year=='2021'&links$metric=='ni_mi']%in%revisions$superseded_by))
used_ids<-setdiff(used_ids,revisions$statement_id)
pending<-statements[statements$statement_id%in%used_ids,]
pending$verified<-ifelse(pending$required_level=='meaning',pending$verified_meaning,pending$verified_numeric)
pending<-pending[!pending$verified,];write(pending,'pending_statements')
write(pending[pending$required_level=='strings or meaning',],'pending_numeric')
write(pending[pending$required_level=='meaning',],'pending_qualitative')
# Number -> input file -> filter/formula for every numerical output cell.
number_sources<-list()
for(i in seq_len(nrow(magnitude))) for(k in c(amounts,grep('_share_delta_mi$',names(magnitude),value=TRUE))) {
 r<-magnitude[i,]
 number_sources[[length(number_sources)+1L]]<-data.frame(table='t047_magnitude.csv',row_id=r$row_id,statistic=k,value=r[[k]],input_file=if(r$row_type=='pooled')'t047_magnitude.csv' else 'outputs/audit/T047/component_ledger.csv;pilot_coding.csv;crossers_coding.csv',filter_or_formula=if(r$row_type=='pooled')paste0('row_type=',if(r$row_id=='all_33_events_31_firms')'firm_union' else 'new_firm_union',';strict sum; never sum event money rows') else paste0('firm_id=',r$firm_id,'; fiscal_years=',r$fiscal_years,'; row_id=',r$row_id,'; delta=closing-opening; residual=delta-profit+dividends-capital; paid cash only for distinct selected transaction rows and evidenced FY; shares use signed delta'),verification=r$verification)
}
for(i in seq_len(nrow(compact))) for(k in c('transaction_count','D1_count','D2_count','D_unspecified_count','boundary_uncertain')) {
 r<-compact[i,];number_sources[[length(number_sources)+1L]]<-data.frame(table='t047_coding.csv',row_id=paste(r$row_id,r$category,sep=':'),statistic=k,value=r[[k]],input_file='outputs/audit/T047/event_transactions.csv;transaction_groups.csv',filter_or_formula=paste0('scope=',r$scope,'; row_id=',r$row_id,'; category=',r$category,'; distinct group IDs with within member; boundary-only separate; exclude coverage_gap'),verification=r$verification)
}
for(i in seq_len(nrow(headlines))) for(k in c('observed_firm_years','required_firm_years','observed_firms','capital_from_nci_observed_rmb','attributed_rmb','not_attributed_rmb','attributed_share')) {
 r<-headlines[i,];number_sources[[length(number_sources)+1L]]<-data.frame(table='t047_attribution_totals.csv',row_id=r$scope,statistic=k,value=r[[k]],input_file='outputs/audit/T047/capital_firm_years_all.csv;capital_firm_years_new.csv;pilot_coding.csv;crossers_coding.csv',filter_or_formula='deduplicate firm_id+FY across event windows; observed capital only; allocate paid transaction cash only in same observed FY; subtract from observed capital; excludes missing cells',verification='unverified')
}
wa(do.call(rbind,number_sources),'number_file_filter')
# Inventory is regenerated from the current manifests and file existence, no download.
inventory<-map[c('event_id','firm_id','lookback_start','date1','closing_report_local')]
inventory$announcement_local_in_window<-vapply(seq_len(nrow(map)),function(i)sum(ann$firm_id==map$firm_id[i]&ann$date>=map$lookback_start[i]&ann$date<=map$date1[i]&file.exists(file.path('..',ann$file))),integer(1))
inventory$note<-'Availability only. No local disclosure is not evidence of no transaction.';wa(inventory,'source_inventory')

# English LaTeX, compact firm unions and a separate event appendix. Values are generated.
esc<-function(x)gsub('_','\\_',x,fixed=TRUE)
fmt<-function(x)ifelse(is.na(x),'--',formatC(x/1e6,format='f',digits=1,big.mark=','))
label<-function(x)ifelse(x=='all_33_events_31_firms','All events',ifelse(x=='new_27_events_26_firms','New events',x))
texcoding<-c('\\begingroup\\small','% Generated by code/18_crossers_coding.R; counts of economic transaction groups.', '\\begin{longtable}{lrrrrrrrr}', '\\caption{Local transaction coding for the crossing-event sample}\\\\', '\\hline Firm & D1 & D2 & D? & G & H & E & U & Boundary \\\\ \\hline','\\endhead')
for(f in c(unique(map$firm_id),'all_33_events_31_firms','new_27_events_26_firms')) {
 z<-compact[compact$row_id==f&compact$scope%in%c('firm_union','pooled'),]
 texcoding<-c(texcoding,paste0(esc(label(f)),' & ',paste(c(sum(z$D1_count),sum(z$D2_count),sum(z$D_unspecified_count),z$transaction_count[match(c('G','H','E','U'),z$category)],sum(z$boundary_uncertain)),collapse=' & '),' \\\\'))
}
texcoding<-c(texcoding,'\\hline','\\end{longtable}', '\\par\\footnotesize D? = D-unspecified. Boundary-only candidates and coverage markers are excluded from transaction counts. Pooled counts deduplicate agreement chains across windows. Proposed transactions and historical contract terms are included where disclosed; these are not counts of completed financing. Category verification follows current PI meaning decisions; U and empty-category counts remain unverified. D1 = 1 in each pool refers to 0813.HK historical terms: the buyback undertaking was transferred from the Group to Mr. Hui and lapses on the Shimao Services listing; it is not evidence of an outstanding year-end Group D1 position. The pool is all events in crossers\\_post.csv, including debt-driven crossings; no MI-driven or causal interpretation is imposed.')
texcoding<-c(texcoding,'\\endgroup')
writeLines(texcoding,'outputs/tables/t047_coding.tex',useBytes=TRUE)
texmoney<-c('\\begingroup\\small','% Generated by code/18_crossers_coding.R. RMB million.', '\\begin{longtable}{lrrrrrr}', '\\caption{Annual minority-interest decomposition, union of years per firm (RMB million)}\\\\', '\\hline Firm & $\\Delta MI$ & NCI profit & NCI capital & Dividends & Attributed & Residual \\\\ \\hline','\\endhead')
for(i in which(magnitude$row_type%in%c('firm_union','pooled'))) {
 r<-magnitude[i,];texmoney<-c(texmoney,paste0(esc(label(r$row_id)),' & ',paste(fmt(unlist(r[c('delta_mi','profit_nci','capital_from_nci','dividends_to_nci','cash_attributed','residual')])),collapse=' & '),' \\\\'))
}
texmoney<-c(texmoney,'\\hline','\\end{longtable}','\\par\\footnotesize All amounts are in RMB million. Firm identifies a fiscal-year union; All events and New events are strict sums of those unions. $\\Delta MI$ = closing minus opening consolidated minority interests; NCI profit = annual profit attributable to non-controlling interests (excluding other comprehensive income); NCI capital = cash capital received from non-controlling investors; Dividends = cash dividends paid to them; Attributed = NCI capital matched to evidenced transaction payments and categories; Residual = $\\Delta MI$ - NCI profit + Dividends - NCI capital. Missing cells are --. Allocations are -- whenever NCI capital is unavailable. The strict pooled component is missing if any required firm-year operand is missing. Attributed capital requires transaction-level payment and fiscal-year evidence. Zeros in attributed categories mean no matched allocation, not absence of such financing. Verification labels in the CSV follow current PI decisions; derived values require every operand and category to be verified, and empty allocations remain unverified. Transactions are counted through date1, while cash flows run to fiscal year-end; the attributed share is a lower bound for that fiscal-year window. For the observed firm-year capital headline (a partial-coverage total), see the following table.', '\\par\\footnotesize Observed NCI capital is the sum over available firm-years only; Not attributed = Observed NCI capital - Attributed. Scope distinguishes all events from new events; these partial-coverage totals remain unverified.','\\begin{tabular}{lrrr} Scope & Observed NCI capital & Attributed & Not attributed \\\\ \\hline')
for(i in seq_len(nrow(headlines)))texmoney<-c(texmoney,paste0(esc(label(headlines$scope[i])),' & ',paste(fmt(unlist(headlines[i,c('capital_from_nci_observed_rmb','attributed_rmb','not_attributed_rmb')])),collapse=' & '),' \\\\'))
texmoney<-c(texmoney,'\\end{tabular}','\\endgroup')
writeLines(texmoney,'outputs/tables/t047_magnitude.tex',useBytes=TRUE)
# Three lines per firm, with both event windows and union-year aggregation explicit.
summaries<-character()
for(f in unique(map$firm_id)) {
 e<-map[map$firm_id==f,];c<-compact[compact$scope=='firm_union'&compact$firm_id==f,];m<-magnitude[magnitude$row_type=='firm_union'&magnitude$firm_id==f,]
 summaries<-c(summaries,paste0(f,': ',paste(paste0(e$date0,' to ',e$date1,' (',e$coding_source,')'),collapse='; '),'; in-window groups=',sum(c$transaction_count),'; boundary-only=',sum(c$boundary_uncertain),'; firm coverage U.'),
 paste0('Categories: ',paste(paste0(c$category,'=',c$transaction_count),collapse=', '),'; D1=',sum(c$D1_count),'; D2=',sum(c$D2_count),'; D-unspecified=',sum(c$D_unspecified_count),'.'),
 paste0('Fiscal-year union ',m$fiscal_years,', RMB million: delta MI ',fmt(m$delta_mi),'; NCI profit ',fmt(m$profit_nci),'; NCI capital ',fmt(m$capital_from_nci),'; dividends ',fmt(m$dividends_to_nci),'; attributed ',fmt(m$cash_attributed),'; residual ',fmt(m$residual),'; ',m$decomposition_status,'; ',m$verification,'.'))
}
writeLines(summaries,paste0(audit,'firm_summaries.txt'),useBytes=TRUE)
# Preserve verification row identity while permitting PI metadata updates/additions.
vb<-read(paste0(audit,'rework_verification_baseline.csv'))
stopifnot(!anyDuplicated(verification$statement_id),!anyDuplicated(vb$statement_id))
row_checks<-do.call(rbind,lapply(seq_len(nrow(vb)),function(i) {
 r<-vb[i,];now<-verification[verification$statement_id==r$statement_id,,drop=FALSE]
 changed<-if(nrow(now)==1L)names(r)[vapply(names(r),function(k)now[[k]]!=r[[k]],logical(1))] else names(r)
 allowed<-c('status','level','verified_by','timestamp','comment',grep('^auto_',names(r),value=TRUE))
 txt<-trimws(gsub('\\[[^][]+\\]','',lines[as.integer(r$line)]))
 identity<-nrow(now)==1L&&now$statement==r$statement&&r$statement==txt&&r$statement_id==paste0(r$firm,':L',r$line)
 metadata<-nrow(now)==1L&&all(changed%in%allowed)&&(!length(changed)||now$verified_by=='PI')
 data.frame(statement_id=r$statement_id,statement_preserved=identity,changed_fields=paste(changed,collapse=';'),PI_metadata_only=metadata,pass=identity&&metadata)
}))
wa(row_checks,'verification_row_checks');stopifnot(all(row_checks$pass))
# Verify all protected files; existing note prefixes alone may grow.
baseline<-read(paste0(audit,'revision2_baseline.csv'));integrity<-baseline
overrides<-read(paste0(audit,'rework_integrity_overrides.csv'))
stopifnot(setequal(overrides$file,c('tasks/T047.md','replication/outputs/audit/T047/component_sources_input.csv')),
 !anyDuplicated(overrides$file))
for(i in seq_len(nrow(baseline))) {
 b<-readBin(file.path('..',baseline$file[i]),'raw',n=file.info(file.path('..',baseline$file[i]))$size)
 if(baseline$mode[i]=='prefix')b<-head(b,as.integer(baseline$bytes[i]))
 integrity$current_sha256[i]<-digest::digest(b,algo='sha256',serialize=FALSE)
 integrity$check_mode[i]<-baseline$mode[i]
 if(baseline$file[i]=='replication/data/raw/manual/handcollect/case_notes_verification.csv') {
  integrity$check_mode[i]<-'row identity; PI metadata updates and added rows permitted'
  integrity$pass[i]<-all(row_checks$pass)
 } else if(baseline$file[i]%in%overrides$file) {
  o<-overrides[overrides$file==baseline$file[i],]
  integrity$check_mode[i]<-o$reason
  integrity$pass[i]<-length(b)==as.numeric(o$bytes)&&integrity$current_sha256[i]==o$sha256
 } else integrity$pass[i]<-length(b)==as.numeric(baseline$bytes[i])&&integrity$current_sha256[i]==baseline$sha256[i]
}
wa(integrity,'input_integrity');stopifnot(all(integrity$pass))
nb<-read(paste0(audit,'rework_notes_baseline.csv'))
b<-head(readBin(paste0(raw,'case_notes.md'),'raw',n=file.info(paste0(raw,'case_notes.md'))$size),as.integer(nb$bytes))
stopifnot(length(b)==as.integer(nb$bytes),digest::digest(b,algo='sha256',serialize=FALSE)==nb$sha256)
# The former preflight stop is superseded by the approved Revision 2.
writeLines(c('T047 Revision 2 implemented: all 33 events / 31 firms; 6 exact T044 windows reused; 27 newly coded events / 26 firms (24 previously nonpilot firms plus two nonmatching pilot windows).','Firm-level money pools use union of fiscal years; transaction counts use distinct agreement-chain group IDs.','This is the file-defined crossing-event sample, not a claim that all crossings were MI driven.','Missing closing reports and unmatched panel amounts remain incomplete; no downloads and no replacements.'),paste0(audit,'preflight_summary.txt'),useBytes=TRUE)
cat(sprintf('T047 sample: %d events / %d firms; %d exact T044 windows; %d new events.\n',nrow(map),length(unique(map$firm_id)),sum(map$pilot_window_exact_match),sum(!map$pilot_window_exact_match)))
cat(sprintf('T047 coding: %d new transaction rows; %d coverage markers; rubric and %d PDF excerpt checks PASS.\n',sum(fresh$record_type=='transaction'),sum(fresh$record_type=='coverage_gap'),nrow(evidence_check)))
cat(sprintf('T047 decomposition: %d/33 events and %d/31 firm unions complete; accounting identities PASS (RMB 0.005).\n',sum(complete&magnitude$row_type=='event'),sum(complete&magnitude$row_type=='firm_union')))
for(i in seq_len(nrow(headlines)))cat(sprintf('T047 %s: observed capital RMB %s million; attributed %s; not attributed %s (%d/%d firm-years).\n',headlines$scope[i],fmt(headlines$capital_from_nci_observed_rmb[i]),fmt(headlines$attributed_rmb[i]),fmt(headlines$not_attributed_rmb[i]),headlines$observed_firm_years[i],headlines$required_firm_years[i]))
cat(sprintf('T047 PI pending: %d numeric / %d qualitative; no unverified operand labelled verified.\n',sum(pending$required_level=='strings or meaning'),sum(pending$required_level=='meaning')))
cat(sprintf('T047 protected inputs: %d/%d integrity checks PASS (%d file/prefix SHA-256, %d verification rows); both note prefixes preserved.\n',sum(integrity$pass),nrow(integrity),sum(integrity$check_mode!='row identity; PI metadata updates and added rows permitted'),nrow(row_checks)))
