# T041: robustness of threshold targeting and frozen-MI dependence.
# Run from replication/: Rscript --vanilla code/14_core_robustness.R
# No causal interpretation: smooth counterfactual density and reporting selection
# remain assumptions. No data downloads or changes to the panel or T023 code.
source("code/00_setup.R", local = TRUE)
options(digits = 17)
seed <- 20261016L
B <- 999L
inputs <- c("data/processed/panel_firm_halfyear.csv", "code/06_bunching_tests.R",
            "code/11_mechanism.R", "code/12_q1_robustness.R", "../state/STATE.md")
input_hash <- tools::sha256sum(inputs)
protected <- list.files("outputs", recursive = TRUE, full.names = TRUE)
protected <- protected[!dir.exists(protected) & !grepl("^t041_", basename(protected))]
protected_hash <- tools::sha256sum(protected)
d <- read.csv(inputs[1], stringsAsFactors = FALSE, na.strings = c("", "NA"))
d <- d[!is.na(d$sample_main) & d$sample_main, ]
d$date <- as.Date(d$date)
d <- d[order(d$firm_id, d$date), ]
rownames(d) <- NULL
stopifnot(!anyDuplicated(d[c("firm_id", "date")]), length(unique(d$date)) == 13L)
d$halfyear <- as.integer(format(d$date, "%Y")) * 2L +
  as.integer(format(d$date, "%m") == "12")
pre <- d$date >= as.Date("2017-06-30") & d$date <= as.Date("2019-12-31")
post <- d$date >= as.Date("2020-12-31") & d$date <= as.Date("2022-12-31")
firms <- sort(unique(d$firm_id))
inside <- function(x, lo, hi) is.finite(x) & x >= lo & x < hi
make_weights <- function(ids) {
  # Reset to the T023 seed for each prespecified firm universe. Whole histories
  # are resampled, with fixed sample-specific G; periods share the same draws.
  set.seed(seed)
  replicate(B, tabulate(sample.int(length(ids), length(ids), replace = TRUE),
                        nbins = length(ids)))
}
weights <- make_weights(firms)
summarize <- function(x) {
  good <- is.finite(x)
  c(se = if (sum(good) > 1L) sd(x[good]) else NA_real_,
    ci_low = if (any(good)) unname(quantile(x[good], .025, type = 7)) else NA_real_,
    ci_high = if (any(good)) unname(quantile(x[good], .975, type = 7)) else NA_real_,
    bootstrap_valid = sum(good), bootstrap_failed = sum(!good))
}
firm_counts <- function(use, ids, edges) {
  ix <- findInterval(d$rl1, edges, rightmost.closed = TRUE)
  use <- use & d$firm_id %in% ids & is.finite(d$rl1)
  in_range <- use & !is.na(ix) & ix > 0L & ix < length(edges)
  z <- matrix(0, nrow(d), length(edges) - 1L)
  z[cbind(which(in_range), ix[in_range])] <- 1
  a <- rowsum(z, match(d$firm_id, firms), reorder = FALSE)
  all <- matrix(0, length(firms), ncol(z))
  all[as.integer(rownames(a)), ] <- a
  list(counts = all[match(ids, firms), , drop = FALSE], n = sum(use),
       n_in_range = sum(in_range), n_outside = sum(use & !in_range),
       firms_observed = length(unique(d$firm_id[use])))
}
mass_fit <- function(use, ids = firms, w = weights, width = .01, lower = .66,
                     upper = .70, degree = 5L, fit_lower = .40, fit_upper = 1) {
  edges <- round(seq(fit_lower, fit_upper, width), 10)
  mid <- (head(edges, -1L) + tail(edges, -1L))/2
  # T023 assigns exclusion and mass by bin midpoint. For nominal bounds not
  # aligned to a 0.02 grid, publish the realized edges rather than conceal them.
  excluded <- mid >= lower - 1e-12 & mid < upper - 1e-12
  mass <- excluded & mid < .70 - 1e-12
  stopifnot(any(mass), all(diff(edges) > 0), all(mid[mass] < .70))
  counts <- firm_counts(use, ids, edges)
  y <- colSums(counts$counts)
  y_boot <- t(counts$counts) %*% w
  X <- cbind(1, poly(mid, degree = degree))
  q <- qr(X[!excluded, , drop = FALSE])
  stopifnot(q$rank == ncol(X))
  fitted <- drop(X %*% qr.coef(q, y[!excluded]))
  # Linear least squares on a fixed basis: all bootstrap coefficients and
  # counterfactuals are re-estimated jointly, not held at their point values.
  fitted_boot <- X %*% qr.coef(q, y_boot[!excluded, , drop = FALSE])
  valid <- all(is.finite(fitted[mass]) & fitted[mass] > 0)
  cf <- sum(fitted[mass]); obs <- sum(y[mass])
  b <- if (valid) (obs - cf)/mean(fitted[mass]) else NA_real_
  cf_boot <- colSums(fitted_boot[mass, , drop = FALSE])
  good <- colSums(!is.finite(fitted_boot[mass, , drop = FALSE]) |
                    fitted_boot[mass, , drop = FALSE] <= 0) == 0L
  draws <- ifelse(good, (colSums(y_boot[mass, , drop = FALSE]) - cf_boot)/
                   (cf_boot/sum(mass)), NA_real_)
  s <- summarize(draws)
  if (!valid) s[c("se", "ci_low", "ci_high")] <- NA_real_
  status <- if (!valid) "invalid_counterfactual" else
    if (s["bootstrap_valid"]/B < .9) "unreliable_bootstrap_below_90pct" else
      if (s["bootstrap_failed"] > 0) "conditional_bootstrap" else "all_draws_valid"
  row <- data.frame(b = b, as.list(s), bootstrap_draws = B,
    valid_counterfactual = valid, bootstrap_meets_90pct = s["bootstrap_valid"]/B >= .9,
    inference_status = status, ci_excludes_zero = is.finite(s["ci_low"]) &&
      (s["ci_low"] > 0 || s["ci_high"] < 0),
    positive_supported = valid && s["bootstrap_valid"]/B >= .9 && is.finite(s["ci_low"]) &&
      s["ci_low"] > 0, n = counts$n, firms = counts$firms_observed,
    bootstrap_universe_firms = length(ids), n_in_range = counts$n_in_range,
    n_outside = counts$n_outside, observed_window = obs, counterfactual_window = cf,
    window_bins = sum(mass), negative_fitted_bins = sum(fitted < 0),
    actual_mass_lower = min(head(edges, -1L)[mass]),
    actual_mass_upper = max(tail(edges, -1L)[mass]),
    actual_exclusion_lower = min(head(edges, -1L)[excluded]),
    actual_exclusion_upper = max(tail(edges, -1L)[excluded]),
    excess_fraction = if (valid) (obs - cf)/cf else NA_real_,
    b_in_001_bins = b * width/.01, row.names = NULL)
  list(row = row, draws = draws, cf_draws = ifelse(good, cf_boot, NA_real_))
}

