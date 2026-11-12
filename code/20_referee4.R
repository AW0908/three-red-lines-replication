# T058: approved, offline descriptive referee checks. Run from replication/.
# Counts use stored RL1; accounting comparisons reconstruct N/(N+E), as T029.
# Shared whole-firm draws preserve every within-firm and between-cell contrast.
options(digits=17)
seed <- 20261016L; B <- 999L; set.seed(seed)
read <- function(p) read.csv(p,stringsAsFactors=FALSE,na.strings=c('','NA','--'))
nf <- function(x) length(unique(x[!is.na(x)]))
clean <- function(x) {x[is.na(x)] <- FALSE; x}
bind <- function(xs) {
 cols <- unique(unlist(lapply(xs,names)))
 do.call(rbind,lapply(xs,function(x) {for(n in setdiff(cols,names(x)))x[[n]]<-NA;x[cols]}))
}
inputs <- unique(c('data/processed/panel_firm_halfyear.csv','../state/pilot_developers.csv',
 'code/20_referee4.R','code/06_bunching_tests.R','code/11_mechanism.R',
 'code/15_referee2.R','code/19_referee3.R','code/12_q1_robustness.R','code/01_clean.R',
 'README.md','run_all.R','run_all.sh','outputs/tables/t004_variable_dictionary.csv',
 list.files('outputs/tables','^t023_|^t029_',full.names=TRUE),
 paste0('outputs/tables/',c('t025_attrition.csv','t031_grid.csv','t031_samples.csv',
 't043_delta_b.csv','t043_heterogeneity.csv'))))
stopifnot(all(file.exists(inputs)))
input_hash <- tools::sha256sum(inputs)
protected <- list.files('outputs',recursive=TRUE,full.names=TRUE,all.files=TRUE)
protected <- protected[!dir.exists(protected)&!grepl('^t058_',basename(protected))]
protected_hash <- tools::sha256sum(protected)
# Read all listed tabular inputs without running scripts that mutate old outputs.
references <- lapply(inputs[grepl('outputs/tables/.*csv$',inputs)],read)
names(references) <- basename(inputs[grepl('outputs/tables/.*csv$',inputs)])
d <- read(inputs[1]); d <- d[!is.na(d$sample_main)&d$sample_main,]
d$date <- as.Date(d$date); d <- d[order(d$firm_id,d$date),];rownames(d)<-NULL
stopifnot(!anyDuplicated(d[c('firm_id','date')]))
firms <- sort(unique(d$firm_id)); G <- length(firms); fi <- match(d$firm_id,firms)
W <- cbind(rep(1L,G),replicate(B,tabulate(sample.int(G,G,replace=TRUE),nbins=G)))
pre <- d$date>=as.Date('2017-06-30')&d$date<=as.Date('2019-12-31')
post <- d$date>=as.Date('2020-12-31')&d$date<=as.Date('2022-12-31')
placebo <- d$date>=as.Date('2017-12-31')&d$date<=as.Date('2019-12-31')
window <- function(x) is.finite(x)&x>=.66&x<.70
summary_boot <- function(v) {
 ok <- is.finite(v);q <- if(any(ok))quantile(v[ok],c(.025,.975),names=FALSE) else c(NA,NA)
 list(se=if(sum(ok)>1L)sd(v[ok]) else NA_real_,ci_low=q[1],ci_high=q[2],
 bootstrap_draws=B,bootstrap_valid=sum(ok),bootstrap_failed=sum(!ok))
}
stat <- function(x,use,id=d$firm_id,kind='mean') {
 use <- clean(use)&is.finite(x); ix <- match(id[use],firms); xx <- x[use]
 vapply(seq_len(B+1L),function(j) {
  ww <- W[ix,j];ok <- ww>0
  if(!any(ok))return(NA_real_)
  if(kind=='median')median(rep(xx[ok],ww[ok])) else weighted.mean(xx[ok],ww[ok])
 },numeric(1))
}
sp0 <- list(bin_width=.01,exclusion_lower=.66,exclusion_upper=.70,degree=5L,fit_lower=.4,fit_upper=1)
mass_est <- function(use,x=d$rl1,id=d$firm_id,sp=sp0,mass_lower=NULL,mass_upper=NULL) {
 use <- clean(use)&is.finite(x)
 edges <- round(seq(sp$fit_lower,sp$fit_upper,sp$bin_width),10)
 mid <- (head(edges,-1)+tail(edges,-1))/2
 excluded <- mid>=sp$exclusion_lower-1e-12&mid<sp$exclusion_upper-1e-12
 mass <- if(is.null(mass_lower))excluded&mid<.70-1e-12 else mid>=mass_lower-1e-12&mid<mass_upper-1e-12
 stopifnot(any(mass))
 ix <- findInterval(x,edges,rightmost.closed=TRUE)
 inside <- use&!is.na(ix)&ix>0L&ix<length(edges)
 a <- matrix(0,G,length(mid))
 for(i in which(inside))a[match(id[i],firms),ix[i]] <- a[match(id[i],firms),ix[i]]+1
 y <- t(a)%*%W
 X <- cbind(1,poly(mid,degree=sp$degree)); q <- qr(X[!excluded,,drop=FALSE])
 stopifnot(q$rank==ncol(X))
 pred <- X%*%qr.coef(q,y[!excluded,,drop=FALSE])
 good <- colSums(!is.finite(pred[mass,,drop=FALSE])|pred[mass,,drop=FALSE]<=0)==0
 cf <- colSums(pred[mass,,drop=FALSE]); obs <- colSums(y[mass,,drop=FALSE])
 v <- ifelse(good,(obs-cf)/(cf/sum(mass)),NA_real_)
 in_mass <- inside&x>=min(head(edges,-1)[mass])&x<max(tail(edges,-1)[mass])
 list(v=v,obs=obs[1],cf=cf[1],mass_firms=nf(id[in_mass]),n=sum(use),firms=nf(id[use]),n_in_range=sum(inside),
 n_outside=sum(use&!inside),negative_fitted_bins=sum(pred[,1]<0),
 actual_mass_lower=min(head(edges,-1)[mass]),actual_mass_upper=max(tail(edges,-1)[mass]),
 actual_exclusion_lower=min(head(edges,-1)[excluded]),actual_exclusion_upper=max(tail(edges,-1)[excluded]))
}
anchor <- function(x,date) x[match(paste(d$firm_id,date),paste(d$firm_id,d$date))]
N <- d$tl-d$adv; valid <- is.finite(N)&N>0&is.finite(d$te)&d$te>0
R <- ifelse(valid,N/(N+d$te),NA_real_)
freeze_mi <- function(date) {
 den <- N+d$te-d$mi+anchor(d$mi,date)
 ifelse(valid&is.finite(d$mi)&is.finite(den)&den>0,N/den,NA_real_)
}
F <- freeze_mi('2019-12-31'); pair <- post&is.finite(R)&is.finite(F)
basepre <- mass_est(pre);basepost <- mass_est(post)
D <- stat(as.numeric(R<=.7)-as.numeric(F<=.7),pair)
ref <- references[['t043_delta_b.csv']];ref <- ref[ref$threshold==.7&ref$specification=='main',]
stopifnot(round(basepost$v[1],2)==3.14,round(basepre$v[1],2)==-.88,
 round(basepost$v[1]-basepre$v[1],2)==4.02,round(D[1],4)==.1146,
 sum(pair)==602L,nf(d$firm_id[pair])==129L,nrow(ref)==1L,
 max(abs((basepost$v-basepre$v)[1]-ref$delta_b))<1e-10,
 all(abs(R[is.finite(R)]-d$rl1[is.finite(R)])<1e-6))
cat(sprintf('T058 reproduction PASS: b_post=%.12f; b_pre=%.12f; delta_b=%.12f; D=%.12f; pairs=602; firms=129.\n',
 basepost$v[1],basepre$v[1],basepost$v[1]-basepre$v[1],D[1]))

