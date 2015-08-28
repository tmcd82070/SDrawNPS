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
  
  siteID <- dat$siteID.entry$getText()
  evalStatus <- dat$evalStatus.entry$getText()
  evalStatusYes <- dat$evalStatusYes.entry$getText()
  pop2 <- dat$pop2.entry$getText() # note that pop1 is all elements combined
  pop3 <- dat$pop3.entry$getText() # note that pop1 is all elements combined
  wgt <- dat$wgt.entry$getText()
  xcoord <- dat$xcoord.entry$getText()
  ycoord <- dat$ycoord.entry$getText()
  cont.var <- dat$cont.var.entry$getText()
  
  df <- getDataFrame( fn, dir )
  
  the.siteID.o <- df[,siteID]   
  
  # make sites df of two vars
  the.sites <- data.frame(siteID=the.siteID.o, df[,evalStatus]==evalStatusYes) 

  # make subpop df describing sets of popns - expand later?
  if(pop3 != '' & pop2 != ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep(1,nrow(df)), Popn2=df[,pop2], Popn3=df[,pop3])     
  } else if(pop3 == '' & pop2 != ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep(1,nrow(df)), Popn2=df[,pop2])     
  } else if (pop3 != '' & pop2 == ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep(1,nrow(df)), Popn2=df[,pop3])       
  } else if(pop3 == '' & pop2 == ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep(1,nrow(df))) 
  }

  # make design df
  the.design <- data.frame(siteID=the.siteID.o, wgt=df[,wgt],xcoord=df[,xcoord], ycoord=df[,ycoord])
  
  # make cont var df
  the.data.cont <- data.frame(siteID=the.siteID.o, Ind=df[,cont.var])
  
  siteID.pretty <- paste0("df","$",siteID)
  evalStatus.pretty <- paste0("df","$",evalStatus)
  pop2.pretty <- paste0("df","$",pop2)
  pop3.pretty <- paste0("df","$",pop3)
  wgt.pretty <- paste0("df","$",wgt)
  xcoord.pretty <- paste0("df","$",xcoord)
  ycoord.pretty <- paste0("df","$",ycoord)
  cont.var.pretty <- paste0("df","$",cont.var)
  the.pretty <- c(siteID.pretty,evalStatus.pretty,evalStatusYes,pop2.pretty,pop3.pretty,wgt.pretty,xcoord.pretty,ycoord.pretty,cont.var.pretty)

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

  the.sites <<- the.sites
  the.subpop <<- the.subpop
  the.design <<- the.design
  the.data.cont <<- the.data.cont


  # do the analysis
  ans <- cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE)
  
  cont.cdfplot(paste0(dir,"/",fn," - CDF Plots.pdf"),ans$CDF)
  makeAnalysisLog(dat,the.pretty)
  options(useFancyQuotes = TRUE)
}




# colVec <- c('red','green','blue')
# uniqueSubpop <- as.character(droplevels(unique(ans$CDF$Subpopulation)))
# uniqueSubpop[uniqueSubpop == "1"] <- "All"
# xMin <- min(ans$CDF$Value)
# xMax <- max(ans$CDF$Value)
# for(i in 1:length(uniqueSubpop)){
#   if(i == 1){
#     plot(ans$CDF$Value[ans$CDF$Subpopulation == "1"],ans$CDF$Estimate.P[ans$CDF$Subpopulation == "1"],xaxt='n',yaxt='n',xlab="",ylab="",col=colVec[i],xlim=c(xMin,xMax),ylim=c(0,100),type='l')
#   } else {
#     par(new=TRUE)
#     plot(ans$CDF$Value[ans$CDF$Subpopulation == uniqueSubpop[i]],ans$CDF$Estimate.P[ans$CDF$Subpopulation == uniqueSubpop[i]],xaxt='n',yaxt='n',xlab="",ylab="",col=colVec[i],xlim=c(xMin,xMax),ylim=c(0,100),type='l')
#   }
# }
# axis(1,xaxp=c(xMin,xMax,5),labels=TRUE)
# axis(2,xaxp=c(0,100,10),labels=TRUE, las=2)
# legend("bottomright",legend=uniqueSubpop,col=colVec[1:i],lty=c(1,1,1),bty="n")
# title("blahblahb",xlab=cont.var,ylab="P(Y <= y)")

