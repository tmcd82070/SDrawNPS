Adjwgt_FrameNR<-function(dat, popn, evalstatus="EvalStatus", wgt="wgt") {

  # Takes data for a single survey year and calculates the design weight 
  # after accounting for frame error and nonresponse.
  #
  # dat contains a field called EvalStatus which takes one of the following values:
  # 	EvalStatus = "Target - Sampled" -- site is a member of target population and data were successfully collected
  # 	EvalStatus = "Target - Not Sampled" -- site is a member of target population and but data were not collected (inaccessible, landowner denial, etc.)
  # 	EvalStatus = "Non-Target" -- site is not a member of target population
  # 	EvalStatus = "Not Evaluated" -- observer crews did not assess target popn membership, site not needed
  # popn = "Target" or "Sampled" for scope of inference
  #
  # lahs 8.20.12 updated 9.30.15
  #
  # dat <- df
  # popn <- popn
  # evalstatus <- "EvalStatus"
  # wgt <- "wgt"

  # error checking -- standardize EvalStatus inputs
  dat[,evalstatus]                                                                          <- as.character(dat[,evalstatus])
  dat[,evalstatus][dat[,evalstatus] %in% c("Target - Sampled","Target - Surveyed")]         <- "Target - Sampled"
  dat[,evalstatus][dat[,evalstatus] %in% c("Target - Not Sampled","Target - Not Surveyed")] <- "Target - Not Sampled"
  dat[,evalstatus][dat[,evalstatus] %in% c("Non-Target","Non-target")]                      <- "Non-Target"
  dat[,evalstatus][dat[,evalstatus] %in% c("NotEval","Not Evaluated")]                      <- "Not Evaluated"
  
  # define quantities of interest
  n.all    <- nrow(dat[dat$panel == "Main",])				                                            # Size of initial sample
  dat.eval <- dat[dat[,evalstatus] != "Not Evaluated",]		                                      # Set of evaluated sites (could be larger than initial sample)
  n.eval   <- nrow(dat.eval)						                    	                                  # Size of target sites
  dat.T    <- dat.eval[dat.eval$EvalStatus != "Non-Target",]                                    # Set of target sites		
  n.T      <- nrow(dat.T)                                                                       # Size of target sites
  dat.R    <- dat.T[dat.T$EvalStatus != "Target - Not Sampled",]                                # Set of responding sites
  n.R      <- nrow(dat.R)                                                                       # Size of responding sites
  n.over   <- nrow(dat[(dat$panel == "OverSamp") & (dat[,evalstatus] == "Target - Sampled"),])	# Size of oversample sites
  
  #print("(n.all, n.eval, n.T, n.R, n.over)")
  #print(c(n.all, n.eval, n.T, n.R, n.over))
  adj <- ifelse(popn == "Target",n.all*n.T/(n.eval*n.R),n.all/n.eval)
  adj.wt <- (dat[,wgt])*(dat[,evalstatus] == "Target - Sampled")*adj

  return(adj.wt)

}
