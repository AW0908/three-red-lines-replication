# T076. Offline; run from replication: Rscript code/25_hk_control.R
# Fixed T074 plan. No specification search, trimming, interpolation or new downloads.
# Historical T076 text integration is explicitly opt-in; never enabled by run_all.
integrate_proposal<-identical(Sys.getenv('MTPA_INTEGRATE_PROPOSAL'),'1')
options(digits=17)
seed <- 20261016L; B <- 999L; set.seed(seed)
suppressPackageStartupMessages(library(data.table))
read <- function(p, ...) read.csv(p, stringsAsFactors=FALSE,
  na.strings=c('', 'NA', '--'), fileEncoding='UTF-8-BOM', ...)
hash <- function(p) unname(tools::sha256sum(p))
files <- function(p) {z<-sort(list.files(p,recursive=TRUE,full.names=TRUE,all.files=TRUE));z[!dir.exists(z)]}
same <- function(p,h) all(file.exists(p)) && identical(hash(p),h)
# Post-build evidence mode: use an already compiled proposal, without estimating
# again. Visual attestation is recorded only when supplied AFTER inspecting the
# rendered pages; SHA-256 ties that attestation to the exact inspected PDF.
# Rscript code/25_hk_control.R --check-build=/path/to/build
#   [--visual-checked-pages=3,4,... --visual-pdf-sha256=...]
args<-commandArgs(TRUE);build_arg<-grep('^--check-build=',args,value=TRUE)
if(length(build_arg)) {
 stopifnot(integrate_proposal)
 stopifnot(length(build_arg)==1L)
 build_dir<-sub('^--check-build=','',build_arg)
 pdf<-file.path(build_dir,'main.pdf');log<-readLines(file.path(build_dir,'main.log'),warn=FALSE)
 txt<-tempfile(fileext='.txt')
 stopifnot(system2('pdftotext',c('-layout',shQuote(pdf),shQuote(txt)))==0L)
 pages<-strsplit(paste(readLines(txt,warn=FALSE),collapse='\n'),'\f',fixed=TRUE)[[1]]
 pages<-pages[nzchar(trimws(pages))]
 footer<-vapply(pages,function(p)tail(trimws(strsplit(p,'\n')[[1]])[nzchar(trimws(strsplit(p,'\n')[[1]]))],1L),character(1))
 heading<-function(pattern)which(vapply(pages,function(p)grepl(pattern,p,perl=TRUE),logical(1)))
 intro<-heading('^\\s*1\\s+Introduction\\s*\n');literature<-heading('^\\s*2\\s+Related Literature\\s*\n')
 refs<-heading('^\\s*References\\s*\n')
 stopifnot(length(intro)==1L,length(literature)==1L,length(refs)==1L)
 number_check<-read('outputs/tables/t076_number_verification.csv')
 repro<-read('outputs/tables/t076_reproducibility.csv')
 guards<-read('outputs/tables/t076_verification.csv')
 check<-data.frame(check=c('compile_errors','main_text_last_page','introduction_first_page',
  'introduction_last_page','references_first_page','overfull_boxes','undefined_references_or_citations',
  'total_pdf_pages','number_audit_verified_rows','byte_identical_staged_files','unchanged_preexisting_outputs'),
  value=c(sum(grepl('^!',log)),footer[refs-1L],footer[intro],footer[literature-1L],footer[refs],
   sum(grepl('Overfull',log)),sum(grepl('LaTeX Warning:.*(Reference|Citation).*undefined|There were undefined',log)),
   length(pages),sum(number_check$source_matches&number_check$printed_present),
   sum(repro$byte_identical),length(unique(guards$file[grepl('^outputs/',guards$file)&guards$unchanged]))),
  pass=c(!any(grepl('^!',log)),footer[refs-1L]=='15',footer[intro]=='1',
   footer[literature-1L]=='1',footer[refs]=='16',!any(grepl('Overfull',log)),
   !any(grepl('LaTeX Warning:.*(Reference|Citation).*undefined|There were undefined',log)),
   TRUE,all(number_check$source_matches&number_check$printed_present),all(repro$byte_identical),all(guards$unchanged)))
 write.csv(check,'outputs/tables/t076_build_checks.csv',row.names=FALSE,eol='\n')
 visual_arg<-grep('^--visual-checked-pages=',args,value=TRUE)
 if(length(visual_arg)) {
  expected<-sub('^--visual-pdf-sha256=','',grep('^--visual-pdf-sha256=',args,value=TRUE))
  stopifnot(length(expected)==1L,identical(hash(pdf),expected),length(visual_arg)==1L)
  pp<-sub('^--visual-checked-pages=','',visual_arg)
  stopifnot(all(as.integer(strsplit(pp,',',fixed=TRUE)[[1]])%in%seq_along(pages)))
  visual<-data.frame(file=c(normalizePath(pdf),'outputs/figures/f_hk_control_density.pdf'),
   sha256=c(hash(pdf),hash('outputs/figures/f_hk_control_density.pdf')),pdf_pages=c(pp,'1'),
   check=c('Rendered pages inspected: text, tables, page transitions; no clipping or overlap',
    'Rendered density figure inspected: common scale, shared legend, legible labels'),pass=TRUE)
  write.csv(visual,'outputs/tables/t076_visual_check.csv',row.names=FALSE,eol='\n')
 }
 print(check,row.names=FALSE);stopifnot(all(check$pass));quit(save='no',status=0L)
}
# Import only pure functions: never source an upstream analysis or modify its outputs.
extract <- function(path,names) {
  expr<-parse(path)
  for(n in names) {
    hit<-vapply(expr,function(e)is.call(e)&&identical(e[[1]],as.name('<-'))&&
      identical(e[[2]],as.name(n)),logical(1))
    stopifnot(sum(hit)==1L);eval(expr[[which(hit)]],envir=.GlobalEnv)
  }
}
extract('code/21_diff_bunching.R',c('nf','period_masks','weights','mass','change','ci'))
extract('code/01_clean.R','nearest_halfyear')
source('code/theme_proposal.R')

allowed_output <- function(p) grepl('^outputs/tables/t076_',p)||p=='outputs/figures/f_hk_control_density.pdf'||
 (!integrate_proposal&&p%in%c('outputs/tables/t082_hk_build_reproducibility.csv','outputs/tables/t082_hk_build_inputs.csv'))
protected<-files('outputs');protected<-protected[!vapply(protected,allowed_output,logical(1))]
protected_hash<-hash(protected)
oldraw<-files('data/raw');oldraw_hash<-hash(oldraw)
immutable_proposal<-if(integrate_proposal)c('../proposal/main.tex','../proposal/preamble.tex',
 '../proposal/sections/01_introduction.tex','../proposal/sections/07_conclusion.tex') else character()
immutable_hash<-hash(immutable_proposal)

