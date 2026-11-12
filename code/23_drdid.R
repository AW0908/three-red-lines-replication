# T066. Offline only. Run from replication/: Rscript code/23_drdid.R
# Sant'Anna-Zhao improved panel DR DiD: IPT logistic PS and odds-weighted OLS.
# No upstream script is executed; no research inputs or existing outputs overwritten.
options(digits=17, stringsAsFactors=FALSE, width=160)
seed <- 20261102L; B <- 999L; BH <- 499L; set.seed(seed)
stopifnot(requireNamespace('DRDID',quietly=TRUE),requireNamespace('fixest',quietly=TRUE))
fixest::setFixest_nthreads(1)
read <- function(p,...)read.csv(p,na.strings=c('','NA','--'),...)
upstream <- parse('code/21_diff_bunching.R')
for(name in c('nf','period_masks','weights','mass','change','ci')) {
 hit<-vapply(upstream,function(e)is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name(name)),logical(1))
 stopifnot(sum(hit)==1L);eval(upstream[[which(hit)]])
}
protected<-list.files('outputs',recursive=TRUE,full.names=TRUE,all.files=TRUE)
protected<-protected[!dir.exists(protected)&!grepl('^t066_',basename(protected))]
protected_hash<-tools::sha256sum(protected)
rawfiles<-list.files('data/raw',recursive=TRUE,full.names=TRUE,all.files=TRUE)
rawfiles<-rawfiles[!dir.exists(rawfiles)&rawfiles!='data/raw/MANIFEST.csv']
raw_hash<-tools::sha256sum(rawfiles)
# Card explicitly authorizes this new immutable copy and its MANIFEST entry.
price_source<-'../Daten/control/prices_2019.csv';price_copy<-'data/raw/manual/prices_2019.csv'
stopifnot(file.exists(price_source))
if(!file.exists(price_copy))stopifnot(file.copy(price_source,price_copy,overwrite=FALSE))
stopifnot(identical(unname(tools::sha256sum(price_source)),unname(tools::sha256sum(price_copy))))
manifest_path<-'data/raw/MANIFEST.csv';manifest<-read(manifest_path)
entry<-data.frame(file=price_copy,source='Daten/control/prices_2019.csv',
 download_export_date='unverified; PI file; price dates 2019-12-30/31',size_bytes=file.info(price_copy)$size,
 sha256=unname(tools::sha256sum(price_copy)))
if(!price_copy%in%manifest$file) {
 # Preserve all existing manifest bytes, including its original line endings.
 con<-file(manifest_path,'ab');write.table(entry,con,sep=',',row.names=FALSE,col.names=FALSE,eol='\r\n',qmethod='double');close(con)
} else stopifnot(identical(as.character(manifest$sha256[manifest$file==price_copy]),entry$sha256))
inputs<-c('code/23_drdid.R','code/09_selection.R','code/21_diff_bunching.R','code/22_referee5.R',
 'code/06_bunching_tests.R','data/processed/panel_firm_halfyear.csv',
 'outputs/tables/t061_control_panel.csv','outputs/tables/t061_estimates.csv',
 'outputs/tables/t025_first_stage_diagnostics.csv',price_source,price_copy,manifest_path,'run_all.R','run_all.sh','README.md')
# Immutable pre-rework output bytes support exact old -> new comparisons.
baseline_path<-'outputs/tables/t066_rework1_baseline.rds'
stopifnot(file.exists(baseline_path),unname(tools::sha256sum(baseline_path))==
 'ab9720be7f3938548815e8a8f6c01babac2c2d269812678ac5592e8d3c6d33fc')
baseline<-readRDS(baseline_path)
inputs<-c(inputs,baseline_path)
# Rework 2 may change only interpretation/validation/guard metadata among the
# existing outputs. Add same-risk-set results separately to preserve old tables.
rework2_path<-'outputs/tables/t066_rework2_baseline.csv'
stopifnot(unname(tools::sha256sum(rework2_path))==
 '005ce263852c2944ee5d0540793ae785ae2ec47162c8cea7847d473c071cdcb0')
rework2_baseline<-read(rework2_path)
inputs<-c(inputs,rework2_path)
input_hash<-tools::sha256sum(inputs)
staged<-list();tables<-list()
stage<-function(f,target) {
 stopifnot(grepl('^outputs/(tables|figures)/t066_',target));staged[[length(staged)+1L]]<<-c(path=f,target=target)
}
csv<-function(z,name,map=TRUE) {
 f<-tempfile(fileext='.csv');con<-file(f,'wb');write.csv(z,con,row.names=FALSE,na='NA',eol='\n');close(con)
 stage(f,paste0('outputs/tables/t066_',name,'.csv'));if(map)tables[[name]]<<-z
}
textout<-function(z,name,ext='tex') {
 f<-tempfile(fileext=paste0('.',ext));writeLines(z,f,useBytes=TRUE);stage(f,paste0('outputs/tables/t066_',name,'.',ext))
}
bind<-function(x) {
 cols<-unique(unlist(lapply(x,names)))
 do.call(rbind,lapply(x,function(z){for(n in setdiff(cols,names(z)))z[[n]]<-NA;z[cols]}))
}
fmt<-function(x)ifelse(is.finite(x),sprintf('%.4f',x),'--')
esc<-function(x)gsub('_','\\_',x,fixed=TRUE)
texrow<-function(x)paste0(paste(x,collapse=' & '),' \\\\')
tex<-function(name,header,rows,align,note,chunk=18L,caption=NULL) {
 out<-c('\\begingroup\\small','\\setlength{\\tabcolsep}{3pt}')
 for(ii in split(seq_along(rows),ceiling(seq_along(rows)/chunk)))out<-c(out,paste0('\\begin{tabular}{',align,'}'),
 '\\toprule',texrow(header),'\\midrule',rows[ii],'\\bottomrule','\\end{tabular}','\\par\\medskip')
 if(!is.null(caption))out<-c('\\begin{table}[htbp]','\\centering',paste0('\\caption{',caption,'}'),out)
 textout(c(out,paste0('\\footnotesize ',note),'\\endgroup',if(!is.null(caption))'\\end{table}'),name)
}
pdf_start<-function(name,width=7.5,height=5.5) {
 f<-tempfile(fileext='.pdf');pdf(f,width=width,height=height,pointsize=11,useDingbats=FALSE,timestamp=FALSE,title=paste('T066',name))
 stage(f,paste0('outputs/figures/t066_',name,'.pdf'))
}
all_panel<-read('data/processed/panel_firm_halfyear.csv')
d<-all_panel[!is.na(all_panel$sample_main)&all_panel$sample_main,];d$date<-as.Date(d$date)
d<-d[order(d$firm_id,d$date),];rownames(d)<-NULL;dates<-sort(unique(d$date))
cp<-read('outputs/tables/t061_control_panel.csv',colClasses=c(code='character'));cp$date<-as.Date(cp$date)
cp<-cp[cp$date%in%dates,];cp<-cp[order(cp$firm_id,cp$date),]
stopifnot(length(dates)==13L,!anyDuplicated(d[c('firm_id','date')]),!anyDuplicated(cp[c('firm_id','date')]),
 !any(cp$firm_id%in%all_panel$firm_id))
# First numerical gate. Point weights suffice; bootstrap begins after reproduction.
W1<-function(z)matrix(1,nf(z$firm_id),1L)
bd<-change(d,W1(d));bc<-change(cp,W1(cp))
stopifnot(round(bd$delta[1],2)==4.02,round(bd$delta[1]-bc$delta[1],2)==4.59)
csv(data.frame(metric=c('developer_delta_b','developer_minus_control_delta_b'),
 estimate=c(bd$delta[1],bd$delta[1]-bc$delta[1]),expected_rounded=c(4.02,4.59),assert_pass=TRUE),'reproduction')
cat('T066 reproduction PASS: 136-firm main-sample developer delta 4.02; developer-control delta 4.59.\n');flush.console()

# Outcomes are missing when the underlying ratio is missing, never coded zero.
add_outcomes<-function(z) {
 z$Y1<-ifelse(is.finite(z$rl1),as.numeric(z$rl1>=.66&z$rl1<.70),NA_real_)
 z$Y2<-ifelse(is.finite(z$rl1),as.numeric(z$rl1<=.70),NA_real_)
 z$Y3<-z$rl1
 z$Y4<-ifelse(is.finite(z$rl1),as.numeric(z$rl1>=.56&z$rl1<.60),NA_real_)
 z$Y5<-if('mi_share'%in%names(z))z$mi_share else NA_real_
 z
}
d<-add_outcomes(d);cp<-add_outcomes(cp)
ylabels<-c(Y1='RL1 in [0.66,0.70)',Y2='RL1 at or below 0.70',Y3='RL1 level',Y4='RL1 in [0.56,0.60)',Y5='Minority interest / total equity')
clabels<-c(log_ta='Log total assets',rl1='RL1 at end-2019',rl1_change='RL1 change 2017H2 to 2019H2',
 adv_ta='Advance receipts plus contract liabilities / assets',rl2='RL2 at end-2019',rl3='RL3 at end-2019',
 cash_std='Cash / short-term debt',mi_share='Minority interest / total equity',hk='Hong Kong listing')
# One row per firm. No synthetic financial data, imputation or currency conversion.
make_cov<-function(z,own=FALSE,base=as.Date('2019-12-31'),include_change=TRUE) {
 ids<-sort(unique(z$firm_id));b<-z[z$date==base,]
 lagdate<-as.Date(paste0(as.integer(format(base,'%Y'))-2L,format(base,'-%m-%d')))
 old<-z[z$date==lagdate,]
 a<-data.frame(firm_id=ids);ix<-match(ids,b$firm_id)
 a$log_ta<-ifelse(b$ta[ix]>0,log(b$ta[ix]),NA_real_);a$rl1<-b$rl1[ix]
 if(own) {
  a$rl2<-b$rl2[ix];a$rl3<-b$rl3[ix]
  a$mi_share<-b$mi_share[ix]
 } else {
  if(include_change)a$rl1_change<-a$rl1-old$rl1[match(ids,old$firm_id)]
  a$adv_ta<-ifelse(b$ta[ix]>0,b$adv[ix]/b$ta[ix],NA_real_)
 }
 a
}
covdev<-make_cov(d);covcp<-make_cov(cp);covown<-make_cov(d,TRUE)
supplier_labels<-c('\u5efa\u7b51\u5efa\u6750','\u6c34\u6ce5\u884c\u4e1a','\u94a2\u94c1\u884c\u4e1a')
supplier<-vapply(strsplit(cp$board,'[;|,]'),function(x)any(trimws(x)%in%supplier_labels),logical(1))
# Literal soe field mandated by the card, not the later soe_final override.
owners<-do.call(rbind,lapply(sort(unique(d$firm_id)),function(id) {
 s<-unique(d$soe[d$firm_id==id&!is.na(d$soe)]);stopifnot(length(s)<=1L)
 data.frame(firm_id=id,soe=if(length(s))s else NA_integer_)
}))
csv(data.frame(classification=c('private','state_owned','unclassified'),
 firms=c(sum(owners$soe==0,na.rm=TRUE),sum(owners$soe==1,na.rm=TRUE),sum(is.na(owners$soe))),
 source='panel soe; no soe_final substitution'),'ownership_counts')
