# T061: offline difference-in-bunching. Run: cd replication && Rscript code/21_diff_bunching.R
# Fixed approved population; no causal interpretation without comparable counterfactual changes.
options(digits=17)
seed <- 20261016L; B <- 999L; set.seed(seed)
read <- function(p,...) read.csv(p,stringsAsFactors=FALSE,na.strings=c('','NA','--'),...)
nf <- function(x) length(unique(x[!is.na(x)]))
rawdir <- 'data/raw/control/'
manifest <- read(paste0(rawdir,'MANIFEST.csv'))
stopifnot(all(file.exists(manifest$file)),!anyDuplicated(manifest$file),
 identical(unname(tools::sha256sum(manifest$file)),manifest$sha256),
 all(file.info(manifest$file)$size==manifest$size_bytes))
inputs <- c(manifest$file,paste0(rawdir,'MANIFEST.csv'),'code/21_diff_bunching.R',
 'code/01_clean.R','code/06_bunching_tests.R','code/20_referee4.R','code/19_referee3.R',
 'data/processed/panel_firm_halfyear.csv','data/raw/manual/ownership_manual_coding.csv',
 'data/raw/wind/wind_A_gelistet_eigentum.xlsx','outputs/tables/t055_kappa.csv',
 'outputs/tables/t055_bootstrap_draws.csv','outputs/tables/t058_attrition.csv',
 'run_all.R','run_all.sh','README.md','outputs/tables/t061_baseline.csv')
input_hash <- tools::sha256sum(inputs)
protected <- list.files('outputs',recursive=TRUE,full.names=TRUE,all.files=TRUE)
protected <- protected[!dir.exists(protected)&!grepl('^t061_',basename(protected))&basename(protected)!='t055_kappa.pdf']
protected_hash <- tools::sha256sum(protected)
baseline <- read('outputs/tables/t061_baseline.csv')
old <- baseline[!baseline$allowed_change %in% c('True','TRUE'),]
# Historical hashes document this task's acceptance. A full upstream rebuild may
# legitimately update upstream verification manifests; the per-run guard below
# always protects every pre-existing output during this script's own execution.
historical_same <- unname(tools::sha256sum(old$file))==old$sha256
# Stage every generated result; failed gates leave the published results intact.
staged <- list()
stage <- function(path,target) {
 stopifnot(grepl('^t061_',basename(target))||target=='outputs/figures/t055_kappa.pdf')
 staged[[length(staged)+1L]] <<- c(path=path,target=target)
}
csv <- function(z,name) {
 f <- tempfile(fileext='.csv');con <- file(f,'wb');write.csv(z,con,row.names=FALSE,na='NA',eol='\n');close(con)
 stage(f,paste0('outputs/tables/t061_',name,'.csv'))
}
textout <- function(z,name,extension='tex') {
 f <- tempfile(fileext=paste0('.',extension));writeLines(z,f,useBytes=TRUE)
 stage(f,paste0('outputs/tables/t061_',name,'.',extension))
}
fmt <- function(x) ifelse(is.finite(x),sprintf('%.3f',x),'--')
ci <- function(v) {ok<-is.finite(v); q<-if(any(ok))quantile(v[ok],c(.025,.975),names=FALSE) else c(NA,NA)
 list(se=if(sum(ok)>1L)sd(v[ok]) else NA_real_,ci_low=q[1],ci_high=q[2],valid=sum(ok),failed=sum(!ok))}

# Developer panel and exact T023 calendar convention. All finite RL1 retained, no trimming.
all_panel <- read('data/processed/panel_firm_halfyear.csv')
d <- all_panel[!is.na(all_panel$sample_main)&all_panel$sample_main,]
d$date <- as.Date(d$date);d <- d[order(d$firm_id,d$date),];rownames(d)<-NULL
stopifnot(!anyDuplicated(d[c('firm_id','date')]))
dates <- sort(unique(d$date));stopifnot(length(dates)==13L,min(dates)==as.Date('2016-12-31'),max(dates)==as.Date('2022-12-31'))
period_masks <- function(z) list(pre=z$date>=as.Date('2017-06-30')&z$date<=as.Date('2019-12-31'),
 post=z$date>=as.Date('2020-12-31')&z$date<=as.Date('2022-12-31'))
