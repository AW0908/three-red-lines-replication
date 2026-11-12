# T029: mechanical accounting counterfactuals and descriptive adjustment.
# Run from replication/. No downloads or input modifications.
set.seed(20261016)
options(digits=17)
B <- 999L
inputs <- c("data/processed/panel_firm_halfyear.csv",
            if(file.exists("data/processed/panel_firm_halfyear_ext.csv"))
              "data/processed/panel_firm_halfyear_ext.csv")
input_hash <- tools::sha256sum(inputs)
protected <- list.files("outputs",recursive=TRUE,full.names=TRUE,all.files=TRUE)
protected <- protected[!dir.exists(protected)&!grepl("^t029_",basename(protected))]
protected_hash <- tools::sha256sum(protected)
nf <- function(x)length(unique(x[!is.na(x)]))
finite <- function(x) {x[!is.finite(x)]<-NA_real_; x}
slog <- function(x) {z<-rep(NA_real_,length(x)); ok<-is.finite(x)&x>0; z[ok]<-log(x[ok]); z}
sdiv <- function(x,y)finite(x/y)
read_panel <- function(p) {
  x<-read.csv(p,stringsAsFactors=FALSE,na.strings=c("","NA"))
  x<-x[!is.na(x$sample_main)&x$sample_main,]
  x$date<-as.Date(x$date); x<-x[order(x$firm_id,x$date),]
  stopifnot(!anyDuplicated(x[c("firm_id","date")]))
  x$h<-as.integer(format(x$date,"%Y"))*2L+as.integer(format(x$date,"%m")=="12")
  x$N<-x$tl-x$adv
  x$valid<-is.finite(x$N)&x$N>0&is.finite(x$te)&x$te>0
  x$official<-ifelse(x$valid,x$N/(x$N+x$te),NA_real_)
  x
}
d <- read_panel(inputs[1])
firms <- sort(unique(d$firm_id)); G<-length(firms)
# Identical seed, firm universe, ordering and whole-history weights as T023.
boot <- replicate(B,tabulate(sample.int(G,G,replace=TRUE),nbins=G))
# T023 main estimator, exactly: 0.01 bins over [0.40,1], fifth-degree
# polynomial excluding [0.66,0.70); no integration constraint or clipping.
edges<-round(seq(.40,1,.01),10); mid<-(head(edges,-1)+tail(edges,-1))/2
specs<-data.frame(specification=c("main","degree4","degree7","narrow","wide"),
 degree=c(5L,4L,7L,5L,5L),left=c(.04,.04,.04,.03,.04),right=c(0,0,0,0,.02))
mass_fit <- function(x,id,spec) {
  ix<-findInterval(x,edges,rightmost.closed=TRUE)
  inside<-is.finite(x)&!is.na(ix)&ix>0L&ix<length(edges)
  counts<-matrix(0,G,length(mid))
  for(j in which(inside))counts[match(id[j],firms),ix[j]]<-
    counts[match(id[j],firms),ix[j]]+1
  observed<-colSums(counts); draws<-t(counts)%*%boot
  lower<-round(.7-spec$left,10); upper<-round(.7+spec$right,10)
  excluded<-mid>=lower&mid<upper; mass<-excluded&mid<.7
  X<-cbind(1,poly(mid,degree=spec$degree)); qr_fit<-qr(X[!excluded,,drop=FALSE])
  stopifnot(qr_fit$rank==ncol(X))
  pred<-drop(X%*%qr.coef(qr_fit,observed[!excluded]))
  pred_boot<-X%*%qr.coef(qr_fit,draws[!excluded,,drop=FALSE])
  valid<-all(is.finite(pred[mass]))&&all(pred[mass]>0)
  b<-if(valid)(sum(observed[mass])-sum(pred[mass]))/mean(pred[mass]) else NA_real_
  good<-colSums(!is.finite(pred_boot[mass,,drop=FALSE])|pred_boot[mass,,drop=FALSE]<=0)==0
  db<-ifelse(good,(colSums(draws[mass,,drop=FALSE])-colSums(pred_boot[mass,,drop=FALSE]))/
    (colSums(pred_boot[mass,,drop=FALSE])/sum(mass)),NA_real_)
  list(estimate=b,draws=db,n=sum(is.finite(x)),n_firms=nf(id[is.finite(x)]),
       n_in_range=sum(inside),observed=observed,predicted=pred)
}
post<-d$date>=as.Date("2020-12-31")&d$date<=as.Date("2022-12-31")
gate<-mass_fit(d$rl1[post],d$firm_id[post],specs[1,])
if(!is.finite(gate$estimate)||round(gate$estimate,2)!=3.14)
 stop(sprintf("STOP: T023 official b %.17g does not reproduce 3.14.",gate$estimate))
cat(sprintf("T029 gate: T023 official b = %.12f (rounds to 3.14).\n",gate$estimate))

# Output helpers: every tabular estimate has available unique-firm counts.
write_csv<-function(x,name) {
  con<-file(paste0("outputs/tables/t029_",name,".csv"),"wb")
  on.exit(close(con)); write.csv(x,con,row.names=FALSE,na="",eol="\n")
}
write_text<-function(x,name) {
  con<-file(paste0("outputs/tables/t029_",name),"wb")
  on.exit(close(con)); writeLines(x,con,useBytes=TRUE)
}
bind<-function(xs) {
  cols<-unique(unlist(lapply(xs,names)))
  do.call(rbind,lapply(xs,function(x){for(n in setdiff(cols,names(x)))x[[n]]<-NA; x[cols]}))
}
ci<-function(x) {
  ok<-is.finite(x); q<-if(any(ok))quantile(x[ok],c(.025,.975),names=FALSE) else c(NA,NA)
  c(ci_low=q[1],ci_high=q[2],bootstrap_draws=B,bootstrap_valid=sum(ok),
    bootstrap_failed=sum(!ok))
}
weighted_stat<-function(y,id,statistic="mean",weights=rep(1L,G)) {
  w<-weights[match(id,firms)]; ok<-is.finite(y)&!is.na(w)&w>0
  if(!any(ok))return(NA_real_)
  if(statistic=="mean")sum(y[ok]*w[ok])/sum(w[ok]) else median(rep(y[ok],w[ok]))
}
summarize<-function(y,id,statistic="mean",inference=TRUE) {
  ok<-is.finite(y); est<-weighted_stat(y,id,statistic)
  draws<-if(inference)vapply(seq_len(B),function(j)
    weighted_stat(y,id,statistic,boot[,j]),numeric(1)) else rep(NA_real_,B)
  list(row=data.frame(estimate=est,n=sum(ok),n_firms=nf(id[ok]),n_missing=sum(!ok),
    as.list(ci(draws)),inference=if(inference)"pointwise_firm_bootstrap" else "descriptive_only"),draws=draws)
}
coverage<-c(
 "T029: mechanical accounting counterfactuals, not attainable balance sheets, causal effects, or economic leverage.",
 "Minority interests may be genuine equity. Ex-MI is mechanical, not a deconsolidated balance sheet.",
 "Interpretation rule (specified before results): a large drop in b means bunching depends mechanically on post-2019 minority-interest growth; no drop means other items achieve bunching.",
 "All estimates are descriptive. No parallel-trends or causal policy interpretation is imposed.",
 "Seed 20261016; 999 whole-firm resamples, full histories, common paired draws; all statistics and polynomial fits re-estimated in each draw.",
 "Event-study uncertainty follows the card's explicit firm-clustered SE requirement (t critical value, G-1 df); not bootstrap SE.",
 "D = mean(C-C_frozen) is a net share difference among eligible firm-dates. fail_given_official = mean(1-C_frozen | C=1) is the requested conditional failure share; these differ when MI shrinks.",
 "Post=2020H2--2022H2. Placebo=2017H2--2019H2, frozen at 2016H2. Extension=2023H1--2024H2 separately (same end-2019 anchor).",
 "Date shares for 2017H1--2019H2 frozen at end-2019 are retrospective accounting comparisons, not the placebo.",
 "Flag: abs(MI_t-MI_(t-1)) > 0.5 E_t, consecutive scheduled half-years. Missing lag means unknown, retained; exclude_jump_dates removes only known jump dates; later dates retain the jump in the MI stock.",
 "Counterfactual total denominator must be positive; nonpositive counterfactual equity with positive denominator is retained and fails compliance. Invalid total denominators are missing, never treated as compliance.",
 "All scales are own-firm end-2019 assets. HK within-firm logs and scales assume unchanged reporting currency (D7 unresolved); no pooled absolute HK RMB levels.",
 "D19: no perpetual imputation or perpetual-specific analysis; parent equity includes unresolved perpetuals. D20: no economic-leverage measure. D22: N>0, E>0 required at analyzed dates.")