config<-list(
 A_control=list(t=d[d$market=='A',],c=cp,xt=covdev,xc=covcp,own=FALSE,label='A developers vs controls'),
 all_control=list(t=d,c=cp,xt=covdev,xc=covcp,own=FALSE,label='All developers vs A controls'),
 A_control_no_suppliers=list(t=d[d$market=='A',],c=cp[!supplier,],xt=covdev,xc=covcp,own=FALSE,label='A developers vs other controls'),
 all_control_no_suppliers=list(t=d,c=cp[!supplier,],xt=covdev,xc=covcp,own=FALSE,label='All developers vs other controls'),
 private_SOE=list(t=d[d$firm_id%in%owners$firm_id[!is.na(owners$soe)&owners$soe==0],],
 c=d[d$firm_id%in%owners$firm_id[!is.na(owners$soe)&owners$soe==1],],xt=covown,xc=covown,own=TRUE,label='Private vs state-owned developers'))
# Approved fallback: only four HK SOEs exist, so no HK stratum can reach ten.
# Keep config$private_SOE unchanged for the all-market ownership bunching contrast.
market_counts<-do.call(rbind,lapply(c('A','HK'),function(m) {
 ids<-unique(d$firm_id[d$market==m]);o<-owners[owners$firm_id%in%ids,]
 data.frame(market=m,private=sum(o$soe==0,na.rm=TRUE),SOE=sum(o$soe==1,na.rm=TRUE),
  eligible=sum(o$soe==0,na.rm=TRUE)>=10L&&sum(o$soe==1,na.rm=TRUE)>=10L)
}))
stopifnot(market_counts$eligible[market_counts$market=='A'],
 !market_counts$eligible[market_counts$market=='HK'])
csv(market_counts,'ownership_markets')
# Interval outcomes are averages of the firm-date outcome, not indicators of an
# averaged ratio. At least one observed date per period; exact counts are saved.
period_value<-function(z,ids,use,ys) {
 ans<-matrix(NA_real_,length(ids),length(ys),dimnames=list(ids,ys));nn<-ans*0
 for(i in seq_along(ids))for(y in ys) {
  v<-z[[y]][z$firm_id==ids[i]&use];v<-v[is.finite(v)];nn[i,y]<-length(v)
  if(length(v))ans[i,y]<-mean(v)
 }
 list(y=ans,n=nn)
}
make_pair<-function(cf,period='main',placebo=NULL) {
 if(cf$own) {
  cf$t<-cf$t[cf$t$market=='A',];cf$c<-cf$c[cf$c$market=='A',]
 }
 ys<-if(cf$own)names(ylabels) else names(ylabels)[1:4]
 # Placebo nuisance covariates are measured at the earlier date only. The
 # two-year lag change ends at that base; never at the 2019 placebo endpoint.
 include_change<-TRUE;base<-as.Date('2019-12-31')
 if(!is.null(placebo)) {
  base<-placebo;lagdate<-as.Date(paste0(as.integer(format(base,'%Y'))-2L,format(base,'-%m-%d')))
  include_change<-lagdate%in%cf$t$date&&lagdate%in%cf$c$date
  cf$xt<-make_cov(cf$t,cf$own,base,include_change)
  cf$xc<-make_cov(cf$c,cf$own,base,include_change)
 }
 z<-rbind(cf$t[,c('firm_id','date',ys)],cf$c[,c('firm_id','date',ys)])
 ids<-sort(unique(z$firm_id));tids<-unique(cf$t$firm_id)
 cv<-rbind(cf$xt[cf$xt$firm_id%in%tids,],cf$xc[cf$xc$firm_id%in%cf$c$firm_id,])
 stopifnot(!anyDuplicated(cv$firm_id));cv<-cv[match(ids,cv$firm_id),]
 if(!is.null(placebo)) {
  pre<-z$date==placebo;post<-z$date==as.Date('2019-12-31')
 } else if(period=='main') {
  pre<-z$date==as.Date('2019-12-31');post<-z$date==as.Date('2021-12-31')
 } else {
  pre<-z$date>=as.Date('2017-06-30')&z$date<=as.Date('2019-12-31')
  post<-z$date>=as.Date('2020-12-31')&z$date<=as.Date('2022-12-31')
 }
 a<-period_value(z,ids,pre,ys);b<-period_value(z,ids,post,ys)
 list(ids=ids,D=as.integer(ids%in%tids),X=as.matrix(cv[-1]),y0=a$y,y1=b$y,n0=a$n,n1=b$n,
  base=base,change_omitted=!cf$own&&!include_change)
}
# Remove only exact redundant columns; no covariate selection based on outcomes.
# Standardization improves IPT numerical conditioning without changing the model.
standard_X<-function(X) {
 mu<-colMeans(X);ss<-apply(X,2,sd);ss[!is.finite(ss)|ss==0]<-1
 Z<-cbind('(Intercept)'=1,sweep(sweep(X,2,mu,'-'),2,ss,'/'))
 q<-qr(Z,tol=1e-9);keep<-sort(q$pivot[seq_len(q$rank)])
 # Orthonormalize the same column space to avoid squaring the condition number
 # in the bootstrap IPT Hessian. This changes no covariate.
 stopifnot(keep[1]==1L)
 xx<-qr.Q(qr(Z[,keep,drop=FALSE]))*sqrt(nrow(Z));xx[,1]<-1
 colnames(xx)<-colnames(Z)[keep]
 list(X=xx,dropped=paste(setdiff(colnames(Z),colnames(Z)[keep]),collapse=';'))
}
# Bootstrap refits solve the same convex IPT moment equations by damped Newton.
# Deterministic iteration/line-search limits prevent a non-existent overlap fit
# from spending unbounded time in the package's secondary optimizer. Convergence
# is checked by the installed package's own ipt.valid gate. No alternative PS
# model is substituted; unsolved equations count as failed bootstrap draws.
ipt_boot<-function(X,D) {
 X0<-X[D==0,,drop=FALSE];target<-colSums(X[D==1,,drop=FALSE]);nT<-sum(D)
 gamma<-rep(0,ncol(X));gamma[1]<-log(sum(D)/sum(D==0))
 objective<-function(g) {
  eta<-drop(X0%*%g)
  if(any(!is.finite(eta))||max(eta)>700)return(Inf)
  sum(exp(eta))-sum(target*g)
 }
 for(iter in seq_len(200L)) {
  eta<-drop(X0%*%gamma);odds<-exp(eta)
  gradient<-drop(crossprod(X0,odds))-target
  H<-crossprod(X0,odds*X0)
  step<-tryCatch(drop(solve(H,gradient)),error=function(e)NULL)
  if(is.null(step)||any(!is.finite(step)))stop('bootstrap IPT curvature is singular')
  if(max(abs(gradient))/max(1,nT)<1e-8&&max(abs(X%*%step))<1e-6&&
   DRDID:::ipt.valid(gamma,D,X,rep(1,length(D))))return(as.vector(plogis(X%*%gamma)))
  old<-objective(gamma);slope<-sum(gradient*step);rate<-1;accepted<-FALSE
  for(line in seq_len(40L)) {
   proposal<-gamma-rate*step;val<-objective(proposal)
   if(is.finite(val)&&val<=old-1e-4*rate*slope+1e-12*max(1,abs(old))) {accepted<-TRUE;break}
   rate<-rate/2
  }
  if(!accepted)stop('bootstrap IPT line search failed')
  gamma<-proposal
 }
 stop('bootstrap IPT did not satisfy package moment gate within 200 iterations')
}
# When ownership draws are sparse, the approved secondary algorithm is tried
# BEFORE damped Newton. Same package loss/initializer/tolerances and gate; a
# deterministic stepmax=2 and 200 iterations bound non-overlap searches.
# This changes the optimizer path, never the IPT equations or validity criterion.
ipt_secondary<-function(X,D) {
 iw<-rep(1,length(D));n<-length(D)
 initial<-tryCatch(suppressWarnings(DRDID:::fastglm_fit(X,D,binomial(),iw,method=3)),error=function(e)NULL)
 gamma<-initial$coefficients
 if(length(gamma)!=ncol(X)||any(!is.finite(gamma)))gamma<-rep(0,ncol(X))
 prepared<-DRDID:::ipt.loss.prepare(D,X,iw)
 second<-tryCatch(suppressWarnings(nlm(DRDID:::loss.ps.IPT,gamma,iterlim=200,gradtol=1e-8,stepmax=2,
  check.analyticals=FALSE,D=D,int.cov=X,iw=iw,n=n,.ipt=prepared)),error=function(e)NULL)
 if(!DRDID:::ipt.valid(second$estimate,D,X,iw))stop('package secondary IPT failed validity gate')
 as.vector(plogis(X%*%second$estimate))
}
ipt_primary<-function(X,D) {
 iw<-rep(1,length(D));n<-length(D)
 init<-tryCatch(suppressWarnings(DRDID:::fastglm_fit(X,D,binomial(),iw,method=3)),error=function(e)NULL)
 gamma<-init$coefficients
 if(length(gamma)!=ncol(X)||any(!is.finite(gamma)))gamma<-rep(0,ncol(X))
 prepared<-DRDID:::ipt.loss.prepare(D,X,iw)
 primary<-tryCatch(suppressWarnings(trust::trust(DRDID:::loss.ps.cal,parinit=gamma,
  rinit=1,rmax=1000,iterlim=1000,D=D,int.cov=X,iw=iw,.ipt=prepared)),error=function(e)NULL)
 if(!DRDID:::ipt.valid(primary$argument,D,X,iw))stop('package primary IPT failed validity gate')
 as.vector(plogis(X%*%primary$argument))
}
# Symmetric support trimming uses one preliminary maximum-likelihood logit on
# the complete-case population. The improved estimator then refits IPT on that
# retained sample. Support selection and IPT/WLS are repeated in every firm draw.
# Both preliminary (trimming) and final (balancing) scores are disclosed.
dr_fit<-function(X,D,dy,package_check=FALSE,secondary_first=FALSE) {
 initial<-standard_X(X);pre<-glm.fit(initial$X,D,family=binomial(),control=glm.control(maxit=100))
 if(!isTRUE(pre$converged)||any(!is.finite(pre$fitted.values)))stop('preliminary support logit failed')
 preliminary_ps<-as.vector(pre$fitted.values)
 idx<-which(preliminary_ps>=.01&preliminary_ps<=.99)
 if(length(idx)<4L||min(table(factor(D[idx],levels=0:1)))<2L)stop('insufficient treatment/comparison support')
 st<-standard_X(X[idx,,drop=FALSE]);xx<-st$X;dd<-D[idx]
 if(qr(xx[dd==0,,drop=FALSE])$rank<ncol(xx))stop('comparison outcome regression is rank deficient')
 solver<-'damped_Newton'
 supplied_verified_ps<-FALSE
 if(package_check&&secondary_first) {
  primary<-tryCatch(ipt_primary(xx,dd),error=function(e)NULL)
  if(!is.null(primary)) {ps<-primary;solver<-'package_primary_trust'} else {
   sec<-tryCatch(ipt_secondary(xx,dd),error=function(e)NULL)
   if(!is.null(sec)) {ps<-sec;solver<-'package_secondary_nlm'} else {
    ps<-ipt_boot(xx,dd);solver<-'secondary_failed_then_damped_Newton'
   }
   supplied_verified_ps<-TRUE
  }
 } else if(package_check) {
  psfit<-DRDID:::pscore.cal(dd,xx,rep(1,length(dd)),length(dd));ps<-psfit$pscore
  solver<-if(psfit$flag==1L)'package_secondary_nlm' else 'package_primary_trust'
 } else if(secondary_first) {
  sec<-tryCatch(ipt_secondary(xx,dd),error=function(e)NULL)
  if(is.null(sec)) {ps<-ipt_boot(xx,dd);solver<-'secondary_failed_then_damped_Newton'} else {
   ps<-sec;solver<-'package_secondary_nlm'
  }
 } else ps<-ipt_boot(xx,dd)
 ps<-pmin(ps,1-1e-6) # Same numerical cap as drdid_imp_panel.
 dropped<-unique(c(initial$dropped,st$dropped));iterations<-1L
 yy<-as.matrix(dy[idx,,drop=FALSE]);odds<-ps/(1-ps)
 # Simultaneous WLS for all outcomes: identical to the package's per-outcome
 # Gaussian WLS; unnormalized DR score uses the improved IPT estimating equation.
 fit<-lm.wfit(xx[dd==0,,drop=FALSE],yy[dd==0,,drop=FALSE],w=odds[dd==0])
 if(any(!is.finite(fit$coefficients)))stop('nonfinite weighted outcome regression')
 m0<-xx%*%fit$coefficients
 score<-dd-(1-dd)*odds
 att<-colSums(score*(yy-m0))/sum(dd)
 err<-0
 if(package_check) {
  bootps<-if(secondary_first)tryCatch(ipt_boot(xx,dd),error=function(e)ipt_secondary(xx,dd)) else ipt_boot(xx,dd)
  stopifnot(max(abs(bootps-ps))<1e-5)
 }
 if(package_check)for(j in seq_len(ncol(yy))) {
  package_panel<-DRDID::drdid_imp_panel
  if(supplied_verified_ps) {
   # Reuse the independently verified IPT solution in the unchanged package
   # outcome code rather than repeating an unbounded failed calibration path.
   env<-new.env(parent=environment(package_panel))
   env$pscore.cal<-function(D,int.cov,i.weights,n,...) {
    stopifnot(identical(D,dd),identical(int.cov,xx),all(i.weights==1))
    list(pscore=ps,flag=1L)
   }
   environment(package_panel)<-env
  }
  pkg<-package_panel(y1=yy[,j],y0=rep(0,nrow(yy)),D=dd,covariates=xx,
   boot=FALSE,trim.level=1)
  err<-max(err,abs(pkg$ATT-att[j]));stopifnot(err<1e-8)
  att[j]<-pkg$ATT
 }
 list(att=att,idx=idx,ps=ps,w=ifelse(dd==1,1,odds),D=dd,
 trimmed_t=sum(D==1)-sum(dd==1),trimmed_c=sum(D==0)-sum(dd==0),iterations=iterations,preliminary_ps=preliminary_ps,
 dropped=paste(dropped[nzchar(dropped)],collapse=';'),package_error=err,solver=solver)
}
safe_dr<-function(...) {
 ww<-character()
 out<-tryCatch(withCallingHandlers(dr_fit(...),warning=function(w){ww<<-c(ww,conditionMessage(w));invokeRestart('muffleWarning')}),
 error=function(e)list(error=conditionMessage(e)))
 out$warnings<-paste(unique(ww),collapse='; ');out
}
# Additional exact-ATT simulation and an independent package/algebra equality gate.
set.seed(seed);ns<-4000L;sx<-cbind(x1=rnorm(ns),x2=rnorm(ns));sd<-rbinom(ns,1,plogis(.2+.4*sx[,1]-.3*sx[,2]))
sdelta<-.3+.2*sx[,1]+.1*sx[,2]+1.5*sd
sim<-safe_dr(sx,sd,cbind(known_ATT=sdelta),TRUE)
stopifnot(is.null(sim$error),abs(sim$att[1]-1.5)<1e-8)
csv(data.frame(check=c('installed_package','known_ATT_linear_simulation','package_formula_equality'),
 expected=c(NA,1.5,0),actual=c(NA,sim$att[1],sim$package_error),pass=TRUE,
 package=paste0('DRDID ',as.character(packageVersion('DRDID'))),seed=seed),'dr_validation')
