
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


trimAllNA <- function(x, startNAs= TRUE, endNAs= TRUE) UseMethod("trimAllNA") 

trimAllNA.default <- function(x, startNAs= TRUE, endNAs= TRUE)
{# trim NAs from the ends of a ts matrix or vector.
 # (Observations are dropped if all in a given period contain NA.)
 # if startNAs=F then beginning NAs are not trimmed.
 # If endNAs=F   then ending NAs are not trimmed.
 sample <- ! if (is.matrix(x)) apply(is.na(x),1, all) else is.na(x)
 if (!any(sample)) warning("data is empty after triming NAs.")
 s <- if (startNAs) min(time(x)[sample]) else tfstart(x)
 e <- if (endNAs)   max(time(x)[sample]) else tfend(x)
 tfwindow(x, start=s, end=e, warn=FALSE)
}

TSrepresentation <- function(df, i, j, tf, names=NULL) {
   zz <- as.matrix(df)[ i, j]  
   require("tframe")
   trimAllNA(tframed(array(as.numeric(zz), dim(zz)), tf=tf, names=names)) 
   }

tsrepresentation <- function(df, i, j, start, frequency=NULL, names=NULL) {
   # assume ts with start date string "Month-YYYY" (Locale-specific conversion)
   dt <- strptime(paste("01-",start, sep=""), format="%d-%b-%Y")
   # drop NA on end
   TSrepresentation(df, i, j, 
      list(start=c(1900+dt$year, dt$mon), frequency=frequency),names=names)
   }

# dt$year and dt$month in next could be used to construct zoo or other time series
# dt <- z[ -(1:10), 1]
# dt <- strptime(paste("01-",dt, sep=""), format="%d-%b-%Y")

combineRows <- function(x, i, j, setEmpty=NULL){
  x[setEmpty] <- ""
  x <- x[i,j]
  r <- NULL
  for (ii in seq(NROW(x))) r <- paste(r, x[ii,])
  r
  }

require("gdata")

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
