makeAnalysisLog <- function(fn,dir,the.pretty){
  
  
#   the.pretty <- the.pretty
#   fn <- 'ugh.txt'
#   dir <- '//lar-file-srv/Data/NPS/SDrawGUI/data'
  
  # if file currently exists, delete it out.
  pasteString <- paste0(dir,"/Cont.Analysis of ",substr(fn,1,nchar(fn) - 4),".log")
  pathfile <- paste0(dir,'/',fn)
  
  CDFString <- paste0(dir,"/",substr(fn,1,nchar(fn) - 4)," - CDF Plots.pdf")
  
  paste0(dir,"/",fn," - CDF Plots.pdf")
  
  if (file.exists(pasteString)) file.remove(paste0(dir,"/Cont.Analysis of ",substr(fn,1,nchar(fn) - 4),".log"))
  
  # file now doesn't exist, so make it.
  
  # make cont.analysis log file 
  options(useFancyQuotes = FALSE)
  log_con <- file(pasteString,open="a")
  
  cat("# Utilization of this code without first installing R package spsurvey will result in error.\n",sep="",append=TRUE,file=log_con)
  
  cat("# This output results from the xxxxxxx.r function of the SDraw package, WEST Inc., 2015, Version 1.04.\n
  library(spsurvey)\n\n",sep="",append=TRUE,file=log_con)
  
  cat("# Read in the csv file of interest for which analysis is required.\n
  df <- read.csv(",dQuote(pathfile),") \n\n",sep="",file=log_con)
  
  cat("# Prepare the analysis for use in the cont.analysis function.\n
  the.sites <- data.frame(siteID=",the.pretty[1],", ",the.pretty[2],"==",dQuote(the.pretty[3]),")\n",sep="",append=TRUE,file=log_con)
  
  if(the.pretty[4] != 'df$' & the.pretty[5] != 'df$'){
    cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep(1,nrow(df)), Popn2=",the.pretty[4],", Popn3=",the.pretty[5],")\n",sep="",append=TRUE,file=log_con)  
  } else if(the.pretty[5] == 'df$' & the.pretty[4] != 'df$'){
    cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep(1,nrow(df)), Popn2=",the.pretty[4],")\n",sep="",append=TRUE,file=log_con) 
  } else if (the.pretty[5] != 'df$' & the.pretty[4] == 'df$'){
    cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep(1,nrow(df)), Popn2=",the.pretty[5],")\n",sep="",append=TRUE,file=log_con) 
  } else if(the.pretty[5] == 'df$' & the.pretty[4] == 'df$'){
    cat("  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1=rep(1,nrow(df)))\n",sep="",append=TRUE,file=log_con)  
  }
  
  cat("  the.design <- data.frame(siteID=",the.pretty[1],", wgt=",the.pretty[6],", xcoord=",the.pretty[7],", ycoord=",the.pretty[8],")
  the.data.cont <- data.frame(siteID=",the.pretty[1],", Ind=",the.pretty[9],")\n\n",sep="",append=TRUE,file=log_con)
  
  cat("# Analyze the sample via the cont.analysis function in package spsurvey.\n
  ans <- cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE)\n\n",sep="",append=TRUE,file=log_con)
  
  cat("# Plot the resulting empirical distribution functions.\n
  cont.cdfplot(",dQuote(CDFString),",ans$CDF)\n\n", sep="",append=TRUE,file=log_con)
  
  close(log_con)
  
  options(useFancyQuotes = TRUE)
}