set.seed(seed)
results<-balances<-overlap<-drdraws<-sampleaudit<-fitlog<-placeboaudit<-strataaudit<-list();max_package_error<-0
weighted_smd<-function(x,D,w,scale=sqrt((var(x[D==1])+var(x[D==0]))/2)) {
 if(!is.finite(scale)||scale==0)return(if(mean(x[D==1])==mean(x[D==0]))0 else NA_real_)
 (weighted.mean(x[D==1],w[D==1])-weighted.mean(x[D==0],w[D==0]))/scale
}
run_dr<-function(key,period,placebo=NULL) {
 cf<-config[[key]];pa<-make_pair(cf,period,placebo)
 pid<-if(is.null(placebo))period else paste0('pre_',format(placebo,'%Y%m%d'))
 ys<-colnames(pa$y0); batches<-split(ys,vapply(ys,function(y)paste(which(is.finite(pa$y0[,y])&is.finite(pa$y1[,y])&
  rowSums(!is.finite(pa$X))==0),collapse=','),character(1)))
 for(ybatch in batches) {
  eligible<-is.finite(pa$y0[,ybatch[1]])&is.finite(pa$y1[,ybatch[1]])&rowSums(!is.finite(pa$X))==0
  ii<-which(eligible);xx<-pa$X[ii,,drop=FALSE];dd<-pa$D[ii]
  yy<-pa$y1[ii,ybatch,drop=FALSE]-pa$y0[ii,ybatch,drop=FALSE]
  cat(sprintf('T066 DR point: %s %s (%s).\n',key,pid,paste(ybatch,collapse=',')));flush.console()
  point<-safe_dr(xx,dd,yy,TRUE,secondary_first=cf$own)
  point_ok<-is.null(point$error)
  if(cf$own)strataaudit[[length(strataaudit)+1L]]<<-data.frame(comparison=key,period=pid,
   outcome=ybatch,market='A',candidate_t=sum(pa$D==1),candidate_c=sum(pa$D==0),
   complete_t=sum(dd==1),complete_c=sum(dd==0),firm_weight=1,
   decision='A shares only; HK excluded because only 4 classified SOEs (<10)')
  if(!is.null(placebo))for(y in ybatch) {
   im<-if(point_ok)point$idx else seq_len(nrow(xx))
   rr<-lm.fit(cbind(1,xx[im,,drop=FALSE]),yy[im,y])$residuals
   mechanical<-max(abs(rr))<1e-12*max(1,max(abs(yy[,y])))
   placeboaudit[[length(placeboaudit)+1L]]<<-data.frame(comparison=key,period=pid,outcome=y,
    covariate_base=as.character(pa$base),lag_change_omitted=pa$change_omitted,
    lag_change_start=if(pa$change_omitted||cf$own)NA_character_ else
     paste0(as.integer(format(pa$base,'%Y'))-2L,format(pa$base,'-%m-%d')),
    lag_change_end=if(pa$change_omitted||cf$own)NA_character_ else as.character(pa$base),
    mechanical=mechanical,count_in_intervals=!mechanical,
    reason=if(mechanical)'Outcome change lies algebraically in baseline covariate span' else
     'No exact algebraic identity; covariates at earlier base only')
  }
  if(point_ok)max_package_error<<-max(max_package_error,point$package_error)
  mat<-matrix(NA_real_,B,length(ybatch),dimnames=list(NULL,ybatch));fails<-rep('',B)
  bt<-bc<-rep(NA_integer_,B);warns<-solvers<-rep('',B)
  # Stratified firm bootstrap; one paired change per sampled firm. Sampling the
  # full complete-case population before support trimming propagates trimming.
  it<-which(dd==1);ic<-which(dd==0)
  if(point_ok)for(b in seq_len(B)) {
   jj<-c(sample(it,length(it),replace=TRUE),sample(ic,length(ic),replace=TRUE))
   f<-safe_dr(xx[jj,,drop=FALSE],dd[jj],yy[jj,,drop=FALSE],secondary_first=cf$own)
   warns[b]<-f$warnings;solvers[b]<-if(is.null(f$error))f$solver else
    if(grepl('support|rank deficient|preliminary',f$error))'not_attempted_support_or_rank_failure' else
     if(cf$own)'failed_secondary_nlm_then_damped_Newton' else 'failed_damped_Newton'
   if(is.null(f$error)) {mat[b,]<-f$att;bt[b]<-f$trimmed_t;bc[b]<-f$trimmed_c} else fails[b]<-f$error
   if(b%%250L==0L){cat(sprintf('T066 DR bootstrap: %s %s %d/%d.\n',key,pid,b,B));flush.console()}
  } else fails[]<-paste0('point failure: ',point$error)
  for(y in ybatch) {
   st<-ci(mat[,y]);iy<-match(y,ys)
   r<-data.frame(comparison=key,period=pid,outcome=y,label=unname(ylabels[y]),
    estimate=if(point_ok)unname(point$att[y]) else NA_real_,as.data.frame(st),
    candidate_t=sum(pa$D==1),candidate_c=sum(pa$D==0),complete_t=sum(dd==1),complete_c=sum(dd==0),
    treated=if(point_ok)sum(point$D==1) else NA_integer_,comparison_firms=if(point_ok)sum(point$D==0) else NA_integer_,
    trimmed_t=if(point_ok)point$trimmed_t else NA_integer_,trimmed_c=if(point_ok)point$trimmed_c else NA_integer_,
    trim_iterations=if(point_ok)point$iterations else NA_integer_,
    pre_observations=sum(pa$n0[ii,iy]),post_observations=sum(pa$n1[ii,iy]),
    algebraically_redundant_columns=if(point_ok)point$dropped else '',
    status=if(!point_ok)point$error else if(st$valid<.9*B)'unreliable: fewer than 90 percent valid bootstrap draws' else
     if(st$valid<B)'conditional on valid bootstrap draws' else 'all draws valid',bootstrap_draws=B,seed=seed)
   results[[length(results)+1L]]<<-r
   drdraws[[length(drdraws)+1L]]<<-data.frame(comparison=key,period=pid,outcome=y,draw=1:B,estimate=mat[,y],
    trimmed_t=bt,trimmed_c=bc,failure=fails,warnings=warns,solver=solvers)
   use<-rep(FALSE,length(pa$ids));pscore<-rep(NA_real_,length(pa$ids));ww<-pscore
   if(point_ok){use[ii[point$idx]]<-TRUE;pscore[ii[point$idx]]<-point$ps;ww[ii[point$idx]]<-point$w}
   sampleaudit[[length(sampleaudit)+1L]]<<-data.frame(comparison=key,period=pid,outcome=y,firm_id=pa$ids,D=pa$D,
    missing_covariate=rowSums(!is.finite(pa$X))>0,pre_dates=pa$n0[,iy],post_dates=pa$n1[,iy],
    pre_outcome=pa$y0[,iy],post_outcome=pa$y1[,iy],
    complete_case=eligible,retained=use,
    trimming_ps=replace(rep(NA_real_,length(pa$ids)),ii,if(point_ok)point$preliminary_ps else rep(NA_real_,length(ii))),
    final_ps=pscore,att_weight=ww)
   for(v in colnames(xx)) {
    xb<-xx[,v];xa<-if(point_ok)xb[point$idx] else numeric();da<-if(point_ok)point$D else numeric()
    balances[[length(balances)+1L]]<<-data.frame(comparison=key,period=pid,outcome=y,variable=v,label=if(is.null(placebo))unname(clabels[v]) else if(v=='rl1')paste('RL1 at',pa$base) else
      if(v=='rl2')paste('RL2 at',pa$base) else if(v=='rl3')paste('RL3 at',pa$base) else
      if(v=='rl1_change')paste('RL1 change ending at',pa$base) else unname(clabels[v]),
     treated=if(point_ok)sum(da==1) else NA_integer_,comparison_firms=if(point_ok)sum(da==0) else NA_integer_,
     mean_t_before=mean(xb[dd==1]),mean_c_before=mean(xb[dd==0]),
     smd_before=weighted_smd(xb,dd,rep(1,length(dd))),
     smd_after_trim=if(point_ok)weighted_smd(xa,da,rep(1,length(da)),sqrt((var(xb[dd==1])+var(xb[dd==0]))/2)) else NA_real_,
     mean_t_weighted=if(point_ok)weighted.mean(xa[da==1],point$w[da==1]) else NA_real_,
     mean_c_weighted=if(point_ok)weighted.mean(xa[da==0],point$w[da==0]) else NA_real_,
     smd_after_weighting=if(point_ok)weighted_smd(xa,da,point$w,sqrt((var(xb[dd==1])+var(xb[dd==0]))/2)) else NA_real_)
   }
  }
  if(point_ok)overlap[[length(overlap)+1L]]<<-data.frame(comparison=key,period=pid,outcome_batch=paste(ybatch,collapse=','),
   firm_id=pa$ids[ii[point$idx]],D=point$D,trimming_ps=point$preliminary_ps[point$idx],ps=point$ps,weight=point$w)
  fitlog[[length(fitlog)+1L]]<<-data.frame(comparison=key,period=pid,outcome_batch=paste(ybatch,collapse=','),
   warnings=point$warnings,point_error=if(point_ok)'' else point$error,bootstrap_failed=sum(nzchar(fails)),
   point_solver=if(point_ok)point$solver else 'failed',secondary_first=cf$own)
 }
 cat(sprintf('T066 DR: %s %s complete.\n',key,pid));flush.console()
}
for(key in names(config))for(period in c('main','average'))run_dr(key,period)
# Earlier date is pre, end-2019 is post; all of these contrasts precede policy.
for(key in names(config))for(dt in dates[dates<as.Date('2019-12-31')])run_dr(key,'placebo',as.Date(dt,origin='1970-01-01'))
res<-bind(results);bal<-bind(balances);ov<-bind(overlap)
csv(res,'drdid');csv(bal,'balance');csv(ov,'overlap',FALSE);csv(bind(drdraws),'drdid_draws',FALSE)
csv(bind(sampleaudit),'sample_audit',FALSE);csv(bind(fitlog),'dr_fit_log')
pla<-bind(placeboaudit);csv(pla,'placebo_audit');csv(bind(strataaudit),'ownership_strata')
# The approved non-ownership main/average rows must retain their original bytes.
baseline_connection<-rawConnection(baseline[['outputs/tables/t066_drdid.csv']])
oldlines<-readLines(baseline_connection,warn=FALSE);close(baseline_connection)
oldkeep<-grepl('^"(A_control|all_control|A_control_no_suppliers|all_control_no_suppliers)","(main|average)"',oldlines)
newlines<-readLines(staged[[which(vapply(staged,function(s)s[['target']]=='outputs/tables/t066_drdid.csv',logical(1)))]][['path']])
newkeep<-grepl('^"(A_control|all_control|A_control_no_suppliers|all_control_no_suppliers)","(main|average)"',newlines)
stopifnot(sum(oldkeep)==32L,identical(oldlines[oldkeep],newlines[newkeep]))
csv(data.frame(check='all control comparisons main/average DR rows byte-identical',rows=32L,pass=TRUE),'preserved_rows')
# Fixed-layout PDF pages, one comparison/period each, avoid unreadable facets.
pdf_start('overlap',7.5,5)
for(key in names(config))for(period in c('main','average')) {
 z<-ov[ov$comparison==key&ov$period==period,]
 par(mar=c(4.5,4.5,4,1),oma=c(2.5,0,0,0),mfrow=c(1,1))
 if(!nrow(z)){plot.new();title(main=paste(config[[key]]$label,period,if(config[[key]]$own)'(A shares only)' else ''));text(.5,.5,'Estimator unavailable; see fit log');next}
 # Ownership MI may have a distinct complete-case sample: plot its scores too.
 batches<-unique(z$outcome_batch);cols<-c('#12617A','#C46B2A','#5B6E2A','#99548B')
 hs<-list();labs<-character()
 for(batch in batches)for(tr in 1:0) {
  zz<-z[z$outcome_batch==batch&z$D==tr,];h<-hist(zz$ps,breaks=seq(0,1,.05),plot=FALSE)
  hs[[length(hs)+1L]]<-h$counts/sum(h$counts)
  labs<-c(labs,paste(if(tr==1)'Treated' else 'Comparison',batch))
 }
 ylim<-c(0,max(unlist(hs)) * 1.3)
 plot(NA,xlim=c(0,1),ylim=ylim,xlab='IPT propensity score in retained sample',ylab='Share of firms (0.05-wide bins)',
  main=paste(config[[key]]$label,period,if(config[[key]]$own)'(A shares only)' else ''))
 for(j in seq_along(hs))lines(seq(.025,.975,.05),hs[[j]],type='s',lwd=2,col=cols[j])
 legend('topright',legend=labs,col=cols[seq_along(hs)],lty=1,lwd=2,bty='n',cex=.78)
 mtext('Preliminary logit selects [0.01,0.99]; final IPT scores can differ. Counts in results table.',side=1,outer=TRUE,line=.8,cex=.8)
}
invisible(dev.off())
pdf_start('pretrends',8,7)
for(key in names(config)) {
 ys<-if(config[[key]]$own)names(ylabels) else names(ylabels)[1:4]
 panels<-if(length(ys)==4L)c(2,2) else c(3,2)
 par(mfrow=panels,mar=c(4.2,4.5,3.8,1),oma=c(3,0,3,0),cex=.85)
 for(y in ys) {
  zz<-res[res$comparison==key&grepl('^pre_',res$period)&res$outcome==y,];zz<-zz[order(zz$period),]
  lim<-range(c(0,zz$estimate,zz$ci_low,zz$ci_high),finite=TRUE);if(diff(lim)==0)lim<-c(-.1,.1)
  mechanical<-pla$mechanical[match(paste(key,zz$period,y),paste(pla$comparison,pla$period,pla$outcome))]
  plot(seq_len(nrow(zz)),ifelse(mechanical,NA,zz$estimate),ylim=lim,xlim=c(.7,6.3),xaxt='n',pch=19,col='#12617A',
   xlab='Earlier pre-policy date',ylab='Change contrast to 2019H2',main=unname(ylabels[y]))
  mtext(sprintf('Valid draws %d-%d / 999',min(zz$valid),max(zz$valid)),side=3,line=.3,cex=.7)
  axis(1,at=1:6,labels=c('16H2','17H1','17H2','18H1','18H2','19H1'),cex.axis=.8)
  segments(which(!mechanical),zz$ci_low[!mechanical],which(!mechanical),zz$ci_high[!mechanical],col='#12617A');abline(h=0,lty=2,col='gray50')
 }
 for(j in seq_len(prod(panels)-length(ys)))plot.new()
 mtext(paste0(config[[key]]$label,if(config[[key]]$own)' (A shares only)' else ''),side=3,outer=TRUE,line=1,cex=1.2)
 mtext(c('Pointwise 95% CIs; <90% valid draws is unreliable.', 'Earlier-base covariates; mechanical rows omitted (see audit).'),side=1,outer=TRUE,line=c(1.1,2.1),cex=.8)
}
invisible(dev.off())
tex('drdid',c('Comparison / period','Y','ATT','95\\% CI','T / C','Trim T / C','Valid'),
 vapply(seq_len(nrow(res[res$period%in%c('main','average'),])),function(i) {
 z<-res[res$period%in%c('main','average'),][i,]
 texrow(c(esc(paste(z$comparison,z$period)),z$outcome,fmt(z$estimate),paste0('[',fmt(z$ci_low),', ',fmt(z$ci_high),']'),
 paste(z$treated,z$comparison_firms,sep=' / '),paste(z$trimmed_t,z$trimmed_c,sep=' / '),paste(z$valid,B,sep='/')))
 },character(1)),'llrrrrr',
 'Improved panel DR DiD; IPT logistic scores and odds-weighted comparison outcome regression. Percentile CIs condition on valid stratified firm draws; below 90 percent valid is unreliable. Main: 2019H2 to 2021H2. Average: observed date means over 2017H1--2019H2 and 2020H2--2022H2. ATT targets retained overlap firms. Private/SOE uses A shares only (HK has 4 SOEs, below 10); no cash/STD or HK dummy. It contrasts two regulated groups.')