# Immutable, byte-for-byte copies. On subsequent runs an existing raw file must
# agree with the PI download; never overwrite a raw file or its manifest.
if(integrate_proposal) {
srcroot<-'../Daten/control/hk';rawroot<-'data/raw/control_hk'
relative<-c('control_hk_roster.csv','control_hk_balance.csv','control_hk_failures.csv',
 'hkex_equities.csv',paste0('raw/',sort(list.files(paste0(srcroot,'/raw'),pattern='[.]csv$'))))
src<-paste0(srcroot,'/',relative);dest<-paste0(rawroot,'/',relative)
stopifnot(all(file.exists(src)),length(relative)>4L)
src_hash<-hash(src)
for(i in seq_along(src)) {
  if(file.exists(dest[i])) stopifnot(identical(hash(dest[i]),src_hash[i])) else {
    dir.create(dirname(dest[i]),recursive=TRUE,showWarnings=FALSE)
    stopifnot(file.copy(src[i],dest[i],overwrite=FALSE))
  }
}
manifest<-data.frame(file=dest,sha256=src_hash,size_bytes=unname(file.info(src)$size))
manifest_path<-paste0(rawroot,'/MANIFEST.csv')
if(file.exists(manifest_path)) stopifnot(isTRUE(all.equal(read(manifest_path),manifest,check.attributes=FALSE))) else
  write.csv(manifest,manifest_path,row.names=FALSE,na='NA',eol='\n')
stopifnot(identical(hash(dest),manifest$sha256),all(file.info(dest)$size==manifest$size_bytes))
} else {
 # Read and authenticate the local immutable copy. No raw writes in build mode.
 rawroot<-'data/raw/control_hk';manifest_path<-paste0(rawroot,'/MANIFEST.csv')
 stopifnot(file.exists(manifest_path))
 manifest<-read(manifest_path)
 stopifnot(!anyDuplicated(manifest$file),nrow(manifest)>4L,
  all(startsWith(manifest$file,paste0(rawroot,'/'))),
  !any(grepl('(^|/)\\.\\.(/|$)',manifest$file)))
 dest<-as.character(manifest$file)
 relative<-substring(dest,nchar(rawroot)+2L)
 # The historical PI directory is only a read fallback for a missing local file.
 src<-ifelse(file.exists(dest),dest,paste0('../Daten/control/hk/',relative))
 stopifnot(all(file.exists(src)),identical(hash(src),manifest$sha256),
  all(file.info(src)$size==manifest$size_bytes))
 # Subsequent reads use the validated local root. A partial local copy cannot be
 # silently mixed with another vintage; the manifest still authenticates all files.
 raw_path<-function(relative)src[match(relative,substring(dest,nchar(rawroot)+2L))]
 message('Build mode: HK MANIFEST verified; historical proposal integration disabled.')
}
inputs<-c(src,dest[file.exists(dest)],manifest_path,'code/25_hk_control.R','code/21_diff_bunching.R',
 'code/22_referee5.R','code/01_clean.R','code/theme_proposal.R',
 'data/processed/panel_firm_halfyear.csv','outputs/tables/t061_control_panel.csv',
 'outputs/tables/t061_estimates.csv','outputs/tables/t061_diff_bunching.csv',
 'outputs/tables/t063_density_bins.csv')
input_hash<-hash(inputs)
staged<-list()
stage<-function(f,target) {
  if(!integrate_proposal&&startsWith(target,'../proposal/'))return(invisible(NULL))
  stopifnot(allowed_output(target)||target%in%c('../proposal/tables/t076_hk_control.tex',
   '../proposal/tables/t076_hk_roster_summary.tex','../proposal/figures/f_hk_control_density.pdf',
   '../proposal/tables/t051_robustness.tex','../proposal/sections/05_context_data.tex',
   '../proposal/sections/06_preliminary_analysis.tex','../proposal/appendix/results.tex',
   '../proposal/tables/t049_threats.tex','../proposal/tables/t061_results.tex',
   '../proposal/sections/02_literature.tex'))
  staged[[length(staged)+1L]]<<-c(path=f,target=target)
}
csv<-function(z,name) {f<-tempfile(fileext='.csv');write.csv(z,f,row.names=FALSE,na='NA',eol='\n')
 stage(f,paste0('outputs/tables/t076_',name,'.csv'))}
textout<-function(z,target) {f<-tempfile(fileext='.tex');writeLines(z,f,useBytes=TRUE);stage(f,target)}

r<-read(if(integrate_proposal)paste0(rawroot,'/control_hk_roster.csv') else raw_path('control_hk_roster.csv'),colClasses=c(code='character'))
hke<-read(if(integrate_proposal)paste0(rawroot,'/hkex_equities.csv') else raw_path('hkex_equities.csv'),colClasses=c(code='character'))
eligible<-r$exclusion_flag=='false'
stopifnot(!anyDuplicated(r$code),all(r$exclusion_flag%in%c('true','false')),
 setequal(r$code,hke$code),all(grepl('^[0-9]{5}$',r$code)),all(as.integer(r$code)<10000),
 all(r$metadata_status=='complete'),all(r$reason[eligible]=='eligible_non_developer'))
c<-read(if(integrate_proposal)paste0(rawroot,'/control_hk_balance.csv') else raw_path('control_hk_balance.csv'),colClasses=c(code='character'))
failure<-read(if(integrate_proposal)paste0(rawroot,'/control_hk_failures.csv') else raw_path('control_hk_failures.csv'),colClasses=c(code='character'))
stopifnot(all(c$code%in%r$code[eligible]),!anyDuplicated(c[c('code','REPORT_DATE')]))
c$date<-as.Date(nearest_halfyear(c$REPORT_DATE));c$firm_id<-sprintf('%04d.HK',as.integer(c$code))
dates<-as.Date(c('2016-12-31',as.vector(rbind(paste0(2017:2022,'-06-30'),paste0(2017:2022,'-12-31')))))
outside_dates<-sum(!c$date%in%dates);c<-c[c$date%in%dates,]
stopifnot(!anyDuplicated(c[c('firm_id','date')]))
c<-c[order(c$firm_id,c$date),];rownames(c)<-NULL
# Exact T061 rule: sum available components; if both absent, advance=0 and flag.
parts<-as.matrix(c[c('ADVANCE_RECEIVABLES','CONTRACT_LIAB')])
c$adv_n_components<-rowSums(!is.na(parts));c$adv_missing<-c$adv_n_components==0L
c$adv<-rowSums(parts,na.rm=TRUE);c$denominator<-c$TOTAL_ASSETS-c$adv
c$rl1<-ifelse(!is.na(c$denominator)&c$denominator>0,
 (c$TOTAL_LIABILITIES-c$adv)/c$denominator,NA_real_)
ids<-sort(unique(c$firm_id))
balanced<-ids[vapply(ids,function(f)sum(c$firm_id==f&is.finite(c$rl1))==13L,logical(1))]
ch<-c[c$firm_id%in%balanced,]
stopifnot(length(balanced)>0L,all(table(ch$firm_id)==13L))
csv(c,'hk_panel')
firm_audit<-data.frame(code=r$code,eligible=eligible,reason=r$reason,
 any_balance=r$code%in%c$code,balanced_13=sprintf('%04d.HK',as.integer(r$code))%in%balanced)
csv(firm_audit,'hk_membership')

# Rework 1(a): retain the original balanced controls only if an advance item is
# reported at EVERY endpoint. A reported zero qualifies; an absent item does not.
noimp_ids<-balanced[vapply(balanced,function(f)all(!ch$adv_missing[ch$firm_id==f]),logical(1))]
ch_noimp<-ch[ch$firm_id%in%noimp_ids,]
stopifnot(length(noimp_ids)>0L,all(table(ch_noimp$firm_id)==13L),!any(ch_noimp$adv_missing))
# Rework 1(b): change only the ratio, keeping the primary balanced-control firms.
ch_unadjusted<-ch
ch_unadjusted$rl1<-ifelse(ch_unadjusted$TOTAL_ASSETS>0,
 ch_unadjusted$TOTAL_LIABILITIES/ch_unadjusted$TOTAL_ASSETS,NA_real_)
