require("RJSDMX")

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
  
  tts0 <- getSDMX('IMF', 'PGI.CA.*.*.*.*')	#13 BUG works but slow. not working in 1.3
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

# BUG #13 repeating from above. Remove
  tts0 <- getSDMX('IMF', 'PGI.CA.*.*.*.*') #  BUG tts not found
# previously
  tts0 <- getSDMX('IMF', 'PGI.CA.*.*.*.*')["PGI.CA.BIS.FOSLB.A.L_M"] # not empty BUG
  tts1 <- getSDMX('IMF', 'PGI.CA.BIS.FOSLB.A.L_M') #  empty result
