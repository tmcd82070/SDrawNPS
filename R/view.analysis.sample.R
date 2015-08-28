view.analysis.sample <- function(x, dat){
  
  samp.nm <- dat$out.r.entry$getText()
  
  if( exists( samp.nm, envir=.GlobalEnv ) ){
    samp <- get( samp.nm, pos=.GlobalEnv )
    View( samp[[1]], paste(samp.nm,"[[1]] - CDFs" ))
    View( samp[[2]], paste(samp.nm,"[[2]] - CDF Summaries" ))
  } else {
    error.message(paste( "Sample object", samp.nm[[1]], "does not exist."))
  }
  
}