stopifnot(all(is.finite(ch_unadjusted$rl1)))

# Check every wide balance value against the immutable long file, using only the
# named annual/interim items. Invalid raw files absent from the wide file stay
# excluded as download failures, rather than repaired or selectively salvaged.
item_map<-c('总资产'='TOTAL_ASSETS','总负债'='TOTAL_LIABILITIES',
 '预收款项'='ADVANCE_RECEIVABLES','合同负债'='CONTRACT_LIAB')
checked<-0L
for(code in sort(unique(c$code))) {
  z<-fread(if(integrate_proposal)paste0(rawroot,'/raw/',code,'.csv') else raw_path(paste0('raw/',code,'.csv')),colClasses=list(character=c('SECURITY_CODE','SECUCODE')),
           na.strings=c('','NA','--'),showProgress=FALSE)
  stopifnot(all(as.integer(z$SECURITY_CODE)==as.integer(code)))
  z<-z[as.integer(DATE_TYPE_CODE)%in%c(1L,2L)]
  z[,REPORT_DATE:=substr(as.character(REPORT_DATE),1L,10L)]
  z[,date:=as.Date(nearest_halfyear(REPORT_DATE))]
  z<-z[date%in%dates]
  stopifnot(!any(z[,.(n=uniqueN(REPORT_DATE)),by=date]$n>1L))
  w<-c[c$code==code,]
  stopifnot(setequal(z$REPORT_DATE,w$REPORT_DATE))
  for(item in names(item_map)) {
    q<-unique(z[STD_ITEM_NAME==item,.(REPORT_DATE,AMOUNT)])
    stopifnot(!anyDuplicated(q$REPORT_DATE))
    actual<-q$AMOUNT[match(w$REPORT_DATE,q$REPORT_DATE)];expected<-w[[item_map[[item]]]]
    stopifnot(identical(is.na(actual),is.na(expected)),all(actual[!is.na(actual)]==expected[!is.na(expected)]))
    checked<-checked+nrow(w)
  }
}

summary<-list()
summ<-function(section,metric,count,definition) {
 summary[[length(summary)+1L]]<<-data.frame(section=section,metric=metric,count=count,definition=definition)
}
summ('roster','roster_firms',nrow(r),'Official HKEX Main Board and GEM equity roster, codes below 10000')
summ('roster','eligible_firms',sum(eligible),'No exclusion reason; industry metadata complete')
summ('roster','excluded_firms',sum(!eligible),'Unique excluded firms; reason categories may overlap')
for(reason in sort(unique(r$reason[!eligible]))) summ('exclusive_reason',reason,sum(r$reason==reason),'Mutually exclusive full reason string')
for(reason in sort(unique(unlist(strsplit(r$reason[!eligible],';',fixed=TRUE)))))
 summ('overlapping_reason',reason,sum(vapply(strsplit(r$reason,';',fixed=TRUE),function(x)reason%in%x,logical(1))),
 'Individual exclusion tag; counts overlap')
summ('coverage','raw_files',length(relative)-4L,'One immutable raw long file per eligible firm')
summ('coverage','firms_any_balance',nf(c$code),'At least one saved wide balance row on the analysis date set')
summ('coverage','eligible_without_balance',sum(eligible)-nf(c$code),'Includes no in-window reports and validation failures')
summ('coverage','balance_rows',nrow(c),'Wide report rows mapping to the 13 analysis endpoints')
summ('coverage','mapped_rows_outside',outside_dates,'Dropped after exact developer date mapping')
summ('coverage','firms_balanced_13',length(balanced),'Finite RL1 at every one of the 13 endpoints')
summ('coverage','firms_any_balance_not_balanced',nf(c$code)-length(balanced),'At least one missing endpoint or nonfinite RL1')
summ('coverage','both_advance_items_missing',sum(ch$adv_missing),'Balanced control firm-dates with zero imputation for both missing items')
summ('validation','wide_values_checked',checked,'Wide values checked against raw long statements, including missingness')
for(s in sort(unique(failure$stage))) {
 summ('failure_events',s,sum(failure$stage==s),'Historical ledger events, including repeated attempts and resolved stages')
 summ('failure_firms',s,nf(failure$code[failure$stage==s&failure$code!='__roster__']),
 'Distinct firm codes at this stage; __roster__ event is not a firm')
}
summary<-do.call(rbind,summary);csv(summary,'hk_roster_summary')

all_panel<-read('data/processed/panel_firm_halfyear.csv')
d<-all_panel[!is.na(all_panel$sample_main)&all_panel$sample_main,]
d$date<-as.Date(d$date);d<-d[order(d$firm_id,d$date),]
stopifnot(!anyDuplicated(d[c('firm_id','date')]),setequal(dates,d$date),
 !any(ch$firm_id%in%all_panel$firm_id),!any(r$code[eligible]%in%
 sprintf('%05d',as.integer(sub('[!.].*','',all_panel$firm_id[all_panel$market=='HK'])))))
ca<-read('outputs/tables/t061_control_panel.csv',colClasses=c(code='character'))
ca$date<-as.Date(ca$date);ca<-ca[ca$date%in%dates,];ca<-ca[order(ca$firm_id,ca$date),]
stopifnot(!anyDuplicated(ca[c('firm_id','date')]),all(table(ca$firm_id)==13L),all(is.finite(ca$rl1)))
dev_balanced<-sort(unique(d$firm_id))[vapply(sort(unique(d$firm_id)),function(f)
 sum(d$firm_id==f&is.finite(d$rl1))==13L,logical(1))]
# Preserve T061/T063 draw order through developers_HK, then draw the new HK
# stratum independently. Within a stratum the SAME firm weights pair pre/post.
pop<-list(developers_all=d,control_A=ca,developers_balanced=d[d$firm_id%in%dev_balanced,],
 developers_A=d[d$market=='A',],developers_HK=d[d$market=='HK',],control_HK=ch)
W<-lapply(pop,function(z)weights(sort(unique(z$firm_id))))
est<-lapply(names(pop),function(g)change(pop[[g]],W[[g]]));names(est)<-names(pop)
ref<-read('outputs/tables/t061_diff_bunching.csv')
refA<-ref[ref$comparison=='developers_A_minus_control_A_Sina',]
contrastA<-est$developers_A$delta-est$control_A$delta
stopifnot(nrow(refA)==1L,abs(contrastA[1]-refA$delta_delta_b)<1e-10,
 abs(ci(contrastA[-1])$ci_low-refA$ci_low)<1e-10,
 abs(ci(contrastA[-1])$ci_high-refA$ci_high)<1e-10)
