require("RJSDMX")

#  https://github.com/amattioc/SDMX/wiki

# to install devel version from Github
# require(devtools)
# install_github(repo = "SDMX", username = "amattioc", subdir = "RJSDMX")

# Package rJava will be needed interactively for experimenting but should be found
#   in the the namespace in eventual testing.
# require("rJava")

#  sdmxHelp()
# "ILO" server is temporarily not working for this help
# "BIS" requires an account

getProviders()
#[1] "BIS"      "ILO"      "ECB"      "OECD"     "EUROSTAT"

getFlows('ECB')

getFlows('ECB','*EXR*')


# The first time above is used in a session it also gives an indication if/where 
# a configuration file has been found.
# Its location should be set with the SDMX_CONF environment variable.
#  e.g  export SDMX_CONF=/home/paul/.SdmxClient
# Details about contents are at https://github.com/amattioc/SDMX/wiki/Configuration
# The configuration file can be used to control the level of std output about
# warnings and errors. This mostly seems to be coming directly from the java,
# rather than passed back to R (which would be more usual for R packages as it
# can then be masked in R by try(), etc, if that makes sense.)
# R users many want to set 
#SDMX.level = WARNING
#java.util.logging.ConsoleHandler.level = WARNING
# to limit output to what would more usually be expected in R sessions.

############################ "BIS" ############################
# need account (free?)
#https://dbsonline.bis.org/

############################ "ILO" ############################
# The server process which provides information to sdmxHelp() is having problems
#  but 
getFlows('ILO')

z <- getSDMX("ILO", 'EAP_TEAP_SEX_AGE_NB.AUS.*.*.*')
 
http://www.ilo.org/ilostat/faces/home/statisticaldata/data_by_country/country-details/indicator-details?country=AUS&indicator=EAP_TEAP_SEX_AGE_NB&source=518&datasetCode=YI&collectionCode=YI

############################ "ECB" ############################
#### annual ####
z <- getSDMX("ECB", 'EXR.A.USD.EUR.SP00.A')
if(1999 != start(z[[1]])) stop("ECB annual retrieval error.")

z <- getSDMX("ECB", 'EXR.A.USD.EUR.SP00.A', start = "2001", end = "2012")
if(2001 != start(z[[1]])) stop("start test for annual data failed.")
if(2012 != end(z[[1]]))   stop(  "end test for annual data failed.")

#### monthly ####
z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A')

if("Jan 1999" != start(z[[1]])) stop("ECB monthly retrieval error.")

#  How should start and end be specified?
#  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A', start="May 2008", end="Aug 2014")
#  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A', start=c(2008,5), end=c(2014,8))
#  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A', start=yearmon(2008+4/12))


#### quarterly ####
z <- getSDMX("ECB", 'EXR.Q.USD.EUR.SP00.A')

if("1999 Q1" != start(z[[1]])) stop("ECB quarterly retrieval error.")

#  How should start and end be specified?
#  z <- getSDMX("ECB", 'EXR.Q.USD.EUR.SP00.A', start="2008 Q2", end="2014 Q3")

#### weeky data  ####
# "Frequency W. Does not allow the creation of a strictly 
fetching but then failing

z <- getSDMX("ECB", "ILM.W.U2.C.A010.Z5.Z0Z")
# character string is not in a standard unambiguous format

# The problem is in makeSDMXTS() 
# require(ISOweek)
# debug(RJSDMX:::makeSDMXTS)
#            else if (freq == "W") {
#                 # assume Wednesday, weekday=3, but there may be more informatin
# 		# available in the SDMX
# 		dt <- as.Date(ISOweek::ISOweek2date(paste(times,"-3", sep="")))
# 		tmp_ts <- zoo(values, order.by = dt)
#             }

## get mixed monthly and annual frequency
##z1 <- getSDMX('ECB', 'EXR.A|M.USD.EUR.SP00.A')
##z2 <- getSDMX('ECB', 'EXR.A+M.USD.EUR.SP00.A')
## get mixed all available frequencies
##z <- getSDMX('ECB', 'EXR.*.USD.EUR.SP00.A')

