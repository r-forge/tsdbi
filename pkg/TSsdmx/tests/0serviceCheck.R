# see
#http://sdmx.org/wp-content/uploads/2013/09/SDMX_2_1-SECTION_07_WebServicesGuidelines_2013-04.pdf
# section 5.8 regarding errors.

require("RJSDMX")

#  https://github.com/amattioc/SDMX/wiki

# to install devel version from Github
# require(devtools)
# install_github(repo = "SDMX", subdir = "amattioc/RJSDMX")

# check installed version
# installed.packages()["RJSDMX",c("Package","Version")] 
# used 1.1 testing to 6 Nov 2014
#      1.2 installed from github 6 Nov 2014

# Package rJava may be needed interactively for experimenting but should be found
#   in the the namespace when everything is working.
# require("rJava")


# When the package is loaded there is an indication if/where 
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


##########  Notes on finding identifiers (e.g. EuroStat) ##################

# sdmxHelp()  # This is very helpful

#>EUROSTAT  ei_nama_q : Main aggregates - quarterly
# 	eil_nama_q  > 	>FREQ: Q
#			>UNIT : MIO-EUR
#			>S_ADJ: NSA
#			>P_ADJ: CP  (current prices)
#			>INDIC: NA-B1GP  (GDP at market prices)
#			>GEO: IT  (Italy)

# This shows all ei_nama_q available for IT, by downloading everything, so
#     it is a bit slow (168 series)
# nm <- names(getSDMX('EUROSTAT', 'ei_nama_q.*.*.*.*.*.IT') )
# length(nm)  # 168

#  There are only Quarterly series in above, so next is the same (and also slow).
#  It works but several series have only  NaN values

#    tts <-  getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.*.*.IT') 
#    names(tts)

# for (i in 1: length(tts)) print( any(! is.nan(tts[[i]])))
# for (i in 1: length(tts)) print( sum(! is.nan(tts[[i]])))

# "ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B11.IT" %in% nm

# Retrieves but values are NaN
# tts2 <- getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B11.IT") 

# This works and the series has data starting 1990Q1 (NaN prior to 1990)
#  tts2 <- getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT") 


#  sdmxHelp()
# "ILO" server is (temporarily?) not working

getProviders()
#[1] "BIS"      "ILO"      "ECB"      "OECD"     "EUROSTAT"       with v1.1
#[1] "ILO"      "ECB"      "INEGI"    "OECD"     "EUROSTAT" "IMF" with v1.2


############################ "ILO" ############################
# http://www.ilo.org/
# The server process which provides information to sdmxHelp() is having problems
#  (Actually, not just the sdmxHelp. The server is not available.)

#####  FAILURE #####:  ILO  is dead
 z <- try(getFlows('ILO') )

if(inherits(z, "try-error")) {
      warning("ILO server failing. Skipping ILO tests.")
   } else {
      tts <- getSDMX("ILO", 'EAP_TEAP_SEX_AGE_NB.AUS.*.*.*')
   }


############################ "ECB" ############################
  getFlows('ECB')

  getFlows('ECB','*EXR*')

  getCodes('ECB', 'EXR', 'FREQ')
  names(getDimensions('ECB','EXR')) # I think this is also in correct order
  getDimensions('ECB','EXR')

  getDSDIdentifier('ECB','EXR')

#### annual ####
  
  z <- getSDMX("ECB", 'EXR.A.USD.EUR.SP00.A')
  if(1999 != start(z[[1]])) stop("ECB annual retrieval error.")

  z <- getSDMX("ECB", 'EXR.A.USD.EUR.SP00.A', start = "2001", end = "2012")
  if(2001 != start(z[[1]])) stop("start test for ECB annual data failed.")
  if(2012 != end(z[[1]]))   stop(  "end test for ECB annual data failed.")

  
