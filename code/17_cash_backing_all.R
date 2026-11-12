# T046: descriptive cash backing of annual minority-interest growth, 2019--2021.
# Run OFFLINE from replication/: Rscript code/17_cash_backing_all.R
# Base R only. No installation, panel changes, FX assumptions or imputation.
options(digits = 17)
seed <- 20261029L
B <- 999L
RNGkind('Mersenne-Twister', 'Inversion', 'Rejection')
set.seed(seed)
read <- function(p) read.csv(p, stringsAsFactors=FALSE, na.strings=c('', 'NA'), check.names=FALSE)
out <- function(d, name) write.csv(d, paste0('outputs/tables/t046_',name,'.csv'), row.names=FALSE, na='')
inputs <- c('data/processed/panel_firm_halfyear.csv', '../state/handcollect/crossers_post.csv',
 'data/raw/manual/handcollect/nci_cashflow.csv', 'data/raw/manual/handcollect/nci_cashflow_all.csv',
 '../Daten/annual_reports_all/manifest.csv', '../Daten/annual_reports_all/missing.txt',
 'code/provenance/extract_nci_cashflow.py', 'outputs/tables/t046_extraction_sources.csv',
 'outputs/tables/t046_currency_audit.csv')
manifest <- read('../Daten/annual_reports_all/manifest.csv')
inputs <- unique(c(inputs, paste0('../',manifest$file[manifest$report %in% c('FY2020','FY2021')])))
stopifnot(all(file.exists(inputs)))
input_hash <- tools::sha256sum(inputs)
protected <- list.files('outputs', recursive=TRUE, full.names=TRUE, all.files=TRUE)
protected <- protected[!dir.exists(protected) & !startsWith(basename(protected),'t046_')]
protected_hash <- tools::sha256sum(protected)
py <- Sys.which('python3')
stopifnot(nzchar(py), nzchar(Sys.which('pdftotext')))
verification <- system2(py, c('code/provenance/extract_nci_cashflow.py','--verify'), stdout=TRUE)
stopifnot(is.null(attr(verification,'status')))
cat(paste(verification,collapse='\n'),'\n')

d <- read(inputs[1]); d <- d[d$sample_main,]
firms <- sort(unique(d$firm_id)); G <- length(firms)
cash <- read('data/raw/manual/handcollect/nci_cashflow_all.csv')
src <- read('outputs/tables/t046_extraction_sources.csv')
cur <- read('outputs/tables/t046_currency_audit.csv')
cross <- read('../state/handcollect/crossers_post.csv')
crossers <- unique(cross$firm_id)
stopifnot(G==136L,length(crossers)==31L,all(crossers %in% firms),
 !anyDuplicated(d[c('firm_id','date')]), !anyDuplicated(cash[c('firm_id','fiscal_year','metric')]),
 setequal(cash$firm_id,firms), setequal(cash$fiscal_year,2019:2021))

# Recreate the prescribed report choice independently of the extraction helper.
have2020 <- manifest$firm_id[manifest$report=='FY2020']
expected_report <- ifelse(cash$fiscal_year==2021L | (cash$fiscal_year==2020L &
 !cash$firm_id %in% have2020),'FY2021','FY2020')
stopifnot(all(cash$report==expected_report))
cash_key <- paste(cash$firm_id,cash$fiscal_year,cash$metric)
panel_key <- paste(d$firm_id,d$date)
currency_at <- function(id,year) {
 k <- match(paste(id,paste0(year,'-12-31')),panel_key)
 if(is.na(k))return('missing panel row')
 if(d$currency[k]=='RMB')return('RMB')
 z <- cur[cur$firm_id==id & cur$year==year,]
 if(nrow(z) && all(z$resolved_currency=='RMB'))return('RMB')
 'unresolved original reporting currency'
}

