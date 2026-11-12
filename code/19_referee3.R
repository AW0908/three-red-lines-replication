# T055: approved descriptive referee checks. Offline; run from replication/.
# All counterfactuals are accounting sensitivities, not identified policy effects.
options(digits = 17)
seed <- 20261016L; B <- 999L; set.seed(seed)
read <- function(p) read.csv(p, stringsAsFactors=FALSE, na.strings=c('', 'NA', '--'))
nf <- function(x) length(unique(x[!is.na(x)]))
inputs <- c('code/19_referee3.R', 'data/processed/panel_firm_halfyear.csv', 'code/11_mechanism.R',
 'code/15_referee2.R', 'code/06_bunching_tests.R',
 list.files('outputs/tables', '^t029_', full.names=TRUE),
 'outputs/tables/t043_trend_cf.csv', 'outputs/tables/t009_pretrend_tests.csv',
 'outputs/tables/t028_pretrend_controls.csv')
stopifnot(all(file.exists(inputs)))
input_hash <- tools::sha256sum(inputs)
protected <- list.files('outputs', recursive=TRUE, full.names=TRUE, all.files=TRUE)
protected <- protected[!dir.exists(protected) & !grepl('^t055_', basename(protected))]
protected_hash <- tools::sha256sum(protected)
d <- read('data/processed/panel_firm_halfyear.csv'); d <- d[!is.na(d$sample_main) & d$sample_main, ]
d$date <- as.Date(d$date); d <- d[order(d$firm_id,d$date), ]; rownames(d) <- NULL
stopifnot(!anyDuplicated(d[c('firm_id','date')]))
firms <- sort(unique(d$firm_id)); G <- length(firms); fi <- match(d$firm_id,firms)
w <- replicate(B, tabulate(sample.int(G,G,replace=TRUE), nbins=G))
W <- cbind(rep(1L,G),w)
pre <- d$date>=as.Date('2017-06-30') & d$date<=as.Date('2019-12-31')
post <- d$date>=as.Date('2020-12-31') & d$date<=as.Date('2022-12-31')
placebo <- d$date>=as.Date('2017-12-31') & d$date<=as.Date('2019-12-31')
N <- d$tl-d$adv; valid <- is.finite(N) & N>0 & is.finite(d$te) & d$te>0
R <- ifelse(valid,N/(N+d$te),NA_real_)
anchor_mi <- function(anchor) d$mi[match(paste(d$firm_id,anchor),paste(d$firm_id,d$date))]
freeze <- function(anchor) {
 den <- N+d$te-d$mi+anchor_mi(anchor)
 ifelse(valid & is.finite(d$mi) & is.finite(den) & den>0,N/den,NA_real_)
}
Fpost <- freeze('2019-12-31'); Fplacebo <- freeze('2016-12-31')
pairs <- list(post=post & is.finite(R) & is.finite(Fpost),
 placebo=placebo & is.finite(R) & is.finite(Fplacebo))
edges <- round(seq(.4,1,.01),10); mid <- (head(edges,-1)+tail(edges,-1))/2
mass <- mid>=.66 & mid<.70
X <- cbind(1,poly(mid,degree=5)); qrfit <- qr(X[!mass,,drop=FALSE])
stopifnot(sum(mass)==4L,qrfit$rank==6L)
fit_counts <- function(y) {
 y <- as.matrix(y); pred <- X %*% qr.coef(qrfit,y[!mass,,drop=FALSE])
 good <- colSums(!is.finite(pred[mass,,drop=FALSE]) | pred[mass,,drop=FALSE]<=0)==0
 cf <- colSums(pred[mass,,drop=FALSE]); obs <- colSums(y[mass,,drop=FALSE])
 ifelse(good,(obs-cf)/(cf/sum(mass)),NA_real_)
}
mass_est <- function(x,use,weights=W) {
 ix <- findInterval(x,edges,rightmost.closed=TRUE)
 inside <- use & is.finite(x) & !is.na(ix) & ix>0L & ix<length(edges)
 a <- matrix(0,G,length(mid))
 for(i in which(inside)) a[fi[i],ix[i]] <- a[fi[i],ix[i]]+1
 fit_counts(t(a)%*%weights)
}
stat_est <- function(x,use,stat='mean',weights=W) {
 use <- use & is.finite(x)
 vapply(seq_len(ncol(weights)),function(j) {
  ww <- weights[fi[use],j]; yy <- x[use]; ok <- ww>0
  if(!any(ok))return(NA_real_)
  if(stat=='mean')weighted.mean(yy[ok],ww[ok]) else median(rep(yy[ok],ww[ok]))
 },numeric(1))
}
b0 <- mass_est(d$rl1,post); bp <- mass_est(d$rl1,pre)
D0 <- stat_est(as.numeric(R<=.7)-as.numeric(Fpost<=.7),pairs$post)
rD <- read('outputs/tables/t029_compliance.csv')
rD <- rD[rD$window=='post' & rD$date=='pooled' & rD$variant=='all' & rD$metric=='D',]
# T029 accounting R is reconstructed from N/E. One historical stored RL1
# differs by 5.08e-8 (rounding); retain both in the sample audit.
stopifnot(all(abs(R[is.finite(R)]-d$rl1[is.finite(R)])<1e-6),
 round(b0[1],2)==3.14,round(D0[1],4)==.1146,
 sum(pairs$post)==602L,nf(d$firm_id[pairs$post])==129L,
 nrow(rD)==1L,abs(D0[1]-rD$estimate)<1e-12)
