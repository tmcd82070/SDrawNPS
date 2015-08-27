analysisCont <- function(button, dat){
  
#   df <- dat
#   siteID <- 'siteID'
#   evalStatus <- 'EvalStatus'
#   evalStatusYes <- 'Target - Sampled'
#   wgt <- 'wgt'
#   xcoord <- 'xcoord'
#   ycoord <- 'ycoord'
#   cont.var <- 'pH'

  # -------------------------------------------------------------------------------------------------
  fn <- dat$shape.in.entry$getText()
  dir <- dat$shape.in.dir$getText()
  
  siteID <- dat$siteID.entry$getText()
  evalStatus <- dat$evalStatus.entry$getText()
  evalStatusYes <- dat$evalStatusYes.entry$getText()
  wgt <- dat$wgt.entry$getText()
  xcoord <- dat$xcoord.entry$getText()
  ycoord <- dat$ycoord.entry$getText()
  cont.var <- dat$cont.var.entry$getText()
  
  df <- getDataFrame( fn, dir )
  
  the.siteID.o <- df[,siteID.entry]   
  
  # make sites df of two vars
  the.sites <- data.frame(siteID=the.siteID.o, df[,evalStatus]==evalStatusYes) 
  
  # make subpop df describing sets of popns - expand later?
  the.subpop <- data.frame(siteID=the.siteID.o, Popn1= rep(1,nrow(df))) 

  # make design df
  the.design <- data.frame(siteID=the.siteID.o, wgt=df[,wgt],xcoord=df[,xcoord], ycoord=df[,ycoord])
  
  # make cont var df
  the.data.cont <- data.frame(siteID=the.siteID.o, Ind=df[,cont.var])
  

  siteID.pretty <- paste0(deparse(substitute(df)),"$",siteID)
  evalStatus.pretty <- paste0(deparse(substitute(df)),"$",evalStatus)
  wgt.pretty <- paste0(deparse(substitute(df)),"$",wgt)
  xcoord.pretty <- paste0(deparse(substitute(df)),"$",xcoord)
  ycoord.pretty <- paste0(deparse(substitute(df)),"$",ycoord)
  cont.var.pretty <- paste0(deparse(substitute(df)),"$",cont.var)
  the.pretty <- c(siteID.pretty,evalStatus.pretty,evalStatusYes,wgt.pretty,xcoord.pretty,ycoord.pretty,cont.var.pretty)
  
  # print out commands
  cat("the.sites <- data.frame(siteID=",siteID.pretty,",",evalStatus.pretty,"==",dQuote(evalStatusYes),")
  the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1= rep(1,nrow(df))) 
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