rows <- list()
for(id in firms)for(year in 2019:2021) {
 k0 <- match(paste(id,paste0(year-1L,'-12-31')),panel_key)
 k1 <- match(paste(id,paste0(year,'-12-31')),panel_key)
 a <- cash[match(paste(id,year,'capital_from_nci'),cash_key),]
 v <- cash[match(paste(id,year,'dividends_to_nci'),cash_key),]
 mi0 <- d$mi[k0]; mi1 <- d$mi[k1]; profit <- d$ni_mi[k1]
 # A mapped June/March fiscal endpoint is not a December annual flow.
 date0_ok <- !is.na(k0) && !is.na(d$report_date[k0]) && d$report_date[k0]==paste0(year-1L,'-12-31')
 date1_ok <- !is.na(k1) && !is.na(d$report_date[k1]) && d$report_date[k1]==paste0(year,'-12-31')
 delta <- mi1-mi0
 cur0 <- currency_at(id,year-1L); cur1 <- currency_at(id,year)
 currency_ok <- cur0=='RMB' && cur1=='RMB' && !is.na(a$currency) &&
  !is.na(v$currency) && a$currency=='RMB' && v$currency=='RMB'
 components_ok <- all(is.finite(c(mi0,mi1,profit,a$value_rmb,v$value_rmb)))
 positive <- is.finite(delta) && delta>0
 residual <- delta-profit+v$value_rmb-a$value_rmb
 eligible <- positive && components_ok && currency_ok && date0_ok && date1_ok
 reason <- c(if(!positive)if(is.finite(delta))'nonpositive delta MI' else 'missing delta MI',
  if(!components_ok)'missing accounting component', if(!currency_ok)'currency unverified or non-RMB',
  if(!date0_ok || !date1_ok)'non-December or missing fiscal endpoint')
 rows[[length(rows)+1L]] <- data.frame(firm_id=id,market=if(endsWith(id,'.HK'))'HK' else 'A',
  year=year,crosser=id %in% crossers,mi0=mi0,mi1=mi1,delta_mi=delta,profit_nci=profit,
  capital_from_nci=a$value_rmb,dividends_to_nci=v$value_rmb,residual=residual,
  panel_currency0=d$currency[k0],panel_currency1=d$currency[k1],
  resolved_currency0=cur0,resolved_currency1=cur1,capital_currency=a$currency,dividend_currency=v$currency,
  report_date0=d$report_date[k0],report_date1=d$report_date[k1],
  positive_delta=positive,components_complete=components_ok,currency_ok=currency_ok,
  fiscal_endpoints_ok=date0_ok && date1_ok,eligible=eligible,
  capital_at_least_half=if(eligible)a$value_rmb>=.5*delta else NA,
  exclusion_reason=if(eligible)'included' else paste(reason,collapse='; '),
  capital_status=a$status,dividend_status=v$status,capital_report=a$report,dividend_report=v$report,
  capital_file=a$file,capital_page=a$pdf_page,capital_check=a$extraction_check,
  dividend_file=v$file,dividend_page=v$pdf_page,dividend_check=v$extraction_check)
}
fy <- do.call(rbind,rows); stopifnot(nrow(fy)==3L*G)
out(fy,'firm_years')

# Complete report x metric audit, including absent reports and empty cells.
audit <- lapply(split(src[src$metric!='panel_mi_check',],
 paste(src$firm_id[src$metric!='panel_mi_check'],src$report[src$metric!='panel_mi_check'],
 src$metric[src$metric!='panel_mi_check'])),function(z) {
 data.frame(firm_id=z$firm_id[1],market=z$market[1],report=z$report[1],metric=z$metric[1],
  file=z$file[1],report_found=!all(z$status=='report missing'),
  line_found=any(!is.na(z$excerpt)),source_cells=nrow(z),
  values_found=sum(!is.na(z$value_printed)),exact=sum(z$extraction_check=='exact',na.rm=TRUE),
  manual=sum(z$extraction_check=='manual',na.rm=TRUE),
  printed_dashes=sum(z$status=='printed dash'),blank_cells=sum(z$status=='blank cell'),
  line_not_reported=sum(z$status=='not reported'),report_missing=sum(z$status=='report missing'),
  other_unresolved=sum(!z$status %in% c('disclosed','printed dash','blank cell','not reported','report missing')))
})
audit <- do.call(rbind,audit); rownames(audit)<-NULL
stopifnot(nrow(audit)==(80L*3L+56L*2L)*2L,sum(audit$source_cells)==nrow(src[src$metric!='panel_mi_check',]))
out(audit,'extraction_audit')
out(src[src$extraction_check %in% 'manual' & src$metric!='panel_mi_check',],'manual_values')