cat(sprintf('T055 reproduction PASS: b_post=%.12f; D=%.12f; pairs=602; firms=129.\n',b0[1],D0[1]))

# All writes are staged until every acceptance assertion and hash guard passes.
staged <- list()
stage <- function(path,target) {
 stopifnot(grepl('^t055_',basename(target)))
 staged[[length(staged)+1L]] <<- c(path=path,target=target)
}
csv <- function(x,name) {
 f <- tempfile(fileext='.csv'); con <- file(f,'wb')
 write.csv(x,con,row.names=FALSE,na='NA',eol='\n'); close(con)
 stage(f,paste0('outputs/tables/t055_',name,'.csv'))
}
fmt <- function(x) ifelse(is.finite(x),sprintf('%.4f',x),'--')
esc <- function(x) gsub('_','\\_',x,fixed=TRUE)
texrow <- function(x) paste0(paste(x,collapse=' & '),' \\\\')
tex <- function(name,header,rows,align,note,chunk=16L) {
 out <- character()
 for(rr in split(rows,ceiling(seq_along(rows)/chunk)))out <- c(out,
  '\\begingroup\\scriptsize\\setlength{\\tabcolsep}{3pt}','\\begin{threeparttable}',
  paste0('\\begin{tabular}{',align,'}'),'\\toprule',texrow(header),'\\midrule',rr,
  '\\bottomrule','\\end{tabular}','\\begin{tablenotes}[flushleft]\\footnotesize',
  paste0('\\item[] ',note),'\\end{tablenotes}','\\end{threeparttable}','\\endgroup','\\par\\medskip')
 f <- tempfile(fileext='.tex'); con <- file(f,'wb'); writeLines(out,con,useBytes=TRUE);close(con)
 stage(f,paste0('outputs/tables/t055_',name,'.tex'))
}
summary_boot <- function(v) {
 ok <- is.finite(v); q <- if(any(ok))quantile(v[ok],c(.025,.975),names=FALSE) else c(NA,NA)
 list(se=if(sum(ok)>1L)sd(v[ok]) else NA_real_,ci_low=q[1],ci_high=q[2],
 bootstrap_draws=B,bootstrap_valid=sum(ok),bootstrap_failed=sum(!ok))
}
rows <- list(); draw_rows <- list()
# Shared long-format schema: each contrast explicitly carries both sample sizes.
record <- function(table,metric,period,scope,v,use,benchmark=NULL,kappa=NA_real_,
 anchor=NA_character_,reason='estimated',extras=list()) {
 stopifnot(length(v)==B+1L)
 st <- summary_boot(v[-1]); if(!is.finite(v[1]))st[c('se','ci_low','ci_high')] <- NA_real_
 r <- data.frame(table=table,metric=metric,period=period,scope=scope,kappa=kappa,
 anchor=anchor,estimate=v[1],n=sum(use),firms=nf(d$firm_id[use]),
 benchmark_n=if(is.null(benchmark))NA_integer_ else sum(benchmark),
 benchmark_firms=if(is.null(benchmark))NA_integer_ else nf(d$firm_id[benchmark]),
 firms_union=nf(d$firm_id[use | if(is.null(benchmark))FALSE else benchmark]),
 as.data.frame(st),status=if(!is.finite(v[1]))reason else 'estimated',
 inference_status=if(!is.finite(v[1]))'invalid_point' else
 if(st$bootstrap_valid<.9*B)'unreliable_below_90pct' else
 if(st$bootstrap_valid<B)'conditional_on_valid_draws' else 'all_draws_valid',
 stringsAsFactors=FALSE)
 for(nm in names(extras))r[[nm]] <- extras[[nm]]
 rows[[length(rows)+1L]] <<- r
 draw_rows[[length(draw_rows)+1L]] <<- data.frame(table=table,metric=metric,period=period,
 scope=scope,kappa=kappa,anchor=anchor,draw=seq_len(B),estimate=v[-1])
 invisible(r)
}
bind <- function(xx) {
 cols <- unique(unlist(lapply(xx,names)))
 do.call(rbind,lapply(xx,function(z) {for(n in setdiff(cols,names(z)))z[[n]]<-NA;z[cols]}))
}
common_note <- paste('Main sample; 999 common whole-firm resamples of the full 136-firm universe, seed 20261016.',
 'All CIs are pointwise percentile intervals; invalid draws omitted and counted in CSV; fewer than 90 percent valid is unreliable.',
 'Post: 2020H2--2022H2, anchor end-2019; placebo: 2017H2--2019H2, anchor end-2016.',
 'b: excess count / mean fitted mass-bin count; degree 5 over [0.40,1.00], 0.01 bins, excluded/mass window [0.66,0.70).',
 'Zero bins and final right edge retained; no clipping or integration constraint. Descriptive; no causal policy interpretation.')
