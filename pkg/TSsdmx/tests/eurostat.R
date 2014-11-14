require("TSsdmx")
require("tframe")

eurostat <- TSconnect("sdmx", dbname="EUROSTAT")

z <- TSget("ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B1G.IT", eurostat) # works

if (seriesNames(z) != "ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B1G.IT")
    stop("seriesNames not set properly in eurostat test 1.")
    
TSmeta(z)

if (start(z) != "1980 Q1") stop("eurostat test 1 start date has changed.")


z <- TSget("ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT",
           start="1990-Q1", end="2012-Q2", eurostat)

if (start(z) != "1990 Q1") stop("eurostat test 2 start date failure.")
if ( end(z)  != "2012 Q2") stop("eurostat test 2 stop  date failure.")


#z <- TSget('ei_nama_q.Q.MIO-EUR.NSA.CP.*.IT', eurostat) # all NaN

# 28 series, 23 with data
z <-  TSget("ei_nama_q.Q.MIO-EUR.NSA.CLV2000.*.IT", eurostat) 

if (23 != sum(hasData(z, quiet=TRUE)))    stop("eurostat hasData test changed.")
if (28 != length(hasData(z, quiet=TRUE))) stop("eurostat hasData test 2 changed.")

hasDataCount(z)
hasDataNames(z)

hasDataDescriptions(z)



#  This is a useful check to know if a series has data
# "ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B11.IT" %in% hasDataNames(z)