# Every double-reported FY2020 value, including present/missing disagreements.
s20 <- src[src$fiscal_year==2020 & src$metric!='panel_mi_check',]
old <- s20[s20$report=='FY2020',]; new <- s20[s20$report=='FY2021',]
comp <- merge(old,new,by=c('firm_id','fiscal_year','metric'),suffixes=c('_FY2020','_FY2021'),all=TRUE,sort=TRUE)
comp$difference_rmb <- comp$value_rmb_FY2021-comp$value_rmb_FY2020
eq <- function(a,b) (is.na(a)&is.na(b)) | (!is.na(a)&!is.na(b)&abs(a-b)<.01)
comp$same_numeric <- eq(comp$value_rmb_FY2020,comp$value_rmb_FY2021)
comp$same_status <- comp$status_FY2020==comp$status_FY2021
comp$comparison <- ifelse(!is.na(comp$value_rmb_FY2020)&!is.na(comp$value_rmb_FY2021),
 ifelse(comp$same_numeric,'same numeric value','numeric difference'),
 ifelse(xor(is.na(comp$value_rmb_FY2020),is.na(comp$value_rmb_FY2021)),
 'one numeric value missing','both numeric values missing'))
out(comp,'comparative_2020')

# All 72 pilot records retained: outside-window/interim records are explicit.
pilot <- read('data/raw/manual/handcollect/nci_cashflow.csv')
amount <- function(v,st,unit) {
 v <- gsub(',','',v,fixed=TRUE); v <- sub('^\\((.*)\\)$','-\\1',v)
 x <- suppressWarnings(as.numeric(v)); x[!is.na(st)&st=='printed dash'] <- 0
 x*ifelse(unit=='RMB 1',1,ifelse(unit=='RMB 1,000',1000,NA_real_))
}
pilot$pilot_value_rmb <- amount(pilot$value,pilot$status,pilot$currency_unit)
pilot$pilot_value_rmb[pilot$metric=='dividends_to_nci'] <- abs(pilot$pilot_value_rmb[pilot$metric=='dividends_to_nci'])
pilot$year <- as.integer(substr(pilot$date,1,4))
ix <- match(paste(pilot$firm_id,pilot$year,pilot$metric),cash_key)
pilot$t046_value_rmb <- cash$value_rmb[ix]; pilot$t046_status <- cash$status[ix]
pilot$t046_report <- cash$report[ix]; pilot$t046_file <- cash$file[ix]; pilot$t046_page <- cash$pdf_page[ix]
pilot$difference_rmb <- pilot$t046_value_rmb-pilot$pilot_value_rmb
inside <- substr(pilot$date,6,10)=='12-31' & pilot$year %in% 2019:2021
metric_inside <- pilot$metric %in% c('capital_from_nci','dividends_to_nci','equity_investment_received_total')
pilot$comparison <- ifelse(!inside,'outside T046 annual window',
 ifelse(!metric_inside,'outside T046 metrics',ifelse(is.na(ix),'no T046 firm-year',
 ifelse(eq(pilot$pilot_value_rmb,pilot$t046_value_rmb),
 ifelse(is.na(pilot$pilot_value_rmb),'both missing','same numeric value'),
 ifelse(xor(is.na(pilot$pilot_value_rmb),is.na(pilot$t046_value_rmb)),
 'availability difference','numeric difference')))))
pilot$explanation <- ifelse(pilot$comparison=='availability difference',
 'T046 uses only manifest FY2020/FY2021 reports; pilot sources are cross-check only',
 ifelse(pilot$comparison=='outside T046 metrics','Acquisitions, advances and capital repayments are outside the card metrics',
 ifelse(pilot$comparison=='outside T046 annual window','No substitution from interim or earlier fiscal windows',
 ifelse(pilot$comparison=='numeric difference','Different annual-report vintage; inspect both cited pages',
 'Same signed capital / absolute dividend convention; blanks stay missing'))))
out(pilot,'pilot_crosscheck')

