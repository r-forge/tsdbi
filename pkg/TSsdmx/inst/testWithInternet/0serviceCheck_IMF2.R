######################## IMF2 #######################
require("RJSDMX")


#  sdmxHelp()
  
  if(! 'DS-BOP' %in% names(getFlows('IMF2')))
     stop("DS-BOP has disappeared from IMF2 flows. Provider changed something.")


  names(getDimensions('IMF2','DS-BOP')) #"FREQ" "REF_AREA" "INDICATOR"

  getCodes('IMF2','DS-BOP', 'FREQ')
  #names(getCodes('IMF2','DS-BOP', 'FREQ')) #[1] "W" "A" "Q" "D" "M" "B"

  #TSsdmx::hasDataCodes( providor='IMF2',  flow='DS-BOP', template='A.MX.*', wild='INDICATOR')

  # available, containing data, with description containing 'Current Account, Total'
  #TSsdmx::hasDataCodes( providor='IMF2',  flow='DS-BOP', template='A.MX.*', wild='INDICATOR',
  #     gp= c('Current Account', 'Total'))


  #  using net which is  $BCA_BP6_USD
   
  z <- getSDMX('IMF2', 'DS-BOP.A.MX.BCA_BP6_USD')

  if(start(z[[1]]) !=  1979)  stop("test 1 start date changed.")
  if(frequency(z[[1]]) !=  1) stop("test 1  frequency changed.")


  if(! 'DS-PGI' %in% names(getFlows('IMF2')))
     stop("DS-PGI has disappeared from IMF2 flows. Provider changed something.")

  names(getDimensions('IMF2','DS-PGI')) # "FREQ"      "REF_AREA"  "INDICATOR"
  getCodes('IMF2','DS-PGI', 'FREQ')
  
  if(! TSsdmx::verifyQuery('IMF2', 'DS-PGI.*.CA.*'))
     stop("Wildcard query 1 does not verify. Provider changed something.")
  
  tts0 <- getSDMX('IMF2', 'DS-PGI.*.CA.*')   # length  897 May 8, 2017 (many zero slots
  nm <- names(tts0)
  length(nm) 
  
  # note that grepl uses . as any char so this gets above
  nm[grepl('.CA.BIS.', nm )] 
  #[1] "DS-PGI.Q.CA.BIS_BP6_USD" "DS-PGI.A.CA.BIS_BP6_USD" #May 8, 2017
    

  z <- getSDMX('IMF2', 'DS-PGI.A.CA.BIS_BP6_USD')
  
  if(start(z[[1]]) !=  1948)  stop("annual test start date changed.")
  if(frequency(z[[1]]) !=  1) stop("annual test  frequency changed.")
    

  z <- getSDMX('IMF2', 'DS-PGI.Q.CA.BIS_BP6_USD')
  
  if(start(z[[1]]) !=  "1950 Q1")  stop("quarterly test start date changed.")
  if(frequency(z[[1]]) !=  4)      stop("quarterly test  frequency changed.")

