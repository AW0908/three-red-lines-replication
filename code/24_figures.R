# T072. Rendering only; run from replication/: Rscript code/24_figures.R
# Never source complete legacy scripts: their top-level code writes protected outputs.
# The sole estimator below is extracted verbatim as an expression from T029.
options(digits=17)
set.seed(20261016)
stopifnot(file.exists('code/theme_proposal.R'))
source('code/theme_proposal.R')
# T082: external publication copies require explicit, independent opt-ins.
integrate_proposal<-identical(Sys.getenv('MTPA_INTEGRATE_PROPOSAL'),'1')
integrate_slides<-identical(Sys.getenv('MTPA_INTEGRATE_SLIDES'),'1')
if(integrate_proposal)dir.create('../proposal/figures',recursive=TRUE,showWarnings=FALSE)
slide_dir<-if(integrate_slides)'../presentation/slides/figures' else tempfile('t082_slide_check_')
dir.create(slide_dir,recursive=TRUE,showWarnings=FALSE)
if(!integrate_proposal)message('Build mode: proposal copies and wrapper disabled.')
if(!integrate_slides)message('Build mode: slide PDFs checked in temporary storage; publication copies disabled.')
readout<-function(name)read.csv(paste0('outputs/tables/',name,'.csv'),stringsAsFactors=FALSE,na.strings=c('','NA'))
writeout<-function(x,name)write.csv(x,paste0('outputs/tables/t072_',name,'.csv'),row.names=FALSE,na='')
sha<-function(p)unname(tools::sha256sum(p))
protected<-list.files('outputs',recursive=TRUE,full.names=TRUE)
protected<-protected[!dir.exists(protected)&!grepl('^(t072_|f_)',basename(protected))]
inputs<-c(list.files('data',recursive=TRUE,full.names=TRUE),list.files('code',pattern='\\.R$',full.names=TRUE))
inputs<-c(inputs[!dir.exists(inputs)],'../proposal/figures/toc_nef.tex','../proposal/references.bib')
guard_paths<-c(protected,inputs)
before<-tools::sha256sum(guard_paths)
audit<-list(); checks<-list()
check<-function(label,actual,expected) {
 stopifnot(length(actual)==length(expected),all(is.finite(actual)),all(is.finite(expected)))
 err<-max(abs(actual-expected));if(err>1e-9)stop(label,': reconstruction mismatch ',err)
 checks[[length(checks)+1L]]<<-data.frame(check=label,max_absolute_error=err,tolerance=1e-9,pass=TRUE)
}
# A4 with one-inch margins, exactly as proposal/preamble.tex. Figure height caps
# are accounted for as well as width; PDF points are 72/in, TeX pt 72.27/in.
paper_w<-210/25.4-2;paper_h<-297/25.4-2
record<-function(name,src,values,w=6.5,h=4,size=12,width_fraction=1,height_fraction=.35,page=1,slide=FALSE) {
 tmp<-tempfile();write.csv(values,tmp,row.names=FALSE,na='');vhash<-sha(tmp);unlink(tmp)
 scale<-if(slide)1 else min(width_fraction*paper_w/w,height_fraction*paper_h/h)
 audit[[length(audit)+1L]]<<-data.frame(figure=name,page=page,
 source_csv=paste(paste0('replication/outputs/tables/',src,'.csv'),collapse=';'),
 plotted_values_sha256=vhash,pdf_min_font_pt=size,printed_min_font_pt=size*scale,
 width_in_paper_inches=w*scale,height_in_paper_inches=h*scale,
 pdf_width_inches=w,pdf_height_inches=h,kind=if(slide)'slide' else 'paper',
 source_file_sha256=paste(vapply(src,function(s)sha(paste0('outputs/tables/',s,'.csv')),character(1)),collapse=';'))
 if(!slide)stopifnot(size*scale>=9)
}
render<-function(name,draw,w=6.5,h=4,size=12,slide=FALSE) {
 path<-if(slide)file.path(slide_dir,paste0(name,'.pdf')) else paste0('outputs/figures/',name,'.pdf')
 proposal_pdf(path,w,h,size);draw();invisible(dev.off())
 if(!slide&&integrate_proposal)stopifnot(file.copy(path,file.path('../proposal/figures',basename(path)),overwrite=TRUE))
}
# Reconstruct Figure 3: T029's exact read_panel and mass_fit function expressions,
# with the original sample, grid, firm universe, bootstrap seed and ordering.
legacy<-parse('code/11_mechanism.R')
fun_from_legacy<-function(name) {
 hit<-Filter(function(e)is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name(name)),as.list(legacy))
 stopifnot(length(hit)==1L);eval(hit[[1]],envir=.GlobalEnv)
}
nf<-function(x)length(unique(x[!is.na(x)]))
fun_from_legacy('read_panel');fun_from_legacy('mass_fit')
d<-read_panel('data/processed/panel_firm_halfyear.csv')
firms<-sort(unique(d$firm_id));G<-length(firms);B<-999L
boot<-replicate(B,tabulate(sample.int(G,G,replace=TRUE),nbins=G))
edges<-round(seq(.40,1,.01),10);mid<-(head(edges,-1)+tail(edges,-1))/2
spec<-data.frame(degree=5L,left=.04,right=0)
j<-match(paste(d$firm_id,'2019-12-31'),paste(d$firm_id,d$date))
den<-d$N+d$te-d$mi+d$mi[j]
d$frozen<-ifelse(d$valid&is.finite(d$mi)&is.finite(d$mi[j])&is.finite(den)&den>0,d$N/den,NA_real_)
pair<-d$date>=as.Date('2020-12-31')&d$date<=as.Date('2022-12-31')&is.finite(d$official)&is.finite(d$frozen)
bins<-list();saved<-readout('t029_counterfactual_bunching')
for(m in c('official','frozen')) {
 fit<-mass_fit(d[[m]][pair],d$firm_id[pair],spec)
 z<-subset(saved,window=='post'&variant=='all'&scope=='paired'&specification=='main'&metric==m)
 stopifnot(nrow(z)==1)
 check(paste('frozen reconstruction',m,'b,N,G,in-range'),
       c(fit$estimate,fit$n,fit$n_firms,fit$n_in_range),c(z$estimate,z$n,z$n_firms,z$n_in_range))
 check(paste('frozen reconstruction',m,'95% CI'),unname(quantile(fit$draws,c(.025,.975),na.rm=TRUE)),c(z$ci_low,z$ci_high))
 bins[[m]]<-data.frame(series=m,mid=mid,lower=head(edges,-1),upper=tail(edges,-1),
   observed=fit$observed,fitted=fit$predicted,n=fit$n,firms=fit$n_firms,b=fit$estimate)
}
z<-subset(readout('t029_compliance'),window=='post'&date=='pooled'&variant=='all'&metric=='D')
check('frozen reconstruction D,N,G',c(mean((d$official[pair]<=.7)-(d$frozen[pair]<=.7)),sum(pair),nf(d$firm_id[pair])),c(z$estimate,z$n,z$n_firms))
writeout(do.call(rbind,bins),'frozen_bins')
# Subsequent plotting reads persisted bins, not in-memory estimator results.
frozen<-readout('t072_frozen_bins')
frozen_draw<-function(slide=FALSE) {
 a<-subset(frozen,series=='official');b<-subset(frozen,series=='frozen')
 par(cex=1,mar=c(5.5,4.5,.6,.5))
 plot(NA,xlim=c(.4,1),ylim=range(c(0,a$observed,b$observed,a$fitted,b$fitted))*c(1,1.08),
      xlab='Reported RL1 or frozen-MI RL1',ylab='Firm-half-years per bin')
 proposal_window();rect(a$lower,0,a$upper,a$observed,col=proposal_col['primary'],border='white')
 rect(b$lower,0,b$upper,b$observed,col=NA,border=proposal_col['grey'],lwd=1.1)
 lines(a$mid,a$fitted,col=proposal_col['dark'],lwd=1.7)
 lines(b$mid,b$fitted,col=proposal_col['grey'],lty=3,lwd=1.7);proposal_threshold()
 proposal_legend(c('Reported','Frozen MI','Reported fit','Frozen fit'),
   proposal_col[c('primary','grey','dark','grey')],lty=c(NA,NA,1,3),pch=c(15,0,NA,NA),ncol=2,inset=-.46)
}
render('f_frozen_mi',frozen_draw)
record('f_frozen_mi','t072_frozen_bins',frozen,width_fraction=.8,height_fraction=1)
# Main Figure 2. No saved control ratio or confidence interval exists; use the
# expressly approved control-share fallback, with its own, labelled right axis.
bydate<-readout('t041_bunching_by_date');controls<-subset(readout('t063_by_date'),group=='control_all'&date>='2017-06-30')
controls<-controls[match(bydate$date,controls$date),];stopifnot(!anyNA(controls$date))
plotdate<-data.frame(date=bydate$date,developer_ratio=bydate$estimate,ci_low=bydate$ci_low,ci_high=bydate$ci_high,control_share=controls$share_below)
bydate_draw<-function(slide=FALSE) {
 par(cex=1,mar=c(7.2,4.8,.6,4.7));xx<-as.Date(plotdate$date); xr<-range(xx)+c(-90,90)
 plot(xx,plotdate$developer_ratio,type='n',xlim=xr,ylim=c(0,max(plotdate$ci_high)*1.05),xaxt='n',
      xlab='',ylab='Developers: observed / fitted share')
 u<-par('usr');rect(as.Date('2020-08-20'),u[3],as.Date('2021-01-01'),u[4],col=proposal_col['light'],border=NA)
 abline(v=as.Date('2020-08-20'),lty=2,col=proposal_col['dark'],lwd=.8)
 abline(h=1,lty=3,col=proposal_col['primary'])
 lines(xx,plotdate$developer_ratio,col=proposal_col['primary'],lwd=1.7)
 points(xx,plotdate$developer_ratio,pch=16,col=proposal_col['primary'])
 if(!slide)segments(xx,plotdate$ci_low,xx,plotdate$ci_high,col=proposal_col['primary'])
 axis(1,at=xx,labels=proposal_halflabel(plotdate$date),las=2)
 mtext('Reporting date',side=1,line=4.7)
 par(new=TRUE)
 plot(xx,plotdate$control_share,type='b',pch=1,col=proposal_col['grey'],lwd=1.5,
      xlim=xr,ylim=c(0,.25),axes=FALSE,xlab='',ylab='')
 axis(4,at=seq(0,.25,.05),labels=paste0(seq(0,25,5),'%'),col.axis=proposal_col['grey'])
 mtext('Controls: share in window',side=4,line=3.1,las=0)
 proposal_legend(c('Developers (left axis)','Controls (right axis)'),proposal_col[c('primary','grey')],pch=c(16,1),inset=-.47)
}
render('f_by_date',bydate_draw)
record('f_by_date',c('t041_bunching_by_date','t063_by_date'),plotdate,width_fraction=.85,height_fraction=1)
# B1: existing bin-level fit; no reconstruction required.
excess<-subset(readout('t023_excess_mass_bins'),ratio=='rl1'&period=='post'&sample_rule=='main_sample'&threshold==.7&specification=='main')
stopifnot(nrow(excess)==60)
render('f_excess_mass',function(){
 par(cex=1,mar=c(5.1,4.5,.6,.5));plot(NA,xlim=c(.4,1),ylim=range(c(0,excess$observed,excess$counterfactual))*c(1,1.1),
 xlab='Reported RL1',ylab='Firm-half-years per bin');proposal_window()
 rect(excess$lower,0,excess$upper,excess$observed,col=proposal_col['primary'],border='white')
 lines(excess$midpoint,excess$counterfactual,col=proposal_col['dark'],lwd=1.7);proposal_threshold()
 proposal_legend(c('Observed','Counterfactual fit'),proposal_col[c('primary','dark')],lty=c(NA,1),pch=c(15,NA))
})
record('f_excess_mass','t023_excess_mass_bins',excess,width_fraction=.8)
# B2: matched validation pairs, threshold detail inset; documentary IDs in note.
validation<-subset(readout('t040_matched_observations'),ratio=='rl1'&is.finite(error))
vplot<-validation[c('firm_id','date','published','constructed')]
render('f_validation',function(){
 par(cex=1,mar=c(4.6,4.6,.6,.7));lim<-range(c(.4,1,vplot$published,vplot$constructed))
 plot(vplot$published,vplot$constructed,pch=16,col=proposal_col['primary'],xlim=lim,ylim=lim,
 xlab='Firm-published RL1',ylab='Constructed RL1')
 abline(a=0,b=1,col=proposal_col['grey']);abline(v=.7,h=.7,lty=2,col=proposal_col['dark'])
 dis<-(vplot$published<=.7)!=(vplot$constructed<=.7)
 points(vplot$published[dis],vplot$constructed[dis],pch=1,col=proposal_col['blue'],cex=1.6)
 par(fig=c(.59,.94,.23,.65),mar=c(2.1,2.1,.5,.2),bg='white');par(new=TRUE)
 plot(vplot$published,vplot$constructed,pch=16,col=proposal_col['primary'],xlim=c(.685,.725),ylim=c(.685,.725),
      xlab='',ylab='',axes=FALSE)
 axis(1,at=c(.69,.71,.72));axis(2,at=c(.69,.71,.72));box()
 abline(a=0,b=1,col=proposal_col['grey']);abline(v=.7,h=.7,lty=2,col=proposal_col['dark'])
 points(vplot$published[dis],vplot$constructed[dis],pch=1,col=proposal_col['blue'],cex=1.4)
})
record('f_validation','t040_matched_observations',vplot)
# B3: exact histogram operation from T043, applied to saved simulation draws.
sim<-readout('t043_meas_error_draws');simsummary<-readout('t043_meas_error');simbins<-list()
for(scope in unique(sim$scope))for(variant in c('uncentered','centered')) {
 z<-sim[sim$scope==scope&sim$error_variant==variant,];x<-z$b_post[is.finite(z$b_post)]
 s<-simsummary[simsummary$scope==scope&simsummary$error_variant==variant&simsummary$metric=='b_post',]
 check(paste('measurement simulation',scope,variant,'N,mean,percentiles'),
       c(length(x),mean(x),unname(quantile(x,c(.025,.975)))),c(s$valid,s$mean,s$p025,s$p975))
 hh<-hist(x,breaks=25,plot=FALSE)
 simbins[[length(simbins)+1L]]<-data.frame(scope=scope,error_variant=variant,lower=head(hh$breaks,-1),upper=tail(hh$breaks,-1),count=hh$counts,baseline=s$baseline)
}
writeout(do.call(rbind,simbins),'simulation_bins');sb<-readout('t072_simulation_bins')
render('f_measurement_error',function(){
 layout(matrix(1:4,2,2,byrow=TRUE));par(cex=1,mar=c(3.3,3.5,1.5,.6),oma=c(.8,.4,0,0),mgp=c(2,.55,0))
 for(scope in unique(sb$scope))for(variant in c('uncentered','centered')) {
  z<-sb[sb$scope==scope&sb$error_variant==variant,];full<-sb[sb$scope==scope,]
  plot(NA,xlim=range(c(full$lower,full$upper,z$baseline)),ylim=c(0,max(z$count)*1.15),xlab='Simulated excess mass',ylab='Perturbations')
  rect(z$lower,0,z$upper,z$count,col=proposal_col['primary'],border='white');abline(v=z$baseline[1],col=proposal_col['dark'],lty=2)
  proposal_panel_label(paste(if(scope=='all')'All validation pairs' else 'Near threshold',if(variant=='uncentered')'raw' else 'centered',sep=': '))
 }
})
record('f_measurement_error',c('t043_meas_error_draws','t043_meas_error','t072_simulation_bins'),sb)
# B4 and requested slide density comparison: directly saved counts and fits.
density<-subset(readout('t061_density_bins'),threshold==.7&group%in%c('control_A_Sina','developers_all'))
density_estimates<-readout('t061_estimates')
density$denominator<-vapply(seq_len(nrow(density)),function(i){
 q<-density_estimates[density_estimates$group==density$group[i]&density_estimates$threshold==.7,]
 stopifnot(nrow(q)==1);q[[paste0(density$period[i],'_n')]]},numeric(1))