# Frozen-MI construction follows T029's N/E domain and accounting definition.
d$N <- d$tl-d$adv
d$valid <- is.finite(d$N)&d$N>0&is.finite(d$te)&d$te>0
d$official <- ifelse(d$valid,d$N/(d$N+d$te),NA_real_)
frozen <- function(anchor) {
  mi0<-d$mi[match(paste(d$firm_id,anchor),paste(d$firm_id,d$date))]
  den<-d$N+d$te-d$mi+mi0
  ifelse(d$valid&is.finite(d$mi)&is.finite(mi0)&is.finite(den)&den>0,d$N/den,NA_real_)
}
fr<-frozen('2019-12-31'); pair<-post&is.finite(d$official)&is.finite(fr)
D<-mean(as.numeric(d$official[pair]<=.7)-as.numeric(fr[pair]<=.7))
baseline<-mass_fit(post)
stopifnot(round(baseline$row$b,2)==3.14,round(D,4)==.1146)
cat(sprintf('T041 reproduction PASS: b_post=%.12f; D=%.12f.\n',baseline$row$b,D))

staged<-list()
stage<-function(f,target) {
 stopifnot(grepl('^t041_',basename(target)))
 staged[[length(staged)+1L]]<<-c(path=f,target=target)
}
csv<-function(x,name) {
 f<-tempfile(fileext='.csv'); mtpa_write_csv(x,f,row.names=FALSE,na='NA')
 stage(f,paste0('outputs/tables/t041_',name,'.csv'))
}
fmt<-function(x)ifelse(is.finite(x),sprintf('%.4f',x),'--')
texrow<-function(x)paste0(paste(x,collapse=' & '),' \\\\')
tex<-function(x,name,note) {
 rows<-vapply(seq_len(nrow(x)),function(i) {
  z<-x[i,]; counts<-as.character(z$firms)
  if('benchmark_firms'%in%names(z)&&is.finite(z$benchmark_firms))counts<-paste(counts,z$benchmark_firms,sep='/')
  texrow(c(gsub('_',' ',z$label,fixed=TRUE),counts,fmt(z$estimate),paste0('[',fmt(z$ci_low),', ',fmt(z$ci_high),']')))
 },character(1))
 out<-unlist(lapply(split(rows,ceiling(seq_along(rows)/16)),function(r)c(
  '\\begin{threeparttable}','\\begin{tabular}{p{0.47\\linewidth}rrr}','\\toprule',
  texrow(c('Check / date / draw','Firms','Estimate','95\\% interval')),'\\midrule',r,
  '\\bottomrule','\\end{tabular}','\\begin{tablenotes}[flushleft]\\footnotesize',
  paste0('\\item[] ',note),'\\end{tablenotes}','\\end{threeparttable}','\\par\\medskip')))
 f<-tempfile(fileext='.tex'); mtpa_write_lines(out,f); stage(f,paste0('outputs/tables/t041_',name,'.tex'))
}
pdf<-function(name,draw) {
 f<-tempfile(fileext='.pdf')
 grDevices::pdf(f,width=10,height=6.5,useDingbats=FALSE,timestamp=FALSE,title=paste('T041',name))
 draw(); invisible(dev.off()); stage(f,paste0('outputs/figures/t041_',name,'.pdf'))
}
note<-paste('Main sample; seed 20261016; 999 whole-firm resamples and complete re-estimation.',
 'Pointwise percentile intervals; no multiple-testing adjustment. Invalid draws are not replaced;',
 'fewer than 90 percent valid draws makes inference unreliable. CSVs give validity and observation counts.',
 'Smooth density and stable reporting selection are assumptions; these results are descriptive, not causal.')