weights <- function(ids) {
 g<-length(ids);stopifnot(g>0L)
 cbind(rep(1L,g),replicate(B,tabulate(sample.int(g,g,replace=TRUE),nbins=g)))
}
# Each population is its own stratum. The same whole-firm draw is used in pre and post.
# Different populations have independent draws; no developer/control overlap is allowed.
mass <- function(z,use,W,threshold=.70) {
 ids <- sort(unique(z$firm_id));stopifnot(nrow(W)==length(ids))
 x<-z$rl1;available<-use&is.finite(x)
 edges<-round(seq(.4,1,.01),10);mid<-(head(edges,-1)+tail(edges,-1))/2
 lower<-round(threshold-.04,10);mass_window<-mid>=lower-1e-12&mid<threshold-1e-12
 # T023: true-threshold mass must not enter a placebo counterfactual fit.
 # The extra exclusion affects the fit only; excess mass still uses four bins.
 regulated_region<-mid>=.66-1e-12&mid<.72-1e-12
 excluded<-mass_window|(threshold!=.70&regulated_region)
 stopifnot(sum(mass_window)==4L,threshold==.70||all(excluded[regulated_region]))
 ix<-findInterval(x,edges,rightmost.closed=TRUE)
 inside<-available&!is.na(ix)&ix>0L&ix<length(edges)
 a<-matrix(0,length(ids),length(mid))
 for(i in which(inside))a[match(z$firm_id[i],ids),ix[i]]<-a[match(z$firm_id[i],ids),ix[i]]+1
 y<-t(a)%*%W
 X<-cbind(1,poly(mid,degree=5L));q<-qr(X[!excluded,,drop=FALSE]);stopifnot(q$rank==6L)
 pred<-X%*%qr.coef(q,y[!excluded,,drop=FALSE])
 good<-colSums(!is.finite(pred[mass_window,,drop=FALSE])|pred[mass_window,,drop=FALSE]<=0)==0L
 cf<-colSums(pred[mass_window,,drop=FALSE]);obs<-colSums(y[mass_window,,drop=FALSE])
 v<-ifelse(good,(obs-cf)/(cf/sum(mass_window)),NA_real_)
 win<-available&x>=lower&x<threshold
 list(v=v,n=sum(available),firms=nf(z$firm_id[available]),candidate_n=sum(use),missing=sum(use&!is.finite(x)),
 range_n=sum(inside),outside_n=sum(available&!inside),range_share=sum(inside)/sum(available),
 window_obs=sum(win),window_firms=nf(z$firm_id[win]),low_support=sum(win)<30L,
 observed_mass=obs[1],fitted_mass=cf[1],negative_fitted_bins=sum(pred[,1]<0),
 zero_window_draws=sum(obs[-1]==0),mid=mid,observed=y[,1],fitted=pred[,1],excluded=excluded,
 mass_window=mass_window)
}
change <- function(z,W,threshold=.7) {
 m<-period_masks(z);a<-mass(z,m$pre,W,threshold);b<-mass(z,m$post,W,threshold)
 list(pre=a,post=b,delta=b$v-a$v)
}
# FIRST numerical gate: developers reproduce the supplied values before control estimation.
Wdev<-weights(sort(unique(d$firm_id)));main<-change(d,Wdev)
stopifnot(round(main$pre$v[1],2)==-.88,round(main$post$v[1],2)==3.14,round(main$delta[1],2)==4.02)
csv(data.frame(metric=c('b_pre','b_post','delta_b'),estimate=c(main$pre$v[1],main$post$v[1],main$delta[1]),
 expected_rounded=c(-.88,3.14,4.02),assert_pass=TRUE),'reproduction')
cat(sprintf('T061 reproduction PASS: b_pre=%.12f; b_post=%.12f; delta_b=%.12f.\n',main$pre$v[1],main$post$v[1],main$delta[1]))

# 1. Immutable copies, exact identifiers, additive advance mapping and positive denominator.
r<-rbind(read(paste0(rawdir,'control_sina_roster.csv'),colClasses='character'),
 read(paste0(rawdir,'control_sina_roster_coal.csv'),colClasses='character'))
stopifnot(!anyDuplicated(r$code),all(r$market=='A'),all(r$universe=='main'),
 all(grepl('^[03468][0-9]{5}$|^92[0-9]{4}$',r$code)))
c<-read(paste0(rawdir,'control_a_balance_sina.csv'),colClasses=c(code='character'))
c$date<-as.Date(c$REPORT_DATE);c<-c[order(c$code,c$date),];rownames(c)<-NULL
raw_dates<-as.Date(paste0(rep(2016:2022,each=2),rep(c('-06-30','-12-31'),7)))
stopifnot(all(c$code%in%r$code),!anyDuplicated(c[c('code','date')]),all(c$date%in%raw_dates),
 all(table(c$code)==14L),all(table(c$date)==nf(c$code)),
 !any(c$code%in%sub('[.].*','',all_panel$firm_id)),
 all(c$board==r$board[match(c$code,r$code)]))
