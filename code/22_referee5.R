# T063: offline referee round 5. Run: cd replication && Rscript code/22_referee5.R
# No upstream script is sourced: extract only the named pure T061 functions.
options(digits=17)
seed <- 20261016L; B <- 999L; S <- 1000L; set.seed(seed)
read <- function(p,...) read.csv(p,stringsAsFactors=FALSE,na.strings=c('','NA','--'),...)
upstream <- parse('code/21_diff_bunching.R')
reuse <- c('nf','period_masks','weights','mass','change','ci')
for(name in reuse) {
 hit <- vapply(upstream,function(e)is.call(e)&&identical(e[[1]],as.name('<-'))&&
  identical(e[[2]],as.name(name)),logical(1))
 stopifnot(sum(hit)==1L);eval(upstream[[which(hit)]])
 stopifnot(is.function(get(name)))
}
inputs <- unique(c('code/22_referee5.R','code/21_diff_bunching.R','code/20_referee4.R',
 'code/06_bunching_tests.R','data/processed/panel_firm_halfyear.csv',
 'outputs/tables/t040_matched_observations.csv','outputs/tables/t031_samples.csv',
 'outputs/tables/t058_above.csv','outputs/tables/t058_attrition.csv',
 'outputs/tables/t058_standard.csv','outputs/tables/t058_bootstrap_draws.csv',
 'outputs/tables/t004_panel_counts.csv',list.files('outputs/tables','^t061_',full.names=TRUE),
 '../state/litsearch/prisma_counts.csv','../state/litsearch/search_log.csv',
 '../state/litsearch/screening.xlsx','run_all.R','run_all.sh','README.md'))
stopifnot(all(file.exists(inputs)))
input_hash <- tools::sha256sum(inputs)
protected <- list.files('outputs',recursive=TRUE,full.names=TRUE,all.files=TRUE)
protected <- protected[!dir.exists(protected)&!grepl('^t063_',basename(protected))]
protected_hash <- tools::sha256sum(protected)
# Protect all raw files, including manual inputs, without reading them into analysis.
rawfiles <- list.files('data/raw',recursive=TRUE,full.names=TRUE,all.files=TRUE)
rawfiles <- rawfiles[!dir.exists(rawfiles)];raw_hash <- tools::sha256sum(rawfiles)
staged <- list(); tables <- list()
stage <- function(f,target) {
 stopifnot(grepl('^outputs/(tables|figures)/t063_',target))
 staged[[length(staged)+1L]] <<- c(path=f,target=target)
}
csv <- function(z,name,map=TRUE) {
 f<-tempfile(fileext='.csv');con<-file(f,'wb')
 write.csv(z,con,row.names=FALSE,na='NA',eol='\n');close(con)
 stage(f,paste0('outputs/tables/t063_',name,'.csv'))
 if(map)tables[[name]] <<- z
}
textout <- function(z,name,ext='tex') {
 f<-tempfile(fileext=paste0('.',ext));writeLines(z,f,useBytes=TRUE)
 stage(f,paste0('outputs/tables/t063_',name,'.',ext))
}
bind <- function(xs) {
 cols<-unique(unlist(lapply(xs,names)))
 do.call(rbind,lapply(xs,function(z){for(n in setdiff(cols,names(z)))z[[n]]<-NA;z[cols]}))
}
fmt <- function(x)ifelse(is.finite(x),sprintf('%.3f',x),'--')
esc <- function(x)gsub('_','\\_',x,fixed=TRUE)
texrow <- function(x)paste0(paste(x,collapse=' & '),' \\\\')
tex <- function(name,header,rows,align,note,chunk=18L) {
 lines<-c('\\begingroup\\small','\\setlength{\\tabcolsep}{3.5pt}')
 for(ix in split(seq_along(rows),ceiling(seq_along(rows)/chunk)))
  lines<-c(lines,paste0('\\begin{tabular}{',align,'}'),'\\toprule',texrow(header),
   '\\midrule',rows[ix],'\\bottomrule','\\end{tabular}','\\par\\medskip')
 textout(c(lines,paste0('\\footnotesize ',note),'\\endgroup'),name)
}
pdf_start <- function(name,width,height) {
 f<-tempfile(fileext='.pdf');pdf(f,width=width,height=height,pointsize=11,
  useDingbats=FALSE,timestamp=FALSE,title=paste('T063',name))
 stage(f,paste0('outputs/figures/t063_',name,'.pdf'))
}

all_panel <- read('data/processed/panel_firm_halfyear.csv')
d <- all_panel[!is.na(all_panel$sample_main)&all_panel$sample_main,]
d$date<-as.Date(d$date);d<-d[order(d$firm_id,d$date),];rownames(d)<-NULL
dates<-sort(unique(d$date));stopifnot(length(dates)==13L,!anyDuplicated(d[c('firm_id','date')]))
cp<-read('outputs/tables/t061_control_panel.csv',colClasses=c(code='character'))
cp$date<-as.Date(cp$date);cp<-cp[cp$date%in%dates,];cp<-cp[order(cp$firm_id,cp$date),]
stopifnot(!anyDuplicated(cp[c('firm_id','date')]),!any(cp$firm_id%in%all_panel$firm_id))
balanced_ids<-sort(unique(d$firm_id))[vapply(sort(unique(d$firm_id)),function(f)
 sum(d$firm_id==f&is.finite(d$rl1))==13L,logical(1))]
pop<-list(developers_all=d,control_all=cp,developers_balanced=d[d$firm_id%in%balanced_ids,],
 developers_A=d[d$market=='A',],developers_HK=d[d$market=='HK',])
# Draw order deliberately reproduces the T061 strata before any new random operation.
W<-lapply(pop,function(z)weights(sort(unique(z$firm_id))))
base<-lapply(names(pop),function(g)change(pop[[g]],W[[g]]));names(base)<-names(pop)
stopifnot(round(base$developers_all$delta[1],2)==4.02,
 round((base$developers_all$delta-base$control_all$delta)[1],2)==4.59,
 round((base$developers_balanced$delta-base$control_all$delta)[1],2)==4.48)