# All outputs are staged. Any failed gate leaves prior outputs intact.
staged <- list()
stage <- function(f,target) {
 stopifnot(grepl('^t058_',basename(target)))
 staged[[length(staged)+1L]] <<- c(path=f,target=target)
}
csv <- function(x,name) {
 f <- tempfile(fileext='.csv');con <- file(f,'wb');write.csv(x,con,row.names=FALSE,na='NA',eol='\n');close(con)
 stage(f,paste0('outputs/tables/t058_',name,'.csv'))
}
fmt <- function(x) ifelse(is.finite(x),sprintf('%.3f',x),'--')
csv(data.frame(metric=c('b_post','b_pre','delta_b','D','paired_observations','paired_firms'),
 estimate=c(basepost$v[1],basepre$v[1],basepost$v[1]-basepre$v[1],D[1],sum(pair),nf(d$firm_id[pair])),
 expected_rounded=c(3.14,-.88,4.02,.1146,602,129),assert_pass=TRUE),'reproduction')
escape <- function(x) gsub('_','\\_',x,fixed=TRUE)
texrow <- function(x) paste0(paste(x,collapse=' & '),' \\\\')
common <- paste('Main sample; pre 2017H1--2019H2, post 2020H2--2022H2 unless labeled.',
 '999 joint whole-firm draws of the 136-firm universe, seed 20261016; density and statistics re-estimated each draw.',
 'Pointwise percentile CIs condition on valid draws; below 90 percent valid is unreliable.',
 'b is excess / mean fitted mass-bin count, degree 5, 0.01 bins over [0.40,1.00], excluding [0.66,0.70).',
 'All cells are descriptive; S flags fewer than 15 firms in the window. Smooth density and reporting comparability are assumptions.')
tex <- function(name,header,rows,align,note,chunk=14L) {
 out <- character()
 for(rr in split(rows,ceiling(seq_along(rows)/chunk)))out <- c(out,
 '\\begingroup\\scriptsize\\setlength{\\tabcolsep}{3pt}','\\begin{threeparttable}',
 paste0('\\begin{tabular}{',align,'}'),'\\toprule',texrow(header),'\\midrule',rr,
 '\\bottomrule','\\end{tabular}','\\begin{tablenotes}[flushleft]\\footnotesize',
 paste0('\\item[] ',note),'\\end{tablenotes}','\\end{threeparttable}','\\endgroup','\\par\\medskip')
 f <- tempfile(fileext='.tex');con <- file(f,'wb');writeLines(out,con,useBytes=TRUE);close(con)
 stage(f,paste0('outputs/tables/t058_',name,'.tex'))
}
rows <- list(); draws <- list(); audits <- list()
sample_info <- function(use,x=d$rl1,id=d$firm_id) {
 candidate <- clean(use);use <- candidate&is.finite(x);ww <- use&window(x)
 list(n=sum(use),firms=nf(id[use]),window_obs=sum(ww),window_firms=nf(id[ww]),
 candidate_n=sum(candidate),missing_window_ratio=sum(candidate&!is.finite(x)))
}
record <- function(table,variant,group,metric,period,v,use,x=d$rl1,id=d$firm_id,
 benchmark=NULL,benchmark_x=x,benchmark_id=id,extras=list()) {
 stopifnot(length(v)==B+1L)
 s <- sample_info(use,x,id); bs <- if(is.null(benchmark))NULL else sample_info(benchmark,benchmark_x,benchmark_id)
 st <- summary_boot(v[-1]);if(!is.finite(v[1]))st[c('se','ci_low','ci_high')] <- NA_real_
 r <- data.frame(table=table,variant=variant,group=group,metric=metric,period=period,estimate=v[1],
 as.data.frame(s),benchmark_n=if(is.null(bs))NA else bs$n,
 benchmark_firms=if(is.null(bs))NA else bs$firms,benchmark_window_obs=if(is.null(bs))NA else bs$window_obs,
 benchmark_window_firms=if(is.null(bs))NA else bs$window_firms,
 descriptive=TRUE,small_cell=s$window_firms<15L||(!is.null(bs)&&bs$window_firms<15L),
 as.data.frame(st),inference_status=if(!is.finite(v[1]))'invalid_point' else
 if(st$bootstrap_valid<.9*B)'unreliable_below_90pct' else
 if(st$bootstrap_valid<B)'conditional_on_valid_draws' else 'all_draws_valid',stringsAsFactors=FALSE)
 for(nm in names(extras))r[[nm]] <- extras[[nm]]
 key <- length(rows)+1L;r$row_id <- key;rows[[key]] <<- r
 draws[[key]] <<- data.frame(row_id=key,draw=seq_len(B),estimate=v[-1])
 invisible(r)
}
level <- function(table,variant,group,period,use,x=d$rl1,id=d$firm_id,sp=sp0,extras=list()) {
 z <- mass_est(use,x,id,sp)
 record(table,variant,group,'b',period,z$v,use,x,id,extras=c(extras,z[setdiff(names(z),c('v','n','firms'))]))
 invisible(z)
}
change <- function(table,variant,group,upre,upost,x=d$rl1,id=d$firm_id,sp=sp0,extras=list()) {
 a <- level(table,variant,group,'pre',upre,x,id,sp,extras)
 b <- level(table,variant,group,'post',upost,x,id,sp,extras)
 record(table,variant,group,'delta_b','post_minus_pre',b$v-a$v,upost,x,id,
 benchmark=upre,extras=extras)
 invisible(list(a=a,b=b,v=b$v-a$v,upre=upre,upost=upost,x=x,id=id))
}
contrast <- function(table,variant,group,a,b,metric='difference_in_delta_b',period='post_minus_pre',extras=list()) {
 record(table,variant,group,metric,period,a$v-b$v,a$upost,a$x,a$id,
 benchmark=b$upost,benchmark_x=b$x,benchmark_id=b$id,
 extras=c(list(first_pre_n=sum(clean(a$upre)&is.finite(a$x)),
 first_pre_firms=nf(a$id[clean(a$upre)&is.finite(a$x)]),
 first_pre_window_obs=sum(clean(a$upre)&window(a$x)),
 first_pre_window_firms=nf(a$id[clean(a$upre)&window(a$x)]),
 second_pre_n=sum(clean(b$upre)&is.finite(b$x)),
 second_pre_firms=nf(b$id[clean(b$upre)&is.finite(b$x)]),
 second_pre_window_obs=sum(clean(b$upre)&window(b$x)),
 second_pre_window_firms=nf(b$id[clean(b$upre)&window(b$x)])),extras))
}

# 1. Exactly the supplied pilot mapping. No hand-collected replacements.
pilots <- read('../state/pilot_developers.csv')
ids0 <- pilots$firm_id[pilots$in_panel=='yes']
stopifnot(length(ids0)==11L,!anyDuplicated(ids0),all(ids0%in%firms),sum(pilots$in_panel=='no')==1L)
ids_s <- ids0
for(i in which(pilots$in_panel=='yes'&!is.na(pilots$firm_id_sensitivity)))
 ids_s[ids_s==pilots$firm_id[i]] <- pilots$firm_id_sensitivity[i]