#### monthly ####

  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A')

  if("Jan 1999" != start(z[[1]])) stop("ECB monthly retrieval error (start check).")
  if(12 != frequency(z[[1]])) stop("ECB monthly retrieval error (frequency check).")

  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A', start="2008", end="2013")
  if("Jan 2008" != start(z[[1]])) stop("ECB monthly start specification 1 failure.")

  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A', start="2008-05", end="2014-07")[[1]]
  if("May 2008" != start(z)) stop("ECB monthly start specification 2 failure.")
  if("Jul 2014" != end(z))   stop("ECB monthly  end  specification 2 failure.")

  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A', start="2008-Q1", end="2014-Q2")[[1]]
  if("Jan 2008" != start(z)) stop("ECB monthly start specification 3 failure.")
  if("Jun 2014" != end(z))   stop("ECB monthly  end  specification 3 failure.")

  z <- getSDMX("ECB", 'EXR.M.USD.EUR.SP00.A',
                       start="2008-01-01", end="2014-01-31")[[1]]
  if("Jan 2008" != start(z)) stop("ECB monthly start specification 4 failure.")
  if("Jan 2014" != end(z))   stop("ECB monthly  end  specification 4 failure.")


#### quarterly ####

  z <- getSDMX("ECB", 'EXR.Q.USD.EUR.SP00.A')

  if("1999 Q1" != start(z[[1]]))
                   stop("ECB quarterly retrieval error (start check).")
  if(4 != frequency(z[[1]]))
                   stop("ECB quarterly retrieval error (frequency check).")

  z <- getSDMX("ECB", 'EXR.Q.USD.EUR.SP00.A', start="2008-Q2", end="2014-Q3")[[1]]
  if("2008 Q2" != start(z)) stop("ECB quarterly start specification 1 failure.")
  if("2014 Q3" != end(z))   stop("ECB quarterly  end  specification 1 failure.")

#### weeky data  ####

# "Frequency W. 

  z <- getSDMX("ECB", "ILM.W.U2.C.A010.Z5.Z0Z")
  
  if(start(z[[1]]) != "1998-W53") stop("ECB weeky retrieval changed start date.")


  # this would make sense but does not work
  #z <- getSDMX("ECB", "ILM.W.U2.C.A010.Z5.Z0Z",start="2008-W1",end="2013-W1")[[1]] 

  # I'm not sure if these are correct
  #z <- getSDMX("ECB", "ILM.W.U2.C.A010.Z5.Z0Z",start="2008-Q1",end="2013-Q4")[[1]] 
  > start(z)
[1] "2008-W02"
> end(z)
[1] "2014-W01"

  
  #if(start(z) != "1998-W53") stop("ECB weeky retrieval changed start date.")

  #z <- getSDMX("ECB", "ILM.W.U2.C.A010.Z5.Z0Z", start="2008", end="2013")[[1]] 
  #if(start(z) != "1998-W53") stop("ECB weeky retrieval changed start date.")

# Dates in above are in form 1998-W53. These might be converted to dates with
# require(ISOweek)
#    # assume Wednesday, weekday=3, but there may be more information
#    # available in the SDMX
#    dt <- as.Date(ISOweek::ISOweek2date(paste(times,"-3", sep="")))
#    tmp_ts <- zoo(values, order.by = dt)
#    }

#### daily data  ####

# select years
  z <- getSDMX('ECB', 'EXR.D.USD.EUR.SP00.A', '2000', '2001')[[1]]
  if("2000-01-03" != start(z)) stop("ECB daily start specification 1 failure.")
  if("2001-12-31" != end(z))   stop("ECB daily  end  specification 1 failure.")

 frequency(z)  check this

# select months
  z <- getSDMX('ECB', 'EXR.D.USD.EUR.SP00.A', '2000-01', '2000-12')[[1]]
  if("2000-01-03" != start(z)) stop("ECB daily start specification 2 failure.")
  if("2000-12-29" != end(z))   stop("ECB daily  end  specification 2 failure.")

