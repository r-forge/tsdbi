
setClass("xlsDriver", representation("DBIDriver", Id = "character")) 

xls <- function() {
  drv <- "xls"
  attr(drv, "package") <- "TSxls"
  new("xlsDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSxlsConnection", contains=c("DBIConnection", "conType","TSdb"),
   representation(url="character", data="matrix", ids="character", 
        dates="character", names="character", description="character") 
   )

####### some kludges to make this look like DBI. ######
# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSxlsConnection"), 
     definition=function(conn,...) TRUE)
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="xlsDriver", dbname="character"),
  definition= 
TSconnectXLS <- function(drv, dbname, 
     map=list(ids, data, dates, names=NULL, description=NULL,
              tsrepresentation = function(data,dates){
		       zoo(data, as.Date(dates))}), ...){
   #  user / password / host  for future consideration
   if (is.null(dbname)) stop("dbname must be specified")

   if (!file.exists(dbname)){
     url <- dbname
     zz <- try(sys.call(paste("wget", url)),  silent=TRUE)
     if(inherits(zz, "try-error")) 
         stop("Could not find file or url ",  dbname)
     dbname <-temp.file()
     file.create(dbname, showWarnings = TRUE)
     #unlink on R exit or dbdisconnect
     }
   else url <- ""

   require("gdata")

   zz <- try(read.xls(dbname, sheet = 1, verbose=FALSE),  silent=TRUE)
                   #method=c("csv","tsv","tab"), perl="perl")
   if(inherits(zz, "try-error")) 
         stop("Could not establish TSxlsConnection to ",  dbname)

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
   nm    <- if(is.null(map$names)) NULL else combineRows(
            z[map$names$i,jmap(map$names$j)]) 
   desc  <- if(is.null(map$description)) NULL else combineRows(
            z[map$description$i,jmap(map$description$j)]) 
   
   #seriesInColumns=TRUE, assuming this for now

   if(length(dates) != NROW(data))
       stop("length of dates not equal length of series.")
   
   if(length(ids)   != NCOL(data))
       stop("number of ids not equal number of series.")
   
   if(!is.null(nm)) if(length(nm)   != NCOL(data))
       stop("number of names not equal number of series.")

   if(!is.null(desc)) if(length(desc)   != NCOL(data))
       stop("number of descriptions not equal number of series.")


   #Adjustments <- c(rep("nsa", 10),rep("sa", 4),rep("nsa", 2)) 
   #Units    <- z[1, 1]  ; names(Units) <- NULL
   #Notes    <- z[2, 1]  ; names(Notes) <- NULL
   #Updated <- z[8, -1]  ; names(Updated) <- NULL# date format error?
   #Source   <- z[9, -1] ; names(Source) <- NULL

   seriesNames(data ) <- ids
 
   # check that tsrepresentation works
   z <- try(map$tsrepresentation(data[,1], dates),  silent=TRUE)
   if(inherits(z, "try-error")) 
         stop("Could not convert data to series using tsrepresentation.")
  
   # cache data, etc in con
   # use ids to extract from cache, but give names
   new("TSxlsConnection", drv="xls", dbname=dbname, 
        hasVintages=FALSE, hasPanels=FALSE, url=url,
	data=data,ids=ids,dates=dates, names=names, description=desc) 
   } 
   )

  # con <- TSconnectXLS(drv="xlsDriver", dbname="d03hist.xls",
          map=list(ids  =list(i=11,     j="B:Q"), 
	           data =list(i=12:627, j="B:Q"), 
	           dates=list(i=12:627, j="A"),
                   names=list(i=4:7,    j="B:Q"), 
		   description = NULL,
		   tsrepresentation = function(data,dates){
		       ts(data,start=c(1959,7), frequency=12)}))

  # con <- TSconnectXLS(drv="xlsDriver", dbname="d03hist.xls",
          map=list(ids  =list(i=11,     j="B:Q"), 
	           data =list(i=12:627, j="B:Q"), 
	           dates=list(i=12:627, j="A"),
                   names=list(i=4:7,    j="B:Q"), 
		   description = NULL,
		   tsrepresentation = function(data,dates){
	dt <- strptime(paste("01-",dates[1], sep=""), format="%d-%b-%Y")
	st <- c(1900+dt$year, dt$mon)
	ts(data,start=st, frequency=12)}))

  # con <- TSconnectXLS(drv="xlsDriver", dbname="d03hist.xls",
          map=list(ids  =list(i=11,     j="B:Q"), 
	           data =list(i=12:627, j="B:Q"), 
	           dates=list(i=12:627, j="A"),
                   names=list(i=4:7,    j="B:Q"), 
		   description = NULL,
		   tsrepresentation = function(data,dates){
		       zoo(data,order.by =as.Date(dates))}))

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

TSrepresentation <- function(df, i, j, tf, names=NULL) {
   zz <- as.matrix(df)[ i, j]  
   require("tframe")
   trimAllNA(tframed(array(as.numeric(zz), dim(zz)), tf=tf, names=names)) 
   }

tsrepresentation <- function(df, i, j, start, frequency=NULL, names=NULL) {
   # assume ts with start date string "Month-YYYY" (Locale-specific conversion)
   dt <- strptime(paste("01-",start, sep=""), format="%d-%b-%Y")
   # drop NA on end
   TSrepresentation(df, i, j, 
      list(start=c(1900+dt$year, dt$mon), frequency=frequency),names=names)
   }

# dt$year and dt$month in next could be used to construct zoo or other time series
# dt <- z[ -(1:10), 1]
# dt <- strptime(paste("01-",dt, sep=""), format="%d-%b-%Y")

combineRows <- function(x, i, j, setEmpty=NULL){
  x[setEmpty] <- ""
  x <- x[i,j]
  r <- NULL
  for (ii in seq(NROW(x))) r <- paste(r, x[ii,])
  r
  }

