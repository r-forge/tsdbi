
# Finding series identifiers is difficult and
#  the mneumonics are obscure. Needs documentation.

# on finding identifiers
# http://epp.eurostat.ec.europa.eu/portal/page/portal/sdmx_web_services/about_eurostat_data
# >SDMX queries tutorial
# and 
#http://epp.eurostat.ec.europa.eu/portal/page/portal/sdmx_web_services/sdmx_tutorial/ident_data

getFlows('ECB')
getFlows('ECB', '*EXR*')

#   but real, use   sdmxHelp()

cat("************** ECB sdmx   ******************************\n")

require("TSsdmx")
# require("RJSDMX")
# require("tframe")

ecb <- TSconnect("sdmx", dbname="ECB")

# annual
z <- TSget('EXR.A.USD.EUR.SP00.A', ecb)
z <- TSget('EXR.A.USD.EUR.SP00.A',start = 2000, end = 2012, ecb)

# monthly 
z <- TSget('EXR.M.USD.EUR.SP00.A', ecb) 
z <- TSget('EXR.M.USD.EUR.SP00.A', start = "", end = "", ecb) 

#'should give error message  does not exist  on ECB
#z <-     TSget('122.ICP.M.U2.N.000000.4.ANR', ecb) 


# weeky data 
# "Frequency W. Does not allow the creation of a strictly 
fetching but then failing
z <- TSget("ILM.W.U2.C.A010.Z5.Z0Z", ecb)


#  following all give  does not exist

require("tfplot")

# monthly data 

options(TSconnection=ecb)

z <- TSget("122.ICP.M.U2.N.000000.4.ANR", ecb)# annual rates 
z <- TSget("122.ICP.M.U2.N.000000.4.INX", ecb)# index 
z <- TSget("117.BSI.M.U2.Y.U.A21.A.4.U2.2250.Z01.E", ecb)
tfplot(z)


# quarterly data 

skey <-c("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A23.A.1.U2.2250.Z01.E")


z <- TSget(skey[1], ecb)     
tfplot(z)

z <- TSget("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E", ecb) 
z <- TSget("117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E", ecb) 
 
tfplot(z)

z <- TSget(skey, ecb)     # multiple series still needs work
tfplot(z)

# weeky data 
# "Frequency W. Does not allow the creation of a strictly 
fetching but then failing
z <- TSget("ILM.W.U2.C.A010.Z5.Z0Z", ecb)