# Firm-cluster bootstrap, shared whole-firm draws for all rows. Ratios of sums;
# missing components exclude the whole firm-year from BOTH ratios of that row.
w <- replicate(B,tabulate(sample.int(G,G,replace=TRUE),nbins=G))
definitions <- list()
add <- function(group,period,keep) definitions[[length(definitions)+1L]] <<- list(group=group,period=period,keep=keep)
for(y in 2019:2021)add('All',as.character(y),fy$year==y)
add('All','2019-2021',rep(TRUE,nrow(fy)))
for(g in c('Crossers','Others')) {
 flag <- if(g=='Crossers')fy$crosser else !fy$crosser
 for(y in 2020:2021)add(g,as.character(y),flag & fy$year==y)
 add(g,'2020-2021',flag & fy$year>=2020)
}
add('All','Pre: 2019',fy$year==2019)
add('All','Post: 2020-2021',fy$year>=2020)
summaries <- draws <- list()
for(j in seq_along(definitions)) {
 z <- definitions[[j]]; candidate <- fy[z$keep,]; use <- candidate[candidate$eligible,]
 fi <- match(use$firm_id,firms)
 delta <- sum(use$delta_mi); capital <- sum(use$capital_from_nci); residual <- sum(use$residual)
 est <- if(delta>0)c(capital,residual)/delta else c(NA_real_,NA_real_)
 boot <- vapply(seq_len(B),function(b) {
  ww <- w[fi,b]; den <- sum(use$delta_mi*ww)
  if(den>0)c(sum(use$capital_from_nci*ww),sum(use$residual*ww))/den else c(NA_real_,NA_real_)
 },numeric(2))
 ci <- t(apply(boot,1,function(x)if(any(is.finite(x)))unname(quantile(x[is.finite(x)],c(.025,.975),type=7)) else c(NA_real_,NA_real_)))
 n <- nrow(use); pos <- candidate$positive_delta
 summaries[[j]] <- data.frame(group=z$group,period=z$period,candidate_firms=length(unique(candidate$firm_id)),
  candidate_firm_years=nrow(candidate),positive_delta_firm_years=sum(pos),n_firms=length(unique(use$firm_id)),
  n_firm_years=n,excluded_positive=sum(pos & !candidate$eligible),
  missing_component_positive=sum(pos & !candidate$components_complete),
  currency_excluded_positive=sum(pos & !candidate$currency_ok),
  fiscal_endpoint_excluded_positive=sum(pos & !candidate$fiscal_endpoints_ok),
  excluded_hk_positive=sum(pos & !candidate$eligible & candidate$market=='HK'),
  delta_mi_rmb=if(n)delta else NA_real_,capital_from_nci_rmb=if(n)capital else NA_real_,
  residual_rmb=if(n)residual else NA_real_,capital_share=est[1],capital_ci_low=ci[1,1],capital_ci_high=ci[1,2],
  residual_share=est[2],residual_ci_low=ci[2,1],residual_ci_high=ci[2,2],
  n_capital_at_least_half=sum(use$capital_at_least_half),
  share_capital_at_least_half=if(n)mean(use$capital_at_least_half) else NA_real_,
  bootstrap_draws=B,valid_capital_draws=sum(is.finite(boot[1,])),valid_residual_draws=sum(is.finite(boot[2,])),
  seed=seed)
 draws[[j]] <- data.frame(group=z$group,period=z$period,draw=seq_len(B),capital_share=boot[1,],residual_share=boot[2,])
}
summary <- do.call(rbind,summaries); out(summary,'cash_backing_all'); out(do.call(rbind,draws),'bootstrap_draws')

# Random PI check list: fixed seed, canonical values including printed zero dashes.
set.seed(seed)
pool <- cash[!is.na(cash$value_printed),]
spot <- pool[sample.int(nrow(pool),20L),]; spot <- cbind(check_order=seq_len(20L),seed=seed,spot)
rownames(spot)<-NULL; out(spot,'pi_spotcheck_20')

fmt <- function(x,digits=3L)ifelse(is.finite(x),formatC(x,format='f',digits=digits),'--')
tex <- c('\\begingroup', '\\small', '\\setlength{\\tabcolsep}{3pt}',
 '\\begin{tabular}{llrrrll}', '\\hline',
 'Group & Year(s) & Firms & Obs. & $\\Delta$MI (bn) & Capital [95\\% CI] & Residual [95\\% CI] \\\\', '\\hline')
for(i in seq_len(nrow(summary))) {
 z<-summary[i,]
 tex<-c(tex,paste0(paste(c(z$group,z$period,z$n_firms,z$n_firm_years,fmt(z$delta_mi_rmb/1e9,2),
  paste0(fmt(z$capital_share),' [',fmt(z$capital_ci_low),', ',fmt(z$capital_ci_high),']'),
  paste0(fmt(z$residual_share),' [',fmt(z$residual_ci_low),', ',fmt(z$residual_ci_high),']')),collapse=' & '),' \\\\'))
}
tex<-c(tex,'\\hline','\\end{tabular}','\\endgroup',
 '% T046. Descriptive only. Ratios of sums over complete firm-years with positive delta MI.',
 '% Residual = delta MI - annual NCI profit + absolute NCI dividends - NCI capital.',
 '% RMB stocks and flows and December fiscal endpoints required; no FX conversion or imputation.',
 '% FY2020 supplies 2019/2020; FY2021 supplies 2021, or 2020 only if FY2020 report is absent.',
 '% Empty/absent cells remain missing; printed dashes are zero. 999 whole-firm draws, seed 20261029; percentile CIs.',
 '% CSVs retain all exclusion counts (overlapping reasons), finite draw counts and the >=50 percent count/share.')