# select quarters
  z <- getSDMX('ECB', 'EXR.D.USD.EUR.SP00.A', '2000-Q1', '2000-Q2')[[1]]
  if("2000-01-03" != start(z)) stop("ECB daily start specification 3 failure.")
  if("2001-12-31" != end(z))   stop("ECB daily  end  specification 3 failure.")

# select days
  z <- getSDMX('ECB', 'EXR.D.USD.EUR.SP00.A', '2000-01-01', '2000-01-31')[[1]]
  if("2000-01-03" != start(z)) stop("ECB daily start specification 4 failure.")
  if("2000-06-30" != end(z))   stop("ECB daily  end  specification 4 failure.")



## These get mixed monthly and annual frequency, but standard R time series
##  representations do not handle that very well.
##z1 <- getSDMX('ECB', 'EXR.A|M.USD.EUR.SP00.A')
##z2 <- getSDMX('ECB', 'EXR.A+M.USD.EUR.SP00.A')
## get mixed all available frequencies
##z <- getSDMX('ECB', 'EXR.*.USD.EUR.SP00.A')

############################ "OECD ############################

  names(getDimensions('OECD','G20_PRICES')) # I think this is also in correct order
  getCodes('OECD', 'G20_PRICES', 'FREQUENCY')
  
  nm <- getFlows('OECD')
  names(nm)
  nm['G20_PRICES']
  
  nm[grepl('TRADE', names(nm))]
  nm[grepl('WATER', names(nm))]
  nm[grepl('FISH', names(nm))]

  tts <- getSDMX('OECD', 'G20_PRICES.CAN.*.*.M')
  names(tts)
  

  #### monthly data  ####
  
  tts1  <-  getSDMX('OECD', 'G20_PRICES.CAN.*.IXOB.M')[[1]]	  
  if(start(tts1) != "Jan 1949") stop("OECD monthly retrieval changed start date.")
  if(frequency(tts1) != 12) stop("OECD monthly retrieval frequency changed.")
  
# Can only year, not period,  be specified for start and end?
# tts2 <- getSDMX('OECD', 'G20_PRICES.CAN.CPALTT01.IXOB.M', start="Jan 2010")

  tts2 <- getSDMX('OECD', 'G20_PRICES.CAN.CPALTT01.IXOB.M', start="2010")[[1]]
  if(start(tts2) != "Jan 2010") stop("OECD monthly retrieval 2 changed start date.")
  if(frequency(tts2) != 12) stop("OECD monthly retrieval 2 frequency changed.")
 

  #### annual data  ####

  tts <- getSDMX('OECD', '7HA_A_Q.CAN.*.*.*.*')
  names(tts)

  if (names(tts)[[1]] != "7HA_A_Q.CAN.AF411LI.ST.C.A")
             stop("OECD annual retrieval  first series changed.")

  if(start(tts[[1]]) != "1995") stop("OECD annual retrieval  changed start date.")
  if(frequency(tts[[1]]) != 1)  stop("OECD annual retrieval  frequency changed.")


############################ EUROSTAT ############################

#[ http://epp.eurostat.ec.europa.eu/portal/page/portal/eurostat/home ]

#http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/search_database
#   >Economy and finance
#      >National accounts (including GDP) (ESA95) (na
#         >Quarterly national accounts (namq) 
#              >GDP and main components (namq_gdp)

  names(getDimensions('EUROSTAT','ei_nama_q')) 
  getCodes('EUROSTAT','ei_nama_q', 'FREQ')
  
  nm <- getFlows('EUROSTAT')
  length(nm)  # 5717 on 7 Nov 2014
  
  getFlows('EUROSTAT', "namq_gdp_c")  # length 1

  getFlows('EUROSTAT', "ei_nama_q")  # length 1


