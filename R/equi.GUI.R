#' @export equi.GUI
#'   
#' @title Graphic User Interface (GUI) for selection of equi-probable samples.
#'   
#' @description Initiates a dialog box which provides a GUI to selection of
#'   equi-probable samples from 2-D resources.
#' 
#' @return Nothing is returned by the function.  The sample object will be stored in the 
#' current workspace, and any export files will be on the hard drive. Any maps 
#' drawn during the life of the dialog will remain afte the dialog closes. 
#' 
#' @details This routine is intended to be called from the 'SDraw' menu, but it can also 
#'   be called from the command line. This routine uses the RGtk2 package windowing 
#'   capabilities to construct a dialog box which pops up on the screen. In the 
#'   dialog box, users specify input parameters to other routines, 
#'   then press 'Run' to draw the sample.  
#'   
#'   The minimum requirements to drawn an equal probability 
#'   sample using the dialog are as follows:
#'     \enumerate{
#'       \item Select the 'Sampling Type' (BAS, GRTS, or SSS) in the top drop down list.
#'       \item Specify sample size in 'Sample Size (n)' box
#'       \item Click 'Browse' button beside the 'Shape file' box to browse for 
#'       a shapefile containing one or more 2-D polygons outlining the study area.  The 
#'       name of a shape file (without the .shp extention) can also be 
#'       typed into the 'Shape file' box, provided the shape file resides 
#'       in the current directory (i.e., the one returned by \code{getwd()}). 
#'       Once the shapefile is specified and before other parameters are specified, 
#'       the user can click the 'Map' button
#'       to display the shape file. This is a good way to check the study area
#'       boundary.
#'       \item Specify the output object's name in the 'Sample's R name' box. This
#'       output object is a 'SpatialPointsDataFrame' (from the 'sp' package)
#'       containing the selected sample points in BAS or GRTS order.
#'       \item Hit 'Run'
#'     } 
#'   
#'   Optional parameters are the number of points in the 'Over sample', and the
#'   'Random number seed'.  
#'   
#'   Over sample points are listed at the bottom of the output
#'   object and can be identified using (output$pointType == "OverSample"), where 'output'
#'   is the sample's R name.  
#'   
#'   If a random number seed is specified, the same sample 
#'   is output every time the 'Run' button is pressed.  In some cases, it may be 
#'   important to replicate the sample draw exactly, and this is accomplished by 
#'   specifying the same random number seed.   Any integer value is accpetable 
#'   as the random number seed. 
#'   
#'   The 'Run' button: After all required and optional inputs are specified, the 'Run'
#'   Button actually draws the sample and places it in the output 'SpatialPointsDataFrame' 
#'   object.
#'   
#'   The 'Map' button: After the shapefile is specified, pressing the 'Map' button
#'   displays a plot of the shape file. After the sample has been drawn, 
#'   the 'Map' button displays a plot of the study area as well as locations 
#'   of the sample and over-sample (if present) points. 
#'   
#'   The 'View Sample' button: After the sample has been drawn, the 'View Sample' 
#'   button displays the sample points in a separate spreadsheet-like window.  
#'   No editing is allowed. 
#'   
#'   The 'Export' button: After the sample has been drawn, the 'Export' button 
#'   brings up a save file dialog box which allows the user to specify the name
#'   of a file to contain the sample.  From this dialog box, the sample can be 
#'   exported in the following formats: ArcGIS shapefile (.SHP); Comma Separated (.CSV); 
#'   Google Earth (.KML); and Garmin format (.GPX). Shapefiles actually consist 
#'   of 3 or 4 files.  
#'   When exporting to a shapefile, 
#'   do not include the .SHP extension in the 'Name' field because the  
#'   associated files have different extensions. 
#'   
#'   The 'Done' button: Dismisses the dialog box, leaving the sample object in the 
#'   .GlobalEnv workspace. 
#' 
#' @author Trent McDonald (tmcdonald@west-inc.com)
#'   
#' @seealso \code{\link{bas}}, \code{\link{bas.polygon}},
#'   \code{\link{bas.line}}, \code{\link{bas.point}}, \code{\link{sss.polygon}},
#'   \code{\link{halton}}
#'   
#' @references Robertson, B. L., J. A. Brown, T. L. McDonald, and P. Jakson
#'   (2013). BAS: Balanced acceptance sampling of natural resources. Biometrics
#'   69, 776-784.
#'   
#'   Stevens, D. L. and A. R. Olsen (2004). Spatially balanced sampling of 
#'   natural resources. Journal of the American Statistical Association 99,
#'   262-278.
#' 
#' @keywords design survey 
#'
#' @examples
#' 
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
    shape.file.label <- gtkLabel("Shape file OR 'sp' Object:")
    
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