writeLines(tex,'outputs/tables/t046_cash_backing_all.tex',useBytes=TRUE)

# Normalize only PDF metadata dates, preserving byte lengths and xref offsets.
fig <- summary[summary$group %in% c('Crossers','Others') & summary$period %in% as.character(2020:2021),]
grDevices::pdf('outputs/figures/t046_cash_share.pdf',width=7.4,height=4.8,useDingbats=FALSE,
 title='Cash backing of minority-interest growth',author='T046')
par(mar=c(5.4,4.6,3.2,1),mgp=c(2.6,.8,0))
yrange <- range(c(0,fig$capital_ci_low,fig$capital_ci_high,fig$capital_share),finite=TRUE)
plot(NA,xlim=c(2019.75,2021.25),ylim=yrange+ c(-.04,.18)*diff(yrange),xaxt='n',
 xlab='Fiscal year',ylab='NCI capital / change in MI (ratio of sums)',main='Cash backing of minority-interest growth')
axis(1,at=2020:2021); abline(h=c(0,.5,1),col='grey88',lty=c(1,2,2))
for(g in c('Crossers','Others')) {
 z<-fig[fig$group==g,]; x<-as.integer(z$period)+if(g=='Crossers')-.035 else .035
 col<-if(g=='Crossers')'#176B93' else '#D16B35'; pch<-if(g=='Crossers')16 else 17
 lines(x,z$capital_share,col=col,lwd=1.8); points(x,z$capital_share,col=col,pch=pch,cex=1.1)
 arrows(x,z$capital_ci_low,x,z$capital_ci_high,angle=90,code=3,length=.045,col=col,lwd=1.3)
}
legend('topleft',legend=c('Post-policy crossers','Other firms'),col=c('#176B93','#D16B35'),pch=c(16,17),lty=1,bty='n',horiz=TRUE,cex=.85)
mtext('Complete positive-MI-growth firm-years with verified RMB stocks and flows; 95% firm-bootstrap CIs.',side=1,line=4.2,cex=.65)
invisible(dev.off())
stopifnot(system2(py,c('code/provenance/extract_nci_cashflow.py','--normalize-pdf'))==0L)

stopifnot(identical(input_hash,tools::sha256sum(inputs)),identical(protected_hash,tools::sha256sum(protected)))
out(data.frame(kind=c(rep('input',length(inputs)),rep('protected_output',length(protected))),
 path=c(inputs,protected),sha256=c(unname(input_hash),unname(protected_hash)),unchanged=TRUE),'input_output_guards')
cat(sprintf('T046 coverage: %d firms; %d/%d annual reports; %d/%d report-metric lines; %d exact / %d manual source values.\n',
 G,nrow(unique(src[src$status!='report missing',c('firm_id','report')])),2L*G,
 sum(audit$line_found),nrow(audit),sum(audit$exact),sum(audit$manual)))
cat(sprintf('T046 pilot: %d rows; %d same numeric; %d both missing; %d availability differences; %d numeric differences; %d outside window; %d outside metrics.\n',
 nrow(pilot),sum(pilot$comparison=='same numeric value'),sum(pilot$comparison=='both missing'),
 sum(pilot$comparison=='availability difference'),sum(pilot$comparison=='numeric difference'),sum(!inside),sum(inside & !metric_inside)))
for(i in seq_len(nrow(summary))) {
 z<-summary[i,]
 cat(sprintf('T046 %s %s: firms=%d; firm-years=%d/%d positive; capital=%.6f [%.6f, %.6f]; residual=%.6f [%.6f, %.6f]; >=half=%d/%d.\n',
 z$group,z$period,z$n_firms,z$n_firm_years,z$positive_delta_firm_years,z$capital_share,z$capital_ci_low,z$capital_ci_high,
 z$residual_share,z$residual_ci_low,z$residual_ci_high,z$n_capital_at_least_half,z$n_firm_years))
}
cat(sprintf('T046 guards PASS: %d inputs and %d protected outputs byte-identical.\n',length(inputs),length(protected)))
cat(sprintf('T046 complete: %d canonical cash rows; %d firm-years; seed=%d; draws=%d.\n',nrow(cash),nrow(fy),seed,B))