balm<-bal[bal$period%in%c('main','average')&bal$outcome=='Y1',]
tex('balance',c('Comparison / period','Covariate','SMD before','SMD weighted'),
 vapply(seq_len(nrow(balm)),function(i)texrow(c(esc(paste(balm$comparison[i],balm$period[i])),paste0('\\raggedright ',balm$label[i]),fmt(balm$smd_before[i]),
 fmt(balm$smd_after_weighting[i]))),character(1)),'lp{4.8cm}rr',
 'Unweighted pooled within-group SD is held fixed within each before/after pair; CSV includes trimming-only balance and separate MI-outcome samples.')

# Private-minus-SOE difference-in-bunching, all original period observations.
set.seed(seed);pv<-config$private_SOE$t;sv<-config$private_SOE$c
Wp<-weights(sort(unique(pv$firm_id)));Ws<-weights(sort(unique(sv$firm_id)))
pm<-change(pv,Wp);sm<-change(sv,Ws);db<-pm$delta-sm$delta
bunch<-bind(lapply(c('private','SOE','private_minus_SOE'),function(group) {
 v<-switch(group,private=pm$delta,SOE=sm$delta,private_minus_SOE=db)
 data.frame(group=group,estimate=v[1],as.data.frame(ci(v[-1])),
  pre_firms=if(group=='SOE')sm$pre$firms else pm$pre$firms,post_firms=if(group=='SOE')sm$post$firms else pm$post$firms,
  pre_n=if(group=='SOE')sm$pre$n else pm$pre$n,post_n=if(group=='SOE')sm$post$n else pm$post$n,
  pre_window_obs=if(group=='SOE')sm$pre$window_obs else pm$pre$window_obs,
  post_window_obs=if(group=='SOE')sm$post$window_obs else pm$post$window_obs,
  pre_comparison_firms=if(group=='private_minus_SOE')sm$pre$firms else NA_integer_,
  post_comparison_firms=if(group=='private_minus_SOE')sm$post$firms else NA_integer_,
  pre_comparison_n=if(group=='private_minus_SOE')sm$pre$n else NA_integer_,
  post_comparison_n=if(group=='private_minus_SOE')sm$post$n else NA_integer_,
  b_pre=if(group=='SOE')sm$pre$v[1] else if(group=='private')pm$pre$v[1] else NA_real_,
  b_post=if(group=='SOE')sm$post$v[1] else if(group=='private')pm$post$v[1] else NA_real_,
  pre_comparison_window_obs=if(group=='private_minus_SOE')sm$pre$window_obs else NA_integer_,
  post_comparison_window_obs=if(group=='private_minus_SOE')sm$post$window_obs else NA_integer_,
  low_support=if(group=='SOE')sm$pre$low_support||sm$post$low_support else
   if(group=='private')pm$pre$low_support||pm$post$low_support else
    pm$pre$low_support||pm$post$low_support||sm$pre$low_support||sm$post$low_support,
  bootstrap_draws=B,seed=seed)
}))
csv(bunch,'ownership_bunching')
csv(data.frame(draw=1:B,private_pre=pm$pre$v[-1],private_post=pm$post$v[-1],SOE_pre=sm$pre$v[-1],SOE_post=sm$post$v[-1],
 private_delta=pm$delta[-1],SOE_delta=sm$delta[-1],private_minus_SOE=db[-1]),'ownership_bunching_draws',FALSE)
