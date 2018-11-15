require("RJSDMX")


############################ EUROSTAT ############################

#[ http://epp.eurostat.ec.europa.eu/portal/page/portal/eurostat/home ]

#http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/search_database
#   >Economy and finance
#      >National accounts (including GDP) (ESA10) (ESA95) (na
#         >Quarterly national accounts (namq) 
#              >GDP and main components (namq_gdp)

  
  nm <- getFlows('EUROSTAT')
  length(nm)  # 5717 on 7 Nov 2014, 6322 on 5 May 2017, 6355 on Oct 5 2018
  
  if (1 != length(getFlows('EUROSTAT', "namq_10_gdp"))) #previously namq_gdp_c
        stop("EUROSTAT namq_10_gdp name changed.")

# flow disappeared  Oct 5 2018
#  if (1 != length(getFlows('EUROSTAT', "ei_nama_q")))
#        stop("EUROSTAT ei_nama_q name changed.")

  names(getDimensions('EUROSTAT','namq_10_gdp')) 
#    [1] "FREQ"    "UNIT"    "S_ADJ"   "NA_ITEM" "GEO"    

  if (! 'Q' %in%   names(getCodes('EUROSTAT','namq_10_gdp', 'FREQ')))
     stop("EUROSTAT namq_10_gdp flow FREQ codes changed.")

  if (! 'CP_MEUR' %in%   names(getCodes('EUROSTAT','namq_10_gdp', 'UNIT')))
     stop("EUROSTAT namq_10_gdp flow UNIT codes changed.")

  if (! 'SCA' %in%   names(getCodes('EUROSTAT','namq_10_gdp', 'S_ADJ')))
     stop("EUROSTAT namq_10_gdp flow S_ADJ codes changed.")

  if (! 'P71' %in%   names(getCodes('EUROSTAT','namq_10_gdp', 'NA_ITEM')))
      stop("EUROSTAT namq_10_gdp flow NA_ITEM codes changed.")

  if (! 'IT' %in%   names(getCodes('EUROSTAT','namq_10_gdp', 'GEO')))
      stop("EUROSTAT namq_10_gdp flow GEO codes changed.")

#### quarterly ####
  # as of Sept 2015 next fails if compression is enabled (BUG #76)
  # compression can be disbled in .SdmxClient config file.
  # a of May 2017 this series is not available
  #tts1 <- getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT") 
  #  pre Oct 2018
  #tts1 <- getSDMX('EUROSTAT', "ei_nama_q.Q.MIO_EUR.SCA.CP.NA-P71.IT") 
  #  switched to this Oct 2018
  tts1 <- getSDMX('EUROSTAT', "namq_10_gdp.Q.CP_MEUR.SCA.P71.IT") 

  names(tts1)

  if("1975 Q1" != start(tts1[[1]]))
                   stop("start test for EUROSTAT quarterly data failed.")

  if(4 != frequency(tts1[[1]])) 
             stop(  "frequency test for EUROSTAT quarterly data failed.")

  #tts2 <- getSDMX('EUROSTAT', "ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT",
  # switched from above, May 2017, again Oct 2018
  tts2 <- getSDMX('EUROSTAT', "namq_10_gdp.Q.CP_MEUR.SCA.P71.IT",
                  start="1990")[[1]]

  if("1990 Q1" != start(tts2))
        stop("EUROSTAT quarterly start specification 2 failure.")

  tts3 <- getSDMX('EUROSTAT', "namq_10_gdp.Q.CP_MEUR.SCA.P71.IT",
	    start="1990-Q1", end="2012-Q2")[[1]]

  if("1990 Q1" != start(tts3))
        stop("EUROSTAT quarterly start specification 3 failure.")
  if("2012 Q2" != end(tts3))
        stop("EUROSTAT quarterly  end  specification 3 failure.")

  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.*.*.IT')   # works
  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.CP.*.IT')  # works
  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.NSA.CP.*.IT')  # works
  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.*.*.CP.*.*.*') NO

  #tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.MIO-EUR.NSA.*.*.IT') 
       #  above has 84 series Feb 2015, but may change
  # tts2 = getSDMX('EUROSTAT', 'ei_nama_q.Q.MIO_EUR.NSA.CP.*.IT') #  28 series
  tts2 = getSDMX('EUROSTAT', 'namq_10_gdp.Q.CP_MEUR.SCA.*.IT') #  39 series
  names(tts2)
  #tts2[[28]]

  # for (i in 1: length(tts2)) print( any(! is.nan(tts2[[i]])))
  # for (i in 1: length(tts2)) print( sum(! is.nan(tts2[[i]])))


  # z <- getSDMX('EUROSTAT', 'ei_nama_q.Q.MIO_EUR.NSA.CLV2000.*.IT')[[1]]

  # if("1980 Q1" != start(z)) stop("EUROSTAT quarterly retrieval start changed.")
  # if(4 != frequency(z)) stop("EUROSTAT quarterly retrieval frequency error.")
  

