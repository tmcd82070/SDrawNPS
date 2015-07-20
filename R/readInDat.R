readInDat <- function(file,path,header=TRUE){
  
  # this function reads in csv data, and prepares it for use in analysis program(s).
  
  
  file <- "SEKIlakes_ExampleData.csv"
  path <- "//LAR-FILE-SRV/DATA/NPS/SDraw/data"    # without file ext, to match behavior of read/writeOGR
  header <- TRUE
  
  # --------------------------------------------------------------------------------------------
  
  dat <- read.csv(paste0(path,'/',file), header=TRUE)
  
  attr(dat,"file") <- file
  attr(dat,"path") <- path
  
  dat
}
  
  