firm_sum<-function(v) {
 a<-numeric(length(firms)); z<-tapply(v,d$firm_id,sum)
 a[match(names(z),firms)]<-z; a
}
bind<-function(xs) {
 cols<-unique(unlist(lapply(xs,names)))
 do.call(rbind,lapply(xs,function(x){for(n in setdiff(cols,names(x)))x[[n]]<-NA;x[cols]}))
}
# 1. Pooled pre density normalized by all finite RL1 observations. Every date
# uses this same share counterfactual; the pre polynomial is refitted per draw.
# Retain directly refitted CF draws, including draws with zero observed mass.
pre_fit<-mass_fit(pre)
window<-is.finite(d$rl1)&d$rl1>=.66&d$rl1<.7
pre_den<-firm_sum(as.numeric(pre&is.finite(d$rl1)))
pre_cf_draw<-pre_fit$cf_draws
pre_share<-pre_fit$row$counterfactual_window/sum(pre_den)
pre_share_draw<-pre_cf_draw/drop(crossprod(pre_den,weights))
by_date<-list(); ratio_draws<-list()
for(dt in as.character(sort(unique(d$date[d$date>=as.Date('2017-06-30')])))) {
 use<-d$date==as.Date(dt)&is.finite(d$rl1)
 den<-firm_sum(as.numeric(use)); num<-firm_sum(as.numeric(use&window))
 obs_share<-sum(num)/sum(den)
 draws<-(drop(crossprod(num,weights))/drop(crossprod(den,weights)))/pre_share_draw
 by_date[[dt]]<-data.frame(label=dt,date=dt,estimate=obs_share/pre_share,as.list(summarize(draws)),
  n=sum(den),firms=length(unique(d$firm_id[use])),observed_window=sum(num),observed_share=obs_share,
  counterfactual_share=pre_share,pre_firms=pre_fit$row$firms,bootstrap_draws=B)
 ratio_draws[[dt]]<-draws
}
by_date<-do.call(rbind,by_date); rownames(by_date)<-NULL
csv(by_date,'bunching_by_date')
tex(by_date,'bunching_by_date',paste(note,
 'Observed [0.66,0.70) share / pooled 2017H1--2019H2 degree-five predicted share.',
 'Fit: 0.01 bins on [0.40,1.00], excluding [0.66,0.70); share denominator: all finite RL1.',
 'Pre density and date shares use shared firm draws.'))