stopifnot(length(ids_s)==11L,all(ids_s%in%firms))
dates <- sort(unique(d$date));stopifnot(length(dates)==13L)
complete <- firms[vapply(firms,function(f)sum(d$firm_id==f&is.finite(d$rl1))==length(dates),logical(1))]
pilot_sets <- list(main=ids0,seazen_A_share=ids_s,complete_RL1_pilots=intersect(ids0,complete))
for(variant in names(pilot_sets)) {
 ids <- pilot_sets[[variant]]
 # In complete-pilot sensitivity, incomplete pilots are excluded, not relabeled controls.
 # Neither Seazen entity may serve as a control in any variant.
 control <- !d$firm_id%in%union(ids0,ids_s)
 stopifnot(!any(control&d$firm_id%in%union(ids0,ids_s)))
 masks <- list(pilot=d$firm_id%in%ids,nonpilot=control)
 zz <- lapply(names(masks),function(g)change('pilot',variant,g,pre&masks[[g]],post&masks[[g]],
 extras=list(pilot_list_firms=length(ids),excluded_incomplete_pilot_firms=if(variant=='complete_RL1_pilots')length(setdiff(ids0,ids)) else 0L)))
 contrast('pilot',variant,'pilot_minus_nonpilot',zz[[1]],zz[[2]])
 for(period in c('2020-12-31','2021-06-30_onward')) {
  tm <- if(period=='2020-12-31')d$date==as.Date(period) else post&d$date>=as.Date('2021-06-30')
  zs <- lapply(names(masks),function(g) {
   u <- tm&masks[[g]];z <- level('pilot',variant,g,period,u)
   list(v=z$v,upre=rep(FALSE,nrow(d)),upost=u,x=d$rl1,id=d$firm_id)
  })
  contrast('pilot',variant,'pilot_minus_nonpilot',zs[[1]],zs[[2]],'difference_in_b',period)
 }
 audits[[length(audits)+1L]] <- data.frame(section='pilot',variant=variant,firm_id=d$firm_id,date=d$date,
 group=ifelse(masks$pilot,'pilot',ifelse(masks$nonpilot,'nonpilot',
 ifelse(d$firm_id%in%setdiff(union(ids0,ids_s),ids),'excluded_other_Seazen_entity','excluded_incomplete_pilot'))),
 value=d$rl1,pre=pre,post=post)
}
csv(bind(audits),'sample_audit')
csv(data.frame(variant=rep(names(pilot_sets),lengths(pilot_sets)),firm_id=unlist(pilot_sets,use.names=FALSE)), 'pilot_mapping')
cat('T058 step 1 PASS: three pilot definitions, pre/post changes and both timing cells.\n')

# 2. T058 explicitly requires contemporaneous other-line classification.
# This differs from the fixed 2020H1 class in T043; no RL1 conditioning.
classified <- is.finite(d$rl2)&is.finite(d$rl3)
both <- classified&d$rl2<=1&d$rl3>=1; breach <- classified&!both
notch <- lapply(c('both_met','at_least_one_breached'),function(g) {
 u <- if(g=='both_met')both else breach
 change('notch','contemporaneous_other_lines',g,clean(pre&u),clean(post&u),
 extras=list(unclassified_pre=sum(pre&!classified),unclassified_post=sum(post&!classified),
 classification='same_firm_date_RL2_le_1_and_RL3_ge_1'))
})
contrast('notch','contemporaneous_other_lines','both_met_minus_breached',notch[[1]],notch[[2]])
csv(data.frame(firm_id=d$firm_id,date=d$date,rl1=d$rl1,rl2=d$rl2,rl3=d$rl3,
 class=ifelse(!classified,'unclassified',ifelse(both,'both_met','at_least_one_breached')),pre=pre,post=post),'notch_classification')

# 3. Symmetric accounting freezes: E items change denominator; debt changes
# N and denominator by the same amount, leaving E fixed. Negative growth retained.
parent <- d$te-d$mi
debt <- rowSums(d[,c('std','ltd','notes','lease')],na.rm=TRUE)
debt[rowSums(is.finite(as.matrix(d[,c('std','ltd','notes','lease')])))==0L] <- NA_real_
stopifnot(all(is.na(debt)==is.na(d$ibd_ext)),max(abs(debt-d$ibd_ext),na.rm=TRUE)<1e-3)
sym_audit <- list();sym_results <- list()
for(period in c('post','placebo')) {
 date <- if(period=='post')'2019-12-31' else '2016-12-31'
 tm <- if(period=='post')post else placebo
 m <- freeze_mi(date); paired <- tm&is.finite(R)&is.finite(m)
 items <- list(MI=d$mi,parent_equity=parent,interest_bearing_debt=debt,MI_and_parent_equity=d$te)
 for(item in names(items)) {
  value <- items[[item]];v0 <- anchor(value,date);delta <- value-v0
  numerator <- if(item=='interest_bearing_debt')N-delta else N
  den <- N+d$te-delta
  cf <- ifelse(valid&is.finite(value)&is.finite(v0)&is.finite(den)&den>0,numerator/den,NA_real_)
  use <- paired&is.finite(cf); ta0 <- anchor(d$ta,date)
  growth <- ifelse(is.finite(ta0)&ta0>0,100*delta/ta0,NA_real_)
  grow_use <- use&is.finite(growth)
  cs <- stat(as.numeric(cf<=.7),use);off <- stat(as.numeric(R<=.7),use)
  dd <- off-cs;mg <- stat(growth,grow_use,kind='median')
  norm <- ifelse(is.finite(mg)&mg!=0,100*dd/mg,NA_real_)
  z <- mass_est(use,cf);zo <- mass_est(use,R)
  sym_results[[paste(period,item)]] <- list(D=dd,growth=mg,norm=norm,use=use)
  vals <- list(official_compliant_share=off,frozen_compliant_share=cs,D=dd,
   official_b=zo$v,frozen_b=z$v,median_growth_pp_assets=mg,D_pp_per_growth_pp_assets=norm)
  for(metric in names(vals))record('symmetric',item,'paired',metric,period,vals[[metric]],
   if(metric=='median_growth_pp_assets')grow_use else use,
   x=if(metric%in%c('official_compliant_share','official_b','D','median_growth_pp_assets','D_pp_per_growth_pp_assets'))R else cf,
   extras=list(anchor=date,candidate_MI_pairs=sum(paired),excluded_from_MI_pairs=sum(paired&!is.finite(cf)),
   growth_n=sum(grow_use),growth_firms=nf(d$firm_id[grow_use]),
   frozen_columns=if(item=='interest_bearing_debt')'std + ltd + notes + lease (=ibd_ext; partial sum)' else
   if(item=='MI')'mi' else if(item=='parent_equity')'te - mi' else 'te',
   normalization='100*D / median(100*(item_t-item_anchor)/ta_anchor)',
   frozen_nonpositive_numerator=sum(use&numerator<=0),partial_debt_rows=sum(use&rowSums(is.finite(as.matrix(d[,c('std','ltd','notes','lease')])))<4L)))
  sym_audit[[length(sym_audit)+1L]] <- data.frame(period=period,anchor=date,item=item,firm_id=d$firm_id,date=d$date,
   MI_pair=paired,eligible=use,reported_R=R,frozen_R=cf,item_value=value,item_anchor=v0,
   growth_pp_anchor_assets=growth,denominator=den,numerator=numerator)
 }
}
csv(bind(sym_audit),'symmetric_audit')

# 4. Balanced samples require finite RL1 on each scheduled date, not just a row.
main_dates <- dates[dates>=as.Date('2017-06-30')&dates!=as.Date('2020-06-30')]
balanced_main <- firms[vapply(firms,function(f)sum(d$firm_id==f&d$date%in%main_dates&is.finite(d$rl1))==length(main_dates),logical(1))]
attr_changes <- list()
for(variant in c('all','balanced_13_dates','balanced_main_11_dates')) {
 ids <- switch(variant,all=firms,balanced_13_dates=complete,balanced_main_11_dates=balanced_main)
 attr_changes[[variant]] <- change('attrition',variant,'all',pre&d$firm_id%in%ids,post&d$firm_id%in%ids,
 extras=list(required_dates=if(variant=='all')NA_integer_ else if(variant=='balanced_13_dates')13L else 11L))
}
last <- do.call(rbind,lapply(firms,function(f) {
 z <- d[d$firm_id==f,];ii <- which(is.finite(z$rl1));j <- if(length(ii))tail(ii,1L) else NA_integer_
 data.frame(firm_id=f,last_report=as.character(max(z$date)),
 last_rl1_date=if(is.na(j))NA_character_ else as.character(z$date[j]),
 last_rl1=if(is.na(j))NA_real_ else z$rl1[j])
}))
last$group <- ifelse(last$last_report=='2022-12-31','continuing',
 ifelse(last$last_report>='2021-06-30','exiting_after_2021h1','earlier_exit'))
