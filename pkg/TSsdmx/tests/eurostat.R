require("TSsdmx")

eurostat <- TSconnect("sdmx", dbname="EUROSTAT")

z <- TSget("ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B11.IT", eurostat) # works

require("tframe")
if (seriesNames(z) != "ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B11.IT")
    stop("seriesNames not set properly in eurostat test 1.")
    
TSmeta(z)

if (start(z) != "1980 Q1") stop("eurostat test 1 start date has changed.")


# z <- TSget("ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT", start="1990", end="2012Q2", eurostat)


# 28 series
#z <- TSget('ei_nama_q.Q.MIO-EUR.NSA.CP.*.IT', eurostat) # all NaN
z <-  TSget("ei_nama_q.Q.MIO-EUR.NSA.CLV2000.*.IT", eurostat) #  works

if (28 != sum(grepl("ei_nama_q.Q.MIO-EUR.NSA.", seriesNames(z)) ) )
    stop("seriesNames not set properly in eurostat test 1.")


#TSmeta(z)
