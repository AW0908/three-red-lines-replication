# T040: descriptive measurement validation and accounting robustness, offline.
# Project-root command: (cd replication && Rscript --vanilla code/13_rl1_validation.R)
set.seed(20261016)
options(digits=17)
B <- 999L
inputs <- c('data/processed/panel_firm_halfyear.csv',
 'data/raw/manual/rl1_validation/published_coded.csv',
 'data/raw/manual/rl1_validation/published_candidates.csv',
 'data/raw/manual/handcollect/rl1_published.csv')
input_hash <- tools::sha256sum(inputs)
protected <- list.files('outputs',recursive=TRUE,full.names=TRUE)
protected <- protected[!dir.exists(protected)&!grepl('^t040_',basename(protected))]
protected_hash <- tools::sha256sum(protected)
p <- read.csv(inputs[1],stringsAsFactors=FALSE,na.strings=c('','NA'))
coded <- read.csv(inputs[2],stringsAsFactors=FALSE,na.strings=c('','NA'))
nf <- function(x)length(unique(x[!is.na(x)]))
stopifnot(!anyDuplicated(p[c('firm_id','date')]),
 !anyDuplicated(coded[c('firm_id','date','ratio')]),
 all(coded$ratio %in% c('rl1','rl2','rl3')),all(is.finite(coded$published)),
 all(is.finite(coded$pdf_page)&coded$pdf_page>=1),
 all(file.exists(file.path('..',coded$file))))
d <- p[!is.na(p$sample_main)&p$sample_main,]
d <- d[order(d$firm_id,d$date),]
firms <- sort(unique(d$firm_id)); G <- length(firms)
# Identical full-history weights, grid and degree-five fit as T023/T029.
boot <- replicate(B,tabulate(sample.int(G,G,replace=TRUE),nbins=G))
edges <- round(seq(.4,1,.01),10); mid <- (head(edges,-1)+tail(edges,-1))/2
mass <- mid>=.66&mid<.70
X <- cbind(1,poly(mid,degree=5)); qr_fit <- qr(X[!mass,,drop=FALSE])
mass_fit <- function(x,id) {
 ix <- findInterval(x,edges,rightmost.closed=TRUE)
 inside <- is.finite(x)&!is.na(ix)&ix>0L&ix<length(edges)
 counts <- matrix(0,G,length(mid))
 for(j in which(inside))counts[match(id[j],firms),ix[j]] <- counts[match(id[j],firms),ix[j]]+1
 obs <- colSums(counts); db <- t(counts)%*%boot
 pred <- drop(X%*%qr.coef(qr_fit,obs[!mass]))
 pb <- X%*%qr.coef(qr_fit,db[!mass,,drop=FALSE])
 valid <- all(is.finite(pred[mass]))&&all(pred[mass]>0)
 good <- colSums(!is.finite(pb[mass,,drop=FALSE])|pb[mass,,drop=FALSE]<=0)==0
 est <- if(valid)(sum(obs[mass])-sum(pred[mass]))/mean(pred[mass]) else NA_real_
 draws <- ifelse(good,(colSums(db[mass,,drop=FALSE])-colSums(pb[mass,,drop=FALSE]))/
  colMeans(pb[mass,,drop=FALSE]),NA_real_)
 list(estimate=est,draws=draws,n=sum(is.finite(x)),n_firms=nf(id[is.finite(x)]),n_in_range=sum(inside))
}
mean_fit <- function(y,id) {
 ok <- is.finite(y); a <- b <- numeric(G)
 for(j in which(ok)) {k<-match(id[j],firms);a[k]<-a[k]+y[j];b[k]<-b[k]+1}
 list(estimate=if(any(ok))mean(y[ok]) else NA_real_,
  draws=drop(crossprod(a,boot)/crossprod(b,boot)),n=sum(ok),n_firms=nf(id[ok]),n_in_range=NA_integer_)
}
post <- d$date>='2020-12-31'&d$date<='2022-12-31'
N <- d$tl-d$adv; den <- d$ta-d$adv
valid <- is.finite(N)&N>0&is.finite(d$te)&d$te>0
base_off <- ifelse(valid,N/(N+d$te),NA_real_)
j <- match(paste(d$firm_id,'2019-12-31'),paste(d$firm_id,d$date))
cfden <- N+d$te-d$mi+d$mi[j]
base_frozen <- ifelse(valid&is.finite(cfden)&cfden>0,N/cfden,NA_real_)
gate_b <- mass_fit(d$rl1[post],d$firm_id[post])
pair <- post&is.finite(base_off)&is.finite(base_frozen)
gate_D <- mean_fit(as.numeric(base_off[pair]<=.7)-as.numeric(base_frozen[pair]<=.7),d$firm_id[pair])
stopifnot(is.finite(gate_b$estimate),round(gate_b$estimate,2)==3.14,
 is.finite(gate_D$estimate),round(gate_D$estimate,4)==.1146)
