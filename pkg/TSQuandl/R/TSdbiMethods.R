
setClass("QuandlDriver", representation("DBIDriver", Id = "character")) 

Quandl <- function() {
  drv <- "Quandl"
  attr(drv, "package") <- "TSQuandl"
  new("QuandlDriver", Id = drv)
  }

# for this require("DBI") ; require("TSdbi")
setClass("TSQuandlConnection", contains=c("conType", "TSdb"),
           representation(current="character"))
   # current is only used with vintages (faking info the db should have)
   #user / password / host  for future consideration

####### some kludges to make this look like DBI. ######
# these do nothing, but prevents error messages

setMethod("dbDisconnect", signature(conn="TSQuandlConnection"), 
   definition=function(conn,...) invisible(TRUE))

setMethod("dbUnloadDriver", signature(drv="QuandlDriver"),
   definition=function(drv, ...) invisible(TRUE))
#######     end kludges   ######

##########################################################################
# this should go in TSdbi
setMethod("TSconnect",   signature(drv="character", dbname="missing"),
   definition=function(drv, dbname=NULL, ...)
             TSconnect(dbDriver(drv), dbname=NULL, ...))

##########################################################################

setMethod("TSconnect",   signature(drv="QuandlDriver", dbname="missing"),
   definition=function(drv, dbname=NULL, ...) {
        if (is.null(dbname)) stop("Quandl dbname must be specified.")
	})

setMethod("TSconnect",   signature(drv="QuandlDriver", dbname="ANY"),
   definition=function(drv, dbname=NULL, ...) {
        if (is.null(dbname)) stop("Quandl dbname cannot be NULL.")
        new("TSQuandlConnection" , drv="Quandl", dbname=dbname, 
  	       hasVintages=FALSE, hasPanels  =FALSE) 
	})

