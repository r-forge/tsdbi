
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
    

#TSgetURI(query="http://credit.bank-banque-canada.ca/webservices?service=getSeriesSDMX&args=CDOR_-_-_FIRST_-_-_Last")
#TSgetURI(query="http://credit.bank-banque-canada.ca/webservices?service=getSeriesSDMX&args=CDOR_-_-_OIS_-_-_SWAPPEDTOFLOAT_-_-_FIRST_-_-_Last")

   uri <- paste( "http://credit.bank-banque-canada.ca/webservices?service=getSeriesSDMX&args=",
   	    paste("SERIES_KEY=", id, "_-_-_", sep="", collapse=""),
   	    paste( "FIRST_-_-_Last",sep="", collapse=""), sep="")

   h <- basicTextGatherer()

   #h$reset()
   curlPerform(url=uri, writefunction = h$update, verbose = FALSE)
   z <- xmlTreeParse(h$value(),  useInternalNodes = TRUE)  #FALSE)

   # should try to check <faultstring> 

  f <- gsub("[.]+[0-9,A-Z]*","",sub("[A-Z]*.","",sub("[0-9]*.","",id) ))
   fr <- f[1]
   if (!all(f==fr)) stop("series frequencies must all be the same.")

   r <- SDMXparse(z, id, fr)
   if(!is.null(names)) seriesNames(r) <- names
   r
   }

TSgetECB <- function(id, names=NULL){
   f <- gsub("[.]+[0-9,A-Z]*","",sub("[A-Z]*.","",sub("[0-9]*.","",id) ))
   fr <- f[1]
   if (!all(f==fr)) stop("series frequencies must all be the same.")
   
#  different versions just for testing
# v1
#   uri <- paste( "http://sdw.ecb.europa.eu/export.do?",
#   	    paste("SERIES_KEY=", id, "&", sep="", collapse=""),
#   	    paste( "BS_ITEM=&sfl5=3&sfl4=4&sfl3=4&sfl1=3&DATASET=0&FREQ=",
#     	    fr,"&node=2116082&exportType=sdmx", sep="", collapse=""), sep="")
#      
# v2
#   uri <- paste( "http://sdw.ecb.europa.eu/export.do?",
#   	    paste("SERIES_KEY=", id, "&", sep="", collapse=""),
#   	    paste( "sfl5=4&sfl4=4&sfl3=4&sfl2=4&sfl1=3&DATASET=0&FREQ=Q&node=2116082&exportType=sdmx",
#   	     sep="", collapse=""), sep="")
	    
# v3
   uri <- paste( "http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&",
	   paste("SERIES_KEY=", id, "&", sep="", collapse=""),
	   paste( "type=sdmx", sep="", collapse=""), sep="")

   h <- basicTextGatherer()

   #h$reset()
   curlPerform(url=uri, writefunction = h$update, verbose = FALSE)
   #See  getNodeSet examples
   z <- xmlTreeParse(h$value(),  useInternalNodes = TRUE)  #FALSE)

   # should try to check <faultstring> 

   r <- SDMXparse(z, id, fr)
   if(!is.null(names)) seriesNames(r) <- names
   r
   }

