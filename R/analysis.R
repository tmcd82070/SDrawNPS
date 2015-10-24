analysis <- function(button, dat){
  
#   dat <- read.csv('//LAR-FILE-SRV/Data/NPS/GRTSUsersManual/SDrawGUI/data/JOTR_IntUp_GRTS_sample.csv')
#   df <- dat
#   outobj <- 'hey'
#   theSiteID <- 'siteID'
#   evalStatus <- 'EvalStatus'
#   evalStatusYes <- 'Target - Surveyed'
#   pop2 <- 'Park'
#   pop3 <- 'LandType'
#   wgt <- 'wgt'
#   xcoord <- 'xcoord'
#   ycoord <- 'ycoord'
#   vars <- "Mean.Percent.Cover,Mean.Canopy.Gap.Percent"              # be sure to put in '.'s. 
#   doWgt <- "Yes"
#   popn <- "Sampled"
#   fn <- 'JOTR_IntUp_GRTS_sample.csv'
#   dir <- '//LAR-FILE-SRV/Data/NPS/GRTSUsersManual/SDrawGUI/data'
  
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
  vars <- dat$vars.entry$getText()
  
  
  df <- getDataFrame( fn, dir )
  the.siteID.o <- df[,theSiteID]  
  
  #111111111111111111111 -- do some stuff in regard to weighting -- 1111111111111111111111111111111111111111111111111111111111111
  EvalCheck <- 0
  if(sum(df[ ,evalStatus ] %in% c('Target - Not Sampled','Target - Not Surveyed','Non-target','Non-Target')) > 0){
    EvalCheck <- 1
  }   
  
  # Then maybe a pop-up window that says "Are you sure? The data set include nonsampling error." 
  # that checks to see if the EvalStatus includes fields that indicate nonsampling error 
  # (Target - Not Sampled, Target - Not Surveyed, Non-target).  In some cases, the analyst may have 
  # conducted their own weighting adjustment outside of SDraw and would use the weights provided in 
  # the design file.  But it might be nice to warn the analyst that something looks amiss.
  
  # Get sample allocation information from radio buttons
  if( dat$y.rb$getActive() ){
    doWgt <- "Yes"
  } else {
    doWgt <- "No"
  }
  
  # Get popn information from radio buttons
  if( dat$T.rb$getActive() ){
    popn <- "Target"
  } else {
    popn <- "Sampled"
  }
  
  # slightly variable pop-up, depending on what's in their data.
  if(EvalCheck == 0 & doWgt == "Yes"){
    dialog <- gtkMessageDialogNew(NULL, c("modal"), "info", "ok", "You have selected to weight your sample.")
    dialog$run()
    dialog$destroy()    
  } else if(EvalCheck == 0 & doWgt == "No"){
    dialog <- gtkMessageDialogNew(NULL, c("modal"), "info", "ok", "You have selected to not weight your sample.")
    dialog$run()
    dialog$destroy()
  } else if(EvalCheck == 1 & doWgt == "Yes"){
    dialog <- gtkMessageDialogNew(NULL, c("modal"), "info", "ok", "You have selected to weight your sample.")
    dialog$run()
    dialog$destroy()
  } else {
    dialog <- gtkMessageDialogNew(NULL, c("modal"), "info", "ok", "You have selected to not weight your sample.  Are you sure?  The data include non-sampling error.")
    dialog$run()
    dialog$destroy()
  }
  
  # adjust weights by calling fn and using read-in var names specific to datarun
  if(doWgt == "YES"){
    adjwgt <- Adjwgt_FrameNR(dat=df, popn=popn , evalstatus=evalStatus, wgt=wgt)  
    oldwgt <- df[,wgt]
    wgtN   <- adjwgt
    adjwgt <- NULL
  }
  
  ############################ -- end weighting -- ##################################################################
  
  # get number of valid stratum levels
  # nStrata <- length(as.character(droplevels(unique(df[,stratum])))[as.character(droplevels(unique(df[,stratum]))) != "None"])

  # make sites df of two vars
  the.sites <- data.frame(siteID=the.siteID.o, Active=df[,evalStatus]==evalStatusYes) 


  
  
  #222222222222222222222222222 -- make subpop -- 22222222222222222222222222222222222222222222222222222222222222222222
  
  # make subpop df describing sets of popns - expand later?
  if(pop3 != '' & pop2 != ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep("AllSites",nrow(df)), Popn2=df[,pop2], Popn3=df[,pop3]) 
    names(the.subpop) <- c('siteID','AllSites',pop2,pop3)
    cdfPage <- 4
  } else if(pop3 == '' & pop2 != ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep("AllSites",nrow(df)), Popn2=df[,pop2])   
    names(the.subpop) <- c('siteID','AllSites',pop2)
    cdfPage <- 4    
  } else if (pop3 != '' & pop2 == ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep("AllSites",nrow(df)), Popn2=df[,pop3])     
    names(the.subpop) <- c('siteID','AllSites',pop3)
    cdfPage <- 4    
  } else if(pop3 == '' & pop2 == ''){
    the.subpop <- data.frame(siteID=the.siteID.o, Popn1=rep("AllSites",nrow(df))) 
    names(the.subpop) <- c('siteID','AllSites')
    cdfPage <- 1    
  }
  
  # put 'None' for subpopulations with blanks -- need to have all empties filled in
  if(pop3 != '' | pop2 != ''){      # make sure we're actually using subpops
    for(i in 1:(dim(the.subpop)[2] - 2)){
      the.subpop[,2 + i] <- as.character(droplevels(the.subpop[,2 + i]))
      the.subpop[,2 + i][the.subpop[,2 + i] == ""] <- "None"
    }
  }
  #222222222222222222222222222 -- end make subpop -- 2222222222222222222222222222222222222222222222222222222222222222