compact <- function(z,name,note) {
 label <- paste(gsub('_',' ',z$period),gsub('_',' ',z$scope),gsub('_',' ',z$metric))
 label[is.finite(z$kappa)] <- paste(label[is.finite(z$kappa)],sprintf('k=%.1f',z$kappa[is.finite(z$kappa)]))
 ntext <- function(a,b)ifelse(is.na(b),as.character(a),paste(a,b,sep='/'))
 tex(name,c('Period / scope / metric','N','Firms','Estimate','95\\% CI','Valid'),
 vapply(seq_len(nrow(z)),function(i)texrow(c(label[i],ntext(z$n[i],z$benchmark_n[i]),
 ntext(z$firms[i],z$benchmark_firms[i]),fmt(z$estimate[i]),
 paste0('[',fmt(z$ci_low[i]),', ',fmt(z$ci_high[i]),']'),paste0(z$bootstrap_valid[i],'/999'))),character(1)),
 'p{6.0cm}rrrrr',paste(common_note,'For contrasts N/Firms show first/benchmark populations.',note))
}

# 1. Paired within-date ratio shifts; the same firms are drawn in both periods.
shift <- list(post=100*(Fpost-R),placebo=100*(Fplacebo-R))
for(scope in c('all_pairs','reported_060_080')) {
 u <- lapply(pairs,function(z)z & if(scope=='all_pairs')TRUE else R>=.60 & R<=.80)
 u <- lapply(u,function(z){z[is.na(z)]<-FALSE;z})
 for(stat in c('mean','median')) {
  a <- stat_est(shift$post,u$post,stat); b <- stat_est(shift$placebo,u$placebo,stat)
  record('mi_shift',paste0(stat,'_shift_pp'),'post',scope,a,u$post,anchor='2019-12-31')
  record('mi_shift',paste0(stat,'_shift_pp'),'placebo',scope,b,u$placebo,anchor='2016-12-31')
  record('mi_shift',paste0(stat,'_shift_pp'),'post_minus_placebo',scope,a-b,u$post,u$placebo)
 }
}
# Reweight the placebo D to the contemporaneous paired post R distribution.
# Within [0.60,0.80], bins are left-closed, final bin includes 0.80.
bin_edges <- round(seq(.60,.80,.02),10)
bin <- findInterval(R,bin_edges,rightmost.closed=TRUE)
range_use <- is.finite(R) & R>=.60 & R<=.80
up <- pairs$post & range_use; ul <- pairs$placebo & range_use
Dy_post <- as.numeric(R<=.7)-as.numeric(Fpost<=.7)
Dy_placebo <- as.numeric(R<=.7)-as.numeric(Fplacebo<=.7)
ipw_audit <- list()
reweighted <- vapply(seq_len(ncol(W)),function(j) {
 ww <- W[fi,j]
 target <- vapply(1:10,function(k)sum(ww[up & bin==k]),numeric(1))
 source <- vapply(1:10,function(k)sum(ww[ul & bin==k]),numeric(1))
 missing <- target>0 & source==0
 p <- target/sum(target); q <- source/sum(source)
 bw <- ifelse(source>0,p/q,NA_real_)
 if(j==1L)ipw_audit[[1]] <<- data.frame(lower=head(bin_edges,-1),upper=tail(bin_edges,-1),
 post_n=target,placebo_n=source,post_share=p,placebo_share=q,bin_weight=bw,
 unsupported_target_bin=missing)
 if(any(missing) || !sum(target) || !sum(source))return(NA_real_)
 z <- which(ul); usew <- ww[z]*ifelse(is.finite(bw[bin[z]]),bw[bin[z]],0)
 weighted.mean(Dy_placebo[z],usew)
},numeric(1))
rdpost <- stat_est(Dy_post,up); rdplacebo <- stat_est(Dy_placebo,ul)
record('mi_shift','D','post','reported_060_080',rdpost,up)
record('mi_shift','D','placebo','reported_060_080',rdplacebo,ul)
record('mi_shift','D_reweighted','placebo','reported_060_080',reweighted,ul,up,
 reason='unavailable_target_bin_without_placebo_support')