cat('T066 ownership bunching complete.\n');flush.console()

# Revised T025 risk set, outcome models and missing-pre-mean indicator convention.
# The five existing outcomes and dose_pre specification are unchanged.
hys<-c('rl1','rl2','mi_share','rl2_gap','jv_ta')
hp<-all_panel[!is.na(all_panel$sample_main)&all_panel$sample_main&!is.na(all_panel$dose_pre),]
hp<-hp[order(hp$firm_id,hp$date),];hids<-sort(unique(hp$firm_id));hdates<-format(dates,'%Y-%m-%d')
stopifnot(length(hids)==124L,!anyDuplicated(hp[c('firm_id','date')]))
prices<-read(price_copy,colClasses=c(firm_id='character'));stopifnot(!anyDuplicated(prices$firm_id))
hf<-do.call(rbind,lapply(hids,function(id) {
 z<-hp[hp$firm_id==id,];pre<-z[z$date<='2019-12-31',];b<-z[z$date=='2019-12-31',]
 pr<-prices[match(id,prices$firm_id),]
 stopifnot(length(unique(z$market))==1L,length(unique(z$dose_pre))==1L,nrow(b)<=1L)
 r<-data.frame(firm_id=id,dose_pre=z$dose_pre[1],market=z$market[1],Z3=sum(!is.na(pre$ta))/7,
  pre_log_ta=mean(pre$log_ta,na.rm=TRUE),close=pr$close,price_date=pr$price_date,currency=pr$currency,
  price_error=pr$error,Z1=if(is.finite(pr$close)&&pr$close>0)log(pr$close) else NA_real_,
  Z2=if(nrow(b)&&is.finite(b$ni))as.numeric(b$ni<0) else NA_real_)
 for(y in hys)r[[paste0('pre_',y)]]<-mean(pre[[y]],na.rm=TRUE)
 r
}))
# Center log prices within listing market (with market FE in selection); currencies
# are not converted. This is an intercept reparameterization, not new information.
for(market in unique(hf$market)) {
 j<-hf$market==market&is.finite(hf$Z1);hf$Z1[j]<-hf$Z1[j]-mean(hf$Z1[j])
}
stopifnot(all(hf$currency[is.finite(hf$Z1)&hf$market=='A']=='RMB'),
 all(hf$currency[is.finite(hf$Z1)&hf$market=='HK']=='HKD'))
csv(hf,'selection_firm_inputs')
hg<-expand.grid(firm_id=hids,date=hdates,stringsAsFactors=FALSE);ix<-match(paste(hg$firm_id,hg$date),paste(hp$firm_id,hp$date))
for(y in hys)hg[[y]]<-hp[[y]][ix]
hg<-merge(hg,hf,by='firm_id',sort=FALSE);hg<-hg[order(hg$firm_id,hg$date),];hg$post<-as.integer(hg$date>='2020-12-31')
stopifnot(nrow(hg)==124L*13L)
hprepare<-function(g,y) {
 g$s<-as.integer(is.finite(g[[y]]));g$pre_y<-g[[paste0('pre_',y)]]
 g$pre_mean_missing<-as.integer(!is.finite(g$pre_y));g$pre_y[g$pre_mean_missing==1L]<-0
 stopifnot(all(is.finite(g$pre_log_ta)),!anyNA(g[c('dose_pre','market','Z3')]))
 g
}
specs<-list(Z1='Z1',Z2='Z2',Z3='Z3',joint=c('Z1','Z2','Z3'))
zlabels<-c(Z1='Log closing price (within market)',Z2='Net loss in FY2019',Z3='Pre-policy reporting frequency')
hfirst<-function(g,vars) {
 dp<-g[g$post==1L,];ok<-rowSums(!is.finite(as.matrix(dp[vars])))==0;dp<-dp[ok,]
 terms<-c('dose_pre','pre_y','pre_log_ta','market','factor(date)',vars)
 if(any(dp$pre_mean_missing!=0L))terms<-c(terms,'pre_mean_missing')
 warns<-character()
 m<-withCallingHandlers(glm(reformulate(terms,'s'),family=binomial('probit'),data=dp,na.action=na.fail,
  control=glm.control(maxit=100)),warning=function(w){warns<<-c(warns,conditionMessage(w));invokeRestart('muffleWarning')})
 # Match T025's cluster sandwich, retaining only estimable columns.
 kk<-names(coef(m))[is.finite(coef(m))];X<-model.matrix(m)[,kk,drop=FALSE]
 U<-rowsum(X*as.vector(residuals(m,type='working')*m$weights),dp$firm_id,reorder=FALSE)
 bread<-summary(m)$cov.unscaled;G<-nrow(U);N<-nrow(dp);K<-m$rank
 V<-(G/(G-1))*((N-1)/(N-K))*bread%*%crossprod(U)%*%bread
 b<-coef(m)[vars];vv<-V[intersect(vars,rownames(V)),intersect(vars,colnames(V)),drop=FALSE]
 wald<-tryCatch(if(all(is.finite(b))&&nrow(vv)==length(vars))as.numeric(t(b)%*%solve(vv,b)) else NA_real_,error=function(e)NA_real_)
 se<-rep(NA_real_,length(vars));names(se)<-vars
 se[intersect(vars,rownames(V))]<-sqrt(pmax(0,diag(V)[intersect(vars,rownames(V))]))
 # A pre-mean indicator with no selected outcome is structural separation, as T025.
 structural_sep<-any(dp$pre_mean_missing==1L)&&!any(dp$pre_mean_missing==1L&dp$s==1L)
 valid<-isTRUE(m$converged)&&all(is.finite(b))&&all(is.finite(se))&&all(se>0)&&
  is.finite(wald)&&wald>=0&&!structural_sep
 nll<-glm(s~1,data=dp,family=binomial('probit'))
 list(m=m,dp=dp,b=b,se=se,wald=wald,valid=valid,structural_sep=structural_sep,
  pseudo_R2=1-as.numeric(logLik(m))/as.numeric(logLik(nll)),warnings=paste(unique(warns),collapse='; '))
}
firstrows<-list();firstfits<-list();chosen<-list()
for(y in hys) {
 g<-hprepare(hg,y);fits<-list()
 for(sn in names(specs)) {
  fit<-hfirst(g,specs[[sn]]);fits[[sn]]<-fit;pr<-fitted(fit$m)
  for(z in specs[[sn]])firstrows[[length(firstrows)+1L]]<-data.frame(outcome=y,specification=sn,candidate=z,label=unname(zlabels[z]),
   coefficient=unname(fit$b[z]),cluster_se=unname(fit$se[z]),cluster_z=unname(fit$b[z]/fit$se[z]),
   joint_Wald_chisq=fit$wald,joint_Wald_df=length(specs[[sn]]),
   joint_Wald_p=if(is.finite(fit$wald))pchisq(fit$wald,length(specs[[sn]]),lower.tail=FALSE) else NA_real_,
   pseudo_R2=fit$pseudo_R2,share_probability_005_095=mean(tapply(pr,fit$dp$firm_id,mean)>.05&
    tapply(pr,fit$dp$firm_id,mean)<.95),
   risk_rows=nrow(fit$dp),risk_firms=nf(fit$dp$firm_id),observed_post=sum(fit$dp$s),
   excluded_missing_candidate_firms=length(setdiff(hids,fit$dp$firm_id)),
   converged=fit$m$converged,structural_separation=fit$structural_sep,
   statistically_admissible=fit$valid,usable_strength=fit$valid&&fit$wald>=10,
   exclusion_validated=FALSE,warnings=fit$warnings)
 }
 firstfits[[y]]<-fits
 admissible<-names(fits)[vapply(fits,function(f)f$valid,logical(1))]
 selected<-if(length(admissible))admissible[which.max(vapply(fits[admissible],`[[`,numeric(1),'wald'))] else NA_character_
 chosen[[y]]<-data.frame(outcome=y,specification=selected,
  usable_strength=if(is.na(selected))FALSE else fits[[selected]]$wald>=10,
  status=if(is.na(selected))'no statistically admissible first stage' else if(fits[[selected]]$wald<10)
   'strongest admissible specification remains weak (Wald < 10); requested sensitivity only; exclusion assumed' else
   'strongest admissible specification meets Wald >= 10; exclusion assumed')
}
fs<-bind(firstrows);ch<-bind(chosen);fs$selected<-!is.na(ch$specification[match(fs$outcome,ch$outcome)])&
 fs$specification==ch$specification[match(fs$outcome,ch$outcome)]