setMethod("TSdates",  
   signature(serIDs="character", con="TSQuandlConnection", vintage="ANY", panel="ANY"),
   definition= function(serIDs, con, vintage=NULL, panel=NULL, ... ) { 
   # Indicate  dates for which data is available. 
   # This requires retrieving series individually so they are not truncated.

   if(!is.null(vintage)) stop("TSQuandlConnection does not support vintages.")
   r <- av <- st <- en <- tb <- NULL
   for (i in 1:length(serIDs))
     {r <- try(TSget( paste0(con@dbname,"/",serIDs[i]), con=con, vintage=vintage), silent=TRUE) 
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


#setMethod("TSget",     signature(serIDs="character", con="TSQuandlConnection"),
#   definition= 
   
TSget <- function(serIDs, con, TSrepresentation=getOption("TSrepresentation"),
       tf=NULL, start=tfstart(tf), end=tfend(tf), names=NULL, quote = NULL, 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       vintage=NULL, ...)
{ # ... arguments unused
  if(!is.null(vintage)) stop("TSQuandlConnection does not support vintages.")
  if(any(TSdescription, TSdoc, TSlabel)) 
      stop("TSQuandlConnection does not support metadata.")

  if (is.null(TSrepresentation)) TSrepresentation <- "default"
  if ( 1 < sum(c(length(serIDs), length(vintage)) > 1))
   stop("Only one of serIDs or vintage can have length greater than 1.")

  if(is.null(names)) names <- serIDs 
  dbname <- rep(con@dbname, length(serIDs))   
  
  if(!is.null(quote)){  # recycle serIDs and quote to matching lengths
    if (length(quote) < length(serIDs))
        quote  <- rep(quote,  length.out=length(serIDs))
    if (length(quote) > length(serIDs))
        serIDs <- rep(serIDs, length.out=length(quote))
    quote <- toupper(quote) 
    }

  mat <- desc <- doc <- label <- source <-  rp <- NULL

  if( !is.null(start))
     start <- as.character(as.POSIXlt(start), format="%Y-%m-%d")
  if( !is.null(end)) 
      end  <- as.character(as.POSIXlt(end),   format="%Y-%m-%d")
  
  if(TSrepresentation %in% c("ts", "zoo", "xts")) {
     type <- TSrepresentation
     convertRep <- FALSE
     }
  else {
     type <- "zoo"
     convertRep <- TRUE
     }

  for (i in seq(length(serIDs))) {
    if (is.null(start) & is.null(end))
      r <- Quandl::Quandl(paste0(con@dbname,"/",serIDs[i]), type=type)
    else if (is.null(start))
      r <- Quandl::Quandl(paste0(con@dbname,"/",serIDs[i]), type=type,
    		end_date=end)
    else if (is.null(end))
      r <- Quandl::Quandl(paste0(con@dbname,"/",serIDs[i]), type=type,
    		start_date=start)
    else 
      r <- Quandl::Quandl(paste0(con@dbname,"/",serIDs[i]), type=type,
    		start_date=start, end_date=end)

    if(0==length(r)){
       stop("Quandl retrieval failed. Series '", serIDs[i],"' may not exist.")
        }
    
    if(!is.null(quote)) r <- r[,quote[i]]
    
    mat <- tbind(mat, r)
   #if(TSdescription) desc <- c(desc,   TSdescription(serIDs[i],con) ) 
    #if(TSdoc)     doc      <- c(doc,    TSdoc(serIDs[i],con) ) 
    #if(TSlabel)   label    <- c(label,  NA) #TSlabel(serIDs[i],con) )
    if(TSsource)  source   <- c(source, "Quandl") #could be better
    }

  # identifiers can be multivariate. 
  #  eg. BOC/CDN_CPI has "Total CPI" "Total CPI S.A." "Core CPI" 
  #      "% Change 1 Yr: Total CPI" ... 7 series
  #if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 

  if (convertRep) {
    fr <- try( frequency(mat), silent=TRUE )  
    if ((! inherits(fr, "try-error")) && !is.null(fr)){ 
       if((TSrepresentation=="default") && (fr %in% c(1,4,12,2)))
           r <-  as.ts(r) 
       }

    if (! TSrepresentation  %in% "default"){
       mat <- changeTSrepresentation(mat, TSrepresentation)
       }
    }

#  mat <- tfwindow(mat, tf=tf, start=start, end=end)

  #if( (!is.null(rp)) && !all(is.na(rp)) ) TSrefperiod(mat) <- rp      

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


setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSQuandlConnection"),
   definition= function(x, serIDs=seriesNames(x), con,   
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=NULL,  
       TSsource.=NULL, warn=TRUE, ...) 
 {stop("TSput is not supported on TSQuandl connection yet.")
  } )



setMethod("TSdescription",   signature(x="character", con="TSQuandlConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
     r <- try(Quandl(paste0(con@dbname,"/",serIDs), meta=TRUE)))
     if (inherits(r, "try-error")) stop("Series (probably) does not exist.")
     #if (is.null(r)) stop("Series (probably) does not exist.")
     #if(is.null(r) || is.na(r)|| ("NA" == r)) NA else r 
     if(is.na(r)|| ("NA" == r)) NA else r })

setMethod("TSdoc",   signature(x="character", con="TSQuandlConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
     r <- try(bdp(con@jcon, serIDs, c("NAME","LAST_UPDATE_DT","TIME")))
     if (inherits(r, "try-error")) stop("Series (probably) does not exist.")
     #if (is.null(r)) stop("Series (probably) does not exist.")
     #if(is.null(r) || is.na(r)|| ("NA" == r)) NA else r 
     if(is.na(r)|| ("NA" == r)) NA else r })

#TSlabel,TSsource, get used for new("Meta", so issuing a warning is not a good idea here.

setMethod("TSlabel",   signature(x="character", con="TSQuandlConnection"),
   definition= function(x, con=getOption("TSconnection"), ...) NA )

setMethod("TSsource",   signature(x="character", con="TSQuandlConnection"),
   definition= function(x, con=getOption("TSconnection"), ...) NA )

setMethod("TSdelete",
   signature(serIDs="character", con="TSQuandlConnection", vintage="ANY", panel="ANY"),
   definition= function(serIDs, con=getOption("TSconnection"),  
            vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...){
    stop("TSdelete not supported on TSQuandl connection.")
    })


setMethod("TSexists", 
 signature(serIDs="character", con="TSQuandlConnection", vintage="ANY", panel="ANY"),
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