#   # make design df -- need to add strata if necessary
#   if(nStrata > 1){
#     the.designYStrat <- data.frame(siteID=the.siteID.o,wgt=df[,wgt],xcoord=df[,xcoord],ycoord=df[,ycoord],stratum=df[,stratum])
#   } 
#   the.designNStrat <- data.frame(siteID=the.siteID.o,wgt=df[,wgt],xcoord=df[,xcoord],ycoord=df[,ycoord])
  the.design <- data.frame(siteID=the.siteID.o,wgt=df[,wgt],xcoord=df[,xcoord],ycoord=df[,ycoord])
  
  # make var(s) df
  vars.vec <- strsplit(vars,',')[[1]]
  if(length(vars.vec) == 1){
    typ <- class(df[,vars.vec])
  } else {
    typ <- unlist(lapply(names(df[,vars.vec]), function(x){class(data.frame(df[,vars.vec])[,x])}))
  }
  
  vars.vec.n <- vars.vec[typ == 'numeric']
  Nvars.n <- length(vars.vec.n)
  vars.vec.f <- vars.vec[typ %in% c('factor','character')]     # factor only?
  Nvars.f <- length(vars.vec.f)
  
  # build continuous df
  if(Nvars.n > 0){
    for(i in 1:Nvars.n){
      if(i == 1){
        the.data.cont <- data.frame(siteID=the.siteID.o,Cont1=df[,vars.vec.n[i]])
      } else if(i > 1){
        the.data.cont <- data.frame(the.data.cont,temp=df[,vars.vec.n[i]])
      }
      colnames(the.data.cont)[1 + i] <- paste0('Cont',i)
    }
    outobj.cont <- paste0(outobj,".cont")
  }
  
  # build categorical df
  if(Nvars.f > 0){
    for(i in 1:Nvars.f){
      if(i == 1){
        the.data.cat <- data.frame(siteID=the.siteID.o,Cat1=df[,vars.vec.f[i]])
      } else if(i > 1){
        the.data.cat <- data.frame(the.data.cat,temp=df[,vars.vec.f[i]])
      }
      colnames(the.data.cat)[1 + i] <- paste0('Cat',i)
    }
    outobj.cat <- paste0(outobj,".cat")
  }

  
  # make pretty things for ease in making analysis log file.
  siteID.pretty <- paste0("df","$",theSiteID)
  evalStatus.pretty <- paste0("df","$",evalStatus)
  evalStatus.pretty2 <- paste0(evalStatus)
  pop2.pretty <- paste0("df","$",pop2)
  pop3.pretty <- paste0("df","$",pop3)
  wgt.pretty <- paste0("df","$",wgt)
  wgt.pretty2 <- wgt
  xcoord.pretty <- paste0("df","$",xcoord)
  ycoord.pretty <- paste0("df","$",ycoord)
  cdfPage.pretty <- cdfPage
  doWgt.pretty <- doWgt
  popn.pretty <- popn
  the.pretty <- c(siteID.pretty,evalStatus.pretty,evalStatusYes,pop2.pretty,pop3.pretty,wgt.pretty,xcoord.pretty,ycoord.pretty,cdfPage.pretty,evalStatus.pretty2,wgt.pretty2,doWgt.pretty,popn.pretty)
                #             1,                2,            3,          4,          5,         6,            7,            8,             9,                10,         11,          12,         13
  the.pretty.cont <- NULL
  if(Nvars.n > 0){
    the.pretty.cont <- c(paste0("siteID=",siteID.pretty),rep(NA,Nvars.n))
    for(i in 1:Nvars.n){
      the.pretty.cont[i + 1] <- paste0("Cont",i,"=df$",vars.vec.n[i])
    }
  }
  the.pretty.cont <- paste0("the.data.cont <- data.frame(",paste(the.pretty.cont,collapse=', '),")")
  
  the.pretty.cat <- NULL
  if(Nvars.f > 0){
    the.pretty.cat <- c(paste0("siteID=",siteID.pretty),rep(NA,Nvars.f))
    for(i in 1:Nvars.f){
      the.pretty.cat[i + 1] <- paste0("Cat",i,"=df$",vars.vec.f[i])
    }
  }
  the.pretty.cat <- paste0("the.data.cat <- data.frame(",paste(the.pretty.cat,collapse=', '),")")
  
  the.pretty <<- the.pretty
  the.pretty.cont <<- the.pretty.cont
  the.pretty.cat <<- the.pretty.cat

  
  # define 'df' for the console window
  options(useFancyQuotes = FALSE)
  cat("df <- ",dQuote(paste0(dir,"/",fn)),"\n")
  cat("popn <- ",dQuote(popn),"\n")

  if(doWgt == "Yes"){
    cat("df$oldwgt <- df$wgt\n
df$wgt <- Adjwgt_FrameNR(dat=df, popn=popn, evalstatus=",dQuote(evalStatus),", wgt=",dQuote(wgt),")\n")
  } 
  
  # print out commands
  if(Nvars.n > 0){
    if(pop3 != '' & pop2 != ''){
      cat("the.sites <- data.frame(siteID=",siteID.pretty,", ",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep('AllSites',nrow(df)), Popn2=df$",pop2,", Popn3=df$",pop3,")  
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")\n",
the.pretty.cont,"\n",sep="")   
    } else if(pop3 == '' & pop2 != ''){
      cat("the.sites <- data.frame(siteID=",siteID.pretty,", ",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep('AllSites',nrow(df)), Popn2=df$",pop2,") 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")\n",
the.pretty.cont,"\n",sep="") 
    } else if (pop3 != '' & pop2 == ''){
      cat("the.sites <- data.frame(siteID=",siteID.pretty,", ",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep('AllSites',nrow(df)), Popn2=df$",pop3,") 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")\n",
the.pretty.cont,"\n",sep="")  
    } else if(pop3 == '' & pop2 == ''){
      cat("the.sites <- data.frame(siteID=",siteID.pretty,", ",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep('AllSites',nrow(df))) 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")\n",
the.pretty.cont,"\n",sep="") 
    }
  }

  if(Nvars.f > 0){
    if(pop3 != '' & pop2 != ''){
      cat("the.sites <- data.frame(siteID=",siteID.pretty,", ",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep('AllSites',nrow(df)), Popn2=df$",pop2,", Popn3=df$",pop3,")  
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")\n",
the.pretty.cat,"\n",sep="")   
    } else if(pop3 == '' & pop2 != ''){
      cat("the.sites <- data.frame(siteID=",siteID.pretty,", ",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep('AllSites',nrow(df)), Popn2=df$",pop2,") 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")\n",
the.pretty.cat,"\n",sep="") 
    } else if (pop3 != '' & pop2 == ''){
      cat("the.sites <- data.frame(siteID=",siteID.pretty,", ",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep('AllSites',nrow(df)), Popn2=df$",pop3,") 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")\n",
the.pretty.cat,"\n",sep="")  
    } else if(pop3 == '' & pop2 == ''){
      cat("the.sites <- data.frame(siteID=",siteID.pretty,", ",evalStatus.pretty,"==",dQuote(evalStatusYes),")
the.subpop <- data.frame(siteID=",siteID.pretty,", Popn1=rep('AllSites',nrow(df))) 
the.design <- data.frame(siteID=",siteID.pretty,", wgt=",wgt.pretty,",xcoord=",xcoord.pretty,", ycoord=",ycoord.pretty,")\n",
the.pretty.cat,"\n",sep="") 
  }
}



  # print to console the actual analysis commands
  if(Nvars.n > 0){
  cat("ans.cont <- cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE)\n\n")
  }
  if(Nvars.f > 0){
  cat("ans.cat <- cat.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cat=the.data.cat)\n\n")
  } 
  
  # do the analysis
  if(Nvars.n > 0){
    ans.cont <- assign(outobj.cont,cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE),pos=.GlobalEnv)
  }
  if(Nvars.f > 0){
    ans.cat <- assign(outobj.cat,cat.analysis(sites=the.sites,
                      subpop=the.subpop,
                      design=the.design,
                      data.cat=the.data.cat),pos=.GlobalEnv)   
  }
  
  if(Nvars.n > 0){
    cont.cdfplot(paste0(dir,"/",substr(fn,1,nchar(fn) - 4)," - CDF Plots.pdf"),ans.cont$CDF,cdf.page=cdfPage)
  }
  makeAnalysisLog(fn,dir,the.pretty,the.pretty.cont,the.pretty.cat)
  options(useFancyQuotes = TRUE)

  dialog <- gtkMessageDialogNew(NULL, c("modal"), "info", "ok", "Analysis successful.")
  dialog$run()
  dialog$destroy()
}