csv(fs,'first_stage');csv(ch,'selected_first_stage')
tex('first_stage',c('Outcome / spec','Candidate','Coef.','Cluster z','Wald','Pseudo R2','Overlap','N firms'),
 vapply(seq_len(nrow(fs)),function(i)texrow(c(esc(paste(fs$outcome[i],fs$specification[i])),fs$candidate[i],
 fmt(fs$coefficient[i]),fmt(fs$cluster_z[i]),fmt(fs$joint_Wald_chisq[i]),fmt(fs$pseudo_R2[i]),
 fmt(fs$share_probability_005_095[i]),fs$risk_firms[i])),character(1)),'llrrrrrr',
 'Pooled post probit with T025 covariates and date effects; firm-clustered z and Wald tests on excluded candidates only. Wald at least 10 is the specified strength rule. Overlap is the share of firms whose mean predicted post reporting probability is strictly between 0.05 and 0.95 (equal firm weights, across the five post dates). Missing candidate firms are excluded and counted; no imputation. Strength does not establish the exclusion restriction.')

# Extract ONLY T025 outcome model function, avoiding writes by that script.
oldcode<-parse('code/09_selection.R');hit<-vapply(oldcode,function(e)is.call(e)&&identical(e[[1]],as.name('<-'))&&
 identical(e[[2]],as.name('main_model')),logical(1));stopifnot(sum(hit)==1L);eval(oldcode[[which(hit)]])
hfit<-function(g,y,sn,do_mass=FALSE) {
 vars<-specs[[sn]];good<-rowSums(!is.finite(as.matrix(g[vars])))==0;g<-g[good,]
 f<-hfirst(g,vars)
 if(!isTRUE(f$m$converged)||f$structural_sep)stop('nonconverged or structurally separated probit')
 eta<-predict(f$m,newdata=f$dp,type='link');g$lambda<-0
 g$lambda[g$post==1L]<-exp(dnorm(eta,log=TRUE)-pnorm(eta,log.p=TRUE))
 if(any(!is.finite(g$lambda)))stop('nonfinite inverse Mills ratio')
 m<-main_model(g,y,heckman=TRUE)
 bb<-unname(coef(m)['dose_pre:post']);if(!is.finite(bb))stop('nonfinite second-stage coefficient')
 out<-list(coefficient=bb,lambda_coefficient=unname(coef(m)['lambda']),N=nobs(m),
  firms=nf(g$firm_id[fixest::obs(m)]),used_key=paste(g$firm_id[fixest::obs(m)],g$date[fixest::obs(m)]),risk_firms=nf(g$firm_id),wald=f$wald,dp=f$dp,p=pnorm(eta),warnings=f$warnings)
 if(do_mass) {
  # Distributional selection is defined by RL1 reporting, not by another outcome.
  # Apply the selected RL1 probit to post observations, floor probabilities at .05.
  # Pre histogram is unweighted; weights do not change the fit/bin definitions.
  gg<-g;gg$rl1<-gg[[y]];gg$date<-as.Date(gg$date);gg$ipw<-1
  post<-which(gg$post==1L);gg$ipw[post]<-1/pmax(.05,pnorm(eta))
  weighted_b<-function(use,ipw=gg$ipw) {
   x<-gg$rl1;av<-use&is.finite(x);edges<-round(seq(.4,1,.01),10);mid<-(head(edges,-1)+tail(edges,-1))/2
   ix<-findInterval(x,edges,rightmost.closed=TRUE);inside<-av&!is.na(ix)&ix>0L&ix<length(edges)
   h<-vapply(seq_along(mid),function(j)sum(ipw[inside&ix==j]),numeric(1))
   X<-cbind(1,poly(mid,5));window<-mid>=.66-1e-12&mid<.70-1e-12
   pred<-drop(X%*%qr.coef(qr(X[!window,,drop=FALSE]),h[!window]))
   val<-if(all(is.finite(pred[window])&pred[window]>0))(sum(h[window])-sum(pred[window]))/mean(pred[window]) else NA_real_
   c(b=val,n=sum(av),firms=nf(gg$firm_id[av]),window_n=sum(av&x>=.66&x<.70),
    weighted_n=sum(ipw[av]),effective_n=sum(ipw[av])^2/sum(ipw[av]^2))
  }
  masks<-period_masks(gg);pre<-weighted_b(masks$pre);postb<-weighted_b(masks$post)
  # Same gg rows, binning and fit, with ipw identically one. No new draws or
  # changed failure rules; the weighted and unweighted estimates remain paired.
  pre_unweighted<-weighted_b(masks$pre,rep(1,nrow(gg)))
  post_unweighted<-weighted_b(masks$post,rep(1,nrow(gg)))
  stopifnot(identical(pre,pre_unweighted),
   identical(unname(postb[c('n','firms','window_n')]),unname(post_unweighted[c('n','firms','window_n')])))
  out$mass_unweighted<-c(b_pre=unname(pre_unweighted['b']),b_post=unname(post_unweighted['b']),
   delta_b=unname(post_unweighted['b']-pre_unweighted['b']))
  out$mass<-c(b_pre=unname(pre['b']),b_post=unname(postb['b']),delta_b=unname(postb['b']-pre['b']),
   pre_n=unname(pre['n']),post_n=unname(postb['n']),pre_firms=unname(pre['firms']),post_firms=unname(postb['firms']),
   pre_window_n=unname(pre['window_n']),post_window_n=unname(postb['window_n']),
   post_weighted_n=unname(postb['weighted_n']),post_effective_n=unname(postb['effective_n']),
   risk_probability_floored=sum(out$p<.05),observed_probability_floored=sum(out$p<.05&f$dp$s==1),
   max_weight=max(gg$ipw[gg$post==1L&is.finite(gg$rl1)]))
 }
 out
}
# One joint whole-firm draw for all outcomes; distinct copies receive distinct FE IDs.
set.seed(seed);drawidx<-replicate(BH,sample.int(length(hids),length(hids),replace=TRUE))
byfirm<-lapply(hids,function(id)which(hg$firm_id==id));hpoints<-list();hdraws<-list();hrows<-list();selectionaudit<-list()
for(y in hys) {
 sn<-ch$specification[ch$outcome==y]
 if(is.na(sn)) {
  hrows[[length(hrows)+1L]]<-data.frame(outcome=y,specification=NA_character_,estimate=NA_real_,
   se=NA_real_,ci_low=NA_real_,ci_high=NA_real_,valid=0L,failed=BH,N=NA_integer_,firms=NA_integer_,
   status='not estimated: no statistically admissible first stage')
  next
 }
 point<-hfit(hprepare(hg,y),y,sn,do_mass=y=='rl1');hpoints[[y]]<-point
 # Baseline on exactly the revised complete-candidate sample provides explicit
 # attribution of sample change, without silently comparing different samples.
 gd<-hprepare(hg,y);good<-rowSums(!is.finite(as.matrix(gd[specs[[sn]]])))==0;gd<-gd[good,]
 base<-main_model(gd,y);old<-read('outputs/tables/t025_selection.csv')
 old<-old[old$outcome==y&old$method=='baseline',]
 used<-gd[fixest::obs(base),c('firm_id','date')]
 # Second stage must use exactly the outcome rows in this complete-candidate risk set.
 stopifnot(nrow(used)==point$N,setequal(paste(used$firm_id,used$date),point$used_key))
 selectionaudit[[length(selectionaudit)+1L]]<-data.frame(outcome=y,original_risk_firms=124L,revised_risk_firms=point$risk_firms,
  second_stage_N=point$N,second_stage_firms=point$firms,baseline_same_sample=unname(coef(base)['dose_pre:post']),
  T025_original_baseline=old$coefficient,first_stage_Wald=point$wald)
 estimates<-matrix(NA_real_,BH,4,dimnames=list(NULL,c('coefficient','b_pre','b_post','delta_b')))
 if(y=='rl1')unweighted_estimates<-matrix(NA_real_,BH,3L,dimnames=list(NULL,c('b_pre','b_post','delta_b')))
 fails<-warns<-rep('',BH)
 for(b in seq_len(BH)) {
  jj<-drawidx[,b];bootg<-hg[unlist(byfirm[jj],use.names=FALSE),];bootg$firm_id<-rep(paste0('boot_',seq_along(jj)),each=13L)
  ww<-character()
  fit<-tryCatch(withCallingHandlers(hfit(hprepare(bootg,y),y,sn,do_mass=y=='rl1'),
   warning=function(w){ww<<-c(ww,conditionMessage(w));invokeRestart('muffleWarning')}),error=function(e)list(error=conditionMessage(e)))
  if(is.null(fit$error)) {
   estimates[b,'coefficient']<-fit$coefficient;if(y=='rl1')estimates[b,c('b_pre','b_post','delta_b')]<-fit$mass[c('b_pre','b_post','delta_b')]
   if(y=='rl1')unweighted_estimates[b,]<-fit$mass_unweighted
   warns[b]<-paste(unique(c(ww,fit$warnings)),collapse='; ')
  } else fails[b]<-fit$error
 }
 hdraws[[length(hdraws)+1L]]<-data.frame(outcome=y,specification=sn,draw=1:BH,as.data.frame(estimates),failure=fails,warnings=warns)
 st<-ci(estimates[,'coefficient'])
 hrows[[length(hrows)+1L]]<-data.frame(outcome=y,specification=sn,estimate=point$coefficient,as.data.frame(st),
  lambda_coefficient=point$lambda_coefficient,N=point$N,firms=point$firms,risk_firms=point$risk_firms,
  first_stage_Wald=point$wald,usable_strength=point$wald>=10,baseline_same_sample=unname(coef(base)['dose_pre:post']),
  status=if(st$valid<.9*BH)'unreliable: fewer than 90 percent valid bootstrap draws' else
   if(st$valid<BH)'conditional on valid bootstrap draws' else 'all draws valid',bootstrap_draws=BH,seed=seed)
 cat(sprintf('T066 Heckman: %s, selected %s, Wald %.4f, valid %d/%d.\n',y,sn,point$wald,st$valid,BH));flush.console()
}
heck<-bind(hrows);hb<-bind(hdraws);csv(heck,'heckman');csv(hb,'heckman_draws',FALSE);csv(bind(selectionaudit),'selection_audit')
if('rl1'%in%names(hpoints)) {
 p<-hpoints$rl1;bb<-hb[hb$outcome=='rl1',]
 ipb<-bind(lapply(c('b_pre','b_post','delta_b'),function(metric)data.frame(metric=metric,estimate=unname(p$mass[metric]),
  as.data.frame(ci(bb[[metric]])),specification=ch$specification[ch$outcome=='rl1'],
  as.data.frame(as.list(p$mass[setdiff(names(p$mass),c('b_pre','b_post','delta_b'))])),bootstrap_draws=BH,seed=seed)))
} else ipb<-data.frame(metric=c('b_pre','b_post','delta_b'),estimate=NA_real_,status='not estimated: no admissible RL1 selection equation')
csv(ipb,'reporting_weighted_bunching')
stopifnot('rl1'%in%names(hpoints),p$risk_firms==124L)
metrics<-c('b_pre','b_post','delta_b')
weighted_estimates<-as.matrix(bb[metrics])
paired_difference<-weighted_estimates-unweighted_estimates
stopifnot(identical(unname(is.finite(weighted_estimates)),unname(is.finite(unweighted_estimates))),
 all(paired_difference[,'b_pre']==0,na.rm=TRUE))