############################ "OECD ############################

tts <- getSDMX('OECD', 'G20_PRICES.CAN.*.*.M')
names(tts)

tts2 = getSDMX('OECD', 'G20_PRICES.CAN.*.IXOB.M')       # retrieves but bad dates
tts2 = getSDMX('OECD', 'G20_PRICES.CAN.CPALTT01.IXOB.M')# retrieves but bad dates

# The problem is in makeSDMXTS() line
tmp_ts <- zoo(values, order.by = as.yearmon(times), frequency = 12)
# which needs to be
tmp_ts <- zoo(values, order.by = as.yearmon(times,"%YM%m"), frequency = 12)
# but assuming the format is a problem, since it is different in the example above which works.


names(tts2)


tts <- getSDMX('OECD', '7HA_A_Q.CAN.*.*.*.*')
names(tts)
tts2 <- getSDMX('OECD', '7HA_A_Q.CAN.*.*.*.*')


#[ http://epp.eurostat.ec.europa.eu/portal/page/portal/eurostat/home ]

#http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/search_database
#   >Economy and finance
#      >National accounts (including GDP) (ESA95) (na
#         >Quarterly national accounts (namq) 
#              >GDP and main components (namq_gdp)
#                   >GDP and main components - Current prices (namq_gdp_c) 

#  getFlows('OECD', "namq_gdp_c")
#  getFlows('OECD', "GDP")

############################ EUROSTAT ############################

#  Notes on finding identifiers

# sdmxHelp()

#>EUROSTAT  el_nama_q : Main aggregates - quarterly
# 	el_nama_q  > 	>FREQ: Q
#			>UNIT : MIO-EUR
#			>S_ADJ: NSA
#			>P_ADJ: CP  (current prices)
#			>INDIC: NA-B1GP  (GDP at market prices)
#			>GEO: IT  (Italy)

# this shows all ei_nama_q available for IT, by downloading everything, so
#     it is a bit slow (168 series)
nm = names(getSDMX('EUROSTAT', 'ei_nama_q.*.*.*.*.*.IT') )

#  there is only Quarterly series in above, so next is the same
# this works but serveral series have only  NaN values
tts = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.*.*.IT') 
names(tts)

# for (i in 1: length(tts)) print( any(! is.nan(tts[[i]])))
# for (i in 1: length(tts)) print( sum(! is.nan(tts[[i]])))

"ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B11.IT" %in% nm

# retrieves but values are NaN
# tts2 = getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B11.IT") 

# this works and the series has data starting 1990Q1 (NaN prior to 1990)
tts2 = getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT") 
names(tts2)

tts2 = getSDMX('EUROSTAT', 
        "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT", start="1990")

tts2 = getSDMX('EUROSTAT', 
        "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT", start="1990", end="2012")

#  ?? how do I specify an end date?
tts2 = getSDMX('EUROSTAT', 
        "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT", start="1990", end="2012Q2")

tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.MIO-EUR.NSA.CP.*.IT') # works 28 series
names(tts2)

nm[167]   #                "ei_nama_q.Q.MIO-EUR.NSA.CP.NA-P72.IT"
nm[168]   #                "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT"

#tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.*.*.IT')   # works
#tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.CP.*.IT')  # works
#tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.NSA.CP.*.IT')  # works
tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.MIO-EUR.NSA.CP.*.IT')  # works
#tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.CP.*.*.*') NO
names(tts2)
# for (i in 1: length(tts2)) print( any(! is.nan(tts2[[i]])))
# for (i in 1: length(tts2)) print( sum(! is.nan(tts2[[i]])))


names(tts2)

# This works (mostly?) but once returned an empty result rather than an error
z <- getSDMX('EUROSTAT', 'ei_nama_q.Q.MIO-EUR.NSA.CLV2000.*.IT')
with message
SEVERE: Exception. Class: it.bankitalia.reri.sia.util.SdmxException .Message: Exception. Class: java.net.UnknownHostException .Message: ec.europa.eu

