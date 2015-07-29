makeAnalysisLog <- function(dat,thePretty){
  
  # if file currently exists, delete it out.
  
  file <- attr(dat,"file")
  path <- attr(dat,"path")
  pasteString <- paste0(path,"/Cont.Analysis of ",substr(file,1,nchar(file) - 4),".log")
  pathfile <- paste0(path,'/',file)
  
  if (file.exists(pasteString)) file.remove(paste0(path,"/Cont.Analysis of ",substr(file,1,nchar(file) - 4),".log"))
  
  # file now doesn't exist, so make it.
  
  # make cont.analysis log file 
  options(useFancyQuotes = FALSE)
  log_con <- file(pasteString,open="a")

  cat("# Utilization of this code without first installing R package spsurvey will result in error.\n",sep="",append=TRUE,file=log_con)
  
  cat("# This output results from the xxxxxxx.r function of the SDraw package, WEST Inc., 2015, Version 1.04.\n
  library(spsurvey)\n\n",sep="",append=TRUE,file=log_con)
  
  cat("# Read in the csv file of interest for which analysis is required.\n
  dat <- read.csv( ",dQuote(pathfile)," ) \n\n",sep="",file=log_con)
  
  cat("# Prepare the analysis for use in the cont.analysis function.\n
  the.sites <- data.frame(siteID=",the.pretty[1],",",the.pretty[2],"==",dQuote(the.pretty[3]),")
  the.subpop <- data.frame(siteID=",the.pretty[1],", Popn1= rep(1,nrow(dat))) 
  the.design <- data.frame(siteID=",the.pretty[1],", wgt=",the.pretty[4],",xcoord=",the.pretty[5],", ycoord=",the.pretty[6],")
  the.data.cont <- data.frame(siteID=",the.pretty[1],", Ind=",the.pretty[7],")\n\n",sep="",append=TRUE,file=log_con)
  
  cat("# Analyze the sample via the cont.analysis function in package spsurvey.\n
  ans <- cont.analysis(sites=the.sites,
                       subpop=the.subpop,
                       design=the.design,
                       data.cont=the.data.cont,
                       total=TRUE)\n\n",sep="",append=TRUE,file=log_con)
  
  cat("# Plot the resulting cdf/edf???? not done. do we care?.\n
  plot(shp)
  plot(Stratsites,col='red',pch=19,add=TRUE)\n\n", sep="",append=TRUE,file=log_con)
  
  close(log_con)
  
  options(useFancyQuotes = TRUE)
}






