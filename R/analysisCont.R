analysisCont <- function(button, dat){
  
#   df <- dat
#   siteID <- 'siteID'
#   evalStatus <- 'EvalStatus'
#   evalStatusYes <- 'Target - Sampled'
#   pop2 <- 'Park'
#   pop3 <- ''
#   wgt <- 'wgt'
#   xcoord <- 'xcoord'
#   ycoord <- 'ycoord'
#   cont.var <- 'pH'
#   fn <- 'SEKIlakes_ExampleData.csv'
#   dir <- '//lar-file-srv/Data/NPS/SDrawGUI/data'
  
  # -------------------------------------------------------------------------------------------------
  fn <- dat$shape.in.entry$getText()
  dir <- dat$shape.in.dir$getText()
  
  outobj <- dat$out.r.entry$getText()
  theSiteID <- dat$siteID.entry$getText()
  evalStatus <- dat$evalStatus.entry$getText()
  evalStatusYes <- dat$evalStatusYes.entry$getText()
  pop2 <- dat$pop2.entry$getText() # note that pop1 is all elements combined
  pop3 <- dat$pop3.entry$getText() # note that pop1 is all elements combined
  wgt <- dat$wgt.entry$getText()
  xcoord <- dat$xcoord.entry$getText()
  ycoord <- dat$ycoord.entry$getText()
  cont.var <- dat$cont.var.entry$getText()
  
  df <- getDataFrame( fn, dir )
  
  the.siteID.o <- df[,theSiteID]   
  
  # make sites df of two vars
  the.sites <- data.frame(siteID=the.siteID.o, df[,evalStatus]==evalStatusYes) 

  # make subpop df describing sets of popns - expand later?
  if(pop3 != '' & pop2 != ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep(1,nrow(df)), Popn2=df[,pop2], Popn3=df[,pop3]) 
    cdfPage <- 4
  } else if(pop3 == '' & pop2 != ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep(1,nrow(df)), Popn2=df[,pop2])     
    cdfPage <- 4    
  } else if (pop3 != '' & pop2 == ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep(1,nrow(df)), Popn2=df[,pop3])     
    cdfPage <- 4    
  } else if(pop3 == '' & pop2 == ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep(1,nrow(df))) 
    cdfPage <- 1    
  }

  # make design df
  the.design <- data.frame(siteID=the.siteID.o, wgt=df[,wgt],xcoord=df[,xcoord], ycoord=df[,ycoord])
  
  # make cont var df
  the.data.cont <- data.frame(siteID=the.siteID.o, Ind=df[,cont.var])
  
  siteID.pretty <- paste0("df","$",theSiteID)
  evalStatus.pretty <- paste0("df","$",evalStatus)
  pop2.pretty <- paste0("df","$",pop2)
  pop3.pretty <- paste0("df","$",pop3)
  wgt.pretty <- paste0("df","$",wgt)
  xcoord.pretty <- paste0("df","$",xcoord)
  ycoord.pretty <- paste0("df","$",ycoord)
  cont.var.pretty <- paste0("df","$",cont.var)
  cdfPage.pretty <- cdfPage
  the.pretty <- c(siteID.pretty,evalStatus.pretty,evalStatusYes,pop2.pretty,pop3.pretty,wgt.pretty,xcoord.pretty,ycoord.pretty,cont.var.pretty,cdfPage.pretty)
  
  the.pretty <<- the.pretty

  # define 'df' for the console window
  options(useFancyQuotes = FALSE)
  cat("df <- ",dQuote(paste0(dir,"/",fn)),"\n")

  # print out commands
  if(pop3 != '' & pop2 != ''){
    cat("the.sites <- data.frame(siteID=",siteID.pretty,",",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep(1,nrow(df)), Popn2=df$",pop2,", Popn3=df$",pop3,")  
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")
the.data.cont <- data.frame(siteID=",siteID.pretty,", Ind=",cont.var.pretty,")\n",sep="")   
  } else if(pop3 == '' & pop2 != ''){
    cat("the.sites <- data.frame(siteID=",siteID.pretty,",",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep(1,nrow(df)), Popn2=df$",pop2,") 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")
the.data.cont <- data.frame(siteID=",siteID.pretty,", Ind=",cont.var.pretty,")\n",sep="")   
  } else if (pop3 != '' & pop2 == ''){
    cat("the.sites <- data.frame(siteID=",siteID.pretty,",",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep(1,nrow(df)), Popn2=df$",pop3,") 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")
the.data.cont <- data.frame(siteID=",siteID.pretty,", Ind=",cont.var.pretty,")\n",sep="")     
  } else if(pop3 == '' & pop2 == ''){
    cat("the.sites <- data.frame(siteID=",siteID.pretty,",",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep(1,nrow(df))) 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")
the.data.cont <- data.frame(siteID=",siteID.pretty,", Ind=",cont.var.pretty,")\n",sep="")
  }



  cat("ans <- cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE)\n\n")

  # do the analysis
#   ans <- cont.analysis(sites=the.sites,
#                        subpop=the.subpop,
#                        design=the.design,
#                        data.cont=the.data.cont,
#                        total=TRUE)
  
  ans <- assign(outobj,cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE),pos=.GlobalEnv)
  
 # outobj2 <<- outobj
#   ans2 <<- ans
#   assign(outobj2,ans2)
  
  cont.cdfplot(paste0(dir,"/",substr(fn,1,nchar(fn) - 4)," - CDF Plots.pdf"),ans$CDF,cdf.page=cdfPage)
  makeAnalysisLog(fn,dir,the.pretty)
  options(useFancyQuotes = TRUE)

  dialog <- gtkMessageDialogNew(NULL, c("modal"), "info", "ok", "Analysis successful.")
  dialog$run()
  dialog$destroy()
}