density$share<-density$observed_count/density$denominator
density$fitshare<-density$fitted_counterfactual/density$denominator
density_draw<-function(compare=FALSE) {
 layout(if(compare)matrix(1:2,1,2) else rbind(1:2,c(3,3)),heights=if(compare)1 else c(1,.14))
 par(cex=1,mar=c(if(compare)5.8 else 3.2,4.4,1.4,.6),mgp=c(2.6,.65,0))
 control_density<-subset(density,group=='control_A_Sina')
 control_ylim<-range(c(0,control_density$share,control_density$fitshare))*c(1,1.08)
 for(period in c('pre','post')) {
  z<-density[density$period==period,];if(!compare)z<-subset(z,group=='control_A_Sina')
  plot(NA,xlim=c(.4,1),ylim=if(compare)range(c(0,z$share,z$fitshare))*c(1,1.08) else control_ylim,xlab='',ylab='Share of firm-half-years')
  mtext('Reported RL1',side=1,line=1.7)
  proposal_window();proposal_threshold();proposal_panel_label(if(period=='pre')'2017H1-2019H2' else '2020H2-2022H2')
  for(g in unique(z$group)) {
   a<-z[z$group==g,];cl<-proposal_col[if(g=='developers_all')'primary' else 'grey']
   if(compare)lines(a$mid,a$share,col=cl,lwd=1.6,type='s') else rect(a$mid-.005,0,a$mid+.005,a$share,col=cl,border='white')
   lines(a$mid,a$fitshare,col=if(g=='developers_all')proposal_col['dark'] else cl,lty=3,lwd=1.4)
  }
  if(compare)proposal_legend(c('Developers','Controls','Developer fit','Control fit'),proposal_col[c('primary','grey','dark','grey')],lty=c(1,1,3,3),ncol=2)
 }
 if(!compare) {
  par(mar=rep(0,4));plot.new()
  legend(.5,.5,legend=c('Observed','Fit'),col=proposal_col[c('grey','grey')],
         lty=c(NA,3),pch=c(15,NA),ncol=2,bty='n',xjust=.5,yjust=.5,
         cex=1,seg.len=1.4,x.intersp=.55)
 }
}
render('f_control_density',density_draw,h=3.6)
record('f_control_density',c('t061_density_bins','t061_estimates'),subset(density,group=='control_A_Sina'),h=3.6)
# B5/B6: all 13 dates. A separate short full-width 2016 baseline panel sits above
# a filled 4 x 3 grid of the 12 dates from 2017 onward; no empty final row.
dh<-readout('t063_by_date_histograms')
render('f_distributions_by_date',function(){
 for(g in c('developers_all','control_all')) {
  zz<-dh[dh$group==g,];dates<-sort(unique(zz$date));stopifnot(length(dates)==13)
  layout(rbind(rep(1,4),matrix(2:13,3,4,byrow=TRUE)),heights=c(.8,1,1,1))
  par(cex=1,mar=c(.35,2.6,1.15,.4),oma=c(2.9,2.3,.3,.2),mgp=c(2,.5,0))
  ymax<-max(zz$share_all_finite)*1.2
  for(i in seq_along(dates)) {
   z<-zz[zz$date==dates[i],];isbottom<-i>=10
   par(cex=1,mar=c(if(isbottom)1.5 else .25,2.6,1.1,.4))
   plot(NA,xlim=c(.5,.9),ylim=c(0,ymax),axes=FALSE,xlab='',ylab='')
   proposal_window(.66,.74)
   rect(z$mid-.01,0,z$mid+.01,z$share_all_finite,col=proposal_col['grey'],border=NA)
   proposal_threshold();axis(2,at=c(0,signif(ymax*.7,1)))
   if(isbottom)axis(1,at=c(.5,.7,.9))
   proposal_panel_label(proposal_halflabel(dates[i]))
  }
  mtext('Reported RL1',1,outer=TRUE,line=1.2);mtext('Share of firm-half-years',2,outer=TRUE,line=.7,las=0)
 }
},size=12)
for(i in 1:2)record('f_distributions_by_date','t063_by_date_histograms',subset(dh,group==c('developers_all','control_all')[i]),page=i)
# B7: a single common-unit curve, sorted by common-unit estimate, with a compact
# categorical indicator matrix. CIs receive the same exact scaling as estimates.
grid<-readout('t058_grid');grid<-grid[order(grid$delta_b_in_001_bins,grid$specification_index),]
grid$lo001<-grid$ci_low*grid$bin_width/.01;grid$hi001<-grid$ci_high*grid$bin_width/.01
check('specification curve common units',grid$delta_b*grid$bin_width/.01,grid$delta_b_in_001_bins)
render('f_specification_curve',function(){
 layout(matrix(1:2,2,1),heights=c(.35,.65));par(cex=1,mar=c(.3,8.3,.6,.5),mgp=c(2,.5,0))
 x<-seq_len(nrow(grid));lim<-range(c(0,grid$lo001,grid$hi001),finite=TRUE)
 plot(x,grid$delta_b_in_001_bins,pch=16,cex=.45,xlim=c(.5,72.5),ylim=lim,xaxt='n',xlab='',ylab='')
 segments(x,grid$lo001,x,grid$hi001,col=proposal_col['grey'],lwd=.65);abline(h=0,col=proposal_col['dark'],lty=2)
 points(x,grid$delta_b_in_001_bins,pch=16,cex=.45,col=proposal_col['primary'])
 points(x[grid$baseline],grid$delta_b_in_001_bins[grid$baseline],pch=18,col=proposal_col['dark'])
 mtext('Excess mass change\n(0.01 bins)',2,line=3,las=0)
 choices<-list('Bin width'=sprintf('%.3f',grid$bin_width),
 'Exclusion'=paste0(sprintf('%.2f',grid$exclusion_lower),'-',sprintf('%.2f',grid$exclusion_upper)),
 'Degree'=as.character(grid$degree),'Fit range'=paste0(grid$fit_lower,'-',grid$fit_upper))
 rows<-do.call(rbind,lapply(names(choices),function(n)data.frame(group=n,value=sort(unique(choices[[n]])))))
 par(cex=1,mar=c(3.2,8.3,.15,.5))
 plot(NA,xlim=c(.5,72.5),ylim=c(nrow(rows)+.5,.5),axes=FALSE,xlab='',ylab='')
 for(i in seq_len(nrow(rows))) {
  if(i%%2==0)rect(.5,i-.5,72.5,i+.5,col=adjustcolor(proposal_col['light'],alpha.f=.2),border=NA)
  points(x[choices[[rows$group[i]]]==rows$value[i]],rep(i,sum(choices[[rows$group[i]]]==rows$value[i])),pch=16,cex=.42,col=proposal_col['primary'])
 }
 axis(2,at=seq_len(nrow(rows)),labels=paste(rows$group,rows$value),tick=FALSE,las=1)
 axis(1,at=c(1,24,48,72));mtext('Specifications ordered by estimate',1,line=2)
},size=12)
record('f_specification_curve','t058_grid',grid)
# B8: component medians in a horizontal dot plot. Totals are separate diamonds,
# since medians of components need not sum to the median of the total.
decomp<-subset(readout('t027_decomposition_rl1'),sample=='all_events'&metric%in%c('ibd','other_liabilities','parent_including_perp','mi','total'))
render('f_crossing_decomposition',function(){
 par(cex=1,mar=c(6.5,8,.6,.7),mgp=c(1.6,.65,0));cells<-c('post_crossings','pre_crossings','post_stayers')
 metrics<-c('ibd','other_liabilities','parent_including_perp','mi','total')
 cols<-proposal_col[c('primary','grey','blue','accent','dark')];pch<-c(16,15,17,18,23)
 labs<-vapply(cells,function(cc){z<-subset(decomp,cell==cc&metric=='total');paste0(switch(cc,post_crossings='Post crossings',pre_crossings='Pre crossings',post_stayers='Post stayers'),'\nN = ',z$n_events)},character(1))
 plot(NA,xlim=range(c(0,decomp$median))*c(1.16,1.16),ylim=c(.5,3.5),yaxt='n',xlab='Median contribution to change in log-odds',ylab='')
 abline(v=0,col=proposal_col['grey'],lty=2);axis(2,at=3:1,labels=labs,tick=FALSE)
 for(i in seq_along(metrics)) {
  z<-decomp[match(paste(cells,metrics[i]),paste(decomp$cell,decomp$metric)),]
  points(z$median,3:1+(i-3)*.11,pch=pch[i],col=cols[i],bg=if(i==5)'white' else cols[i],cex=1.1)
 }
 proposal_legend(c('Interest-bearing debt','Other liabilities','Parent equity','Minority interests','Median total'),cols,lty=NA,pch=pch,ncol=2,inset=-.58)
})
record('f_crossing_decomposition','t027_decomposition_rl1',decomp,width_fraction=.8)
# B9 and slide: saved kappa estimates, both panels with their own units.
kappa<-readout('t055_kappa')
kappa_draw<-function() {
 layout(matrix(1:2,1,2));par(cex=1,mar=c(5.1,4.5,1.4,.6),mgp=c(2.6,.65,0))
 for(m in c('b','compliant_share')) {
  z<-subset(kappa,metric==m);plot(NA,xlim=c(0,1),ylim=range(c(0,z$ci_low,z$ci_high),finite=TRUE),
   xlab='Assumed debt-like share',ylab=if(m=='b')'Excess mass' else 'Share compliant')
  abline(h=0,col=proposal_col['grey'],lty=2)
  for(p in c('post','placebo')) {
   a<-subset(z,period==p);a<-a[order(a$kappa),];cl<-proposal_col[if(p=='post')'primary' else 'grey']
   polygon(c(a$kappa,rev(a$kappa)),c(a$ci_low,rev(a$ci_high)),col=adjustcolor(cl,alpha.f=.18),border=NA)
   lines(a$kappa,a$estimate,col=cl,lwd=1.7,lty=if(p=='post')1 else 3)
  }
  proposal_legend(c('Post','Placebo'),proposal_col[c('primary','grey')],lty=c(1,3),inset=-.42)
 }
}
render('f_kappa',kappa_draw,h=3.6);record('f_kappa','t055_kappa',kappa,h=3.6)
# Frozen horizons: requested themed version, even though the proposal retains
# only its table. No new figure is added to the manuscript.
horizons<-subset(readout('t041_frozen_horizons'),type!='post_minus_placebo'&is.finite(estimate))
render('f_frozen_horizons',function(){
 par(cex=1,mar=c(6,4.5,.6,.6),mgp=c(2.5,.65,0));plot(NA,xlim=c(.9,3.1),ylim=range(c(0,horizons$ci_low,horizons$ci_high)),
 xlab='',ylab='Official minus frozen compliance');mtext('Years after anchor',side=1,line=1.6);abline(h=0,col=proposal_col['grey'],lty=2)
 anchors<-c('2019-12-31','2016-12-31','2017-06-30');cl<-proposal_col[c('primary','grey','blue')]
 for(i in 1:3){z<-subset(horizons,anchor==anchors[i]);z<-z[order(z$horizon),];xx<-z$horizon+(i-2)*.025
 lines(xx,z$estimate,col=cl[i],lty=i,type='b',pch=14+i);segments(xx,z$ci_low,xx,z$ci_high,col=cl[i])}
 proposal_legend(c('Post: end-2019','Placebo: end-2016','Placebo: 2017H1'),cl,lty=1:3,pch=15:17,ncol=2,inset=-.42)
});record('f_frozen_horizons','t041_frozen_horizons',horizons)
# Overlap: hist() operation copied from T066, with every retained firm included.
overlap<-readout('t066_overlap');ob<-list()
keys<-c('A_control','all_control','A_control_no_suppliers','all_control_no_suppliers','private_SOE')
for(key in keys)for(period in c('main','average')) {
 z<-overlap[overlap$comparison==key&overlap$period==period,]
 for(batch in unique(z$outcome_batch))for(tr in 1:0) {
  zz<-z[z$outcome_batch==batch&z$D==tr,];hh<-hist(zz$ps,breaks=seq(0,1,.05),plot=FALSE)
  check(paste('overlap histogram counts',key,period,batch,tr),sum(hh$counts),nrow(zz))
  ob[[length(ob)+1L]]<-data.frame(comparison=key,period=period,outcome_batch=batch,D=tr,mid=hh$mids,count=hh$counts,share=hh$counts/sum(hh$counts))
 }
}
writeout(do.call(rbind,ob),'overlap_bins');ob<-readout('t072_overlap_bins')
render('f_overlap',function(){
 for(key in keys)for(period in c('main','average')) {
  z<-ob[ob$comparison==key&ob$period==period,];par(cex=1,mar=c(5.8,4.6,.6,.6))
  plot(NA,xlim=c(0,1),ylim=c(0,max(z$share)*1.12),xlab='Propensity score in retained sample',ylab='Share of firms per bin')
  batches<-unique(z$outcome_batch);labs<-character();cls<-character();lts<-numeric()
  for(j in seq_along(batches))for(tr in 1:0) {
   a<-z[z$outcome_batch==batches[j]&z$D==tr,];cl<-proposal_col[if(tr==1)'primary' else 'grey']
   lines(a$mid,a$share,col=cl,lwd=1.6,lty=j,type='s')
   labs<-c(labs,paste(if(tr==1)'Treated' else 'Comparison',batches[j]));cls<-c(cls,cl);lts<-c(lts,j)
  }
  proposal_legend(labs,cls,lty=lts,ncol=2,inset=-.51)
 }
})
ii<-0L;for(key in keys)for(period in c('main','average')){ii<-ii+1L;record('f_overlap',c('t066_overlap','t072_overlap_bins'),ob[ob$comparison==key&ob$period==period,],page=ii,height_fraction=.33)}
# Pre-policy contrasts: four panels for control comparisons, and a filled final
# row spanning the page for the fifth ownership outcome. No empty sixth facet.
pre<-subset(readout('t066_drdid'),grepl('^pre_',period));pla<-readout('t066_placebo_audit')
pre$mechanical<-pla$mechanical[match(paste(pre$comparison,pre$period,pre$outcome),paste(pla$comparison,pla$period,pla$outcome))]
stopifnot(!anyNA(pre$mechanical));pre$estimate[pre$mechanical]<-NA;pre$ci_low[pre$mechanical]<-NA;pre$ci_high[pre$mechanical]<-NA
render('f_pretrends',function(){
 for(key in keys) {
  ys<-if(key=='private_SOE')paste0('Y',1:5) else paste0('Y',1:4)
  layout(if(length(ys)==5)rbind(c(1,2),c(3,4),c(5,5)) else matrix(1:4,2,2,byrow=TRUE))
  par(cex=1,mar=c(2.1,4.4,1.3,.6),oma=c(2,1.8,0,0),mgp=c(2.5,.55,0))
  for(y in ys) {
   z<-pre[pre$comparison==key&pre$outcome==y,];z<-z[order(z$period),];lim<-range(c(0,z$ci_low,z$ci_high),finite=TRUE)
   if(diff(lim)==0)lim<-c(-.1,.1)
   plot(seq_len(nrow(z)),z$estimate,xlim=c(.7,6.3),ylim=lim,xaxt='n',xlab='',ylab='',pch=16,col=proposal_col['primary'])
   segments(1:nrow(z),z$ci_low,1:nrow(z),z$ci_high,col=proposal_col['primary']);abline(h=0,col=proposal_col['grey'],lty=2)
   axis(1,at=1:6,labels=c('16H2','17H1','17H2','18H1','18H2','19H1'))
   proposal_panel_label(switch(y,Y1='RL1 in [0.66, 0.70)',Y2='RL1 at or below 0.70',Y3='RL1 level',Y4='RL1 in [0.56, 0.60)',Y5='Minority interests / equity'))
  }
  mtext('Earlier pre-policy reporting date',1,outer=TRUE,line=.7)
  mtext('Change contrast to 2019H2',2,outer=TRUE,line=.3,las=0)
 }
},h=5.4,size=12)
for(i in seq_along(keys))record('f_pretrends',c('t066_drdid','t066_placebo_audit'),subset(pre,comparison==keys[i]),page=i,h=5.4,height_fraction=.5)
# Diagram exemption: PRISMA is an unchanged diagram, copied with the f_ prefix.
stopifnot(file.copy('outputs/figures/prisma.pdf','outputs/figures/f_prisma.pdf',overwrite=TRUE))
if(integrate_proposal)stopifnot(file.copy('outputs/figures/f_prisma.pdf','../proposal/figures/f_prisma.pdf',overwrite=TRUE))
prisma_info<-system2('pdfinfo','outputs/figures/f_prisma.pdf',stdout=TRUE)
prisma_dims<-as.numeric(strsplit(trimws(sub(' pts.*','',sub('Page size:','',grep('^Page size:',prisma_info,value=TRUE)))), '[[:space:]]+x[[:space:]]+')[[1]])/72
prisma_scale<-min(.8*paper_w/prisma_dims[1],.35*paper_h/prisma_dims[2])
# Eight points is the integer-rounded font size reported by Poppler; this
# unchanged-diagram exception is measured and disclosed, not asserted >= 9.
audit[[length(audit)+1L]]<-data.frame(figure='f_prisma',page=1,
 source_csv='diagram exemption: outputs/figures/prisma.pdf',
 plotted_values_sha256=sha('outputs/figures/prisma.pdf'),pdf_min_font_pt=8,
 printed_min_font_pt=8*prisma_scale,width_in_paper_inches=prisma_dims[1]*prisma_scale,
 height_in_paper_inches=prisma_dims[2]*prisma_scale,pdf_width_inches=prisma_dims[1],
 pdf_height_inches=prisma_dims[2],kind='unchanged_diagram',source_file_sha256=sha('outputs/figures/prisma.pdf'))