pdf('bunching_by_date',function() {
 par(mar=c(7,4.5,3,1)); x<-as.Date(by_date$date)
 plot(x,by_date$estimate,type='b',pch=16,ylim=range(c(0,by_date$ci_low,by_date$ci_high),finite=TRUE),
  xaxt='n',xlab='',ylab='Observed / pooled-pre counterfactual share',main='RL1 mass in [0.66, 0.70)')
 axis(1,at=x,labels=paste0(format(x,'%Y'),'H',ifelse(format(x,'%m')=='06',1,2)),las=2,cex.axis=.8)
 segments(x,by_date$ci_low,x,by_date$ci_high,col='#176B8E')
 abline(h=1,lty=3); abline(v=as.Date('2020-08-20'),lty=2,col='#B24B3C')
 mtext('Reporting date',side=1,line=4)
 mtext('Dashed: August 2020. Pointwise 95% firm-bootstrap CIs; date-specific counts in CSV.',side=1,line=5.5,cex=.8)
})
# 2a. Date-specific baseline fits; thin cells are descriptive only.
one<-list()
for(dt in c('2019-12-31','2020-12-31','2021-06-30','2021-12-31','2022-06-30')) {
 r<-mass_fit(d$date==as.Date(dt))$row; small<-r$firms<60
 if(small)r[c('se','ci_low','ci_high')]<-NA_real_
 one[[length(one)+1L]]<-cbind(label=dt,type='cross_section',draw=NA_integer_,estimate=r$b,r,descriptive_small_cell=small)
}
# 2b. Uniform random available date per firm, no firm replacement. Each draw
# refits the polynomial. This distribution is not a bootstrap confidence interval.
set.seed(seed)
choices<-split(which(post&is.finite(d$rl1)),d$firm_id[post&is.finite(d$rl1)])
for(j in seq_len(B)) {
 ix<-vapply(choices,function(v)v[sample.int(length(v),1L)],integer(1))
 stopifnot(!anyDuplicated(d$firm_id[ix]))
 r<-mass_fit(seq_len(nrow(d))%in%ix,w=matrix(1,length(firms),1))$row
 r[c('se','ci_low','ci_high','bootstrap_valid','bootstrap_failed','bootstrap_draws')]<-NA_real_
 r$bootstrap_meets_90pct<-NA; r$inference_status<-'random_date_draw_not_bootstrap'
 r$ci_excludes_zero<-NA; r$positive_supported<-NA
 one[[length(one)+1L]]<-cbind(label=paste('Random draw',j),type='random_date_draw',draw=j,estimate=r$b,r,descriptive_small_cell=FALSE)
}
one<-do.call(rbind,one); rownames(one)<-NULL
random<-one$estimate[one$type=='random_date_draw']; good<-is.finite(random)
one$random_valid_draws<-sum(good)
one$random_share_positive_all_draws<-sum(random>0,na.rm=TRUE)/B
one$random_share_positive_valid_draws<-mean(random[good]>0)
one$random_q025<-unname(quantile(random[good],.025)); one$random_q975<-unname(quantile(random[good],.975))
csv(one,'one_per_firm')
# CSV retains all 999 draws; the TeX table reports cross sections and distribution.
one_tex<-one[one$type=='cross_section',]
r<-one_tex[1,]; r$label<-'Random-date distribution'; r$firms<-length(choices)
r$estimate<-mean(random[good]); r$ci_low<-quantile(random[good],.025); r$ci_high<-quantile(random[good],.975)
one_tex<-rbind(one_tex,r)
tex(one_tex,'one_per_firm',paste(note,
 'Cross sections use the T023 baseline; fewer than 60 firms suppresses inference.',
 'Random rows choose one finite post-policy observation per firm uniformly over available dates without firm replacement.',
 'The random-date summary shows mean b and 2.5/97.5 percentiles over date selections, not a confidence interval.',
 sprintf('Random-date b percentiles [%.4f, %.4f]; positive in %d/999 draws; %d valid.',
 quantile(random[good],.025),quantile(random[good],.975),sum(random>0,na.rm=TRUE),sum(good))))
