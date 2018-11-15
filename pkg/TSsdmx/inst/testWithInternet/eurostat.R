require("TSsdmx")
require("tframe")

# RJSDMX::sdmxHelp()  # can be useful for finding series identifiers, etc

eurostat <- TSconnect("sdmx", dbname="EUROSTAT")

# this worked in Dec 2014 but the series seems to have disappeared
# z <- TSget("ei_nama_q.Q.MIO-EUR.NSA.CLV2000.NA-B1G.IT", eurostat)

# Note change MIO-EUR to MIO_EUR everywhere, as of May 2017

#z <- TSget("ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT", eurostat)
# above not available in May 2017, replaced by next
#z <- TSget("ei_nama_q.Q.MIO_EUR.SCA.CP.NA-P71.IT", eurostat)
#  switched to this Oct 2018
z <- TSget("namq_10_gdp.Q.CP_MEUR.SCA.P71.IT", eurostat)

if (seriesNames(z) != "namq_10_gdp.Q.CP_MEUR.SCA.P71.IT")
    stop("seriesNames not set properly in eurostat test 1.")
    
TSmeta(z)

if (! all(c(1975, 1) == start(z))) stop("eurostat test 1 start date has changed.")

# Aug 2016 this started giving
#HTTP error code : 500, message: Internal Server Error
#SDMX meaning: Error on the provider side.
#z <- TSget("ei_nama_q.Q.MIO-EUR.SWDA.CP.NA-P72.IT",
#           start="1990-Q1", end="2012-Q2", eurostat)

# Aug 2016 this also gave
#  HTTP error code : 500, message: Internal Server Error
# for a couple of days but then worked a few days later.
#z <- TSget("ei_nama_q.Q.MIO-EUR.NSA.CP.NA-P72.IT",
#           start="1990-Q1", end="2012-Q2", eurostat)
# not available May 2017, replaced by next
# "ei_nama_q.Q.MIO_EUR.SCA.CP.NA-P71.IT" not available Oct 2018, replaced by
z <- TSget("namq_10_gdp.Q.CP_MEUR.SCA.P71.IT",
           start="1990-Q1", end="2012-Q2", eurostat)

if (! all(c(1990, 1) == start(z))) stop("eurostat test 2 start date failure.")
if (! all(c(2012, 2) ==   end(z))) stop("eurostat test 2  end  date failure.")


#z <- TSget('ei_nama_q.Q.MIO-EUR.NSA.CP.*.IT', eurostat) # all NaN

# at one time this had 28 series, 23 with data
#z <-  TSget("ei_nama_q.Q.MIO-EUR.NSA.CLV2000.*.IT", eurostat) 
#z <-  TSget("ei_nama_q.Q.MIO-EUR.NSA.CP.*.IT", eurostat) 
z <-  TSget("namq_10_gdp.Q.CP_MEUR.NSA.*.IT", eurostat) 

if (37 != sum(hasData(z, quiet=TRUE)))    stop("eurostat hasData test 1 changed.") # previously 23
if (39 != length(hasData(z, quiet=TRUE))) stop("eurostat hasData test 2 changed.")

hasDataCount(z)
hasDataNames(z)

hasDataDescriptions(z)

#  This is a useful check to know if a series has data
if (! ("namq_10_gdp.Q.CP_MEUR.NSA.P71.IT"
                 %in% hasDataNames(z))) stop("eurostat hasData test 3 changed.")

##  vector of serIDs

z <-  TSget(c("namq_10_gdp.Q.CP_MEUR.NSA.P7.IT",        
              "namq_10_gdp.Q.CP_MEUR.NSA.P71.IT",        
              "namq_10_gdp.Q.CP_MEUR.NSA.P72.IT"),
	    start="1990-Q1", end="2012-Q2",eurostat) 

if (! all(c(1990, 1) == start(z))) stop("eurostat vector test 1 start date failure.")
if (! all(c(2012, 2) ==   end(z))) stop("eurostat vector test 1  end  date failure.")
if ( 4 !=  frequency(z)) stop("eurostat vector test 1  frequency  date failure.")


z <-  TSget(c("namq_10_gdp.Q.CP_MEUR.NSA.P7.IT",        
              "namq_10_gdp.Q.CP_MEUR.NSA.P71.IT",        
              "namq_10_gdp.Q.CP_MEUR.NSA.P72.IT"),
	    start=c(1990,1), end=c(2012,2), eurostat) 

if (! all(c(1990, 1) == start(z))) stop("eurostat vector test 2 start date failure.")
if (! all(c(2012, 2) ==   end(z))) stop("eurostat vector test 2  end  date failure.")
if ( 4 !=  frequency(z)) stop("eurostat vector test 2  frequency  date failure.")
