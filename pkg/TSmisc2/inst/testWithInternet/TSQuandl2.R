require("tfplot")
require("TSmisc2")

cat("**************        connecting to Quandl\n")

con <- TSconnect("Quandl", dbname="NSE") 

oilz <- TSget("OIL", con, start=as.Date("2001-01-01"), quote="Close")
oilz <- TSget("OIL", con, start="2002-01-01", TSrepresentation="zoo")
oilx <- TSget("OIL", con, start=as.Date("2001-01-01"), TSrepresentation="xts")
   
if(! all(start(oilz) == start(oilx)))
   stop("oil xts and zoo start dates do not compare.")  

end(oilz)
  
tfplot(oilz, graphs.per.page=3)

require("zoo") # for coredata but not for above
if (max(abs(coredata(oilz) - coredata(oilx))) > 1e-6 )
   stop("oil xts and zoo coredata do not compare.")  