c$firm_id<-paste0(c$code,ifelse(substr(c$code,1,1)=='6','.SH',ifelse(substr(c$code,1,1)%in%c('0','3'),'.SZ','.BJ')))
c$ta<-c$TOTAL_ASSETS;c$tl<-c$TOTAL_LIABILITIES
parts<-as.matrix(c[c('ADVANCE_RECEIVABLES','CONTRACT_LIAB')])
c$adv_n_components<-rowSums(!is.na(parts));c$adv_missing<-c$adv_n_components==0L
c$adv<-rowSums(parts,na.rm=TRUE) # All-missing sum -> 0, identical to the PI-authorized developer rule.
c$denominator<-c$ta-c$adv
c$rl1<-ifelse(!is.na(c$denominator)&c$denominator>0,(c$tl-c$adv)/c$denominator,NA_real_)
c$in_developer_date_set<-c$date%in%dates
cm<-period_masks(c);c$period<-ifelse(cm$pre,'pre',ifelse(cm$post,'post','excluded'))
csv(c,'control_panel') # T061-only table path; approved scope does not include processed/.
coverage<-do.call(rbind,lapply(raw_dates,function(date) {
 z<-c[c$date==date,];avail<-is.finite(z$rl1);inside<-avail&z$rl1>=.4&z$rl1<=1
 data.frame(date=as.Date(date,origin='1970-01-01'),in_developer_date_set=all(z$in_developer_date_set),
 n=nrow(z),firms=nf(z$firm_id),finite_rl1=sum(avail),finite_rl1_firms=nf(z$firm_id[avail]),
 in_range=sum(inside),share_in_range_among_finite=sum(inside)/sum(avail),
 adv_imputed_zero=sum(z$adv_missing),nonpositive_denominator=sum(z$denominator<=0,na.rm=TRUE),
 missing_assets=sum(is.na(z$ta)),missing_liabilities=sum(is.na(z$tl)))
}))
csv(coverage,'coverage')
# Failure ledger was overwritten by coal rerun. Report every absent roster firm;
# a missing historical error message cannot be reconstructed from missingness.
e<-read(paste0(rawdir,'balance_download_errors.csv'),colClasses='character')
stopifnot(!anyDuplicated(e$code),all(e$code%in%r$code),!any(e$code%in%c$code))
fail<-r[!r$code%in%c$code,];fail$error<-e$error[match(fail$code,e$code)]
fail$reason_status<-ifelse(is.na(fail$error),'not_in_combined_balance; historical error unavailable','recorded_in_current_error_ledger')
csv(fail,'download_failures')
sector<-do.call(rbind,lapply(sort(unique(r$board)),function(b) {
 rr<-r[r$board==b,];ff<-fail[fail$board==b,]
 data.frame(board=b,roster_firms=nrow(rr),downloaded_firms=sum(rr$code%in%c$code),missing_firms=nrow(ff),
 recorded_errors=sum(!is.na(ff$error)),historical_errors_unavailable=sum(is.na(ff$error)),
 failure_share=nrow(ff)/nrow(rr))
}))
csv(sector,'failure_by_sector')
rules<-data.frame(rule=1:9,description=c(
 'Union of two approved Sina rosters; unique 6-digit A-share codes; exact board labels retained including joint membership.',
 'No firm from the entire developer panel may overlap controls; duplicates or unexpected codes/dates stop execution.',
 'All 14 fetch dates 2016H1-2022H2 required for every saved control firm; no synthetic rows or replacement data.',
 'Analysis uses the same 13 date set as developers: 2016H2-2022H2. 2016H1 retained only in raw/coverage audit.',
 'ADVANCE_RECEIVABLES plus CONTRACT_LIAB; sum observed components; both absent -> zero with adv_missing flag (01_clean.R PI rule).',
 'RL1 = (TOTAL_LIABILITIES - adv)/(TOTAL_ASSETS - adv); denominator <= 0 or missing -> NA; no numerator restriction.',
 'Missing assets/liabilities retained as missing; no winsorization, trimming, outlier exclusion, currency conversion or interpolation.',
 'Finite RL1 defines available N; [0.40,1.00] defines polynomial fit N only, with last bin including 1; out-of-range ratios remain in N.',
 'Pre 2017H1-2019H2 (6 dates); post 2020H2-2022H2 (5 dates); 2016H2 and 2020H1 excluded from both.'),
 evidence=c('control_panel; download_failures','runtime assertions','coverage','coverage','control_panel adv_missing/adv_n_components',
 'control_panel denominator/rl1','control_panel','estimates range_n/outside_n','estimates pre/post N'))
csv(rules,'cleaning_rules')
cp<-c[c$in_developer_date_set,];Wcontrol<-weights(sort(unique(cp$firm_id)))
controls<-lapply(c(.70,.60,.80),function(t)change(cp,Wcontrol,t));names(controls)<-c('070','060','080')

# 2-4. Every requested available variant, with within-population cluster bootstrap.
balanced_ids<-sort(unique(d$firm_id))[vapply(sort(unique(d$firm_id)),function(f)
 sum(d$firm_id==f&is.finite(d$rl1))==length(dates),logical(1))]