ref61<-read('outputs/tables/t061_estimates.csv')
for(g in names(pop)[1:4]) {
 oldg<-switch(g,control_all='control_A_Sina',developers_balanced='developers_balanced_13_dates',g)
 rr<-ref61[ref61$group==oldg&ref61$threshold==.7,]
 stopifnot(nrow(rr)==1L,abs(base[[g]]$delta[1]-rr$delta_b)<1e-10)
}
csv(data.frame(metric=c('developer_delta','all_delta_delta','balanced_delta_delta'),
 estimate=c(base$developers_all$delta[1],(base$developers_all$delta-base$control_all$delta)[1],
 (base$developers_balanced$delta-base$control_all$delta)[1]),
 expected_rounded=c(4.02,4.59,4.48),assert_pass=TRUE),'reproduction')
cat('T063 reproduction PASS: developer delta 4.02; all/balanced contrasts 4.59/4.48.\n')

# Common generalized estimator: same polynomial and invalid-counterfactual rule as T061.
edges<-round(seq(.4,1,.01),10);mid<-(head(edges,-1)+tail(edges,-1))/2
X<-cbind(1,poly(mid,5L))
fit_counts <- function(y,upper=.70,mlo=.66,mhi=.70) {
 y<-as.matrix(y);excluded<-mid>=.66-1e-12&mid<upper-1e-12
 mw<-mid>=mlo-1e-12&mid<mhi-1e-12
 pred<-X%*%qr.coef(qr(X[!excluded,,drop=FALSE]),y[!excluded,,drop=FALSE])
 good<-colSums(!is.finite(pred[mw,,drop=FALSE])|pred[mw,,drop=FALSE]<=0)==0L
 obs<-colSums(y[mw,,drop=FALSE]);cf<-colSums(pred[mw,,drop=FALSE])
 list(v=ifelse(good,(obs-cf)/(cf/sum(mw)),NA_real_),pred=pred,obs=obs,cf=cf,
  mw=mw,excluded=excluded)
}
hist_counts <- function(x) {
 ix<-findInterval(x,edges,rightmost.closed=TRUE)
 tabulate(ix[is.finite(x)&!is.na(ix)&ix>0L&ix<length(edges)],nbins=length(mid))
}
mass_general <- function(z,use,ww,upper=.74,mhi=.70) {
 ids<-sort(unique(z$firm_id));stopifnot(nrow(ww)==length(ids))
 avail<-use&is.finite(z$rl1);ix<-findInterval(z$rl1,edges,rightmost.closed=TRUE)
 inside<-avail&!is.na(ix)&ix>0L&ix<length(edges)
 a<-matrix(0,length(ids),length(mid))
 for(i in which(inside))a[match(z$firm_id[i],ids),ix[i]]<-a[match(z$firm_id[i],ids),ix[i]]+1
 y<-t(a)%*%ww;f<-fit_counts(y,upper,.66,mhi)
 win<-avail&z$rl1>=.66&z$rl1<mhi
 fitout<-avail&z$rl1>=.66&z$rl1<upper
 list(v=f$v,n=sum(avail),firms=nf(z$firm_id[avail]),candidate_n=sum(use),missing=sum(use&!avail),
  range_n=sum(inside),outside_n=sum(avail&!inside),window_obs=sum(win),window_firms=nf(z$firm_id[win]),
  exclusion_obs=sum(fitout),exclusion_firms=nf(z$firm_id[fitout]),low_support=sum(win)<30L,
  observed_mass=f$obs[1],fitted_mass=f$cf[1],negative_fitted_bins=sum(f$pred[,1]<0),
  zero_window_draws=sum(colSums(y[f$mw,-1,drop=FALSE])==0),
  observed=y[,1],fitted=f$pred[,1],excluded=f$excluded,mass_window=f$mw)
}
change_general <- function(z,ww,upper=.74,mhi=.70) {
 masks<-period_masks(z);a<-mass_general(z,masks$pre,ww,upper,mhi)
 b<-mass_general(z,masks$post,ww,upper,mhi);list(pre=a,post=b,delta=b$v-a$v)
}
# Independent point validation with hist/lm/predict, including eight-bin mass.
validation_error<-0
for(g in names(pop))for(p in c('pre','post'))for(up in c(.70,.74))for(hi in unique(c(.70,up))) {
 use<-period_masks(pop[[g]])[[p]];x<-pop[[g]]$rl1[use];x<-x[is.finite(x)&x>=.4&x<=1]
 h<-hist(x,breaks=edges,right=FALSE,include.lowest=TRUE,plot=FALSE)
 q<-data.frame(mid=mid,count=h$counts);out<-mid>=.66&mid<up;mw<-mid>=.66&mid<hi
 pred<-predict(lm(count~poly(mid,5),data=q[!out,]),newdata=q)
 manual<-(sum(q$count[mw])-sum(pred[mw]))/mean(pred[mw])
 z<-mass_general(pop[[g]],use,W[[g]],up,hi)
 validation_error<-max(validation_error,abs(manual-z$v[1]),max(abs(pred-z$fitted)))
 if(up==.70)stopifnot(abs(z$v[1]-base[[g]][[p]]$v[1])<1e-10)
}
stopifnot(validation_error<1e-10)

# 1. Period-end error calibration, without centering, trimming or manual-source access.
val<-read('outputs/tables/t040_matched_observations.csv')
val<-val[val$ratio=='rl1'&is.finite(val$constructed)&is.finite(val$published),]
epsilon<-val$constructed-val$published
stopifnot(length(epsilon)>1L,max(abs(epsilon-val$error))<1e-12)
probs<-c(0,.025,.05,.25,.5,.75,.95,.975,1)
cal<-data.frame(metric=c('N','firms','mean','SD',paste0('q',probs*100),'normal_mu','normal_sigma'),
 value=c(nrow(val),nf(val$firm_id),mean(epsilon),sd(epsilon),quantile(epsilon,probs,names=FALSE),
 mean(epsilon),sd(epsilon)),source='t040_matched_observations.csv: ratio=rl1; finite constructed and published')