#### quarterly ####

  tts1 <- getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT") 
  names(tts2)

  if("1980 Q1" != start(tts1[[1]]))
                   stop("start test for EUROSTAT quarterly data failed.")
  if(4 != frequency(tts1[[1]])) 
             stop(  "frequency test for EUROSTAT quarterly data failed.")

  tts2 <- getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT",
                  start="1990")[[1]]

  if("1990 Q1" != start(tts2))
        stop("EUROSTAT quarterly start specification 2 failure.")

  tts3 <- getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT",
	    start="1990-Q1", end="2012-Q2")[[1]]

  if("1990 Q1" != start(tts3))
        stop("EUROSTAT quarterly start specification 3 failure.")
  if("2012 Q2" != end(tts3))
        stop("EUROSTAT quarterly  end  specification 3 failure.")

  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.*.*.IT')   # works
  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.CP.*.IT')  # works
  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.NSA.CP.*.IT')  # works
  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.CP.*.*.*') NO

  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.MIO-EUR.NSA.CP.*.IT') #  28 series
  #names(tts2)

  #nm[167]   #                "ei_nama_q.Q.MIO-EUR.NSA.CP.NA-P72.IT"
  #nm[168]   #                "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT"

  # for (i in 1: length(tts2)) print( any(! is.nan(tts2[[i]])))
  # for (i in 1: length(tts2)) print( sum(! is.nan(tts2[[i]])))


  # z <- getSDMX('EUROSTAT', 'ei_nama_q.Q.MIO-EUR.NSA.CLV2000.*.IT')[[1]]

  # if("1980 Q1" != start(z)) stop("EUROSTAT quarterly retrieval start changed.")
  # if(4 != frequency(z)) stop("EUROSTAT quarterly retrieval frequency error.")
  
  
  # When it occures, the message
  # SEVERE: Exception. Class: it.bankitalia.reri.sia.util.SdmxException .Message: 
  # Exception. Class: java.net.UnknownHostException .Message: ec.europa.eu
  # should return an R error. (Occassionaly seems to return null result instead.)


######################## IMF #######################

  names(getDimensions('IMF','PGI')) 
  getCodes('IMF','PGI', 'FREQ')
  
  nm <- getFlows('IMF')
  names(nm)
  nm
  nm['PGI']

  # PGI
  #   REF_AREA.DATASOURCE.PGI_CONCEPT.FREQ.UNIT0FMEASURE
  #   CA: Canada
  #  IFS: International Financial Statistics  (BIS is and option)
  #  (003: National Accounts)
  #  FREQ
  #  L_M USD millions (N_M: National currency, Millions 
  #   (NSA_M: National currency SA, Millions)
  
  tts0 <- getSDMX('IMF', 'PGI.CA.*.*.*.*')	   #works but slow
  nm <- names(tts0)
  length(nm) # 627
  
  nm[grepl('PGI.CA.BIS.', nm )] # this suggests these should work but

  z <- tts0[grepl('PGI.CA.BIS.', nm )]
  
  tts0["PGI.CA.BIS.FOSLB.A.L_M"]  # this is not empty
  
  getSDMX('IMF', 'PGI.CA.BIS.FOSLB.A.L_M') # but this gives an empty result
 
#####  FAILURE #####:   empty result but retrieved above
  tts <- getSDMX('IMF', 'PGI.CA.BIS.*.*.L_M')	#fails (empty result)
  names(tts)
  
#####  FAILURE #####:   empty result but retrieved above
  tts <- getSDMX('IMF', "PGI.CA.BIS.FOSAB.Q.L_M") #fails (empty result)
  names(tts)
  
  #  even though it was returned above
  	"PGI.CA.BIS.FOSAB.Q.L_M" %in% nm  # TRUE
  #   and 
       tts0[["PGI.CA.BIS.FOSAB.Q.L_M" ]]

 
  nm[grepl('PGI.CA.IFS.', nm )] # this suggests these should work but

#####  FAILURE #####:   empty result but retrieved above
  tts <- getSDMX('IMF', 'PGI.CA.IFS.*.Q.N_M') #fails (empty result)
  names(tts)