riskdraws<-bind(lapply(metrics,function(metric)data.frame(draw=seq_len(BH),metric=metric,
 weighted=weighted_estimates[,metric],unweighted=unweighted_estimates[,metric],
 weighted_minus_unweighted=paired_difference[,metric],failure=bb$failure,warnings=bb$warnings)))
csv(riskdraws,'reporting_same_sample_draws',FALSE)
same_sample<-bind(lapply(c('weighted','unweighted','weighted_minus_unweighted'),function(method)
 bind(lapply(metrics,function(metric) {
  values<-switch(method,weighted=weighted_estimates[,metric],unweighted=unweighted_estimates[,metric],
   weighted_minus_unweighted=paired_difference[,metric])
  point<-switch(method,weighted=p$mass[metric],unweighted=p$mass_unweighted[metric],
   weighted_minus_unweighted=p$mass[metric]-p$mass_unweighted[metric])
  data.frame(method=method,metric=metric,estimate=unname(point),as.data.frame(ci(values)),
   specification=ch$specification[ch$outcome=='rl1'],risk_firms=p$risk_firms,
   pre_n=p$mass['pre_n'],post_n=p$mass['post_n'],pre_firms=p$mass['pre_firms'],post_firms=p$mass['post_firms'],
   bootstrap_draws=BH,seed=seed,filter='sample_main & nonmissing dose_pre; observed RL1; T061 period masks',
   status='paired whole-firm bootstrap; weak selection equation; exclusion unverified',row.names=NULL)
 }))))
csv(same_sample,'reporting_same_sample_bunching',FALSE)
# Verify the new weighted rows exactly reproduce the unchanged published rows.
stopifnot(identical(unname(as.matrix(same_sample[same_sample$method=='weighted',c('estimate','se','ci_low','ci_high','valid','failed')])),
 unname(as.matrix(ipb[c('estimate','se','ci_low','ci_high','valid','failed')]))))
tex('heckman',c('Outcome','Z','Dose x post','95\\% CI','Wald $\\chi^2$','\\shortstack{Usable\\\\$\\chi^2\\geq10$}','N / firms','Valid'),
 vapply(seq_len(nrow(heck)),function(i) {
  z<-heck[i,];texrow(c(esc(z$outcome),esc(ifelse(is.na(z$specification),'unavailable',z$specification)),fmt(z$estimate),
  paste0('[',fmt(z$ci_low),', ',fmt(z$ci_high),']'),fmt(z$first_stage_Wald),if(z$usable_strength)'Yes' else 'No',
  paste(z$N,z$firms,sep=' / '),paste(z$valid,BH,sep=' / ')))
 },character(1)),'llrrrrrr',
 paste0('None of the candidate specifications reaches the usable threshold of Wald $\\chi^2 \\geq 10$; maximum across t066-first-stage is ',fmt(max(fs$joint_Wald_chisq,na.rm=TRUE)),'. T025 outcome models retain firm/date effects and dose by post, adding the post inverse Mills ratio. Both stages refit in 499 whole-firm bootstrap draws. The largest raw candidate-only Wald selects the admissible specification separately by outcome, as the disclosed interpretation of strongest; df differs across single/joint candidates, so this is not a comparable-significance ranking. Prices and losses may directly reflect leverage/distress, so the exclusion restriction is assumed and these are sensitivity estimates. Dose is dose\\_pre: the firm-constant mean number of breached red lines over 2017H1--2019H2, requiring at least three nonmissing dates (T025).'),
 caption=paste0('Revised Heckman sensitivity: no first stage reaches Wald $\\chi^2 \\geq 10$ (maximum ',fmt(max(fs$joint_Wald_chisq,na.rm=TRUE)),').'))

# Generated interpretations: every reported number is drawn from saved tables.
desc<-function(z)paste0(fmt(z$estimate),' [',fmt(z$ci_low),', ',fmt(z$ci_high),']')
mainr<-res[res$comparison=='A_control'&res$period=='main',]
mainpre<-merge(res[res$comparison=='A_control'&grepl('^pre_',res$period),],pla,
 by=c('comparison','period','outcome'))
countable<-mainpre$count_in_intervals&is.finite(mainpre$ci_low)&is.finite(mainpre$ci_high)
supplier_placebo<-res[grepl('no_suppliers',res$comparison)&res$period=='main'&res$outcome=='Y4',]
ownr<-res[res$comparison=='private_SOE'&res$period=='main',]
interp<-c(
 paste0('A-share developer versus control main-period ATT estimates are ',paste(paste(mainr$outcome,desc(mainr)),collapse='; '),
 '. All four main A-share intervals include zero, providing no precise evidence of a differential change. In the same comparison, ',
 sum(countable&(mainpre$ci_low>0|mainpre$ci_high<0),na.rm=TRUE),
 ' of ',sum(countable),' pointwise nonmechanical pre-policy intervals exclude zero; these correlated, unadjusted intervals cannot establish parallel trends. Identification requires conditional parallel trends of untreated changes, no anticipation, stable outcome definitions, no relevant spillovers and common support; DR consistency additionally requires a correct logistic PS or linear comparison-change model. The balance table diagnoses covariate comparability, not these assumptions. All-developer, supplier-exclusion and period-average estimates and pre-policy date contrasts are reported whatever their signs. Supplier-exclusion Y4 main estimates are ',paste(paste(supplier_placebo$comparison,desc(supplier_placebo)),collapse='; '),'; both intervals exclude zero, so the no-precise-evidence statement applies only to the main A-share comparison. Placebo covariates are at each earlier base; a two-year RL1 change ending at that base is used only when its lag date exists, otherwise omitted. The placebo audit flags algebraic identities and excludes them from the interval count; missing intervals are also excluded. Baseline RL1 is allowed as a pre-change covariate, but no covariate includes the subsequent 2019 endpoint or the dependent change. Advance ratios inherit T061 zero coding when components are not reported, which may affect balancing. The survivor-selected controls, concurrent sector shocks and absence of Hong Kong controls limit interpretation. Preliminary-logit support trimming targets the retained overlap population; IPT scores are then refitted and can differ from trimming scores.'),
 paste0('Private-minus-SOE A-share-only main-period ATT estimates are ',paste(paste(ownr$outcome,desc(ownr)),collapse='; '),
 '; the distributional change contrast is ',desc(bunch[bunch$group=='private_minus_SOE',]),
 '. Valid main-period bootstrap draws by outcome are ',paste(paste(ownr$outcome,ownr$valid,sep=': '),collapse='; '),
 ' of 999. Main and average-period inference remains conditional on valid draws; rows below 90 percent valid are explicitly unreliable. Cash/short-term debt was removed; the market dummy was replaced by exact market stratification. HK has only four SOEs and fails the ten-per-group rule, so only the A-share stratum is reported (weight one). Package secondary nlm is tried before damped Newton in ownership draws; draw-level solvers and failures are saved. Both groups were regulated. A larger private response would be consistent with tighter credit access making the policy bind harder; this exposure contrast does not identify a treated-versus-untreated effect or prove disguised debt. Literal panel soe coding excludes ',
 sum(is.na(owners$soe)),' unclassified firms. Smooth counterfactual density and comparable counterfactual changes are required for the bunching contrast; small threshold-window counts and invalid bootstrap fits are reported.'),
 paste0('Selection specifications chosen by the disclosed largest-raw-Wald interpretation of strongest are ',paste(paste(ch$outcome,ch$specification,sep=': '),collapse='; '),
 '. The largest candidate Wald across all specifications/outcomes is ',fmt(max(fs$joint_Wald_chisq,na.rm=TRUE)),
 '. The selected stages reach Wald >= 10 for ',sum(ch$usable_strength),' of ',nrow(ch),' outcomes. The requested second-stage estimates are still reported if the strongest admissible model is weak, without calling its first stage usable. All single-candidate and all-candidate joint probits, clustered diagnostics and missing candidate exclusions are reported. Z1 can predict reporting through price-related suspension/delisting, but prices may also reflect distress and directly predict leverage changes. Z2 can predict reporting through losses and financial failure, but losses mechanically affect equity and leverage. Z3 measures reporting capacity/history, but it can proxy persistent distress or disclosure quality associated with leverage. None has a verified exclusion restriction. Raw Wald ranks single/joint specifications with different df and must not be read as a significance ranking. The strongest statistically admissible first stage therefore provides conditional sensitivity estimates, not validated selection identification. On the same 124-firm risk set, unweighted b_pre, b_post and delta b are ',paste(vapply(metrics,function(metric)desc(same_sample[same_sample$method=='unweighted'&same_sample$metric==metric,]),character(1)),collapse='; '),', respectively. Reporting-IPW b_pre, b_post and delta b are ',paste(vapply(metrics,function(metric)desc(same_sample[same_sample$method=='weighted'&same_sample$metric==metric,]),character(1)),collapse='; '),'. Weighted minus unweighted b_pre, b_post and delta b are ',paste(vapply(metrics,function(metric)desc(same_sample[same_sample$method=='weighted_minus_unweighted'&same_sample$metric==metric,]),character(1)),collapse='; '),' (paired percentile CIs from the same 499 firm draws; t066_reporting_same_sample_bunching.csv, method and metric identify each row; t066_reporting_same_sample_draws.csv provides paired draws). These same-sample differences alone measure the effect of weighting; the pre difference is zero because pre weights equal one. The 136-firm main-sample unweighted developer delta is ',fmt(bd$delta[1]),' (t066_reproduction.csv, developer_delta_b); comparing it with the 124-firm weighted delta mixes sample composition and weighting and cannot isolate a weighting effect. Both weighted level/change intervals exclude zero, indicating a positive descriptive post-policy rise under the fitted reporting weights, not a validated correction for nonrandom attrition. The paired b_post/delta-b difference intervals ',if(all(same_sample$ci_low[same_sample$method=='weighted_minus_unweighted'&same_sample$metric%in%c('b_post','delta_b')]<=0 & same_sample$ci_high[same_sample$method=='weighted_minus_unweighted'&same_sample$metric%in%c('b_post','delta_b')]>=0))'include zero, so the same-sample comparison provides no precise evidence that weighting changes the estimated rise.' else 'are reported without implying a validated attrition correction.', ' The RL1 first-stage Wald is ',fmt(hpoints$rl1$wald),', below 10. Reporting-weighted b uses the selected RL1 probit, probabilities floored at 0.05, the unchanged degree-5 histogram fit, and a joint two-stage firm bootstrap. Missing prices/losses are never replaced and can change the risk set; selection_audit gives baseline coefficients on that same sample. The finance fallback is not estimated by this card.')
)
csv(data.frame(step=1:3,interpretation=interp,number_map='t066_number_map.csv'),'interpretation')
# Full numeric cell map, using row and available explicit keys as exact filters.
mapping<-list()
for(name in names(tables)) {
 z<-tables[[name]];nn<-names(z)[vapply(z,is.numeric,logical(1))]
 keys<-intersect(c('comparison','period','outcome','specification','candidate','variable','group','metric','firm_id','step','check'),names(z))
 filters<-vapply(seq_len(nrow(z)),function(i)paste(c(paste0('row=',i),vapply(keys,function(k)paste0(k,'=',z[[k]][i]),character(1))),collapse='; '),character(1))
 for(n in nn)mapping[[length(mapping)+1L]]<-data.frame(file=paste0('outputs/tables/t066_',name,'.csv'),row=seq_len(nrow(z)),
  filter=filters,column=n,value=z[[n]])
}
csv(bind(mapping),'number_map',FALSE)

