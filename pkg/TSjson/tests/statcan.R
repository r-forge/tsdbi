require("TSjson")
require("tfplot")


require("findpython")
if(can_find_python_cmd(
         minimum_version="2.6",
         maximum_version="2.9",
         required_modules=c("sys", "re", "urllib2", "csv", "mechanize", "json"),
         silent=TRUE)){

     # user/passwd/host from file ~/.TSjson.cfg
     #con <- TSconnect("json", dbname="proxy-cansim")
     con <- TSconnect("json", dbname="cansim")

     # quarterly

     x <- TSget("v498086", con)
     tfplot(x)

     x <- TSget("v1593272", con)
     tfplot(x)

     x <- TSget("v498086", con, TSdescription=TRUE, TSdoc=TRUE, TSlabel=TRUE)
     TSdescription(x)
     TSdoc(x)
     TSlabel(x)
     TSsource(x)
     TSseriesIDs(x)

     TSdescription("v498086", con)
     TSdoc("v498086", con)
     TSlabel("v498086", con)
     TSsource("v498086", con)

     TSdates(c("v498086", "v498087"), con)
     TSdates(c("v498086", "vNoSeries"), con)

     tfplot(ytoypc(TSget(c("v498086", "v498087"), con)))


     # monthly

     TSdates(c("V122746", "V122747"), con)

     resMorg <- TSget("V122746", con,TSdescription=TRUE,TSdoc=TRUE,TSlabel=TRUE)
     TSdescription(resMorg)
     TSdoc(resMorg)
     TSlabel(resMorg)
     TSseriesIDs(resMorg)
     TSsource(resMorg)
     seriesNames(resMorg) <- "Residential Mortgage Credit (SA)"
     
     tfplot(ytoypc(resMorg), 
     	ylab="Year-to-Year Growth Rate",
     	Title=seriesNames(resMorg), 
     	source=paste("Bank of Canada, ", TSsource(x)),
     	lastObs=TRUE)
     
     tfplot(ytoypc(resMorg), annualizedGrowth(resMorg),
     	Title=seriesNames(resMorg), 
     	subtitle="year-to-year (black) and annualize monthly growth (red)",
     	ylab="Growth Rate",
     	source=paste("Bank of Canada, ", TSsource(x)),
     	lastObs=TRUE)
     
     # annual 
     
     x <- TSget("v687341", con)
     seriesNames(x) <- "Canadian GDP Growth"
     tfplot(ytoypc(x),
     	Title="Canadian GDP Growth", 
     	ylab="year-to-year growth",
     	source=TSsource(x),
     	lastObs=TRUE)

     
     TSdates(c("v687341", "v687342"), con)
     TSdescription(c("v687341", "v687342"), con)
     
     # semi- annual
     x <- TSget("v141", con)
     seriesNames(x) <- 
        "Footwear production - Canada; Work and utility-type boots and shoes"
     tfplot(x)
     
     TSdates("v141", con)
     
     # weekly 
     BoCbal <- TSget("V36610", con)
     seriesNames(BoCbal) <- "Bank of Canada - Assets and Liabilities"
     tfplot(BoCbal)
     tfplot(BoCbal, start="2007-1-1")

     # mixed
     TSdates(c("v498086","v498087","V122746","v687341","V36610","v141"), con)
     
     # daily 
     OverNightFin <-  TSget("v39050", con, TSdescription=TRUE, TSdoc=TRUE)
     TSdescription(OverNightFin)
     TSdoc(OverNightFin)
     
     tfplot(OverNightFin)
     tfplot(OverNightFin, Title=TSdescription(OverNightFin),
     	subtitle="(weekends and holidays zero filled)",
     	start="2012-1-1")
     tfplot(OverNightFin, Title=TSdescription(OverNightFin),
     	subtitle="(weekends and holidays zero filled)",
     	start="2012-9-15", end="2012-9-30")
     
     OverNightFin[OverNightFin == 0] <-  NA
     
     tfplot(OverNightFin)
     tfplot(OverNightFin, Title=TSdescription(OverNightFin),
       start="2012-1-1")
     tfplot(OverNightFin, Title=TSdescription(OverNightFin),
     	start="2012-9-15", end="2012-9-30")

     }     
