dbBackEnd <- function(...) {
  drv <- "sdmx"
  attr(drv, "package") <- "TSsdmx"
  new("sdmxDriver")
  }

# there is an SDMX primer at
# http://www.ecb.int/stats/services/sdmx/html/index.en.html

# NB firebug shows browser requests to server, so is useful for seeing what is
#  sent to the server

####### some kludges to make this look like DBI. ######
#for this require("DBI") ; require("RJSDMX")

setClass("sdmxDriver", contains=c("DBIDriver")) 

setClass("sdmxConnection", contains=c("DBIConnection", "sdmxDriver"),
   slots=c(dbname="character") )

# slot getTimeSeries="function" could be here but J() function 
#     value may not persist in method across sessions??
setMethod("dbConnect", signature(drv="sdmxDriver"), 
     definition=function(drv, dbname, ...) 
         new("sdmxConnection", dbname=dbname))

# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSsdmxConnection"), 
     definition=function(conn,...) TRUE)

#######     end kludges   ######
# require(TSdbi)

setClass("TSsdmxConnection", contains=c("DBIConnection", "conType","TSdb"),
   slots=c( getTimeSeries="function",
      user="character", password="character", host="character") )

setMethod("TSconnect",   signature(q="sdmxConnection", dbname="missing"),
  definition= function(q, dbname, user="", password="", host="", ...){
   #  user / password / host  for future consideration
   # getProviders()
   # "BIS"      "ILO"      "ECB"      "OECD"     "EUROSTAT"
   dbname <- q@dbname #  dbname <- "ECB" 
   
   get <- try(
     J("it.bankitalia.reri.sia.sdmx.client.SdmxClientHandler")$getTimeSeries)

   # there should be something that could be checked. This is not really
   #  contacting the server yet
   if(inherits(get, "try-error")) 
         stop("Could not establish TSsdmxConnection to ",  dbname)
   
   new("TSsdmxConnection", dbname=dbname, getTimeSeries=get,
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
   definition= function(serIDs, con, TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=serIDs, quiet=TRUE, ...){ 
    if (is.null(TSrepresentation)) TSrepresentation <- "ts"
    dbname <- con@dbname
    
    if( ! (dbname %in% getProviders()))
          stop("dbname", dbname, "not a recognized SDMX provider.")

    st <- if(is.null(start)) "" else as.character(start)
    en <- if(is.null(end))   "" else as.character(end)
    ser <- try(getSDMX(dbname, serIDs, start=st, end=en))
    
    if(inherits(ser, "try-error")){
       if(grepl("does not exist in provider", attr(ser,"condition")$message))
         stop(serIDs, " does not exist on ", dbname)
       else
         stop(serIDs, " error: ", attr(ser,"condition")$message)
       }

    if (0 == length(ser)) stop("unknown error getting ", serIDs, " from ", dbname,
            " try getSDMX('",dbname, "', '", serIDs, "')" )

    mat <- ser[[1]]
    desc <- names(ser)
    doc <- attr(ser[[1]], "TITLE_COMPL")
    #sdmxMeta <- list(attributes(ser[[1]]))
 
    if (1 < length(ser)) for (i in 2:length(ser)) {
       mat <- tbind(mat, ser[[i]])
       if (! is.null(doc)) doc <- c(doc, attr(ser[[i]], "TITLE_COMPL"))
       #sdmxMeta <- append(sdmxMeta, list(attributes(ser[[i]])))
      }

    #mat <- tfwindow(mat, tf=tf, start=start, end=end)

    if (all(is.nan(mat))) warning("Data is all NaN.")
   
    if (! TSrepresentation  %in% c( "ts", "default")){
      require("tframePlus")
      mat <- changeTSrepresentation(mat, TSrepresentation)
      }

    if(any(grepl('*',serIDs)))
       if(length(names) != length(ser)) names <- names(ser)
    
    
    seriesNames(mat) <- names

    TSmeta(mat) <- new("TSmeta", serIDs=serIDs,  dbname=con@dbname, 
        hasVintages=con@hasVintages, hasPanels=con@hasPanels,
  	conType=class(con), DateStamp= Sys.time(), 
	#TSdoc=paste(desc, " from ", con@dbname, "retrieved ", Sys.time()),
	TSdoc=if (is.null(doc)) "" else doc , #sdmxMeta,
	TSdescription=paste(desc, " from ", dbname),
	TSlabel=desc, 
	TSsource=con@dbname # could be better
	) 
    mat
    } 
    )


# setMethod("TSput",  signature(x="ANY", serIDs="character", con="TSsdmxConnection"),
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

setMethod("TSsource",   signature(x="character", con="TSsdmxConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSsource for TSsdmx connection not supported." )
