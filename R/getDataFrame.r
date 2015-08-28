getDataFrame <- function( filename, dir ){

    if( exists(filename) ){
      
        #   The dataframe has already been read, and it is laying around.  No need to re-read.
        dat <- get(filename)
        
    } else {
      
        #   The dat is not laying around.  Read it.      
        dat <- read.csv(paste0(dir,'/',filename))  

    }

    dat
}