csv(cal,'noise_calibration')
csv(val[c('firm_id','date','constructed','published','error')],'noise_errors')
obmain<-base$developers_all$post$v[1]
abref<-read('outputs/tables/t058_above.csv')
abref<-abref[abref$variant=='070_074'&abref$metric=='above_excess_b'&abref$period=='post',]
obabove<-abref$estimate;stopifnot(length(obabove)==1L,round(obmain,2)==3.14,round(obabove,2)==1.75)
preuse<-period_masks(d)$pre&is.finite(d$rl1);x0<-d$rl1[preuse];id0<-d$firm_id[preuse]
ids0<-sort(unique(id0));fi0<-match(id0,ids0);y0<-hist_counts(x0)
# One targeting draw per real firm per replication; only its eligible observations move.
# Errors are independent across eligible firm-dates. Common uniforms pair all grid cells.
set.seed(seed+1L)
utarget<-matrix(runif(length(ids0)*S),length(ids0),S)
uerror<-matrix(runif(length(x0)*S),length(x0),S)
eps_emp<-matrix(epsilon[pmin(length(epsilon),floor(uerror*length(epsilon))+1L)],length(x0),S)
eps_normal<-matrix(qnorm(uerror,mean(epsilon),sd(epsilon)),length(x0),S)
grid<-expand.grid(pi=seq(0,1,.1),beta=c(0,.01,.02),Delta=c(.05,.10),
 noise=c('empirical','normal','frictionless'),stringsAsFactors=FALSE)
simrows<-simdraws<-simhist<-list()
for(k in seq_len(nrow(grid))) {
 parset<-grid[k,];eligible<-x0>=.70&x0<=round(.70+parset$Delta,10)
 moving<-eligible & (utarget[fi0,,drop=FALSE]<parset$pi)
 err<-switch(parset$noise,empirical=eps_emp,normal=eps_normal,frictionless=matrix(0,length(x0),S))
 # beta=0 denotes the left limit at .70: a numerical 1e-10 interior buffer avoids
 # putting a frictionless target into the ABOVE bin under left-closed histograms.
 target<-.70-parset$beta-if(parset$beta==0)1e-10 else 0
 yy<-matrix(y0,length(mid),S);moved<-colSums(moving)
 nsupport<-below_support<-above_support<-below_firms<-above_firms<-range_support<-numeric(S)
 for(j in seq_len(S)) {
  xx<-x0;xx[moving[,j]]<-target+err[moving[,j],j]
  yy[,j]<-hist_counts(xx);range_support[j]<-sum(yy[,j])
  wb<-xx>=.66&xx<.70;wa<-xx>=.70&xx<.74
  below_support[j]<-sum(wb);above_support[j]<-sum(wa)
  below_firms[j]<-nf(id0[wb]);above_firms[j]<-nf(id0[wa])
 }
 fm<-fit_counts(yy);fa<-fit_counts(yy,.74,.70,.74)
 fb<-fit_counts(yy,.74,.66,.70)
 valid<-is.finite(fm$v)&is.finite(fa$v)
 quant<-function(v,p)if(any(is.finite(v)))unname(quantile(v[is.finite(v)],p)) else NA_real_
 # Matching is descriptive: both observed statistics inside their own 95% simulation
 # ranges. These are NOT simultaneous tests, parameter CIs or a fitted model claim.
 a<-quant(fm$v,c(.025,.975));b<-quant(fa$v,c(.025,.975))
 row<-cbind(data.frame(parameter_id=k),parset,
  data.frame(n_obs=length(x0),n_firms=nf(id0),eligible_obs=sum(eligible),eligible_firms=nf(id0[eligible]),
   simulations=S,valid_main=sum(is.finite(fm$v)),valid_above=sum(is.finite(fa$v)),valid_joint=sum(valid),
   b_mean=mean(fm$v,na.rm=TRUE),b_p025=a[1],b_p975=a[2],
   above_b_mean=mean(fa$v,na.rm=TRUE),above_b_p025=b[1],above_b_p975=b[2],
   wide_below_mean=mean(fb$v,na.rm=TRUE),
   above_excess_count_mean=mean(fa$obs-fa$cf),moved_obs_mean=mean(moved),
   range_obs_mean=mean(range_support),below_obs_mean=mean(below_support),above_obs_mean=mean(above_support),
   below_firms_mean=mean(below_firms),above_firms_mean=mean(above_firms),
   observed_post_b=obmain,observed_above_b=obabove,
   b_mean_error=mean(fm$v,na.rm=TRUE)-obmain,above_mean_error=mean(fa$v,na.rm=TRUE)-obabove,
   both_in_marginal_95=obmain>=a[1]&obmain<=a[2]&obabove>=b[1]&obabove<=b[2],
   mean_excess_both_sides=mean(fb$v,na.rm=TRUE)>0&mean(fa$v,na.rm=TRUE)>0,
   fraction_excess_both_sides=mean(fb$v[valid]>0&fa$v[valid]>0),
   main_exclusion_upper=.70,above_exclusion_upper=.74,above_mass_lower=.70,above_mass_upper=.74))
 simrows[[k]]<-row
 simdraws[[k]]<-data.frame(parameter_id=k,draw=1:S,b=fm$v,above_b=fa$v,wide_below_b=fb$v,
  above_observed=fa$obs,above_fitted=fa$cf,moved_obs=moved,range_obs=range_support,
  below_obs=below_support,above_obs=above_support,below_firms=below_firms,above_firms=above_firms)
 simhist[[k]]<-data.frame(parameter_id=k,mid=mid,mean_count=rowMeans(yy),
  share_all_finite=rowMeans(yy)/length(x0))
}
noise<-do.call(rbind,simrows);csv(noise,'noise')
csv(do.call(rbind,simdraws),'noise_draws',FALSE);csv(do.call(rbind,simhist),'noise_histograms',FALSE)
noise$distance<-sqrt(noise$b_mean_error^2+noise$above_mean_error^2)
best<-function(kind)noise$parameter_id[which.min(ifelse(noise$noise==kind,noise$distance,Inf))]
empbest<-best('empirical');normbest<-best('normal');frbest<-best('frictionless')
# Fourth panel matches the empirical-best policy parameters without errors.
matchfr<-which(noise$noise=='frictionless'&noise$pi==noise$pi[empbest]&
 noise$beta==noise$beta[empbest]&noise$Delta==noise$Delta[empbest])
reps<-c(empbest,normbest,frbest,matchfr)
csv(data.frame(panel=1:4,parameter_id=reps,selection=c('minimum mean-statistic distance: empirical',
 'minimum mean-statistic distance: normal','minimum mean-statistic distance: frictionless',
 'frictionless at empirical-best pi/beta/Delta')),'noise_representatives')