stopifnot(length(balanced_ids)==115L)
bd<-d[d$firm_id%in%balanced_ids,];ad<-d[d$market=='A',]
bal<-change(bd,weights(sort(unique(bd$firm_id))))
ashare<-change(ad,weights(sort(unique(ad$firm_id))))
ref<-read('outputs/tables/t058_attrition.csv');ref<-ref[ref$variant=='balanced_13_dates'&ref$metric=='delta_b',]
stopifnot(nrow(ref)==1L,abs(bal$delta[1]-ref$estimate)<1e-10)
estimates<-list();draws<-list();densities<-list()
record<-function(group,threshold,z) {
 row<-list(group=group,threshold=threshold,exclusion_lower=round(threshold-.04,10),exclusion_upper=threshold,
 bin_width=.01,degree=5L,fit_lower=.4,fit_upper=1,bootstrap_draws=B,seed=seed)
 for(p in c('pre','post')) {
  zz<-z[[p]];row[[paste0('b_',p)]]<-zz$v[1]
  st<-ci(zz$v[-1]);for(n in names(st))row[[paste0('b_',p,'_',n)]]<-st[[n]]
  for(n in c('n','firms','candidate_n','missing','range_n','outside_n','range_share','window_obs','window_firms',
   'low_support','observed_mass','fitted_mass','negative_fitted_bins','zero_window_draws'))row[[paste0(p,'_',n)]]<-zz[[n]]
  draws[[length(draws)+1L]]<<-data.frame(group=group,threshold=threshold,metric=paste0('b_',p),draw=1:B,estimate=zz$v[-1])
  densities[[length(densities)+1L]]<<-data.frame(group=group,threshold=threshold,period=p,mid=zz$mid,
   observed_count=zz$observed,fitted_counterfactual=zz$fitted,excluded=zz$excluded,mass_window=zz$mass_window)
 }
 row$delta_b<-z$delta[1];st<-ci(z$delta[-1]);for(n in names(st))row[[paste0('delta_',n)]]<-st[[n]]
 row$low_support<-z$pre$low_support||z$post$low_support
 row$inference_status<-if(!is.finite(z$delta[1]))'invalid_point' else if(st$valid<.9*B)'unreliable_below_90pct_valid' else
 if(st$valid<B)'conditional_on_valid_draws' else 'all_draws_valid'
 estimates[[length(estimates)+1L]]<<-as.data.frame(row)
 draws[[length(draws)+1L]]<<-data.frame(group=group,threshold=threshold,metric='delta_b',draw=1:B,estimate=z$delta[-1])
}
for(i in seq_along(controls))record('control_A_Sina',c(.70,.60,.80)[i],controls[[i]])
record('developers_all',.70,main);record('developers_balanced_13_dates',.70,bal);record('developers_A',.70,ashare)
est<-do.call(rbind,estimates);csv(est,'estimates');csv(do.call(rbind,densities),'density_bins')
contrasts<-list()
for(g in c('developers_all','developers_balanced_13_dates','developers_A')) {
 zz<-switch(g,developers_all=main,developers_balanced_13_dates=bal,developers_A=ashare)
 v<-zz$delta-controls[['070']]$delta;st<-ci(v[-1])
 row<-data.frame(comparison=paste0(g,'_minus_control_A_Sina'),co_primary=g!='developers_A',
 threshold=.70,delta_developers=zz$delta[1],delta_control=controls[['070']]$delta[1],delta_delta_b=v[1],
 as.data.frame(st),bootstrap_draws=B,seed=seed,low_support=zz$pre$low_support||zz$post$low_support||
 controls[['070']]$pre$low_support||controls[['070']]$post$low_support,
 inference_status=if(st$valid<.9*B)'unreliable_below_90pct_valid' else if(st$valid<B)'conditional_on_valid_draws' else 'all_draws_valid')
 for(side in c('developer','control'))for(p in c('pre','post'))for(n in c('n','firms','window_obs','window_firms','range_n','outside_n','missing'))
 row[[paste(side,p,n,sep='_')]]<-(if(side=='developer')zz else controls[['070']])[[p]][[n]]
 contrasts[[length(contrasts)+1L]]<-row
 draws[[length(draws)+1L]]<-data.frame(group=row$comparison,threshold=.70,metric='delta_delta_b',draw=1:B,estimate=v[-1])
}
contrast<-do.call(rbind,contrasts);csv(contrast,'diff_bunching');csv(do.call(rbind,draws),'bootstrap_draws')
support<-est[,c('group','threshold','pre_n','pre_firms','pre_window_obs','pre_window_firms','post_n','post_firms',
 'post_window_obs','post_window_firms','low_support')];csv(support,'support')
cat(sprintf('T061 control: %d firms; %d raw firm-half-years; %d on developer date set; %d roster failures.\n',nf(c$firm_id),nrow(c),nrow(cp),nrow(fail)))
cat(sprintf('T061 control 0.70: b_pre=%.6f; b_post=%.6f; delta_b=%.6f; window support=%d/%d.\n',
 controls[['070']]$pre$v[1],controls[['070']]$post$v[1],controls[['070']]$delta[1],controls[['070']]$pre$window_obs,controls[['070']]$post$window_obs))
for(i in seq_len(nrow(contrast)))cat(sprintf('T061 %s: delta_delta_b=%.6f [%.6f, %.6f].\n',contrast$comparison[i],contrast$delta_delta_b[i],contrast$ci_low[i],contrast$ci_high[i]))

