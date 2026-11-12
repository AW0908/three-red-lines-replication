# T072: shared, deterministic base-graphics theme. Sizes are PDF points.
proposal_col <- c(primary='#549E39', accent='#6B9F25', light='#D1DFCE',
                  dark='#3D7A28', grey='#7F7F7F', blue='#2F5D8A')
proposal_pdf <- function(path, width=6.5, height=4, size=12) {
  grDevices::pdf(path, width=width, height=height, family='Times', pointsize=size,
                 useDingbats=FALSE, timestamp=FALSE, title=basename(path),
                 author='MTPA replication', compress=TRUE)
  par(family='serif', cex=1, cex.axis=1, cex.lab=1, cex.main=1,
      col.axis='#333333', col.lab='#333333', fg='#333333',
      las=1, bty='l', tcl=-.22, mgp=c(2.5,.65,0), lend=1, lwd=.8,
      mar=c(5.2,4.7,.7,1), xaxs='i', yaxs='i')
}
proposal_window <- function(lo=.66,hi=.70) {
  u<-par('usr');rect(lo,u[3],hi,u[4],col=proposal_col['light'],border=NA)
}
proposal_threshold <- function() abline(v=.70,col=proposal_col['dark'],lty=2,lwd=.8)
proposal_legend <- function(labels, cols, lty=1, pch=NA, ncol=length(labels), inset=-.34, ...) {
  # Place in the physical bottom margin of the current figure region. A negative
  # plot-relative inset can clip legends when the plot has a large y range.
  fig<-par('fig');nr<-ceiling(length(labels)/ncol)
  y<-fig[3]+(.04+par('ps')*1.25*nr/144)/par('din')[2]
  args<-list(x=mean(par('usr')[1:2]),y=grconvertY(y,from='ndc',to='user'),
         xjust=.5,yjust=.5,legend=labels,col=cols,
         ncol=ncol,bty='n',xpd=NA,cex=1,seg.len=1.4,x.intersp=.55, ...)
  if(any(!is.na(lty)))args$lty<-lty
  if(any(!is.na(pch)))args$pch<-pch
  do.call(legend,args)
}
proposal_panel_label <- function(label) mtext(label,side=3,line=.12,adj=0)
proposal_halflabel <- function(date) paste0(substr(date,1,4),'H',ifelse(substr(date,6,7)=='06',1,2))
