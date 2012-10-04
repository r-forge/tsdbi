#require(DBI) 
#require(TSdbi) 
#require(RCurl) 
#require(RJSONIO)
#source("R/TSdbiMethods.R")

require("TSjson")
require("tfplot")


# user/passwd/host from file ~/.TSjson.cfg
#con <- TSconnect("json", dbname="proxy-cansim")
con <- TSconnect("json", dbname="cansim")

# quarterly

#x <- fromJSON(getURL("http://{url}/v498086")) 
x <- TSget("v498086", con)
tfplot(x)

x <- TSget("v1593272", con)
tfplot(x)

x <- TSget("v498086", con, TSdescription=TRUE, TSdoc=TRUE, TSlabel=TRUE)
TSdescription(x)
TSdoc(x)
TSlabel(x)
TSsource(x)
TSseriesIDs(x)

TSdescription("v498086", con)
TSdoc("v498086", con)
TSlabel("v498086", con)
TSsource("v498086", con)

TSdates(c("v498086", "v498087"), con)
TSdates(c("v498086", "vNoSeries"), con)

tfplot(ytoypc(TSget(c("v498086", "v498087"), con)))


# monthly

TSdates(c("V122746", "V122747"), con)

resMorg <- TSget("V122746", con, TSdescription=TRUE, TSdoc=TRUE, TSlabel=TRUE)
TSdescription(x)
TSdoc(x)
TSlabel(x)
TSseriesIDs(x)
TSsource(x)
seriesNames(resMorg) <- "Residential Mortgage Credit (SA)"

tfplot(ytoypc(resMorg), 
   ylab="Year-to-Year Growth Rate",
   Title=seriesNames(resMorg), 
   source=paste("Bank of Canada, ", TSsource(x)),
   lastObs=TRUE)

tfplot(ytoypc(resMorg), annualizedGrowth(resMorg),
   Title=seriesNames(resMorg), 
   subtitle="year-to-year (black) and annualize monthly growth (red)",
   ylab="Growth Rate",
   source=paste("Bank of Canada, ", TSsource(x)),
   lastObs=TRUE)

# annual 

#x <- fromJSON(getURL("http://{url}/v687341")) 
x <- TSget("v687341", con)
seriesNames(x) <- "Canadian GDP Growth"
tfplot(ytoypc(x),
   Title="Canadian GDP Growth", 
   ylab="year-to-year growth",
   source=TSsource(x),
   lastObs=TRUE)


TSdates(c("v687341", "v687342"), con)
TSdescription(c("v687341", "v687342"), con)

# semi- annualmay still fail on proxy
x <- TSget("v141", con)
seriesNames(x) <- "Footwear production - Canada; Work and utility-type boots and shoes"
tfplot(x)

TSdates("v141", con)

# weekly NOT WORKING PROPERLY
#x <- fromJSON(getURL("http://{url}/V36610"),nullValue=NA) 
BoCbal <- TSget("V36610", con)
##the csv data file looks like
#Legend:
#v36610,"Table 176-0009: Bank of Canada, assets and liabilities, Wednesdays; Canada; Total assets (x 1,000,000)"
#Weekly,v36610
#Jan 01 1980,
#Jan 08 1980,
#...
#Nov 25 1980,
#Dec 02 1980,16495
#Dec 09 1980,16680
#...
#Sep 11 2012,71937
#Sep 18 2012,72027

seriesNames(BoCbal) <- "Bank of Canada - Assets and Liabilities"
tfplot(BoCbal)

# mixed
TSdates(c("v498086", "v498087","V122746", "v687341", "V36610", "v141"), con)

# daily FAILS
#OverNightFin <-  TSget("v39050", con)
#the csv data file looks like
#Legend:
#v39050,"Table 176-0048: Bank of Canada, money market and other interest rates, daily; Canada; Overnight money market financing"
#Daily,v39050
#Jan 01 1991,
#Jan 02 1991,
#Jan 03 1991,
#...
#Dec 23 1997,4.34
#Dec 24 1997,4.36
#Dec 25 1997,..
#Dec 26 1997,..
#Dec 27 1997,0.00
#Dec 28 1997,0.00
#...
#Sep 23 2012,0.00
#Sep 24 2012,1.00
#Sep 25 2012,
#tfplot(OverNightFin)