last$cutoff_definition <- 'last financial row >=2021-06-30 and <2022-12-31; continuing has row at 2022-12-31'
csv(last,'attrition_firms')
abin <- list();aedge <- round(seq(.4,1,.05),10)
for(g in c('exiting_after_2021h1','continuing')) {
 use <- last$group==g&is.finite(last$last_rl1)
 for(i in seq_len(length(aedge)-1L)) {
  inbin <- last$last_rl1>=aedge[i] & if(i==length(aedge)-1L)last$last_rl1<=aedge[i+1L] else last$last_rl1<aedge[i+1L]
  record('attrition','last_observation_distribution',g,'bin_share',paste(aedge[i],aedge[i+1L],sep='_'),
   stat(as.numeric(inbin),use,last$firm_id),use,last$last_rl1,last$firm_id,
   extras=list(bin_lower=aedge[i],bin_upper=aedge[i+1L],count=sum(clean(use&inbin)),
   window_obs=sum(clean(use&inbin)),window_firms=nf(last$firm_id[clean(use&inbin)]),
   small_cell=nf(last$firm_id[clean(use&inbin)])<15L,
   denominator='all finite last RL1, including values outside histogram range'))
  abin[[length(abin)+1L]] <- data.frame(group=g,lower=aedge[i],upper=aedge[i+1L],share=mean(inbin[use]))
 }
}
u <- last$group=='exiting_after_2021h1'&is.finite(last$last_rl1)
v <- last$group=='continuing'&is.finite(last$last_rl1)
exshare <- stat(as.numeric(window(last$last_rl1)),u,last$firm_id)
coshare <- stat(as.numeric(window(last$last_rl1)),v,last$firm_id)
tab <- rbind(c(sum(u&window(last$last_rl1)),sum(u&!window(last$last_rl1))),
 c(sum(v&window(last$last_rl1)),sum(v&!window(last$last_rl1))))
ft <- if(all(rowSums(tab)>0))fisher.test(tab) else NULL
for(g in c('exiting','continuing','exiting_minus_continuing'))record('attrition','equal_near_threshold_share',g,
 'share_below', 'last_observed_RL1',if(g=='exiting')exshare else if(g=='continuing')coshare else exshare-coshare,
 if(g=='continuing')v else u,last$last_rl1,last$firm_id,
 benchmark=if(g=='exiting_minus_continuing')v else NULL,
 extras=list(fisher_two_sided_p=if(is.null(ft))NA_real_ else ft$p.value))
# LOCF adds only scheduled observations after terminal exit, not intermittent gaps.
fill <- list()
for(i in which(last$group=='exiting_after_2021h1'&is.finite(last$last_rl1))) {
 dt <- dates[dates>as.Date(last$last_report[i])]
 fill[[length(fill)+1L]] <- data.frame(firm_id=last$firm_id[i],date=dt,rl1=last$last_rl1[i])
}
filled <- if(length(fill))do.call(rbind,fill) else data.frame(firm_id=character(),date=as.Date(character()),rl1=numeric())
dd <- rbind(d[,c('firm_id','date','rl1')],filled);dd <- dd[order(dd$firm_id,dd$date),]
stopifnot(!anyDuplicated(dd[c('firm_id','date')]))
attr_n_exit <- sum(u);attr_n_continue <- sum(v)
attr_changes$LOCF <- change('attrition','terminal_exit_LOCF','all',
 dd$date>=as.Date('2017-06-30')&dd$date<=as.Date('2019-12-31'),
 dd$date>=as.Date('2020-12-31')&dd$date<=as.Date('2022-12-31'),dd$rl1,dd$firm_id,
 extras=list(added_observations=nrow(filled),filled_firms=nf(filled$firm_id),
 rule='carry last finite RL1 to scheduled dates strictly after terminal financial exit >=2021-06-30'))
csv(filled,'attrition_LOCF')

# 5. Quote the existing explicit calendar rule; do not invent its rationale.
rule <- '2017-06-30 <= date <= 2019-12-31: pre; 2020-12-31 <= date <= 2022-12-31: post; otherwise NA'
readme_rule <- 'Uses the main sample, pre-period 2017H1–2019H2 and post-period 2020H2–2022H2'
level('window','2020h1_only','all','2020-06-30',d$date==as.Date('2020-06-30'),
 extras=list(calendar_rule=rule,README_quote=readme_rule,reason='2020H1 is between the two explicit calendar windows; sources do not state a separate substantive rationale'))
change('window','2020h1_added_to_pre','all',pre|d$date==as.Date('2020-06-30'),post,
 extras=list(calendar_rule=rule,README_quote=readme_rule))

# 6. Observed minus fitted mass ABOVE threshold; negative values mean missing mass.
# Exclude the entire evaluated region. Below, above and total share ONE fit;
# each b uses its OWN region's mean fitted bin count, so b's need not add.
above_extra <- list()
for(p in c('pre','post'))for(upper in c(.74,.80)) {
 use <- if(p=='pre')pre else post
 sp <- sp0;sp$exclusion_upper <- upper
 z <- mass_est(use,sp=sp,mass_lower=.70,mass_upper=upper)
 record('above',paste0('070_',sprintf('%03d',round(upper*100))),'all','above_excess_b',p,z$v,use,
 extras=c(list(above_lower=.70,above_upper=upper,sign='negative means missing mass',
 normalization='own evaluated-region mean fitted count per bin',window_obs=z$obs,window_firms=z$mass_firms),
 z[setdiff(names(z),c('v','n','firms'))]))
 for(region in c('below','total')) {
  lo <- .66;hi <- if(region=='below').70 else upper
  zz <- mass_est(use,sp=sp,mass_lower=lo,mass_upper=hi)
  above_extra[[length(above_extra)+1L]] <- list(p=p,upper=upper,region=region,use=use,z=zz)
 }
}

