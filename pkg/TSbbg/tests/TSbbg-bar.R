
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

# ticker data at high frequency is not available historically.
# The retention period depends on interval.

 st <- as.POSIXlt(Sys.Date() - 2) # two days ago
 if(6 == st$wday )st <- as.POSIXlt(Sys.Date() - 3)# change Saturday to Friday
 if(7 == st$wday )st <- as.POSIXlt(Sys.Date() - 1) # change Sunday to Monday
  
 st <- st + 8*3600  # 8am
 
 x <- TSget("AGS BB Equity", con, quote="TRADE", 
       start=format.POSIXct(st,   "%Y-%m-%d %H:%M:%OS3"), 
       end=format.POSIXct(st + 8.5*3600,   "%Y-%m-%d %H:%M:%OS3"), #4:30pm 
       interval="510")

 x <- TSget("AGS BB Equity", con, quote="BID",
          start=st,  end = st + 3600, interval="1") # 8:00-9:00

 x <- TSget("AGS BB Equity", con, quote="ASK",
          start=st,  end= st + 3600 , interval="1") # 8:00-9:00

} else  cat("Rbbg not available. Skipping tests.")
