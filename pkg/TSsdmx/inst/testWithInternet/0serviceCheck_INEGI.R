if (FALSE) {
########################### "INEGI" ###########################
##### Instituto Nacional de Estadistica y Geografia (Mexico) ######

#For further info about the provider content you may want to check the INEGI SDMX page:
#http://www.inegi.org.mx/inegi/contenidos/servicios/sdmx/

#  sdmxHelp()

require("RJSDMX")

#why slash? in DF_STEI/
  tts = getTimeSeries("INEGI", "DF_STEI/..C1161+C1162+C5004.....") #works sometimes
  tts = getSDMX("INEGI", "DF_STEI/..C1161+C1162+C5004.....") #works sometimes
  
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
  tts <- getSDMX("INEGI", 'DF_COMTRADE.*.*.*.*.*.*.*.*.*.*') # very slow responding, then #Error in .jcall("RJavaTools", "Ljava/lang/Object;", "invokeMethod", cl,  : 
#    it.bankitalia.reri.sia.util.SdmxException: Exception. Class: java.net.SocketException #.Message: Connection reset
    
  #names(tts)
 
}