# 7. All 72 rows, in the exact input order; realized bin edges as T031.
grid_input <- references[['t031_grid.csv']];stopifnot(nrow(grid_input)==72L)
grid <- list()
for(i in seq_len(nrow(grid_input))) {
 sp <- as.list(grid_input[i,names(sp0)]);a <- mass_est(pre,sp=sp);b <- mass_est(post,sp=sp)
 stopifnot(is.na(b$v[1])==is.na(grid_input$b[i]),is.na(b$v[1])||abs(b$v[1]-grid_input$b[i])<1e-9)
 v <- b$v-a$v;s <- summary_boot(v[-1]);if(!is.finite(v[1]))s[c('se','ci_low','ci_high')]<-NA_real_
 grid[[i]] <- data.frame(specification_index=grid_input$specification_index[i],as.data.frame(sp),baseline=grid_input$baseline[i],
  b_pre=a$v[1],b_post=b$v[1],delta_b=v[1],delta_b_in_001_bins=v[1]*sp$bin_width/.01,as.data.frame(s),
  delta_positive=is.finite(v[1])&&v[1]>0,CI_above_zero=is.finite(v[1])&&s$bootstrap_valid>=.9*B&&is.finite(s$ci_low)&&s$ci_low>0,
  n_pre=a$n,firms_pre=a$firms,
  window_obs_pre=sum(pre&is.finite(d$rl1)&d$rl1>=a$actual_exclusion_lower&d$rl1<a$actual_exclusion_upper),
  window_firms_pre=nf(d$firm_id[pre&is.finite(d$rl1)&d$rl1>=a$actual_exclusion_lower&d$rl1<a$actual_exclusion_upper]),
  n_post=b$n,firms_post=b$firms,
  window_obs_post=sum(post&is.finite(d$rl1)&d$rl1>=b$actual_exclusion_lower&d$rl1<b$actual_exclusion_upper),
  window_firms_post=nf(d$firm_id[post&is.finite(d$rl1)&d$rl1>=b$actual_exclusion_lower&d$rl1<b$actual_exclusion_upper]),
  mass_obs_pre=a$obs,mass_obs_post=b$obs,mass_firms_pre=a$mass_firms,mass_firms_post=b$mass_firms,
  descriptive=TRUE,small_cell=a$mass_firms<15L||b$mass_firms<15L,
  mass_lower=b$actual_mass_lower,mass_upper=b$actual_mass_upper,
  exclusion_actual_lower=b$actual_exclusion_lower,exclusion_actual_upper=b$actual_exclusion_upper,
  negative_fitted_pre=a$negative_fitted_bins,negative_fitted_post=b$negative_fitted_bins,
  n_in_range_pre=a$n_in_range,n_in_range_post=b$n_in_range,
  inference_status=if(!is.finite(v[1]))'invalid_point' else if(s$bootstrap_valid<.9*B)'unreliable_below_90pct' else if(s$bootstrap_valid<B)'conditional_on_valid_draws' else 'all_draws_valid')
 record('grid',paste0('spec_',grid_input$specification_index[i]),'all','delta_b','post_minus_pre',v,post,benchmark=pre,
  extras=list(specification_index=grid_input$specification_index[i],
   window_obs=grid[[i]]$window_obs_post,window_firms=grid[[i]]$window_firms_post,
   benchmark_window_obs=grid[[i]]$window_obs_pre,benchmark_window_firms=grid[[i]]$window_firms_pre))
}
grid <- do.call(rbind,grid);csv(grid,'grid')
gs <- list()
for(dimension in c('all','bin_width','exclusion_window','degree','fit_range')) {
 values <- switch(dimension,all=rep('all',nrow(grid)),exclusion_window=paste(grid$exclusion_lower,grid$exclusion_upper,sep=':'),
  fit_range=paste(grid$fit_lower,grid$fit_upper,sep=':'),as.character(grid[[dimension]]))
 for(value in unique(values)) {
  z <- grid[values==value,];valid_delta <- is.finite(z$delta_b);vv <- z$delta_b[valid_delta]
  gs[[length(gs)+1L]] <- data.frame(dimension=dimension,value=value,specifications=nrow(z),valid_points=sum(valid_delta),
  share_delta_positive=sum(z$delta_positive)/nrow(z),share_CI_above_zero=sum(z$CI_above_zero)/nrow(z),
  min=if(length(vv))min(vv) else NA,median=if(length(vv))median(vv) else NA,max=if(length(vv))max(vv) else NA,
  min_001=min(z$delta_b_in_001_bins,na.rm=TRUE),median_001=median(z$delta_b_in_001_bins,na.rm=TRUE),max_001=max(z$delta_b_in_001_bins,na.rm=TRUE))
 }
}
gs <- do.call(rbind,gs);csv(gs,'grid_summary')
tex('grid',c('Dimension','Value','Fits','Positive','CI above 0','Min','Median','Max'),
 vapply(seq_len(nrow(gs)),function(i) {z<-gs[i,];texrow(c(gsub('_',' ',z$dimension),z$value,z$specifications,
 fmt(z$share_delta_positive),fmt(z$share_CI_above_zero),fmt(z$min_001),fmt(z$median_001),fmt(z$max_001)))},character(1)),
 'llrrrrrr',paste('Main sample; pre 2017H1--2019H2, post 2020H2--2022H2. 999 joint whole-firm draws; seed 20261016.',
 'All 72 T031 specifications vary bin width (0.005, 0.01, 0.02), exclusion window, polynomial degree and fit range as shown.',
 'Window counts in the CSV refer to each realized exclusion window. Shares use all fits as denominator, including invalid fits as unsupported.',
 'Min/Median/Max are rescaled to 0.01-bin units (native b times bin width / 0.01); native units appear only in CSV. No multiple-testing adjustment.'),chunk=100L)

# 8. Existing build uses the SUM of both advance components at every date.
std_medians <- list()
for(market in c('A','HK'))for(date in dates) {
 use <- d$market==market&d$date==date&is.finite(d$ta)&d$ta>0&is.finite(d$adv)
 period <- as.character(as.Date(date,origin='1970-01-01'))
 record('standard','adv_ta_by_date',market,'median_adv_ta',period,stat(d$adv/d$ta,use,kind='median'),use,
 extras=list(n=sum(use),firms=nf(d$firm_id[use]),
 advance_missing_imputed=sum(use&d$adv_missing),adv_components='advance receipts + contract liabilities at all dates',
 A_eastmoney=if(market=='A')'ADVANCE_RECEIVABLES + CONTRACT_LIAB' else '预收款项 + 合同负债',
 A_wind=if(market=='A')'预收账款 + 合同负债' else '预收款项 + 合同负债',
 sum_rule='partial sums: missing component zero if another observed; all missing adv=0 with adv_missing flag'))
}
markets <- lapply(c('HK','A'),function(m)change('standard','market_split',m,pre&d$market==m,post&d$market==m))
contrast('standard','market_split','HK_minus_A',markets[[1]],markets[[2]])
csv(data.frame(market=c('A','A','HK'),period=c('before_2020','2020_onward','all_dates'),
 source=c('01_clean.R maps$a_em / maps$a_wind','01_clean.R maps$a_em / maps$a_wind','01_clean.R maps$hk_em / maps$hk_wind'),
 components=c('ADVANCE_RECEIVABLES + CONTRACT_LIAB; Wind 预收账款 + 合同负债',
 'ADVANCE_RECEIVABLES + CONTRACT_LIAB; Wind 预收账款 + 合同负债','预收款项 + 合同负债'),
 rule='sum both available components; all missing -> 0 with adv_missing=TRUE',
 qualification='existing harmonization, no year-specific splice; component-level vintages not independently validated here; standard timing supplied by T058, not independently source-verified'), 'standard_mapping')

