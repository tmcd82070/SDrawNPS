my.write.csv <- function(x,dat){
  #
  #   for next version, call this "Export Sample" 
  #   and open a dialog and ask for the format (from amoung those 
  #   supported by writeOGR - see ogrDrivers()$name
  
  outobj <- dat$out.r.entry$getText()
  
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

    # This is how one creates a dialog with buttons and associated response codes.
    dialog <- gtkFileChooserDialog("Export Sample As...", dat$parent.window, "save",
                                   "gtk-save", GtkResponseType["accept"], 
                                   "gtk-cancel", GtkResponseType["cancel"])
    
    #   Define the "extra Widget" for format, and add it to the FileChooseDialog    
    export.formats <- c("Comma Separated (.CSV)")#, "Excel (.XLSX)" )
    export.format.combo <- gtkComboBoxNewText()
    export.format.combo$show()
    for( i in export.formats ){
      export.format.combo$appendText( i )
    }
    export.format.combo$setActive(0)
    
    combo.box <- gtkHBoxNew(FALSE, 8)
    combo.box$setBorderWidth(8)
    combo.box$add( export.format.combo ) # put the combo box in a HBox to get the spacing
    
    export.format.frame <- gtkFrameNew("Export format:")
    export.format.frame$setBorderWidth(8)
    export.format.frame$add( combo.box )
    
    dialog$setExtraWidget( export.format.frame )
    
    # run dialog    
    if (dialog$run() == GtkResponseType["accept"]) {
      #   They pressed "Save"
      path.n.filename <- dialog$getFilename()
      out.format <- export.format.combo$getActiveText()
      dialog$destroy()
      
      if( length(grep("CSV", out.format)) > 0 ){
        path.n.filename <- extractPathFilename(path.n.filename)
        if( exists( paste0( outobj,".cont"), envir=.GlobalEnv) ){
          write.csv( samp.cont[[1]],paste0(path.n.filename$path,'/',path.n.filename$file,'_CDF.csv'))
          write.csv( samp.cont[[2]],paste0(path.n.filename$path,'/',path.n.filename$file,'_Pct.csv'))
        }
        if( exists( paste0( outobj,".cat"), envir=.GlobalEnv) ){
          write.csv( samp.cat,paste0(path.n.filename$path,'/',path.n.filename$file,'_Cat.csv'))
        }
      } 
      
    } else {
      dialog$destroy()
    }
      
  } else {
    error.message( paste( "Sample object(s) '", samp.nm.cont,"' and/or '", samp.nm.cat, "' not found. Hit RUN before EXPORT.\n", sep=""))
  }
  
}
