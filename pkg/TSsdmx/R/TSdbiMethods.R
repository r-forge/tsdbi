
setClass("sdmxDriver", representation("DBIDriver", Id = "character")) 

sdmx <- function() {
  drv <- "sdmx"
  attr(drv, "package") <- "TSsdmx"
  new("sdmxDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSsdmxConnection", contains=c("DBIConnection", "conType","TSdb"),
   representation(user="character", password="character", host="character") )

####### some kludges to make this look like DBI. ######
# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSsdmxConnection"), 
     definition=function(conn,...) TRUE)
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="sdmxDriver", dbname="character"),
  definition= function(drv, dbname, user="", password="", host="", ...){
   #  user / password / host  for future consideration
   if (is.null(dbname)) stop("dbname must be specified")
   if (dbname == "FRED") {
      #there could be a better test
      con <- try(quantmod:::sdmxCall('CPIAUCNS',src='FRED'), silent = TRUE)
      if(inherits(con, "try-error")) 
         stop("Could not establish TSsdmxConnection to ",  dbname)
      #close(con)
      }
   else if (dbname == "yahoo") {
      con <- try(quantmod:::sdmxCall('QQQQ',src='yahoo'), silent = TRUE)
      if(inherits(con, "try-error")) 
         stop("Could not establish TSsdmxConnection to ",  dbname)
      #close(con)
      }
   else 
      warning(dbname, "not recognized. Connection assumed working, but not tested.")
   
   new("TSsdmxConnection", drv="sdmx", dbname=dbname, hasVintages=FALSE, hasPanels=FALSE,
    	  user = user, password = password, host = host ) 
   } )


setMethod("TSdates",
  signature(serIDs="character", con="TSsdmxConnection", vintage="ANY", panel="ANY"),
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

setMethod("TSget",     signature(serIDs="character", con="TSsdmxConnection"),
   definition=function(serIDs, con, TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=serIDs, quiet=TRUE, repeat.try=3, ...){ 
    if (is.null(TSrepresentation)) TSrepresentation <- "ts"
    mat <- desc <- NULL
    # recycle serIDs and quote to matching lengths
    # argument 'quote' ignored for provider 'oanda'
    # if (con@dbname == "yahoo") {
       # if (length(quote) < length(serIDs))
       #     quote  <- rep(quote,  length.out=length(serIDs))
       # if (length(quote) > length(serIDs))
       #     serIDs <- rep(serIDs, length.out=length(quote))
       # }
    
    #sdmxCall BUG workaround. Set this as zoo otherwise periodicity is wrong
    #   (and frequency does not work either). Then convert below
    args <- list(src = con@dbname, return.class="zoo",
                 auto.assign=FALSE)
    
    #args <- if (is.null(start) & is.null(end)) append(args, list(...))
    #        else if (is.null(start)  ) append(args, list(end=end, ...))
    #        else if (is.null(end)  )   append(args, list(start=start, ...))
    #        else         append(args, list(start=start, end=end, ...) )
    for (i in seq(length(serIDs))) {
       argsi <- append(list(serIDs[i]),  args)
       for (rpt in seq(repeat.try)) {
           # quantmod:::sdmxCall
           r <- try(do.call("sdmxCall", argsi), silent=quiet)
	   if (!inherits(r , "try-error")) break
	   }
       if (inherits(r , "try-error")) stop("series not retrieved:", r)
       if (is.character(r)) stop("series not retrieved:", r)
       #TSrefperiod(r) <- quote[i]
       mat <- tbind(mat, r)
       desc <- c(desc, paste(serIDs[i], collapse=" "))
       }
    if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 
    # sdmxCall BUG workaround
    st <- start(mat) #POSIXlt as return for zoo
    if (TSrepresentation  %in% c( "ts", "default")) {
        if(periodicity(mat)$scale == "monthly")  mat <- as.ts(mat, frequency=12,start=c(1900+st$year, 1+st$mon))
        if(periodicity(mat)$scale == "quarterly")mat <- as.ts(mat, frequency=4, start=c(1900+st$year, 1+(st$mon-1)/3))
        if(periodicity(mat)$scale == "yearly")   mat <- as.ts(mat, frequency=1, start=c(1900+st$year, 1))
	}
    mat <- tfwindow(mat, tf=tf, start=start, end=end)
    #if (! TSrepresentation  %in% c( "zoo", "default"))
    #	 mat <- do.call(TSrepresentation, list(mat))   
    seriesNames(mat) <- names
    TSmeta(mat) <- new("TSmeta", serIDs=serIDs,  dbname=con@dbname, 
        hasVintages=con@hasVintages, hasPanels=con@hasPanels,
  	conType=class(con), DateStamp= Sys.time(), 
	TSdoc=paste(desc, " from ", con@dbname, "retrieved ", Sys.time()),
	TSdescription=paste(desc, " from ", con@dbname),
	TSlabel=desc) 
    mat
    } 
    )


#setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSsdmxConnection"),
#   definition= function(x, serIDs=seriesNames(data), con, ...)   
#    "TSput for TSsdmx connection not supported." )

setMethod("TSdescription",   signature(x="character", con="TSsdmxConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdescription for TSsdmx connection not supported." )


setMethod("TSdoc",   signature(x="character", con="TSsdmxConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdoc for TSsdmx connection not supported." )

setMethod("TSlabel",   signature(x="character", con="TSsdmxConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSlabel for TSsdmx connection not supported." )

