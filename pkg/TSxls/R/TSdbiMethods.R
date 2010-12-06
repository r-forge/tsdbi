
setClass("xlsDriver", representation("DBIDriver", Id = "character")) 

xls <- function() {
  drv <- "xls"
  attr(drv, "package") <- "TSxls"
  new("xlsDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSxlsConnection", contains=c("DBIConnection", "conType","TSdb"),
   representation(user="character", password="character", host="character") )

####### some kludges to make this look like DBI. ######
# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSxlsConnection"), 
     definition=function(conn,...) TRUE)
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="xlsDriver", dbname="character"),
  definition= function(drv, dbname, user="", password="", host="", ...){
   #  user / password / host  for future consideration
   if (is.null(dbname)) stop("dbname must be specified")

   # there could be a better connection test mechanism below
   if (dbname == "ECB" )      con <- try(TSgetECB('CPIAUCNS',...),  silent=TRUE)
   else if (dbname == "OECD") con <- try(TSgetOECD('CPIAUCNS',...), silent=TRUE)
   else stop(dbname, "not recognized. dbname should be one of 'ECB', 'OECD'.")

   if(inherits(con, "try-error")) 
         stop("Could not establish TSxlsConnection to ",  dbname)
   
   new("TSxlsConnection", drv="xls", dbname=dbname, 
        hasVintages=FALSE, hasPanels=FALSE, 
	user=user, password=password, host=host ) 
   } )


setMethod("TSdates",
  signature(serIDs="character", con="TSxlsConnection", vintage="ANY", panel="ANY"),
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

setMethod("TSget",     signature(serIDs="character", con="TSxlsConnection"),
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


#setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSxlsConnection"),
#   definition= function(x, serIDs=seriesNames(data), con, ...)   
#    "TSput for TSxls connection not supported." )

setMethod("TSdescription",   signature(x="character", con="TSxlsConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdescription for TSxls connection not supported." )


setMethod("TSdoc",   signature(x="character", con="TSxlsConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdoc for TSxls connection not supported." )

setMethod("TSlabel",   signature(x="character", con="TSxlsConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSlabel for TSxls connection not supported." )

