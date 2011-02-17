require("TSzip")
require("timeSeries")

##################################################
##################################################

#### Data from PiTrading  ########
## http://pitrading.com/free_market_data.htm # free futures data 
## http://pitrading.com/free_eod_data/INDU.zip
##################################################
##################################################
  pit <- TSconnect("zip", dbname="http://pitrading.com/free_eod_data")

  z <- TSget("INDU", pit, TSrepresentation="timeSeries")
  tfplot(z)

  options(TSrepresentation="timeSeries")

  z <- TSget(c("EURUSD", "GBPUSD"), pit)
  tfplot(z)
 
  TSrefperiod(z) 
  TSdescription(z) 

  z <- TSget(c("AD", "CD"), pit, select="Close")

  zz <- window(z, start=as.timeDate("2007-01-01"), end=end(z))
  zz <- window(z, start="2007-01-01", end=end(z))
  zz <- tfwindow(z, start="2007-01-01", end=end(z))
  zz <- tfwindow(z, start="2007-01-01")
  

# next does not work because tframe:::tfplot.default does not seem to recognize
# S4 method is.tframed.timeSeries. Seems this will require a better 
# understanding of S3/S4/NAMESPACE issues.
#  tfplot(z, start="2007-01-01",
#         Title="Australian and Canadian Dollar Continuous Contract, Close")