cat(sprintf('T040 baseline assertions: T023 b=%.12f; T029 D=%.12f.\n',gate_b$estimate,gate_D$estimate))

# Coded observations merged by exact firm and reporting date; no nearest-date matching.
z <- merge(coded,p[c('firm_id','date','rl1','rl2','rl3','sample_main','perp','perp_missing','ta','tl','adv')],
 by=c('firm_id','date'),all.x=TRUE,sort=TRUE)
z$constructed <- vapply(seq_len(nrow(z)),function(i)z[[z$ratio[i]]][i],numeric(1))
z$error <- z$constructed-z$published
summary_rows <- list()
add <- function(type,ratio,scope,metric,estimate,n,n_firms) {
 summary_rows[[length(summary_rows)+1L]] <<- data.frame(row_type=type,ratio=ratio,scope=scope,
  metric=metric,estimate=estimate,n=n,n_firms=n_firms)
}
for(v in c('rl1','rl2','rl3'))for(scope in c('all','published_rl1_060_080')) {
 if(scope!='all'&&v!='rl1')next
 q <- z[z$ratio==v&is.finite(z$error),]
 if(scope!='all')q<-q[q$published>=.6&q$published<=.8,]
 e <- q$error
 stats <- c(mean=mean(e),median=median(e),MAE=mean(abs(e)),
  share_within_0_5pp=mean(abs(e)<=.005+1e-12),share_within_1pp=mean(abs(e)<=.01+1e-12))
 for(m in names(stats))add('error',v,scope,m,stats[m],nrow(q),nf(q$firm_id))
}
r <- z[z$ratio=='rl1'&is.finite(z$error),]
stopifnot(nf(r$firm_id)>=15L)
for(a in c(TRUE,FALSE))for(b in c(TRUE,FALSE)) {
 use <- (r$constructed<=.7)==a&(r$published<=.7)==b
 add('classification','rl1','all',paste0('constructed_',if(a)'compliant' else 'breach',
 '_published_',if(b)'compliant' else 'breach'),sum(use),nrow(r),nf(r$firm_id))
}
for(v in c('rl1','rl2','rl3')) {
 q<-z[z$ratio==v,]
 add('coverage',v,'all','coded_values',nrow(q),nrow(q),nf(q$firm_id))
 add('coverage',v,'all','unavailable_panel_ratio',sum(!is.finite(q$constructed)),nrow(q),nf(q$firm_id))
}
# Raw panel can store zero when perpetual item is missing: never treat that as observed.
observed <- !is.na(d$perp_missing)&!d$perp_missing&is.finite(d$perp)
rl1_perp <- ifelse(observed&is.finite(den)&den>0,(N+d$perp)/den,NA_real_)
check <- observed&is.finite(rl1_perp)&is.finite(d$rl1)
for(scope in c('all_main_dates','post')) {
 use <- check & if(scope=='post')post else TRUE
 changed <- (d$rl1[use]<=.7)!=(rl1_perp[use]<=.7)
 add('perpetual','rl1',scope,'side_changes',sum(changed),sum(use),nf(d$firm_id[use]))
 add('perpetual','rl1',scope,'side_change_share',mean(changed),sum(use),nf(d$firm_id[use]))
 add('perpetual','rl1',scope,'observed_nonzero_perpetuals',sum(d$perp[use]!=0),sum(use),nf(d$firm_id[use]))
}
validation <- do.call(rbind,summary_rows)
# Only RL1 threshold classification disagreements; exact document wording retained.
dis <- r[(r$constructed<=.7)!=(r$published<=.7),]
dis$reason <- vapply(seq_len(nrow(dis)),function(i) {
 w<-dis$definition_wording[i]; reasons<-character()
 if(!is.na(w)&&grepl('perpetual|永续',w,ignore.case=TRUE))reasons<-c(reasons,'document states perpetual treatment')
 if(!is.na(w)&&grepl('value-added|待转',w,ignore.case=TRUE))reasons<-c(reasons,'document includes VAT in advance receipts')
 if(!length(reasons))'not established from cited definition; no causal attribution' else
  paste(paste(reasons,collapse='; '),'(documented convention, not verified error decomposition)')
},character(1))
# A matched firm must pass at EVERY coded current-date RL1 observation, with panel availability.
rr <- z[z$ratio=='rl1',]
pass <- tapply(is.finite(rr$error)&abs(rr$error)<=.01+1e-12,rr$firm_id,all)
matched <- names(pass)[pass]
# Observed-perpetual sensitivity holds current assets and other items fixed.
# When unavailable use original stored RL1 / T029 counterfactual, as authorized.
var_full <- d$rl1
var_full[observed] <- rl1_perp[observed]
var_off <- base_off; var_off[observed] <- ifelse(valid[observed],rl1_perp[observed],NA_real_)
pden <- den-d$mi+d$mi[j]
var_frozen <- base_frozen
var_frozen[observed] <- ifelse(valid[observed]&is.finite(pden[observed])&pden[observed]>0,
 (N[observed]+d$perp[observed])/pden[observed],NA_real_)