# Figure 1 is a conceptual diagram, not an empirical plot. Render the existing
# TikZ content with the course colours and larger type; the original source is
# preserved. Bibliography is resolved locally, in a hidden box, without Git.
diagram_source<-readLines('../proposal/figures/toc_nef.tex',warn=FALSE)
a<-grep('\\begin{tikzpicture}',diagram_source,fixed=TRUE);b<-grep('\\end{tikzpicture}',diagram_source,fixed=TRUE)
stopifnot(length(a)==1,length(b)==1)
tikz<-diagram_source[a:b]
tikz<-gsub('draw=black,fill=white','draw=courseDark,fill=courseLight',tikz,fixed=TRUE)
tikz<-gsub('\\fontsize{9}{10.5}','\\fontsize{10}{11.5}',tikz,fixed=TRUE)
tikz<-gsub('\\fontsize{8.5}{9.5}','\\fontsize{10}{11.5}',tikz,fixed=TRUE)
tmpdir<-tempfile('t072_diagram_');dir.create(tmpdir)
invisible(file.copy('../proposal/references.bib',file.path(tmpdir,'references.bib')))
writeLines(c('\\documentclass[border=0pt]{standalone}',
 '\\usepackage{fontspec,tikz}',
 '\\usepackage[authoryear,round]{natbib}',
 '\\setmainfont{Times New Roman}',
 '\\usetikzlibrary{arrows.meta,positioning}',
 '\\definecolor{courseDark}{HTML}{3D7A28}',
 '\\definecolor{courseLight}{HTML}{D1DFCE}',
 '\\begin{document}',
 '\\special{pdf:trailerid [<543037324449414752414d><543037324449414752414d>]}',
 tikz,
 '\\setbox0=\\vbox{\\bibliographystyle{plainnat}\\bibliography{references}}',
 '\\end{document}'),file.path(tmpdir,'diagram.tex'))