SDMXparse <- function(doc, id, fr){  
   # id is just for check of number of results

   #eg. nmsp <- c(ns="http://www.ecb.int/vocabulary/stats/bsi") 
   nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["DataSet"]][[2]]))

   # local function
   meta <- function(node){
      c(FREQ=		xmlGetAttr(node, "FREQ",	    nmsp),
   	REF_AREA=	xmlGetAttr(node, "REF_AREA",	    nmsp),
   	ADJUSTMENT=	xmlGetAttr(node, "ADJUSTMENT",      nmsp),
   	BS_REP_SECTOR=  xmlGetAttr(node, "BS_REP_SECTOR",   nmsp),
   	BS_ITEM=	xmlGetAttr(node, "BS_ITEM",	    nmsp),
   	MATURITY_ORIG=  xmlGetAttr(node, "MATURITY_ORIG",   nmsp),
   	DATA_TYPE=	xmlGetAttr(node, "DATA_TYPE",	    nmsp),
   	COUNT_AREA=	xmlGetAttr(node, "COUNT_AREA",      nmsp),
   	BS_COUNT_SECTOR=xmlGetAttr(node, "BS_COUNT_SECTOR", nmsp),
   	CURRENCY_TRANS= xmlGetAttr(node, "CURRENCY_TRANS",  nmsp),
   	BS_SUFFIX=	xmlGetAttr(node, "BS_SUFFIX",       nmsp),
   	TIME_FORMAT=	xmlGetAttr(node, "TIME_FORMAT",     nmsp),
   	COLLECTION=	xmlGetAttr(node, "COLLECTION",      nmsp))
       }

   # separate the series
   zs <-   getNodeSet(doc, "//ns:Series[@FREQ]", nmsp )
   if(length(zs) != length(id)) stop("some series not retrieved.")
   m <- r <- NULL
   for (i in seq(length(zs))) { 
      m <- c(m, paste(meta(zs[[i]]), collapse="."))
      #cat(paste(meta(zs[[i]]), collapse="."),"\n")

      # getNodeSet(zs[[i]], "//ns:Obs[@TIME_PERIOD]",nmsp )
      # gets Obs from all series. The XPath needs
      # to tell getNodeSet() to look from that node downwards, not
      # the original document. So you need a .//
      zz <-   getNodeSet(zs[[i]], ".//ns:Obs[@TIME_PERIOD]",nmsp )  

      dt <- sapply(zz, xmlGetAttr, "TIME_PERIOD")
      # obs are usually in sequential order, but not certain, so
      ix <- order(dt)
      dt <- dt[ix]

      # In some formats Q dates are first month of Q, eg Q4 is 2010-10
      # but usually? 2010-Q4

      r1 <- as.numeric( sapply(zz, xmlGetAttr, "OBS_VALUE") )[ix]
      if (fr == "Q"){ 
        y <- as.numeric(sub("-Q[0-9]","",dt[1]))
	q <- as.numeric(sub("[0-9]*-Q","",dt[1]))
        r2 <- ts(r1, start=c(y,q), frequency=4)
	} 
      else if (fr == "M"){ 
        dt <- strptime(paste(dt,"-01",sep=""), format="%Y-%m-%d")
        r2 <- ts(r1, start=cbind(1900+dt[1]$year, dt$mon[1]), frequency=12) 
	} 
      else if (fr == "A"){ 
        y <- as.numeric(dt[1])
        r2 <- ts(r1, start=cbind(y, 1), frequency=1) 
	} 
      else{ 
        require("zoo")
	r2 <- zoo(r1, order.by=as.Date(dt)) 
	} 
      r <- tbind(r, r2)
      }
   seriesNames(r) <- m
   r
   }

TSgetURI <- function(query){
   # function primarily for debugging queries

   fr <- 1 # skip trying to set fr properly (for debugging)

   h <- basicTextGatherer()
   h$reset()
   curlPerform(url=query, writefunction = h$update, verbose = FALSE)

   #See  getNodeSet examples
   z <- xmlTreeParse(h$value(),  useInternalNodes = TRUE)

   #htmlTreeParse(h$value()) # gives nicer printout

   # separate the series
   nmsp <- c(ns=xmlNamespace(xmlRoot(z)[["DataSet"]][[2]]))
   zs <-   getNodeSet(z, "//ns:Series[@FREQ]", nmsp )
   r <- dt <- NULL
   for (i in seq(length(zs))) { 
      # getNodeSet(zs[[i]], "//ns:Obs[@TIME_PERIOD]",nmsp )
      # gets Obs from all series. The XPath needs
      # to tell getNodeSet() to look from that node downwards, not
      # the original document. So you need a .//
      zz <-   getNodeSet(zs[[i]], ".//ns:Obs[@TIME_PERIOD]",nmsp )  

      # no attempt at time series
      dt <- cbind(dt, sapply(zz, xmlGetAttr, "TIME_PERIOD"))
      r  <- cbind(r,  as.numeric( sapply(zz, xmlGetAttr, "OBS_VALUE") ))
      }
   r
   }

# debug(TSgetURI)
