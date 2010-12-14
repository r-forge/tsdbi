
from Int..Money/extracalc

##################################################
##################################################

####### Data from Bank of Australia  #############

##################################################
##################################################

#  http://www.rba.gov.au/statistics/tables/index.html
#  wget "http://www.rba.gov.au/statistics/tables/xls/d03hist.xls"  #has money
#  wget "http://www.rba.gov.au/statistics/tables/xls/g10hist.xls"  #has GDP
#  wget "http://www.rba.gov.au/statistics/tables/xls/f13hist.xls"  #has R (international too)
#  wget "http://www.rba.gov.au/statistics/tables/xls/i01hist.xls"  #has Int real GDP
#  wget "http://www.rba.gov.au/statistics/tables/xls/i02hist.xls"  #has Int CPI


TSgetXLS <- function(id, con){
  # data, ids and dates are cached in con

  d <- con@data[,names=Title)
  length(ids) == NROW(data)
  length(ids) ==length(dates)
  }
####  Australian Money ####

#NB The first line provides data frame names, so rows are shifted.
#   Blank rows seem to be skipped, so result is compressed

z <- as.matrix(read.xls("d03hist.xls", sheet = 1, verbose=FALSE) )
                   #method=c("csv","tsv","tab"), perl="perl")

Title    <- combineRows(z, 3:6, -1, setEmpty=c(2, 11)) 

Adjustments <- c(rep("nsa", 10),rep("sa", 4),rep("nsa", 2)) # could improve
Units    <- z[1, 1]  ; names(Units) <- NULL
Notes    <- z[2, 1]  ; names(Notes) <- NULL
Updated <- z[8, -1]  ; names(Updated) <- NULL# date format error?
Source   <- z[9, -1] ; names(Source) <- NULL
id       <- z[10,-1] ; names(id ) <- NULL

r <- tsrepresentation(z, -(1:10), -1, start=z[11, 1], frequency=12, names=Title)
start(r)
end(r)
