
########################################################################
##                 Quandl
########################################################################

Quandl <- function(...) {
  drv <- "Quandl"
  attr(drv, "package") <- "TSQuandl"
  new("QuandlDriver", Id = drv)
  }


####### some kludges to make this look like DBI. ######

setClass("QuandlDriver", contains=c("DBIDriver"), slots=c(Id = "character")) 

setClass("QuandlConnection", contains=c("DBIConnection", "QuandlDriver"),
   slots=c(dbname="character") )

setMethod("dbConnect", signature(drv="QuandlDriver"), 
     definition=function(drv, dbname, ...) 
                   new("QuandlConnection", drv, dbname=dbname))

setMethod("dbDisconnect", signature(conn="QuandlConnection"), 
   definition=function(conn,...) invisible(TRUE))

#setMethod("dbUnloadDriver", signature(drv="QuandlDriver"),
#   definition=function(drv, ...) invisible(TRUE))

#######     end kludges   ######

setClass("TSQuandlConnection", contains=c("QuandlConnection", "conType", "TSdb"),
           slots = c(token=c("character", "logical")))

setMethod("TSconnect", signature(q="QuandlConnection", dbname="missing"),
   definition= function(q, dbname, token=NULL, ...) {
        dbname <- q@dbname 
        # get defaults from file  or system variables but 
	# token can be NULL if system variable is not set, and this
	# works up to Quandl limit. Quandl::Quandl.auth() uses NA for not set.
	# It allows resetting to NULL but then things break so leave NA if not set.
        if (is.null(token)) token <- Quandl::Quandl.auth() #returns set value or NA
   	if (is.na(token)) {
   	  f <- paste0(Sys.getenv("HOME"),"/.Quandl.cnf")
   	  if (file.exists(f)) {
             f <- scan(f, what="", quiet=TRUE) #token
             token <- f[1]
             }
          else  token <- Sys.getenv()["QUANDL_TOKEN"] #may be NULL
          if (is.null(token)) token <- NA
          token <- Quandl::Quandl.auth(token) # set, possibly to default NA
	  }
	new("TSQuandlConnection" , dbname=dbname, token=token, 
  	       hasVintages=FALSE, hasPanels=FALSE) 
	}
	)

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


setMethod("TSget",     signature(serIDs="character", con="TSQuandlConnection"),
   definition= function(serIDs, con, TSrepresentation=getOption("TSrepresentation"),
       tf=NULL, start=tfstart(tf), end=tfend(tf), names=NULL, quote = NULL, 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       vintage=NULL, ...)
{ # ... arguments unused
  if(!is.null(vintage)) stop("TSQuandl does not support vintages yet.")

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
    #  quote <- toupper(quote) Close NOT CLOSE
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

  if (TSdescription | TSdoc | TSlabel ) meta <- TRUE
  else  meta <- FALSE
  metadata   <- list()

# sort="asc"  should be ignored but is important as of Nov23,2013
  #if(!is.null(con@token)) tok <- con@token else tok <- NA
  tok <- con@token 


  for (i in seq(length(serIDs))) {
    if (is.null(start) & is.null(end))
      r <- Quandl::Quandl(paste0(con@dbname,"/",serIDs[i]), 
              sort="asc", type=type,meta=meta, authcode = tok)
    else if (is.null(start))
      r <- Quandl::Quandl(paste0(con@dbname,"/",serIDs[i]), 
              sort="asc", type=type,meta=meta, authcode = tok, end_date=end)
    else if (is.null(end))
      r <- Quandl::Quandl(paste0(con@dbname,"/",serIDs[i]), 
              sort="asc", type=type,meta=meta, authcode = tok, start_date=start)
    else 
      r <- Quandl::Quandl(paste0(con@dbname,"/",serIDs[i]), 
              sort="asc", type=type,meta=meta, authcode = tok,
    		start_date=start, end_date=end)

    if(0==length(r)){
       stop("Quandl retrieval failed. Series '", serIDs[i],"' may not exist.")
        }
    
    if(!is.null(quote)) r <- r[,quote[i], drop=FALSE]

    # Need version ( <=2.2.1)of Quandl for this. May eventuall have metaData(r)
    met <- attr(r, "meta")
    if(TSdescription) desc <- c(desc,   met$description ) 
    if(TSdoc)     doc      <- c(doc,    paste("updated", met$updated,
      "from", met$source_name, met$source_link, met$source_description))
    if(TSlabel)   label    <- c(label,  met$name) 
    if(TSsource)  source   <- c(source, paste(serIDs ,con@dbname,"via Quandl")) 
    
    attr(r, "meta") <- NULL
    mat <- tbind(mat, r)
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

  # identifiers can be multivariate so setting names does not work 
  #seriesNames(mat) <- names 

  TSmeta(mat) <- new("TSmeta", serIDs=serIDs, dbname=dbname, 
      hasVintages=con@hasVintages, hasPanels=con@hasPanels,
      conType=class(con), 
      DateStamp=Sys.time(), 
      TSdescription= if(TSdescription) desc else NA, 
      TSdoc        = if(TSdoc)          doc else NA,
      TSlabel      = if(TSlabel)      label else NA,
      TSsource     = if(TSsource)    source else NA )
  mat
}
)


setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSQuandlConnection"),
   definition= function(x, serIDs=seriesNames(x), con,   
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=NULL,  
       TSsource.=NULL, warn=TRUE, ...) 
 {stop("TSput is not supported on TSQuandl connection yet.")
  } )