# HK developers are the unchanged main sample, as in T063 (not balanced anew).
refbins<-read('outputs/tables/t063_density_bins.csv')
for(p in c('pre','post')) {
 q<-refbins[refbins$key=='window|developers_HK|none|0.74|0.7'&refbins$period==p,]
 stopifnot(nrow(q)==60L,max(abs(q$observed-est$developers_HK[[p]]$observed))<1e-10)
}
contrastHK<-est$developers_HK$delta-est$control_HK$delta
shareA<-nf(pop$developers_A$firm_id)/nf(d$firm_id);shareHK<-1-shareA
matched<-shareA*contrastA+shareHK*contrastHK
# Append the authorized sensitivity stratum AFTER all original draws, preserving
# every primary/secondary draw. The unadjusted ratio uses the original control
# weights (same firms); the developer side is unchanged in both joint bootstraps.
pop$control_HK_no_imputation<-ch_noimp
pop$control_HK_unadjusted<-ch_unadjusted
W$control_HK_no_imputation<-weights(sort(unique(ch_noimp$firm_id)))
W$control_HK_unadjusted<-W$control_HK
for(g in c('control_HK_no_imputation','control_HK_unadjusted')) est[[g]]<-change(pop[[g]],W[[g]])
contrast_noimp<-est$developers_HK$delta-est$control_HK_no_imputation$delta
contrast_unadjusted<-est$developers_HK$delta-est$control_HK_unadjusted$delta
rows<-draws<-list()
record<-function(metric,v,priority,pre=NA_real_,post=NA_real_) {
 st<-ci(v[-1]);rows[[length(rows)+1L]]<<-data.frame(metric=metric,priority=priority,
 b_pre=pre,b_post=post,estimate=v[1],as.data.frame(st),B=B,seed=seed,
 inference_status=if(st$valid<.9*B)'unreliable_below_90pct_valid' else if(st$valid<B)'conditional_on_valid_draws' else 'all_draws_valid',
 weight_A=if(metric=='market_matched_delta_delta_b')shareA else NA_real_,
 weight_HK=if(metric=='market_matched_delta_delta_b')shareHK else NA_real_)
 draws[[length(draws)+1L]]<<-data.frame(metric=metric,draw=seq_len(B),estimate=v[-1])
}
record('control_HK_delta_b',est$control_HK$delta,'control',est$control_HK$pre$v[1],est$control_HK$post$v[1])
record('developers_HK_delta_b',est$developers_HK$delta,'support',est$developers_HK$pre$v[1],est$developers_HK$post$v[1])
record('HK_delta_delta_b',contrastHK,'PRIMARY')
record('A_delta_delta_b',contrastA,'existing_within_market')
record('market_matched_delta_delta_b',matched,'secondary')
record('HK_delta_delta_b_no_imputation',contrast_noimp,'rework_robustness')
record('HK_delta_delta_b_unadjusted_control',contrast_unadjusted,'rework_robustness')
results<-do.call(rbind,rows);csv(do.call(rbind,draws),'bootstrap_draws')
support_groups<-c('developers_A','control_A','developers_HK','control_HK',
 'control_HK_no_imputation','control_HK_unadjusted')
support<-do.call(rbind,lapply(support_groups,function(g)
 do.call(rbind,lapply(c('pre','post'),function(p) {
 z<-est[[g]][[p]];control<-grepl('^control',g)
 data.frame(group=g,period=p,firms=z$firms,firm_halfyears=z$n,window_firms=z$window_firms,
 window_firm_halfyears=z$window_obs,fit_range_obs=z$range_n,outside_range_obs=z$outside_n,
 missing_rl1=z$missing,minimum_firms=if(control)150L else NA_integer_,minimum_window_obs=20L,
 low_support=(control&&z$firms<150L)||z$window_obs<20L)
 }))))
csv(support,'hk_support')
bad<-function(g)any(support$low_support[support$group==g])
results$control_low_support<-c(bad('control_HK'),FALSE,bad('control_HK'),bad('control_A'),
 bad('control_A')||bad('control_HK'),bad('control_HK_no_imputation'),bad('control_HK_unadjusted'))
results$developer_low_support<-c(FALSE,bad('developers_HK'),bad('developers_HK'),bad('developers_A'),
 bad('developers_A')||bad('developers_HK'),bad('developers_HK'),bad('developers_HK'))
results$low_support<-results$control_low_support|results$developer_low_support
csv(results,'hk_control')
bins<-do.call(rbind,lapply(c('pre','post'),function(p) {
 z<-est$control_HK[[p]]
 data.frame(group='control_HK',period=p,mid=z$mid,observed_count=z$observed,
 fitted_counterfactual=z$fitted,excluded=z$excluded,mass_window=z$mass_window,
 denominator=z$n,share=z$observed/z$n,fitshare=z$fitted/z$n)
}));csv(bins,'density_bins')
csv(data.frame(parameter=c('seed','B','bin_width','degree','fit_lower','fit_upper',
 'window_lower','window_upper','pre_first','pre_last','post_first','post_last',
 'endpoints','minimum_control_firms','minimum_window_obs','ci_level','weight_A','weight_HK'),
 value=c(seed,B,.01,5,.4,1,.66,.7,'2017H1','2019H2','2020H2','2022H2',13,150,20,95,shareA,shareHK)),
 'specification')

# Independent point reconstruction with hist/lm/predict, without bootstrap code.
validation<-do.call(rbind,lapply(support_groups,function(g)
 do.call(rbind,lapply(c('pre','post'),function(p) {
 z<-pop[[g]];x<-z$rl1[period_masks(z)[[p]]];x<-x[is.finite(x)&x>=.4&x<=1]
 edges<-round(seq(.4,1,.01),10);mid<-(head(edges,-1)+tail(edges,-1))/2
 h<-hist(x,breaks=edges,right=FALSE,include.lowest=TRUE,plot=FALSE)$counts
 q<-data.frame(mid=mid,count=h);mw<-mid>=.66&mid<.70
 pred<-predict(lm(count~poly(mid,5),data=q[!mw,]),newdata=q)
 b<-(sum(h[mw])-sum(pred[mw]))/mean(pred[mw]);expected<-est[[g]][[p]]$v[1]
 data.frame(group=g,period=p,independent_b=b,estimator_b=expected,error=abs(b-expected))
 }))))
stopifnot(max(validation$error)<1e-10);csv(validation,'validation')

# Two panels, common scale and shared legend in the T072 theme.
# theme_proposal.R records basename(path) as the title: keep it stable, too.
f<-file.path(tempdir(),'f_hk_control_density.pdf');proposal_pdf(f,width=6.5,height=3.6,size=12)
layout(rbind(1:2,c(3,3)),heights=c(1,.14));ylim<-range(c(0,bins$share,bins$fitshare))*c(1,1.08)
for(p in c('pre','post')) {
 par(cex=1,mar=c(3.2,4.4,1.4,.6),mgp=c(2.6,.65,0))
 z<-bins[bins$period==p,]
 plot(NA,xlim=c(.4,1),ylim=ylim,xlab='',ylab='Share of firm-half-years')
 mtext('Reported RL1',side=1,line=1.7);proposal_window();proposal_threshold()
 proposal_panel_label(if(p=='pre')'2017H1-2019H2' else '2020H2-2022H2')
 rect(z$mid-.005,0,z$mid+.005,z$share,col=proposal_col['grey'],border='white')
 lines(z$mid,z$fitshare,col=proposal_col['grey'],lty=3,lwd=1.4)
 proposal_threshold()
}
par(mar=rep(0,4));plot.new()
legend(.5,.5,legend=c('Observed','Fit'),col=proposal_col[c('grey','grey')],lty=c(NA,3),
 pch=c(15,NA),ncol=2,bty='n',xjust=.5,yjust=.5,cex=1,seg.len=1.4,x.intersp=.55)
invisible(dev.off());stage(f,'outputs/figures/f_hk_control_density.pdf')
stage(f,'../proposal/figures/f_hk_control_density.pdf')

