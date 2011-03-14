
setClass("xlsDriver", representation("DBIDriver", Id = "character")) 

xls <- function() {
  drv <- "xls"
  attr(drv, "package") <- "TSxls"
  new("xlsDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSxlsConnection", contains=c("DBIConnection", "conType","TSdb"),
   representation(url="character", data="matrix", ids="character", 
        dates="character", names="character", description="character",
	tsrepresentation = "function") 
   )

####### some kludges to make this look like DBI. ######
# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSxlsConnection"), 
     definition=function(conn,...) TRUE)
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="xlsDriver", dbname="character"),
  definition=function(drv, dbname, 
     map=list(ids, data, dates, names=NULL, description=NULL,
              tsrepresentation = function(data,dates){
		       zoo(data, as.Date(dates))}), ...){
   #  user / password / host  for future consideration
   if (is.null(dbname)) stop("dbname must be specified")

   if (file.exists(dbname)) {
      file <- dbname
      url <- ""
      }
   else{
     url <- dbname
     file <- tempfile()
     on.exit(unlink(file) )
     zz <- try(download.file(url, file, quiet = FALSE, mode = "w",
                   cacheOK = TRUE),  silent=TRUE)
     #or url(url)

     if(inherits(zz, "try-error")) 
         stop("Could not find file or url ",  dbname)
     }

   require("gdata")

   zz <- try(read.xls(file, sheet = 1, verbose=FALSE),  silent=TRUE)
                   #method=c("csv","tsv","tab"), perl="perl")
   if(inherits(zz, "try-error")) 
         stop("Could read not spreedsheet ",  dbname, zz)

   #NB The first line provides data frame names, so rows are shifted. 
   #   This fixes so matrix corresponds to spreadsheet cells
   z <- rbind(names(zz), as.matrix(zz))

   #   Blank rows seem to be skipped, so result is compressed

   # translate cell letters to numbers MAKE LONGER
   jmap <- function(cols){ 
        charmatch(sub(":[A-Z]*","",cols), LETTERS):
        charmatch(sub("[A-Z]*:","",cols), LETTERS) 
	}

   ids   <- z[map$ids$i,  jmap(map$ids$j)] 
   data  <- z[map$data$i, jmap(map$data$j)]   
   dates <- z[map$dates$i,jmap(map$dates$j)]   
   nm    <- if(is.null(map$names)) NULL else TSxls:::combineRows(
            z[map$names$i,jmap(map$names$j)]) 
   desc  <- if(is.null(map$description)) NULL else TSxls:::combineRows(
            z[map$description$i,jmap(map$description$j)]) 
   
   #seriesInColumns=TRUE, assuming this for now
   
   z <- dim(data)
   data <- try(as.numeric(data),  silent=TRUE)
   if(inherits(data, "try-error")) 
         stop("Error converting  data to numeric.", data)
   
   data <- array(data, z)

   if(length(dates) != NROW(data))
       stop("length of dates not equal length of series.")
   
   if(length(ids)   != NCOL(data))
       stop("number of ids not equal number of series.")
   
   if(!is.null(nm)) if(length(nm)   != NCOL(data))
       stop("number of names not equal number of series.")

   if(!is.null(desc)) if(length(desc)   != NCOL(data))
       stop("number of descriptions not equal number of series.")

   if(is.null(nm))   nm   <- rep("",NCOL(data))
   if(is.null(desc)) desc <- rep("",NCOL(data))
   
   seriesNames(data ) <- ids
   names(nm)   <- ids
   names(desc) <- ids

   #Adjustments <- c(rep("nsa", 10),rep("sa", 4),rep("nsa", 2)) 
   #Units    <- z[1, 1]  ; names(Units) <- NULL
   #Notes    <- z[2, 1]  ; names(Notes) <- NULL
   #Updated <- z[8, -1]  ; names(Updated) <- NULL# date format error?
   #Source   <- z[9, -1] ; names(Source) <- NULL
 
   # check that tsrepresentation works
   z <- try(map$tsrepresentation(data[,1], dates),  silent=TRUE)
   if(inherits(z, "try-error")) 
         stop("Could not convert data to series using tsrepresentation.",z)
  
   # cache data, etc in con
   # use ids to extract from cache, but give names
   new("TSxlsConnection", drv="xls", dbname=dbname, 
        hasVintages=FALSE, hasPanels=FALSE, url=url,
	data=data,ids=ids,dates=dates, names=nm, description=desc,
	tsrepresentation=map$tsrepresentation) 
   } 
   )

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
       names=serIDs, ...){ 
    if (is.null(TSrepresentation)) TSrepresentation <- "ts"
    
    # data, ids and dates are cached in con
    mat <- try(con@tsrepresentation(con@data[,serIDs], con@dates),
               silent=TRUE)
    if(inherits(mat, "try-error")) 
         stop("Could not convert data to series using tsrepresentation.",mat)
    # give names rather than id mnemonic 
    seriesNames(mat) <- con@names[serIDs]
    desc <- con@description[serIDs]

    if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 
    mat <- tfwindow(mat, tf=tf, start=start, end=end)
    #if (! TSrepresentation  %in% c( "zoo", "default")){
    #  require("tframePlus")
    #  mat <- changeTSrepresentation(mat, TSrepresentation)
    #  }

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

##### utilities #####

trimAllNA <- function(x, startNAs= TRUE, endNAs= TRUE) UseMethod("trimAllNA") 

trimAllNA.default <- function(x, startNAs= TRUE, endNAs= TRUE)
{# trim NAs from the ends of a ts matrix or vector.
 # (Observations are dropped if all in a given period contain NA.)
 # if startNAs=F then beginning NAs are not trimmed.
 # If endNAs=F   then ending NAs are not trimmed.
 sample <- ! if (is.matrix(x)) apply(is.na(x),1, all) else is.na(x)
 if (!any(sample)) warning("data is empty after triming NAs.")
 s <- if (startNAs) min(time(x)[sample]) else tfstart(x)
 e <- if (endNAs)   max(time(x)[sample]) else tfend(x)
 tfwindow(x, start=s, end=e, warn=FALSE)
}

combineRows <- function(x, i, j, setEmpty=NULL){
  x[setEmpty] <- ""
  x <- x[i,j]
  r <- NULL
  for (ii in seq(NROW(x))) r <- paste(r, x[ii,])
  r
  }

