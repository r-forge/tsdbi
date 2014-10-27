require("RJSDMX")

#  https://github.com/amattioc/SDMX/wiki

# to install devel version from Github
# require(devtools)
# install_github(repo = "SDMX", username = "amattioc", subdir = "RJSDMX")

# Package rJava will be needed interactively for experimenting but should be found
#   in the the namespace in eventual testing.
# require("rJava")

#  sdmxHelp()
# "ILO" seems broken.
# "BIS" requires an account

getProviders()
#[1] "BIS"      "ILO"      "ECB"      "OECD"     "EUROSTAT"

############################ "BIS" ############################
# need account (free?)
#https://dbsonline.bis.org/

############################ "ILO" ############################
# temporarily broken?

############################ "ECB" ############################
# annual
z <- getSDMX("ECB", 'EXR.A.USD.EUR.SP00.A')
z <- getSDMX("ECB", 'EXR.A.USD.EUR.SP00.A', start = "", end = "")

# monthly
z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A')
#  How should start and end be specified?
#  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A', start="May 2008", end="Aug 2014")
#  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A', start=c(2008,5), end=c(2014,8))

# weeky data 
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

tts = getSDMX('OECD', 'G20_PRICES.CAN.*.*.M')
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

#   Note sure how this works yet
#  addProvider(name, agency, endpoint, needsCredentials)
#  This guess does not work
#  addProvider("ECBTEST", '4F0',
#    "http://sdw-wsrest.ecb.europa.eu/service/dataflow/ECB/EXR/latest" ,
#    needsCredentials=FALSE)
#z <- getSDMX("ECBTEST", 'EXR.A.USD.EUR.SP00.A')
#z <- getSDMX("ECB",     'EXR.A.USD.EUR.SP00.A')


######################################

#  Notes regarding not yet providers 
#  These have SDMX but not sure about REST 

#  see also organizations listed at
# http://sdmx.org/wp-content/uploads/2014/09/SWG_members_8-9-2014.pdf

######################################

############################ UN ############################

#http://unstats.un.org/unsd/tradekb/Knowledgebase/Comtrade-SDMX-Web-Services-and-Data-Exchange


######################## World Bank #######################
# See http://data.worldbank.org/developers
# and specifics at http://data.worldbank.org/node/11


############################ UN ############################
http://unstats.un.org/unsd/tradekb/Knowledgebase/Comtrade-SDMX-Web-Services-and-Data-Exchange?Keywords=SDMX

############################ IStat ############################

# http://sodi.istat.it/sodiWS/service1.asmx.


############################ IMF ############################

#http://www.imf.org

#http://www.imf.org/external/np/ds/matrix.htm

############################ JEDH ############################

#http://www.jedh.org/jedh_dbase.html


############################ Federal Reserve Board ############################
#Consumer credit from all sources (I think)
#https://www.federalreserve.gov/datadownload/Output.aspx?rel=G19&series=79d3b610380314397facd01b59b37659&lastObs=&from=01/01/1943&to=12/31/2010&filetype=sdmx&label=include&layout=seriescolumn


############################ Statistics Canada ############################


############################  Bank of Canada  ############################