record('mi_shift','D_post_minus_reweighted_placebo','post_minus_placebo','reported_060_080',
 rdpost-reweighted,up,ul,reason='unavailable_target_bin_without_placebo_support')
csv(ipw_audit[[1]],'mi_reweight_bins')
cat('T055 step 1: density-free shifts and reweighted D computed.\n')

# 2. Reclassification retains the total denominator. Negative MI growth is zero.
kgrid <- seq(0,1,.1); kresults <- list(); kbreak <- list()
first_crossing <- function(y,k,kind='point') {
 if(!is.finite(y[1]))return(list(value=NA_real_,status='invalid_initial_fit'))
 if(y[1]<=0)return(list(value=0,status='already_nonpositive_at_zero'))
 for(i in 2:length(y))if(is.finite(y[i-1]) && is.finite(y[i]) && y[i-1]>0 && y[i]<=0)
  return(list(value=k[i-1]+(k[i]-k[i-1])*y[i-1]/(y[i-1]-y[i]),status='interpolated_first_crossing'))
 list(value=NA_real_,status=if(any(!is.finite(y)))'unresolved_invalid_grid_fit' else 'never_on_0_1_grid')
}
for(period in names(pairs)) {
 anchor <- if(period=='post')'2019-12-31' else '2016-12-31'
 delta <- pmax(d$mi-anchor_mi(anchor),0); use <- pairs[[period]]
 bmat <- cmat <- matrix(NA_real_,length(kgrid),B+1L)
 for(i in seq_along(kgrid)) {
  x <- ifelse(valid & is.finite(delta),(N+kgrid[i]*delta)/(N+d$te),NA_real_)
  stopifnot(all(is.finite(x[use])),all(x[use]>=R[use]-1e-12))
  if(i==1L)stopifnot(all(abs(x[use]-R[use])<1e-12))
  bmat[i,] <- mass_est(x,use); cmat[i,] <- stat_est(as.numeric(x<=.7),use)
  record('kappa','b',period,'paired',bmat[i,],use,kappa=kgrid[i],anchor=anchor,
   extras=list(n_in_range=sum(use & x>=.4 & x<=1)))
  record('kappa','compliant_share',period,'paired',cmat[i,],use,kappa=kgrid[i],anchor=anchor)
 }
 stopifnot(all(diff(cmat[,1])<=1e-12))
 ci_low <- apply(bmat[,-1,drop=FALSE],1,function(z)summary_boot(z)$ci_low)
 ci_high <- apply(bmat[,-1,drop=FALSE],1,function(z)summary_boot(z)$ci_high)
 point <- first_crossing(bmat[,1],kgrid)
 # With positive b(0), first inclusion occurs when the lower bound reaches zero.
 # If the initial CI lies below zero and excludes it, use its upper bound instead.
 if(is.finite(ci_low[1]) && is.finite(ci_high[1]) && ci_low[1]<=0 && ci_high[1]>=0)
  incl <- list(value=0,status='CI_includes_zero_at_zero') else {
  boundary <- if(is.finite(ci_high[1]) && ci_high[1]<0)-ci_high else ci_low
  incl <- first_crossing(boundary,kgrid)
 }
 kresults[[period]] <- list(b=bmat,compliance=cmat,low=ci_low,high=ci_high)
 kbreak[[period]] <- data.frame(period=period,anchor=anchor,n=sum(use),firms=nf(d$firm_id[use]),
 kappa_point=point$value,point_status=point$status,kappa_CI=incl$value,CI_status=incl$status,
 interpolation='linear_between_0.1_grid_points_no_monotonicity_imposed')
 cat(sprintf('T055 step 2 %s: b(0)=%.6f; b(1)=%.6f; k*=%.6f; CI k*=%.6f.\n',
 period,bmat[1,1],bmat[11,1],point$value,incl$value))
}
csv(do.call(rbind,kbreak),'kappa_break_even')