# 3. Local linear regression on 0.01 bin counts outside [0.66,0.70),
# tricube kernel, bandwidth 0.10, range [0.55,0.85]. These choices are fixed.
local_fit<-function() {
 edges<-round(seq(.55,.85,.01),10); mid<-(head(edges,-1)+tail(edges,-1))/2
 excluded<-mid>=.66&mid<.70; counts<-firm_counts(post,firms,edges)
 y<-colSums(counts$counts); yb<-t(counts$counts)%*%weights
 A<-t(vapply(mid[excluded],function(target) {
  xx<-mid[!excluded]-target; ww<-(1-(abs(xx)/.10)^3)^3; ww[abs(xx)>=.10]<-0
  X<-cbind(1,xx); solve(crossprod(X,ww*X),t(X)*rep(ww,each=2))[1,]
 },numeric(sum(!excluded))))
 pred<-drop(A%*%y[!excluded]); pb<-A%*%yb[!excluded,,drop=FALSE]
 valid<-all(is.finite(pred)&pred>0); good<-colSums(!is.finite(pb)|pb<=0)==0
 draws<-ifelse(good,(colSums(yb[excluded,,drop=FALSE])-colSums(pb))/colMeans(pb),NA_real_)
 est<-if(valid)(sum(y[excluded])-sum(pred))/mean(pred) else NA_real_
 s<-summarize(draws); if(!valid)s[c('se','ci_low','ci_high')]<-NA
 data.frame(b=est,as.list(s),firms=counts$firms_observed,n=counts$n,n_in_range=counts$n_in_range,
  n_outside=counts$n_outside,valid_counterfactual=valid,bootstrap_draws=B,
  inference_status=if(!valid)'invalid_counterfactual' else if(sum(good)<.9*B)'unreliable_bootstrap_below_90pct' else 'all_draws_valid')
}
low<-bind(list(cbind(label='Baseline degree 5',baseline$row),
 cbind(label='Narrow degree 1',mass_fit(post,degree=1,fit_lower=.55,fit_upper=.85)$row),
 cbind(label='Narrow degree 2',mass_fit(post,degree=2,fit_lower=.55,fit_upper=.85)$row),
 cbind(label='Local linear h=0.10',local_fit())))
low$estimate<-low$b; low$fit_lower<-c(.4,.55,.55,.55); low$fit_upper<-c(1,.85,.85,.85)
low$degree<-c(5,1,2,1); low$bandwidth<-c(NA,NA,NA,.10)
csv(low,'low_flex'); tex(low,'low_flex',paste(note,
 'All fits exclude [0.66,0.70); b is excess count divided by mean predicted mass-bin count.',
 'Baseline: degree five on [0.40,1.00]; others: [0.55,0.85]. Local linear uses tricube weights and fixed bandwidth 0.10 RL1 units on bin counts. No clipping.'))
