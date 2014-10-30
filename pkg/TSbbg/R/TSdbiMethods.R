bbg <- function(...) {
  drv <- "bbg"
  attr(drv, "package") <- "TSbbg"
  new("bbgDriver", Id = drv)
  }

# Notes
#  r <- bdh(con, serIDs[i], fld="PX_LAST", sdate="20020101")
#  failure tested by zero length result is probably not good.

#  showClass("jobjRef")
#  showClass("TSbbgConnection")

####### some kludges to make this look like DBI. ######

setClass("bbgDriver", contains=c("DBIDriver"). slots=c(Id = "character")) 

setClass("bbgConnection", contains=c("DBIConnection", "bbgDriver"),
   slots=c(dbname="character") )

setMethod("dbConnect", signature(drv="bbgDriver"), 
     definition=function(drv, dbname, ...) 
                   new("bbgConnection", drv, dbname=dbname))

# this does nothing, but prevents error messages
setMethod("dbDisconnect", signature(conn="bbgConnection"), 
   definition=function(conn,...) invisible(TRUE))

#######     end kludges   ######

setClass("TSbbgConnection", contains=c("bbgConnection", "conType", "TSdb"),  
          slots=c(jcon="jobjRef"))

setMethod("TSconnect",   signature(q="TSbbgConnection", dbname="missing"),
   definition=function(q, dbname, ...) {
        dbname <- q@dbname
        con <- try(blpConnect(verbose=FALSE))
	if(inherits(con, "try-error") )
           stop("Could not establish TSbbgConnection.")
	new("TSbbgConnection" , jcon=con, drv="bbg", dbname="not used", 
  	       hasVintages=FALSE, hasPanels  =FALSE) 
	})