prepare<-function(x,label) {
  j<-match(paste(x$firm_id,"2019-12-31"),paste(x$firm_id,x$date))
  jp<-match(paste(x$firm_id,"2016-12-31"),paste(x$firm_id,x$date))
  lag<-match(paste(x$firm_id,x$h-1L),paste(x$firm_id,x$h))
  x$mi0<-x$mi[j]; x$mi_placebo<-x$mi[jp]; x$ta0<-x$ta[j]; x$ibd0<-x$ibd[j]
  x$mi_flag<-ifelse(is.finite(x$mi)&is.finite(x$mi[lag])&x$valid,
    abs(x$mi-x$mi[lag])>.5*x$te,NA)
  x$known_flag<-!is.na(x$mi_flag)&x$mi_flag
  counter<-function(base) {
    den<-x$N+x$te-x$mi+base
    ifelse(x$valid&is.finite(x$mi)&is.finite(base)&is.finite(den)&den>0,x$N/den,NA_real_)
  }
  x$frozen<-counter(x$mi0); x$ex_mi<-counter(rep(0,nrow(x)))
  x$placebo<-counter(x$mi_placebo)
  equal<-x$valid&is.finite(x$mi)&is.finite(x$mi0)&x$mi==x$mi0
  err<-max(abs(x$frozen[equal]-x$official[equal]))
  stopifnot(sum(equal)>0,err<=1e-12)
  # Synthetic equality on every valid row also verifies the formula's invariant.
  synthetic<-x$N/(x$N+x$te-x$mi+x$mi)
  ok<-x$valid&is.finite(x$mi)
  stopifnot(all(abs(synthetic[ok]-x$official[ok])<=1e-12))
  base_firms<-unique(x$firm_id); observed<-unique(x$firm_id[is.finite(x$mi0)])
  coverage<<-c(coverage,sprintf("%s: sample_main firms=%d; MI_2019 unavailable=%d (%.4f%%); N/E-domain excluded rows=%d/%d; actual invariant rows=%d, max error=%.17g.",
    label,length(base_firms),length(setdiff(base_firms,observed)),100*length(setdiff(base_firms,observed))/length(base_firms),sum(!x$valid),nrow(x),sum(equal),err))
  for(dt in as.character(sort(unique(x$date)))) {
    z<-x[x$date==dt,]
    coverage<<-c(coverage,sprintf("%s %s: rows=%d firms=%d; invalid_N_E=%d; MI_2019_missing=%d; MI_t_missing=%d; frozen_missing=%d; exMI_missing=%d; known_flags=%d; flag_unknown=%d; cf_equity_nonpositive=%d.",
      label,as.character(dt),nrow(z),nf(z$firm_id),sum(!z$valid),sum(!is.finite(z$mi0)),sum(!is.finite(z$mi)),sum(!is.finite(z$frozen)),sum(!is.finite(z$ex_mi)),sum(z$known_flag),sum(is.na(z$mi_flag)),sum(z$te-z$mi+z$mi0<=0,na.rm=TRUE)))
  }
  x
}
d<-prepare(d,"main")
ext<-if(length(inputs)>1)prepare(read_panel(inputs[2]),"extension") else NULL
# Extension preserves the T030 firm universe and unchanged historical values.
if(!is.null(ext))stopifnot(all(ext$firm_id %in% firms))

# Part A: both flag variants, date shares, pooled post/placebo, paired contrasts.
compliance<-list(); compliance_draws<-list()
add_compliance<-function(x,window,variant,date="pooled",cf="frozen") {
  if(variant=="exclude_jump_dates")x<-x[!x$known_flag,]
  pair<-is.finite(x$official)&is.finite(x[[cf]])
  z<-x[pair,]; C<-as.numeric(z$official<=.7); F<-as.numeric(z[[cf]]<=.7)
  values<-list(official=C,frozen=F,ex_mi=ifelse(is.finite(z$ex_mi),as.numeric(z$ex_mi<=.7),NA),
    D=C-F,fail_given_official=ifelse(C==1,1-F,NA_real_),
    official_fail_frozen_share=C*(1-F),reverse_compliance_share=(1-C)*F)
  for(m in names(values)) {
    s<-summarize(values[[m]],z$firm_id)
    r<-cbind(data.frame(window=window,date=date,variant=variant,metric=m,
      anchor=if(cf=="placebo")"2016-12-31" else "2019-12-31",
      n_candidate=nrow(x),n_pair=nrow(z),n_pair_firms=nf(z$firm_id),excluded_pair=sum(!pair)),s$row)
    compliance[[length(compliance)+1L]]<<-r
    if(date=="pooled")compliance_draws[[paste(window,variant,m)]]<<-list(row=r,draws=s$draws)
  }
}
for(v in c("all","exclude_jump_dates")) {
  for(dt in as.character(sort(unique(d$date[d$date>=as.Date("2017-06-30")]))))
    add_compliance(d[d$date==dt,],"main_by_date",v,as.character(dt))
  add_compliance(d[post,],"post",v)
  placebo<-d$date>=as.Date("2017-12-31")&d$date<=as.Date("2019-12-31")
  add_compliance(d[placebo,],"placebo",v,cf="placebo")
  for(m in c("D","fail_given_official","official_fail_frozen_share","reverse_compliance_share")) {
    a<-compliance_draws[[paste("post",v,m)]]; b<-compliance_draws[[paste("placebo",v,m)]]
    r<-a$row; r$window<-"post_minus_placebo"; r$anchor<-"2019_minus_2016"
    r$estimate<-a$row$estimate-b$row$estimate
    info<-ci(a$draws-b$draws); r[names(info)]<-as.list(info)
    r$benchmark_n<-b$row$n; r$benchmark_firms<-b$row$n_firms
    compliance[[length(compliance)+1L]]<-r
  }
  if(!is.null(ext)) {
    z<-ext[ext$date>as.Date("2022-12-31"),]
    for(dt in as.character(sort(unique(z$date))))add_compliance(z[z$date==dt,],"extension_by_date",v,as.character(dt))
    add_compliance(z,"extension",v)
  }
}
compliance<-bind(compliance); write_csv(compliance,"compliance")