# Every newly printed number is rendered from a saved table and recorded here.
# Row selectors in source_row are exact metric/parameter/group-period keys.
audit<-list()
num<-function(value,source,row,column,target,location,digits=2L,printed=NULL) {
 if(is.null(printed)) printed<-ifelse(is.finite(value),sprintf(paste0('%.',digits,'f'),value),'--')
 audit[[length(audit)+1L]]<<-data.frame(target=target,location=location,
  source_file=paste0('replication/outputs/tables/',source,'.csv'),source_row=row,
  source_column=column,value=as.character(value),printed=printed)
 printed
}
spec<-function(parameter,printed,target,location) {
 values<-list(seed=seed,B=B,bin_width=.01,degree=5,fit_lower=.4,fit_upper=1,
  window_lower=.66,window_upper=.70,pre_first='2017H1',pre_last='2019H2',
  post_first='2020H2',post_last='2022H2',endpoints=13,minimum_control_firms=150,
  minimum_window_obs=20,ci_level=95,weight_A=shareA,weight_HK=shareHK)
 num(values[[parameter]],'t076_specification',parameter,'value',target,location,printed=printed)
}
rn<-function(metric,column,target,location,digits=2L) {
 z<-results[results$metric==metric,];stopifnot(nrow(z)==1L)
 num(z[[column]],'t076_hk_control',metric,column,target,location,digits)
}
# Standalone negative values need math minus signs; CI endpoints already occur
# inside a shared math environment. Keep the audit's printed token unwrapped.
mathminus<-function(x)ifelse(grepl('^-[0-9]',x),paste0('$',x,'$'),x)
sn<-function(metric,target,location) {
 z<-summary[summary$metric==metric&summary$section%in%c('roster','coverage'),]
 stopifnot(nrow(z)==1L);num(z$count,'t076_hk_roster_summary',paste(z$section,metric,sep='|'),
 'count',target,location,0L)
}
sup<-function(group,period,column,target,location) {
 z<-support[support$group==group&support$period==period,];stopifnot(nrow(z)==1L)
 num(z[[column]],'t076_hk_support',paste(group,period,sep='|'),column,target,location,0L)
}
rowtex<-function(x)paste0(paste(x,collapse=' & '),' \\\\')
source_comment<-'% source: replication/outputs/tables/t076_hk_control.csv; t076_hk_support.csv; t076_hk_roster_summary.csv; t076_specification.csv (exact cells in t076_number_audit.csv)'
target<-'proposal/tables/t076_hk_control.tex'
labels<-c('HK control: $\\Delta b$','HK developers: $\\Delta b$',
 'HK within-market: $\\Delta\\Delta b$','A within-market: $\\Delta\\Delta b$',
 'Market-matched: $\\Delta\\Delta b$',
 'HK: reported advances at all dates','HK: unadjusted control ratio')
tabrows<-vapply(seq_len(nrow(results)),function(i) {
 m<-results$metric[i];loc<-paste0('estimate row ',m)
 rowtex(c(labels[i],mathminus(rn(m,'b_pre',target,loc)),mathminus(rn(m,'b_post',target,loc)),
  mathminus(rn(m,'estimate',target,loc)),paste0('$[',rn(m,'ci_low',target,loc),', ',
  rn(m,'ci_high',target,loc),']$'),rn(m,'valid',target,loc,0L)))
},character(1))
table_lines<-c(source_comment,'\\begingroup\\apptablefont',
 '\\begin{appstar}{P{0.27\\linewidth}rrrrr}\\toprule',
 rowtex(c('Group / comparison','Pre','Post','Change',
  paste0(spec('ci_level','95',target,'CI header'),'\\% CI'),'Valid draws')),
 '\\midrule',tabrows,'\\bottomrule\\end{appstar}','\\par\\medskip',
 '\\begin{appstar}{P{0.30\\linewidth}rrrrr}\\toprule',
 rowtex(c('Support','Firms','Obs. pre','Obs. post','Window pre','Window post')),'\\midrule')
for(g in support_groups) {
 loc<-paste0('support row ',g)
 firms<-paste0(sup(g,'pre','firms',target,loc),'/',sup(g,'post','firms',target,loc))
 table_lines<-c(table_lines,rowtex(c(switch(g,developers_A='A developers',control_A='A controls',
  developers_HK='HK developers',control_HK='HK controls',
  control_HK_no_imputation='HK controls: reported advances',
  control_HK_unadjusted='HK controls: unadjusted ratio'),firms,
  sup(g,'pre','firm_halfyears',target,loc),sup(g,'post','firm_halfyears',target,loc),
  sup(g,'pre','window_firm_halfyears',target,loc),sup(g,'post','window_firm_halfyears',target,loc))))
}
table_lines<-c(table_lines,'\\bottomrule\\end{appstar}',
 paste0('\\floatnote{Pre: ',spec('pre_first','2017H1',target,'note'),'--',spec('pre_last','2019H2',target,'note'),
 '; post: ',spec('post_first','2020H2',target,'note'),'--',spec('post_last','2022H2',target,'note'),
 '. Degree ',spec('degree','5',target,'note'),' polynomial on ',
 '$[',spec('fit_lower','0.40',target,'note'),',',spec('fit_upper','1.00',target,'note'),
 ']$, bin width ',spec('bin_width','0.01',target,'note'),'; fit excludes the mass window ',
 '$[',spec('window_lower','0.66',target,'note'),',',spec('window_upper','0.70',target,'note'),
 ')$. ',spec('B','999',target,'note'),' whole-firm draws (seed ',spec('seed','20261016',target,'note'),
 '), paired across periods and independent across groups; pointwise percentile intervals. ',
 'HK within-market is the primary new contrast. Market-matched is the developer-share-weighted mean ',
 'of the A and HK contrasts, with fixed weights ',
 num(shareA,'t076_specification','weight_A','value',target,'weight',4L),' and ',
 num(shareHK,'t076_specification','weight_HK','value',target,'weight',4L),
 '. The last two estimates are HK developer minus control changes: controls either report an advance item at every endpoint, or use TL/TA on the primary control sample. Developer samples are unchanged; controls are balanced survivors. A low-support flag applies below ',
 spec('minimum_control_firms','150',target,'note'),' control firms or ',
 spec('minimum_window_obs','20',target,'note'),' window observations in either period; ',
 'Primary HK controls pass; the reported-advance subset has only ',
 sup('control_HK_no_imputation','pre','firms',target,'note'),' firms. HK developers have only ',sup('developers_HK','pre','window_firm_halfyears',target,'note'),
 ' pre-window observations. Pre/post levels refer to the named group; contrast levels are not defined. ',
 'Smooth counterfactual densities and comparable counterfactual changes are assumptions; ',
 'developer-specific shocks and survivor selection remain.}'),'\\endgroup')
textout(table_lines,'outputs/tables/t076_hk_control.tex')
textout(table_lines,paste0('../',target))

# Roster summary at full text width, with overlapping tags explicitly separated.
target<-'proposal/tables/t076_hk_roster_summary.tex'
roster_lines<-c(source_comment,'\\begingroup\\apptablefont',
 '\\begin{appstar}{P{0.73\\linewidth}r}\\toprule',rowtex(c('Roster and coverage','Firms / rows')),'\\midrule')
metrics<-c(roster_firms='HKEX equity roster',eligible_firms='Eligible non-developers',
 excluded_firms='Excluded (unique firms)',firms_any_balance='Firms with any balance row',
 eligible_without_balance='Eligible firms without a balance row',firms_balanced_13='Balanced finite-RL1 controls',
 firms_any_balance_not_balanced='With balance rows, failing balanced coverage',balance_rows='Saved balance rows')
