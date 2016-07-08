my.write.csv.nonWidget <- function(outobj,dir){

  
  samp.nm.cont <- '<<Continuous Results>>' 
  samp.nm.cat <- '<<Categorical Results>>'
  if( exists( paste0(outobj,".cont"), envir=.GlobalEnv ) | exists( paste0(outobj,".cat"), envir=.GlobalEnv ) ){
    
    # set up naming variables
    if( exists( paste0( outobj,".cont"), envir=.GlobalEnv) ){
      samp.cont <- get( paste0(outobj,".cont") )
      samp.nm.cont <- gsub(".", "_", paste0(outobj,".cont"), fixed=TRUE )
    }
    if( exists( paste0( outobj,".cat"), envir=.GlobalEnv) ){
      samp.cat <- get( paste0(outobj,".cat") )
      samp.nm.cat <- gsub(".", "_",paste0(outobj,".cat"), fixed=TRUE )
    }

    #path.n.filename <- paste0(dir,'/',outobj)
    #path.n.filename <- extractPathFilename(path.n.filename)
    
    #  redefine to be getwd. 
    path.n.filename <- paste0(getwd(),'/',outobj)
    path.n.filename <- extractPathFilename(path.n.filename)
    
    if( exists( paste0( outobj,".cont"), envir=.GlobalEnv) ){
      write.csv( samp.cont[[1]],paste0(path.n.filename$path,'/',path.n.filename$file,'_CDF.csv'))
      write.csv( samp.cont[[2]],paste0(path.n.filename$path,'/',path.n.filename$file,'_Pct.csv'))
    }
    if( exists( paste0( outobj,".cat"), envir=.GlobalEnv) ){
      write.csv( samp.cat,paste0(path.n.filename$path,'/',path.n.filename$file,'_Cat.csv'))
    }
  } else {
    error.message( paste( "Sample object(s) '", samp.nm.cont,"' and/or '", samp.nm.cat, "' not found. Hit RUN before EXPORT.\n", sep=""))
  }
}