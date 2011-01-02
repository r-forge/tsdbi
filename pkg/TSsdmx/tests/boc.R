# Status: Partially working, but finding series identifiers is difficult and
#    limited data is available (as of December 2010).
#    Needs documentation.

cat("************** Bank of Canada sdmx   ******************************\n")
require("TSsdmx")

con <- TSconnect("sdmx", dbname="BoC") 

# identifiers can be extraced at ??

# z <- TSget("CDOR", con=con)
# above seems to end with funny <Series/>
# </Obs></Series><Series/></DataSet></CompactData></return>


z <- TSget(c("CDOR", "OIS", "SWAPPEDTOFLOAT"), con=con)

tfplot(z, Title="From Bank of Canada")
TSdescription(z) 

#  not sure if these series exist, or some other problem
# options(TSconnection=con)
# 
# x <- TSget(c("TOTALSL","TOTALNS"), con, 
#        names=c("Total Consumer Credit Outstanding SA",
#                "Total Consumer Credit Outstanding NSA"))
# plot(x)
# tfplot(x)
# TSdescription(x) 

