setClass("padiDriver", representation("DBIDriver", Id = "character")) 

padi <- function() {
  drv <- "padi"
  attr(drv, "package") <- "TSpadi"
  new("padiDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSpadiConnection", contains=c("DBIConnection", "conType", "TSdb"),
  representation(
   user = "character",
   password = "character",
   host = "character",
   start.server = "logical",
   server.process = "character",
   cleanup.script = "character",
   stop.on.error = "logical",
   use.tframe = "logical",
   warn = "logical",
   timeout = "numeric")
   )

setMethod("TSconnect",   signature(drv="padiDriver", dbname="character"),
  definition= function(drv, dbname, user=NULL, password = NULL, host=NULL,
        timeout=60, ...)  {
   if (is.null(dbname)) stop("dbname must be specified")
   # if other values are not specified get defaults from file or system variables
   f <- paste(Sys.getenv("HOME"),"/.padi.cfg", sep="")
   if (file.exists(f)) {
       f <- scan(f, what="") # parse a file for user password host
       r <- list(user=f[1],        # f[2+seq(length(f))[f=="user"]],
                 password = f[2] , # f[2+seq(length(f))[f=="password"]],
                 host     = f[3]   #f[2+seq(length(f))[f=="host"]]
		 )
      }
   else {
       r <- list(user=Sys.getenv()["USER"],
                 password =  "",
                 host     = Sys.info()["nodename"])
      }
   if (is.null(user)) user <- r$user
   if (is.null(password)) password <-r$password
   if (is.null(host)) host <- r$host
   if(checkPADIserver(server=host, user=user, timeout=timeout) )   
     new("TSpadiConnection", drv="padi", dbname=dbname,
             hasVintages=FALSE, hasPanels=FALSE,
    	  user = user,
    	  password = password,
    	  host = host,
    	  start.server=   FALSE,
    	  server.process= PADIserverProcess(),
    	  cleanup.script= PADIcleanupScript(),
    	  stop.on.error = TRUE,
    	  use.tframe = FALSE, # so uses ts()
    	  warn = TRUE,
    	  timeout = timeout ) 
     else 
       stop("Could not establish TSpadiConnection to ", dbname, " on ", host,
             ". See the help for padi (?padi) for hints.")
   } )


setMethod("TSdates",  
   signature(serIDs="character", con="TSpadiConnection", vintage="ANY", panel="ANY"),
   definition= function(serIDs, con, vintage=NULL, panel=NULL, ... )  
{  # Indicate  dates for which data is available.
   # This requires retrieving series individually so they are not truncated.

   # next 3 lines are to look after older style name forms at the BOC
#   ets <- "ets" == substring(obj["db",],1,3)
#   obj["server", ets] <- "ets"
#   obj["db",     ets] <- ""

   r <- av <- st <- en <- tb <- NULL
   for (i in 1:length(serIDs))
     {r <- try(getpadi( serIDs[i], server=con@host, dbname=con@dbname, 
        start.server   = con@start.server, 
        server.process = con@server.process,
        cleanup.script = con@cleanup.script,
        #starty=if(any(is.na(tfstart(obj)))) 0 else tfstart(obj)[1],
        #startm=if(any(is.na(tfstart(obj)))) 0 else tfstart(obj)[2],
        #endy=if(any(is.na(tfend(obj))))  0 else tfend(obj)[1],
        #endm=if(any(is.na(tfend(obj))))  0 else tfend(obj)[2],
        #transformations = attr(serIDs, "transforms"),
        #pad  = (attr(obj,"pad.start") | attr(obj,"pad.end")) ,
        user = con@user,
        passwd=con@password,
        stop.on.error = con@stop.on.error,
        #use.tframe=attr(obj,"use.tframe"), 
        warn=FALSE, timeout=con@timeout), silent = TRUE)

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


setMethod("TSget",     signature(serIDs="character", con="TSpadiConnection"),
   definition= function(serIDs, con,
       TSrepresentation=getOption("TSrepresentation"), names=serIDs, ...)
{ # ... arguments unused
  # This function retreives data from a PADI server using getpadi
  # A server specified as NULL or as "" is expanded to the localhost.

   # next 3 lines are to look after older style name forms at the BOC
#   ets <- "ets" == substring(serIDs["db",],1,3)
#   serIDs["server", ets] <- "ets"
#   serIDs["db",     ets] <- ""

#   serIDs["server", serIDs["server",] ==""] <- PADIserver() 

   # missing attr is NULL but should be translated to getpadi defaults:
   IfNull <- function(a,b) {c(a,b)[1]}

   r  <- getpadi( serIDs, server=con@host, dbname=con@dbname,
     start.server=   con@start.server,
     server.process= con@server.process,
     cleanup.script= con@scleanup.script,
     #starty= if(any(is.na(tfstart(serIDs)))) 0 else tfstart(serIDs)[1],
     #startm= if(any(is.na(tfstart(serIDs)))) 0 else tfstart(serIDs)[2],
     #endy=   if(any(is.na(tfend(serIDs))))   0 else tfend(serIDs)[1],
     #endm=   if(any(is.na(tfend(serIDs))))   0 else tfend(serIDs)[2],
     starty= 0,
     startm= 0,
     endy=   0,
     endm=   0,
     transformations = attr(serIDs, "transforms"),
     pad  = TRUE,
     user =          con@user,
     passwd=         con@password,
     stop.on.error = con@stop.on.error,
     use.tframe=     con@use.tframe, 
     warn=           con@warn,
     timeout= con@timeout, 
     names=names)

 if (is.character(r)) stop(r)
 if (dim(r)[2] != length(serIDs)) stop("Error retrieving series", serIDs) 
 
 if (!is.null(attr(serIDs,"pad.start")) && !attr(serIDs,"pad.start"))
     r <- trimNA(r, startNAs=TRUE,  endNAs=FALSE)
 if (!is.null(attr(serIDs,"pad.end")) && !attr(serIDs,"pad.end"))
     r <- trimNA(r, startNAs=FALSE, endNAs=TRUE)

# if ( !is.na(tffrequency(serIDs)) && (tffrequency(serIDs)) != tffrequency(r))
#       warning("returned serIDs frequency differs from request.")
 
 if (is.null(TSrepresentation)) TSrepresentation <- "ts"
 
 if (! TSrepresentation  %in% c( "ts", "default")){
      require("tframePlus")
      r <- changeTSrepresentation(r, TSrepresentation)
      }

 TSmeta(r) <- new("TSmeta", serIDs=serIDs,  dbname=con@dbname, 
      hasVintages=con@hasVintages, hasPanels=con@hasPanels,
      conType=class(con), 
      DateStamp= Sys.time(), 
      TSdescription=NA, 
      TSdoc    = NA,
      TSlabel  = NA,
      TSsource = NA) 
 r
} )


setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSpadiConnection"),
   definition= function(x, serIDs=seriesNames(data), con, ...)   
  {# This should return an object suitable for retrieving the data.

   ok <- putpadi(x, server=con@host, dbname=con@dbname, series=serIDs,
         start.server = con@start.server, server.process=con@server.process, 
         cleanup.script=con@cleanup.script,
         user=con$user, passwd=con@password,
         stop.on.error=con@stop.on.error, warn=con@warn, timeout=con@timeout ) 

   if (!all(ok)) warning("error putting data on database.")
  
   new("logicalId", all(ok), 
        TSid=new("TSid", serIDs=serIDs, dbname=con@dbname, 
                 hasVintages=con@hasVintages, hasPanels=con@hasPanels,
 	         conType=class(con), DateStamp=NA))
  } )


setMethod("TSdescription",   signature(x="character", con="TSpadiConnection"),
   definition= function(x, con=getOption("TSconnection"), ...) NA )

setMethod("TSdoc",   signature(x="character", con="TSpadiConnection"),
   definition= function(x, con=getOption("TSconnection"), ...) NA )

setMethod("TSlabel",   signature(x="character", con="TSpadiConnection"),
   definition= function(x, con=getOption("TSconnection"), ...) NA )

setMethod("TSsource",   signature(x="character", con="TSpadiConnection"),
   definition= function(x, con=getOption("TSconnection"), ...) NA )