oldwd<-getwd();epoch_before<-Sys.getenv(c('SOURCE_DATE_EPOCH','FORCE_SOURCE_DATE'),unset=NA)
Sys.setenv(SOURCE_DATE_EPOCH='1794182400',FORCE_SOURCE_DATE='1')
setwd(tmpdir)
runtex<-function(cmd,args){out<-system2(cmd,args,stdout=TRUE,stderr=TRUE);if(!is.null(attr(out,'status')))stop(paste(out,collapse='\n'))}
runtex('xelatex',c('-interaction=nonstopmode','-halt-on-error','diagram.tex'))
runtex('bibtex','diagram')
runtex('xelatex',c('-interaction=nonstopmode','-halt-on-error','diagram.tex'))
runtex('xelatex',c('-interaction=nonstopmode','-halt-on-error','diagram.tex'))
setwd(oldwd)
for(n in names(epoch_before))if(is.na(epoch_before[n]))Sys.unsetenv(n) else do.call(Sys.setenv,setNames(list(epoch_before[n]),n))
stopifnot(file.copy(file.path(tmpdir,'diagram.pdf'),'outputs/figures/f_toc_nef.pdf',overwrite=TRUE))
if(integrate_proposal)stopifnot(file.copy('outputs/figures/f_toc_nef.pdf','../proposal/figures/f_toc_nef.pdf',overwrite=TRUE))
wrapper<-c(diagram_source[seq_len(a-1)],
 '% source: replication/outputs/figures/f_toc_nef.pdf (T072, existing conceptual diagram)',
 '\\includegraphics[width=\\linewidth]{f_toc_nef}',diagram_source[(b+1):length(diagram_source)])