# Rework additions follow the original rows to preserve their stable row IDs.
# 3. Joint normalized-D differences, and their post-minus-placebo changes.
for(other in c('parent_equity','MI_and_parent_equity')) {
 vv <- list();uses <- list()
 for(p in c('post','placebo')) {
  a <- sym_results[[paste(p,'MI')]];b <- sym_results[[paste(p,other)]]
  vv[[p]] <- a$norm-b$norm;uses[[p]] <- list(a=a$use,b=b$use)
  record('symmetric',paste0('MI_minus_',other),'paired','difference_normalized_D',p,vv[[p]],a$use,R,
   benchmark=b$use,benchmark_x=R,
   extras=list(anchor=if(p=='post')'2019-12-31' else '2016-12-31',
    normalization='difference of 100*D / median(100*(item_t-item_anchor)/ta_anchor); same joint W draws'))
 }
 # All four populations are reported: post/benchmark via record, placebo via extras.
 record('symmetric',paste0('MI_minus_',other),'paired','difference_in_difference_normalized_D',
  'post_minus_placebo',vv$post-vv$placebo,uses$post$a,R,benchmark=uses$post$b,benchmark_x=R,
  extras=list(first_pre_n=sum(uses$placebo$a),first_pre_firms=nf(d$firm_id[uses$placebo$a]),
   first_pre_window_obs=sum(uses$placebo$a&window(R)),first_pre_window_firms=nf(d$firm_id[uses$placebo$a&window(R)]),
   second_pre_n=sum(uses$placebo$b),second_pre_firms=nf(d$firm_id[uses$placebo$b]),
   second_pre_window_obs=sum(uses$placebo$b&window(R)),second_pre_window_firms=nf(d$firm_id[uses$placebo$b&window(R)]),
   normalization='(MI minus comparator normalized D) post minus placebo; same joint W draws'))
}
# 6. Matching below and total mass from the same excluded-region fit.
for(a in above_extra) {
 z <- a$z
 record('above',paste0('070_',sprintf('%03d',round(a$upper*100))),'all',paste0(a$region,'_excess_b'),a$p,
  z$v,a$use,extras=c(list(above_lower=.70,above_upper=a$upper,sign='negative means missing mass',
   normalization='own evaluated-region mean fitted count per bin',window_obs=z$obs,window_firms=z$mass_firms),
   z[setdiff(names(z),c('v','n','firms'))]))
}
# 8. Exclude all imputed-zero adv observations, preserving every other rule.
for(market in c('A','HK'))for(date in dates) {
 candidate <- d$market==market&d$date==date&is.finite(d$ta)&d$ta>0&is.finite(d$adv)
 use <- candidate&!d$adv_missing
 period <- as.character(as.Date(date,origin='1970-01-01'))
 record('standard','adv_ta_by_date_no_imputed_zero',market,'median_adv_ta',period,
  stat(d$adv/d$ta,use,kind='median'),use,
  extras=list(advance_missing_imputed=sum(candidate&d$adv_missing),
   adv_components='advance receipts + contract liabilities at all dates',
   A_eastmoney=if(market=='A')'ADVANCE_RECEIVABLES + CONTRACT_LIAB' else '预收款项 + 合同负债',
   A_wind=if(market=='A')'预收账款 + 合同负债' else '预收款项 + 合同负债',
   sum_rule='exclude adv_missing=TRUE observations; partial sums otherwise retained'))
}
markets_nozero <- lapply(c('HK','A'),function(m)change('standard','market_split_no_imputed_zero',m,
 pre&d$market==m&!d$adv_missing,post&d$market==m&!d$adv_missing))
contrast('standard','market_split_no_imputed_zero','HK_minus_A',markets_nozero[[1]],markets_nozero[[2]])
imputed_note <- paste(vapply(c('A','HK'),function(m)paste0(m,': ',paste(vapply(
 list(pre=pre,post=post,excluded_2016H2_or_2020H1=!pre&!post),function(u)
 paste0(sum(u&d$market==m&d$adv_missing),'/',sum(u&d$market==m)),character(1)),collapse=', ')),character(1)),collapse='; ')

all_rows <- bind(rows);all_draws <- bind(draws)
# Direct changes and cross-group changes flag small contributing cells in EITHER period.
ix <- all_rows$metric=='difference_in_delta_b'
all_rows$small_cell[ix] <- all_rows$small_cell[ix]|
 all_rows$first_pre_window_firms[ix]<15L|all_rows$second_pre_window_firms[ix]<15L
# Flag zero-window point cells AND bootstrap draws explicitly. In the latter
# case the original cell can still contain observations (end-2020 has one).
for(i in which(all_rows$table=='pilot'&all_rows$metric=='b')) {
 z <- draws[[i]]$estimate;zero_draws <- sum(is.finite(z)&abs(z+4)<1e-10)
 if(all_rows$window_obs[i]==0L||zero_draws>0L)
  all_rows$inference_status[i] <- paste0(all_rows$inference_status[i],
   '; zero_window_point=',all_rows$window_obs[i]==0L,'; zero_window_draws=',zero_draws,
   '; bounded_CI_not_informative')
}
stopifnot(!anyDuplicated(all_rows[c('table','variant','group','metric','period')]),nrow(all_draws)==nrow(all_rows)*B)
table_notes <- list(
 pilot='Exactly the supplied pilot IDs; Seazen substitution only in its named sensitivity. The other Seazen entity is excluded from controls: 601155.SH in main/complete variants, 1030.HK in the A-share sensitivity. Complete-pilot sensitivity excludes incomplete pilots rather than assigning them to controls. B flags b cells with zero-window point observations or bootstrap draws (counts in CSV inference-status): their percentile CIs are bounded by construction at b = -4 (minus the number of mass bins) and are not informative. Period timing cannot separate anticipation from other concurrent sector shocks.',
 notch='Classification uses finite RL2 and RL3 at the SAME firm-date: both met means RL2 <=1 and RL3 >=1. T043 instead used fixed 2020H1 classes. A firm can change group over time; compositional change limits interpretation.',
 symmetric='Freeze at end-2019 (post) or end-2016 (placebo 2017H2--2019H2). N=tl-adv, E=te. Equity freeze: N/(N+E-item+anchor); debt freeze: (N-debt+anchor)/(N+E-debt+anchor). Debt=std+ltd+notes+lease, equal to ibd-ext, partial sums as in panel. Valid reported N,E positive; frozen total denominator positive. Negative growth and nonpositive frozen numerator retained. Parent equity includes unresolved perpetuals. Normalize 100D by median growth as percent of OWN anchor total assets; zero median is undefined. MI minus parent and MI minus joint-freeze differences, and post-minus-placebo differences of these contrasts, use the SAME joint W draws, retaining undefined draws as failed. Different eligibility exclusions, all four difference-in-differences populations and growth support are in CSV. Constant within-firm currency is assumed.',
 attrition='Balanced means finite RL1 at each of 13 dates, or each of 11 pre/post dates excluding 2016H2 and 2020H1. Exiting: last financial row on or after 2021H1 and before 2022H2; continuing: financial row at 2022H2; last finite RL1 used. Earlier exits excluded from distribution comparison. Histogram shares include out-of-range ratios in denominator. Fisher exact two-sided test for equal near-threshold shares in CSV. LOCF fills only terminal exit dates through 2022H2, never internal gaps; a sensitivity scenario, not an identified numerical bound.',
 above='For each upper bound, exclude [0.66,upper) from the polynomial fit. Below [0.66,0.70), above [0.70,upper) and total [0.66,upper) mass use this SAME counterfactual and own-region mean fitted counts per bin; b values therefore need not add. Window N (firms) refers to the evaluated region. Negative means missing mass. No integration correction; earlier fit-includes-evaluated-bins rows are dropped.',
 standard=paste('adv sums advance receipts and contract liabilities before AND after 2020; no year-specific splice. HK maps use advance receipts plus contract liabilities for both sources; legacy source-column names A-eastmoney/A-wind describe sources for the row market. Baseline retains imputed-zero adv; no-imputed-zero variants exclude adv-missing firm-dates. Imputed-zero counts / all main-sample rows by market (pre, post, excluded 2016H2 or 2020H1):',imputed_note,
 '. By-date counts in CSV; missing counts in sensitivity rows identify excluded baseline observations. HK versus A split is descriptive, with different firm composition and reporting calendars. Standard-adoption timing is supplied by T058 and not independently source-verified offline.'))