# 3. Falsification: raw tl/ta, never rl1_alt; joint full-firm bootstrap.
raw <- ifelse(is.finite(d$tl) & is.finite(d$ta) & d$ta>0,d$tl/d$ta,NA_real_)
fu <- list(pre=pre & is.finite(raw) & is.finite(d$rl1),
 post=post & is.finite(raw) & is.finite(d$rl1))
# No definition-specific sample changes relative to the original RL1 estimator.
stopifnot(all(fu$pre==(pre & is.finite(d$rl1))),all(fu$post==(post & is.finite(d$rl1))))
fresults <- list()
for(period in c('pre','post')) {
 a <- mass_est(d$rl1,fu[[period]]); b <- mass_est(raw,fu[[period]])
 fresults[[period]] <- list(rl1=a,raw=b)
 record('falsification','b_RL1',period,'joint_available',a,fu[[period]])
 record('falsification','b_raw_tl_ta',period,'joint_available',b,fu[[period]])
 record('falsification','b_RL1_minus_raw',period,'joint_available',a-b,fu[[period]])
}
for(metric in c('rl1','raw'))record('falsification',paste0('delta_b_',metric),'post_minus_pre',
 'joint_available',fresults$post[[metric]]-fresults$pre[[metric]],fu$post,fu$pre)
record('falsification','delta_b_RL1_minus_raw','post_minus_pre','joint_available',
 (fresults$post$rl1-fresults$pre$rl1)-(fresults$post$raw-fresults$pre$raw),fu$post,fu$pre)
stopifnot(max(abs(fresults$post$rl1-b0),na.rm=TRUE)<1e-12,
 max(abs(fresults$pre$rl1-bp),na.rm=TRUE)<1e-12)
cat('T055 step 3: raw tl/ta and RL1 period/change contrasts computed jointly.\n')