########################### "INEGI" ###########################
##### Instituto Nacional de Estadistica y Geografia (Mexico) ######

#  http://www.inegi.org.mx/
  
  nm <- getFlows('INEGI')  # can be slow
  length(nm)  # 8
  names(nm)
  nm['DF_COMTRADE']

  getCodes('INEGI','DF_COMTRADE', 'FREQ')
  names(getDimensions('INEGI','DF_COMTRADE')) 
  
  #getCodes('INEGI','DF_STEI', 'FREQ')
  #names(getDimensions('INEGI','DF_STEI')) #can be slow

  nm[grepl('TRADE', names(nm))]
  nm[grepl('LABOUR', names(nm))]
  
  # DF_COMTRADE.
  #   FREQ.REF-AREA.HS2007.VIS_AREA_A3.STATISTICAL_CATEGORY.
  #	 VALUATION.CURRENCY_UNIT.UNIT_MEASURE.S_PARTNER.TRANSPORT_MODE
  
  #####  FAILURE #####:  
  #tts <- getSDMX("INEGI", 'DF_COMTRADE.Q.MX.TOTAL.CAN.*.*.USD.Z.CAN.*') #empty
  tts <- getSDMX("INEGI", 'DF_COMTRADE.Q.MX.TOTAL.CAN.*.*.USD.*.*.*') #empty & slow
  names(tts)

#####  FAILURE #####:  
  tts <- getSDMX("INEGI", 'DF_COMTRADE.Q.MX.TOTAL.*.*.*.USD.*.*.*')  #empty & slow
  # (previously failed with: Comment must start with "<!--". )

####  FAILURE #####:  
  tts <- getSDMX("INEGI", 'DF_COMTRADE.Q.MX.TOTAL.*.*.*.*.*.*.*')  #empty
  tts <- getSDMX("INEGI", 'DF_COMTRADE.*.MX.TOTAL.*.*.*.*.*.*.*')  #empty
  
#####  FAILURE #####:  
  tts <- getSDMX("INEGI", 'DF_COMTRADE.*.*.TOTAL.*.*.*.*.*.*.*')  #empty 
  # (previously failed with: Comment must start with "<!--". )
  
#####  FAILURE #####:  
  tts <- getSDMX("INEGI", 'DF_COMTRADE.*.*.*.*.*.*.*.*.*.*') # very slow responding, then Error in .jcall("RJavaTools", "Ljava/lang/Object;", "invokeMethod", cl,  : 
    it.bankitalia.reri.sia.util.SdmxException: Exception. Class: java.net.SocketException .Message: Connection reset
    
  #names(tts)
  
  
############################ "BIS" ############################
# need account, not available to the publicly as of Nov 2014
#addProvider(name='BIS', endpoint='xxx', TRUE)


###########################################################################
###########################################################################

#  Notes regarding not yet providers 
#  These have SDMX but not sure about REST 

#  see also organizations listed at
# http://sdmx.org/wp-content/uploads/2014/09/SWG_members_8-9-2014.pdf

###########################################################################


######################################
#  RJSDMX function addProvider

######################################

## The addProvider function works only on SDMX 2.1 fully compliant providers. 
# All other versions of SDMX are "not so standard", and it is impossible (at 
# others are a 'custom' client

  #addProvider(name='test', agency='ECB',   v1.1
  addProvider(name='test', 
    endpoint='http://sdw-wsrest.ecb.europa.eu/service', FALSE)

  z <- getSDMX('test', 'EXR.A.USD.EUR.SP00.A')


######################## World Bank #######################
# See http://data.worldbank.org/developers
# and specifics at http://data.worldbank.org/node/11

  addProvider(name='WB', 
     endpoint='http://api.worldbank.org/data', FALSE)


############ Swiss institute of StatisticsD ###############

