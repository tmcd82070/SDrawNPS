\name{SDrawNPS-package}
\alias{SDrawNPS-package}
\alias{GRTS}
\alias{SDrawNPS}

\docType{package}

\title{Selection of spatially balanced samples.}

\description{
SDrawNPS is a GUI interface to a set of R functions that draw Generalized-Random-Tesselation-Stratified (GRTS) samples. Input sampling frames can be points (0-D, finite), lines (1-D, infinite), or polygons (2-D, infinite), and can be contained in ESRI shapefiles (SHP), Google Earth files (KML), Garmin files (GPX), or CSV files.  Functionality to visualize the frame and sample is included.
}

\details{
\tabular{ll}{
Package: \tab SDrawNPS\cr
Type: \tab Package\cr
License: \tab GNU General Public License\cr
Dependencies: \tab RGtk2, sp, spsurvey, utils, rgdal\cr 
}
When SDrawNPS is attached (via \code{library(SDrawNPS)}, a new menu item appears in the (Windows) R interface.  This menu ('SDrawNPS') contains items which call dialog boxes, or Graphical User Interfaces (GUIs) that implement the interface to functions that actually do the work of drawing and analyzing samples.   

The function that actually draws the samples is \code{grts} (for GRTS samples), while the functions that analyzes samples are \code{cat.analysis} and \code{cont.analysis}.  All three are taken straight from package \code{spsurvey}.  The main purpose of SDrawNPS is to provide a simple-to-use interface to these routines.  These routines, however, could be called directly in code if needed.  

GRTS samples can be drawn from resources having at most 2 dimensions.  

The general work flow for drawing a sample from a 2-dimensional resource is as follows:
\tabular{ll}{
1: \tab Open the appropriate item under the SDrawNPS menu (or execute the appropriate GUI function, e.g., \code{equi.GUI()});\cr
2: \tab Select GRTS as the sampling algorithm (GRTS);\cr
3: \tab Input appropriate parameters for the sampling of interest;\cr
4: \tab Browse for a shapefile containing a 2-D polygon of the study area;\cr
5: \tab Hit 'Run'.\cr
} 


}
\author{
Trent McDonald \code{tmcdonald@west-inc.com}, Jason Mitchell, Guy DiDonato, and David Russo wrote the GUI interfaces. Leigh Ann Starcevich wrote the design-weight adjustment routine.  

The GRTS routine comes from package \code{spsurvey}, as do the routines associated with sampling analysis.  All the difficult routines of the GUI interface are in \code{RGtk2}, while routines to handle spatial 
objects are in package \code{sp} and \code{rgdal}.   
}

\references{Kincaid, T. (2015). Analysis of a GRTS Survey Design for a Finite Resource. Accessed online May 6, 2016.. \code{https://cran.r-project.org/web/packages/spsurvey/vignettes/Finite_Analysis.pdf}.
   
Kincaid, T. (2015). Analysis of a GRTS Survey Design for an Area Resource. Accessed online May 6, 2016. 
\code{https://cran.r-project.org/web/packages/spsurvey/vignettes/Area_Analysis.pdf}.

Kincaid, T. (2015). GRTS Survey Designs for an Area Resource. Accessed online May 6, 2016. \code{https://cran.r-project.org/web/packages/spsurvey/vignettes/Area_Design.pdf}.

McDonald, T. L. (2012) Spatial sampling designs for long-term ecological monitoring. In R. A. Gitzen, J. J. Millspaugh, A. B. Cooper, and D. S. Licht (Eds.), \emph{Design and Analysis of Long-term Ecological Monitoring Studies}, Chapter 5, pp. 101-125. Cambridge: Cambridge University Press.

McDonald, T. L. (2015) Sampling Designs for Environmental Monitoring. In B. F. J. Manly and J. A. Navarro Alberto (Eds.), \emph{Introduction to Ecological Sampling}, Chapter 10, pp. 145-166. Boca Raton, FL: CRC Press.

Robertson, B.L., J. A. Brown,  T. L. McDonald, and P. Jaksons (2013) "BAS: Balanced Acceptance Sampling of Natural Resources", Biometrics, v69, p. 776-784.

Starcevich L. A., DiDonato G., McDonald T., Mitchell, J. (2016). A GRTS User\'s Manual for the SDrawNPS Package: A graphical user interface for Generalized Random Tessellation Stratified (GRTS) sampling and estimation. National Park Service, U.S. Department of the Interior.  Natural Resource Report NPS/XXXX/NRR—20XX/XXX.

Stevens, D. L., Jr. and A. R. Olsen (2004) "Spatially balanced sampling of natural resources." Journal of the American Statistical Association 99, 262-278.
}


\seealso{
Documentation for package \code{spsurvey}, available at \code{https://cran.r-project.org/web/packages/spsurvey/spsurvey.pdf}.
}

\examples{
equi.GUI()        # Start the equi-probable interface
stratified.GUI()  # Start the stratified interface
unequal.GUI()     # Start the unstratified interface
analysis.GUI()    # Start the anlaysis interface
}

\keyword{ package }