for(name in c('pilot','notch','symmetric','attrition','window','above','standard')) {
 z <- all_rows[all_rows$table==name,];csv(z,name)
 if(name!='window') {
  ntext <- function(a,b)ifelse(is.na(b),as.character(a),paste(a,b,sep='/'))
  labels <- paste(gsub('_',' ',z$variant),gsub('_',' ',z$group),gsub('_',' ',z$metric),gsub('_',' ',z$period),sep=' / ')
  tex(name,c('Cell / statistic / period','N','Firms','Window N (firms)','Estimate','95\\% CI','S'),
   vapply(seq_len(nrow(z)),function(i)texrow(c(labels[i],ntext(z$n[i],z$benchmark_n[i]),
    ntext(z$firms[i],z$benchmark_firms[i]),paste0(ntext(z$window_obs[i],z$benchmark_window_obs[i]),' (',
    ntext(z$window_firms[i],z$benchmark_window_firms[i]),')'),fmt(z$estimate[i]),
    paste0('[',fmt(z$ci_low[i]),', ',fmt(z$ci_high[i]),']'),paste0(if(z$small_cell[i])'S' else '',
     if(name=='pilot'&&grepl('bounded_CI_not_informative',z$inference_status[i]))'B' else ''))),character(1)),
   'p{5.7cm}rrrrrl',paste(if(name=='above')sub('excluding [0.66,0.70).','excluding the full [0.66,upper) region.',common,fixed=TRUE) else common,
    'Contrasts list first/benchmark populations; delta rows list post/pre.',
    if(name=='attrition')'Window counts are the respective histogram bin for bin-share rows, otherwise [0.66,0.70).' else
    if(name=='above')'Window counts use the evaluated mass region.' else 'Window is [0.66,0.70).',table_notes[[name]]))
 }
}
csv(all_draws,'bootstrap_draws')
ledger <- all_rows[,c('row_id','table','variant','group','metric','period','estimate','n','firms','window_obs','window_firms')]
ledger$file <- paste0('replication/outputs/tables/t058_',ledger$table,'.csv')
ledger$file[ledger$table=='grid'] <- 'replication/outputs/tables/t058_grid.csv'
ledger$filter <- paste0('variant=',ledger$variant,'; group=',ledger$group,'; metric=',ledger$metric,'; period=',ledger$period)
ledger$filter[ledger$table=='grid'] <- paste0('specification_index=',all_rows$specification_index[all_rows$table=='grid'],'; column=delta_b')
csv(ledger,'number_map')

# 9. One generated interpretation paragraph per step; every estimate is traceable
# to the long-format number map rather than manually transcribed into prose.
pick <- function(table,variant,group,metric,period) {
 z <- all_rows[all_rows$table==table&all_rows$variant==variant&all_rows$group==group&
  all_rows$metric==metric&all_rows$period==period,]
 stopifnot(nrow(z)==1L);z
}
desc <- function(z)paste0(fmt(z$estimate),' [',fmt(z$ci_low),', ',fmt(z$ci_high),']')
pp <- pick('pilot','main','pilot','delta_b','post_minus_pre')
pn <- pick('pilot','main','nonpilot','delta_b','post_minus_pre')
pd <- pick('pilot','main','pilot_minus_nonpilot','difference_in_delta_b','post_minus_pre')
pt <- pick('pilot','main','pilot','b','2020-12-31')
nt <- pick('notch','contemporaneous_other_lines','both_met_minus_breached','difference_in_delta_b','post_minus_pre')
sm <- pick('symmetric','MI','paired','D_pp_per_growth_pp_assets','post')
sp <- pick('symmetric','parent_equity','paired','D_pp_per_growth_pp_assets','post')
sb <- pick('symmetric','MI','paired','D_pp_per_growth_pp_assets','placebo')
pb <- pick('symmetric','parent_equity','paired','D_pp_per_growth_pp_assets','placebo')
sdiff <- pick('symmetric','MI_minus_parent_equity','paired','difference_normalized_D','post')
spdiff <- pick('symmetric','MI_minus_parent_equity','paired','difference_normalized_D','placebo')
sdd <- pick('symmetric','MI_minus_parent_equity','paired','difference_in_difference_normalized_D','post_minus_placebo')
sj <- pick('symmetric','MI_minus_MI_and_parent_equity','paired','difference_normalized_D','post')
sjp <- pick('symmetric','MI_minus_MI_and_parent_equity','paired','difference_normalized_D','placebo')
sjd <- pick('symmetric','MI_minus_MI_and_parent_equity','paired','difference_in_difference_normalized_D','post_minus_placebo')
ba <- pick('attrition','balanced_13_dates','all','delta_b','post_minus_pre')
lc <- pick('attrition','terminal_exit_LOCF','all','delta_b','post_minus_pre')
ww <- pick('window','2020h1_added_to_pre','all','delta_b','post_minus_pre')
wh <- pick('window','2020h1_only','all','b','2020-06-30')
aa <- pick('above','070_074','all','above_excess_b','post')
abv <- pick('above','070_080','all','above_excess_b','post')
hk <- pick('standard','market_split','HK','delta_b','post_minus_pre')
am <- pick('standard','market_split','A','delta_b','post_minus_pre')
hd <- pick('standard','market_split','HK_minus_A','difference_in_delta_b','post_minus_pre')
hkn <- pick('standard','market_split_no_imputed_zero','HK','delta_b','post_minus_pre')
amn <- pick('standard','market_split_no_imputed_zero','A','delta_b','post_minus_pre')
hdn <- pick('standard','market_split_no_imputed_zero','HK_minus_A','difference_in_delta_b','post_minus_pre')
interpretations <- c(
 paste0('Pilot delta b is ',desc(pp),' versus ',desc(pn),' for nonpilots; their difference is ',desc(pd),
 '. Only ',pp$window_firms,' pilot firms contribute post-window observations (',pp$window_obs,
 ' firm-dates). Pilot b at end-2020 is ',desc(pt),
 '. The other Seazen entity is excluded from controls: main control pre/post N=',pn$benchmark_n,'/',pn$n,
 ' and firms=',pn$benchmark_firms,'/',pn$firms,
 '. Earlier pilot concentration is not demonstrated, and wide intervals cannot establish identical timing or sector-wide anticipation. Zero-window pilot cells have construction-bounded, uninformative percentile CIs. All 11 pilots have complete RL1 histories, so that sensitivity coincides with the main pilot list; substituting the A-share Seazen entity is separately reported. The exposure dates are supplied assumptions, not independently verified here.'),
 paste0('The difference in delta b, both other lines met minus at least one breached, is ',desc(nt),
 '. This does not support the predicted larger increase in the largest-gain group; its interval includes zero. Classes use contemporaneous RL2/RL3 as explicitly requested by T058, so firms can switch class and compositional changes remain a limitation. Unclassified firm-dates are excluded and counted.'),
 paste0('Post D per median growth percentage point of anchor assets is ',desc(sm),' for MI and ',desc(sp),
 ' for parent equity. The corresponding placebo values are ',
 desc(sb),' and ',desc(pb),
 '. Joint-bootstrap MI minus parent differences are ',desc(sdiff),' post and ',desc(spdiff),' placebo, with post minus placebo ',desc(sdd),
 '. MI minus joint-freeze differences are ',desc(sj),' post and ',desc(sjp),' placebo, with post minus placebo ',desc(sjd),
 '. A positive difference whose interval excludes zero supports the pre-specified relative-MI comparison within that period; the post-minus-placebo contrast assesses whether this relative difference increased. These are nonlinear accounting comparisons, without disguised-debt identification. Debt freezes have additional eligibility losses, and all anchors, signed growth and undefined normalization draws remain visible.'),
 paste0('Both balanced definitions retain ',ba$firms,' firms and give delta b ',desc(ba),
 '; terminal-exit LOCF gives ',desc(lc),'. The near-window last-observation shares are ',fmt(exshare[1]),
 ' for ',attr_n_exit,' exiting firms and ',fmt(coshare[1]),' for ',attr_n_continue,
 ' continuing firms, with Fisher two-sided p=',fmt(if(is.null(ft))NA_real_ else ft$p.value),
 '. These checks do not overturn the positive main change, but the small exit group limits power. LOCF is a specified attrition scenario, not a mathematical bound on the unknown nonlinear statistic.'),
 paste0('The existing rule is: ',rule,'. README states: ',readme_rule,
 '. June 2020 is therefore excluded mechanically; neither source supplies a separate substantive explanation. June-only b is ',
 desc(wh),'; adding June 2020 to pre yields delta b ',desc(ww),
 '. This checks the specified calendar exclusion without attributing it to verified anticipation or policy exposure.'),
 paste0('After excluding [0.66,upper) from fitting, post observed-minus-counterfactual mass above 0.70 is ',desc(aa),
 ' in [0.70,0.74) and ',desc(abv),' in [0.70,0.80). ',
 paste(vapply(c('pre','post'),function(p)paste(vapply(c(.74,.80),function(u) {
  variant <- paste0('070_',sprintf('%03d',round(u*100)))
  paste0(p,' upper=',u,': below ',desc(pick('above',variant,'all','below_excess_b',p)),
   ', above ',desc(pick('above',variant,'all','above_excess_b',p)),
   ', total ',desc(pick('above',variant,'all','total_excess_b',p)),'.')
 },character(1)),collapse=' '),character(1)),collapse=' '),
 ' Each triple uses one fit; each b is normalized within its own evaluated region. Negative above values indicate missing mass; intervals containing zero do not demonstrate missing mass. No supported missing mass is consistent with imprecise ratio control or a diffuse response, but does not establish either mechanism. Smooth density over the excluded region remains an assumption.'),
 paste0('All ',nrow(grid),' specified changes are reported; ',sum(grid$delta_positive),'/72 are positive and ',
 sum(grid$CI_above_zero),'/72 have a reliable pointwise 95 percent CI above zero. Comparable 0.01-bin min/median/max are ',
 fmt(min(grid$delta_b_in_001_bins)), '/',fmt(median(grid$delta_b_in_001_bins)),'/',fmt(max(grid$delta_b_in_001_bins)),
 '. These are correlated sensitivity checks, without multiplicity adjustment. Window counts follow the actual exclusion window; native-bin values remain in CSV.'),
 paste0('The build sums advance receipts and contract liabilities at every date for A shares, before and after 2020; it does not splice columns at adoption. The by-date advance/asset medians retain this rule and its missingness flags. HK delta b is ',
 desc(hk),' and A-share delta b is ',desc(am),'; HK minus A is ',desc(hd),
 '. Excluding imputed-zero adv observations gives HK ',desc(hkn),', A ',desc(amn),', and HK minus A ',desc(hdn),
 '. Imputed-zero counts / all rows (pre, post, excluded dates) are ',imputed_note,
 '. The positive HK change shows the pooled result is not confined to mainland filers, but market composition and reporting calendars prevent a causal accounting-standard interpretation. HK adoption precedes the policy but occurs within the full 2017--2019 pre window; it is not absent from the entire estimation window. Adoption dates are supplied by T058, not verified offline.')
)
csv(data.frame(step=seq_len(8L),table=paste0('t058_',c('pilot','notch','symmetric','attrition','window','above','grid','standard'),'.csv'),
 interpretation=interpretations,number_to_file_filter='t058_number_map.csv: table plus variant/group/metric/period; grid: specification_index'), 'interpretation')

