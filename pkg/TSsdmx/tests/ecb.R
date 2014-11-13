
# Finding series identifiers is difficult and
#  the mneumonics are obscure. Needs documentation.

# on finding identifiers
# http://epp.eurostat.ec.europa.eu/portal/page/portal/sdmx_web_services/about_eurostat_data
# >SDMX queries tutorial
# and 
#http://epp.eurostat.ec.europa.eu/portal/page/portal/sdmx_web_services/sdmx_tutorial/ident_data

#   but real, use   sdmxHelp()

cat("************** ECB sdmx   ******************************\n")

require("TSsdmx")
# require("RJSDMX")
# require("tframe")

ecb <- TSconnect("sdmx", dbname="ECB")

#### annual####
z <- TSget('EXR.A.USD.EUR.SP00.A', ecb)
z <- TSget('EXR.A.USD.EUR.SP00.A',start = 2000, end = 2012, ecb)

if(1 != frequency(z)) stop("ECB monthly frequency error.")
if(2000 != start(z))  stop("ECB monthly start error.")


#### monthly ####
z <- TSget('EXR.M.USD.EUR.SP00.A', ecb)

if("Jan 1999" != start(z)) stop("ECB monthly start error.")

#  How should start and end be specified?
#  z <- TSget('EXR.M.USD.EUR.SP00.A', start="May 2008", end="Aug 2014", ecb)
#  z <- TSget('EXR.M.USD.EUR.SP00.A', start=c(2008,5), end=c(2014,8), ecb)
#  z <- TSget('EXR.M.USD.EUR.SP00.A', start=yearmon(2008+4/12), ecb)

z <- TSget('EXR.M.USD.EUR.SP00.A', ecb) 
z <- TSget('EXR.M.USD.EUR.SP00.A', start = "", end = "", ecb) 

#'should give error message  does not exist  on ECB
z <-   try(  TSget('122.ICP.M.U2.N.000000.4.ANR', ecb), silent=TRUE )
if (! grepl('122.ICP.M.U2.N.000000.4.ANR', attr(z,"condition"))) stop(
        'does not exist error not caught properly.')

require("tfplot")

options(TSconnection=ecb)

z <- TSget("ICP.M.U2.N.000000.4.ANR")# annual rates 
if("Jan 1991" != start(z)) stop("ECB monthly start error 2.")
##   BUG  ?? tfplot(z)

z <- TSget("ICP.M.U2.N.000000.4.INX")# index 
z <- TSget("BSI.M.U2.Y.U.A21.A.4.U2.2250.Z01.E")
##   BUG  ?? tfplot(z)
plot(z)


#### quarterly data ####

z <- TSget('EXR.Q.USD.EUR.SP00.A')

if("1999 Q1" != start(z)) stop("ECB quarterly retrieval error.")

#  How should start and end be specified?
#  z <- TSget('EXR.Q.USD.EUR.SP00.A', start="2008 Q2", end="2014 Q3")

# BSI balance sheet indicators
#   FREQ Q
#   U2 Euro area, changing composition.
#   not adjusted 
#   sector T 
#   item  A20 loans   (no A21 cedit for cunsumption)
#   A all maturities
#   data type 1 outstanding
#   count area  U2 Euro area, changing composition.
#   count sector2250 household and non-profit...
#   currency  Z01 all currencies
#   suffix  E euro   (no B average )

z <- getSDMX('ECB', "BSI.Q.U2.N.T.A21.A.1.U2.2250.Z01.B") not found

z <- getSDMX('ECB', "BSI.Q.U2.N.T.A20.A.1.U2.2250.Z01.E") 

z <- getSDMX('ECB', "BSI.Q.U2.N.T.*.*.*.*.*.*.*")  not found

z <- getSDMX('ECB', "BSI.Q.U2.N.*.*.*.*.*.*.*.*") 
nm <- names(z)
length(nm) #927
nm

sum(grepl('A21',nm)  # 0
sum(grepl('.B', names(z)))  # 0
sum(grepl('2250', names(z))) #

any("BSI.Q.U2.N.V.A20.A.1.U2.2250.Z01.E" %in% nm )

z <- getSDMX('ECB', "BSI.Q.U2.N.*.*.*.*.*.*.*.*") 
length(names(z)) #
names(z)


skey <-c("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A23.A.1.U2.2250.Z01.E")


z <- TSget(skey[1], ecb)   
  
tfplot(z)

z <- TSget("BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E", ecb) 
z <- TSget("117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E", ecb) 
 
tfplot(z)

z <- TSget(skey, ecb)     # multiple series still needs work
tfplot(z)
  plot(z)


#### weeky data  ####

# "Frequency W. Does not allow the creation of a strictly 
# fetching but then failing translating date with error
#   character string is not in a standard unambiguous format

# z <- TSget("ILM.W.U2.C.A010.Z5.Z0Z", ecb)

# "Frequency W. Does not allow the creation of a strictly 
fetching but then failing
z <- TSget("ILM.W.U2.C.A010.Z5.Z0Z", ecb)