tex('noise',c('Error','$\\pi$','$\\beta$','$\\Delta$','Mean b','Mean above','Both ranges'),
 vapply(seq_len(nrow(noise)),function(i)texrow(c(noise$noise[i],fmt(noise$pi[i]),fmt(noise$beta[i]),
 fmt(noise$Delta[i]),fmt(noise$b_mean[i]),fmt(noise$above_b_mean[i]),
 if(noise$both_in_marginal_95[i])'Yes' else 'No')),character(1)), 'lrrrrrl',
 paste0('All grid cells, including failed matches. 1,000 replications per cell; seed ',seed+1L,
 '. Raw constructed minus published RL1 errors; normal uses their mean and sample SD. ',
 'Both ranges means observed b and above-b fall within their respective marginal 95\\% simulation ranges; ',
 'this is descriptive, not a joint test or parameter confidence set. Full ranges, support and draws in CSVs. ',
 'No-policy distribution fixes all finite pre-policy firm-dates. A Bernoulli targeting indicator is shared within firm; ',
 'only observations in [0.70,0.70+$\\Delta$] move; only movers receive period-end noise. ',
 'Validation discrepancies proxy control errors by assumption; they are not observed behavioral errors.'),chunk=22L)
hh<-do.call(rbind,simhist);obs<-hist_counts(d$rl1[period_masks(d)$post])
pdf_start('noise_shapes',8,6.8)
par(mfrow=c(2,2),mar=c(4.1,4.3,3.4,1),oma=c(3,0,0,0),cex=1,cex.axis=.85,cex.lab=.9)
for(k in reps) {
 rr<-noise[k,];ss<-hh[hh$parameter_id==k,]
 ylim<-max(c(obs/base$developers_all$post$n,ss$share_all_finite))*1.12
 plot(NA,xlim=c(.5,.9),ylim=c(0,ylim),xlab='RL1',ylab='Share of all finite observations',
  main=paste0(rr$noise,': pi=',rr$pi,', beta=',rr$beta,'\nDelta=',rr$Delta,
   '; mean b=',sprintf('%.2f',rr$b_mean),', above=',sprintf('%.2f',rr$above_b_mean)),cex.main=.85)
 rect(mid-.005,0,mid+.005,obs/base$developers_all$post$n,col='#D9E1E8',border='white')
 lines(mid,ss$share_all_finite,col='#A64134',lwd=2);abline(v=.7,lty=3)
 legend('topright',c('Observed post','Simulated mean'),fill=c('#D9E1E8',NA),border=NA,
  lty=c(NA,1),col=c(NA,'#A64134'),bty='n',cex=.72)
}
mtext('0.01 bins; all-finite denominators; no clipping or renormalizing to the displayed range.',1,outer=TRUE,line=1.6,cex=.8)
mtext('Representative cells minimize squared mean-statistic discrepancies; not estimated policy parameters.',1,outer=TRUE,line=.3,cex=.8)
invisible(dev.off())
cat(sprintf('T063 noise: %d cells x %d replications; empirical/normal matching cells %d/%d.\n',
 nrow(noise),S,sum(noise$both_in_marginal_95&noise$noise=='empirical'),sum(noise$both_in_marginal_95&noise$noise=='normal')))

# 2-3. Store every level and contrast, plus all actual-window and exclusion support.
draws<-densities<-list()
support_fields<-c('n','firms','candidate_n','missing','range_n','outside_n','window_obs','window_firms',
 'exclusion_obs','exclusion_firms','low_support','observed_mass','fitted_mass','negative_fitted_bins','zero_window_draws')
record <- function(table,group,control,z,zz=NULL,upper=.74,mhi=.70) {
 v<-if(is.null(zz))z$delta else z$delta-zz$delta
 row<-list(table=table,group=group,control=control,metric=if(is.null(zz))'delta_b' else 'delta_delta_b',
  exclusion_lower=.66,exclusion_upper=upper,mass_lower=.66,mass_upper=mhi,
  bin_width=.01,degree=5L,fit_lower=.4,fit_upper=1,bootstrap_draws=B,seed=seed,
  b_pre=z$pre$v[1],b_post=z$post$v[1],delta_developers_or_group=z$delta[1],
  delta_control=if(is.null(zz))NA_real_ else zz$delta[1],estimate=v[1])
 st<-ci(v[-1]);row<-c(row,st)
 row$inference_status<-if(st$valid<.9*B)'unreliable_below_90pct_valid' else
  if(st$valid<B)'conditional_on_valid_draws' else 'all_draws_valid'
 for(side in c('group','control')) {
  obj<-if(side=='group')z else zz
  if(is.null(obj))next
  for(p in c('pre','post')) {
   for(n in support_fields)row[[paste(side,p,n,sep='_')]]<-obj[[p]][[n]]
   cs<-ci(obj[[p]]$v[-1])
   row[[paste0(side,'_',p,'_ci_low')]]<-cs$ci_low
   row[[paste0(side,'_',p,'_ci_high')]]<-cs$ci_high
  }
 }
 key<-paste(table,group,control,upper,mhi,sep='|')
 draws[[length(draws)+1L]]<<-data.frame(key=key,metric=row$metric,draw=1:B,estimate=v[-1])
 if(is.null(zz))for(p in c('pre','post')) {
  densities[[length(densities)+1L]]<<-data.frame(key=key,period=p,mid=mid,
   observed=z[[p]]$observed,fitted=z[[p]]$fitted,excluded=z[[p]]$excluded,mass_window=z[[p]]$mass_window)
  draws[[length(draws)+1L]]<<-data.frame(key=key,metric=paste0('b_',p),draw=1:B,estimate=z[[p]]$v[-1])
 }
 as.data.frame(row)
}
windowrows<-list()
for(hi in c(.70,.74)) {
 zz<-lapply(names(pop),function(g)change_general(pop[[g]],W[[g]],.74,hi));names(zz)<-names(pop)
 for(g in names(pop))windowrows[[length(windowrows)+1L]]<-record('window',g,'none',zz[[g]],upper=.74,mhi=hi)
 for(g in c('developers_all','developers_balanced','developers_A'))
  windowrows[[length(windowrows)+1L]]<-record('window',g,'control_all',zz[[g]],zz$control_all,.74,hi)
}
windowtab<-bind(windowrows);csv(windowtab,'window')
# Exact membership tokens, not substring approximations; overlapping roster membership
# is also removed if ANY of the three supplier labels is present.
supplier_labels<-c('\u5efa\u7b51\u5efa\u6750','\u6c34\u6ce5\u884c\u4e1a','\u94a2\u94c1\u884c\u4e1a')
supplier<-vapply(strsplit(cp$board,'[;|,]'),function(x)any(trimws(x)%in%supplier_labels),logical(1))
csamples<-list(without_suppliers=cp[!supplier,],only_suppliers=cp[supplier,])
stopifnot(nrow(csamples$without_suppliers)+nrow(csamples$only_suppliers)==nrow(cp),
 !any(csamples$without_suppliers$firm_id%in%csamples$only_suppliers$firm_id))