# 4. T043 step 7 with linear MI levels. Same minimum-history and bin fallback.
# Nonpositive observed pre MI still disqualifies a donor (unchanged T043 rule).
h <- as.integer(format(d$date,'%Y'))*2L+as.integer(format(d$date,'%m')=='12')
trend_setup <- function(anchor) {
 ah <- as.integer(format(as.Date(anchor),'%Y'))*2L+as.integer(format(as.Date(anchor),'%m')=='12')
 ai <- match(paste(firms,anchor),paste(d$firm_id,d$date)); rl <- d$rl1[ai]
 bins <- ifelse(is.finite(rl)&rl>=.60&rl<.66,'060_066',
  ifelse(is.finite(rl)&rl>=.66&rl<.74,'066_074',
  ifelse(is.finite(rl)&rl>=.74&rl<=.80,'074_080','other')))
 slope <- rep(NA_real_,G); npre <- integer(G); bad <- logical(G)
 for(j in seq_len(G)) {
  ix <- which(fi==j & h>=ah-6L & h<=ah & is.finite(d$mi))
  npre[j] <- length(ix); bad[j] <- any(d$mi[ix]<=0)
  if(npre[j]>=4L && !bad[j])slope[j] <- unname(lm.fit(cbind(1,h[ix]-ah),d$mi[ix])$coefficients[2])
 }
 list(ah=ah,ai=ai,bin=bins,slope=slope,npre=npre,bad=bad,use=h>=ah+2L & h<=ah+6L)
}
trend_est <- function(z,weights,variant) {
 common <- rep(NA_real_,G)
 for(bin_name in unique(z$bin)) {
  donor <- z$bin==bin_name & is.finite(z$slope) & weights>0
  if(any(donor))common[z$bin==bin_name] <- median(rep(z$slope[donor],weights[donor]))
 }
 slope <- if(variant=='firm_trend')ifelse(is.finite(z$slope),z$slope,common) else common
 # As in T043, anchor the extrapolation at actual anchor MI. Only slope is OLS.
 mihat <- d$mi[z$ai][fi]+slope[fi]*(h-z$ah)
 den <- N+d$te-d$mi+mihat
 cf <- ifelse(valid & is.finite(d$mi) & is.finite(mihat) & is.finite(den) & den>0,N/den,NA_real_)
 use <- z$use & is.finite(R) & is.finite(cf) & weights[fi]>0
 weight_matrix <- matrix(weights,ncol=1)
 list(D=stat_est(as.numeric(R<=.7)-as.numeric(cf<=.7),use,weights=weight_matrix)[1],
 b=mass_est(cf,use,weight_matrix)[1],official_b=mass_est(R,use,weight_matrix)[1],
 use=use,cf=cf,mihat=mihat,slope=slope,n=sum(weights[fi[use]]),firms=nf(d$firm_id[use]),
 missing_trend_firms=sum(!is.finite(slope)&weights>0))
}
trends <- list(); trend_audit <- list(); trend_coverage <- list()
for(anchor in c('2019-12-31','2016-12-31','2017-06-30')) {
 z <- trend_setup(anchor)
 for(variant in c('firm_trend','bin_trend')) {
  point <- trend_est(z,rep(1L,G),variant)
  boots <- lapply(seq_len(B),function(j)trend_est(z,w[,j],variant))
  key <- paste(anchor,variant); trends[[key]] <- list(point=point,boot=boots)
  for(metric in c('D','b')) {
   v <- c(point[[metric]],vapply(boots,`[[`,numeric(1),metric))
   record('linear_trend',paste0(metric,'_trend'),anchor,variant,v,point$use,anchor=anchor,
    reason='unavailable_no_eligible_pre_history_or_valid_counterfactual',
    extras=list(donor_firms=sum(is.finite(z$slope)),fallback_firms=sum(!is.finite(z$slope)),
    fallback_firms_in_window=sum(!is.finite(z$slope) & firms %in% d$firm_id[z$use]),
    missing_trend_firms=point$missing_trend_firms,b_official_paired=point$official_b,
    n_in_range=sum(point$use & point$cf>=.4 & point$cf<=1),
    nonpositive_extrapolated_MI=sum(z$use & is.finite(point$mihat) & point$mihat<=0),
    invalid_cf_denominator=sum(z$use & valid & is.finite(point$mihat) &
     is.finite(d$mi) & N+d$te-d$mi+point$mihat<=0)))
  }
  trend_audit[[key]] <- data.frame(anchor=anchor,variant=variant,firm_id=firms,bin=z$bin,
   pre_n=z$npre,nonpositive_pre=z$bad,own_halfyear_level_slope=z$slope,
   used_halfyear_level_slope=point$slope,fallback=!is.finite(z$slope))
  trend_coverage[[key]] <- data.frame(anchor=anchor,variant=variant,draw=seq_len(B),
   n=vapply(boots,`[[`,numeric(1),'n'),firms=vapply(boots,`[[`,integer(1),'firms'),
   missing_trend_firms=vapply(boots,`[[`,integer(1),'missing_trend_firms'))
  cat(sprintf('T055 step 4 %s %s: pairs=%d/%d; D=%.6f; b=%.6f; donors=%d.\n',
   anchor,variant,point$n,point$firms,point$D,point$b,sum(is.finite(z$slope))))
 }
}
for(anchor in c('2016-12-31','2017-06-30'))for(variant in c('firm_trend','bin_trend')) {
 a <- trends[[paste('2019-12-31',variant)]]; b <- trends[[paste(anchor,variant)]]
 for(metric in c('D','b'))record('linear_trend',paste0(metric,'_trend'),paste0('post_minus_',anchor),variant,
 c(a$point[[metric]]-b$point[[metric]],vapply(a$boot,`[[`,numeric(1),metric)-vapply(b$boot,`[[`,numeric(1),metric)),
 a$point$use,b$point$use,reason='unavailable_placebo_history')
}
csv(do.call(rbind,trend_audit),'linear_trend_firms');csv(do.call(rbind,trend_coverage),'linear_trend_coverage')

# 5. Copy the published tests, with provenance; do not refit event studies.
t9 <- read('outputs/tables/t009_pretrend_tests.csv')
t28 <- read('outputs/tables/t028_pretrend_controls.csv')
t9$source <- 't009_pretrend_tests.csv'; t9$specification <- 'baseline'
t9$N <- NA_integer_; t9$n_firms <- NA_integer_
t28$source <- 't028_pretrend_controls.csv'
pt <- bind(list(t9,t28))
stopifnot(nrow(pt)==9L,round(pt$p_value[pt$outcome=='rl1' & pt$specification=='C3-date'],4)==.0002)
csv(pt,'pretrend_tests')
tex('pretrend_tests',c('Source','Outcome / spec.','F','df','p','N','Firms'),
 vapply(seq_len(nrow(pt)),function(i)texrow(c(if(pt$source[i]=='t009_pretrend_tests.csv')'T009' else 'T028',
 esc(paste(pt$outcome[i],pt$specification[i])),fmt(pt$statistic[i]),
 paste(pt$df[i],pt$df_denom[i],sep=','),fmt(pt$p_value[i]),
 ifelse(is.na(pt$N[i]),'--',pt$N[i]),ifelse(is.na(pt$n_firms[i]),'--',pt$n_firms[i]))),character(1)),
 'llrrrrr',paste('Values copied verbatim from T009/T028 CSVs (no re-estimation); decimals rounded for display.',
 'Joint Wald F tests of seven pre-policy interactions, 2016H2--2019H2. T009 does not record N/firms; -- means unrecorded.',
 'C0 is also shown in T028 to preserve both input tables. Controlled RL1 C3-date p=0.000222545565783325 rejects the tested pre-trend restriction;',
 'a non-rejection for another outcome does not establish parallel trends. No multiple-testing adjustment.'))