# Bunching: five pre-specified T023 specifications, paired populations as well
# as the unrestricted replication gate. Negative excess and invalid fits retained.
bunch<-list(); fits<-list()
add_bunch<-function(x,window,variant,scope="paired") {
  if(variant=="exclude_jump_dates")x<-x[!x$known_flag,]
  if(scope=="paired")x<-x[is.finite(x$official)&is.finite(x$frozen),]
  for(s in seq_len(nrow(specs))) {
    sp<-specs[s,]; a<-mass_fit(x$official,x$firm_id,sp)
    b<-mass_fit(x$frozen,x$firm_id,sp)
    for(m in c("official","frozen","official_minus_frozen")) {
      z<-if(m=="official")a else if(m=="frozen")b else
        list(estimate=a$estimate-b$estimate,draws=a$draws-b$draws,n=a$n,n_firms=a$n_firms,n_in_range=NA)
      info<-ci(z$draws); if(!is.finite(z$estimate))info[c("ci_low","ci_high")]<-NA
      bunch[[length(bunch)+1L]]<<-data.frame(window=window,variant=variant,scope=scope,
        specification=sp$specification,degree=sp$degree,window_lower=.7-sp$left,
        exclusion_upper=.7+sp$right,bin_width=.01,metric=m,estimate=z$estimate,
        n=z$n,n_firms=z$n_firms,n_in_range=z$n_in_range,
        benchmark_n=if(m=="official_minus_frozen")b$n else NA,
        benchmark_firms=if(m=="official_minus_frozen")b$n_firms else NA,
        as.list(info),inference_status=if(!is.finite(z$estimate))"invalid_counterfactual" else
          if(info["bootstrap_valid"]<.9*B)"unreliable_below_90pct" else "pointwise_firm_bootstrap")
    }
    if(window=="post"&&variant=="all"&&scope=="paired"&&s==1L)fits<<-list(official=a,frozen=b)
  }
}
# Report original-sample gate, and paired comparisons on the specified N,E domain.
bunch[[1]]<-data.frame(window="post",variant="all",scope="T023_replication_stored_RL1",
 specification="main",degree=5,window_lower=.66,exclusion_upper=.7,bin_width=.01,
 metric="official",estimate=gate$estimate,n=gate$n,n_firms=gate$n_firms,
 n_in_range=gate$n_in_range,as.list(ci(gate$draws)),inference_status="replication_gate")
for(v in c("all","exclude_jump_dates")) {
 add_bunch(d[post,],"post",v)
 add_bunch(d[post,],"post",v,scope="all_eligible")
 if(!is.null(ext))add_bunch(ext[ext$date>as.Date("2022-12-31"),],"extension",v)
}
bunch<-bind(bunch); write_csv(bunch,"counterfactual_bunching")

# Debt benchmark: the same complete official/frozen pairs, cumulative since 2019.
debt<-list()
for(window in c("post",if(!is.null(ext))"extension"))for(v in c("all","exclude_jump_dates")) {
 x<-if(window=="post")d[post,] else ext[ext$date>as.Date("2022-12-31"),]
 if(v=="exclude_jump_dates")x<-x[!x$known_flag,]
 x<-x[is.finite(x$official)&is.finite(x$frozen)&x$official<=.7,]
 x$group<-ifelse(x$frozen>.7,"fails_frozen","compliant_both")
 outcomes<-list(log_ibd_change=slog(x$ibd)-slog(x$ibd0),
   ibd_change_scaled=ifelse(is.finite(x$ta0)&x$ta0>0,(x$ibd-x$ibd0)/x$ta0,NA))
 for(m in names(outcomes))for(st in c("median","mean")) {
   zs<-list()
   for(g in c("fails_frozen","compliant_both")) {
     use<-x$group==g; s<-summarize(outcomes[[m]][use],x$firm_id[use],st); zs[[g]]<-s
     debt[[length(debt)+1L]]<-cbind(data.frame(window=window,variant=v,group=g,metric=m,statistic=st),s$row)
   }
   a<-zs[[1]]; b<-zs[[2]]; r<-a$row; r$estimate<-a$row$estimate-b$row$estimate
   inf<-ci(a$draws-b$draws); r[names(inf)]<-as.list(inf)
   r$benchmark_n<-b$row$n; r$benchmark_firms<-b$row$n_firms
   debt[[length(debt)+1L]]<-cbind(data.frame(window=window,variant=v,group="fails_minus_both",metric=m,statistic=st),r)
 }
}
debt<-bind(debt); write_csv(debt,"debt_benchmark")

