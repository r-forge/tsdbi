#require(DBI) 
#require(TSdbi) 
#require(RCurl) 
#require(RJSONIO)
#source("R/TSdbiMethods.R")

require("TSjson")
require("tfplot")


# user/passwd/host from file ~/.TSjson.cfg
con <- TSconnect("json", dbname="statcan")

# quarterly

#x <- fromJSON(getURL("http://{url}/v498086")) 
x <- TSget("v498086", con)
tfplot(x)

# this series is causing a problem
x <- TSget("v1593272", con)
tfplot(x)

x <- TSget("v498086", con, TSdescription=TRUE, TSdoc=TRUE, TSlabel=TRUE)
TSdescription(x)
TSdoc(x)
TSlabel(x)

TSdates(c("v498086", "v498087"), con)

tfplot(ytoypc(TSget(c("v498086", "v498087"), con)))


# monthly

resMorg <- TSget("V122746", con)
seriesNames(resMorg) <- "Residential Mortgage Credit (SA)"
TSdescription(x)
TSdoc(x)
TSlabel(x)
TSseriesIDs(x)

TSdates(c("V122746", "V122747"), con)


# annual 

#x <- fromJSON(getURL("http://{url}/v687341")) 
x <- TSget("v687341", con)
seriesNames(x) <- "Canadian GDP - current prices"
tfplot(x)

TSdates(c("v687341", "v687342"), con)


# semi- annual FAILS

#x <- fromJSON(getURL("http://{url}/v141")) 
x <- TSget("v141", con)
seriesNames(x) <- "Footwear production - Canada; Work and utility-type boots and shoes"
tfplot(x)

TSdates("v141", con)

# weekly FAILS
#x <- fromJSON(getURL("http://{url}/V36610"),nullValue=NA) 
BoCbal <- TSget("V36610", con)
seriesNames(BoCbal) <- "Bank of Canada - Assets and Liabilities"

# mixed
TSdates(c("v498086", "v498087","V122746", "v687341", "V36610", "v141"), con)