# 4. Exact half-year horizons, with paired whole-firm draws on available cells.
mean_fit<-function(use,cf) {
 use<-use&is.finite(d$official)&is.finite(cf)
 y<-ifelse(use,as.numeric(d$official<=.7)-as.numeric(cf<=.7),0)
 num<-firm_sum(y); den<-firm_sum(as.numeric(use))
 list(estimate=if(sum(den))sum(num)/sum(den) else NA_real_,
  draws=drop(crossprod(num,weights)/crossprod(den,weights)),n=sum(den),
  firms=length(unique(d$firm_id[use])),ids=unique(d$firm_id[use]))
}
anchor_h<-function(a)as.integer(format(as.Date(a),'%Y'))*2L+as.integer(format(as.Date(a),'%m')=='12')
horizon<-list(); cells<-list()
for(anchor in c('2019-12-31','2016-12-31','2017-06-30'))for(h in seq(1,3,.5)) {
 hh<-anchor_h(anchor)+as.integer(2*h)
 dt<-sprintf('%04d-%s',hh%/%2L,if(hh%%2L==0L)'06-30' else '12-31')
 available<-anchor=='2019-12-31'||(as.Date(dt)>=as.Date('2017-12-31')&as.Date(dt)<=as.Date('2019-12-31'))
 z<-mean_fit(d$halfyear==hh&available,frozen(anchor)); cells[[paste(anchor,h)]]<-z
 horizon[[length(horizon)+1L]]<-data.frame(label=paste(anchor,h,'years'),
  type=if(anchor=='2019-12-31')'post' else 'placebo',anchor=anchor,horizon=h,date=dt,
  estimate=z$estimate,as.list(summarize(z$draws)),n=z$n,firms=z$firms,
  benchmark_n=NA_integer_,benchmark_firms=NA_integer_,overlap_firms=NA_integer_,available=available,bootstrap_draws=B)
}
for(anchor in c('2016-12-31','2017-06-30'))for(h in seq(1,3,.5)) {
 a<-cells[[paste('2019-12-31',h)]]; b<-cells[[paste(anchor,h)]]
 horizon[[length(horizon)+1L]]<-data.frame(label=paste('Post minus',anchor,h,'years'),type='post_minus_placebo',
  anchor=anchor,horizon=h,date=NA_character_,estimate=a$estimate-b$estimate,
  as.list(summarize(a$draws-b$draws)),n=a$n,firms=a$firms,benchmark_n=b$n,benchmark_firms=b$firms,
  overlap_firms=length(intersect(a$ids,b$ids)),available=b$n>0,bootstrap_draws=B)
}
horizon<-do.call(rbind,horizon); rownames(horizon)<-NULL
csv(horizon,'frozen_horizons'); tex(horizon,'frozen_horizons',paste(note,
 'D: mean official minus frozen compliance (RL1 at most 0.70) among eligible pairs.',
 'N=liabilities minus advances and equity must be positive; frozen denominator N+E-MI+MI(anchor) must be positive.',
 'Exact horizons 1, 1.5, 2, 2.5, 3 years. Placebos only 2017H2--2019H2; June-2017 anchor lacks a 3-year placebo.',
 'No extrapolation. Contrasts show post/placebo firm counts. Shared firm draws retain period dependence;',
 'available cell samples may differ. MI may be genuine equity. Stable within-firm reporting currency is assumed.'))
pdf('frozen_horizons',function() {
 par(mar=c(5,4.5,3,1)); z<-horizon[horizon$type!='post_minus_placebo',]
 plot(NA,xlim=c(.95,3.05),ylim=range(c(0,z$ci_low,z$ci_high),finite=TRUE),
  xlab='Years after anchor',ylab='D: official minus frozen compliance',main='Frozen-MI dependence at matched horizons')
 anchors<-c('2019-12-31','2016-12-31','2017-06-30'); cols<-c('#176B8E','#B24B3C','#6E7F3F')
 abline(h=0,col='grey70')
 for(i in 1:3) {
  a<-z[z$anchor==anchors[i]&is.finite(z$estimate),]; x<-a$horizon+(i-2)*.025
  lines(x,a$estimate,type='b',col=cols[i],pch=14+i,lty=i); segments(x,a$ci_low,x,a$ci_high,col=cols[i])
 }
 legend('topleft',legend=paste(c('Post','Placebo','Placebo'),anchors),col=cols,pch=15:17,lty=1:3,bty='n')
 mtext('Pointwise 95% firm-bootstrap CIs. Missing placebo horizons are not extrapolated; counts in CSV.',side=1,line=4,cex=.8)
})
stopifnot(nrow(by_date)==12L,nrow(one)==1004L,nrow(low)==4L,nrow(horizon)==25L,
 identical(input_hash,tools::sha256sum(inputs)),identical(protected_hash,tools::sha256sum(protected)))
for(z in staged)stopifnot(file.copy(z[['path']],z[['target']],overwrite=TRUE))
cat(sprintf('T041: %d protected outputs unchanged; input hashes unchanged.\n',length(protected)))
cat(sprintf('T041: date=%d, one-per-firm=%d, density=%d, horizon=%d rows; 8 tables and 2 figures written.\n',nrow(by_date),nrow(one),nrow(low),nrow(horizon)))
cat(sprintf('T041 random-date selection: %d/999 positive; %d valid; b range [%.4f, %.4f].\n',sum(random>0,na.rm=TRUE),sum(good),min(random[good]),max(random[good])))
