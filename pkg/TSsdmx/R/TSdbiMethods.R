
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

   # there could be a better connection test mechanism below
   if (dbname == "ECB" )      con <- try(TSgetECB('CPIAUCNS',...),  silent=TRUE)
   else if (dbname == "OECD") con <- try(TSgetOECD('CPIAUCNS',...), silent=TRUE)
   else stop(dbname, "not recognized. dbname should be one of 'ECB', 'OECD'.")

   if(inherits(con, "try-error")) 
         stop("Could not establish TSsdmxConnection to ",  dbname)
   
   new("TSsdmxConnection", drv="sdmx", dbname=dbname, 
        hasVintages=FALSE, hasPanels=FALSE, 
	user=user, password=password, host=host ) 
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
    desc <- NULL
    
    if(con@dbname == "OECD")     mat <- TSgetOECD(serIDs, names=names)
    else if(con@dbname == "ECB") mat <- TSgetOECD(serIDs, names=names)
    else stop("dbname not recognized.")

    if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 
    mat <- tfwindow(mat, tf=tf, start=start, end=end)
    #if (TSrepresentation  %in% c( "ts", "default")) {}
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

#######  database source specific methods (not exported)   ######
# It should be possible to a have a single SDMX parser deal with the
# result from the fetch, bu that is not (yet) done. The parsing is still
# specific to the format retrieved from each db.

TSgetBoC <- function(id, names=NULL){
   f <- gsub("[.]+[0-9,A-Z]*","",sub("[A-Z]*.","",sub("[0-9]*.","",id) ))
   fr <- f[1]
   if (!all(f==fr)) stop("series frequencies must all be the same.")
   
   uri <- paste( "http://sdw.ecb.europa.eu/export.do?",
   	    paste("SERIES_KEY=", id, "&", sep="", collapse=""),
   	    paste( "BS_ITEM=&sfl5=3&sfl4=4&sfl3=4&sfl1=3&DATASET=0&FREQ=",
     	    fr,"&node=2116082&exportType=sdmx", sep="", collapse=""), sep="")

   h <- basicTextGatherer()

   #h$reset()
   curlPerform(url=uri, writefunction = h$update, verbose = FALSE)
   nmsp <- c(ns="http://www.ecb.int/vocabulary/stats/bsi") 
   #nmsp <- c(ns="https://stats.ecb.europa.eu/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd")
   #See  getNodeSet examples
   z <- xmlTreeParse(h$value(),  useInternalNodes = TRUE)  #FALSE)

   # should try to check <faultstring> 

   r <- SDMXparse(z, nmsp, id, fr)
   if(!is.null(names)) seriesNames(r) <- names
   r
   }

TSgetECB <- function(id, names=NULL){
   f <- gsub("[.]+[0-9,A-Z]*","",sub("[A-Z]*.","",sub("[0-9]*.","",id) ))
   fr <- f[1]
   if (!all(f==fr)) stop("series frequencies must all be the same.")
   
#  different versions just for testing
# v1
   uri <- paste( "http://sdw.ecb.europa.eu/export.do?",
   	    paste("SERIES_KEY=", id, "&", sep="", collapse=""),
   	    paste( "BS_ITEM=&sfl5=3&sfl4=4&sfl3=4&sfl1=3&DATASET=0&FREQ=",
     	    fr,"&node=2116082&exportType=sdmx", sep="", collapse=""), sep="")
      
# v2
#   uri <- paste( "http://sdw.ecb.europa.eu/export.do?",
#   	    paste("SERIES_KEY=", id, "&", sep="", collapse=""),
#   	    paste( "sfl5=4&sfl4=4&sfl3=4&sfl2=4&sfl1=3&DATASET=0&FREQ=Q&node=2116082&exportType=sdmx",
#   	     sep="", collapse=""), sep="")
	    
# v3
#   uri <- paste( "http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&",
#   	    paste("SERIES_KEY=", id, "&", sep="", collapse=""),
#   	    paste( "type=sdmx", sep="", collapse=""), sep="")

# ns1
   nmsp <- c(ns="http://www.ecb.int/vocabulary/stats/bsi") 
# ns2
#   nmsp <- c(ns="https://stats.ecb.europa.eu/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd")
#  <dataset xmlns="http://www.ecb.int/vocabulary/stats/bsi" xsi:schemalocation="http://www.ecb.int/vocabulary/stats/bsi https://stats.ecb.int/stats/vocabulary/bsi/2005-07-01/sdmx-compact.xsd

   h <- basicTextGatherer()

   #h$reset()
   curlPerform(url=uri, writefunction = h$update, verbose = FALSE)
   #See  getNodeSet examples
   z <- xmlTreeParse(h$value(),  useInternalNodes = TRUE)  #FALSE)

   # should try to check <faultstring> 

   r <- SDMXparse(z, nmsp, id, fr)
   if(!is.null(names)) seriesNames(r) <- names
   r
   }

