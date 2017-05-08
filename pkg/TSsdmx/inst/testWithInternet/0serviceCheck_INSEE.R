######################## INSEE #######################

#CNT-2010-S15-EMP   Quarterly National Accounts ...
#BMP6-CTRANSACTION  Monthly BOP

require("RJSDMX")

#  sdmxHelp()
  
  if(! 'CNT-2010-CSI-EMP' %in% names(getFlows('INSEE')))
     stop("CNT-2010-CSI-EMP has disappeared from INSEE flows. Provider changed something.")


  names(getDimensions('INSEE','CNT-2010-CSI-EMP')) #"SECT-INST" "TYPE-EMP" 

  #getCodes('INSEE','CNT-2010-CSI-EMP', 'TYPE-EMP')
  #names(getCodes('INSEE','CNT-2010-CSI-EMP', 'TYPE-EMP')) 

  # in flow 'CNT-2010-CSI-EMP get all "TYPE-EMP" series with other dimensions 'S1.*'
  tts0 <- getSDMX('INSEE', 'CNT-2010-CSI-EMP.S1.*')  
  nm <- names(tts0)
  length(nm)   # 441 but only two ($EMPNS and $EMPS) appear to have data in May 2017

#EMP is a code in dimension TYPE-EMP. S1 is a code in dimension SECT-INST
# hasDataCodes( providor='INSEE', flow='CNT-2010-CSI-EMP',  template='S1.*',  wild='TYPE-EMP')# 2
# hasDataCodes( providor='INSEE', flow='CNT-2010-CSI-EMP',  template='*.EMP', wild='SECT-INST')#none

# hasDataCodes( providor='INSEE', flow='IPC-2015-CVS',  template='*.NIVEAU', wild='FREQ') #none
# hasDataCodes( providor='INSEE', flow='IPC-2015-CVS',   template='A.*',  wild='NATURE') #"Weighting"

   
  z <- getSDMX('INSEE', 'CNT-2010-CSI-EMP.S1.EMPS')
#   RETURNING TWO SERIES  ??BUG??
  z[[1]]
  z[[2]]
  z[[1]] - z[[2]]
  
    
  z <- getSDMX('INSEE', 'CNT-2010-CSI-EMP.*.*')


hasData(z)
hasDataCount(z)
hasDataNames(z)
hasDataDescriptions(z)

  if(start(z[[1]]) !=  1979)  stop("test 1 start date changed.")
  if(frequency(z[[1]]) !=  1) stop("test 1  frequency changed.")

#  COULD DO MORE TESTS, EG  DIFFERENT FREQ