# Part B: all eligible firms; bins fixed before outcomes are examined.
# Boundaries are [-inf,-.1),[-.1,0),[0,.1),[.1,inf), so zero joins
# the near-above bin (also required in component step 7).
bins<-c("below_minus_010","minus_010_to_0","0_to_010","above_010")
bin_labels<-c("g < -0.10","-0.10 <= g < 0","0 <= g < 0.10","g >= 0.10")
get_bin<-function(x) {
 b<-as.integer(cut(x,c(-Inf,-.1,0,.1,Inf),right=FALSE)); b[!is.finite(x)]<-NA_integer_; b
}
es<-list(); models<-list()
for(anchor in c("2019-12-31","2019-06-30")) {
 j<-match(paste(d$firm_id,anchor),paste(d$firm_id,d$date))
 g<-d$official[j]-.7; bin<-get_bin(g)
 j0<-match(paste(d$firm_id,"2019-12-31"),paste(d$firm_id,d$date))
 outcomes<-list(mi=d$mi-d$mi[j0],parent_equity=(d$te-d$mi)-(d$te[j0]-d$mi[j0]),
   ibd=d$ibd-d$ibd[j0],N=d$N-d$N[j0])
 for(outcome in names(outcomes)) {
   y<-ifelse(is.finite(d$ta0)&d$ta0>0,outcomes[[outcome]]/d$ta0,NA)
   use<-d$valid&is.finite(y)&!is.na(bin)
   z<-data.frame(y=y[use],firm_id=d$firm_id[use],date=as.character(d$date[use]),bin=bin[use])
   dates<-sort(unique(z$date)); terms<-character()
   for(dt in dates[dates!="2019-12-31"])for(b in 2:4) {
     nm<-paste0("b",b,"_d",gsub("-","",dt))
     z[[nm]]<-as.numeric(z$bin==b&z$date==dt); terms<-c(terms,nm)
   }
   model<-fixest::feols(as.formula(paste("y ~",paste(terms,collapse=" + "),"| firm_id + date")),
     data=z,vcov=~firm_id,notes=FALSE,nthreads=1)
   models[[paste(anchor,outcome)]]<-model
   co<-coef(model); se<-sqrt(diag(vcov(model))); crit<-qt(.975,nf(z$firm_id)-1L)
   coverage<-c(coverage,sprintf("ES anchor=%s outcome=%s: available=%d firms=%d excluded=%d; N/E excluded=%d; baseline TA invalid=%d; baseline gap missing=%d; outcome missing=%d; collinear terms=%s.",
     anchor,outcome,nrow(z),nf(z$firm_id),sum(!use),sum(!d$valid),sum(!is.finite(d$ta0)|d$ta0<=0),sum(is.na(bin)),sum(!is.finite(y)),paste(model$collin.var,collapse=",")))
   for(dt in dates)for(b in 1:4) {
     nm<-paste0("b",b,"_d",gsub("-","",dt)); normalized<-b==1L||dt=="2019-12-31"
     est<-if(normalized)0 else unname(co[nm]); s<-if(normalized)NA_real_ else unname(se[nm])
     cell<-z$date==dt&z$bin==b; ref<-z$date==dt&z$bin==1
     es[[length(es)+1L]]<-data.frame(anchor=anchor,outcome=outcome,date=dt,bin=b,
       bin_label=bin_labels[b],estimate=est,se=s,ci_low=est-crit*s,ci_high=est+crit*s,
       n=sum(cell),n_firms=nf(z$firm_id[cell]),reference_n=sum(ref),reference_firms=nf(z$firm_id[ref]),
       model_n=nrow(z),model_firms=nf(z$firm_id),
       status=if(normalized)"normalization" else if(is.finite(est))"estimated" else "not_identified",
       interpretation="Differential adjustment relative to g < -0.10 and end-2019; not a policy effect.",
       inference_note="pointwise CIs, no multiple-testing correction")
   }
 }
}
es<-bind(es); write_csv(es,"distance_es")

# Exact T027 log-odds components for all consecutive transitions in 0<=g<.1.
# Logarithmic-mean factors use their continuous limit when net changes are zero;
# offsetting components remain defined and the exact additive identity holds.
lag<-match(paste(d$firm_id,d$h-1L),paste(d$firm_id,d$h))
j0<-match(paste(d$firm_id,"2019-12-31"),paste(d$firm_id,d$date))
g<-d$official[j0]-.7
use<-is.finite(g)&g>=0&g<.1&d$valid&!is.na(lag)&!is.na(d$valid[lag])&d$valid[lag]
period<-ifelse(d$date>=as.Date("2017-06-30")&d$date<=as.Date("2019-12-31"),"pre",
 ifelse(post,"post",NA_character_))
i<-which(use&!is.na(period)); j<-lag[i]
e<-data.frame(firm_id=d$firm_id[i],date0=as.character(d$date[j]),date1=as.character(d$date[i]),period=period[i])
dN<-d$N[i]-d$N[j]; dE<-d$te[i]-d$te[j]
dibd<-d$ibd[i]-d$ibd[j]; dmi<-d$mi[i]-d$mi[j]
dparent<-(d$te[i]-d$mi[i])-(d$te[j]-d$mi[j])
lnN<-log(d$N[i]/d$N[j]); lnE<-log(d$te[i]/d$te[j])
a<-ifelse(dN==0,1/d$N[j],lnN/dN); b<-ifelse(dE==0,1/d$te[j],lnE/dE)
logs<-list(total=lnN-lnE,N=lnN,equity=-lnE,ibd=a*dibd,other_liabilities=a*(dN-dibd),
 parent_equity=-b*dparent,mi=-b*dmi)
scaled<-list(N=dN,ibd=dibd,other_liabilities=dN-dibd,equity=dE,parent_equity=dparent,mi=dmi)
error<-logs$ibd+logs$other_liabilities+logs$parent_equity+logs$mi-logs$total
stopifnot(all(abs(error[is.finite(error)])<=1e-10))
coverage<-c(coverage,sprintf("Component identity: %d transitions, %d firms; complete components=%d; max exact sum error=%.17g. No selection on crossing.",
 nrow(e),nf(e$firm_id),sum(is.finite(error)),max(abs(error),na.rm=TRUE)),
 "Component periods: pre destinations 2017H1--2019H2, post 2020H2--2022H2 (2020H1 excluded); only consecutive valid endpoints, no bridging gaps.",
 "Scaled components are signed raw item changes / TA_2019 (positive equity growth); log-odds components sign equity negatively. Parent equity includes unresolved perpetuals. Firm distributions are medians of all available transitions within firm/period.")
components<-list()
for(unit in c("log_odds","delta_item_over_TA2019")) {
 vals<-if(unit=="log_odds")logs else lapply(scaled,function(x)
   ifelse(is.finite(d$ta0[i])&d$ta0[i]>0,x/d$ta0[i],NA))
 for(m in names(vals)) {
   y<-vals[[m]]
   for(k in seq_len(nrow(e)))components[[length(components)+1L]]<-data.frame(
     row_type="transition",unit=unit,metric=m,period=e$period[k],firm_id=e$firm_id[k],
     date0=e$date0[k],date1=e$date1[k],statistic="value",estimate=y[k],n=as.integer(is.finite(y[k])),
     n_firms=as.integer(is.finite(y[k])))
   for(p in c("pre","post")) {
     in_period<-e$period==p
     for(st in c("median","mean")) {
       s<-summarize(y[in_period],e$firm_id[in_period],st)
       components[[length(components)+1L]]<-cbind(data.frame(row_type="pooled_summary",unit=unit,
         metric=m,period=p,statistic=st),s$row)
     }
     for(f in sort(unique(e$firm_id[in_period]))) {
       z<-in_period&e$firm_id==f; ok<-z&is.finite(y)
       components[[length(components)+1L]]<-data.frame(row_type="firm_distribution",unit=unit,
         metric=m,period=p,firm_id=f,statistic="within_firm_median",
         estimate=if(any(ok))median(y[ok]) else NA_real_,n=sum(ok),n_firms=as.integer(any(ok)))
     }
   }
   if(m=="mi") {
     fs<-sort(unique(e$firm_id[e$period=="post"&is.finite(y)])); loo<-numeric()
     for(f in fs) {
       z<-e$period=="post"&e$firm_id!=f&is.finite(y)
       val<-if(any(z))median(y[z]) else NA_real_; loo<-c(loo,val)
       components[[length(components)+1L]]<-data.frame(row_type="leave_one_firm_out",unit=unit,metric=m,
         period="post",firm_id=f,statistic="median_excluding_named_firm",estimate=val,n=sum(z),n_firms=nf(e$firm_id[z]))
     }
     coverage<-c(coverage,sprintf("Post MI median LOFO range (%s): [%.12f, %.12f]; omitted firms=%d.",unit,min(loo,na.rm=TRUE),max(loo,na.rm=TRUE),length(fs)))
   }
 }
}
components<-bind(components); write_csv(components,"distance_components")

