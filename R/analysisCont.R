analysisCont <- function(dat,the.siteID,the.evalStatus,the.evalStatusYes,the.wgt,the.xcoord,the.ycoord,the.cont.var){
  
  dat <- dat
  siteID <- 'siteID'
  the.evalStatus <- 'EvalStatus'
  the.evalStatusYes <- 'Target - Sampled'
  the.wgt <- 'wgt'
  the.xcoord <- 'xcoord'
  the.ycoord <- 'ycoord'
  the.cont.var <- 'pH'

  # -------------------------------------------------------------------------------------------------
  
  the.siteID.o <- dat[,the.siteID]   
  
  # make sites df of two vars
  the.sites <- data.frame(siteID=the.siteID.o, dat[,the.evalStatus]==the.evalStatusYes) 
  
  # make subpop df describing sets of popns - expand later?
  the.subpop <- data.frame(siteID=the.siteID.o, Popn1= rep(1,nrow(dat))) 

  # make design df
  the.design <- data.frame(siteID=the.siteID.o, wgt=dat[,the.wgt],xcoord=dat[,the.xcoord], ycoord=dat[,the.ycoord])
  
  # make cont var df
  the.data.cont <- data.frame(siteID=the.siteID.o, Ind=dat[,the.cont.var])
  


  siteID.pretty <- paste0(deparse(substitute(dat)),"$",siteID)
  evalStatus.pretty <- paste0(deparse(substitute(dat)),"$",the.evalStatus)
  wgt.pretty <- paste0(deparse(substitute(dat)),"$",the.wgt)
  xcoord.pretty <- paste0(deparse(substitute(dat)),"$",the.xcoord)
  ycoord.pretty <- paste0(deparse(substitute(dat)),"$",the.ycoord)
  cont.var.pretty <- paste0(deparse(substitute(dat)),"$",the.cont.var)
  the.pretty <- c(siteID.pretty,evalStatus.pretty,the.evalStatusYes,wgt.pretty,xcoord.pretty,ycoord.pretty,cont.var.pretty)
  
  # print out commands
  cat("the.sites <- data.frame(siteID=",siteID.pretty,",",evalStatus.pretty,"==",dQuote(the.evalStatusYes),")
  the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1= rep(1,nrow(dat))) 
  the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")
  the.data.cont <- data.frame(siteID=",siteID.pretty,", Ind=",cont.var.pretty,")\n",sep="")

  cat("ans <- cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE)\n\n")

  # do the analysis
  ans <- cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE)
  
  makeAnalysisLog(dat,the.pretty)

}