setMethod("TSdates",  
   signature(serIDs="character", con="TSbbgConnection", vintage="ANY", panel="ANY"),
   definition= function(serIDs, con, vintage=NULL, panel=NULL, ... ) { 
   # Indicate  dates for which data is available. 
   # This requires retrieving series individually so they are not truncated.

   if(!is.null(vintage)) stop("TSbbgConnection does not support vintages.")
   r <- av <- st <- en <- tb <- NULL
   for (i in 1:length(serIDs))
     {r <- try(TSget( serIDs[i], con=con, vintage=vintage), silent=TRUE) 
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


#setMethod("TSget",     signature(serIDs="character", con="TSbbgConnection"),
#   definition= 
   
TSget <- function(serIDs, con, TSrepresentation=getOption("TSrepresentation"),
       tf=NULL, start=tfstart(tf), end=tfend(tf), names=NULL, quote = "Close", 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       vintage=NULL, ...)
{ # ... arguments unused
  if(!is.null(vintage)) stop("TSbbgConnection does not support vintages.")
  if(any(TSdescription, TSdoc, TSlabel)) 
      stop("TSbbgConnection does not support metadata.")

  if (is.null(TSrepresentation)) TSrepresentation <- "default"
  if ( 1 < sum(c(length(serIDs), length(vintage)) > 1))
   stop("Only one of serIDs or vintage can have length greater than 1.")

  if(is.null(names)) names <- serIDs 
  dbname <- NULL  #rep(con@dbname, length(serIDs))   
  
  # recycle serIDs and quote to matching lengths
  if (length(quote) < length(serIDs))
      quote  <- rep(quote,  length.out=length(serIDs))
  if (length(quote) > length(serIDs))
      serIDs <- rep(serIDs, length.out=length(quote))

  #"PRICE_AT_NOON", "PRICE_AT_CLOSE", "VOLUME_TRADED"   
  #"PX_LAST" is synonym "PRICE_AT_CLOSE"
  # For consistency with TShistQuote:
  quote[toupper(quote) == "CLOSE"]  <- "PRICE_AT_CLOSE" 
  quote[toupper(quote) == "OPEN"]   <- "PRICE_AT_OPEN"   
  quote[toupper(quote) == "VOLUME"] <- "VOLUME_TRADED"   

  mat <- desc <- doc <- label <- source <-  rp <- NULL

  # Use bar() if the start or end has a time as well as date, eg, ticker data,
  #    otherwise bdh(), eg daily data like open, close.
  # This can be a bit tricky because start and end may be passed as
  #   char strings or as Date POSIXt objects. POSIXt dates with no time
  #   are represented as midnight UTC (POSIXlt $hour $min and $sec all 0).
  #  So, the strategy here is to convert to POSIXlt and check if these are 0.

  if(is.null(start)) stop("A start must be specified.")
  else start <- as.POSIXlt(start)

print(str(start))

  if( !is.null(end))   end <- as.POSIXlt(end)

  barCall <- !all(0 == c(start$hour, start$min, start$sec, end$hour, end$min, end$sec))

  if(barCall) {# has a time as well as date, eg, ticker data
     # Note that retention period for intra-day data varies, with older data 
     # only available at longer intervals. Tick data is only available about
     # 10days, 240min intervals up to 6 months.
     start   <-   format.POSIXlt(start, "%Y-%m-%d %H:%M:%OS3")
    
     if( is.null(end))  stop("An end must be specified for bar() calls.")  
     else end  <- format.POSIXlt(end,   "%Y-%m-%d %H:%M:%OS3")
     
     if(is.null(list(...)$interval)) stop("interval must be specified.")
     else interval <- list(...)$interval
     }
  else  {
     start <- as.character(start, format="%Y%m%d")
     if( !is.null(end))    end  <- as.character(end,   format="%Y%m%d")
     }

  for (i in seq(length(serIDs))) {
    #  may need try around this
    # old code has fld,sdate="20020101" but new version seems to have fields, start_date
    # start must be supplied, end can be NULL

    if(barCall)  { # has a time as well as date, eg, ticker data
       cat("barCall\n")
       # data at 60 min interval is available for 6 months.
       #bar(bbgcon, "RYA ID Equity", "TRADE",
       #        "2012-11-20 09:00:00.000", "2012-11-20 15:00:00.000", "60")
       # fields returned by TRADE are 
       #    time, open, high, low, close, numEvents, volume
       
       # for debugging
	cat(" barCall try7\n")       
        cat(" barCall interval=", interval, "\n")       
       r <- try(bar(con@jcon, serIDs[i], field=quote[i], 
                start_date_time=start, 
		end_date_time=end, interval=interval))
   print(str(r))
       if (toupper(quote) == "TRADE") quote <- c(
	  "open", "high", "low", "close", "numEvents", "volume")

   print(str(quote))
   print(tolower(quote))
   print(names(r))
       r <- zoo(r[, tolower(quote)], 
         order.by=as.POSIXlt(r$time, format='%Y-%m-%dT%H:%M:%S'))
       }
    else {
       r <- try(bdh(con@jcon, serIDs[i], field=quote[i],
                  start_date=start, end_date=end))
      if (inherits(r, "try-error")){ 
	  print(str(r))
	  stop("Series (probably) does not exist.")
	  }
      if(0==length(r)){
	  print(str(r))
          stop("bbg retrieval failed. Series '", serIDs[i],"' may not exist.")
	  }
       r <- zoo(r$fld, order.by=as.Date(r$date))
       }
      
    fr <- try( frequency(r), silent=TRUE )  
    print(str(TSrepresentation))
    print(str(fr))
    if ((! inherits(fr, "try-error")) && !is.null(fr)){ 
 cat(" trying as.ts() fr is\n")       
 print(str(fr))

       if((TSrepresentation=="default" | TSrepresentation=="ts")
             && fr %in% c(1,4,12,2)) r <-  as.ts(r) 
       }
 cat(" trying tbind() fr is\n")       
 print(str(r))
    mat <- tbind(mat, r)
  print(str(mat))
   #if(TSdescription) desc <- c(desc,   TSdescription(serIDs[i],con) ) 
    #if(TSdoc)     doc      <- c(doc,    TSdoc(serIDs[i],con) ) 
    #if(TSlabel)   label    <- c(label,  NA) #TSlabel(serIDs[i],con) )
    if(TSsource)  source   <- c(source, "Bloomberg") #could be better
    }

  if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 

cat(" trying tfwindow\n")       
 print(str(mat))
  mat <- tfwindow(mat, tf=tf, start=start, end=end)

  #if( (!is.null(rp)) && !all(is.na(rp)) ) TSrefperiod(mat) <- rp      

  if (! TSrepresentation  %in% c( "zoo", "default")){
      require("tframePlus")
      mat <- changeTSrepresentation(mat, TSrepresentation)
      }

  seriesNames(mat) <- names 

  TSmeta(mat) <- new("TSmeta", serIDs=serIDs, dbname=dbname, 
      hasVintages=con@hasVintages, hasPanels=con@hasPanels,
      conType=class(con), 
      DateStamp=Sys.time(), 
      TSdescription=NA, 
      TSdoc=NA,
      TSlabel=NA,
      TSsource=if(TSsource) source else NA )
  mat
}
# )


setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSbbgConnection"),
   definition= function(x, serIDs=seriesNames(x), con,   
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=NULL,  
       TSsource.=NULL, warn=TRUE, ...) 
 {stop("TSput is not supported on TSbbg connection.")
  } )



setMethod("TSdescription",   signature(x="character", con="TSbbgConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
     r <- try(bdp(con@jcon, serIDs, c("NAME","LAST_UPDATE_DT","TIME")))
     if (inherits(r, "try-error")) stop("Series (probably) does not exist.")
     #if (is.null(r)) stop("Series (probably) does not exist.")
     #if(is.null(r) || is.na(r)|| ("NA" == r)) NA else r 
     if(is.na(r)|| ("NA" == r)) NA else r })

setMethod("TSdoc",   signature(x="character", con="TSbbgConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
     r <- try(bdp(con@jcon, serIDs, c("NAME","LAST_UPDATE_DT","TIME")))
     if (inherits(r, "try-error")) stop("Series (probably) does not exist.")
     #if (is.null(r)) stop("Series (probably) does not exist.")
     #if(is.null(r) || is.na(r)|| ("NA" == r)) NA else r 
     if(is.na(r)|| ("NA" == r)) NA else r })

#TSlabel,TSsource, get used for new("Meta", so issuing a warning is not a good idea here.

setMethod("TSlabel",   signature(x="character", con="TSbbgConnection"),
   definition= function(x, con=getOption("TSconnection"), ...) NA )

setMethod("TSsource",   signature(x="character", con="TSbbgConnection"),
   definition= function(x, con=getOption("TSconnection"), ...) NA )

setMethod("TSdelete",
   signature(serIDs="character", con="TSbbgConnection", vintage="ANY", panel="ANY"),
   definition= function(serIDs, con=getOption("TSconnection"),  
            vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...){
    stop("TSdelete not supported on TSbbg connection.")
    })


setMethod("TSexists", 
 signature(serIDs="character", con="TSbbgConnection", vintage="ANY", panel="ANY"),
 definition= function(serIDs, con=getOption("TSconnection"), 
                      vintage=NULL, panel=NULL, ...){
   op <- options(warn=-1)
   on.exit(options(op))
   x <-  try(bdp(con@jcon, serIDs, c("NAME","LAST_UPDATE_DT","TIME")))
   ok <- ! inherits(x, "try-error")
   new("logicalId",  !is.null(ok), 
       TSid=new("TSid", serIDs=serIDs, dbname=con@dbname, 
         conType=class(con), hasVintages=con@hasVintages, hasPanels=con@hasPanels,
	 DateStamp=NA))
   })