# Part C: fixed end-2019 classification; missing RL2 or RL3 remains unclassified.
base<-d[d$date==as.Date("2019-12-31"),]
base$group<-NA_character_
known<-is.finite(base$official)&base$official>.7&is.finite(base$rl2)&is.finite(base$rl3)
base$group[known]<-ifelse(base$rl2[known]<=1&base$rl3[known]>=1,"rl1_only","rl1_plus")
d$incentive_group<-base$group[match(d$firm_id,base$firm_id)]
groups<-c("rl1_only","rl1_plus")
coverage<-c(coverage,sprintf("Incentive classification: end-2019 RL1>0.70 firms=%d; rl1_only=%d; rl1_plus=%d; unclassified (missing RL2/RL3)=%d.",
 sum(base$official>.7,na.rm=TRUE),sum(base$group=="rl1_only",na.rm=TRUE),sum(base$group=="rl1_plus",na.rm=TRUE),sum(is.finite(base$official)&base$official>.7&is.na(base$group))),
 "Part C D and fail_given_official compare post (2019 anchor) with placebo 2017H2--2019H2 (2016 anchor), never pre with a 2019 anchor. The near-threshold share retains its 2017H1--2019H2 pre comparison.",
 "Incentive B is the economic value of a relaxed cap; it need not be larger for rl1_only. Any ranking is an assumption about financing constraints, not a prediction. Tier description citation: jin2025deleveraging only; institutional rules not independently verified here.",
 "Part C gate is statistic-, scope-, variant- and period-specific: both groups must contribute at least 15 unique firms with finite outcomes. Contrasts require all contributing cells to pass; otherwise inference=descriptive_small_cell, no CI. Double differences are rl1_only minus rl1_plus.")
incentive<-list(); cell_firms<-matrix(0,2,2,dimnames=list(groups,c("pre","post")))
pre<-d$date>=as.Date("2017-06-30")&d$date<=as.Date("2019-12-31")
for(p in c("pre","post"))for(g in groups) {
 use<-if(p=="pre")pre else post
 use<-use&!is.na(d$incentive_group)&d$incentive_group==g&is.finite(d$official)&d$official>=.6&d$official<=.8
 cell_firms[g,p]<-nf(d$firm_id[use])
 incentive[[length(incentive)+1L]]<-data.frame(row_type="counts_first",group=g,period=p,
   scope="RL1_060_080",variant="all",metric="unique_firms",estimate=cell_firms[g,p],n=sum(use),n_firms=cell_firms[g,p])
}
# Draws use the same full-history firm resamples as Part A; the gate uses
# actual finite outcomes (conditional failure counts only official compliers).
incentive_summary<-function(y,id,gate_min) {
 pass<-gate_min>=15L
 z<-summarize(y,id,inference=pass)
 z$row$size_gate_pass<-pass; z$row$gate_min_firms<-gate_min
 if(!pass) {
   z$row$inference<-"descriptive_small_cell"
   z$row[c("ci_low","ci_high","bootstrap_draws","bootstrap_valid","bootstrap_failed")]<-NA
 }
 z
}
incentive_contrast<-function(a,b,gate_min) {
 r<-a$row; r$estimate<-a$row$estimate-b$row$estimate
 pass<-gate_min>=15L
 if(pass) {
   inf<-ci(a$draws-b$draws); r[names(inf)]<-as.list(inf)
 } else r[c("ci_low","ci_high","bootstrap_draws","bootstrap_valid","bootstrap_failed")]<-NA
 r$size_gate_pass<-pass; r$gate_min_firms<-gate_min
 r$inference<-if(pass)"pointwise_firm_bootstrap" else "descriptive_small_cell"
 r$benchmark_n<-b$row$n; r$benchmark_firms<-b$row$n_firms
 list(row=r,draws=if(pass)a$draws-b$draws else rep(NA_real_,B))
}
for(v in c("all","exclude_jump_dates"))for(scope in c("RL1_060_080","all_firm_dates")) {
 contrasts<-list()
 for(m in c("share_068_070","D","fail_given_official")) {
   periods<-if(m=="share_068_070")c("pre","post") else c("placebo","post")
   cells<-list(); gate_counts<-matrix(0,2,2,dimnames=list(groups,periods))
   for(p in periods)for(g in groups) {
     use<-switch(p,pre=pre,post=post,placebo=placebo)
     use<-use&!is.na(d$incentive_group)&d$incentive_group==g&is.finite(d$official)
     if(scope=="RL1_060_080")use<-use&d$official>=.6&d$official<=.8
     if(v=="exclude_jump_dates")use<-use&!d$known_flag
     z<-d[use,]; C<-as.numeric(z$official<=.7)
     cf<-if(p=="placebo")z$placebo else z$frozen
     F<-ifelse(is.finite(cf),as.numeric(cf<=.7),NA_real_)
     y<-switch(m,share_068_070=as.numeric(z$official>=.68&z$official<.7),
       D=C-F,fail_given_official=ifelse(C==1,1-F,NA_real_))
     cells[[paste(g,p)]]<-list(y=y,id=z$firm_id)
     gate_counts[g,p]<-nf(z$firm_id[is.finite(y)])
   }
   stats<-list()
   for(p in periods)for(g in groups) {
     cell<-cells[[paste(g,p)]]
     z<-incentive_summary(cell$y,cell$id,min(gate_counts[,p]))
     stats[[paste(g,p)]]<-z
     incentive[[length(incentive)+1L]]<-cbind(data.frame(row_type="statistic",group=g,period=p,
       scope=scope,variant=v,metric=m,anchor=if(m=="share_068_070")"not_applicable" else
         if(p=="placebo")"2016-12-31" else "2019-12-31"),z$row)
   }
   contrast_period<-if(m=="share_068_070")"post_minus_pre" else "post_minus_placebo"
   for(g in groups) {
     z<-incentive_contrast(stats[[paste(g,"post")]],stats[[paste(g,periods[1])]],min(gate_counts))
     contrasts[[paste(g,m)]]<-z
     incentive[[length(incentive)+1L]]<-cbind(data.frame(row_type="contrast",group=g,period=contrast_period,
       scope=scope,variant=v,metric=m,anchor=if(m=="share_068_070")"not_applicable" else "2019_minus_2016"),z$row)
   }
   if(m!="share_068_070") {
     a<-contrasts[[paste(groups[1],m)]]; b<-contrasts[[paste(groups[2],m)]]
     z<-incentive_contrast(a,b,min(gate_counts)); r<-z$row
     # Preserve all four contributing cell counts next to a double difference.
     r$benchmark_n<-a$row$benchmark_n; r$benchmark_firms<-a$row$benchmark_firms
     r$other_group_n<-b$row$n; r$other_group_firms<-b$row$n_firms
     r$other_group_benchmark_n<-b$row$benchmark_n
     r$other_group_benchmark_firms<-b$row$benchmark_firms
     incentive[[length(incentive)+1L]]<-cbind(data.frame(row_type="difference_of_differences",
       group="rl1_only_minus_rl1_plus",period=contrast_period,scope=scope,variant=v,metric=m,
       anchor="2019_minus_2016"),r)
   }
 }
}
incentive<-bind(incentive); write_csv(incentive,"incentive")
stopifnot(!any(incentive$period=="pre"&incentive$metric %in% c("D","fail_given_official")),
 all(is.na(incentive$ci_low[incentive$inference=="descriptive_small_cell"&!is.na(incentive$inference)])))
