# test that the Quandl package is working

cat("**************        connecting Quandl\n")

  require("Quandl")

cat("**************        extracting from Quandl, type zoo\n")

  x  <- Quandl("NSE/OIL", type="zoo")

  if (7 != dim(x)[2])   stop("NSE/OIL number of series have changed (zoo).")

  # assuming series will never get shorter
  if (1094 > dim(x)[1]) stop("NSE/OIL number of time points is shorter(zoo).")

  if ( !all(names(x) == c("Open","High" ,"Low" , "Last", "Close", 
     "Total Trade Quantity", "Turnover (Lacs)")))
     stop("NSE/OIL series names have changed (zoo).")

  # assuming historic start date never changes
  if (as.Date("2009-09-30") != start(x))  
     stop("NSE/OIL start date thas changed (zoo).")


cat("**************        extracting from Quandl, type xts\n")

  x  <- Quandl("NSE/OIL", type = "xts")

  if (7 != dim(x)[2])   stop("NSE/OIL number of series have changed (xts).")

  # assuming series will never get shorter
  if (1094 > dim(x)[1]) stop("NSE/OIL number of time points is shorter (xts).")

  if ( !all(names(x) == c("Open","High" ,"Low" , "Last", "Close", 
     "Total Trade Quantity", "Turnover (Lacs)")))
     stop("NSE/OIL series names have changed (xts).")

  # assuming historic start date never changes
  if (as.Date("2009-09-30") != start(x))  
     stop("NSE/OIL start date thas changed (xts).")


cat("**************    test start date trimming\n")
 
  #x  <- Quandl("NSE/OIL", sort = "asc", start_date = as.Date("2011-01-01"))
  # should not neeed sort = "asc" anymore

  x  <- Quandl("NSE/OIL", start_date = as.Date("2011-01-03"), type="zoo")

  if (as.Date("2011-01-03") != start(x))  
     stop("NSE/OIL start date trimming is not working with type zoo.")

  x  <- Quandl("NSE/OIL", start_date = as.Date("2011-01-03"), type = "xts")

  if (as.Date("2011-01-03") != start(x))  
     stop("NSE/OIL start date trimming is not working with type xts.")


cat("**************    test end date trimming\n")
  
  x  <- Quandl("NSE/OIL", start_date = as.Date("2013-12-16"),
                            end_date = as.Date("2014-04-01"), type="zoo")

  if (as.Date("2014-04-01") != end(x))  
     stop("NSE/OIL end date trimming is not working with type zoo.")

  if (as.Date("2013-12-16") != start(x))  
     stop("NSE/OIL start date trimming in combination with end trimming is not working with type zoo.")


  x  <- Quandl("NSE/OIL", start_date = as.Date("2014-02-17"),
                            end_date = as.Date("2014-04-01"), type = "xts")

  if (as.Date("2014-04-01") != end(x))  
     stop("NSE/OIL end date trimming is not working with type xts.")

  if (as.Date("2014-02-17") != start(x))  
     stop("NSE/OIL start date trimming in combination with end trimming is not working with type zoo.")


cat("**************    test meta data\n")

#  temporarily disable, needs as.yearmon or newer Quandl
if (FALSE) {
  x  <- Quandl("BOC/CDA_CPI", type = "zoo", meta = TRUE)
  
  if (is.null(attr(x,"meta"))) 
     stop("meta data not retrieved (zoo).")
   
  if ("Canada CPI" != attr(x,"meta")$name )  
     stop("meta data $name is changed (zoo).")
   
  if ("Bank of Canada" != attr(x,"meta")$source_name )  
     stop("meta data $source_name is changed (zoo).")


  x  <- Quandl("BOC/CDA_CPI", type = "xts", meta = TRUE)
  
  if (is.null(attr(x,"meta"))) 
     stop("meta data not retrieved (xts).")
   
  if ("Canada CPI" != attr(x,"meta")$name )  
     stop("meta data $name is changed (xts).")
   
  if ("Bank of Canada" != attr(x,"meta")$source_name )  
     stop("meta data $source_name is changed (xts).")
}
