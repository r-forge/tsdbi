require("RJSDMX")

############################ "OECD ############################

  names(getDimensions('OECD','G20_PRICES')) # I think this is also in correct order
  getCodes('OECD', 'G20_PRICES', 'FREQUENCY')
 
#  message: Internal Server Error Dec 10,2014
#  nm <- getFlows('OECD')
#  names(nm)
#  nm['G20_PRICES']
#  
#  nm[grepl('TRADE', names(nm))]
#  nm[grepl('WATER', names(nm))]
#  nm[grepl('FISH', names(nm))]

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
 

  #### quarterly data  ####

#   test "+" and "|" in query 
  tts <-  getSDMX('OECD', 'QNA.CAN+USA|MEX.PPPGDP.CARSA.Q')

  if (! all(names(tts) == 
      c("QNA.CAN.PPPGDP.CARSA.Q", "QNA.MEX.PPPGDP.CARSA.Q", "QNA.USA.PPPGDP.CARSA.Q")))
             stop("OECD quarterly retrieval series names changed.")

  if(start(tts[[1]]) != "1960 Q1") stop("OECD quarterly retrieval  changed start date.")
  if(frequency(tts[[1]]) != 4)  stop("OECD quarterly retrieval  frequency changed.")


  #### annual data  ####

  tts <- getSDMX('OECD', '7HA_A_Q.CAN.*.*.*.*')
  names(tts)

  if (names(tts)[[1]] != "7HA_A_Q.CAN.AF411LI.ST.C.A")
             stop("OECD annual retrieval  first series changed.")

  if(start(tts[[1]]) != "1995") stop("OECD annual retrieval  changed start date.")
  if(frequency(tts[[1]]) != 1)  stop("OECD annual retrieval  frequency changed.")


  tts <- getSDMX('OECD', '7HA_A_Q.CAN.AF411LI.ST.C.A', start="2001", end="2009")
  if(start(tts[[1]]) != "2001") stop("OECD annual retrieval start date error.")
  if(end(tts[[1]]) != "2009")   stop("OECD annual retrieval end date error.")
