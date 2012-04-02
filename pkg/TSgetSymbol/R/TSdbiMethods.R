
setClass("getSymbolDriver", representation("DBIDriver", Id = "character")) 

getSymbol <- function() {
  drv <- "getSymbol"
  attr(drv, "package") <- "TSgetSymbol"
  new("getSymbolDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSgetSymbolConnection", contains=c("DBIConnection", "conType","TSdb"),
   representation(user="character", password="character", host="character") )

####### some kludges to make this look like DBI. ######
# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSgetSymbolConnection"), 
     definition=function(conn,...) TRUE)
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="getSymbolDriver", dbname="character"),
  definition= function(drv, dbname, user="", password="", host="", ...){
   #  user / password / host  for future consideration
   if (is.null(dbname)) stop("dbname must be specified")
   if (dbname == "FRED") {
      #there could be a better test
      con <- try(quantmod:::getSymbols('CPIAUCNS',src='FRED'), silent = TRUE)
      if(inherits(con, "try-error")) 
         stop("Could not establish TSgetSymbolConnection to ",  dbname)
      #close(con)
      }
   else if (dbname == "yahoo") {
      #this breaks if the symbol disappears, so it is more trouble than value
      # a better test would be good
      #con <- try(quantmod:::getSymbols('QQQQ',src='yahoo'), silent = TRUE)
      #if(inherits(con, "try-error")) 
      #   stop("Could not establish TSgetSymbolConnection to ",  dbname)
      ##close(con)
      }
   else 
      warning(dbname, "not recognized. Connection assumed working, but not tested.")
   
   new("TSgetSymbolConnection", drv="getSymbol", dbname=dbname, hasVintages=FALSE, hasPanels=FALSE,
    	  user = user, password = password, host = host ) 
   } )


setMethod("TSdates",
  signature(serIDs="character", con="TSgetSymbolConnection", vintage="ANY", panel="ANY"),
   definition= function(serIDs, con, vintage=NULL, panel=NULL, ... )  
{  # Indicate  dates for which data is available.
   # This requires retrieving series individually so they are not truncated.
   r <- av <- st <- en <- tb <- NULL
   for (i in 1:length(serIDs))
     {r <- try(TSget(serIDs[i], con), silent = TRUE)

      if(inherits(r, "try-error") ) {
        av <- c(av, FALSE)
	st <- append(st, list(NA))
	en <- append(en, list(NA))
	tb <- rbind(tb, NA)
	}
      else  {
        av <- c(av, TRUE)
        st <- append(st, list(tfstart(r)))
        en <- append(en, list(tfend(r)))
        tb <- rbind(tb,tffrequency(r))
        }
      }
  r <- serIDs
  attr(r, "TSdates") <- av
  attr(r, "start") <- st
  attr(r, "end")   <- en
  attr(r, "frequency")   <- tb
  class(r) <- "TSdates"
  r
} )

#trace("TSget", browser, exit=browser, signature = c(serIDs="character", #con="TSgetSymbolConnection"))

