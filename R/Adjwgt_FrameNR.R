#' @export Adjwgt_FrameNR
#'   
#' @title Adjust design weights for frame error.
#'   
#' @description Takes data for a single survey year (why does a year matter) and
#'   calculates site-specific design weights after accounting for frame error and
#'   nonresponse, while assuming missing-completely-at-random missingness.
#'   
#' @param dat A GRTS-design \code{csv} file generated from a GRTS sample draw, 
#' with individual sites forming its rows.  
#'   
#' @param popn A text string identifying the type of membership of a site.  Use 
#'   \code{popn="Target"} if the site is not needed, or \code{popn="Sampled"} 
#'   for scope of inference.  (what does this mean?)
#'   
#' @param evalstatus  A text string identifying the variable within \code{dat} 
#'   describing the evaluation status of sites in \code{dat}.  See
#'   \sQuote{Variable \code{evalstatus} Specifications.}
#'   
#' @param wgt  A text string identifying the variable within \code{dat} 
#'   containing site-specific design weights.
#'   
#' @return  A numeric vector \code{adj.wt} of length equal to the number-of-site
#'   rows originally contained in \code{dat}.  Right???
#'   
#' @details This routine is called by the sampling analysis Graphical User 
#'   Interface (GUI), i.e., function \code{analysis.GUI}, when its
#'   \sQuote{Optional Weight Inputs} \sQuote{Adjust Weights?} radio button is
#'   set to \sQuote{Yes.}  See \code{analysis.GUI}. Generally, this function is
#'   not intended to be called directly by the user.
#'   
#'   When the \code{analysis.GUI} requests adjustment of weights, function 
#'   \code{Adjwgt_FrameNR} modifies the included weights \code{wgt} in 
#'   \code{dat} for frame error and nonresponse.  The methodology assumes any 
#'   missing (sites??? -- should these be set to evalstatus="something"??) are
#'   missing completely at random.
#'   
#'   What happens if the data cover more than a year?  Does the code break?  Should 
#'   the user manipulate the data somehow to account for this?  Does the function
#'   assume non-temporal variability?  
#'   
#' @section Variable \code{evalstatus} Specifications:
#'   
#'   Each row of \code{dat} represents a randomly selected site from the GRTS 
#'   sample draw. Generally, \code{dat} contains additional variables for data 
#'   collected during the survey. Essentially however, \code{dat} must contain a
#'   field \code{evalstatus} that describes the sampling nature of all sampled 
#'   sites.  Valid values include: (what happens if a value is not one of these
#'   4???)
#'   
#'   \enumerate{
#'   
#'   \item \code{"Target - Sampled"} -- The site is a member of the target
#'   population and data were successfully collected.
#'   
#'   \item \code{"Target - Not Sampled"} -- The site is a member of the target
#'   population, but data were not collected, e.g., due to innaccessibility, 
#'   landowner denial, etc.
#'   
#'   \item{"Not Evaluated"} -- The site was not assessed by observer crews.
#'   
#'   \item{"Non-Target"} -- The site is not a member of the target population.
#'   
#'   }
#'   
#' @author Leigh Ann Starcevich (lstarcevish@@west-inc.com) 
#'   
#' @seealso \code{\link{analysis.GUI}}
#'   
#' @references 
#'   Little, J. A. R., and Rubin, D. B. (2002). Statistical analysis with missing
#'   data, 2nd edition. John Wiley and Sons, Inc., New Jersey
#'   
#'   Lessler, J. T. and Kalsbeek, W. D. (1992). Nonsampling errors in surveys.
#'   John Wiley and Sons, New York.
#'   
#'   Oh, H. L. and Scheuren, F. J. (1983). Weighting adjustment for unit
#'   nonresponse. Pages 143-184 in W. G. Madow, I. Olkin, and D. B. Rubin,
#'   editors. Incomplete data and in sample surveys. (Vol. 2). Academic Press,
#'   New York.
#'   
#'   Starcevich L. A., DiDonato G., McDonald T., Mitchell, J. (2016). A GRTS 
#'   User\'s Manual for the SDrawNPS Package: A graphical user interface for 
#'   Generalized Random Tessellation Stratified (GRTS) sampling and estimation. 
#'   National Park Service, U.S. Department of the Interior.  Natural Resource 
#'   Report NPS/XXXX/NRR—20XX/XXX.
#'   
#' @keywords design survey sampling missing
#'   
#' @examples
#' # Do we want to put anything here?  If so, what might it be?  It should use 
#' # a dat from a csv included in the package.
#' stratified.GUI() # change me change me change me
#'   
Adjwgt_FrameNR<-function(dat, popn, evalstatus="EvalStatus", wgt="wgt") {


#
# LA Starcevich 5.4.2016
#

# error checking -- standardize EvalStatus inputs
dat[,evalstatus]<-as.character(dat[,evalstatus])
dat[,evalstatus][dat[,evalstatus]%in%c("Target - Sampled","Target - Surveyed")]<-"Target - Sampled"
dat[,evalstatus][dat[,evalstatus]%in%c("Target - Not Sampled","Target - Not Surveyed")]<-"Target - Not Sampled"
dat[,evalstatus][dat[,evalstatus]%in%c("Non-Target","Non-target")]<-"Non-Target"
dat[,evalstatus][dat[,evalstatus]%in%c("NotEval","Not Evaluated")]<-"Not Evaluated"

# Calculate numbers of main sample sites, evaluated sites, target sites, and responding sites
n.all<-nrow(dat[dat$panel=="Main",])				# Size of initial sample
dat.eval<-dat[dat[,evalstatus]!="Not Evaluated",]		# Set of evaluated sites (could be larger than initial sample)
n.eval<-nrow(dat.eval)							# Size of target sites
dat.T<- dat.eval[dat.eval$EvalStatus!="Non-Target",]		# Set of target sites		
n.T<- nrow(dat.T)								# Size of target sites
dat.R<- dat.T[dat.T$EvalStatus!="Target - Not Sampled",]  	# Set of responding sites
n.R<-nrow(dat.R)								# Size of responding sites
n.over<- nrow(dat[(dat$panel=="OverSamp")&(dat[,evalstatus]=="Target - Sampled"),])	# Size of oversample sites				# Size of oversample sites

# Calculate adjusted weight assumption missing-completely-at-random missingness
adj<-ifelse(popn=="Target",n.all*n.T/(n.eval*n.R), n.all/n.eval)
adj.wt<-(dat[,wgt])*(dat[,evalstatus]=="Target - Sampled")*adj
return(adj.wt)
}