ci <- function(x) {
 ok<-is.finite(x); q<-if(any(ok))quantile(x[ok],c(.025,.975),names=FALSE) else c(NA,NA)
 c(ci_low=q[1],ci_high=q[2],bootstrap_valid=sum(ok),bootstrap_failed=sum(!ok))
}
rob <- list()
add_rob <- function(scenario,metric,s) {
 cinfo<-ci(s$draws)
 if(!is.finite(s$estimate))cinfo[c('ci_low','ci_high')]<-NA_real_
 rob[[length(rob)+1L]] <<- data.frame(scenario=scenario,metric=metric,estimate=s$estimate,
 n=s$n,n_firms=s$n_firms,n_in_range=s$n_in_range,as.list(cinfo),bootstrap_draws=B,
 inference=if(!is.finite(s$estimate))'invalid_point' else if(cinfo['bootstrap_valid']<.9*B)
 'unreliable_below_90pct' else 'pointwise_firm_bootstrap',row.names=NULL)
}
for(scenario in c('baseline','perpetual','matched_firms')) {
 use<-post
 if(scenario=='matched_firms') {
  use<-use&d$firm_id %in% matched
  # Uniform resamples within the restricted firm universe, retaining histories.
  firms<-sort(intersect(unique(d$firm_id),matched));G<-length(firms)
  if(!G)stop('STOP: no matched firms; cannot fit matched-sample robustness.')
  set.seed(20261016);boot<-replicate(B,tabulate(sample.int(G,G,replace=TRUE),nbins=G))
 }
 full<-if(scenario=='perpetual')var_full else d$rl1
 off<-if(scenario=='perpetual')var_off else base_off
 frozen<-if(scenario=='perpetual')var_frozen else base_frozen
 paired<-use&is.finite(off)&is.finite(frozen)
 a<-mass_fit(off[paired],d$firm_id[paired]);b<-mass_fit(frozen[paired],d$firm_id[paired])
 add_rob(scenario,'T023_b',mass_fit(full[use],d$firm_id[use]))
 add_rob(scenario,'T029_paired_official_b',a)
 add_rob(scenario,'T029_paired_frozen_b',b)
 contrast<-a;contrast$estimate<-a$estimate-b$estimate;contrast$draws<-a$draws-b$draws
 add_rob(scenario,'T029_b_drop',contrast)
 add_rob(scenario,'T029_D',mean_fit(as.numeric(off[paired]<=.7)-as.numeric(frozen[paired]<=.7),d$firm_id[paired]))
}
rob <- do.call(rbind,rob)
# All numerical CSV/TeX displays generated from estimates, never hand copied.
write_csv <- function(x,name)write.csv(x,paste0('outputs/tables/t040_',name,'.csv'),row.names=FALSE,na='')
write_csv(validation,'validation');write_csv(dis,'disagreements');write_csv(rob,'robustness')
write_csv(z,'matched_observations')
fmt<-function(x)ifelse(is.finite(x),sprintf('%.4f',x),'--')
esc<-function(x)gsub('_','\\_',x,fixed=TRUE)
tex <- function(rows,file,header,align,note,per_page=18L) {
 out<-character();chunks<-split(rows,ceiling(seq_along(rows)/per_page))
 for(k in seq_along(chunks))out<-c(out,'\\begin{table}[!htbp]\\centering\\scriptsize',
 paste0('\\begin{tabular}{',align,'}'),'\\toprule',paste0(header,' \\\\'),'\\midrule',chunks[[k]],
 '\\bottomrule','\\end{tabular}',paste0('\\par\\smallskip\\parbox{0.95\\linewidth}{\\footnotesize ',note,'}'),'\\end{table}','')
 writeLines(out,paste0('outputs/tables/t040_',file,'.tex'))
}
vrows<-vapply(seq_len(nrow(validation)),function(i){x<-validation[i,];paste0(paste(
 gsub('_',' ',paste(x$ratio,x$scope,x$metric),fixed=TRUE),x$n,x$n_firms,fmt(x$estimate),sep=' & '),' \\\\')},character(1))
