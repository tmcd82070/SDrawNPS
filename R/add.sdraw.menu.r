add.sdraw.menu <- function(){
#
#   Add a menu to the R GUI under windows
#

sys <-  Sys.info()["sysname"]
rstudio <-  Sys.getenv("RSTUDIO") == "1"

if( sys == "Windows" & interactive() & !rstudio){
  winMenuAdd("SDrawNPS")
	winMenuAddItem("SDrawNPS/Sample Draws", "Equi-Probable...", "equi.GUI()")
	winMenuAddItem("SDrawNPS/Sample Draws", "Stratified...", "stratified.GUI()")
  winMenuAddItem("SDrawNPS/Sample Draws", "Unequal...", "unequal.GUI()")
	#winMenuAddItem("SDrawNPS/Sample Draws", "Variable Probable...", "advanced.GUI()")
	winMenuAddItem("SDrawNPS/Analysis", "Analysis...", "analysis.GUI()")
} else if(!rstudio){
  cat("This is a non-menu environment, but provided RGtk2 can be loaded.\n")
  cat("you can still use the dialogs.  To use the dialogs, call one of the following:\n")
  cat("\t equi.GUI() -> Equi-probable samples.\n")
	cat("\t stratified.GUI() -> Stratified samples.\n") #added by Guy, 1/2/15
  cat("\t unequalprob.GUI() -> Unequal probability samples.\n")
  cat("\t analysis.GUI() -> Analysis of continuous or categorical variables.")
  #cat("\t advanced.GUI() -> Interface to draw advanced samples.\n")
} else {
  cat("You are running in RStudio where an SDrawNPS menu cannot be created.\n")
  cat("To use the dialogs, execute one of the following in the Console window:\n")
  cat("  equi.GUI() -> Equi-probable samples.\n")
  cat("  stratified.GUI() -> Stratified samples.\n")
  cat("  unequal.GUI() -> Unequal probability samples.\n")
  cat("  analysis.GUI() -> Analysis of continuous or categorical variables.")
}


}
