Adjwgt_FrameNR <- function (dat, popn, evalstatus = "EvalStatus", wgt = "wgt") 
{

# Format EvalStatus field
# remove all spaces and dashes
    dat[, evalstatus] <- gsub(" ", "", dat[, evalstatus], fixed = TRUE)
    dat[, evalstatus] <- gsub("-", "", dat[, evalstatus], fixed = TRUE)
# make evalstatus lower case
    dat[, evalstatus] <- tolower(dat[, evalstatus])
# standardize possible entries
    dat[, evalstatus] <- as.character(dat[, evalstatus])
    dat[, evalstatus][dat[, evalstatus] %in% c("targetsampled","targetsurveyed")] <- "targetsurveyed"
    dat[, evalstatus][dat[, evalstatus] %in% c("targetnotsampled","targetnotsurveyd")] <- "targetnotsurveyed"
    dat[, evalstatus][dat[, evalstatus] %in% c("nontarget","nottarget")] <- "nontarget"
    dat[, evalstatus][dat[, evalstatus] %in% c("noteval", "notevaluated")] <- "notevaluated"

# Error check
EvalVector = c("targetsurveyed","targetnotsurveyed","notevaluated","oversamp","nontarget")
if(any(!dat[, evalstatus]%in%EvalVector)) print(paste("EvalStatus field should take only the following values:","Target - Surveyed,Target - Not Surveyed,Not Evaluated,OverSamp,Non-Target"))

    n.all <- nrow(dat[dat$panel != "OverSamp", ])
    dat.eval <- dat[dat[, evalstatus] != "notevaluated", ]
    n.eval <- nrow(dat.eval)
    dat.T <- dat.eval[dat.eval$EvalStatus != "nontarget", ]
    n.T <- nrow(dat.T)
    dat.R <- dat.T[dat.T$EvalStatus != "targetnotsurveyed",]
    n.R <- nrow(dat.R)
    n.over <- nrow(dat[(dat$panel == "OverSamp") & (dat[, evalstatus] == "targetsurveyed"), ])

    adj <- ifelse(popn == "Target", n.all * n.T/(n.eval * n.R), n.all/n.eval)
    adj.wt <- (dat[, wgt]) * (dat[, evalstatus] == "targetsurveyed") * adj 
    return(adj.wt)
}


