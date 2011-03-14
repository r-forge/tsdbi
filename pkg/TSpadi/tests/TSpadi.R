service <- Sys.getenv("_R_CHECK_HAVE_PADI_")

if(identical(as.logical(service), TRUE)) {

   require("TSpadi")
   
   m <- dbDriver("padi")
   dbname   <- Sys.getenv("PADI_DATABASE")
   if ("" == dbname)   dbname <- "ets"  
   user    <- Sys.getenv("PADI_USER")
    
    if ("" != user) conets <- 
         try(TSconnect(m, dbname=dbname, username=user, password=passwd, host=host)) 
    else  conets <-
         try(TSconnect(m, dbname=dbname)) # pass user/passwd/host in ~/.padi.cfg

   if (!inherits(conets, "try-error")) {
      cat("getpadi  test ets ... ")
      options(TSconnection=conets)
      print(TSmeta("M.SDR.CCUSMA02.ST"))
      
      z <- TSget("M.SDR.CCUSMA02.ST")

      EXCH.IDs <- t(matrix(c(
  	    "M.SDR.CCUSMA02.ST",     "SDR/USD exchange rate",
  	    "M.CAN.CCUSMA02.ST",     "CAN/USD exchange rate",
  	    "M.MEX.CCUSMA02.ST",     "MEX/USD exchange rate",
  	    "M.JPN.CCUSMA02.ST",     "JPN/USD exchange rate",
  	    "M.EMU.CCUSMA02.ST",     "Euro/USD exchange rate",
  	    "M.OTO.CCUSMA02.ST",     "OECD /USD exchange rate",
  	    "M.G7M.CCUSMA02.ST",     "G7   /USD exchange rate",
  	    "M.E15.CCUSMA02.ST",     "Euro 15. /USD exchange rate"
  	    ), 2, 8))

      print(TSdates(EXCH.IDs[,1]))
      z <- TSdates(EXCH.IDs[,1])
      print(start(z))
      print(end(z))
       
      tfplot(TSget(serIDs="V122646", conets))

      z <- TSget(serIDs="V122646", conets, TSrepresentation="timeSeries")
      if("timeSeries" != class(z)) stop("timeSeries class object not returned.")

    } else  {
      cat("ets not available\n")
   }

   
   cat("**************        disconnecting test\n")
   #dbDisconnect(con)
   #dbUnloadDriver(m)

} else  {
   cat("PADI not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_PADI_ setting ", service, "\n")
   }