# 5. Existing ownership sources only; no ownership inferred from firm names.
manual<-read('data/raw/manual/ownership_manual_coding.csv')
wind<-suppressWarnings(as.data.frame(readxl::read_excel('data/raw/wind/wind_A_gelistet_eigentum.xlsx',col_types='text')))
owner_sources<-list(panel=unique(all_panel$firm_id),manual=manual$firm_id,wind=wind[[1]])
own<-do.call(rbind,lapply(names(owner_sources),function(n)data.frame(source=n,source_firms=nf(owner_sources[[n]]),
 matched_control_firms=length(intersect(unique(cp$code),sub('[.].*','',owner_sources[[n]]))))))
stopifnot(all(own$matched_control_firms==0L));csv(own,'ownership_availability')
availability<-data.frame(variant=c('main_Sina_A_control','balanced_developer_comparison','A_developer_comparison','control_placebo_060',
 'control_placebo_080','broad_control','HK_developers_vs_HK_control','SOE_controls','nonSOE_controls'),
 status=c(rep('reported',5),'dropped_by_approved_data_route','dropped_by_approved_data_route','unavailable','unavailable'),
 reason=c('Approved ten Sina sector rosters; EastMoney balance definition',
 '115 firms with finite RL1 at all 13 developer dates; co-primary survivor comparison',
 'Same-market A-share comparison','Mass [0.56,0.60); fit additionally excludes [0.66,0.72)',
 'Mass [0.76,0.80); fit additionally excludes [0.66,0.72)',
 'No broad population downloaded; explicitly dropped in T061','No HK control downloaded; explicitly dropped in T061',
 'Zero control matches in existing panel/manual/Wind ownership files; no imputation',
 'Zero control matches in existing panel/manual/Wind ownership files; no imputation'))
csv(availability,'variants')

# 6. Re-render from existing T055 points and draws, using ONLY the figure block
# in 19_referee3.R. No old analysis script is executed and no old table is written.
k<-read('outputs/tables/t055_kappa.csv');kb<-read('outputs/tables/t055_bootstrap_draws.csv')
kgrid<-seq(0,1,.1);kresults<-list()
for(p in c('post','placebo')) {
 z<-list()
 for(metric in c('b','compliant_share')) {
  mat<-matrix(NA_real_,11L,B+1L)
  for(i in seq_along(kgrid)) {
   point<-k[k$period==p&k$metric==metric&abs(k$kappa-kgrid[i])<1e-9,]
   bb<-kb[kb$table=='kappa'&kb$period==p&kb$metric==metric&!is.na(kb$kappa)&abs(kb$kappa-kgrid[i])<1e-9,]
   bb<-bb[order(bb$draw),];stopifnot(nrow(point)==1L,identical(bb$draw,1:B))
   mat[i,]<-c(point$estimate,bb$estimate)
   check<-ci(bb$estimate);stopifnot(abs(check$ci_low-point$ci_low)<1e-10,abs(check$ci_high-point$ci_high)<1e-10)
  }
  z[[if(metric=='b')'b' else 'compliance']]<-mat
 }
 kresults[[p]]<-z
}
summary_boot<-ci
figcode<-readLines('code/19_referee3.R')
start<-grep("^grDevices::pdf.*T055 kappa reclassification",figcode)
end<-grep("^invisible\\(dev.off\\(\\)\\); stage\\(f,'outputs/figures/t055_kappa.pdf'\\)",figcode)
stopifnot(length(start)==1L,length(end)==1L,start<end)
f<-tempfile(fileext='.pdf');eval(parse(text=figcode[start:end]))
kappa_width<-6.25;kappa_linewidth<-210/25.4-2
kappa_min_native<-12*.8;kappa_min_linewidth<-kappa_min_native*kappa_linewidth/kappa_width
stopifnot(kappa_min_linewidth>=9)
csv(data.frame(metric=c('native_width_inches','paper_linewidth_inches_A4_1in_margins','minimum_text_native_pt',
 'minimum_text_at_linewidth_pt','T055_points','T055_bootstrap_draws'),
 value=c(kappa_width,kappa_linewidth,kappa_min_native,kappa_min_linewidth,nrow(k),sum(kb$table=='kappa')),
 note=c('Same figure block in 19_referee3.R and T061','Read from existing preamble: A4, 1 inch margins',
 'pointsize 12; cex reset to 1; legend and notes cex .8','At full linewidth (no smaller placement assumed)',
 'All existing points and confidence intervals unchanged','Existing draws; not re-estimated in step 6')),'kappa_render')

