#' @export equi.GUI
#'   
#' @title Graphic User Interface (GUI) for selection of equi-probable samples.
#'   
#' @description Initiates a dialog box via a GUI to select equi-probable samples
#'   from 2-D resources.
#'   
#' @return  A \code{SpatialDesign} (see the \code{spsurvey} package) object with
#'   the name specified by the user in the GUI\'s \code{Sample\'s R name} box. 
#'   This object contains the sampling design specifications, the selected 
#'   sample points in GRTS order, coordinates, and projection information. 
#'   Sample objects are stored in the current workspace, while any export files,
#'   including a \code{txt} log of the commands utilized to generate the sample,
#'   are saved to the file directory specified via \code{getwd}.
#'   
#'   Any maps drawn during the sampling process must be saved before R is 
#'   closed. See \code{dev.copy}, \code{jpg}, and other graphics device 
#'   functions.
#'   
#' @details This routine is intended to be called from the \code{SDrawNPS} menu,
#'   but it can also be called from the command line in non-interactive 
#'   environments, such as RStudio. This routine uses the \code{RGtk2} package 
#'   windowing capabilities to construct a pop-up dialog box, or GUI. In the 
#'   dialog box, users specify at least the required input parameters, then 
#'   press the \sQuote{Run} button to draw the sample.
#'   
#'   On submission, the GUI internally packages its inputs, processes the 
#'   necessary shapefile, and executes the \code{spsurvey}-package \code{grts} 
#'   function. All \code{SDrawNPS} GUI submissions utilizing the GRTS sampling
#'   methodology lead to the creation of a text-based log file, which records
#'   all code utilized. The log file thus serves as a historical record
#'   containing sampling information, including the random seed utilized.  It
#'   also serves as a tool for enhancing methodological understanding.
#'   
#'   See \sQuote{References} for additional resources.
#'   
#' @section Required Inputs:
#'   
#'   \enumerate{
#'   
#'   \item Select \code{GRTS} as the \code{Sample Type} in the top drop-down 
#'   list. The other sampling types are not currently available.
#'   
#'   \item Specify sample size in the 'Sample Size (n)' box.
#'   
#'   \item Specify the shapefile or \code{SpatialPoints*}, \code{SpatialLines*},
#'   or \code{SpatialPolygons*} package-\code{sp} object that constitutes the 
#'   sample frame in the \code{Shapefile} box, or click \sQuote{Browse} to 
#'   browse for a shapefile with a \code{.shp} extension. When specifying the 
#'   name of a shapefile via use of the input box, do not include the 
#'   \code{.shp} extension and recognize that all files associated with the 
#'   shapefile must reside in the current working directory, i.e., the one 
#'   returned by \code{getwd}. Following selection of a spatial object or 
#'   shapefile, click the \sQuote{Inspect Frame} button to plot it and list 
#'   variables associated with its attribute data.  This is a good way to 
#'   determine the study area boundary.
#'   
#'   \item Specify the sample\'s R object name. The output will be a 
#'   \code{SpatialDesign} object created via the \code{spsurvey} package, and 
#'   contains the sampling design specifications and selected sample points in 
#'   GRTS order, along with spatial coordinates and projection information.
#'   
#'   }
#'   
#' @section Optional Inputs:
#'   
#'   \enumerate{
#'   
#'   \item The number of \sQuote{Over sample, each strata} points can be 
#'   specified within each stratum. Oversample points are listed after the main 
#'   sample points in the GRTS design file, i.e., the resulting sample R output 
#'   object.  (does this mean they're in the attribute data?  i think maybe so. 
#'   this is better shapefile language.  we will need to check.)
#'   
#'   True with equi.GUI??: They can also be identified in the \sQuote{panel} 
#'   field (variable?) of the sample output. Apply caution when specifying 
#'   oversample points, as large oversamples can cause samples to tend toward a 
#'   proportional-to-size allocation even when other allocations are specified. 
#'   (reference?)
#'   
#'   \item The \sQuote{Random number seed.} When specified, the seed may be
#'   used to recreate the sample. When not specified, i.e., the box is left
#'   blank, a random seed is selected against the current time.  See
#'   \code{set.seed}. In both cases, the seed ultimately utilized is recorded in
#'   both the resulting log text file and R Console. Recording the seed allows
#'   for the easy redrawing of samples if lost, or if more sites are needed. 
#'   Any integer value is accpetable as the random number seed.
#'   
#'   }
#'   
#' @section Dialog Buttons:
#'   
#'   \enumerate{
#'   
#'   \item \sQuote{Run.} After specifying all required and optional inputs, the 
#'   \sQuote{Run} button draws the sample.  The \code{.GlobalEnv} workspace 
#'   holds the resulting \code{SpatialPointsDataFrame} (sampledesign object? not
#'   sure) with the name specified via the GUI \code{Sample\'s R name} box.  A 
#'   confirmation dialog appears following completion of the draw. Large samples
#'   may require several tens of minutes for completion.
#'   
#'   \item \sQuote{Plot Sample.} Following sampling, the \sQuote{Plot Sample} 
#'   button displays the sampled points on the sampling frame.
#'   
#'   \item \sQuote{Tabulate Sample.} Following sampling, display the GRTS design
#'   file in a tabular format.  The GRTS design file contains information on 
#'   each sampled unit, such as coordinates, and design variables, e.g., stratum
#'   or multi-density category.  It also contains design weights. true equi.gui?
#'   
#'   \item \sQuote{Export.} Following sampling, the \sQuote{Export} button 
#'   prompts the user to save sampling results via a pop-up dialog box. The 
#'   sample can be exported as an ArcGIS shapefile (\code{.SHP}); Comma 
#'   Separated (\code{.CSV}); Google Earth (\code{.KML}); or Garmin format 
#'   (\code{.GPX}) file.
#'   
#'   Shapefiles actually consist of several files with different 
#'   extensions. Because of this, do not include the \code{.SHP} extension in 
#'   the \code{Name} field of the pop-up when exporting to a shapefile.
#'   
#'   \item \sQuote{Done.} Dismisses the GUI dialog box, leaving any sample 
#'   objects in the \code{.GlobalEnv} workspace.
#'   
#'   }
#'   
#'   Language here similar to stratified.GUI language that talks about using the 
#'   \code{table} function?  
#'   
#' @author Trent McDonald (tmcdonald@@west-inc.com)
#'   
#' @seealso \code{\link{spsurvey::grts}}
#'   
#' @references Stevens, D. L. and A. R. Olsen (2004). Spatially balanced sampling of 
#'   natural resources. Journal of the American Statistical Association 99, 
#'   262-278.
#'  
#'   Kincaid, T. (2015). GRTS Survey Designs for an Area Resource. Accessed online May 6, 2016.  
#'   \code{https://cran.r-project.org/web/packages/spsurvey/vignettes/Area_Design.pdf}.
#'   
#'   Starcevich L. A., DiDonato G., McDonald T., Mitchell, J. (2016). A GRTS
#'   User\'s Manual for the SDrawNPS Package: A graphical user interface for
#'   Generalized Random Tessellation Stratified (GRTS) sampling and estimation. 
#'   National Park Service, U.S. Department of the Interior.  Natural Resource
#'   Report NPS/XXXX/NRR—20XX/XXX.
#'   
#' @keywords design survey
#'   
#' @examples
#' # Open a GUI for equi-probable sampling.
#' equi.GUI()
#' 
equi.GUI <- function()   {
#
#   Setup and run a GUI to take a BAS sample 
#



    #   ---- Define the main window
    win <- gtkWindowNew("toplevel")
    win$setSizeRequest(750,350)
    win$setBorderWidth(8)
    win$setTitle("SDrawNPS : Equiprobable sample drawing interface")
    #gtkWindowSetIconFromFile(win, filename = "s-draw.ico")  # need path to be correct here, or does not work, obviously

    vbox1 <- gtkVBoxNew(FALSE, 8)
    vbox1$setBorderWidth(8)
    win$add(vbox1)

    # ================= Sample type frame ============================
    samp.types <- c("HAL - Halton Lattice Sampling", "BAS - Balanced Acceptance Sampling", "GRTS - Generalized Random Tessellation Stratified", 
            "SSS - Simple Systematic Sampling")
    samp.type.combo <- gtkComboBoxNewText()
    samp.type.combo$show()
    for( i in samp.types ){
        samp.type.combo$appendText( i )
    }
    samp.type.combo$setActive(2)
    
#    print(gtkComboBoxGetActive(samp.type.combo))
#    print(gtkComboBoxGetWrapWidth(samp.type.combo))

    samp.type.frame <- gtkFrameNew("Sample Type")
    samp.type.frame$setBorderWidth(8)
    
    combo.box <- gtkHBoxNew(FALSE, 8)
    combo.box$setBorderWidth(8)
    combo.box$packStart( samp.type.combo )
    samp.type.frame$add( combo.box )

    hbox2 <- gtkHBoxNew(FALSE, 8)
    #hbox2$setBorderWidth(8)
    hbox2$packStart(samp.type.frame)

#    logo <- gtkImageNewFromFile("s_draw_banner.png")
#    hbox2$packStart(logo)


    vbox1$packStart(hbox2)



    # --------------------------- Middle horizontal box ---------------
    hbox1 <- gtkHBoxNew(FALSE, 8)
    hbox1$setBorderWidth(8)
    vbox1$add(hbox1)



    # ================= Required Inputs frame ============================
    req.frame <- gtkFrameNew("Required Inputs")
    hbox1$add(req.frame)

    #   ---- Define a verticle box
    req.vbox <- gtkVBoxNew(FALSE, 8)
    req.vbox$setBorderWidth(8)
    req.frame$add(req.vbox)


    #   ---- Define table of boxes so everything aligns
    tbl <- gtkTable(3,2,FALSE)
    gtkTableSetRowSpacings(tbl,1)
    gtkTableSetColSpacings(tbl,5)

    req.vbox$packStart(tbl)

    #   ---- Sample size text box
    n.entry <- gtkEntry()
    n.entry$setText( "" )
 
    samp.size.label <- gtkLabel("Sample size (n):")

    gtkTableAttach(tbl,samp.size.label, 0, 1, 0, 1, xpadding=5, ypadding=5)
    gtkTableAttach(tbl,n.entry, 1, 2, 0, 1, xpadding=5, ypadding=5)

    #   ---- Input shape file and directory box
    shape.in.entry <- gtkEntry()
    shape.in.entry$setText( "" )
    shape.file.label <- gtkLabel("Shapefile OR 'sp' Object:")
    
    shape.in.dir <- gtkEntry()  # this entry box is hidden/not displayed
    shape.in.dir$setText( getwd() )

    #   ---- Output R object box
    out.r.entry <- gtkEntry()
    out.r.entry$setText("")#paste("sdraw.", format(Sys.time(), "%Y.%m.%d.%H%M%S"), sep=""))
    out.r.label <- gtkLabel("Sample's R name:")
    
    gtkTableAttach(tbl,out.r.label, 0, 1, 2, 3, xpadding=5, ypadding=5) 
    gtkTableAttach(tbl,out.r.entry, 1, 2, 2, 3, xpadding=5, ypadding=5)
 

    shape.file.box <- gtkHBox(FALSE, 10)
    browse.b <- gtkButton("Browse")
    gSignalConnect(browse.b, "clicked", browse.for.shapefile,data=list(
        shape.in.entry = shape.in.entry,
        shape.in.dir = shape.in.dir, 
        out.r.entry = out.r.entry,
        parent.window = win
    ))
    
   
    shape.file.box$packEnd(browse.b)
    shape.file.box$packStart(shape.in.entry)

    gtkTableAttach(tbl,shape.file.label, 0, 1, 1, 2, xpadding=5, ypadding=5)
    gtkTableAttach(tbl,shape.file.box, 1, 2, 1, 2, xpadding=5, ypadding=5)

    



    # =========================== Optional inputs frame ================================
    opt.frame <- gtkFrameNew("Optional Inputs")
    hbox1$add(opt.frame)

    opt.vbox <- gtkVBoxNew(FALSE, 8)
    opt.vbox$setBorderWidth(8)
    opt.frame$add(opt.vbox)

    #   ---- Define table of boxes so everything aligns
    opt.tbl <- gtkTable(3,2,FALSE)
    gtkTableSetRowSpacings(tbl,1)
    gtkTableSetColSpacings(tbl,5)

    opt.vbox$add(opt.tbl)

    #   ---- Over sample size text box
    over.entry <- gtkEntry()
    over.entry$setText( "0" )
    over.size.label <- gtkLabel("Over sample:")

    gtkTableAttach(opt.tbl,over.size.label, 0, 1, 0, 1, xpadding=5, ypadding=5)
    gtkTableAttach(opt.tbl,over.entry, 1, 2, 0, 1, xpadding=5, ypadding=5)

    #   ---- Seed text box
    seed.entry <- gtkEntry()
    seed.entry$setText( "" )
    seed.label <- gtkLabel("Random number seed:")

    gtkTableAttach(opt.tbl,seed.label, 0, 1, 1, 2, xpadding=5, ypadding=5)
    gtkTableAttach(opt.tbl,seed.entry, 1, 2, 1, 2, xpadding=5, ypadding=5)

#    # =========================== Frame Type ================================
#    samp.type.frame <- gtkFrameNew("Frame Type")
#    hbox1$add(samp.type.frame)
#
#    stype.box <- gtkVBoxNew(TRUE, 2)
#    samp.type.frame$add( stype.box )
#
#    area.rb <- gtkRadioButton(label="Area\n(polygon shapefile)")
#    line.rb <- gtkRadioButtonNewWithLabelFromWidget(area.rb,"Linear\n(line shapefile)")
#    disc.rb <- gtkRadioButtonNewWithLabelFromWidget(area.rb,"Finite\n(point shapefile)")
#
#
#    stype.box$packStart(area.rb, TRUE, TRUE, 2)
#    stype.box$packStart(line.rb, TRUE, TRUE, 2)
#    stype.box$packStart(disc.rb, TRUE, TRUE, 2)
#
    
#     # =========================== Seed row button ==================================
#     hbox2 <- gtkHBoxNew(FALSE, 8)
#     hbox2$setBorderWidth(8)
#     vbox1$add(hbox2)
#     
#     # add seed box.
#     seed.random.frame <- gtkFrameNew("Generate a random seed?")
#     hbox2$add(seed.random.frame)  # alloc
#     
#     #  Radio Buttons to Specify Sample Weights
#     stype.box <- gtkHBoxNew(TRUE, 2)
#     stype.box$setBorderWidth(8)
#     seed.random.frame$add( stype.box )
#     
#     seedy.rb <- gtkRadioButtonNewWithLabel(label="Yes") #const.rb
#     seedn.rb <- gtkRadioButtonNewWithLabelFromWidget(seedy.rb,label="No")  # prop.rb
# 
#     stype.box$packStart(seedn.rb, TRUE, TRUE, 2)
#     stype.box$packStart(seedy.rb, TRUE, TRUE, 2)
  
    
    # =========================== Bottom row of buttons ==================================

    #   ---- Separator
    gtkBoxPackStart(vbox1, gtkHSeparatorNew(), expand=FALSE)

    #   ---- Define box for row of buttons at bottom
    bbox <- gtkHButtonBox()
    bbox$SetLayout("Spread")                   # Layout can be c("Start", "Edge", "Spread", "End")
    bbox$SetBorderWidth(10)
  
    #   ---- Run button
    run.b <- gtkButton("Run")
    gSignalConnect(run.b, "clicked", run.sample, data=list( 
      samp.type.combo=samp.type.combo,
      n.entry=n.entry,
      shape.in.entry=shape.in.entry,
      shape.in.dir=shape.in.dir,
      out.r.entry=out.r.entry,
      over.entry=over.entry,
      seed.entry=seed.entry
#       seedy.rb=seedy.rb,
#       seedn.rb=seedn.rb
      )
    ) 
    bbox$packEnd(run.b, expand=FALSE)
    
    #   ---- Plot button
    plot.b <- gtkButton("  Plot\nSample")
    gSignalConnect(plot.b, "clicked", plotSample, 
                   data=list(
                     shape.in.entry=shape.in.entry,
                     shape.in.dir=shape.in.dir,
                     out.r.entry=out.r.entry
                   )
    )
    bbox$packEnd(plot.b, expand=FALSE)
    
    #   ---- View button
    view.b <- gtkButton("Tabulate\n Sample")
    gSignalConnect(view.b, "clicked", view.sample, data=list(
      out.r.entry = out.r.entry
    ))
    bbox$packEnd( view.b, expand=FALSE)
  
    # ???   #   ---- Write to csv button
    #    write.csv.b <- gtkButton("Write CSV")
    #    gSignalConnect(write.csv.b, "clicked", SDraw::my.write.csv, data=list(
    #            out.r.entry = out.r.entry
    #    ))
    #    bbox$packEnd( write.csv.b, expand=FALSE)
     
    #   ---- Write to Shapefile button
    write.shp.b <- gtkButton("Export")
    gSignalConnect(write.shp.b, "clicked", my.write.shp, data=list(
      out.r.entry = out.r.entry, 
      parent.window = win            
    ))
    bbox$packEnd( write.shp.b, expand=FALSE)
    
    #   ---- Done button
    cancel.b <- gtkButton("Done")
    gSignalConnect(cancel.b, "clicked", function(x){
      win$Hide();
      win$Destroy()
    })
    bbox$packEnd( cancel.b, expand=FALSE)

    #   ---- Pack the rows of buttons into the vertical box
    vbox1$packEnd( bbox, expand=FALSE)


    #   ---- Finally, show the window

    win$Show()

}