coverage<-c(coverage,sprintf("Part C: %d inferential rows; %d descriptive_small_cell rows (CIs suppressed). Counts-first rows are descriptive counts.",
 sum(incentive$size_gate_pass,na.rm=TRUE),sum(incentive$inference=="descriptive_small_cell",na.rm=TRUE)))

# Plain American English TeX; complete CSVs accompany readable page-size panels.
fmt<-function(x)ifelse(is.finite(x),sprintf("%.4f",x),"--")
escape<-function(x)gsub("_","\\_",x,fixed=TRUE)
common_note<-paste(
 "These are mechanical accounting counterfactuals, not attainable balance sheets, causal effects, or economic leverage. Minority interests may be genuine equity.",
 "Official RL1 is N/(N+E), N=liabilities minus advances, E=total equity including minority interests. N and E must be positive.",
 "Frozen MI replaces current minority interests with their end-2019 level, holding all other observed items at their realized values; the pre-period placebo freezes them at end-2016.",
 "Ex-MI is mechanical, not a deconsolidated balance sheet. Nonpositive total counterfactual denominators are unavailable.",
 "All shares are proportions. N and firms count available observations and unique firms for each estimate; contributing contrast counts are identified in the table notes.",
 "Both variants are reported: all observations and exclude jump dates (known half-year minority-interest jumps above 50 percent of current equity). Unknown flags are retained; later dates retain the jump in the MI stock.",
 "Percentile 95 percent intervals use 999 whole-firm resamples with shared draws, full histories and complete re-estimation. Intervals are pointwise; no significance stars.",
 "HK changes assume unchanged reporting currency within firm; currency metadata remain unresolved.")
tex_table<-function(rows,name,caption,header,align,note,panel=16L) {
 chunks<-split(rows,ceiling(seq_along(rows)/panel)); out<-character()
 for(k in seq_along(chunks))out<-c(out,
  "\\begin{table}[!htbp]\\centering\\scriptsize",paste0("\\caption{",caption," (panel ",k," of ",length(chunks),")}"),
  "\\begin{threeparttable}",paste0("\\begin{tabular}{",align,"}"),"\\toprule",
  paste0(header," \\\\"),"\\midrule",chunks[[k]],"\\bottomrule","\\end{tabular}",
  "\\begin{tablenotes}[flushleft]\\footnotesize",paste0("\\item[] ",note),
  "\\end{tablenotes}","\\end{threeparttable}","\\end{table}","")
 write_text(out,paste0(name,".tex"))
}
rows<-vapply(seq_len(nrow(compliance)),function(i) {
 z<-compliance[i,]; label<-paste(gsub("_"," ",z$window),if(z$date!="pooled")z$date else "",gsub("_"," ",z$metric))
 n_label<-if(is.finite(z$benchmark_n))paste(z$n,z$benchmark_n,sep=" / ") else z$n
 firms_label<-if(is.finite(z$benchmark_firms))paste(z$n_firms,z$benchmark_firms,sep=" / ") else z$n_firms
 paste0(paste(label,if(z$variant=="all")"All" else "Excl. dates",n_label,firms_label,fmt(z$estimate),
   paste0("[",fmt(z$ci_low),", ",fmt(z$ci_high),"]"),sep=" & ")," \\\\")
},character(1))
tex_table(rows,"compliance","RL1 compliance under mechanical minority-interest counterfactuals",
 "Window, date and statistic & Sample & N & Firms & Estimate & 95\\% CI","p{0.36\\linewidth}lrrrr",
 paste(common_note,
 "Compliance contrast rows show post / placebo N and unique-firm counts in that order.",
 "D is the net difference C minus frozen compliance among paired firm-dates. Fail given official is the share failing frozen MI conditional on official compliance; reverse compliance is also reported.",
 "Main date shares cover 2017H1--2022H2; pre-policy date shares with a 2019 anchor are retrospective comparisons. The actual placebo covers 2017H2--2019H2 with the 2016 anchor.",
 "Post covers 2020H2--2022H2. Extension covers 2023H1--2024H2 separately."),panel=12L)
rows<-vapply(seq_len(nrow(bunch)),function(i) {
 z<-bunch[i,]; label<-paste(z$window,gsub("_"," ",z$scope),z$specification,gsub("_"," ",z$metric))
 paste0(paste(label,if(z$variant=="all")"All" else "Excl. dates",z$n,z$n_firms,fmt(z$estimate),
 paste0("[",fmt(z$ci_low),", ",fmt(z$ci_high),"]"),sep=" & ")," \\\\")
},character(1))
tex_table(rows,"counterfactual_bunching","Excess mass with minority interests frozen at end-2019",
 "Window, population, fit and ratio & Sample & N & Firms & b or difference & 95\\% CI","p{0.43\\linewidth}lrrrr",
 paste(common_note,
 "Interpretation rule specified before results: a large drop in b means bunching depends mechanically on post-2019 minority-interest growth; no drop means other items achieve bunching.",
 "The T023 stored-RL1 replication gate reproduces 3.14. The replication and all-eligible official fits share b despite different N because the 14 excluded nonpositive-N/E observations lie outside [0.40,1.00], leaving the same 557 histogram observations. Paired comparisons use identical eligible observations. All eligible comparisons retain all eligible official observations and available frozen observations, with separate counts and shared firm draws.",
 "Bins have width 0.01 over [0.40,1.00]; fifth-degree polynomial excludes [0.66,0.70). Alternatives use degree four or seven, [0.67,0.70), or [0.66,0.72). The mass window is always below 0.70.",
 "b equals excess count divided by the mean predicted count per mass-window bin. No integration constraint or clipping is used; nonpositive predicted counts invalidate a draw.",
 "Differences use paired draws with both fits re-estimated. Invalid draws and coverage are in the CSV; fewer than 90 percent valid draws makes inference unreliable."),panel=10L)

# A compact Part B table makes the requested pre-policy finding explicit;
# the complete coefficient grid, including both anchors, remains in the CSV.
pre_mi<-es[es$anchor=="2019-12-31"&es$outcome=="mi"&es$bin==3&
 es$date %in% c("2016-12-31","2017-06-30","2017-12-31","2018-06-30"),]
