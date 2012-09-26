#require(DBI) 
#require(TSdbi) 
#require(RCurl) 
#require(RJSONIO)
#source("R/TSdbiMethods.R")

require("TSjson")
require("tfplot")


# user/passwd/host from file ~/.TSjson.cfg
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

# semi- annual FAILS
#  freq is coming back as "Error"
#x <- fromJSON(getURL("http://{url}/v141")) 
#x <- fromJSON(getURL("http://user:passwd@url/db/default/get.json/v141")) 
#x <- TSget("v141", con)
#seriesNames(x) <- "Footwear production - Canada; Work and utility-type boots and shoes"
#tfplot(x)

TSdates("v141", con)

# weekly NOT WORKING PROPERLY
#x <- fromJSON(getURL("http://{url}/V36610"),nullValue=NA) 
BoCbal <- TSget("V36610", con)
seriesNames(BoCbal) <- "Bank of Canada - Assets and Liabilities"
tfplot(BoCbal)

# mixed
TSdates(c("v498086", "v498087","V122746", "v687341", "V36610", "v141"), con)