tex(vrows,'validation','Ratio, scope, statistic & N & Firms & Value','p{0.61\\linewidth}rrr',
 'Errors are constructed minus published, in ratio units; 0.005 and 0.01 denote 0.5 and 1 percentage point. For RL3 these are absolute ratio tolerances, not percentage points. Classification compliance includes 0.70. For error statistics and classification rows, N is the available comparison-pair count. For coverage rows, N is the coded-value count, including observations without an available panel counterpart (RL2: 96 coded, 85 pairs; RL3: 64 coded, 59 pairs). For perpetual rows, N is the observed-perpetual pair count. Classification values are counts. Current reporting dates in 2020--2021 only; documentary coverage is selected, not representative.')
# The same four classification counts also appear as a literal 2 x 2 TeX panel.
cc <- function(a,b)sum((r$constructed<=.7)==a&(r$published<=.7)==b)
cat(paste(c('\\begin{table}[!htbp]\\centering\\small',
 '\\begin{tabular}{lrr}\\toprule',
 'Constructed RL1 & Published $\\leq 0.70$ & Published $>0.70$ \\\\',
 '\\midrule',
 sprintf('$\\leq 0.70$ & %d & %d \\\\',cc(TRUE,TRUE),cc(TRUE,FALSE)),
 sprintf('$>0.70$ & %d & %d \\\\',cc(FALSE,TRUE),cc(FALSE,FALSE)),
 '\\bottomrule\\end{tabular}\\end{table}'),collapse='\n'),
 file='outputs/tables/t040_validation.tex',append=TRUE)
rrows<-vapply(seq_len(nrow(rob)),function(i){x<-rob[i,];paste0(paste(esc(x$scenario),esc(x$metric),x$n,x$n_firms,
 fmt(x$estimate),paste0('[',fmt(x$ci_low),', ',fmt(x$ci_high),']'),x$bootstrap_valid,sep=' & '),' \\\\')},character(1))
tex(rrows,'robustness','Sample & Statistic & N & Firms & Estimate & 95\\% CI & Valid','llrrrrr',
 'Post: 2020H2--2022H2. Pointwise percentile intervals, 999 whole-firm draws, seed 20261016. Degree five, 0.01 bins on [0.40,1.00], exclude [0.66,0.70). Perpetual RL1 adds observed perpetuals to non-advance liabilities, holding assets fixed; missing perpetuals use the original definition. Frozen MI also replaces current MI with end-2019 MI, holding perpetuals at their current values. T029 requires positive original N and equity and positive total denominators; bunching uses paired observations. Matched firms pass within one percentage point at every coded current-date RL1 observation; this is a selected-sample robustness check. Mechanical accounting comparisons, not causal effects or economic leverage. MI may be genuine equity. The all-perpetual adjustment is not an exact reconstruction of every firm convention. Fewer than 90 percent valid draws is unreliable.')

# Label disagreements with a keyed legend to avoid overlapping long firm/date labels.
pdf('outputs/figures/t040_constructed_vs_published.pdf',width=11,height=7,
 useDingbats=FALSE,timestamp=FALSE,title='T040 constructed and firm-published RL1')
layout(matrix(c(1,1,2,3),2,2),widths=c(1.6,1));par(mar=c(5,4.5,3,1))
lim<-range(c(.4,1,r$constructed,r$published),finite=TRUE)
plot(r$published,r$constructed,xlim=lim,ylim=lim,asp=1,pch=16,col='#25657A',
 xlab='Firm-published RL1',ylab='Constructed RL1',main='RL1 measurement validation')
abline(a=0,b=1,col='grey40');abline(v=.7,h=.7,lty=2,col='#B14D36')
if(nrow(dis))points(dis$published,dis$constructed,pch=1,col='#B14D36',cex=1.5)
mtext(sprintf('%d firm-dates, %d firms; reporting dates 2020-2021',nrow(r),nf(r$firm_id)),side=1,line=3.8,cex=.75)
par(mar=c(4,3.5,3,1))
plot(r$published,r$constructed,xlim=c(.685,.725),ylim=c(.685,.725),pch=16,col='#25657A',
 xlab='Published RL1',ylab='',main='Threshold detail',cex.main=.95,cex.axis=.8)
