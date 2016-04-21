\name{SDrawNPS-package}
\alias{SDrawNPS-package}
\alias{BAS-package}
\alias{BAS}
\alias{GRTS}
\alias{SDrawNPS}

\docType{package}

\title{Selection of spatially balanced samples.}

\description{
SDrawNPS is a GUI interface to a set of R functions that draw 
Balanced-Acceptance-Samples (BAS) and Generalized-Random-Tesselation-Stratified (GRTS) samples. 
Input sampling frames can be points (0-D, finite), lines (1-D, infinite), or polygons (2-D, infinit), 
and can be contained in ESRI shapefiles (SHP), Google Earth files (KML), Garmin files (GPX), 
or CSV files.  Functionality to visualize the frame and sample is included.
}

\details{
\tabular{ll}{
Package: \tab SDrawNPS\cr
Type: \tab Package\cr
License: \tab GNU General Public License\cr
Dependencies: \tab RGtk2, sp, spsurvey, utils, rgdal\cr 
}
When SDrawNPS is attached (via \code{library(SDrawNPS)}, a new menu item appears in the (Windows) R interface.  This 
menu ('SDrawNPS') contains items which call dialog boxes that implement the interface to functions that 
actually do the work of drawing samples.   

The functions that actually draw the samples are \code{bas} (for BAS samples) and \code{grts} (for GRTS samples) and \code{sss.polygon} (for Simple Systematic Samples).  
\code{bas} and \code{sss.polygon} are contained in SDrawNPS.  \code{grts} is taken straight from package \code{spsurvey}.  The main 
purpose of SDrawNPS is to provide a simple-to-use interface to these routines.  These routines, however, could be called
directly in code if needed.  BAS samples of n-dimensional resources (up to a max of n = 99 dimensions) can be drawn. 
GRTS samples can be drawn from resources having at most 2 dimensions.  

The general work flow for drawing an equal probability sample from a 2-dimensional resource is as follows:
\tabular{ll}{
1: \tab Open 'Equi-probable Designs' item under SDraw menu (or execute equi.GUI())\cr
2: \tab Select sampling algorithm (BAS, GRTS, or SSS)\cr
3: \tab Input desired sample size into the 'Sample Size' box\cr
4: \tab Browse for shapefile containing a 2-D polygon of study area \cr
5: \tab Hit 'Run'\cr
6: \tab (optional) Hit 'Map'\cr
7: \tab (optional) Hit 'Export'\cr
} 


}
\author{
Trent McDonald \code{tmcdonald@west-inc.com} wrote the GUI interface parts and the BAS sampling routine. 
The GRTS routine comes from package \code{spsurvey}.  All the difficult  
routines of the GUI interface are in RGtk2, while routines to handle spatial 
objects are in package \code{sp} and \code{rgdal}.   

}
\references{
McDonald, T. L. (2012) Spatial sampling designs for long-term ecological monitoring. In R. A. Gitzen, J. J. Millspaugh, A. B. Cooper, and D. S. Licht (Eds.), \emph{Design and Analysis of Long-term Ecological Monitoring Studies}, Chapter 5, pp. 101-125. Cambridge: Cambridge University Press.

McDonald, T. L. (2015) Sampling Designs for Environmental Monitoring. In B. F. J. Manly and J. A. Navarro Alberto (Eds.), \emph{Introduction to Ecological Sampling}, Chapter 10, pp. 145-166. Boca Raton, FL: CRC Press.

Robertson, B.L., J. A. Brown,  T. L. McDonald, and P. Jaksons (2013) "BAS: Balanced Acceptance Sampling of Natural Resources", Biometrics, v69, p. 776-784.

Stevens, D. L., Jr. and A. R. Olsen (2004) "Spatially balanced sampling of natural resources." Journal of the American Statistical Association 99, 262-278.
}


\seealso{
documentation for package 'spsurvey' 
}

\examples{
equi.GUI()   # Start the interface

halton(20,2,floor(runif(2,max=100000))) # A random-start 2-D Halton sequence of length 20
}

\keyword{ package }
