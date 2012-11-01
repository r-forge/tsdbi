
if(identical(as.logical(Sys.getenv("_R_CHECK_HAVE_RBBG_")), TRUE)) {

require("Rbbg") ## should not need this when Rbbg is in Depends
require("TSbbg")
require("tfplot")

cat("**************        connecting to Bloomberg\n")

con <- TSconnect("bbg") # need change in TSdbi

cat("*******  ticker example\n")

#trades.1 <- bar(conn, ticker, "TRADE", start.time, end.time, "1")
#trades.510 <- bar(conn, ticker, "TRADE", start.time, end.time, "510")
#sum(trades.1$numEvents) == sum(trades.510$numEvents) ## TRUE
#
#bids.1 <- bar(conn, ticker, "BID", start.time, end.time, "1")
#bids.510 <- bar(conn, ticker, "BID", start.time, end.time, "510")
#sum(bids.1$numEvents) == sum(bids.510$numEvents) ## TRUE
#
#asks.1 <- bar(conn, ticker, "ASK", start.time, end.time, "1")
#asks.510 <- bar(conn, ticker, "ASK", start.time, end.time, "510")
#sum(asks.1$numEvents) == sum(asks.510$numEvents) ## TRUE

 x <- TSget("AGS BB Equity", con, quote="TRADE", 
       start="2011-09-12 08:00:00.000", 
       end=as.POSIXct("2011-09-12 16:30:00.000"), interval="510")

 x <- TSget("AGS BB Equity", con, quote="BID",
       start=as.POSIXct("2011-09-12 08:00:00.000"), 
       end = as.POSIXct("2011-09-12 16:30:00.000"), interval="1")

 x <- TSget("AGS BB Equity", con, quote="ASK",
       start="2011-09-12 08:00:00.000", 
       end=  "2011-09-12 16:30:00.000", interval="1")

} else  cat("Rbbg not available. Skipping tests.")
