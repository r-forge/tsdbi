
cat("************** ECB sdmx   ******************************\n")
require("TSsdmx")
#require("RCurl") 
#require("XML")
#require("tframe")

con <- TSconnect("sdmx", dbname="ECB") 

# there is an SDMX primer at
# http://www.ecb.int/stats/services/sdmx/html/index.en.html

#for the Guide:

# identifiers can be found by viewing the series key is listed under the title
at http://sdw.ecb.europa.eu/ eg 
#http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&SERIES_KEY=118.DD.A.I5.POPE.LEV.4D&type=sdmx

#  or extracted from the link to export / XML
# For example, the Inflation rate at annual rates link is 
#http://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=122.ICP.M.U2.N.000000.4.ANR
# so the series key is 122.ICP.M.U2.N.000000.4.ANR

# eg pop
#http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&SERIES_KEY=118.DD.A.I5.POPE.LEV.4D&type=sdmx

TSgetURI("http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&SERIES_KEY=118.DD.A.I5.POPE.LEV.4D&type=sdmx") #as v3


z <- TSgetECB("118.DD.A.I5.POPE.LEV.4D") # ns1 fails v1 v2 v3; ns2 fails v1
# above only seems to get the header and no error message with ns1 v1
# With v3 it gets data and <dataset> <group ,,,> and parse does not work.

# next gets nothing 
z <- TSgetECB("DD.A.I5.POPE.LEV.4D")     #fails needs 118.


#quarterly
# http://sdw.ecb.europa.eu/
#    >Money,banking, and fin. >MFIs loans, dep..> households 
#      |quarterly  | all | select series (click check box) BSI... as below    
#      | Data table | export (csv SDMX excel)

#annual rate not INX 
z <- TSgetECB("122.ICP.M.U2.N.000000.4.ANR")# ns1 fails v1 v2 v3; ns2 fails v1 


skey <-c("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A23.A.1.U2.2250.Z01.E")


z <- TSgetECB(skey) #ns1 works v1 v2 v3; ns2 fails v1
z <- TSgetECB("117.BSI.M.U2.Y.U.A21.A.4.U2.2250.Z01.E")   #ns1 works v1 v3 fails v2; ns2 fails v1
z <- TSgetECB("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E")   #ns1 works v1 v2 v3

z <- TSgetECB(c("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
                "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E"))#ns1 works v1 v2 v3; ns2 fails v1




z <- TSget(skey, con)
tfplot(z)

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