csv(unique(data.frame(firm_id=cp$firm_id,board=cp$board,supplier=supplier)),'control_membership')
sensrows<-list()
for(cg in names(csamples)) {
 cw<-weights(sort(unique(csamples[[cg]]$firm_id)))
 for(up in c(.70,.74)) {
  cz<-change_general(csamples[[cg]],cw,up,.70)
  sensrows[[length(sensrows)+1L]]<-record('control_sens',paste0('control_',cg),'none',cz,upper=up)
  for(g in c('developers_all','developers_balanced','developers_A')) {
   dz<-change_general(pop[[g]],W[[g]],up,.70)
   sensrows[[length(sensrows)+1L]]<-record('control_sens',g,paste0('control_',cg),dz,cz,up)
  }
 }
}
senstab<-bind(sensrows);csv(senstab,'control_sens')
csv(do.call(rbind,draws),'bootstrap_draws',FALSE);csv(do.call(rbind,densities),'density_bins',FALSE)
result_tex <- function(z,name,note) {
 labels<-c(developers_all='D all',developers_balanced='D balanced',developers_A='D A',
  developers_HK='D HK',control_all='C all',control_without_suppliers='C other',control_only_suppliers='C suppliers')
 rows<-vapply(seq_len(nrow(z)),function(i)texrow(c(paste0(labels[z$group[i]],
  if(z$control[i]!='none')paste0(' - ',labels[z$control[i]]) else ''),
  sprintf('%.2f/%.2f',z$exclusion_upper[i],z$mass_upper[i]),fmt(z$b_pre[i]),fmt(z$b_post[i]),
  fmt(z$estimate[i]),paste0('[',fmt(z$ci_low[i]),', ',fmt(z$ci_high[i]),']'))),character(1))
 tex(name,c('Group / comparison','Fit/Mass','Pre','Post','Change','95\\% CI'),
  rows,'lrrrrl',paste(note,'Pre 2017H1--2019H2; post 2020H2--2022H2. All lower bounds 0.66. ',
  'D = developers; C = control; A = A-share; HK = Hong Kong. Fit/Mass gives upper bounds. Columns pre/post give the named group levels; change gives its change or developer minus control change. ',
  '999 whole-firm draws, paired across periods and independent across populations. All N, firms, fit-range and actual mass/exclusion support are in the CSV. ',
  'Smooth counterfactual density and comparable counterfactual changes are assumptions. Pointwise CIs, no multiplicity adjustment.'),chunk=8L)
}
result_tex(windowtab,'window','Co-main fit excludes [0.66,0.74); mass is evaluated below 0.70 and separately over the whole excluded region.')
result_tex(senstab,'control_sens','Supplier membership: construction, cement or steel; removal and reverse-only sample both reported. The reverse-only comparison is descriptive.')

# 4. Distinct original firms and observation-selection sensitivity (NOT a firm bootstrap).
distinct<-list();onerows<-onedraws<-one_support<-list();onelevels<-list()
set.seed(seed+2L)
for(g in c('developers_all','control_all')) {
 z<-pop[[g]];mm<-period_masks(z);vals<-list()
 for(p in c('pre','post')) {
  avail<-mm[[p]]&is.finite(z$rl1);win<-avail&z$rl1>=.66&z$rl1<.70
  distinct[[length(distinct)+1L]]<-data.frame(group=g,period=p,n_obs=sum(avail),n_firms=nf(z$firm_id[avail]),
   window_obs=sum(win),window_firms=nf(z$firm_id[win]),mass_lower=.66,mass_upper=.70)
  # Select among ALL finite ratios, including outside the polynomial fit range.
  indices<-split(which(avail),z$firm_id[avail]);selected<-vapply(indices,function(ii)
   ii[sample.int(length(ii),B,replace=TRUE)],integer(B))
  counts<-vapply(seq_len(B),function(j)hist_counts(z$rl1[selected[j,]]),integer(length(mid)))
  fit<-fit_counts(counts);vals[[p]]<-fit$v
  for(j in seq_len(B)) {
   xx<-z$rl1[selected[j,]]
   one_support[[length(one_support)+1L]]<-data.frame(group=g,period=p,draw=j,
    n_obs=length(xx),n_firms=length(xx),range_obs=sum(counts[,j]),
    window_obs=sum(xx>=.66&xx<.70),window_firms=sum(xx>=.66&xx<.70),b=fit$v[j])
  }
 }
 onelevels[[g]]<-vals
 onedraws[[g]]<-data.frame(group=g,metric='delta_b',draw=1:B,estimate=vals$post-vals$pre)
}
onedraws$contrast<-data.frame(group='developers_all_minus_control_all',metric='delta_delta_b',draw=1:B,
 estimate=onedraws$developers_all$estimate-onedraws$control_all$estimate)
for(z in onedraws) {
 q<-ci(z$estimate);onerows[[length(onerows)+1L]]<-data.frame(group=z$group[1],metric=z$metric[1],
  median=median(z$estimate,na.rm=TRUE),p025=q$ci_low,p975=q$ci_high,valid=q$valid,failed=q$failed,
  random_draws=B,seed=seed+2L,exclusion_lower=.66,exclusion_upper=.70,mass_lower=.66,mass_upper=.70,
  inference='observation_selection_distribution_not_sampling_CI')
}
onetab<-do.call(rbind,onerows);distinct<-do.call(rbind,distinct);os<-do.call(rbind,one_support)
csv(onetab,'one_obs');csv(distinct,'distinct_firms');csv(os,'one_obs_support',FALSE)
csv(do.call(rbind,onedraws),'one_obs_draws',FALSE)
tex('one_obs',c('Group / comparison','Median change','2.5--97.5\\%','Valid'),
 vapply(seq_len(nrow(onetab)),function(i)texrow(c(esc(onetab$group[i]),fmt(onetab$median[i]),
 paste0('[',fmt(onetab$p025[i]),', ',fmt(onetab$p975[i]),']'),onetab$valid[i])),character(1)), 'lrlr',
 'One independently sampled finite observation per firm and period in each of 999 draws, including out-of-fit-range ratios. These percentiles describe observation-selection sensitivity, not sampling confidence intervals. Original distinct-firm counts are in t063\\_distinct\\_firms.csv; every selected N, firm count and window support is in t063\\_one\\_obs\\_support.csv.')