SDMXparse <- function(doc, namespace, id, fr){  
   # id is just for check of number of results
     # local function
     meta <- function(node){
      c(FREQ=		xmlGetAttr(node, "FREQ",	    namespace),
   	REF_AREA=	xmlGetAttr(node, "REF_AREA",	       namespace),
   	ADJUSTMENT=	xmlGetAttr(node, "ADJUSTMENT",      namespace),
   	BS_REP_SECTOR=  xmlGetAttr(node, "BS_REP_SECTOR",   namespace),
   	BS_ITEM=	xmlGetAttr(node, "BS_ITEM",	       namespace),
   	MATURITY_ORIG=  xmlGetAttr(node, "MATURITY_ORIG",   namespace),
   	DATA_TYPE=	xmlGetAttr(node, "DATA_TYPE",	       namespace),
   	COUNT_AREA=	xmlGetAttr(node, "COUNT_AREA",      namespace),
   	BS_COUNT_SECTOR=xmlGetAttr(node, "BS_COUNT_SECTOR", namespace),
   	CURRENCY_TRANS= xmlGetAttr(node, "CURRENCY_TRANS",  namespace),
   	BS_SUFFIX=	xmlGetAttr(node, "BS_SUFFIX", namespace),
   	TIME_FORMAT=	xmlGetAttr(node, "TIME_FORMAT", namespace),
   	COLLECTION=	xmlGetAttr(node, "COLLECTION", namespace))
       }

   # separate the series
   zs <-   getNodeSet(doc, "//ns:Series[@FREQ]", namespace )
   if(length(zs) != length(id)) stop("some series not retrieved.")
   m <- r <- NULL
   for (i in seq(length(zs))) { 
      m <- c(m, paste(meta(zs[[i]]), collapse="."))
      #cat(paste(meta(zs[[i]]), collapse="."),"\n")

      # getNodeSet(zs[[i]], "//ns:Obs[@TIME_PERIOD]",namespace )
      # gets Obs from all series. The XPath needs
      # to tell getNodeSet() to look from that node downwards, not
      # the original document. So you need a .//
      zz <-   getNodeSet(zs[[i]], ".//ns:Obs[@TIME_PERIOD]",namespace )  

      dt <- sapply(zz, xmlGetAttr, "TIME_PERIOD")
      # obs are usually in sequential order, but not certain, so
      ix <- order(dt)
      dt <- strptime(paste(dt[ix],"-01",sep=""), format="%Y-%m-%d")

      # Q dates are first month of Q?
      # cbind(1900+dt$year, 1+dt$mon/3) for all dates

      r1 <- as.numeric( sapply(zz, xmlGetAttr, "OBS_VALUE") )[ix]
      if (fr == "Q") 
        r2 <- ts(r1, start=cbind(1900+dt[1]$year, 1+dt$mon[1]/3), frequency=4) 
      else if (fr == "M") 
        r2 <- ts(r1, start=cbind(1900+dt[1]$year, dt$mon[1]), frequency=12) 
      else if (fr == "A") 
        r2 <- ts(r1, start=cbind(1900+dt[1]$year, 1), frequency=1) 
      else 
        r2 <- ts(r1, start=cbind(1900+dt[1]$year, 1), frequency=1) 
      r <- tbind(r, r2)
      }
   seriesNames(r) <- m
   r
   }

TSgetURI <- function(query,nmsp= c(ns="http://www.ecb.int/vocabulary/stats/bsi")){
   # function primarily for debugging queries
   # nmsp=c(ns="http://www.ecb.int/vocabulary/stats/bsi") 
   # nmsp=c(ns="https://stats.ecb.europa.eu/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd")

   fr <- 1 # skip trying to set fr properly (for debugging)

   h <- basicTextGatherer()

   h$reset()
   curlPerform(url=query, writefunction = h$update, verbose = FALSE)

   #See  getNodeSet examples
   z <- xmlTreeParse(h$value(),  useInternalNodes = TRUE)
   #z <- xmlTreeParse(h$value(),  useInternalNodes = FALSE)

   #htmlTreeParse(h$value()) # gives nicer printout

   # separate the series
   zs <-   getNodeSet(z, "//ns:Series[@FREQ]", nmsp )
   r <- NULL
   for (i in seq(length(zs))) { 
      # getNodeSet(zs[[i]], "//ns:Obs[@TIME_PERIOD]",nmsp )
      # gets Obs from all series. The XPath needs
      # to tell getNodeSet() to look from that node downwards, not
      # the original document. So you need a .//
      zz <-   getNodeSet(zs[[i]], ".//ns:Obs[@TIME_PERIOD]",nmsp )  

      dt <- sapply(zz, xmlGetAttr, "TIME_PERIOD")
      # obs are usually in sequential order, but not certain, so
      ix <- order(dt)
      dt <- strptime(paste(dt[ix],"-01",sep=""), format="%Y-%m-%d")

      # Q dates are first month of Q?
      # cbind(1900+dt$year, 1+dt$mon/3) for all dates

      r1 <- as.numeric( sapply(zz, xmlGetAttr, "OBS_VALUE") )[ix]
      # no attempt to deterrmine freq here
      r2 <- ts(r1, start=cbind(1900+dt[1]$year, 1), frequency=1) 
      r <- tbind(r, r2)
      }
   r
   }

# debug(TSgetURI)