halfyear<-function(x)paste0(format(as.Date(x),"%Y"),"H",ifelse(format(as.Date(x),"%m")=="06",1,2))
pre_finding<-paste0("For the end-2019 bin 0 <= g < 0.10, pre-policy MI coefficients are ",
 paste(sprintf("%s: %.4f [%.4f, %.4f]",halfyear(pre_mi$date),pre_mi$estimate,
   pre_mi$ci_low,pre_mi$ci_high),collapse="; "),
 ". These pointwise intervals exclude zero: firms just above the threshold were already building MI faster than the reference group before 2020. Part B describes differential adjustment, not a policy effect.")
coverage<-c(coverage,pre_finding,"Part B: pointwise CIs, no multiple-testing correction.")
rows<-vapply(seq_len(nrow(pre_mi)),function(i) {
 z<-pre_mi[i,]
 paste0(paste(halfyear(z$date),z$n,z$n_firms,z$reference_n,z$reference_firms,
   fmt(z$estimate),paste0("[",fmt(z$ci_low),", ",fmt(z$ci_high),"]"),sep=" & ")," \\\\")
},character(1))
tex_table(rows,"distance_es","Pre-policy minority-equity adjustment for the initially near-above bin",
 "Date & N & Firms & Ref. N & Ref. firms & Coefficient & 95\\% CI","lrrrrrr",
 paste("Outcome is cumulative MI change since end-2019 / end-2019 total assets, with firm and date fixed effects. Reference date: 2019H2; reference bin: $g < -0.10$.",
 "Firm-clustered SEs with t critical values (model firms minus one degrees of freedom); pointwise CIs, no multiple-testing correction. Complete results for four outcomes and both anchors, including normalizations, are in the CSV and figure.",
 gsub("0 <= g < 0.10", "$0 \\leq g < 0.10$", pre_finding, fixed=TRUE),"Mechanical accounting comparisons are not attainable balance sheets, causal effects, or economic leverage; minority interests may be genuine equity."))

# Part C reports all four cells' counts for double differences. Small cells
# have a literal -- in the CI column, consistent with the machine-readable gate.
count_label<-function(z,field) {
 a<-as.character(z[[field]])
 benchmark<-if(field=="n")"benchmark_n" else "benchmark_firms"
 other<-if(field=="n")"other_group_n" else "other_group_firms"
 other_benchmark<-if(field=="n")"other_group_benchmark_n" else "other_group_benchmark_firms"
 if(is.finite(z[[benchmark]]))a<-paste(a,z[[benchmark]],sep=" / ")
 if(is.finite(z[[other]]))a<-paste0("\\shortstack{",a,"\\\\",
   z[[other]]," / ",z[[other_benchmark]],"}")
 a
}
rows<-vapply(seq_len(nrow(incentive)),function(i) {
 z<-incentive[i,]
 group<-switch(z$group,rl1_only="Only",rl1_plus="Plus",rl1_only_minus_rl1_plus="Only minus Plus")
 label<-paste(group,gsub("_"," ",z$period),if(z$scope=="RL1_060_080")"[0.60,0.80]" else "all dates",
   if(z$variant=="all")"All" else "Excl. dates",gsub("_"," ",z$metric))
 interval<-if(is.finite(z$ci_low)&&is.finite(z$ci_high))paste0("[",fmt(z$ci_low),", ",fmt(z$ci_high),"]") else "--"
 paste0(paste(label,count_label(z,"n"),count_label(z,"n_firms"),fmt(z$estimate),interval,sep=" & ")," \\\\")
},character(1))
tex_table(rows,"incentive","Descriptive incentive groups and anchor-matched compliance comparisons",
 "Group, period, scope, variant and statistic & N & Firms & Estimate & 95\\% CI","p{0.40\\linewidth}rrrr",
 paste(common_note,
 "Only denotes RL1-only breaches and Plus denotes RL1 plus other breaches at end-2019, requiring observed RL2 and RL3. Counts in [0.60,0.80] are listed first.",
 "D and fail given official use post 2020H2--2022H2 with the 2019 anchor and placebo 2017H2--2019H2 with the 2016 anchor. Share 068 070 uses [0.68,0.70) and pre 2017H1--2019H2. No pre-period D with a 2019 anchor is reported.",
 "For each statistic, scope, variant and period, both groups must contribute at least 15 unique firms with finite outcomes; contrasts require all contributing cells to pass. Otherwise inference is descriptive small cell and the CI is --.",
 "Contrasts list post / comparison counts; double differences are (Only post minus placebo) minus (Plus post minus placebo), with Only counts above Plus counts. Shared firm draws give paired percentile CIs.",
 "The economic value B of a relaxed cap need not be larger for Only firms; ranking it requires an assumption about financing constraints. Tier description: \\citet{jin2025deleveraging}."),panel=10L)

# Deterministic PDFs, using date-specific counts in CSV and population counts here.
cols<-c("#176B8E","#B24B3C","#6E7F3F","#8B5BA6")
open_pdf<-function(name,width,height,title)grDevices::pdf(paste0("outputs/figures/t029_",name,".pdf"),
 width=width,height=height,useDingbats=FALSE,timestamp=FALSE,title=title)
open_pdf("compliance_shares",10,8,"T029 mechanical RL1 compliance shares")
par(mfrow=c(2,1),mar=c(3.8,4.2,3.4,1),oma=c(3.5,0,0,0))
for(v in c("all","exclude_jump_dates")) {
 z<-compliance[compliance$window %in% c("main_by_date","extension_by_date")&compliance$variant==v,]
 dates<-sort(unique(z$date)); xr<-as.Date(dates)
 plot(xr,rep(NA,length(xr)),ylim=c(0,1),xlab="Reporting date",ylab="Compliance share",xaxt="n",
   main=if(v=="all")"Official vs. frozen MI vs. ex-MI: all eligible pairs" else "Known MI jump dates excluded")
 axis(1,at=xr[seq(1,length(xr),by=2)],labels=paste0(format(xr[seq(1,length(xr),by=2)],"%Y"),"H",ifelse(format(xr[seq(1,length(xr),by=2)],"%m")=="06",1,2)),cex.axis=.8)
 abline(v=as.Date(c("2020-08-20","2023-06-30")),col="grey65",lty=c(2,3))
 for(k in 1:3) {
   a<-z[z$metric==c("official","frozen","ex_mi")[k],]; a<-a[order(a$date),]
   for(window in c("main_by_date","extension_by_date")) {
     segment<-a[a$window==window,]
     if(nrow(segment))lines(as.Date(segment$date),segment$estimate,col=cols[k],lty=k,type="b",pch=14+k,cex=.6)
   }
 }
 legend("topleft",c("Official","Frozen at end-2019","Ex-MI"),col=cols[1:3],lty=1:3,pch=15:17,bty="n",cex=.8)
 mtext(sprintf("Unique firms: %d main, %d extension; date-specific counts in CSV.",
  nf(d$firm_id[is.finite(d$frozen)]),if(is.null(ext))0 else nf(ext$firm_id[ext$date>as.Date("2022-12-31")&is.finite(ext$frozen)])),side=3,line=.25,cex=.7)
}
mtext("Mechanical accounting comparisons; minority interests may be genuine equity. Pre-2020 frozen shares use the 2019 anchor.",
 side=1,outer=TRUE,line=1,cex=.75)