# 5. All 13 dates, including the two dates excluded from the pre/post estimand.
dated<-datehist<-list();hedges<-round(seq(.5,.9,.02),10);hmids<-(head(hedges,-1)+tail(hedges,-1))/2
for(g in c('developers_all','control_all'))for(dt in as.character(dates)) {
 z<-pop[[g]][pop[[g]]$date==as.Date(dt),];avail<-is.finite(z$rl1);x<-z$rl1[avail]
 wb<-x>=.66&x<.70;wa<-x>=.70&x<.74
 dated[[length(dated)+1L]]<-data.frame(group=g,date=dt,candidate_n=nrow(z),n_obs=length(x),
  n_firms=nf(z$firm_id[avail]),missing=sum(!avail),below_obs=sum(wb),above_obs=sum(wa),
  below_firms=nf(z$firm_id[avail][wb]),above_firms=nf(z$firm_id[avail][wa]),
  share_below=mean(wb),share_above=mean(wa),histogram_obs=sum(x>=.5&x<=.9),
  mass_below_lower=.66,mass_below_upper=.70,mass_above_lower=.70,mass_above_upper=.74)
 xh<-x[x>=.5&x<=.9];h<-hist(xh,breaks=hedges,right=FALSE,include.lowest=TRUE,plot=FALSE)
 datehist[[length(datehist)+1L]]<-data.frame(group=g,date=dt,mid=hmids,count=h$counts,
  share_all_finite=h$counts/length(x))
}
bydate<-do.call(rbind,dated);dh<-do.call(rbind,datehist);csv(bydate,'by_date');csv(dh,'by_date_histograms',FALSE)
pdf_start('by_date',8.3,10.5)
for(g in c('developers_all','control_all')) {
 par(mfrow=c(5,3),mar=c(2.3,2.5,2.1,.6),oma=c(3,1.2,2.5,0),cex=1,cex.axis=.75,cex.lab=.8)
 ymax<-max(dh$share_all_finite[dh$group==g])*1.16
 for(dt in as.character(dates)) {
  z<-dh[dh$group==g&dh$date==dt,];rr<-bydate[bydate$group==g&bydate$date==dt,]
  title<-paste0(substr(dt,1,4),if(substr(dt,6,7)=='12')'H2' else 'H1',
   ' (N=',rr$n_obs,', G=',rr$n_firms,')')
  plot(NA,xlim=c(.5,.9),ylim=c(0,ymax),xlab='',ylab='',main=title,cex.main=.85)
  rect(z$mid-.01,0,z$mid+.01,z$share_all_finite,col=ifelse(z$mid>=.66&z$mid<.74,'#BD7D63','#C9D5DF'),border='white')
  abline(v=.7,lty=3,col='#444444')
 }
 for(i in 1:2)plot.new()
 mtext(if(g=='developers_all')'Developers' else 'A-share Sina controls',3,outer=TRUE,line=.7,cex=1.1)
 mtext('RL1; 0.02 bins. Bar heights divide by all finite observations at each date.',1,outer=TRUE,line=1.4,cex=.85)
 mtext('Shaded region [0.66,0.74); common vertical scale within population.',1,outer=TRUE,line=.1,cex=.8)
 mtext('Share of all finite observations',2,outer=TRUE,line=-.2,cex=.85)
}
invisible(dev.off())

# 6. Reconciliation uses existing point estimates/draws, never new re-estimation.
reconcile<-list()
addrec <- function(issue,source,filter,definition,value=NA_real_,lo=NA_real_,hi=NA_real_,detail='') {
 reconcile[[length(reconcile)+1L]]<<-data.frame(issue=issue,source=source,filter=filter,definition=definition,
  value=value,ci_low=lo,ci_high=hi,detail=detail)
}
miss<-d[!is.finite(d$rl1),];counts<-read('outputs/tables/t004_panel_counts.csv')
cc<-counts[counts$stage=='10_final_panel'&counts$sample=='sample_main',]
stopifnot(nrow(d)==1692L,sum(is.finite(d$rl1))==1691L,nrow(miss)==1L,
 miss$firm_id=='2103.HK',as.character(miss$date)=='2019-06-30',is.na(miss$ta),is.na(miss$tl),
 sum(cc$n_firm_dates)==nrow(d))
addrec('panel_rows','panel_firm_halfyear.csv; t004_panel_counts.csv','sample_main=TRUE; stage=10_final_panel',
 'Retained firm-half-year rows, before finite-RL1 restriction',nrow(d))
addrec('finite_RL1','panel_firm_halfyear.csv','sample_main=TRUE; is.finite(rl1)',
 'Rows with defined RL1',sum(is.finite(d$rl1)))
addrec('missing_RL1','panel_firm_halfyear.csv','firm_id=2103.HK; date=2019-06-30',
 'Missing total assets and liabilities; adv=0 cannot recover RL1',nrow(miss),detail='ta=NA; tl=NA; adv=0; no replacement or imputation')
prisma<-read('../state/litsearch/prisma_counts.csv');slog<-read('../state/litsearch/search_log.csv')
screen<-as.data.frame(readxl::read_excel('../state/litsearch/screening.xlsx'))
cnki<-screen[grepl('CNKI',screen$database),];overlap<-cnki[grepl(';',cnki$query_id),]
count52<-prisma$n[prisma[[1]]=='identified_CNKI'];searchcn<-slog[slog$query_id%in%c('C1','C2','C3'),]
# Source metadata confirm the duplicate's two query memberships; do not equate
# the 51 unique journal-source entries with 51 peer-reviewed/core-journal papers.
stopifnot(count52==52L,sum(searchcn$exported_records)==count52,nrow(cnki)==51L,
 nrow(overlap)==1L,overlap$query_id=='C1; C3',!anyDuplicated(cnki$key))
addrec('CNKI_records','../state/litsearch/prisma_counts.csv','row=identified_CNKI',
 'Records identified before cross-query deduplication (35 + 12 + 5)',count52)