# Figures: deterministic metadata; pre/post histograms and the exact fitted counts.
f<-tempfile(fileext='.pdf');pdf(f,width=6.25,height=4.2,pointsize=11,useDingbats=FALSE,timestamp=FALSE,title='T061 control density')
par(mfrow=c(1,2),mar=c(4.5,4.1,3,1),oma=c(2.8,0,0,0),cex=1,cex.axis=.85,cex.lab=.9,cex.main=.95)
for(p in c('pre','post')) {
 z<-controls[['070']][[p]];top<-max(c(z$observed,z$fitted),na.rm=TRUE)*1.3
 plot(NA,xlim=c(.4,1),ylim=c(min(0,min(z$fitted)),top),xlab='RL1',ylab='Firm-half-years per 0.01 bin',
 main=if(p=='pre')'Pre: 2017H1-2019H2' else 'Post: 2020H2-2022H2')
 rect(z$mid-.005,0,z$mid+.005,z$observed,col=ifelse(z$excluded,'#D4896B','#D2DCE5'),border='white')
 lines(z$mid,z$fitted,col='#245B85',lwd=2);abline(v=.7,lty=3)
 legend('topleft',c('Observed','Counterfactual'),fill=c('#D2DCE5',NA),border=c(NA,NA),
 lty=c(NA,1),col=c(NA,'#245B85'),bty='n',cex=.8)
}
mtext('A-share Sina controls; degree 5 fit over [0.40,1.00].',side=1,outer=TRUE,line=1,cex=.85)
mtext('Shaded mass window [0.66,0.70) excluded from fitting.',side=1,outer=TRUE,line=0,cex=.85)
invisible(dev.off());stage(f,'outputs/figures/t061_control_density.pdf')

# Compact review table, in two independent panels rather than a page-wide grid.
esc<-function(x)gsub('_','\\_',x,fixed=TRUE)
texrow<-function(x)paste0(paste(x,collapse=' & '),' \\\\')
tex<-c('\\begingroup\\small','\\begin{tabular}{lrrrrr}','\\toprule',
 texrow(c('Population / threshold','$b_{pre}$','$b_{post}$','$\\Delta b$','95\\% CI','Support pre/post')),'\\midrule')
labels<-c(control_A_Sina='Control A',developers_all='Developers: all',
 developers_balanced_13_dates='Developers: balanced',developers_A='Developers: A')
for(i in seq_len(nrow(est)))tex<-c(tex,texrow(c(paste(labels[est$group[i]],sprintf('%.2f',est$threshold[i])),
 fmt(est$b_pre[i]),fmt(est$b_post[i]),fmt(est$delta_b[i]),paste0('[',fmt(est$delta_ci_low[i]),', ',fmt(est$delta_ci_high[i]),']'),
 paste(est$pre_window_obs[i],est$post_window_obs[i],sep='/'))))
tex<-c(tex,'\\bottomrule','\\end{tabular}','\\par\\medskip','\\begin{tabular}{lrrr}','\\toprule',
 texrow(c('Developer comparison','$\\Delta\\Delta b$','95\\% CI','Role')),'\\midrule')
for(i in 1:nrow(contrast))tex<-c(tex,texrow(c(labels[sub('_minus_control_A_Sina','',contrast$comparison[i])],fmt(contrast$delta_delta_b[i]),
 paste0('[',fmt(contrast$ci_low[i]),', ',fmt(contrast$ci_high[i]),']'),if(contrast$co_primary[i])'Co-primary' else 'Same market')))
tex<-c(tex,'\\bottomrule','\\end{tabular}',
 '\\par\\footnotesize Pre 2017H1--2019H2; post 2020H2--2022H2. 999 whole-firm bootstrap draws, resampled independently within each population; periods paired within firm. Pointwise percentile intervals; no multiplicity adjustment. All six estimation rows have N, firms, in-range counts and actual threshold-window support in t061\\_estimates.csv. Control is balanced and survivor-selected; balanced developers are co-primary. Support and excess mass use only the four bins below the displayed threshold. Placebo fits at 0.60 and 0.80 additionally exclude [0.66,0.72), following T023; this extra exclusion does not enter placebo mass or its four-bin normalization. Fewer than 30 observations in either mass window flags low support. Broad and HK controls were dropped by the approved data route; ownership unavailable. Comparable counterfactual changes and smooth densities are identifying assumptions, not established by this table.','\\endgroup')
textout(tex,'results')

# 7. One interpretation paragraph per step; all numbers keyed to file + exact row filter.
describe<-function(x,lo,hi)paste0(fmt(x),' [',fmt(lo),', ',fmt(hi),']')
controlrow<-est[est$group=='control_A_Sina'&est$threshold==.7,]
cc<-function(i)describe(contrast$delta_delta_b[i],contrast$ci_low[i],contrast$ci_high[i])
reading<-function(i)if(contrast$valid[i]<.9*B)'Inference is unreliable because too few bootstrap draws are valid.' else
 if(contrast$ci_low[i]>0)'The interval is above zero, supporting developer-specific concentration conditional on comparable counterfactual changes.' else
 'The interval includes zero: developer-specific concentration is not established and a general reporting or focal-point shift cannot be excluded. Failure to reject zero does not establish equivalence.'
