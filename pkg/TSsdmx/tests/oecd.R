require("TSsdmx")


oecd <- TSconnect("sdmx", dbname="OECD")
z <- TSget('CPIAUCNS',oecd)


z <- TSget('G20_PRICES.CAN.*.IXOB.M', oecd)   # zoo date problems
seriesNames(z)
start(z)

z <- TSget('G20_PRICES.CAN.CPALTT01.IXOB.M', oecd)  # zoo date problems
seriesNames(z)


#tts = getSDMX('OECD', '7HA_A_Q.CAN.*.*.*.*')

z <- TSget('7HA_A_Q.CAN.*.*.*.*', oecd)
seriesNames(z)
Error in `seriesNames<-.default`(`*tmp*`, value = "7HA_A_Q.CAN.*.*.*.*") : 
  length of names (1) does not match number of series(42).

seriesNames(z)s(tts)
tts2 = getSDMX('OECD', '7HA_A_Q.CAN.*.*.*.*')


#  USING sdmxHelp()
#>OECD
# 	G20_PRICES > 	>LOCATION:CAN
#			>SUBJECT : CP   (CPI)
#			>MEASURE : IXOB (INDEX)
#			>FREQUENCY: M
tts2 = getSDMX('OECD', 'G20_PRICES.CAN.CPALTT01.IXOB.M')  YES

z <- TSget('G20_PRICES.CAN.CP.IXOB.M',oecd)
z <- getSDMX('OECD', 'G20_PRICES.CAN.CP.IXOB.M')
z <- getSDMX('OECD', 'CL_G20_PRICES.M.CAN.CP.IXOB')
z <- getSDMX('OECD', 'CL_G20_PRICES.CAN.CP.IXOB.M')

z <- getSDMX('OECD', 'G20_PRICES.CAN.CP.IXOB.Q')
z <- getSDMX('OECD', 'CL_G20_PRICES.CAN.CP.IXOB.Q')
z <- getSDMX('OECD', 'CL_G20_PRICES.Q.CAN.CP.IXOB')
z <- getSDMX('OECD', 'CL_G20_PRICES.CAN.CP.IXOB.Q')

#>OECD  Household ... assets and liabilities ..
# 	7HA_A_Q > 	>LOCATION:CAN
#			>TRANSACTION : AF411LI (cons. cr No 7HAL2=liabilities)
#			>ACTIVITY : ST (stocks)
#			>MEASURE : C  (nominal CDN)
#			>FREQUENCY: Q does not exist use A

# tts = getSDMX('OECD', '7HA_A_Q.CAN.*.*.*.*')
# names(tts)
#
# tts2 = getSDMX('OECD', '7HA_A_Q.CAN.*.*.C.A') YES
# tts2 = getSDMX('OECD', '7HA_A_Q.CAN.*.ST.C.A') YES
# tts2 = getSDMX('OECD', '7HA_A_Q.CAN.AF411LI.ST.C.A') YES
# tts2 = getSDMX('OECD', '7HA_A_Q.CAN.AF411LI.ST.C.Q') NO
# names(tts2)

z <- TSget('7HA_A_Q.CAN.AF411LI.ST.C.A', oecd)

this drop multiv series
z <- TSget('7HA_A_Q.CAN.*.ST.C.A', oecd)


need to catch error in this
z <- TSget('G20_PRICES.CAB.CP.IXOB.M',oecd)