setMethod("TSget",     signature(serIDs="character", con="TSgetSymbolConnection"),
   definition=function(serIDs, con, TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=serIDs, quote = if (con@dbname == "yahoo") "Close" else NULL, 
       quiet=TRUE, repeat.try=3, ...){ 

    if (is.null(TSrepresentation)) {
       default <- TRUE
       TSrepresentation <- "zoo"
       }
    else default <- FALSE
    
    if (! TSrepresentation %in% c("ts", "its", "zoo", "xts", "timeSeries"))
       stop(TSrepresentation, " time series class not supported.")
    mat <- desc <- NULL
    # recycle serIDs and quote to matching lengths
    # argument 'quote' ignored for provider 'oanda'
    # if quote is null then HLOC will be retained
    if (con@dbname == "yahoo" && !is.null(quote)) {
        if (length(quote) < length(serIDs))
            quote  <- rep(quote,  length.out=length(serIDs))
        if (length(quote) > length(serIDs))
            serIDs <- rep(serIDs, length.out=length(quote))
        }
    
    #getSymbols BUG workaround. Set this as zoo otherwise periodicity is wrong
    #   (and frequency does not work either). Then convert below
    #args <- list(src = con@dbname, return.class="zoo",
    #             auto.assign=FALSE)
    args <- list(src = con@dbname, return.class=TSrepresentation,
                 auto.assign=FALSE)
    
    #args <- if (is.null(start) & is.null(end)) append(args, list(...))
    #        else if (is.null(start)  ) append(args, list(end=end, ...))
    #        else if (is.null(end)  )   append(args, list(start=start, ...))
    #        else         append(args, list(start=start, end=end, ...) )
    for (i in seq(length(serIDs))) {
       argsi <- append(list(serIDs[i]),  args)
       for (rpt in seq(repeat.try)) {
           # quantmod:::getSymbols
           r <- try(do.call("getSymbols", argsi), silent=quiet)
	   if (!inherits(r , "try-error")) break
	   }
       if (inherits(r , "try-error")) stop("series not retrieved:", r)
       if (is.character(r)) stop("series not retrieved:", r)
       #TSrefperiod(r) <- quote[i]
       if (!is.null(quote)) 
          r <- r[, paste(toupper(serIDs[i]),".", quote[i], sep="")]
       mat <- tbind(mat, r)
       desc <- c(desc, paste(serIDs[i], quote[i], collapse=" "))
       }
    #if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs)
    #  yahoo connections return high, low , ... 
    if (NCOL(mat) != length(serIDs)) names <- seriesNames(mat) 
    # getSymbols BUG workaround
    st <- as.POSIXlt(start(mat)) #POSIXlt as return for zoo
    if (default) {
        if(periodicity(mat)$scale == "monthly")
	   mat <- ts(mat, frequency=12,start=c(1900+st$year, 1+st$mon))
        else if(periodicity(mat)$scale == "quarterly")
	   mat <- ts(mat, frequency=4, start=c(1900+st$year, 1+(st$mon-1)/3))
        else if(periodicity(mat)$scale == "yearly")  
	   mat <- ts(mat, frequency=1, start=c(1900+st$year, 1))
	}

    # BUG in tfwindow when mat is zoo with POSIXct and start is eg"2011-01-03"
    #   next should work , but does not
    # mat <- tfwindow(mat, tf=tf, start=start, end=end)
    if (inherits(mat, "ts"))
       mat <- tfwindow(mat, tf=tf, start=start, end=end)
    else if (inherits(mat, "zoo")) {
       if(!is.null(start)) mat <- window(mat, start=as.POSIXct(start))
       if(!is.null(end))   mat <- window(mat, end=as.POSIXct(end))
       }

    seriesNames(mat) <- names
    TSmeta(mat) <- new("TSmeta", serIDs=serIDs,  dbname=con@dbname, 
        hasVintages=con@hasVintages, hasPanels=con@hasPanels,
  	conType=class(con), DateStamp= Sys.time(), 
	TSdoc=paste(desc, " from ", con@dbname, "retrieved ", Sys.time()),
	TSdescription=paste(desc, " from ", con@dbname),
	TSlabel=desc, 
	TSsource= (if("yahoo" == con@dbname) "yahoo" 
	      else if("FRED" == con@dbname) "Federal Reserve Bank of St. Louis"
	      else con@dbname )
	) 
    mat
    } 
    )


#setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSgetSymbolConnection"),
#   definition= function(x, serIDs=seriesNames(data), con, ...)   
#    "TSput for TSgetSymbol connection not supported." )

setMethod("TSdescription",   signature(x="character", con="TSgetSymbolConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdescription for TSgetSymbol connection not supported." )


setMethod("TSdoc",   signature(x="character", con="TSgetSymbolConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdoc for TSgetSymbol connection not supported." )

setMethod("TSlabel",   signature(x="character", con="TSgetSymbolConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSlabel for TSgetSymbol connection not supported." )

setMethod("TSsource",   signature(x="character", con="TSgetSymbolConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        if("yahoo" == con@dbname) "yahoo" 
	      else if("FRED" == con@dbname) "Federal Reserve Bank of St. Louis"
	      else "unspecified"  )