# there may be a way to do this without getting the data (and discarding it).
setMethod("TSdescription",   signature(x="character", con="TSQuandlConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
     r <- try(TSget(x ,con, TSdescription=TRUE))
     if (inherits(r, "try-error")) stop("Series (probably) does not exist.")
     if (is.null(r)) stop("Series (probably) does not exist.")
     if(is.null(TSmeta(r)@TSdescription)) NA else TSmeta(r)@TSdescription 
     })

setMethod("TSdoc",   signature(x="character", con="TSQuandlConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
     r <- try(TSget(x ,con, TSdoc=TRUE))
     if (inherits(r, "try-error")) stop("Series (probably) does not exist.")
     if (is.null(r)) stop("Series (probably) does not exist.")
     if(is.null(TSmeta(r)@TSdoc)) NA else TSmeta(r)@TSdoc
     })

#?? TSlabel,TSsource, get used for new("Meta", so issuing a warning is not a good idea here.

setMethod("TSlabel",   signature(x="character", con="TSQuandlConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
     r <- try(TSget(x ,con, TSlabel=TRUE))
     if (inherits(r, "try-error")) stop("Series (probably) does not exist.")
     if (is.null(r)) stop("Series (probably) does not exist.")
     if(is.null(TSmeta(r)@TSlabel)) NA else TSmeta(r)@TSlabel
     })

setMethod("TSsource",   signature(x="character", con="TSQuandlConnection"),
   definition= function(x, con=getOption("TSconnection"), ...){
     r <- try(TSget(x ,con, TSsource=TRUE))
     if (inherits(r, "try-error")) stop("Series (probably) does not exist.")
     if (is.null(r)) stop("Series (probably) does not exist.")
     if(is.null(TSmeta(r)@TSsource)) NA else TSmeta(r)@TSsource
     })


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
   x <-  try(Quandl::Quandl(paste0(con@dbname,"/",serIDs),, meta=FALSE))
   ok <- ! inherits(x, "try-error")
   new("logicalId",  !is.null(ok), 
       TSid=new("TSid", serIDs=serIDs, dbname=con@dbname, 
         conType=class(con), hasVintages=con@hasVintages, hasPanels=con@hasPanels,
	 DateStamp=NA))
   })
