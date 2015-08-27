readButtonActionCSV<-function(x,dat){
  
  # Read the shape file, and display in the dialog any variables found.
  
#   fn <- "SEKIlakes_ExampleData.csv"
#   in.dir <- "//LAR-FILE-SRV/DATA/NPS/SDraw/data"    # without file ext, to match behavior of read/writeOGR
#   header <- TRUE
  # ------------------------------------------------------------------------------
  
  fn <- dat$shape.in.entry$getText()
  in.dir <- dat$shape.in.dir$getText()
  
  datframe <- getDataFrame(fn,in.dir)

  nms <- names(datframe)
  typ <- unlist(lapply(names(datframe), function(x){class(data.frame(datframe)[,x])}))
  
  ftyp <- 'VARIABLES'
  
  # Set frame info title
  dat$finfo.title$setText(paste("Frame Contents:    \n", length(datframe), toupper(ftyp)))
  
  # Add the variable names to the dialog box, first clear any existing labels
  lapply(2:length(dat$name.labs), function(x,lablist){lablist[[x]]$hide()}, lablist=dat$name.labs)
  lapply(2:length(dat$type.labs), function(x,lablist){lablist[[x]]$hide()}, lablist=dat$type.labs)
  
  f.labtxt <- function(x,lablist,txt){
    lablist[[x+1]]$setText(txt[x])
    lablist[[x+1]]$show()
  }
  nn <- min(length(nms),length(dat$name.labs)-1)
  lapply(1:nn, f.labtxt, lablist=dat$name.labs, txt=nms )
  lapply(1:nn, f.labtxt, lablist=dat$type.labs, txt=typ )
  
  if( length(nms) > (length(dat$name.labs)-1) ){
    dat$name.labs[[nn+1]]$setText(paste("<list truncated>"))
    dat$type.labs[[nn+1]]$setText(paste("<first", nn-1, "displayed>"))
  }
  
}