#' @export unequal.GUI
#'   
#' @title Graphic User Interface (GUI) for selection of unequal probability
#'   samples.
#'   
#' @description Initiates a dialog box via a GUI to select unequal probability
#'   samples from 2-D resources.
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
#'   \itemize{
#'   
#'   \item{Frame Information}
#'   
#'   \enumerate{
#'   
#'   \item Select \code{GRTS} as the \sQuote{Sample Type} in the top drop-down 
#'   list. The other sampling types are not currently available.
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
#'   \item Specify the \sQuote{Name of [the] Continuous:Categorical variable.} 
#'   Note that the label changes depending on the \sQuote{Sample Allocation}
#'   selected.  Continuous variables associate with numeric variables, while
#'   categorical associate with factor and/or character variables.  In all cases,
#'   this variable must be contained in the attribute data of the spatial object
#'   specified in the \code{Shapefile} box. For example, a Continuous-variable
#'   sample, this could be the elevation associated with every point in the
#'   shapefile. This name is case sensitive and must match that in the shapefile
#'   or \code{sp} object exactly.
#'   
#'   \item Specify the sample\'s R object name. The output will be a 
#'   \code{SpatialDesign} object created via the \code{spsurvey} package, and 
#'   contains the sampling design specifications and selected sample points in 
#'   GRTS order, along with spatial coordinates and projection information.
#'   
#'   \item Specify the \sQuote{Sample Allocation} scheme. Available options include 
#'   \sQuote{Continuous} relative to the range of a continuous variable in the 
#'   population; \sQuote{Constant} across all categories of a categorical variable; and 
#'   \sQuote{Unequal proportion} sample sizes within each category of a categorical
#'   variable. Note that units in small categories will have lower probabilities
#'   of inclusion and may not be represented in small overall sample sizes.  
#'   
#'   Additionally, observe that selection of the \sQuote{Continuous} radio
#'   button leads to a \sQuote{Continous Variable} label in the \sQuote{Frame
#'   Information} section of the GUI.  Similarly, a \sQuote{Categorical
#'   Variable} label appears on selection of \sQuote{Constant} or
#'   \sQuote{Unequal proportion.}
#'   
#'   \item Specify the sample size as described above for the appropriate 
#'   allocation scheme.
#'   
#'   }
#'   
#'   \item{Sample Allocation & Sample Size}
#'   
#'   \enumerate{
#'   
#'   \item If the allocation scheme is \sQuote{Continous,} enter one number for
#'   \sQuote{Sample Size.} This number will be distributed among the range based on
#'   the values in the provided \sQuote{Continuous Variable.}
#'   
#'   \item If the allocation scheme is \sQuote{Constant,} enter one number for 
#'   \sQuote{Sample Size.} This number will be selected across all categories,
#'   with the number of sample points resulting in each category proportional to
#'   the number in each level of the provided \sQuote{Categorical Variable.}  The
#'   count of all points across all levels then equals the number originally 
#'   entered.  (check this)
#'   
#'   \item If the allocation scheme is \sQuote{Unequal Proportion,} enter a list
#'   of numbers separated by commas for\sQuote{Sample Size.} If there are
#'   \eqn{H} categories in the frame, specify \eqn{H} numbers, i.e., one number
#'   per category. Order of sample sizes should be the same as the levels of the
#'   categorical variable, as with a factor. In fact, to match sample sizes to
#'   categories, SDrawNPS calls function \code{factor} to extract factor levels
#'   of the categorical variable. The order of these levels is the order of
#'   samples sizes in the list. For example, if the categorical variable
#'   contains strings \code{"small"} and \code{"big"}, converting this variable
#'   to a factor generally results in alphabetic ordering of levels, as in
#'   \code{c("big", "small")}. In this case, the first number in the specified
#'   list should be the sample size in the \code{"big"} category. The default
#'   ordering of levels when vectors are converted to factors is alphabetic,
#'   unless global options have changed.
#'   
#'   }
#'   
#'   }
#'   
#' @section Optional Inputs:
#'   
#'   \enumerate{
#'   
#'   \item The \sQuote{Random number seed.} When specified, the seed may be used
#'   to recreate the sample. When not specified, i.e., the box is left blank, a 
#'   random seed is selected against the current time.  See \code{set.seed}. In 
#'   both cases, the seed ultimately utilized is recorded in both the resulting 
#'   log text file and R Console. Recording the seed allows for the easy 
#'   redrawing of samples if lost, or if more sites are needed. Any integer 
#'   value is accpetable as the random number seed.
#'   
#'   \item The number of \sQuote{Over sample, each strata} points can be 
#'   specified within each stratum. Oversample points are listed after the main 
#'   sample points in the GRTS design file, i.e., the resulting sample R output 
#'   object.  (does this mean they're in the attribute data?  i think maybe so. 
#'   this is better shapefile language.  we will need to check.) They can also 
#'   be identified in the \sQuote{panel} field (variable?) of the sample output.
#'   Apply caution when specifying oversample points, as large oversamples can 
#'   cause samples to tend toward a proportional-to-size allocation even when 
#'   other allocations are specified.  (reference?)
#'   
#'   }
#'   
#' @section Dialog Buttons:
#'   
#'   \enumerate{
#'   
#'   \item \sQuote{Inspect Frame.} After specifying the shapefile or \code{sp} 
#'   object name, pressing the \sQuote{Inspect Frame} button plots the 
#'   shapefile. It also lists the variables and their class in the shapefile\'s 
#'   attribute data.  After drawing a sample, the \sQuote{Inspect Frame} button 
#'   plots of the study area, along with sampled points.
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
#'   or multi-density category.  It also contains design weights.
#'   
#'   \item \sQuote{Export.} Following sampling, the \sQuote{Export} button 
#'   prompts the user to save sampling results via a pop-up dialog box. The 
#'   sample can be exported as an ArcGIS shapefile (\code{.SHP}); Comma 
#'   Separated (\code{.CSV}); Google Earth (\code{.KML}); or Garmin format 
#'   (\code{.GPX}) file.
#'   
#'   Shapefiles actually consist of several files with different extensions.
#'   Because of this, do not include the \code{.SHP} extension in the
#'   \code{Name} field of the pop-up when exporting to a shapefile.
#'   
#'   \item \sQuote{Done.} Dismisses the GUI dialog box, leaving any sample 
#'   objects in the \code{.GlobalEnv} workspace.
#'   
#'   }
#'   
#'   is true in unequal.gui?  After the sample draw, one can check allocation
#'   sample sizes in each stratum using the \code{table} function. For example,
#'   if the output R name is \code{samp}, one can check sample sizes with
#'   \code{table(samp$stratum)}. One can plot the study area and sample points
#'   with \code{plot(frame); points(samp)}, assuming \code{frame} is the
#'   \code{sp} object containing the frame.  (this how-to-do-it stuff should
#'   really be in the examples but having to use the GUI to get results makes it
#'   weird.)
#'   
#' @author Trent McDonald (tmcdonald@@west-inc.com) and Jason Mitchell 
#'   (jmitchell@@west-inc.com)
#'   
#' @seealso \code{\link{spsurvey::grts}}
#'   
#' @references Stevens, D. L. and A. R. Olsen (2004). Spatially balanced 
#'   sampling of natural resources. Journal of the American Statistical 
#'   Association 99, 262-278.
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
#' # Open a GUI for stratified sampling.
#' stratified.GUI()
#'     
unequal.GUI <- function()   {
  #
  #   Setup and run a GUI to take a BAS sample 
  #
  
  design <- "unequal"
  
  #   ---- Define the main window
  win <- gtkWindowNew("toplevel")
  win$setBorderWidth(8) 
  win$setTitle("SDrawNPS : Unequal probability sample drawing interface")
  #gtkWindowSetIconFromFile(win, filename = "s-draw.ico")  # need path to be correct here, or does not work, obviously
  
  vbox1 <- gtkVBoxNew(FALSE, 8)
  vbox1$setBorderWidth(8)
  win$add(vbox1)
  
  # ================= Sample type frame ============================
  samp.types <- c("HAL - Halton Lattice Sampling", 
                  "BAS - Balanced Acceptance Sampling", 
                  "GRTS - Generalized Random Tessellation Stratified", 
                  "SSS - Simple Systematic Sampling")
  
  #this adds different sampling frames
  #I don't forsee adding anything other than BAS, GRTS, or SSS  -- HAL!!!
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
  #this adds a label to the combo box
  
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
  
  #   Handler for change in sample type
  f.samp.type.change <- function(x,dat){
    stype <- samp.type.combo$getActive()
    
    #  Carefull, don't get the numbers out of order with the options
    if( stype == 0 ){
      # Halton samples
      over.entry$hide()
      over.size.label$hide()
    } else if( stype == 1 ){
      # BAS samples
      over.entry$hide()
      over.size.label$hide()        
    } else if( stype == 2 ){
      # GRTS samples
      over.entry$show()
      over.size.label$show()
    } else {
      # sss samples
      over.entry$hide()
      over.size.label$hide()
    }
    
    
  }
  gSignalConnect(samp.type.combo, "changed", f.samp.type.change )
  
  
  
  # ------ Optional inputs box
  opt.hbox <- gtkHBoxNew(TRUE, 2)
  opt.hbox$setBorderWidth(8)
  hbox2$packStart(opt.hbox)
  
  opt.frame <- gtkFrameNew("Optional Inputs")
  opt.hbox$packStart(opt.frame)
  
  #    opt.blank.box <- gtkHBoxNew(TRUE,2)
  #    opt.hbox$packStart(opt.blank.box)
  
  opt.vbox <- gtkVBoxNew(FALSE, 8)
  opt.vbox$setBorderWidth(8)
  opt.frame$add(opt.vbox)
  
  
  #   ---- Define table of boxes so everything aligns
  opt.tbl <- gtkTable(7,5,FALSE)
  gtkTableSetRowSpacings(opt.tbl,1)
  gtkTableSetColSpacings(opt.tbl,5)
  
  opt.vbox$add(opt.tbl)
  
  #   ---- Over sample size text box
  over.entry <- gtkEntry()
  over.entry$setText( "0" )
  over.size.label <- gtkLabel("Over sample, total over all categories:")
  
  gtkTableAttach(opt.tbl,over.size.label, 0, 1, 1, 2, xpadding=5, ypadding=5)
  gtkTableAttach(opt.tbl,over.entry, 1, 2, 1, 2, xpadding=5, ypadding=5)
  
  #   ---- Seed text box
  seed.entry <- gtkEntry()
  seed.entry$setText( "" )
  seed.label <- gtkLabel("Random number seed:")
  
  gtkTableAttach(opt.tbl,seed.label, 0, 1, 0, 1, xpadding=5, ypadding=5)
  gtkTableAttach(opt.tbl,seed.entry, 1, 2, 0, 1, xpadding=5, ypadding=5)
  
#   #   ---- Over sample size text boxes
#   over.entry <- gtkEntry()
#   over.entry$setText( "0" )
#   over.size.label <- gtkLabel("Over sample, total over all categories:")
#   
#   # Hide initially because Halton Latice is initial sample type
#   over.entry$hide()
#   over.size.label$hide()
#    
#   gtkTableAttach(opt.tbl,over.size.label, 0, 1, 1, 2, xpadding=5, ypadding=5)
#   gtkTableAttach(opt.tbl,over.entry, 1, 2, 1, 2, xpadding=5, ypadding=5)
  
  # --------------------------- Middle horizontal box ---------------
  req.frame <- gtkFrameNew("Required Inputs")
  vbox1$packStart(req.frame)
  
  hbox1 <- gtkHBoxNew(FALSE, 8) #sets up middle horizontal box, FALSE means things not evenly spaced, 8 is for 8 pixels between things
  hbox1$setBorderWidth(8)
  req.frame$add(hbox1) #this adds the new horizontal box to the frame which is in the overall vertical box.  we are building the window vertically
  
  
  
  # ================= Required Inputs frame ============================
  frame.frame <- gtkFrameNew("Frame Information")
  hbox1$add(frame.frame)  # Adds the frame to the horizontal box
  
  #   ---- Define a verticle box
  req.vbox <- gtkVBoxNew(FALSE, 8)
  req.vbox$setBorderWidth(8)
  frame.frame$add(req.vbox)
  
  
  #   ---- Define table of boxes so everything aligns
  tbl <- gtkTable(7,4,FALSE) #3 rows, 2 columns, FALSE for nonhomogeneous
  gtkTableSetRowSpacings(tbl,1) #1 pixel between rows
  gtkTableSetColSpacings(tbl,5) #5 pixels between columns
  
  req.vbox$packStart(tbl)
  
  
  #   ---- Input shape file box
  shape.in.entry <- gtkEntry()
  shape.in.entry$setText( "" )
  shape.file.label <- gtkLabel("Shapefile OR 'sp' Object:")
  
  shape.in.dir <- gtkEntry()  # this entry box is hidden/not displayed
  shape.in.dir$setText( getwd() )
  
  #out.r.entry <- gtkEntry()
  #out.r.entry$setText( "" )
  
  #   ---- Output R object box
  out.r.entry <- gtkEntry()
  out.r.entry$setText("")#paste("sdraw.", format(Sys.time(), "%Y.%m.%d.%H%M%S"), sep=""))
  out.r.label <- gtkLabel("Sample's R name:")
  
  gtkTableAttach(tbl,out.r.label, 0, 1, 3, 4, xpadding=5, ypadding=5)
  gtkTableAttach(tbl,out.r.entry, 1, 2, 3, 4, xpadding=5, ypadding=5)
  
  
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
  
  # #   ---- Stratum Names
  unequal.var.entry <- gtkEntry()
  unequal.var.entry$setText( "" )
  
  
  # jason add 6/16/2015
  f.write.var.label <- function(x,dat){
    prop.active <- cont.rb$getActive()
    const.active <- const.rb$getActive()
    
    if(prop.active){
      unequal.var.label$setText("Name of Continuous Variable:")
    } else if( const.active ){
      unequal.var.label$setText("Name of Categorical Variable:")
    } else {
      # Note, because the three buttons are in a group, you don't need signal for the last one
      unequal.var.label$setText("Name of Categorical Variable:")
    }
  }
  
  unequal.var.label <- gtkLabel("Name of Continuous Variable:")   # basically the default display when first opened

  
  gtkTableAttach(tbl,unequal.var.label, 0, 1, 2, 3, xpadding=5, ypadding=5)
  gtkTableAttach(tbl,unequal.var.entry, 1, 2, 2, 3, xpadding=5, ypadding=5)
  
  
  
  
  # ============================ Sample Allocation frame ===========
  #hbox1 <- gtkHBoxNew(FALSE, 8) #sets up another horizontal box, FALSE means things not evenly spaced, 8 is for 8 pixels between things
  #hbox1$setBorderWidth(8)
  #vbox1$add(hbox1)
  
  samp.alloc.frame <- gtkFrameNew("Sample Allocation")
  hbox1$add(samp.alloc.frame)
  
  #  Radio Buttons to Specify Sample Allocation 
  stype.box <- gtkVBoxNew(TRUE, 2)
  stype.box$setBorderWidth(8)
  samp.alloc.frame$add( stype.box )
  
  cont.rb <- gtkRadioButtonNewWithLabel(label="Continuous")
  const.rb <- gtkRadioButtonNewWithLabelFromWidget(cont.rb,"Constant")
  uneqprop.rb <- gtkRadioButtonNewWithLabelFromWidget(cont.rb,"Unequal Proportion")
  #user.entry <-gtkEntry()
  #user.entry$setText( "" ) #keep box blank
  
  stype.box$packStart(cont.rb, TRUE, TRUE, 2)
  stype.box$packStart(const.rb, TRUE, TRUE, 2)
  stype.box$packStart(uneqprop.rb, TRUE, TRUE, 2)
  #stype.box$packStart(user.entry, TRUE, TRUE, 2) 
  #this creates a box next to the user-specified button
  #it would be nice to only have this box pop up if the user-specified button is clicked
  
  f.write.sample.label <- function(x,dat){
    prop.active <- cont.rb$getActive()
    const.active <- const.rb$getActive()
    
    if(prop.active){
      n.label$setText("Specify: total n across\n\tcontinous variable range")
    } else if( const.active ){
      n.label$setText("Specify: total n across\n\tall categories")
    } else {
      # Note, because the three buttons are in a group, you don't need signal for the last one
      n.label$setText("Specify: a comma delimited\n\tlist of n, in alphabetized\n\tcategorical order")
    }
  }
  
  
  gSignalConnect(cont.rb, "toggled", f.write.sample.label )
  gSignalConnect(const.rb, "toggled", f.write.sample.label )
  
  # jason 6/16/2015 - do stuff in the left box when radio buttons toggled.
  gSignalConnect(cont.rb, "toggled", f.write.var.label )
  gSignalConnect(const.rb, "toggled", f.write.var.label )
  
  #   ---- Sample sizes
  
  n.frame <- gtkFrameNew( "Sample Size")
  
  # n.tbl <- gtkTableNew(7,4,homogeneous=FALSE) #Bigger than we need. FALSE for nonhomogeneous
  # gtkTableSetRowSpacings(n.tbl,1) #1 pixel between rows
  # gtkTableSetColSpacings(n.tbl,5) #5 pixels between column
  
  hbox1$add(n.frame)
  
  n.vbox <- gtkVBoxNew(TRUE, 2)
  n.vbox$setBorderWidth(8)
  n.frame$add( n.vbox )
  
  n.entry <- gtkEntry()
  n.entry$setText( "" )
  
  n.label <- gtkLabel("Specify: total n across all\n\tcategories") 
  n.label2 <- gtkLabel(" ")
  
  n.vbox$packStart(n.label)
  n.vbox$packStart(n.entry)
  n.vbox$packStart(n.label2)
  
  # gtkTableAttach(n.tbl,tot.size.label, 0, 1, 0, 1, xpadding=5, ypadding=5)
  # gtkTableAttach(n.tbl,n.entry, 1, 2, 0, 1, xpadding=5, ypadding=5)
  
  
  # =========================== Frame information area ==================================
  
  #   ---- Separator
  vbox1$packStart(gtkHSeparatorNew(), expand=FALSE)
  
  
  finfo.vbox <- gtkHBoxNew(FALSE,2)
  finfo.vbox$setBorderWidth(8)
  vbox1$packStart(finfo.vbox)
  
  finfo.title <- gtkLabel("Frame Type:    \n<pending>")
  finfo.vbox$packStart(finfo.title, expand=FALSE, fill=FALSE)
  
  finfo.vbox$packStart(gtkVSeparatorNew(), expand=FALSE)
  
  max.vars <- 20  # maximum number of variables to display
  n.blank.cols <- 4  # must be even, half place on left and half on right
  
  finfo.tbl <- gtkTable(max.vars+1,n.blank.cols+2,FALSE) #FALSE for nonhomogeneous
  gtkTableSetRowSpacings(finfo.tbl,1) #1 pixel between rows
  gtkTableSetColSpacings(finfo.tbl,5) #5 pixels between columns
  finfo.vbox$packStart(finfo.tbl)
  
  # Allocate the labels
  names.labs <- lapply(1:(max.vars+1), gtkLabel, str="")
  vtypes.labs <- lapply(1:(max.vars+1), gtkLabel, str="")
  
  # Place column header labels
  names.labs[[1]]$setText("VARIABLE")
  vtypes.labs[[1]]$setText("CLASS")
  
  gtkTableAttach(finfo.tbl, names.labs[[1]], (n.blank.cols/2), (n.blank.cols/2)+1, 0,1 )
  gtkTableAttach(finfo.tbl, vtypes.labs[[1]], (n.blank.cols/2)+1, (n.blank.cols/2)+2, 0,1 )
  
  # Place separators
  gtkTableAttach(finfo.tbl, gtkHSeparatorNew(), (n.blank.cols/2), (n.blank.cols/2)+1, 1,2)
  gtkTableAttach(finfo.tbl, gtkHSeparatorNew(), (n.blank.cols/2)+1, (n.blank.cols/2)+2, 1,2)
  
  # Set thier length
  #     f.setlablen <-function(x,lablist){
  #         lablist[[x]]$setWidthChars(25)
  #         #lablist[[x]]$setJustify(GTK_JUSTIFY_LEFT)
  #         #lablist[[x]]$setAlignment(0,.5)
  #     }
  #     names.labs <- lapply(1:(max.vars+1), f.setlablen, lablist=names.labs)
  #     vtypes.labs <- lapply(1:(max.vars+1), f.setlablen, lablist=vtypes.labs)
  
  # place them
  placelabs <-  function(x, lablist, obj, labcol, bcols){
    gtkTableAttach( obj, lablist[[x+1]], bcols+labcol-1, bcols+labcol, x-1+2, x+2) # + 2 for header
  }
  
  lapply(1:max.vars, placelabs, lablist=names.labs, obj=finfo.tbl, labcol=1, bcols=n.blank.cols/2)
  lapply(1:max.vars, placelabs, lablist=vtypes.labs, obj=finfo.tbl, labcol=2, bcols=n.blank.cols/2 )
  
  
  #     blank.labs <- lapply(1:(n.blank.cols+2), gtkLabel, str=" ")
  #     placeblanklabs <-  function(x, lablist, obj, side){
  #       gtkTableAttach( obj, lablist[[side+x]], side+x-1, side+x, 0, 1)
  #     }
  #     lapply(1:(n.blank.cols/2), placeblanklabs, lablist=blank.labs, obj=finfo.tbl, side=0)
  #     lapply(1:(n.blank.cols/2), placeblanklabs, lablist=blank.labs, obj=finfo.tbl, side=(n.blank.cols/2)+1)
  
  # Initial values in columns, and hide all but first
  names.labs[[2]]$setText("<pending>")
  vtypes.labs[[2]]$setText("<pending>")
  lapply(2:max.vars, function(x,lablist){lablist[[x+1]]$hide()}, lablist=names.labs)
  lapply(2:max.vars, function(x,lablist){lablist[[x+1]]$hide()}, lablist=vtypes.labs)
  
  
  
  
  
  # Bottom row of buttons ---------------------------------------------------
  # =========================== Bottom row of buttons ==================================
  
  
  #   ---- Separator
  vbox1$packStart(gtkHSeparatorNew(), expand=FALSE)
  
  
  #   ---- Define box for row of buttons at bottom
  bbox <- gtkHButtonBox()
  bbox$SetLayout("Spread")                   # Layout can be c("Start", "Edge", "Spread", "End")
  bbox$SetBorderWidth(10)
  
  #   ---- Read frame button, but do not draw sample, this displays variables in shapefile
  read.b <- gtkButton("Inspect\n Frame ")
  gSignalConnect(read.b, "clicked", readButtonAction, 
                 data=list(
                   shape.in.entry=shape.in.entry,
                   shape.in.dir=shape.in.dir,
                   out.r.entry=out.r.entry,
                   name.labs=names.labs,
                   type.labs=vtypes.labs, 
                   finfo.title=finfo.title
                 )
  )
  bbox$packEnd(read.b, expand=FALSE)
  
  #   ---- Run button
  run.b <- gtkButton("Run")
  gSignalConnect(run.b, "clicked", run.unequal.sample, data=list( 
    samp.type.combo=samp.type.combo,
    n.entry=n.entry,
    shape.in.entry=shape.in.entry,
    shape.in.dir=shape.in.dir,
    unequal.var.entry=unequal.var.entry,
    out.r.entry=out.r.entry,
    over.entry=over.entry,
    seed.entry=seed.entry, 
    cont.rb=cont.rb,
    const.rb=const.rb, 
    uneqprop.rb=uneqprop.rb
  )
  ) 
  bbox$packEnd(run.b, expand=FALSE)
  
  #   ---- Read frame button, but do not draw sample, this displays variables in shapefile
  plot.b <- gtkButton("  Plot\nSample")
  gSignalConnect(plot.b, "clicked", readButtonAction, 
                 data=list(
                   shape.in.entry=shape.in.entry,
                   shape.in.dir=shape.in.dir,
                   out.r.entry=out.r.entry,
                   name.labs=names.labs,
                   type.labs=vtypes.labs, 
                   finfo.title=finfo.title
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
