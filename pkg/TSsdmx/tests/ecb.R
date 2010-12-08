
cat("************** ECB sdmx   ******************************\n")
require("TSsdmx")
#require("RCurl") 
#require("XML")
#require("tframe")

con <- TSconnect("sdmx", dbname="ECB") 

# there is an SDMX primer at
# http://www.ecb.int/stats/services/sdmx/html/index.en.html
# NB firebug shows browser requests to server, so is useful for seeing what is
#  sent to the server

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
# note that it would be nice to use  
# TSgetECB("DD.A.I5.POPE.LEV.4D")     #but this fails. It needs 118.

# Annual data
z <- TSgetECB("118.DD.A.I5.POPE.LEV.4D")#works v3 
# seems to get only the header with v1


#quarterly
# http://sdw.ecb.europa.eu/
#    >Money,banking, and fin. >MFIs loans, dep..> households 
#      |quarterly  | all | select series (click check box) BSI... as below    
#      | Data table | export (csv SDMX excel)

# monthly data 
z <- TSgetECB("122.ICP.M.U2.N.000000.4.ANR")# annual rates #works v3 
z <- TSgetECB("122.ICP.M.U2.N.000000.4.INX")# index        #works v3 

z <- TSgetECB("117.BSI.M.U2.Y.U.A21.A.4.U2.2250.Z01.E")   #works v3

skey <-c("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A23.A.1.U2.2250.Z01.E")


z <- TSgetECB(skey)                                       #works v3
z <- TSgetECB("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E")   #works v3
# length 123 for all three
z <- TSgetECB(c("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
                "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E"))#works v3




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