for(m in names(metrics)) roster_lines<-c(roster_lines,rowtex(c(metrics[[m]],sn(m,target,m))))
roster_lines<-c(roster_lines,'\\midrule','\\multicolumn{2}{l}{Exclusion tags (overlapping firm counts)} \\\\')
for(m in c('developer_panel_or_roster','real_estate_or_property_services','financial','a_plus_h_dual_listing')) {
 z<-summary[summary$section=='overlapping_reason'&summary$metric==m,]
 label<-switch(m,developer_panel_or_roster='Developer panel / roster',
  real_estate_or_property_services='Real estate / property services',financial='Financials',
  a_plus_h_dual_listing='A+H dual listings')
 roster_lines<-c(roster_lines,rowtex(c(label,num(z$count,'t076_hk_roster_summary',
  paste('overlapping_reason',m,sep='|'),'count',target,m,0L))))
}
roster_lines<-c(roster_lines,'\\midrule',rowtex(c('Failure ledger stage','Events (firms)')))
for(s in sort(unique(failure$stage))) {
 vals<-vapply(c('failure_events','failure_firms'),function(k) {
  z<-summary[summary$section==k&summary$metric==s,]
  num(z$count,'t076_hk_roster_summary',paste(k,s,sep='|'),'count',target,s,0L)
 },character(1))
 roster_lines<-c(roster_lines,rowtex(c(gsub('_','\\_',s,fixed=TRUE),paste0(vals[1],' (',vals[2],')'))))
}
roster_lines<-c(roster_lines,'\\bottomrule\\end{appstar}',
 '\\floatnote{HKEX List of Securities, Main Board and GEM equities, selected on November 12, 2026; EastMoney statements via AKShare. Exclusion tags overlap; exclusive reason strings are retained in the CSV. Non-equities were removed before this roster. The spot event is a roster request, not a firm. Ledger events include repeat attempts. March/September fiscal-year reports map to the nearest June/December endpoint, as for developers. This current-listing, balanced-survivor sample does not recover delisted controls.}',
 '\\endgroup')
# The date is a roster field, not a newly inferred download date.
audit[[length(audit)+1L]]<-data.frame(target=target,location='roster date',
 source_file='replication/data/raw/control_hk/control_hk_roster.csv',source_row='all',
 source_column='selection_date',value=unique(r$selection_date),printed='November 12, 2026')
textout(roster_lines,'outputs/tables/t076_hk_roster_summary.tex');textout(roster_lines,paste0('../',target))

# Build ends before any historical proposal read/patch or integration attestation.
# Those T076 attestations describe the accepted manuscript and stay untouched.
if(!integrate_proposal) {
 stopifnot(same(protected,protected_hash),same(oldraw,oldraw_hash),same(inputs,input_hash))
 reproducibility<-do.call(rbind,lapply(staged,function(s)data.frame(file=unname(s['target']),
  sha256=hash(s['path']),byte_identical=file.exists(s['target'])&&identical(hash(s['target']),hash(s['path'])))))
 stopifnot(all(reproducibility$byte_identical))
 for(s in staged)stopifnot(file.copy(s['path'],s['target'],overwrite=TRUE))
 write.csv(reproducibility,'outputs/tables/t082_hk_build_reproducibility.csv',row.names=FALSE,eol='\n')
 write.csv(data.frame(file=inputs,sha256=unname(input_hash)),
  'outputs/tables/t082_hk_build_inputs.csv',row.names=FALSE,eol='\n')
 stopifnot(same(protected,protected_hash),same(oldraw,oldraw_hash),same(inputs,input_hash))
 cat(sprintf('T082 HK build PASS: %d byte-identical statistical/table/figure outputs; %d raw MANIFEST entries verified.\n',
  nrow(reproducibility),nrow(manifest)))
 quit(save='no',status=0L)
}

# Deterministic, narrowly scoped paragraph replacements; reruns update marked
# T076 blocks and never append a second copy. Original prose is matched exactly.
update_block<-function(lines,start,end,new,original_pattern=NULL) {
 a<-which(lines==start);b<-which(lines==end)
 if(length(a)||length(b)) {stopifnot(length(a)==1L,length(b)==1L,a<b)
  return(c(head(lines,a-1L),start,new,end,tail(lines,length(lines)-b)))}
 hit<-grep(original_pattern,lines);stopifnot(length(hit)==1L)
 c(head(lines,hit-1L),start,new,end,tail(lines,length(lines)-hit))
}
target<-'proposal/sections/05_context_data.tex'
sample_text<-c(source_comment,paste0(
 'The A-share control uses current Sina Finance industry lists and EastMoney statements, excluding known developers; its balanced survivors and unavailable ownership split are described in Online Appendix~\\ref{app:res_control}. ',
 'The HKEX equity list and EastMoney HK statements provide ',sn('firms_balanced_13',target,'HK sample sentence'),
 ' balanced Hong Kong controls, excluding developers, real estate and property services, financials and A+H dual listings (Appendix~\\ref{app:res_hk_control}).'))
lines<-readLines(paste0('../',target))
lines<-update_block(lines,'% T076 sample begin','% T076 sample end',sample_text,'^The control uses')
textout(lines,paste0('../',target))

target<-'proposal/sections/06_preliminary_analysis.tex'
main_text<-c(source_comment,paste0(
 'The same-market A-share contrast is ',rn('A_delta_delta_b','estimate',target,'within-market paragraph'),
 ', with interval $[',rn('A_delta_delta_b','ci_low',target,'within-market paragraph'),',',
 rn('A_delta_delta_b','ci_high',target,'within-market paragraph'),']$. The Hong Kong contrast is ',
 rn('HK_delta_delta_b','estimate',target,'within-market paragraph'),' $[',
 rn('HK_delta_delta_b','ci_low',target,'within-market paragraph'),',',
 rn('HK_delta_delta_b','ci_high',target,'within-market paragraph'),
 ']$: both point estimates are positive, but only the Hong Kong interval excludes zero, with just ',
 sup('developers_HK','pre','window_firm_halfyears',target,'within-market paragraph'),
 ' pre-policy developer observations in the window. The market-matched average is ',
 rn('market_matched_delta_delta_b','estimate',target,'within-market paragraph'),' $[',
 rn('market_matched_delta_delta_b','ci_low',target,'within-market paragraph'),',',
 rn('market_matched_delta_delta_b','ci_high',target,'within-market paragraph'),
 ']$ (Table~\\ref{tab:robustness}). Comparable counterfactual changes remain an assumption; these contrasts do not remove developer-specific shocks.'))
lines<-readLines(paste0('../',target))
lines<-update_block(lines,'% T076 finding begin','% T076 finding end',main_text,'^The same-market A-share contrast')
textout(lines,paste0('../',target))

