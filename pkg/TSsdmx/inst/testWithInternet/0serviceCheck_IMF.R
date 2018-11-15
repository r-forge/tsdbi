######################## IMF #######################
require("RJSDMX")

#  sdmxHelp()
# Oct 2018, 'IMF' is broken. Use 'IMF2'.
  
  if(! 'DS-PGI' %in% names(getFlows('IMF2')))
     stop("DS-PGI has disappeared from IMF2 flows. Provider changed something.")

  # IMF PGI codes were not working for some period prior to Feb 9, 2015. 
  #  but then started working again. 

  # PGI
  #  REF_AREA.DATASOURCE.PGI_CONCEPT.FREQ.UNIT0FMEASURE
  #     CA: Canada
  #  INDICATOR
  #    003: National Accounts
  #    IFS: International Financial Statistics
  #    AIP: Industrial Production
  #    BIS_BP6: Balance on Secondary Income
  #    NCG: Government Consumption Expenditure
  #    NGDP: Gross Domestic Product (Nominal)
  #  DATA SOURCE
  #    PGI: Principal Global Indicators
  #  UNIT
  #    L:  USD  
  #    N:   National currency 
  #    NSA: National currency SA
  #  FREQ
  #    A:  
  #    M:  
  #    Q:  

  names(getDimensions('IMF2','DS-PGI')) 
  # [1] "FREQ"      "REF_AREA"  "INDICATOR"
  getCodes('IMF2','DS-PGI', 'FREQ')
  getCodes('IMF2','DS-PGI', 'REF_AREA')
  
  if(! TSsdmx::verifyQuery('IMF2', 'DS-PGI.*.CA.*.'))
     stop("Query 1 does not verify. Provider changed something.")
  
  tts0 <- getSDMX('IMF2', 'DS-PGI.*.CA.*') # length 346 Oct 2018
  # previously on 'IMF' 'PGI' length # 627   #774 Feb 9, 2015
  nm <- names(tts0)
  length(nm) 
  
  #nm[grepl('PGI.CA.BIS.', nm )] 
  #[1] "PGI.CA.BIS_BP6.PGI.L.A" "PGI.CA.BIS_BP6.PGI.L.Q"  # Feb 9, 2015

  nm[grepl('.CA.BIS', nm )] 
  #[1] "DS-PGI.Q.CA.BIS_BP6_USD" "DS-PGI.A.CA.BIS_BP6_USD" # Oct 2018

  # note that grepl uses . as any char 
  #z <- tts0[grepl('CA.BIS', nm )]
    
  #z <- getSDMX('IMF', 'PGI.CA.BIS_BP6.PGI.L.A')
  # start was 2005 for awhile (circa spring 2015)
  z <- getSDMX('IMF2', 'DS-PGI.A.CA.BIS_BP6_USD')
  if(start(z[[1]]) !=  1948)  stop("test 1 start date changed (again).")
  if(frequency(z[[1]]) !=  1) stop("test 1  frequency changed.")

  z <- getSDMX('IMF2', 'DS-PGI.Q.CA.BIS_BP6_USD')	
  names(z)
  if(start(z[[1]]) !=  "1950 Q1")  stop("test 2 start date changed (again).")
  if(frequency(z[[1]]) !=  4) stop("test 2  frequency changed.")
  
