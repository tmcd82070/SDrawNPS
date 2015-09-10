view.analysis.sample <- function(x, dat){
  
  outobj <- dat$out.r.entry$getText()
  
  if( exists( paste0(outobj,".cont"), envir=.GlobalEnv ) | exists( paste0(outobj,".cat"), envir=.GlobalEnv ) ){
    if( exists( paste0(outobj,".cont"), envir=.GlobalEnv ) ){
      samp <- get( paste0(outobj,".cont"), pos=.GlobalEnv )
      View( samp[[1]], paste0(outobj,".cont[[1]] - CDF" ))
      View( samp[[2]], paste0(outobj,".cont[[2]] - Pct" ))
    } 
    if( exists( paste0(outobj,".cat"), envir=.GlobalEnv ) ){
      samp <- get( paste0(outobj,".cat"), pos=.GlobalEnv )
      View( samp, paste0(outobj,".cat - Cat" ))
    } 
  } else {
    error.message(paste0( "Sample objects ",paste0(outobj,".cat")," and ",paste0(outobj,".cat")," do not exist."))
  }
}