
setClass("jsonDriver", representation("DBIDriver", Id = "character")) 

json <- function() {
  drv <- "json"
  attr(drv, "package") <- "TSjson"
  new("jsonDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSjsonConnection", contains=c("DBIConnection", "conType","TSdb"),
   representation(user="character", password="character", host="character",
                  url="character", proxy="logical") )

####### some kludges to make this look like DBI. ######
# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSjsonConnection"), 
     definition=function(conn,...) TRUE)
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="jsonDriver", dbname="character"),
  definition= function(drv, dbname, user=NULL, password=NULL, host=NULL, ...){
 if (is.null(dbname)) stop("dbname must be specified")
 # if other values are not specified get defaults from file or system variables

 if (dbname == "proxy-cansim") {
   dbname <- "scapi/default/get.json"
   
   f <- paste(Sys.getenv("HOME"),"/.TSjson.cfg", sep="")
   if (file.exists(f)) {
       f <- scan(f, what="") # parse a file for [proxy-cansim] user password host
       # only proxy-cansim supported for now
       r <- list(user=f[2],        
                 password = f[3] , 
                 host     = f[4]   
		 )
      }
   else  r <- list(user     = Sys.getenv()["TSJSONUSER"],
                   password = Sys.getenv()["TSJSONPASSWORD"],
                   host     = Sys.getenv()["TSJSONHOST"])
    
   if (is.null(user)) user <- r$user
   if (is.null(password)) password <-r$password
   if (is.null(host)) host <- r$host
   url <- paste("http://",user,":",password,"@",host,"/",dbname,"/", sep="")
   proxy <- TRUE
   } else

 if (dbname == "cansim") {
   user <- password <- host  <- ""
   # this is not really a url in this case, but the .py has the url+
   url <-  paste(path.package("TSjson"), "/exec/cansimGet.py ", sep = "")
   proxy <- FALSE
   }

 # there could be a better connection test mechanism 
 #if(inherits(con, "try-error")) 
 #      stop("Could not establish TSjsonConnection to ",  dbname)
   
 new("TSjsonConnection", drv="json", dbname=dbname,
        hasVintages=FALSE, hasPanels=FALSE, 
	user=user, password=password, host=host, url=url, proxy=proxy ) 
 } )


setMethod("TSdates",
  signature(serIDs="character", con="TSjsonConnection", vintage="ANY", panel="ANY"),
   definition= function(serIDs, con, vintage=NULL, panel=NULL, ... )  
{  # Indicate  dates for which data is available.
   # This requires retrieving series individually so they are not truncated.
   r <- av <- st <- en <- tb <- NULL
   for (i in 1:length(serIDs))
     {r <- try(TSget(serIDs[i], con, quiet=TRUE), silent = TRUE)

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
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       quiet=TRUE, repeat.try=3, ...){ 
       
  if(is.null(TSrepresentation)) TSrepresentation <- "default"
  if(is.null(repeat.try)) repeat.try <- 5
  
  url <- con@url 

  mat <- desc <- doc <- label <- source <-  rp <- NULL

  for (i in seq(length(serIDs))) {
    qq <- paste(url, serIDs[i], sep="")
    
    if(con@proxy){
       for (rpt in seq(repeat.try)) {
   	      rr <- try(getURL(qq), silent=quiet)
   	      if (!inherits(rr , "try-error")) break
   	      }

       if(inherits(rr , "try-error") ) stop(# after repeating
 	    "Series retrieval failed. Server ", con@host, "not responding.")

       # there may also be attr(rr,"errmsg") available
       if ((!is.null(attr(rr,"status"))) && (0 !=  attr(rr,"status")) ) 
   	  stop("Series retrieval failed. Series ",serIDs[i], " may not exist.")

       rr <-  try(fromJSON(rr, asText=TRUE), silent=quiet)
       if(inherits(rr , "try-error") ) stop(
   	   "Conversion from JSON failed, server returning unrecognized object.")
       } 
    else {#!con@proxy
       for (rpt in seq(repeat.try)) {
	    #rr <- try(system(qq, intern=TRUE), silent=quiet)
   	    rr <- fromJSON(pcon <- pipe(qq), asText=TRUE)
   	    close(pcon)
	    if ((!inherits(rr , "try-error"))){
	       if(is.atomic(rr)) stop(rr, "\n rr is atomic. DEBUG py.")
	       else if(is.null(rr$error)) break
	       }
   	    }
       if(inherits(rr , "try-error")) # after repeating
   	  stop("system command or fromJSON did not execute properly.")
       else if(!is.null(rr$error)) stop("error retrieving series: ", rr$error)
       
       # this is for system() rather than pipe()
       # if ((!is.null(attr(rr,"status"))) && (0 !=  attr(rr,"status")) ) stop( 
       #   "Series retrieval failed. Series ",serIDs[i], " may not exist.")
       }

    if(0==length(rr))
       stop("Series retrieval failed. Series ",serIDs[i], " may not exist.")

    fr <- rr$freq
    if("Error" == fr) stop("frequency not recognized.")
    st <- rr$start
    x  <- rr$x
    
    #this is necessary sometimes. unlist(x) would be ok but missing
    # values (py None are translated to json null and then as null
    # in the R list) get truncated out with unlist(x)
    if(is.list(x)) {
        na <- unlist(lapply(x, is.null))
	z <- unlist(x)
	x <- rep(NA, length(na)) 
	x[!na] <- z 
	}
    
    if((TSrepresentation=="default" | TSrepresentation=="ts") 
           && fr %in% c(1,4,12,2))
	 r <-   ts(x, start=st, frequency=fr) 
    else {
         require("tframePlus")
	 require("zoo")
	 r <-  zoo(x, order.by=as.Date(rr$dates, format='%b %d %Y'))
	 }

    mat <- tbind(mat, r)
    if(TSdescription) desc <- c(desc,   rr$shortdesc ) 
    if(TSdoc)     doc      <- c(doc,    rr$desc ) 
    if(TSlabel)   label    <- c(label,  serIDs[i] )
    if(TSsource)  source   <- c(source, rr$source )
    }

  if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 

  mat <- tfwindow(mat, tf=tf, start=start, end=end)

  if( (!is.null(rp)) && !all(is.na(rp)) ) TSrefperiod(mat) <- rp      

  if (! TSrepresentation  %in% c( "zoo", "default")){
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
   definition= function(x, con=getOption("TSconnection"), ...){
        TSdescription(TSget(serIDs=x, con=con, TSdescription=TRUE ))})

setMethod("TSdoc",   signature(x="character", con="TSjsonConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
        TSdoc(TSget(serIDs=x, con=con, TSdoc=TRUE ))})

setMethod("TSlabel",   signature(x="character", con="TSjsonConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
        TSlabel(TSget(serIDs=x, con=con, TSlabel=TRUE ))})

setMethod("TSsource",   signature(x="character", con="TSjsonConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
        TSsource(TSget(serIDs=x, con=con, TSsource=TRUE ))})

