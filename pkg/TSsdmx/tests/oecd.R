require("TSsdmx")


oecd <- TSconnect("sdmx", dbname="OECD")

#  environmental indicators. single point, not series?
#  tts <- getSDMX('OECD', 'ENV_KEI.*.NOX_GDP')   # date problems
#  names(tts) # 34 countries
# z <- TSget('ENV_KEI.CAN.NOX_GDP', oecd)
# z <- TSget('ENV_KEI.*.NOX_GDP', oecd)


#  USING sdmxHelp()
#>OECD
# 	G20_PRICES > 	>LOCATION:CAN
#			>SUBJECT : CP   (CPI)
#			>MEASURE : IXOB (INDEX)
#			>FREQUENCY: M

z <- TSget('G20_PRICES.CAN.CPALTT01.IXOB.A',oecd)  # date problems
z <- TSget('G20_PRICES.CAN.CPALTT01.IXOB.M',oecd)  # date problems
# tts <- getSDMX('OECD', 'G20_PRICES.CAN.*.IXOB.M') 

# above is only subject:
# tts2 = getSDMX('OECD', 'G20_PRICES.CAN.*.IXOB.M')  #YES but date problems
# names(tts2)
# tts2 = getSDMX('OECD', 'G20_PRICES.CAN.*.IXOB.*')  #YES but date problems
# names(tts2)


#### monthly data ####

z <- TSget('G20_PRICES.CAN.CPALTT01.IXOB.M',oecd)  # date problems
seriesNames(z)

z <- TSget('G20_PRICES.CAN.*.IXOB.M', oecd)   # zoo date problems
tframe::seriesNames(z)
start(z)


#### quarterly data ####

# quarterly national accounts
#CARSA: national currency, nominal, SAAR (level)

z <- TSget('QNA.CAN.PPPGDP.CARSA.Q', oecd)

if("1960 Q1" != start(z)) stop('quarterly test start date is changed.')
if(4 != frequency(z)) stop('quarterly test frequency is changed.')

# tts <- getSDMX('OECD', 'QNA.CAN.*.*.*')
# names(tts)

# tts <- getSDMX('OECD', 'QNA.CAN.*.CARSA.Q')
# names(tts)

z <- TSget('QNA.*.PPPGDP.CARSA.Q', oecd)

if("1955 Q1" != start(z)) stop('quarterly mulivariate test start date is changed.')
if(4 != frequency(z)) stop('quarterly mulivariate test frequency is changed.')

# tfplot::tfplot(z, graphs.per.page=3)
# tfplot::tfOnePlot(z, start=c(1990,1))


z <- TSget('G20_PRICES.CAN.CPALTT01.IXOB.Q',oecd)  

if("1949 Q1" != start(z)) stop('quarterly prices test start date is changed.')
if(4 != frequency(z)) stop('quarterly test frequency is changed.')

# Annual only ??
z <- TSget('BSI.NAT.EQU.TOT.DIR.CAN', oecd)    # zoo date problems

# tts <- getSDMX('OECD', 'BSI.NAT.*.*.*.CAN')
# names(tts)



#####  annual #####
  
#>OECD  Household ... assets and liabilities ..
# 	7HA_A_Q > 	>LOCATION:CAN
#			>TRANSACTION : AF411LI (cons. cr No 7HAL2=liabilities)
#			>ACTIVITY : ST (stocks)
#			>MEASURE : C  (nominal CDN)
#			>FREQUENCY:  A only  *** Q does not exist ***


z <- TSget('7HA_A_Q.CAN.*.*.*.*', oecd)
tframe::seriesNames(z)

z <- TSget('7HA_A_Q.CAN.AF411LI.ST.C.A', oecd)

if(1995 != start(z)) stop('annual test start date is changed.')
if(1 != frequency(z)) stop('annual test frequency is changed.')

z <- TSget('7HA_A_Q.CAN.*.ST.C.A', oecd)

z <- TSget('7HA_A_Q.CAN.*.*.*.*', oecd)
tframe::seriesNames(z)

if(1995 != start(z)) stop('annual mulivariate test start date is changed.')
if(1 != frequency(z)) stop('annual mulivariate test frequency is changed.')

# need to catch error in this
z <- TSget('G20_PRICES.CAB.CP.IXOB.M',oecd)