# Vector PDF metadata exclude timestamps for exact reproducibility.
pdf_start <- function(name,width,height) {
 f <- tempfile(fileext='.pdf');grDevices::pdf(f,width=width,height=height,useDingbats=FALSE,timestamp=FALSE,title=paste('T058',name))
 stage(f,paste0('outputs/figures/t058_',name,'.pdf'))
}
pdf_start('attrition',8,4.8)
ab <- do.call(rbind,abin);aa <- ab[ab$group=='exiting_after_2021h1',];bb <- ab[ab$group=='continuing',]
par(mar=c(5,4,3,1))
plot((aa$lower+aa$upper)/2,aa$share,type='b',pch=16,col='#B44E31',ylim=range(c(0,aa$share,bb$share),finite=TRUE),
 xlab='Last observed RL1 (0.05 bins)',ylab='Share of firms with finite last RL1',main='Terminal exits after 2021H1 and continuing firms')
lines((bb$lower+bb$upper)/2,bb$share,type='b',pch=17,col='#245B85');abline(v=.7,lty=3)
legend('topright',c(sprintf('Exiting: %d firms',attr_n_exit),sprintf('Continuing: %d firms',attr_n_continue)),
 col=c('#B44E31','#245B85'),pch=c(16,17),lty=1,bty='n')
mtext(sprintf('Near-window share: %.3f vs %.3f; Fisher p = %.3f. Shares include out-of-range denominators.',exshare[1],coshare[1],if(is.null(ft))NA_real_ else ft$p.value),side=1,line=4,cex=.7)
invisible(dev.off())
pdf_start('grid',8.3,8)
o <- order(grid$delta_b,na.last=TRUE);z <- grid[o,];idx <- seq_len(nrow(z))
par(mfrow=c(2,1),mar=c(4,4,3,1))
plot(idx,z$delta_b,pch=16,cex=.55,ylim=range(c(z$ci_low,z$ci_high),finite=TRUE),xlab='Specification sorted by change',ylab='Post minus pre b (native bin units)',main='All 72 pre-specified changes with pointwise 95% CIs')
segments(idx,z$ci_low,idx,z$ci_high,col='#245B85');points(idx,z$delta_b,pch=16,cex=.55);abline(h=0,lty=3)
scaled <- z$bin_width/.01
plot(idx,z$delta_b_in_001_bins,pch=16,cex=.55,ylim=range(c(z$ci_low*scaled,z$ci_high*scaled),finite=TRUE),xlab='Same specification order',ylab='Change in units of 0.01 bins',main='Comparable units across bin widths')
segments(idx,z$ci_low*scaled,idx,z$ci_high*scaled,col='#245B85');points(idx,z$delta_b_in_001_bins,pch=16,cex=.55);abline(h=0,lty=3)
invisible(dev.off())

# Gates: exact coverage plus protection of every read-only input and old output.
stopifnot(sum(all_rows$table=='pilot')==39L,sum(all_rows$table=='notch')==7L,
 sum(all_rows$table=='symmetric')==62L,sum(all_rows$table=='attrition')==39L,
 sum(all_rows$table=='window')==4L,sum(all_rows$table=='above')==12L,
 sum(all_rows$table=='grid')==72L,sum(all_rows$table=='standard')==66L,
 identical(input_hash,tools::sha256sum(inputs)),identical(protected_hash,tools::sha256sum(protected)))
csv(data.frame(kind=c(rep('input',length(inputs)),rep('protected_output',length(protected))),
 file=c(inputs,protected),sha256=c(unname(input_hash),unname(protected_hash)),unchanged=TRUE),'verification')
targets <- vapply(staged,`[[`,character(1),'target')
ver <- 'outputs/tables/t058_verification.csv';sv <- staged[[match(ver,targets)]][['path']]
same_context <- file.exists(ver)&&identical(unname(tools::sha256sum(sv)),unname(tools::sha256sum(ver)))
if(all(file.exists(targets))&&same_context) {
 same <- vapply(staged,function(z)identical(unname(tools::sha256sum(z['path'])),unname(tools::sha256sum(z['target']))),logical(1))
 if(!all(same))stop('STOP: repeated-run output differs: ',paste(targets[!same],collapse=', '))
 cat(sprintf('T058 repeat-run PASS: %d/%d outputs byte-identical.\n',sum(same),length(same)))
}
for(z in staged)stopifnot(file.copy(z['path'],z['target'],overwrite=TRUE))
unlink(vapply(staged,`[[`,character(1),'path'))
cat(sprintf('T058 grid: positive %d/72; CI above zero %d/72; min/median/max %.6f / %.6f / %.6f.\n',
 sum(grid$delta_positive),sum(grid$CI_above_zero),min(grid$delta_b,na.rm=TRUE),median(grid$delta_b,na.rm=TRUE),max(grid$delta_b,na.rm=TRUE)))
cat(sprintf('T058 guards PASS: %d inputs and %d old outputs byte-identical.\n',length(inputs),length(protected)))
cat(sprintf('T058 coverage PASS: %d estimates; %d bootstrap draws; 72 grid specifications.\n',nrow(all_rows),nrow(all_draws)))
cat(sprintf('T058 complete: %d CSV/TEX/PDF files; seed=%d; bootstrap=%d.\n',length(staged),seed,B))