addrec('CNKI_unique_articles','../state/litsearch/screening.xlsx','database contains CNKI; unique key',
 '51 unique journal-source articles after one cross-query duplicate; journal restriction is not core/peer-review verification',
 nrow(cnki),detail=paste(overlap$id,overlap$query_id,overlap$title,overlap$source,sep=' | '))
bd61<-read('outputs/tables/t061_bootstrap_draws.csv')
bd58<-read('outputs/tables/t058_bootstrap_draws.csv')
attr58<-read('outputs/tables/t058_attrition.csv');std58<-read('outputs/tables/t058_standard.csv')
for(g in c('developers_A','developers_balanced_13_dates')) {
 r61<-ref61[ref61$group==g&ref61$threshold==.7,]
 v61<-bd61[bd61$group==g&bd61$threshold==.7&bd61$metric=='delta_b',]
 r58<-if(g=='developers_A')std58[std58$variant=='market_split'&std58$group=='A'&std58$metric=='delta_b',] else
  attr58[attr58$variant=='balanced_13_dates'&attr58$metric=='delta_b',]
 stopifnot(nrow(r61)==1L,nrow(r58)==1L,nrow(v61)==B)
 v58<-bd58[bd58$row_id==r58$row_id,];stopifnot(nrow(v58)==B,identical(sort(v61$draw),1:B),identical(sort(v58$draw),1:B))
 a<-ci(v61$estimate);b<-ci(v58$estimate)
 stopifnot(abs(a$ci_low-r61$delta_ci_low)<1e-10,abs(a$ci_high-r61$delta_ci_high)<1e-10,
  abs(b$ci_low-r58$ci_low)<1e-10,abs(b$ci_high-r58$ci_high)<1e-10,abs(r61$delta_b-r58$estimate)<1e-10)
 addrec(paste(g,'T061'), 't061_estimates.csv; t061_bootstrap_draws.csv',paste0('group=',g,'; threshold=0.7; metric=delta_b'),
  '999 independent within-subgroup whole-firm resamples; pre/post paired; T061 draw order',r61$delta_b,a$ci_low,a$ci_high,
  'T061 table uses its own subgroup resampling universe; seed=20261016; percentile type 7')
 addrec(paste(g,'T058'),if(g=='developers_A')'t058_standard.csv; t058_bootstrap_draws.csv' else
  't058_attrition.csv; t058_bootstrap_draws.csv',paste0('row_id=',r58$row_id),
  '999 whole-main-population (136 firms) resamples, then subgroup selection; pre/post paired',r58$estimate,b$ci_low,b$ci_high,
  'T058 table retains shared 136-firm weights across cells; random subgroup multiplicities; seed=20261016; percentile type 7')
}
for(th in c(.7,.6)) {
 rr<-ref61[ref61$group=='control_A_Sina'&ref61$threshold==th,]
 addrec('control_placebo_distinct','t061_estimates.csv',paste0('group=control_A_Sina; threshold=',th),
  if(th==.7)'Mass and fit exclusion [0.66,0.70)' else
   'Mass [0.56,0.60); fit excludes this plus [0.66,0.72)',rr$delta_b,rr$delta_ci_low,rr$delta_ci_high)
}
stopifnot(diff(ref61$delta_b[ref61$group=='control_A_Sina'&ref61$threshold%in%c(.7,.6)])!=0)
rectab<-do.call(rbind,reconcile);csv(rectab,'reconcile')