# federal Swiss institute of statistics to disseminate their data in SDMX 
# and via a RESTful API.
# addProvider(name='SIS', 
#     endpoint='', FALSE)


############################ IStat ############################

# http://sodi.istat.it/sodiWS/service1.asmx.


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

################### Federal Reserve Board #####################

#Consumer credit from all sources (I think)
#https://www.federalreserve.gov/datadownload/Output.aspx?rel=G19&series=79d3b610380314397facd01b59b37659&lastObs=&from=01/01/1943&to=12/31/2010&filetype=sdmx&label=include&layout=seriescolumn


############################ Statistics Canada ############################


############################  Bank of Canada  ############################


############################  Fisheries and Oceans  ############################

# FAO Fisheries has currently this SDMX 2.1 REST API with SDMX 2.0 messages:
# http://www.fao.org/figis/sdmx/
# FAO will publish this year also:
# http://data.fao.org/sdmx/


############################ British ONS  ############################

# https://www.ons.gov.uk/ons/apiservice/web/apiservice/home
# http://stackoverflow.com/questions/tagged/ons-api



############################ INE (Spain)  ############################
# reference here:
#http://www.bfs.admin.ch/bfs/portal/en/index/news/veranstaltungen/blank/blank/pax/04.parsys.1169.downloadList.27646.DownloadFile.tmp/countryreportspain.pdf

Request for time series using the metadata
description of the concepts that intervene
(Population: dpop, Annual frequency
FREQ.A and NUTS2 AREA2.ES11):
http://servicios.ine.es/wstempus/SDMX/en/compact/dpop?metadata=FREQ.A:AREA_2.ES11: 

addProvider(name='INE', agency='INE',
    endpoint='http://servicios.ine.es/wstempus/', FALSE)

sdmxHelp()

tts <- getSDMX('INE', 'dpop')
names(tts)

########################## Australian Bureau of Statistics ####################

# The Australian Bureau of Statistics have an SDMX interface 
# http://www.abs.gov.au/ausstats/abs@.nsf/Lookup/1407.0.55.002main+features32013/  
# we haven't tried to RJSDMX to access it but it would be great if you were able to.
addProvider(name='ABS', 
    endpoint='http://stat.abs.gov.au/sdmxws/sdmx.asmx', FALSE)
addProvider(name='ABS', 
    endpoint='http://stat.abs.gov.au/restsdmx/sdmx.ashx', FALSE)
addProvider(name='ABS2', 
    endpoint='http://stat.abs.gov.au/restsdmx/', FALSE)

sdmxHelp()

#example

SDMX DATA URL:
http://stat.abs.gov.au/restsdmx/sdmx.ashx/GetData/MERCH_EXP/-.-1+0+1+2+3+4+5+6+7+8+9.-1.-.M/ABS?startTime=2014&endTime=2014

SDMX Data Structure Definition URL:
http://stat.abs.gov.au/restsdmx/sdmx.ashx/GetDataStructure/MERCH_EXP/ABS


############################ UN ############################

##R example using json at
##http://comtrade.un.org/data/Doc/api/ex/r


# no SDMX yet but coming
# http://comtrade.un.org/data/doc/api/
# http://comtrade.un.org/data/doc/api/#Future

# UN Comtrade data request takes the following form:
# http://comtrade.un.org/api/get?parameters
# API call: 
# http://comtrade.un.org/api/get?max=50000&type=C&freq=A&px=HS&ps=2013&r=826&p=0&rg=all&cc=AG2&fmt=json

# http://comtrade.un.org/api/get?max=50000&type=C&freq=A&px=HS&ps=2013&r=826&p=0&rg=all&cc=AG2&fmt=sdmx

#Old
#http://unstats.un.org/unsd/tradekb/Knowledgebase/Comtrade-SDMX-Web-Services-and-Data-Exchange
#http://unstats.un.org/unsd/tradekb/Knowledgebase/Comtrade-SDMX-Web-Services-and-Data-Exchange?Keywords=SDMX

