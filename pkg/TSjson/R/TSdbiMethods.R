
setClass("jsonDriver", representation("DBIDriver", Id = "character")) 

json <- function() {
  drv <- "json"
  attr(drv, "package") <- "TSjson"
  new("jsonDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSjsonConnection", contains=c("DBIConnection", "conType","TSdb"),
   representation(user="character", password="character", host="character",
                  url="character") )

####### some kludges to make this look like DBI. ######
# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSjsonConnection"), 
     definition=function(conn,...) TRUE)
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="jsonDriver", dbname="ANY"),
  definition= function(drv, dbname, user=NULL, password=NULL, host=NULL, ...){
   if (is.null(dbname)) stop("dbname must be specified")
   # if other values are not specified get defaults from file or system variables
   f <- paste(Sys.getenv("HOME"),"/.TSjson.cfg", sep="")
   if (file.exists(f)) {
       f <- scan(f, what="") # parse a file for user password host
       r <- list(user=f[1],        # f[2+seq(length(f))[f=="user"]],
                 password = f[2] , # f[2+seq(length(f))[f=="password"]],
                 host     = f[3]   #f[2+seq(length(f))[f=="host"]]
		 )
      }
   else {
       r <- list(user=      Sys.getenv()["TSJSONUSER"],
                 password = Sys.getenv()["TSJSONPASSWORD"],
                 host     = Sys.getenv()["TSJSONHOST"])
      }
   if (is.null(user)) user <- r$user
   if (is.null(password)) password <-r$password
   if (is.null(host)) host <- r$host
   
   url <- paste("http://", user, ":", password, "@", host, "/", sep="")
   #dbname,
  
   # there could be a better connection test mechanism 
   #if(inherits(con, "try-error")) 
   #      stop("Could not establish TSjsonConnection to ",  dbname)
   
   new("TSjsonConnection", drv="json", dbname=dbname,
        hasVintages=FALSE, hasPanels=FALSE, 
	user=user, password=password, host=host, url=url ) 
   } )


setMethod("TSdates",
  signature(serIDs="character", con="TSjsonConnection", vintage="ANY", panel="ANY"),
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


setMethod("TSget",     signature(serIDs="character", con="TSjsonConnection"),
   definition= function(serIDs, con=getOption("TSconnection"), 
       TSrepresentation=getOption("TSrepresentation"),
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=serIDs, 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE, ...){ 
       
  if(is.null(TSrepresentation)) TSrepresentation <- "default"

  url <- con@url
  
  mat <- desc <- doc <- label <- source <-  rp <- NULL

  for (i in seq(length(serIDs))) {
    rr <- fromJSON(getURL(paste(url, serIDs[i], sep="")))

    if(0==length(rr))
       stop("Series retrieval failed. Series ",i," may not exist at ", con@host)

    fr <- rr$freq
    st <- rr$start
    r <-  if((TSrepresentation=="default" | TSrepresentation=="ts")
             && fr %in% c(1,4,12,2)) ts(rr$x, start=st, frequency=fr) 
	     else zoo(rr$x, start=st, frequency=fr)
       #r <- zoo(c(r[[1]]), order.by=as.Date(ti(r[[1]])), frequency=frequency(r[[1]]))

    mat <- tbind(mat, r)
    if(TSdescription) desc <- c(desc,   rr$shortdesc ) 
    if(TSdoc)     doc      <- c(doc,    rr$desc ) 
    if(TSlabel)   label    <- c(label,  rr$mnem )
    if(TSsource)  source   <- c(source, rr$source )
    }

  if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 

  mat <- tfwindow(mat, tf=tf, start=start, end=end)

  if( (!is.null(rp)) && !all(is.na(rp)) ) TSrefperiod(mat) <- rp      

  if (! TSrepresentation  %in% c( "zoo", "default", "tis")){
      require("tframePlus")
      mat <- changeTSrepresentation(mat, TSrepresentation)
      }

  seriesNames(mat) <- names 

  TSmeta(mat) <- new("TSmeta", serIDs=serIDs,  
      hasVintages=con@hasVintages, hasPanels=con@hasPanels,
      conType=class(con), 
      DateStamp=Sys.time(), 
      TSdescription = if(TSdescription) desc   else NA, 
      TSdoc         = if(TSdoc)         doc    else NA,
      TSlabel       = if(TSlabel)       label  else NA,
      TSsource      = if(TSsource)      source else NA )
  mat
} )



#setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSjsonConnection"),
#   definition= function(x, serIDs=seriesNames(data), con, ...)   
#    "TSput for TSjson connection not supported." )

setMethod("TSdescription",   signature(x="character", con="TSjsonConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdescription for TSjson connection not supported." )


setMethod("TSdoc",   signature(x="character", con="TSjsonConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdoc for TSjson connection not supported." )

setMethod("TSlabel",   signature(x="character", con="TSjsonConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSlabel for TSjson connection not supported." )

setMethod("TSsource",   signature(x="character", con="TSjsonConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSsource for TSjson connection not supported." )