cat('T055 step 5: copied all 9 pre-trend tests; controlled RL1 p=0.000222545565783325.\n')

# Publish summaries, full draws, memberships and number-to-file-to-filter ledger.
all_rows <- bind(rows); all_draws <- do.call(rbind,draw_rows)
for(name in c('mi_shift','kappa','falsification','linear_trend')) {
 z <- all_rows[all_rows$table==name,]; csv(z,name)
 note <- switch(name,
  mi_shift=paste('Shift = 100(frozen minus reported RL1), in percentage points; negative shifts retained.',
   'Reported-range restriction uses accounting R in [0.60,0.80] in each period.',
   'D is a share, not percentage points. IPW placebo uses post bin shares / placebo bin shares in 0.02 bins;',
   'both source and target distributions re-estimated in each draw; unsupported target bins invalidate the draw.',
   'The D contrast compares restricted post D to reweighted restricted placebo D.'),
  kappa=paste('R(k)=(N+k max(MI minus anchor MI,0))/(N+E). Same official/frozen eligible pairs at every k.',
   'Reclassification conserves total debt plus equity; compliance means R(k) at most 0.70.',
   'Break-even values below are first linear interpolations of grid estimates, not exact roots of the discontinuous histogram statistic.',
   paste(vapply(seq_len(nrow(do.call(rbind,kbreak))),function(i){q<-do.call(rbind,kbreak)[i,];
    paste(q$period,': point k*',fmt(q$kappa_point),'(',esc(q$point_status),'); CI k*',fmt(q$kappa_CI),'(',esc(q$CI_status),').')},character(1)),collapse=' ')),
  falsification=paste('Raw ratio is total liabilities / total assets (tl/ta), with no deduction of advance receipts.',
   'Both definitions use identical available firm-dates; rl1-alt is never used.',
   'RL1 minus raw is computed in each joint draw; delta b is post minus pre.',
   'Smooth densities near 0.70 are assumed separately; a shared focal point can generate excess mass without policy targeting.'),
  linear_trend=paste('Linear MI = actual anchor MI + OLS pre-policy level slope times elapsed half-years.',
   'OLS uses all finite pre MI in inclusive prior three years, at least four observations and no observed nonpositive MI, as T043 eligibility.',
   'Own variant falls back to the median eligible slope in the anchor RL1 bin; bin variant uses that median for all firms.',
   'Bins [0.60,0.66), [0.66,0.74), [0.74,0.80], other; no global fallback. Each draw re-estimates donor medians and density.',
   'No clipping of extrapolated MI; invalid total denominators excluded and counts recorded.',
   'Placebo pre histories have only one/two dates, so their estimates and contrasts are unavailable.',
   'Level-slope fallback assumes comparable monetary units within each bin across firms (including HK currency uncertainty).'))
 compact(z,name,note)
}
csv(all_draws,'bootstrap_draws')
csv(data.frame(firm_id=d$firm_id,date=as.character(d$date),sample_main=TRUE,
 pre=pre,post=post,placebo=placebo,valid_N_E=valid,R=R,reported_panel_rl1=d$rl1,
 raw_tl_ta=raw,frozen_post=Fpost,frozen_placebo=Fplacebo,
 post_pair=pairs$post,placebo_pair=pairs$placebo,
 shift_post_pp=shift$post,shift_placebo_pp=shift$placebo,
 range_060_080=range_use,reweight_bin=ifelse(range_use,bin,NA_integer_)), 'sample_audit')
ledger <- all_rows[,c('table','metric','period','scope','kappa','anchor','estimate','n','firms','benchmark_n','benchmark_firms')]
ledger$file <- paste0('replication/outputs/tables/t055_',ledger$table,'.csv')
ledger$filter <- vapply(seq_len(nrow(ledger)),function(i)paste0('metric=',ledger$metric[i],
 '; period=',ledger$period[i],'; scope=',ledger$scope[i],
 if(is.finite(ledger$kappa[i]))paste0('; kappa=',sprintf('%.1f',ledger$kappa[i])) else ''),character(1))
