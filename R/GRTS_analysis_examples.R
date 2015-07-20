# Example R code for design-based analysis of GRTS survey data


# Design-based estimate of pH

# We have a smaller sample than planned, frame error, and nonresponse error
# For now, we will ignore that
# We need to develop code to read in the design file and analyze the data


Lakes<-read.csv("SEKIlakes_ExampleData.csv", header=TRUE)
names(Lakes)
 [1] "siteID"       "xcoord"       "ycoord"       "mdcaty"       "wgt"         
 [6] "stratum"      "panel"        "EvalStatus"   "EvalReason"   "Park"        
[11] "Cost_cat"     "Inverse_Cost" "pH"

require(spsurvey)

# Design-based analysis
Lakes.pH.Est<-cont.analysis(
sites=data.frame(siteID=Lakes$siteID, Lakes$EvalStatus=="Target - Sampled"), 
subpop= data.frame(siteID=Lakes$siteID, Popn1= rep(1,nrow(Lakes))), 
design= data.frame(siteID=Lakes$siteID, wgt=  Lakes$wgt, 
xcoord = Lakes$xcoord, ycoord = Lakes$ycoord),total=TRUE, 
data.cont= data.frame(siteID=Lakes$siteID, Ind=Lakes$pH))