target<-'proposal/tables/t051_robustness.tex'
lines<-readLines(paste0('../',target))
hkrows<-c(source_comment,'\\multicolumn{4}{l}{Hong Kong control and market-matched comparisons} \\\\')
for(m in c('control_HK_delta_b','HK_delta_delta_b','market_matched_delta_delta_b')) {
 loc<-paste0('new row ',m)
 label<-switch(m,control_HK_delta_b='HK control: $\\Delta b$',
  HK_delta_delta_b='HK developers $-$ HK control',market_matched_delta_delta_b='Market-matched: $\\Delta\\Delta b$')
 g<-if(m=='control_HK_delta_b')'control_HK' else if(m=='HK_delta_delta_b')'developers_HK' else NA_character_
 obs<-if(m=='HK_delta_delta_b') paste0('D ',sup('developers_HK','pre','firms',target,loc),'/',
  sup('developers_HK','post','firms',target,loc),'; C ',sup('control_HK','pre','firms',target,loc)) else
  if(is.na(g))'See Appendix' else paste0(sup(g,'pre','firm_halfyears',target,loc),'/',
  sup(g,'post','firm_halfyears',target,loc),' (',sup(g,'pre','firms',target,loc),')')
 hkrows<-c(hkrows,rowtex(c(label,rn(m,'estimate',target,loc),paste0('$[',rn(m,'ci_low',target,loc),
  ',',rn(m,'ci_high',target,loc),']$'),obs)))
}
# One compact table row carries both authorized robustness contrasts, in the
# order reported-advance controls / TL/TA controls; full support is in the appendix.
loc<-'advance-item robustness row'
robust_metrics<-c('HK_delta_delta_b_no_imputation','HK_delta_delta_b_unadjusted_control')
robust_values<-vapply(robust_metrics,function(m)rn(m,'estimate',target,loc),character(1))
robust_intervals<-vapply(robust_metrics,function(m)paste0('$[',rn(m,'ci_low',target,loc),',',
 rn(m,'ci_high',target,loc),']$'),character(1))
hkrows<-c(hkrows,rowtex(c('HK advance checks',paste0('\\multicolumn{3}{l}{Reported: ',
 mathminus(robust_values[1]),' ',robust_intervals[1],'; TL/TA: ',
 mathminus(robust_values[2]),' ',robust_intervals[2],'}'))))
a<-which(lines=='% T076 table rows begin');b<-which(lines=='% T076 table rows end')
if(length(a)) {stopifnot(length(a)==1L,length(b)==1L,a<b)
 lines<-c(head(lines,a-1L),'% T076 table rows begin',hkrows,'% T076 table rows end',tail(lines,length(lines)-b))
} else {
 i<-grep('Post-policy levels',lines);stopifnot(length(i)==1L)
 lines<-c(head(lines,i-1L),'% T076 table rows begin',hkrows,'% T076 table rows end',tail(lines,length(lines)-i+1L))
}
newnote<-paste0('\\floatnote{A-share: preferred design for attribution; HK: within-market; pooled: descriptive. ',
 'A controls: ',sup('control_A','pre','firm_halfyears',target,'note'),'/',
 sup('control_A','post','firm_halfyears',target,'note'),' observations (',sup('control_A','pre','firms',target,'note'),
 ' firms). D/C: developer/control firms, pre/post if different; HK developer pre-window support: ',
 sup('developers_HK','pre','window_firm_halfyears',target,'note'),'. ',
 'Checks: controls report advances at every date / use TL/TA; developers unchanged. ',
 'Market-matched uses developer-share weights. Percentile CIs: ',
 spec('B','999',target,'note'),' whole-firm draws, independent across groups, paired across periods. ',
 'Support and details: Appendix Table~\\ref{tab:t076_hk_control}.}')
i<-grep('^\\\\floatnote',lines);stopifnot(length(i)==1L);lines[i]<-newnote
textout(lines,paste0('../',target))

target<-'proposal/appendix/results.tex'
appendix<-c('\\Needspace{0.35\\textheight}',
 '\\subsection{Hong Kong control and within-market difference-in-bunching}',
 '\\label{app:res_hk_control}',source_comment,
 paste0('The HKEX roster contains ',sn('roster_firms',target,'roster paragraph'),' equities, of which ',
 sn('eligible_firms',target,'roster paragraph'),' pass the exclusions and ',
 sn('firms_any_balance',target,'roster paragraph'),' have at least one balance row; ',
 sn('firms_balanced_13',target,'roster paragraph'),' have finite RL1 at all ',
 spec('endpoints','13',target,'roster paragraph'),' endpoints. Table~\\ref{tab:t076_hk_roster} records exclusions, coverage and ledger events. ',
 'Current listings and balanced coverage select survivors; no missing or failed reports are replaced. ',
 'Reporting dates use the same nearest-June/December rule as HK developers. Advance receipts and contract liabilities are summed; ',
 'a missing component contributes zero, including when both are absent (flagged). Nonpositive adjusted assets give missing RL1. ',
 'Other missing items stay missing; no trimming or interpolation is applied. ',
 'Setting absent advances to zero raises control RL1 relative to positive unreported advances when liabilities are below assets; ',
 'this can shift observations around the mass window, without fixing the sign of the bias in the change contrast.'),
 '',paste0('The authorized advance-item checks keep the HK developers unchanged. Restricting controls to firms reporting ',
 'at least one advance item at every endpoint gives ',rn('HK_delta_delta_b_no_imputation','estimate',target,'robustness paragraph'),
 ' $[',rn('HK_delta_delta_b_no_imputation','ci_low',target,'robustness paragraph'),',',
 rn('HK_delta_delta_b_no_imputation','ci_high',target,'robustness paragraph'),']$. ',
 'Using TL/TA for the primary balanced controls gives ',rn('HK_delta_delta_b_unadjusted_control','estimate',target,'robustness paragraph'),
 ' $[',rn('HK_delta_delta_b_unadjusted_control','ci_low',target,'robustness paragraph'),',',
 rn('HK_delta_delta_b_unadjusted_control','ci_high',target,'robustness paragraph'),
 ']$. The reported-advance subset has ',sup('control_HK_no_imputation','pre','firms',target,'robustness paragraph'),
 ' firms, below the control-firm support minimum. Both use the same estimator and fixed seed; ',
 'Table~\\ref{tab:t076_hk_control} reports support and valid draws.'),
 '',paste0('The pre-registered primary contrast compares the unchanged HK developer sample with the balanced HK control. ',
 'The secondary market-matched estimate weights the within-market contrasts by the original developer firm shares, ',
 'holding these weights fixed in stratified bootstrap draws. The same whole-firm draw is used before and after the policy; ',
 'developer and control groups are resampled independently. HK control support passes both minima; the developer pre-window count of ',
 sup('developers_HK','pre','window_firm_halfyears',target,'support paragraph'),
 ' is below ',spec('minimum_window_obs','20',target,'support paragraph'),
 ', so the HK contrast is flagged for sparse developer support. All primary and secondary draws are valid. ',
 'Smooth densities and comparable counterfactual changes remain assumptions; a positive contrast does not rule out developer-specific shocks.'),
 '',source_comment,
 '\\apptable{t076_hk_control}{Hong Kong controls and within-market changes in excess mass}{tab:t076_hk_control}',
 '', '% source: replication/outputs/tables/t076_density_bins.csv; t076_specification.csv (exact cells in t076_number_audit.csv)',
 paste0('\\appfigure[{Balanced HK controls; pre: ',spec('pre_first','2017H1',target,'figure note'),'--',
 spec('pre_last','2019H2',target,'figure note'),'; post: ',spec('post_first','2020H2',target,'figure note'),'--',
 spec('post_last','2022H2',target,'figure note'),'. Shares of all finite firm-half-years per ',
 spec('bin_width','0.01',target,'figure note'),' bin, including observations outside the plotted range in denominators. ',
 'Degree ',spec('degree','5',target,'figure note'),' polynomial fitted over $[',
 spec('fit_lower','0.40',target,'figure note'),',',spec('fit_upper','1.00',target,'figure note'),
 ']$ outside the shaded window $[',spec('window_lower','0.66',target,'figure note'),',',
 spec('window_upper','0.70',target,'figure note'),')$; dashed line at ',
 spec('window_upper','0.70',target,'figure note'),'. Identical vertical scales and a shared legend.}]{f_hk_control_density}',
 '{RL1 density among unregulated Hong Kong firms}{fig:t076_hk_density}{0}'),
 '',source_comment,
 '\\apptable{t076_hk_roster_summary}{Hong Kong roster, coverage and failure ledger}{tab:t076_hk_roster}','')