# Compare every numeric/logical cell, including draws and firm audits, against
# the immutable pre-rework snapshot. Join by substantive keys, never row order.
# number_map duplicates cells; verification contains changing guard hashes.
# Both are audit metadata, excluded from the numerical result-cell comparison.
cellchanges<-list();filechecks<-list()
for(path in names(baseline)[grepl('[.]csv$',names(baseline))&
 !grepl('t066_(number_map|verification)[.]csv$',names(baseline))]) {
 j<-match(path,vapply(staged,`[[`,character(1),'target'));stopifnot(!is.na(j))
 con<-textConnection(rawToChar(baseline[[path]]));old<-read.csv(con,na.strings=c('','NA','--'));close(con)
 new<-read(staged[[j]][['path']])
 keys<-intersect(c('comparison','period','outcome','outcome_batch','specification','candidate',
  'variable','group','metric','firm_id','draw','step','check','kind','file'),intersect(names(old),names(new)))
 if(!length(keys)) {old$.row<-seq_len(nrow(old));new$.row<-seq_len(nrow(new));keys<-'.row'}
 keyfun<-function(z)vapply(seq_len(nrow(z)),function(i)
  paste(vapply(keys,function(k)paste0(k,'=',z[[k]][i]),character(1)),collapse='; '),character(1))
 ko<-keyfun(old);kn<-keyfun(new);stopifnot(!anyDuplicated(ko),!anyDuplicated(kn))
 kk<-union(ko,kn);io<-match(kk,ko);inew<-match(kk,kn)
 numericcols<-union(names(old)[vapply(old,function(v)is.numeric(v)||is.logical(v),logical(1))],
  names(new)[vapply(new,function(v)is.numeric(v)||is.logical(v),logical(1))])
 numericcols<-setdiff(numericcols,c(keys,'.row'))
 nchanged<-0L
 for(n in numericcols) {
  a<-if(n%in%names(old))old[[n]][io] else rep(NA_real_,length(kk))
  b<-if(n%in%names(new))new[[n]][inew] else rep(NA_real_,length(kk))
  changed<-(is.na(a)!=is.na(b))|(!is.na(a)&!is.na(b)&a!=b)
  if(any(changed)) {
   cellchanges[[length(cellchanges)+1L]]<-data.frame(file=path,filter=kk[changed],column=n,
    old=as.character(a[changed]),new=as.character(b[changed]),
    change=ifelse(is.na(io[changed]),'added row',ifelse(is.na(inew[changed]),'removed row','changed cell')))
   nchanged<-nchanged+sum(changed)
  }
 }
 filechecks[[length(filechecks)+1L]]<-data.frame(file=path,old_rows=nrow(old),new_rows=nrow(new),
  changed_numeric_or_logical_cells=nchanged,
  byte_identical=identical(baseline[[path]],readBin(staged[[j]][['path']],'raw',n=file.info(staged[[j]][['path']])$size)))
}
csv(bind(cellchanges),'rework1_old_new',FALSE);csv(bind(filechecks),'rework1_change_summary',FALSE)
# The all-market ownership bunching contrast and its full joint bootstrap stay
# unchanged; both are independent of the revised A-share DR comparison.
for(path in c('outputs/tables/t066_ownership_bunching.csv','outputs/tables/t066_ownership_bunching_draws.csv')) {
 j<-match(path,vapply(staged,`[[`,character(1),'target'))
 stopifnot(identical(baseline[[path]],readBin(staged[[j]][['path']],'raw',n=file.info(staged[[j]][['path']])$size)))
}

# Every other pre-existing T066 output stays byte-identical to Rework 1.
rework2_checks<-rework2_baseline[!rework2_baseline$allowed_change,]
rework2_checks$generated_sha256<-vapply(rework2_checks$file,function(path) {
 j<-match(path,vapply(staged,`[[`,character(1),'target'))
 unname(tools::sha256sum(if(is.na(j))path else staged[[j]][['path']]))
},character(1))
rework2_checks$byte_identical<-rework2_checks$sha256==rework2_checks$generated_sha256
stopifnot(all(rework2_checks$byte_identical))
csv(rework2_checks,'rework2_preserved_outputs',FALSE)
cat(sprintf('T066 Rework 2 preservation PASS: %d/%d other existing T066 outputs byte-identical.\n',
 nrow(rework2_checks),nrow(rework2_checks)))

# Coverage + guards; all numerical outputs are staged until every gate passes.
stopifnot(nrow(res)==(4L*4L+5L)*8L, # five comparisons, main/average + six placebos
 nrow(fs)==length(hys)*6L,all(table(res$comparison)==c(A_control=32L,A_control_no_suppliers=32L,
  all_control=32L,all_control_no_suppliers=32L,private_SOE=40L)),
 all(vapply(tables[c('drdid','balance')],nrow,integer(1))>0L),max_package_error<1e-8,
 identical(input_hash,tools::sha256sum(inputs)),identical(protected_hash,tools::sha256sum(protected)),
 identical(raw_hash,tools::sha256sum(rawfiles)))
csv(data.frame(kind=c(rep('input',length(inputs)),rep('existing_output',length(protected)),rep('raw',length(rawfiles))),
 file=c(inputs,protected,rawfiles),sha256=c(unname(input_hash),unname(protected_hash),unname(raw_hash)),unchanged=TRUE),'verification',FALSE)
textout(c('PASS: reproduction asserts 136-firm main-sample developer delta 4.02 and developer-control delta 4.59.',
 sprintf('DIAGNOSTIC: A-share-only private/SOE main valid draws %s / 999; MI/JV Heckman valid draws %s / 499; inference remains unreliable below 90 percent.',
 paste(ownr$valid,collapse=','),paste(heck$valid[heck$outcome%in%c('mi_share','jv_ta')],collapse=',')),
 sprintf('PASS: DRDID %s; exact-ATT simulation %.12f (expected 1.5); maximum package/formula difference %.12g.',
 as.character(packageVersion('DRDID')),sim$att[1],max_package_error),
 sprintf('PASS: %d DR rows; 999 firm draws per row; %d first-stage candidate rows; 499 two-stage firm draws per available outcome.',nrow(res),nrow(fs)),
 sprintf('PASS: %d inputs, %d existing outputs, %d existing raw files unchanged (new price copy and appended manifest entry authorized).',
 length(inputs),length(protected),length(rawfiles)),
 sprintf('PASS: Rework 2 same-risk-set weighted/unweighted/difference rows %d; paired draws %d; %d other existing T066 outputs byte-identical.',nrow(same_sample),nrow(riskdraws),nrow(rework2_checks)),
 'All point failures, bootstrap failures, complete-case exclusions, support trimming, mean-period observed dates and balance saved.',
 'Package is used for all point outcomes; ownership bootstrap tries package secondary nlm before damped Newton. All successful IPT refits pass the package moment gate; multi-outcome IPT/WLS score agrees within 1e-8.',
 'Repeat-run byte equality is checked for every staged output under identical verification context.'),'validation','txt')
targets<-vapply(staged,`[[`,character(1),'target');stopifnot(!anyDuplicated(targets))
vtarget<-'outputs/tables/t066_verification.csv';vpath<-staged[[match(vtarget,targets)]][['path']]
same_context<-file.exists(vtarget)&&identical(unname(tools::sha256sum(vpath)),unname(tools::sha256sum(vtarget)))
if(all(file.exists(targets))&&same_context) {
 same<-vapply(staged,function(s)identical(unname(tools::sha256sum(s['path'])),unname(tools::sha256sum(s['target']))),logical(1))
 if(!all(same))stop('STOP: repeat-run bytes differ: ',paste(targets[!same],collapse=', '))
 cat(sprintf('T066 repeat-run PASS: %d/%d outputs byte-identical.\n',sum(same),length(same)))
}
for(s in staged)stopifnot(file.copy(s['path'],s['target'],overwrite=TRUE))
unlink(vapply(staged,`[[`,character(1),'path'))
cat(sprintf('T066 guards PASS: %d inputs; %d existing outputs; %d raw files unchanged.\n',length(inputs),length(protected),length(rawfiles)))
cat(sprintf('T066 coverage PASS: %d DR outcome rows; %d first-stage rows; package maximum error %.12g.\n',nrow(res),nrow(fs),max_package_error))
cat(sprintf('T066 complete: %d files; seed=%d; firm bootstrap=%d; selection bootstrap=%d.\n',length(staged),seed,B,BH))