abline(a=0,b=1,col='grey60');abline(v=.7,h=.7,lty=2,col='#B14D36')
if(nrow(dis)) {
 points(dis$published,dis$constructed,pch=21,bg='white',col='#B14D36',cex=1.1)
 text(dis$published,dis$constructed,labels=seq_len(nrow(dis)),
  pos=rep(c(2,4,2,2,4,4),length.out=nrow(dis)),offset=.55,cex=.8,col='#B14D36')
}
par(mar=c(1,0,2,0));plot.new();title('Threshold disagreements',cex.main=.85)
if(nrow(dis))legend('topleft',legend=paste(seq_len(nrow(dis)),dis$firm_id,dis$date),bty='n',cex=.8,xpd=NA)
invisible(dev.off())
# Output results with explicit coverage and interpretation limitations.
near<-validation[validation$row_type=='error'&validation$ratio=='rl1'&validation$scope=='published_rl1_060_080',]
notes<-c('T040: descriptive validation only; no causal policy identification asserted.',
 sprintf('Baseline gates: T023 b %.12f (3.14); T029 D %.12f (0.1146).',gate_b$estimate,gate_D$estimate),
 sprintf('Coded %d ratios from %d firms; RL1 %d pairs, %d firms; classification disagreements %d.',nrow(coded),nf(coded$firm_id),nrow(r),nf(r$firm_id),nrow(dis)),
 sprintf('Near threshold (published [0.60,0.80]): %d observations, %d firms; MAE %.6f; share within 1pp %.4f.',near$n[1],near$n_firms[1],near$estimate[near$metric=='MAE'],near$estimate[near$metric=='share_within_1pp']),
 sprintf('Matched firms require every coded RL1 date to have an available panel ratio and error <=1pp: %d of %d coded RL1 firms; %d in main panel.',length(matched),nf(rr$firm_id),length(intersect(matched,unique(d$firm_id)))),
 paste('Matched firm IDs:',paste(matched,collapse=', ')),
 sprintf('Observed perpetual coverage in main panel: %d/%d rows, %d firms; missing fallback %d rows.',sum(observed),nrow(d),nf(d$firm_id[observed]),sum(!observed)),
 'Perpetual convention: (tl-adv+perp)/(ta-adv), observed items only; missing fallback is original RL1. Frozen denominator: ta-adv-mi+MI_2019; current perpetual stock fixed. No issue-date filter or firm-specific VAT adjustment was authorized.',
 'Do not infer universal regulator equivalence: cited firms use VAT, selected issuance dates and either numerator or denominator perpetual adjustments. Reasons in disagreements are documentary clues, not an error decomposition.',
 sprintf('ASSESSMENT: Near 0.70, approximate measurement agreement is supported (MAE %.3f pp; %.1f%% within 1pp), but exact threshold classification is not validated (%d discordant firm-dates). Selected disclosure coverage cannot establish population validity.',100*near$estimate[near$metric=='MAE'],100*near$estimate[near$metric=='share_within_1pp'],nrow(dis)),
 'Current-date values are used; later comparative restatements not pooled. Full page evidence in published_coded.csv; candidate decisions and conflicts in coding_log.md.',
 'Independent 25-value PDF check completed by the Co-PI: 25/25 correct (seed 20261027; review/T040_copi_pdf_check.csv), as recorded in the card feedback; not repeated in this rework. Stable reporting currency within firm is assumed in frozen MI; MI may be genuine equity.',
 'Smooth counterfactual density outside the exclusion window is assumed; polynomial excess mass and mechanical compliance do not identify evasion or a causal policy effect.')
for(i in seq_len(nrow(rob)))notes<-c(notes,sprintf('RESULT %s %s: %.8f [%.8f, %.8f]; N=%d, firms=%d; valid=%d/%d.',
 rob$scenario[i],rob$metric[i],rob$estimate[i],rob$ci_low[i],rob$ci_high[i],rob$n[i],rob$n_firms[i],rob$bootstrap_valid[i],B))
stopifnot(identical(input_hash,tools::sha256sum(inputs)),identical(protected_hash,tools::sha256sum(protected)))
notes<-c(notes,sprintf('SHA-256 guards passed for %d inputs and %d protected outputs.',length(inputs),length(protected)))
writeLines(notes,'outputs/tables/t040_verification.txt')
cat(paste(tail(notes,16),collapse='\n'),'\n')
cat('T040: wrote validation, disagreements, robustness, matched-observation CSVs; two TeX fragments; scatter PDF; verification text.\n')
