
cat("************** ECB sdmx   ******************************\n")
require("TSsdmx")
#require("RCurl") 
#require("XML")
#require("tframe")

con <- TSconnect("sdmx", dbname="BOC") 


########## to clean out below

# there is an SDMX primer at
# http://www.ecb.int/stats/services/sdmx/html/index.en.html


# identifiers can be extraced at ??

these retrieve the data but has the wrong ns or <DataSet> parse problem
args=CDOR_-_-_OIS_-_-_SWAPPEDTOFLOAT_-_-_FIRST_-_-_Last



z <- TSgetBoC("CDOR")

z <- TSgetBoC(c("CDOR", "OIS", "SWAPPEDTOFLOAT"))

TSdescription(z) 


#monthly ?

TSdescription(x) 

options(TSconnection=con)


x <- TSget(c("TOTALSL","TOTALNS"), con, 
       names=c("Total Consumer Credit Outstanding SA",
               "Total Consumer Credit Outstanding NSA"))
plot(x)
tfplot(x)
TSdescription(x) 