lines<-readLines(paste0('../',target))
lines<-sub('There is no Hong Kong control, broad-control variant or ownership split.',
 'There is no broad-control variant or ownership split; the new HK comparison follows below.',lines,fixed=TRUE)
lines<-sub('Controls are survivor-selected; pooled comparisons have no Hong Kong control.',
 'Controls select current-listing survivors; the separate HK contrast has sparse developer pre-window support (Appendix~\\ref{app:res_hk_control}).',
 lines,fixed=TRUE)
a<-which(lines=='% T076 appendix begin');b<-which(lines=='% T076 appendix end')
if(length(a)) {stopifnot(length(a)==1L,length(b)==1L,a<b)
 lines<-c(head(lines,a-1L),'% T076 appendix begin',appendix,'% T076 appendix end',tail(lines,length(lines)-b))
} else {
 i<-grep('^\\\\subsection\\{Exposure, symmetric',lines);stopifnot(length(i)==1L)
 # Insert before this subsection's Needspace, after the full control section.
 i<-i-1L;stopifnot(grepl('Needspace',lines[i]))
 lines<-c(head(lines,i-1L),'% T076 appendix begin',appendix,'% T076 appendix end','',tail(lines,length(lines)-i+1L))
}
textout(lines,paste0('../',target))

# Only the stale HK-control clauses authorized in Rework 1 are changed. In
# particular, preserve the PI-approved focal-paper author footnote verbatim.
for(target in c('proposal/tables/t049_threats.tex','proposal/tables/t061_results.tex',
 'proposal/sections/02_literature.tex')) {
 lines<-readLines(paste0('../',target))
 lines<-sub('Survivor-only A-shares; no Hong Kong control',
  'A/HK survivor controls; sparse HK developer support',lines,fixed=TRUE)
 lines<-sub('No broad or Hong Kong control is available, and ownership is not observed.',
  'No broad control or control ownership split is available; the separate HK comparison uses current-listing survivors and has sparse developer pre-window support (Appendix~\\ref{app:res_hk_control}).',
  lines,fixed=TRUE)
 lines<-sub('my sample adds Hong Kong listings, whose concentration is descriptive without a same-market control.',
  'my sample adds Hong Kong listings and a same-market control drawn from current-listing survivors, with sparse developer pre-window support (Appendix~\\ref{app:res_hk_control}).',
  lines,fixed=TRUE)
 textout(lines,paste0('../',target))
}
number_audit<-do.call(rbind,audit);csv(number_audit,'number_audit')

stopifnot(same(protected,protected_hash),same(oldraw,oldraw_hash),
 same(inputs,input_hash),same(immutable_proposal,immutable_hash))
csv(data.frame(file=c(protected,oldraw,inputs,immutable_proposal),
 sha256_before=c(protected_hash,oldraw_hash,input_hash,immutable_hash),
 unchanged=TRUE),'verification')
reproducibility<-do.call(rbind,lapply(staged,function(s)data.frame(file=unname(s['target']),
 sha256=hash(s['path']),byte_identical=file.exists(s['target'])&&identical(hash(s['target']),hash(s['path'])))))
for(s in staged) {dir.create(dirname(s['target']),recursive=TRUE,showWarnings=FALSE)
 stopifnot(file.copy(s['path'],s['target'],overwrite=TRUE))}
write.csv(reproducibility,'outputs/tables/t076_reproducibility.csv',row.names=FALSE,na='NA',eol='\n')
# Verify saved audit sources independently after publishing the staged files.
number_verification<-do.call(rbind,lapply(seq_len(nrow(number_audit)),function(i) {
 a<-number_audit[i,];z<-read(paste0('../',a$source_file))
 key<-strsplit(a$source_row,'|',fixed=TRUE)[[1]]
 if(a$source_column=='selection_date') val<-unique(z$selection_date) else {
  if('metric'%in%names(z)&&'section'%in%names(z)) z<-z[z$section==key[1]&z$metric==key[2],]
  else if('metric'%in%names(z)) z<-z[z$metric==key[1],]
  else if('parameter'%in%names(z)) z<-z[z$parameter==key[1],]
  else z<-z[z$group==key[1]&z$period==key[2],]
  stopifnot(nrow(z)==1L);val<-z[[a$source_column]]
 }
 source_matches<-isTRUE(all.equal(as.character(val),a$value))||
  (length(val)==1L&&isTRUE(all.equal(suppressWarnings(as.numeric(val)),suppressWarnings(as.numeric(a$value)),tolerance=1e-12)))
 printed_present<-any(grepl(a$printed,readLines(paste0('../',a$target)),fixed=TRUE))
 data.frame(audit_row=i,source_matches=source_matches,printed_present=printed_present)
}))
stopifnot(all(number_verification$source_matches),all(number_verification$printed_present))
write.csv(number_verification,'outputs/tables/t076_number_verification.csv',row.names=FALSE,eol='\n')
stopifnot(same(protected,protected_hash),same(oldraw,oldraw_hash),same(inputs,input_hash),
 same(immutable_proposal,immutable_hash))
cat(sprintf('T076 roster: %d total; %d eligible; %d excluded; %d firms with balances; %d balanced controls.\n',
 nrow(r),sum(eligible),sum(!eligible),nf(c$code),length(balanced)))
cat(sprintf('T076 HK control delta_b = %.6f [%.6f, %.6f].\n',results$estimate[1],results$ci_low[1],results$ci_high[1]))
for(metric in c('HK_delta_delta_b','market_matched_delta_delta_b',robust_metrics)) {
 z<-results[results$metric==metric,]
 cat(sprintf('T076 %s = %.6f [%.6f, %.6f]; valid draws %d/%d.\n',metric,z$estimate,z$ci_low,z$ci_high,z$valid,B))
}
for(g in c('control_HK','developers_HK','control_HK_no_imputation','control_HK_unadjusted')) {
 z<-support[support$group==g,]
 cat(sprintf('T076 %s: firms %s; window observations pre/post %s; low_support %s.\n',
 g,paste(z$firms,collapse='/'),paste(z$window_firm_halfyears,collapse='/'),any(z$low_support)))
}
cat(sprintf('T076 guards PASS: %d existing outputs; %d existing raw files; %d inputs unchanged.\n',
 length(protected),length(oldraw),length(inputs)))
cat(sprintf('T076 raw reconstruction PASS: %d values; independent estimator max error %.3g.\n',checked,max(validation$error)))
cat(sprintf('T076 number audit PASS: %d verified transfers; previous-run byte matches %d/%d.\n',
 nrow(number_verification),sum(reproducibility$byte_identical),nrow(reproducibility)))