if(integrate_proposal)writeLines(wrapper,'../proposal/figures/f_toc_nef.tex')
unlink(tmpdir,recursive=TRUE)
di<-system2('pdfinfo','outputs/figures/f_toc_nef.pdf',stdout=TRUE)
 dims<-as.numeric(strsplit(trimws(sub(' pts.*','',sub('Page size:','',grep('^Page size:',di,value=TRUE)))), '[[:space:]]+x[[:space:]]+')[[1]])/72
 audit[[length(audit)+1L]]<-data.frame(figure='f_toc_nef',page=1,
 source_csv='conceptual diagram: proposal/figures/toc_nef.tex',
 plotted_values_sha256=sha('../proposal/figures/toc_nef.tex'),pdf_min_font_pt=10,
 printed_min_font_pt=(10/1.00375)*paper_w/dims[1],width_in_paper_inches=paper_w,height_in_paper_inches=dims[2]*paper_w/dims[1],
 pdf_width_inches=dims[1],pdf_height_inches=dims[2],kind='conceptual_diagram',
 source_file_sha256=sha('../proposal/figures/toc_nef.tex'))
# Slides: 10 x 5.6 inches, larger type, same persisted numeric sources.
render('f_by_date',function()bydate_draw(TRUE),w=10,h=5.6,size=18,slide=TRUE)
record('f_by_date',c('t041_bunching_by_date','t063_by_date'),plotdate,w=10,h=5.6,size=18,slide=TRUE)
render('f_frozen_mi',frozen_draw,w=10,h=5.6,size=18,slide=TRUE)
record('f_frozen_mi','t072_frozen_bins',frozen,w=10,h=5.6,size=18,slide=TRUE)
render('f_developer_control_density',function()density_draw(TRUE),w=10,h=5.6,size=18,slide=TRUE)
record('f_developer_control_density',c('t061_density_bins','t061_estimates'),density,w=10,h=5.6,size=18,slide=TRUE)
render('f_kappa',kappa_draw,w=10,h=5.6,size=18,slide=TRUE)
record('f_kappa','t055_kappa',kappa,w=10,h=5.6,size=18,slide=TRUE)
# Requested B5 slide: aggregate saved date-bin counts for the two named windows.
# The post window excludes 2020H2, so aggregate only its four saved date bins.
slidehist<-subset(dh,group=='developers_all'&((date>='2017-06-30'&date<='2019-12-31')|(date>='2021-06-30'&date<='2022-12-31')))
date_n<-subset(readout('t063_by_date'),group=='developers_all')
slidehist$period<-ifelse(slidehist$date<='2019-12-31','2017H1-2019H2','2021H1-2022H2')
agg<-aggregate(count~period+mid,data=slidehist,sum)
agg$denominator<-vapply(agg$period,function(p){dates<-unique(slidehist$date[slidehist$period==p]);sum(date_n$n_obs[date_n$date%in%dates])},numeric(1))
agg$share<-agg$count/agg$denominator
writeout(agg,'slide_distribution_bins');agg<-readout('t072_slide_distribution_bins')
render('f_distributions_pre_post',function(){
 layout(matrix(1:2,1,2));par(cex=1,mar=c(4.8,4.5,1.4,.6))
 for(p in unique(agg$period)) {
  z<-subset(agg,period==p);plot(NA,xlim=c(.5,.9),ylim=c(0,max(agg$share)*1.1),xlab='Reported RL1',ylab='Share of firm-half-years')
  proposal_window(.66,.74);rect(z$mid-.01,0,z$mid+.01,z$share,col=proposal_col['grey'],border='white');proposal_threshold();proposal_panel_label(p)
 }
},w=10,h=5.6,size=18,slide=TRUE)
record('f_distributions_pre_post',c('t063_by_date_histograms','t063_by_date','t072_slide_distribution_bins'),agg,w=10,h=5.6,size=18,slide=TRUE)
# Inspect PDF font metadata as a cross-check against the declared point sizes.
# Poppler rounds its XML size to integer points; the audit retains exact sizes.
font_checks<-list()
for(slide in c(FALSE,TRUE)) {
 # T082: check only this renderer's audited figures; other steps own their PDFs.
 audited<-do.call(rbind,audit)
 figures<-sort(unique(audited$figure[if(slide)audited$kind=='slide' else audited$kind!='slide']))
 paths<-file.path(if(slide)slide_dir else 'outputs/figures',paste0(figures,'.pdf'))
 for(path in paths) {
  xml<-system2('pdftohtml',c('-xml','-zoom','1','-hidden','-i','-stdout',shQuote(path)),stdout=TRUE,stderr=FALSE)
  fs<-grep('<fontspec ',xml,value=TRUE)
  sizes<-as.numeric(sub('.* size="([0-9.]+)".*','\\1',fs))
  ar<-do.call(rbind,audit);ar<-ar[ar$figure==tools::file_path_sans_ext(basename(path))&ar$kind==if(slide)'slide' else if(grepl('f_toc_nef',path))'conceptual_diagram' else if(grepl('f_prisma',path))'unchanged_diagram' else 'paper',]
  stopifnot(length(sizes)>0,nrow(ar)>0)
  if(all(is.finite(ar$pdf_min_font_pt)))stopifnot(abs(min(sizes)-min(ar$pdf_min_font_pt))<=.51)
  font_checks[[length(font_checks)+1L]]<-data.frame(file=if(slide)file.path('../presentation/slides/figures',basename(path)) else path,xml_min_font_pt_rounded=min(sizes),
     declared_min_font_pt=min(ar$pdf_min_font_pt),
     printed_min_font_pt=min(ar$printed_min_font_pt),
     exempt_diagram=grepl('f_prisma',path),pass=TRUE)
 }
}
writeout(do.call(rbind,font_checks),'pdf_font_check')
writeout(do.call(rbind,checks),'reconstruction_checks')
writeout(do.call(rbind,audit),'figure_audit')
after<-tools::sha256sum(guard_paths);stopifnot(identical(before,after))
writeout(data.frame(file=guard_paths,before_sha256=unname(before),after_sha256=unname(after),unchanged=unname(before==after)),'verification')
cat(sprintf('T072 reconstruction checks: %d PASS; tolerance 1e-9.\n',length(checks)))
cat(sprintf('T072 guards: %d old outputs and %d data/code inputs byte-identical.\n',length(protected),length(inputs)))
cat(sprintf('T072 audit: %d paper/slide pages; minimum empirical printed font %.3f pt.\n',nrow(do.call(rbind,audit)),min(subset(do.call(rbind,audit),kind=='paper')$printed_min_font_pt,na.rm=TRUE)))
cat('T072 rendering complete: themed PDFs, proposal copies, 5 slide PDFs, persisted bins and audit.\n')

if(!integrate_slides)unlink(slide_dir,recursive=TRUE)
