readShape <- function(input.dir, layername){
#
#   This is a wrapper for readOGR
#


    cat("Reading shapefile...This takes a while if the file is big...\n")

    #   Read the shape file, if it does not exist, readOGR says so.
  
    shp <- readOGR( input.dir, layername )  # This requires library rgdal
    
    #   ---- Print to console.  
    options(useFancyQuotes = FALSE)
    cat("# Read in the shapefile of interest from which sampling occurs.\n
    shp <- readOGR( ",dQuote(input.dir),", ",dQuote(layername)," ) \n\n",sep="")
    options(useFancyQuotes = TRUE)
    #   ---- End print to console.

    cat("Success reading shapefile\n")

    if( length(grep("SpatialPoints", class(shp))) > 0 ){
        attr(shp,"type") <- "points"
    } else if( length(grep("SpatialLines", class(shp))) > 0 ){
        attr(shp,"type") <- "lines"
    } else if( length(grep("SpatialPolygons", class(shp))) > 0 ){
        attr(shp,"type") <- "polygons"
    } 
    
        
    shp
}