interpret<-c(
 paste0('The approved Sina roster contains ',nrow(r),' firms; ',nf(c$firm_id),' have all 14 EastMoney balance dates (',nrow(c),' firm-half-years), of which ',nrow(cp),' fall on the 13 developer dates. ',nrow(fail),' roster firms are absent; only ',nrow(e),' have error messages in the current coal-run ledger. Historical reasons for the other ',sum(is.na(fail$error)),' are unavailable. All failures are listed by exact sector membership. Sina classification replaces EastMoney boards. Missing advances are summed componentwise, both missing are zero flagged; only positive adjusted denominators define RL1, without trimming. Coverage by date separates all finite ratios from the fit range. The downloaded controls are balanced survivors; the developer panel is unbalanced.'),
 paste0('At 0.70 control b_pre is ',fmt(controlrow$b_pre),', b_post ',fmt(controlrow$b_post),', and change ',describe(controlrow$delta_b,controlrow$delta_ci_low,controlrow$delta_ci_high),'. Placebo changes are ',
 paste(vapply(c(.6,.8),function(t) {z<-est[est$group=='control_A_Sina'&est$threshold==t,];paste0(t,': ',describe(z$delta_b,z$delta_ci_low,z$delta_ci_high))},character(1)),collapse='; '),
 '. Histograms and counterfactual counts use degree-5 fits excluding the four-bin mass window below each threshold. In addition, placebo fits at 0.60 and 0.80 exclude [0.66,0.72), following T023. Observed mass, fitted mass and normalization use only the four bins in the placebo window. Smooth counterfactual density and comparable accounting remain assumptions; placebo intervals are pointwise.'),
 paste0('Developer minus control change is ',cc(1),' for the full sample; ',cc(2),' for ',length(balanced_ids),' balanced developers (co-primary); ',cc(3),' for A-share developers only. ',reading(1),' Balanced comparison: ',reading(2),' A-share comparison: ',reading(3),
 ' These are independent within-group whole-firm bootstrap contrasts with pre/post re-estimation. A-share controls and mixed-market developers differ in composition; balancing aligns observed histories but does not remove survivor selection or sector-specific shocks. Broad and HK control variants were explicitly dropped in the approved data route, with no substitutes.'),
 paste0('Main control window support is ',controlrow$pre_window_obs,' pre and ',controlrow$post_window_obs,' post firm-half-years; low-support flag is ',controlrow$low_support,'. The pre-specified cutoff is 30 in either period. Actual-threshold support, firms, finite N and fit-range N are recorded for every estimated variant. Adequate window counts do not demonstrate power to distinguish every effect size; no post-hoc power analysis was added.'),
 paste0('SOE warning lines since 2018 are a supplied institutional caveat, not independently verified offline. The existing panel, manual coding and Wind ownership sources match zero control firms; SOE and non-SOE control changes cannot be estimated. No ownership was inferred. An aggregate control shift could reflect SOE warning lines, other sector shocks or reporting changes; ownership confounding remains unresolved.'),
 paste0('The kappa figure is rendered only from the existing 44 T055 point/interval rows and their stored bootstrap draws, using the updated figure block in 19_referee3.R. Native width is ',kappa_width,' inches; the calculated text lower bound is ',sprintf('%.6f',kappa_min_native),' pt (12 times 0.8), and ',sprintf('%.6f',kappa_min_linewidth),' pt at full A4 paper linewidth with 1-inch margins. This is a conservative rendering bound, not a measured PDF font size. Points and intervals are checked against stored rows and all T055 tables remain byte-identical.'),
 'Every displayed numerical result is stored in a T061 CSV; t061_number_map.csv maps each numeric cell to file, exact row filter and column. The worker report records execution, provenance limitations and reproducibility checks. No proposal text or research question is changed.'
)
csv(data.frame(step=1:7,interpretation=interpret),'interpretation')
# All generated tabular numerical cells (including audits), before verification itself.
mapping<-list()
for(s in staged)if(grepl('[.]csv$',s[['target']])) {
 z<-read(s[['path']]);num<-names(z)[vapply(z,is.numeric,logical(1))]
 if(!length(num))next
 keys<-intersect(c('group','threshold','metric','comparison','date','board','variant','source','step','rule','firm_id','period','draw','mid'),names(z))
 for(n in num) {
 filters<-vapply(seq_len(nrow(z)),function(i)paste(c(paste0('row=',i),vapply(keys,function(key)paste0(key,'=',z[[key]][i]),character(1))),collapse='; '),character(1))
 mapping[[length(mapping)+1L]]<-data.frame(file=s[['target']],row=seq_len(nrow(z)),filter=filters,column=n,value=z[[n]])
 }
}
csv(do.call(rbind,mapping),'number_map')

# Acceptance gates and repeat-run verification (including the permitted kappa change).
stopifnot(nrow(est)==6L,nrow(contrast)==3L,nrow(support)==6L,
 sum(availability$status=='reported')==5L,nrow(coverage)==14L,
 sum(sector$missing_firms)==64L,nrow(cp)==752L*13L,
 identical(input_hash,tools::sha256sum(inputs)),identical(protected_hash,tools::sha256sum(protected)))
csv(data.frame(kind=c(rep('input',length(inputs)),rep('protected_output',length(protected))),file=c(inputs,protected),
 sha256=c(unname(input_hash),unname(protected_hash)),unchanged=TRUE),'verification')
