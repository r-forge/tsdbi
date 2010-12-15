require("TSxls")
#see also Int..Money/extracalc

##################################################
##################################################

####### Data from Reserve Bank of Australia  #############

##################################################
##################################################

#  http://www.rba.gov.au/statistics/tables/index.html
#  wget "http://www.rba.gov.au/statistics/tables/xls/d03hist.xls"  #has money
#  wget "http://www.rba.gov.au/statistics/tables/xls/g10hist.xls"  #has GDP
#  wget "http://www.rba.gov.au/statistics/tables/xls/f13hist.xls"  #has R (international too)
#  wget "http://www.rba.gov.au/statistics/tables/xls/i01hist.xls"  #has Int real GDP
#  wget "http://www.rba.gov.au/statistics/tables/xls/i02hist.xls"  #has Int CPI


#remove this
TSgetXLS <- function(id, con){
  # data, ids and dates are cached in con

  d <- try(con@tsrepresentation(con@data[,id], con@dates),  silent=TRUE)
  if(inherits(d, "try-error")) 
         stop("Could not convert data to series using tsrepresentation.",d)
  # give names rather than id mnemonic 
  seriesNames(d) <- con@names[id]
  d
  }

####  Australian Money ####

  con1 <- TSconnect("xls", dbname="d03hist.xls",
          map=list(ids  =list(i=11,     j="B:Q"), 
	           data =list(i=12:627, j="B:Q"), 
	           dates=list(i=12:627, j="A"),
                   names=list(i=4:7,    j="B:Q"), 
		   description = NULL,
		   tsrepresentation = function(data,dates){
		       ts(data,start=c(1959,7), frequency=12)}))

  z <- TSget("DMACN", con1)
  tfplot(z)

  z <- TSget(c("DMAM1N", "DMAM3N"), con1)
  tfplot(z)
   
  con2 <- TSconnect(drv="xls", dbname="d03hist.xls",
          map=list(ids  =list(i=11,     j="B:Q"), 
	           data =list(i=12:627, j="B:Q"), 
	           dates=list(i=12:627, j="A"),
                   names=list(i=4:7,    j="B:Q"), 
		   description = NULL,
		   tsrepresentation = function(data,dates){
	dt <- strptime(paste("01-",dates[1], sep=""), format="%d-%b-%Y")
	st <- c(1900+dt$year, dt$mon)
	ts(data,start=st, frequency=12)}))

  z <- TSget("DMACN", con2)
  tfplot(z)

  con3 <- TSconnect(drv="xls", dbname="d03hist.xls",
          map=list(ids  =list(i=11,     j="B:Q"), 
	           data =list(i=12:627, j="B:Q"), 
	           dates=list(i=12:627, j="A"),
                   names=list(i=4:7,    j="B:Q"), 
		   description = NULL,
		   tsrepresentation = function(data,dates){
		       zoo(data,order.by = as.Date(
			 paste("01-",dates, sep=""), format="%d-%b-%Y"))}))

  z <- TSget("DMACN", con3)
  tfplot(z)