csv(ledger,'number_map')

# Base graphics vector PDF; fixed metadata permits exact two-run comparison.
f <- tempfile(fileext='.pdf')
grDevices::pdf(f,width=6.25,height=4.3,pointsize=12,useDingbats=FALSE,timestamp=FALSE,title='T055 kappa reclassification')
par(mfrow=c(1,2),mar=c(4.5,4.5,3,1),oma=c(3,0,0,0),cex=1,cex.axis=.85,cex.lab=.9,cex.main=.9)
colors <- c(post='#245B85',placebo='#B44E31')
for(metric in c('b','compliance')) {
 vals <- lapply(kresults,function(z)if(metric=='b')z$b else z$compliance)
 lows <- lapply(vals,function(z)apply(z[,-1,drop=FALSE],1,function(x)summary_boot(x)$ci_low))
 highs <- lapply(vals,function(z)apply(z[,-1,drop=FALSE],1,function(x)summary_boot(x)$ci_high))
 limits <- range(c(unlist(lows),unlist(highs),vapply(vals,function(z)z[,1],numeric(11))),finite=TRUE)
 plot(NA,xlim=c(0,1),ylim=limits,xlab=expression(kappa),
 ylab=if(metric=='b')'Excess mass b' else 'Compliant share',main=if(metric=='b')'Bunching at 0.70' else 'RL1 at most 0.70')
 if(metric=='b')abline(h=0,lty=3,col='grey40')
 for(p in names(vals)) {
  polygon(c(kgrid,rev(kgrid)),c(lows[[p]],rev(highs[[p]])),border=NA,col=adjustcolor(colors[p],alpha.f=.12))
  lines(kgrid,vals[[p]][,1],col=colors[p],lwd=2,type='b',pch=if(p=='post')16 else 17)
 }
 legend('topright',c('Post','Placebo'),col=colors,lty=1,pch=c(16,17),bty='n',cex=.8)
}
mtext('Paired populations; shaded pointwise 95% firm-bootstrap CIs.',outer=TRUE,side=1,line=1.2,cex=.8)
mtext('kappa is an assumed reclassified share.',outer=TRUE,side=1,line=0,cex=.8)
invisible(dev.off()); stage(f,'outputs/figures/t055_kappa.pdf')

# Hard coverage checks and unchanged-input/output evidence.
stopifnot(sum(all_rows$table=='mi_shift')==16L,
 sum(all_rows$table=='kappa')==44L,sum(all_rows$table=='falsification')==9L,
 sum(all_rows$table=='linear_trend')==20L,
 nrow(all_draws)==nrow(all_rows)*B,
 identical(input_hash,tools::sha256sum(inputs)),
 identical(protected_hash,tools::sha256sum(protected)))
csv(data.frame(kind=c(rep('input',length(inputs)),rep('protected_output',length(protected))),
 file=c(inputs,protected),sha256=c(unname(input_hash),unname(protected_hash)),unchanged=TRUE),'verification')
# If all targets already exist, compare them before replacing; fail on any drift.
# This makes the second execution itself a byte-for-byte reproducibility check.
targets <- vapply(staged,`[[`,character(1),'target')
verification_target <- 'outputs/tables/t055_verification.csv'
verification_stage <- staged[[match(verification_target,targets)]][['path']]
same_context <- file.exists(verification_target) &&
 identical(unname(tools::sha256sum(verification_stage)),unname(tools::sha256sum(verification_target)))
if(all(file.exists(targets)) && same_context) {
 same <- vapply(staged,function(z)identical(unname(tools::sha256sum(z['path'])),
  unname(tools::sha256sum(z['target']))),logical(1))
 if(!all(same))stop('STOP: repeated-run output differs: ',paste(targets[!same],collapse=', '))
 cat(sprintf('T055 repeat-run PASS: %d/%d staged outputs byte-identical.\n',sum(same),length(same)))
}
for(z in staged)stopifnot(file.copy(z['path'],z['target'],overwrite=TRUE))
unlink(vapply(staged,`[[`,character(1),'path'))
cat(sprintf('T055 guards PASS: %d inputs and %d existing outputs byte-identical.\n',length(inputs),length(protected)))
cat(sprintf('T055 coverage PASS: 16 shift, 44 kappa, 9 falsification, 20 trend rows; %d draws; 9 copied tests.\n',nrow(all_draws)))
cat(sprintf('T055 complete: %d CSV/TEX/PDF files; seed=%d; bootstrap=%d.\n',length(staged),seed,B))