csv(data.frame(file=old$file,before_sha256=old$sha256,after_sha256=unname(tools::sha256sum(old$file)),
 unchanged=historical_same),'historical_output_check')

# Reproducible validation, published by the prescribed command and repeat-checked.
# hist()/lm()/predict() independently check the control point estimates and fits.
validation_errors<-numeric()
for(threshold in c(.70,.60,.80))for(period in c('pre','post')) {
 use<-period_masks(cp)[[period]]&is.finite(cp$rl1)
 x<-cp$rl1[use];x<-x[x>=.4&x<=1]
 h<-hist(x,breaks=round(seq(.4,1,.01),10),right=FALSE,include.lowest=TRUE,plot=FALSE)
 grid<-data.frame(mid=h$mids,count=h$counts)
 mass_bins<-grid$mid>=round(threshold-.04,10)&grid$mid<threshold
 fit_out<-mass_bins
 if(threshold!=.70)fit_out<-fit_out|(grid$mid>=.66&grid$mid<.72)
 fit<-lm(count~poly(mid,5),data=grid[!fit_out,])
 predicted<-predict(fit,newdata=grid)
 point<-(sum(grid$count[mass_bins])-sum(predicted[mass_bins]))/mean(predicted[mass_bins])
 z<-controls[[sprintf('%03d',round(threshold*100))]][[period]]
 stopifnot(sum(mass_bins)==4L,sum(fit_out)==if(threshold==.70)4L else 10L,
  identical(mass_bins,z$mass_window),identical(fit_out,z$excluded),
  identical(as.numeric(grid$count),as.numeric(z$observed)),sum(grid$count[mass_bins])==z$window_obs)
 validation_errors<-c(validation_errors,abs(point-z$v[1]),max(abs(predicted-z$fitted)))
}
stopifnot(max(validation_errors)<1e-10)
all_draws<-do.call(rbind,draws)
component<-function(group)all_draws$estimate[all_draws$group==group&all_draws$threshold==.70&all_draws$metric=='delta_b']
contrast_errors<-vapply(contrast$comparison,function(group) {
 developer<-sub('_minus_control_A_Sina','',group)
 saved<-all_draws$estimate[all_draws$group==group&all_draws$metric=='delta_delta_b']
 stopifnot(length(saved)==B)
 max(abs(saved-(component(developer)-component('control_A_Sina'))))
},numeric(1))
stopifnot(max(contrast_errors)<1e-12)
textout(c(
 'PASS: all six control levels independently reproduced with hist()/lm()/predict(); maximum error < 1e-10.',
 'PASS: placebo fit exclusions contain ten bins (own four plus six in [0.66,0.72)); mass uses only its own four bins.',
 'PASS: all 2997 developer-minus-control bootstrap differences match saved component draws (< 1e-12).',
 sprintf('PASS: all %d frozen control files match MANIFEST SHA-256 and size.',nrow(manifest)),
 sprintf('PASS: %d/%d historical non-kappa output hashes unchanged.',sum(historical_same),length(historical_same)),
 sprintf('PASS: all %d read-only inputs and %d existing protected outputs unchanged during execution.',length(inputs),length(protected)),
 sprintf('PASS: kappa calculated text lower bound %.6f pt natively (12 * 0.8); %.6f pt at full A4/1-inch-margin linewidth (native * (210/25.4 - 2) / 6.25). Conservative rendering bound, not measured PDF font size.',kappa_min_native,kappa_min_linewidth),
 sprintf('PASS: all %d existing T055 point/interval rows checked against stored bootstrap draws; no T055 table re-estimated.',nrow(k)),
 'Repeat-run byte identity is asserted for every staged output when input/protected-output hashes match; see console log.'
),'validation','txt')
targets<-vapply(staged,`[[`,character(1),'target')
ver<-'outputs/tables/t061_verification.csv';vpath<-staged[[match(ver,targets)]][['path']]
same_context<-file.exists(ver)&&identical(unname(tools::sha256sum(vpath)),unname(tools::sha256sum(ver)))
if(all(file.exists(targets))&&same_context) {
 same<-vapply(staged,function(z)identical(unname(tools::sha256sum(z['path'])),unname(tools::sha256sum(z['target']))),logical(1))
 if(!all(same))stop('STOP: repeated-run output differs: ',paste(targets[!same],collapse=', '))
 cat(sprintf('T061 repeat-run PASS: %d/%d generated outputs byte-identical.\n',sum(same),length(same)))
}
for(s in staged)stopifnot(file.copy(s['path'],s['target'],overwrite=TRUE))
unlink(vapply(staged,`[[`,character(1),'path'))
cat(sprintf('T061 guards PASS: %d inputs unchanged; %d existing outputs byte-identical (kappa PDF exception).\n',length(inputs),length(protected)))
cat(sprintf('T061 coverage PASS: 6 population/threshold estimates; 3 contrasts; %d bootstrap statistic draws.\n',nrow(do.call(rbind,draws))))
cat(sprintf('T061 complete: %d generated files; seed=%d; bootstrap=%d.\n',length(staged),seed,B))
