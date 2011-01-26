require("TSzip")

##################################################
##################################################

#### Data from PiTrading  ########
## http://pitrading.com/free_market_data.htm # free futures data 
## http://pitrading.com/free_eod_data/INDU.zip
##################################################
##################################################
  pit <- TSconnect("zip", dbname="http://pitrading.com/free_eod_data",
          read.csvArg=list())

  z <- TSget("INDU", pit)
  tfplot(z)

  z <- TSget(c("EURUSD", "GBPUSD"), pit)
  tfplot(z)

  z <- TSget(c("EURUSD", "GBPUSD"), pit, select="Close")
  tfplot(z)
 
  TSrefperiod(z) 
  TSdescription(z) 