# 7. Interpretation paragraphs and number -> file -> exact row/column map.
wb<-windowtab[windowtab$mass_upper==.70&windowtab$control=='control_all',]
ss<-senstab[senstab$group=='developers_all'&senstab$metric=='delta_delta_b',]
nbest<-noise[empbest,]
desc<-function(x,lo,hi)paste0(fmt(x),' [',fmt(lo),', ',fmt(hi),']')
interpret<-c(
 paste0('Validation errors have N=',nrow(val),' across ',nf(val$firm_id),' firms, mean ',fmt(mean(epsilon)),
  ' and SD ',fmt(sd(epsilon)),'. The empirical grid has ',sum(noise$both_in_marginal_95&noise$noise=='empirical'),
  ' cells with both observed statistics inside their respective marginal 95% simulation ranges; the normal grid has ',
  sum(noise$both_in_marginal_95&noise$noise=='normal'),'. The empirical cell minimizing the two mean-statistic discrepancies is pi=',
  nbest$pi,', beta=',nbest$beta,', Delta=',nbest$Delta,': mean main b=',fmt(nbest$b_mean),', mean above-b=',fmt(nbest$above_b_mean),
  '. At this cell the mean above-b remains below the observed ',fmt(obabove),
  '; inclusion in a simulation range does not mean that both simulated means reproduce the data. ',
  'The fixed pre-policy distribution already has above-b ',fmt(fit_counts(matrix(y0,ncol=1),.74,.70,.74)$v),
  ', so positive above-threshold mass need not be created by noise and does not establish its necessity. ',
  'All cells and their separate mean errors are reported; marginal-range matching is not a joint test or parameter confidence set. ',
  if(any(noise$mean_excess_both_sides&noise$noise=='empirical'&noise$pi>0))
   'The calibrated empirical model can generate positive fitted excess on both sides, making that qualitative shape consistent with imprecise targeting conditional on the proxy assumption. ' else
   'The empirical calibration does not generate positive mean excess on both sides in the evaluated grid. ',
  'It does not establish behavioral control errors: constructed-minus-published differences also include definition and measurement discrepancies, come from a selected validation sample, and are applied to movers without centering. Fixed pre-policy atoms and firm-level Bernoulli targeting define the simulation; errors vary by date. The beta=0 target is the left limit at 0.70.'),
 paste0('With the entire [0.66,0.74) region excluded and mass below 0.70, developer-minus-control changes are ',
  paste(vapply(seq_len(nrow(wb)),function(i)paste0(wb$group[i],': ',desc(wb$estimate[i],wb$ci_low[i],wb$ci_high[i])),character(1)),collapse='; '),
  '. The second panel evaluates total [0.66,0.74) mass with its own eight-bin normalization; it is not the sum of separately normalized b statistics. ',
  'Hong Kong developer levels are reported, but no Hong Kong control exists. Smooth counterfactual density and comparable counterfactual changes remain assumptions.'),
 paste0('Removing construction, cement and steel retains ',nf(csamples$without_suppliers$firm_id),' controls; the reverse-only descriptive sample contains ',
  nf(csamples$only_suppliers$firm_id),'. Full-developer contrasts are ',paste(vapply(seq_len(nrow(ss)),function(i)
  paste0(ss$control[i],', exclusion upper ',ss$exclusion_upper[i],': ',desc(ss$estimate[i],ss$ci_low[i],ss$ci_high[i])),character(1)),collapse='; '),
  '. All/balanced/A-share comparisons and actual support are reported for both fits. Removing these sectors addresses the specified supplier exposure but cannot rule out property-related shocks in other controls, survivor selection or unmatched Hong Kong shocks.'),
 paste0('Distinct firms in the below-threshold window are ',paste(paste(distinct$group,distinct$period,distinct$window_firms,sep=': '),collapse='; '),
  '. Selecting one finite observation per firm and period yields change distributions ',paste(vapply(seq_len(nrow(onetab)),function(i)
   paste0(onetab$group[i],': median ',desc(onetab$median[i],onetab$p025[i],onetab$p975[i])),character(1)),collapse='; '),
  '. These percentiles measure sensitivity to observation choice; they are not sampling CIs, and repeat-firm dependence is not assessed by this exercise.'),
 paste0('The by-date panels show all ',length(dates),' scheduled dates separately for each population, including 2016H2 and 2020H1 excluded from the pre/post contrast. ',
  'Counts, distinct firms and both near-threshold shares use all finite RL1 values as denominators; histogram mass outside [0.50,0.90] is not renormalized away. ',
  'Shared vertical scales within population facilitate temporal comparison without interpreting date-specific patterns as causal effects.'),
 paste0('The 1,692 retained rows contain 1,691 finite RL1 values: 2103.HK on 2019-06-30 lacks assets and liabilities. CNKI identified 52 records across C1/C2/C3, ',
  'but 51 unique journal-source articles after the C1/C3 duplicate ',overlap$id,'. This is a record-versus-unique-article distinction, not proof of peer review. ',
  'Stored draws reproduce the differing T061 and T058 subgroup CIs: T061 resamples each subgroup itself, whereas T058 resamples 136 full-population firms then selects the subgroup. ',
  'The control changes at 0.70 and 0.60 differ in their exact values and fit/mass exclusions. No reconciliation estimate was re-estimated.'),
 'Every summary numerical cell maps to file, row filter and column in t063_number_map.csv. Draw and histogram files use explicit parameter_id/key/group/date/draw/mid keys. Existing outputs and raw inputs are guarded by SHA-256; repeat execution compares staged bytes. No research question, new primary data, ownership classification or proposal text is changed.'
)
csv(data.frame(step=1:7,interpretation=interpret,number_map='t063_number_map.csv'),'interpretation')
mapping<-list()
for(name in names(tables)) {
 z<-tables[[name]];num<-names(z)[vapply(z,is.numeric,logical(1))]
 keys<-intersect(c('parameter_id','table','group','control','metric','period','date','issue','step','mass_upper','exclusion_upper'),names(z))
 filters<-vapply(seq_len(nrow(z)),function(i)paste(c(paste0('row=',i),
  vapply(keys,function(key)paste0(key,'=',z[[key]][i]),character(1))),collapse='; '),character(1))
 for(n in num)mapping[[length(mapping)+1L]]<-data.frame(file=paste0('outputs/tables/t063_',name,'.csv'),
  row=seq_len(nrow(z)),filter=filters,column=n,value=z[[n]])
}
csv(do.call(rbind,mapping),'number_map',FALSE)

# Acceptance and publication. Stage first; all failed gates leave prior T063 intact.
stopifnot(nrow(noise)==198L,nrow(windowtab)==16L,nrow(senstab)==16L,nrow(onetab)==3L,
 nrow(distinct)==4L,nrow(bydate)==26L,nrow(os)==4L*B,
 identical(input_hash,tools::sha256sum(inputs)),identical(protected_hash,tools::sha256sum(protected)),
 identical(raw_hash,tools::sha256sum(rawfiles)))
csv(data.frame(kind=c(rep('input',length(inputs)),rep('existing_output',length(protected)),rep('raw',length(rawfiles))),
 file=c(inputs,protected,rawfiles),sha256=c(unname(input_hash),unname(protected_hash),unname(raw_hash)),unchanged=TRUE),'verification',FALSE)
textout(c(sprintf('PASS: independent hist/lm/predict maximum error %.12g (<1e-10).',validation_error),
 'PASS: reproduction asserts delta developer 4.02, all/balanced developer-control 4.59/4.48.',
 sprintf('PASS: 198 simulation cells x 1000 replications; 16 co-main rows; 16 supplier rows; 3 one-observation rows; 26 date/population rows.'),
 sprintf('PASS: %d inputs, %d existing outputs, %d raw files unchanged.',length(inputs),length(protected),length(rawfiles)),
 'Simulation calibration uses the mandated pre-existing T040 validation differences; no new hand-collected data or raw manual file is used.',
 'Observation-selection intervals and simulation ranges are not sampling confidence intervals.',
 'Repeat-run byte equality is checked for every staged output under identical verification context.'),'validation','txt')
targets<-vapply(staged,`[[`,character(1),'target')
stopifnot(!anyDuplicated(targets))
vtarget<-'outputs/tables/t063_verification.csv';vpath<-staged[[match(vtarget,targets)]][['path']]
same_context<-file.exists(vtarget)&&identical(unname(tools::sha256sum(vpath)),unname(tools::sha256sum(vtarget)))
if(all(file.exists(targets))&&same_context) {
 same<-vapply(staged,function(s)identical(unname(tools::sha256sum(s['path'])),unname(tools::sha256sum(s['target']))),logical(1))
 if(!all(same))stop('STOP: repeat-run bytes differ: ',paste(targets[!same],collapse=', '))
 cat(sprintf('T063 repeat-run PASS: %d/%d outputs byte-identical.\n',sum(same),length(same)))
}
for(s in staged)stopifnot(file.copy(s['path'],s['target'],overwrite=TRUE))
unlink(vapply(staged,`[[`,character(1),'path'))
cat(sprintf('T063 guards PASS: %d inputs; %d existing outputs; %d raw files unchanged.\n',length(inputs),length(protected),length(rawfiles)))
cat('T063 coverage PASS: 198 noise cells; 16 window rows; 16 control rows; 999 observation draws; 26 date rows.\n')
cat(sprintf('T063 complete: %d files; seed=%d; firm-bootstrap=%d; simulation=%d.\n',length(staged),seed,B,S))
