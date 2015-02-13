######################## World Bank #######################

# See http://data.worldbank.org/developers
#http://api.worldbank.org/data/WB/2/chn;ind/sp.pop.totl?format=generic

require("RJSDMX")

#  sdmxHelp()

#  getFlows('WB') # $WDI

#  getDimensions('WB', 'WDI') 
#  $FREQ     [1] "WB/CL_FREQ_WDI"
#  $SERIES   [1] "WB/CL_SERIES_WDI"
#  $REF_AREA [1] "WB/CL_REF_AREA_WDI"

# names(getCodes('WB', 'WDI', 'FREQ'))

#BM_GSR_MRCH_CD  Goods imports (BoP, current US$)
#BM_GSR_NFSV_CD  Services imports (BoP, current US$)

#The World Bank (beta) has a slightly unconventional indication for time series. #Hopefully this will change in a future releases.
#Even if the declared structure is FREQ.SERIES.REF_AREA, you have to build
# the queries as REF_AREA.SERIES. for example:

# SO FAR THIS HAS NEVER WORKED
  if(! TSsdmx::verifyQuery('WB', 'WDI.*.*.USA'))
     stop("Query 1 does not verify. Provider changed something.")

  a = getSDMX('WB', 'WDI.A.SP_POP_TOTL.USA', start='2000', end='2010')

  a = getSDMX('WB', 'WDI/CHN.SP_POP_TOTL', start='2000', end='2010')
or
  a = getSDMX('WB', 'WDI/USA.SP_POP_TOTL', start='2000', end='2010')

  z <- getSDMX('WB', 'WDI/.USA.SP_POP_TOTL')

  z <- getSDMX('WB', 'WDI...')
  z <- getSDMX('WB', 'WDI.*.*.*')
  z <- getSDMX('WB', 'WDI/.*.*.*')

  z <- getSDMX('WB', 'WDI.A.*.*')
  z <- getSDMX('WB', 'WDI.Q.*.*')
  z <- getSDMX('WB', 'WDI.A.BM_GSR_MRCH_CD.CAN')

  z <- getSDMX('WB', 'WDI.CAN.A.BM_GSR_MRCH_CD')

  if(start(z[[1]]) !=  1970)  stop("test 2 start date changed.")
  if(frequency(z[[1]]) !=  1) stop("test 2  frequency changed.")
  if(length(z) !=  3)  stop("test 2  frequency changed.")