mtext("Dashed: August 2020; dotted: start of separate extension. Not attainable balance sheets, causal effects, or economic leverage.",
 side=1,outer=TRUE,line=2.2,cex=.75)
invisible(dev.off())

open_pdf("bunching_frozen",9,6.5,"T029 official and frozen RL1 post-policy")
par(mar=c(8,4.2,4,1))
plot(mid,fits$official$observed,type="s",col=cols[1],lwd=2,xlim=c(.4,1),
 ylim=c(0,max(fits$official$observed,fits$frozen$observed)*1.12),xlab="RL1 (0.01 bins)",ylab="Firm-date count",
 main="Post-policy RL1 with minority interests frozen at end-2019")
lines(mid,fits$frozen$observed,type="s",col=cols[2],lwd=2)
abline(v=.7,lty=2,col="grey40")
legend("topleft",c(sprintf("Official: b=%.2f; firms=%d",fits$official$estimate,fits$official$n_firms),
 sprintf("Frozen: b=%.2f; firms=%d",fits$frozen$estimate,fits$frozen$n_firms)),col=cols[1:2],lwd=2,bty="n")
mtext(sprintf("2020H2--2022H2; paired observations N=%d. Counts outside [0.40,1.00] official/frozen: %d/%d.",
 fits$official$n,fits$official$n-fits$official$n_in_range,fits$frozen$n-fits$frozen$n_in_range),side=1,line=4.4,cex=.73)
mtext("Mechanical accounting counterfactuals; minority interests may be genuine equity.",side=1,line=5.5,cex=.73)
mtext("Not attainable balance sheets, causal effects, or economic leverage. Both flag variants and all five fits in CSV.",side=1,line=6.6,cex=.73)
invisible(dev.off())

open_pdf("distance_es",11,9,"T029 differential adjustment by predetermined RL1 distance")
for(anchor in c("2019-12-31","2019-06-30")) {
 par(mfrow=c(2,2),mar=c(4,4.3,3,1),oma=c(5,0,3,0))
 for(outcome in c("mi","parent_equity","ibd","N")) {
   z<-es[es$anchor==anchor&es$outcome==outcome,]; dates<-sort(unique(z$date)); xx<-as.Date(dates)
   yr<-range(c(z$estimate,z$ci_low,z$ci_high),finite=TRUE); pad<-.07*diff(yr)
   plot(xx,rep(NA,length(xx)),ylim=yr+c(-pad,pad),xaxt="n",xlab="Reporting date",
     ylab="Change / end-2019 total assets",main=switch(outcome,mi="Minority equity",parent_equity="Parent equity",ibd="Interest-bearing debt",N="Non-advance liabilities N"))
   axis(1,at=xx[seq(1,length(xx),by=2)],labels=halfyear(xx[seq(1,length(xx),by=2)]),cex.axis=.8)
   abline(h=0,col="grey70"); abline(v=as.Date(c("2019-12-31","2020-08-20")),col="grey75",lty=c(3,2))
   for(b in 1:4) {
     a<-z[z$bin==b,]; a<-a[order(a$date),]; x<-as.Date(a$date)
     lines(x,a$estimate,col=cols[b],lty=b,lwd=1.5)
     arrows(x,a$ci_low,x,a$ci_high,angle=90,code=3,length=.025,col=adjustcolor(cols[b],alpha.f=.4))
     points(x,a$estimate,col=cols[b],pch=14+b,cex=.5)
   }
   mtext(sprintf("Model: %d firms, %d observations",z$model_firms[1],z$model_n[1]),side=3,line=.2,cex=.72)
 }
 mtext(paste("Differential adjustment by initial distance; gap measured at",anchor),outer=TRUE,side=3,line=1,cex=1)
 for(b in 1:4)mtext(bin_labels[b],outer=TRUE,side=1,line=.5,at=.15+.23*(b-1),col=cols[b],cex=.8)
 mtext("Reference: end-2019 and g < -0.10 (zero line). Firm-clustered 95% pointwise CIs, no multiple-testing correction.",outer=TRUE,side=1,line=2,cex=.75)
 mtext("Descriptive differential adjustment, not a policy effect. MI may be genuine equity. Bin/date counts in CSV.",outer=TRUE,side=1,line=3.1,cex=.75)
}
invisible(dev.off())

# Machine-readable outputs drive the plain-language results and safeguards.
get_comp<-function(w,m,v="all")compliance[compliance$window==w&compliance$date=="pooled"&
 compliance$variant==v&compliance$metric==m,]
for(v in c("all","exclude_jump_dates")) {
 a<-get_comp("post","D",v); b<-get_comp("placebo","D",v); c<-get_comp("post_minus_placebo","D",v)
 q<-get_comp("post","fail_given_official",v)
 coverage<-c(coverage,sprintf("RESULT %s: post D=%.8f [%.8f,%.8f] (%d firms); placebo D=%.8f [%.8f,%.8f] (%d firms); post-minus-placebo=%.8f [%.8f,%.8f]; post conditional failure=%.8f (%d firms).",
  v,a$estimate,a$ci_low,a$ci_high,a$n_firms,b$estimate,b$ci_low,b$ci_high,b$n_firms,c$estimate,c$ci_low,c$ci_high,q$estimate,q$n_firms))
 z<-bunch[bunch$window=="post"&bunch$variant==v&bunch$scope=="paired"&bunch$specification=="main",]
 a<-z[z$metric=="official",]; b<-z[z$metric=="frozen",]; c<-z[z$metric=="official_minus_frozen",]
 coverage<-c(coverage,sprintf("RESULT %s: paired b_official=%.8f, b_frozen=%.8f; drop=%.8f [%.8f,%.8f]; %d/%d paired valid draws, %d firms.",
  v,a$estimate,b$estimate,c$estimate,c$ci_low,c$ci_high,c$bootstrap_valid,B,c$n_firms))
}
coverage<-c(coverage,"Existing outputs and both input panels guarded by exact SHA-256 before and after T029.",
 "Two-run and full-build byte comparisons are recorded separately in t029_verification.txt (not overwritten by this analysis).")
write_text(coverage,"coverage.txt")
stopifnot(identical(input_hash,tools::sha256sum(inputs)),
 identical(protected_hash,tools::sha256sum(protected)))
cat(sprintf("T029: equality invariant <=1e-12 and component sum <=1e-10 asserted; %d protected outputs unchanged.\n",length(protected)))
cat(sprintf("T029: %d compliance, %d bunching, %d debt, %d event-study, %d component and %d incentive rows.\n",
 nrow(compliance),nrow(bunch),nrow(debt),nrow(es),nrow(components),nrow(incentive)))
cat(sprintf("T029: Part C per-statistic gate: %d inferential / %d descriptive_small_cell rows.\n",
 sum(incentive$size_gate_pass,na.rm=TRUE),sum(incentive$inference=="descriptive_small_cell",na.rm=TRUE)))
cat("T029: wrote six CSVs, four TeX fragments, coverage and three deterministic PDFs.\n")
