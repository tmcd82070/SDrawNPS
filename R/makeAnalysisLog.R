makeAnalysisLog <- function(fn,dir,outobj,the.pretty,the.pretty.cont,the.pretty.cat){
  
  
#   the.pretty <- the.pretty
#   the.pretty.cont <- the.pretty.cont
#   the.pretty.cat <- the.pretty.cat
#   fn <- 'JOTR_IntUp_GRTS_sample.csv'
#   dir <- '//lar-file-srv/Data/NPS/GRTSUsersManual/SDrawNPS/data'
  
  #  set the directory to be the working directory. 
  oldDir <- dir
  dir <- getwd()
  
  # if file currently exists, delete it out.
  pasteString <- paste0(dir,"/Analysis of ",substr(fn,1,nchar(fn) - 4)," - ",outobj,".log")
  pathfile <- paste0(oldDir,'/',fn)
  
  CDFString <- paste0(dir,"/",substr(fn,1,nchar(fn) - 4)," - ",outobj," - CDF Plots.pdf")
  
  paste0(dir,"/",fn," - CDF Plots.pdf")
  
  if (file.exists(pasteString)) file.remove(paste0(dir,"/Analysis of ",substr(fn,1,nchar(fn) - 4)," - ",outobj,".log"))
  
  # file now doesn't exist, so make it.
  
  # make cont.analysis log file 
  options(useFancyQuotes = FALSE)
  log_con <- file(pasteString,open="a")
  cat("# Utilization of this code without first installing R package spsurvey will result in error.\n",sep="",append=TRUE,file=log_con)
  
#   cat("# This output results from the analysis.r function of the SDrawNPS package, WEST Inc., 2015.\n
#   library(spsurvey)
#   library(SDrawNPS)\n\n",sep="",append=TRUE,file=log_con)
  
  cat("# This output results from the analysis.r function of the SDrawNPS package, WEST Inc., 2015.\n
# To ensure code completion, check if packages are installed;  if not, install them.\n
      pkgList <- c('spsurvey','SDrawNPS')
      inst <- pkgList %in% installed.packages()
      if (length(pkgList[!inst]) > 0)
      install.packages(pkgList[!inst])
      lapply(pkgList, library, character.only=TRUE)\n\n", sep="", append = TRUE, file = log_con)
  
  cat("# Read in the csv file of interest for which analysis is required.\n
  df <- read.csv(",dQuote(pathfile),") \n\n",sep="",file=log_con)
  
  if(the.pretty[12] == "Yes"){
    if(the.pretty[13] == "Target"){
      cat("# Identify the pop'n of inference.  Keep in mind you have chosen to focus on the entire pop'n.\n
    popn <- ",dQuote(the.pretty[13]),"\n\n",sep="",file=log_con)
    } else {
      cat("# Identify the pop'n of inference.  Keep in mind you have chosen to focus on the subpop'n of the target pop'n.\n
    popn <- ",dQuote(the.pretty[13]),"\n\n",sep="",file=log_con)
    }
  }

  object <- "oldwgt"
  if(the.pretty[12] == "Yes"){
    cat("# Identify your chosen weighting scheme.  Keep in mind SDrawNPS is adjusting your weights.\n
  df$oldwgt <- ",the.pretty[6],"
  df$wgt <- Adjwgt_FrameNR(dat=df, popn=popn, evalstatus=",dQuote(the.pretty[10]),", wgt=",dQuote(object),")\n\n",sep="",file=log_con)
  } else {
    cat("# Identify your chosen weighting scheme.  Keep in mind your original data contains the weights.\n
  df$wgt <- ",the.pretty[6],"\n",sep="",file=log_con)
  }
  
  if(the.pretty.cont != "the.data.cont <- data.frame()"){
    cat("# Prepare the analysis for use in the continuous analysis function.\n\n",sep="",append=TRUE,file=log_con)
    cat("  the.sites <- data.frame(siteID=",the.pretty[1],", ",the.pretty[2],"==",dQuote(the.pretty[3]),")\n",sep="",append=TRUE,file=log_con)
  
    if(the.pretty[4] != 'df$' & the.pretty[5] != 'df$'){
      cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep('AllSites',nrow(df)), Popn2=",the.pretty[4],", Popn3=",the.pretty[5],")
  names(the.subpop) <- c('siteID','AllSites',",sQuote(the.pretty[14]),",",sQuote(the.pretty[15]),")\n",sep="",append=TRUE,file=log_con)  
    } else if(the.pretty[5] == 'df$' & the.pretty[4] != 'df$'){
      cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep('AllSites',nrow(df)), Popn2=",the.pretty[4],")
  names(the.subpop) <- c('siteID','AllSites',",sQuote(the.pretty[14]),")\n",sep="",append=TRUE,file=log_con) 
    } else if (the.pretty[5] != 'df$' & the.pretty[4] == 'df$'){
      cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep('AllSites',nrow(df)), Popn2=",the.pretty[5],")
  names(the.subpop) <- c('siteID','AllSites',",sQuote(the.pretty[15]),")\n",sep="",append=TRUE,file=log_con) 
    } else if(the.pretty[5] == 'df$' & the.pretty[4] == 'df$'){
      cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep('AllSites',nrow(df)))
  names(the.subpop) <- c('siteID','AllSites')\n",sep="",append=TRUE,file=log_con)  
    }
  
    cat("  the.design <- data.frame(siteID=",the.pretty[1],", wgt=",the.pretty[6],", xcoord=",the.pretty[7],", ycoord=",the.pretty[8],")\n",sep="",append=TRUE,file=log_con)
    cat("  ",the.pretty.cont,"\n\n",sep="",append=TRUE,file=log_con)
  
    cat("# Analyze the sample via the cont.analysis function in package spsurvey.\n
  ans.cont <- cont.analysis(sites=the.sites,
                            subpop=the.subpop,
                            design=the.design,
                            data.cont=the.data.cont,
                            total=TRUE,
                            conf=",the.pretty[16],")\n\n",sep="",append=TRUE,file=log_con)
  
    cat("# Plot the resulting empirical distribution functions.\n
  cont.cdfplot(",dQuote(CDFString),",ans.cont$CDF,cdf.page=",as.numeric(the.pretty[9]),")\n\n", sep="",append=TRUE,file=log_con)
  }
  
  if(the.pretty.cat != "the.data.cat <- data.frame()"){
    cat("\n\n# Prepare the analysis for use in the categorical analysis function.\n\n",sep="",append=TRUE,file=log_con)
    cat("  the.sites <- data.frame(siteID=",the.pretty[1],", ",the.pretty[2],"==",dQuote(the.pretty[3]),")\n",sep="",append=TRUE,file=log_con)
    
    if(the.pretty[4] != 'df$' & the.pretty[5] != 'df$'){
      cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep('AllSites',nrow(df)), Popn2=",the.pretty[4],", Popn3=",the.pretty[5],")
  names(the.subpop) <- c('siteID','AllSites',",sQuote(the.pretty[14]),",",sQuote(the.pretty[15]),")\n",sep="",append=TRUE,file=log_con)  
    } else if(the.pretty[5] == 'df$' & the.pretty[4] != 'df$'){
      cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep('AllSites',nrow(df)), Popn2=",the.pretty[4],")
  names(the.subpop) <- c('siteID','AllSites',",sQuote(the.pretty[14]),")\n",sep="",append=TRUE,file=log_con) 
    } else if (the.pretty[5] != 'df$' & the.pretty[4] == 'df$'){
      cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep('AllSites',nrow(df)), Popn2=",the.pretty[5],")
  names(the.subpop) <- c('siteID','AllSites',",sQuote(the.pretty[15]),")\n",sep="",append=TRUE,file=log_con) 
    } else if(the.pretty[5] == 'df$' & the.pretty[4] == 'df$'){
      cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep('AllSites',nrow(df)))
  names(the.subpop) <- c('siteID','AllSites')\n",sep="",append=TRUE,file=log_con)  
    }
    
    cat("  the.design <- data.frame(siteID=",the.pretty[1],", wgt=",the.pretty[6],", xcoord=",the.pretty[7],", ycoord=",the.pretty[8],")\n",sep="",append=TRUE,file=log_con)
    cat("  ",the.pretty.cat,"\n\n",sep="",append=TRUE,file=log_con)
    
    cat("# Analyze the sample via the cat.analysis function in package spsurvey.\n
  ans.cat <- cat.analysis(sites=the.sites,
                          subpop=the.subpop,
                          design=the.design,
                          data.cat=the.data.cat,
                          conf=",the.pretty[16],")\n\n",sep="",append=TRUE,file=log_con)
  } 
  
  close(log_con)
  
  options(useFancyQuotes = TRUE)
}