######################################

#  other RJSDMX functions

######################################

# getCodes
dims <- getCodes('ECB', 'EXR', 'FREQ')

# getDimensions
dims <-  getDimensions('ECB','EXR')

# getDSDIdentifier
id <-  getDSDIdentifier('ECB','EXR')

#  addProvider(name, agency, endpoint, needsCredentials)
#In the next release you will not need to specify the agency.

## The addProvider function works only on SDMX 2.1 fully compliant providers. 
# All other versions of SDMX are "not so standard", and it is impossible (at 
# others are a 'custom' client

addProvider(name='test', agency='ECB',
    endpoint='http://sdw-wsrest.ecb.europa.eu/service', FALSE)

z <- getSDMX('test', 'EXR.A.USD.EUR.SP00.A')
z <- getSDMX('test', 'EXR.A.USD.EUR.SP00.A', start = "2001")

#http://sdw-wsrest.ecb.europa.eu/service/data/EXR/A.USD.EUR.SP00.A?startPeriod=2001

######################################

#  Notes regarding not yet providers 
#  These have SDMX but not sure about REST 

#  see also organizations listed at
# http://sdmx.org/wp-content/uploads/2014/09/SWG_members_8-9-2014.pdf

######################################

############################ UN ############################

R example using json at
http://comtrade.un.org/data/Doc/api/ex/r


# no SDMX yet but coming
http://comtrade.un.org/data/doc/api/
http://comtrade.un.org/data/doc/api/#Future

UN Comtrade data request takes the following form:
http://comtrade.un.org/api/get?parameters
API call: http://comtrade.un.org/api/get?max=50000&type=C&freq=A&px=HS&ps=2013&r=826&p=0&rg=all&cc=AG2&fmt=json

http://comtrade.un.org/api/get?max=50000&type=C&freq=A&px=HS&ps=2013&r=826&p=0&rg=all&cc=AG2&fmt=sdmx

#Old
#http://unstats.un.org/unsd/tradekb/Knowledgebase/Comtrade-SDMX-Web-Services-and-Data-Exchange
#http://unstats.un.org/unsd/tradekb/Knowledgebase/Comtrade-SDMX-Web-Services-and-Data-Exchange?Keywords=SDMX

######################## World Bank #######################
# See http://data.worldbank.org/developers
# and specifics at http://data.worldbank.org/node/11


############################ IStat ############################

# http://sodi.istat.it/sodiWS/service1.asmx.


############################ IMF ############################

#http://www.imf.org

#http://www.imf.org/external/np/ds/matrix.htm

############################ JEDH ############################

#http://www.jedh.org/jedh_dbase.html


############################ WHO ############################
# their XLM looks like SDMX but does not say it is
# see
# http://apps.who.int/gho/data/node.resources
# http://apps.who.int/gho/data/node.resources.api?lang=en
# http://apps.who.int/gho/data/node.resources.examples?lang=en

# dimensions
#http://apps.who.int/gho/athena/api/ 

# example
# http://apps.who.int/gho/athena/api/GHO/WHOSIS_000001 
# http://apps.who.int/gho/athena/api/GHO/WHOSIS_000001?filter=COUNTRY:BWA 

############################ Federal Reserve Board ############################
#Consumer credit from all sources (I think)
#https://www.federalreserve.gov/datadownload/Output.aspx?rel=G19&series=79d3b610380314397facd01b59b37659&lastObs=&from=01/01/1943&to=12/31/2010&filetype=sdmx&label=include&layout=seriescolumn


############################ Statistics Canada ############################


############################  Bank of Canada  ############################


############################  Fisheries and Oceans  ############################


FAO Fisheries has currently this SDMX 2.1 REST API with SDMX 2.0 messages:
http://www.fao.org/figis/sdmx/
FAO will publish this year also:
http://data.fao.org/sdmx/
