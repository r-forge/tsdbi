
setClass("zipDriver", representation("DBIDriver", Id = "character")) 

zip <- function() {
  drv <- "zip"
  attr(drv, "package") <- "TSzip"
  new("zipDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSzipConnection", contains=c("DBIConnection", "conType","TSdb"),
   representation(suffix="character") )

####### some kludges to make this look like DBI. ######
# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSzipConnection"), 
     definition=function(conn,...) TRUE)
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="zipDriver", dbname="character"),
  definition=function(drv, dbname, 
                suffix=c("Open","High","Low","Close","Volume","OI"), ...){ 
   #  user / password / host  for future consideration
   # may need to to have this function specific to dbname  cases as in TSsdmx
   if (is.null(dbname)) stop("dbname must be specified")
   
   new("TSzipConnection", drv="zip", dbname=dbname, 
        hasVintages=FALSE, hasPanels=FALSE,
	#read.csvArgs=list(...), 
	suffix=suffix) 
   } 
   )

setMethod("TSdates",
  signature(serIDs="character", con="TSzipConnection", vintage="ANY", panel="ANY"),
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

setMethod("TSget",     signature(serIDs="character", con="TSzipConnection"),
   definition=function(serIDs, con, TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=NULL, quote=con@suffix, ...){ 
   if (mode(TSrepresentation) == "character" && TSrepresentation == "tis") {
	    require("tis")
	    require("zoo")
	    }
   if (is.null(TSrepresentation)) {
      require("zoo")
      TSrepresentation <- zoo
      }
    
   if(is.null(names)) names <- c(t(outer(serIDs, quote, paste, sep=".")))
   quote <- con@suffix %in% quote

   dir <- tempfile()
   dir.create(dir)
   on.exit(unlink(dir) )
   mat <- NULL
   
   for (i in 1:length(serIDs)){
      url <- paste(con@dbname, "/", serIDs[i], ".zip", sep="")
      file <- paste(dir, "/", serIDs[i], ".zip", sep="")

      zz <- try(download.file(url, file, quiet = TRUE, mode = "wb",
   		      cacheOK = TRUE),  silent=TRUE) 
      if(inherits(zz, "try-error") || (0 != zz)) 
       stop("download.file error, possibly could not find url ",  url,
            " or file ", file)

      zz <- try(unzip(file, overwrite = TRUE, exdir=dir))
      #zz <- try(system(paste("unzip", file, " -d ", dir)),  silent=TRUE)
      if(inherits(zz, "try-error")) stop("Could not unzip file ", file)

      file <- paste(dir, "/", serIDs[i], ".txt", sep="")
      zz <- try(read.csv(file),  silent=TRUE)
   		      #method=c("csv","tsv","tab"), perl="perl")
  #  # header=TRUE, sep=",", quote="\"", dec=".", fill=TRUE, comment.char=""  
  #  #  could use colClasses
     
      if(inherits(zz, "try-error")) 
   	    stop("Could read downloaded file ",  file, zz)
    
      zz <- as.matrix(zz)
      dates <- as.Date(zz[,1], format="%m/%d/%Y")
      zzz <- try(as.numeric(zz[,-1]),  silent=TRUE)
      if(inherits(zzz, "try-error")) 
   	    stop("Error converting  data to numeric.", data)
      
      d <- matrix(zzz, NROW(zz), NCOL(zz)-1 )
      #d <- zoo(d[, quote], order.by=dates)
      #d <- as.tis(zoo(d[, quote], order.by=dates))
      #d <- timeSeries(d[, quote], charvec=dates)
      #d <- TSrepresentation(d[, quote], dates)
      if (mode(TSrepresentation) == "character") d <- 
	 if (TSrepresentation == "tis") as.tis(zoo(d[, quote], order.by=dates))
	 else                do.call(TSrepresentation, list(d[, quote], dates))
      else d <- TSrepresentation(d[, quote], dates)
  
      mat <- tbind(mat,d)
      }
   
    seriesNames(mat) <- names
    desc <- paste(names, " from ", con@dbname)
   
    mat <- tfwindow(mat, tf=tf, start=start, end=end)
 
    TSmeta(mat) <- new("TSmeta", serIDs=serIDs,  dbname=con@dbname, 
        hasVintages=con@hasVintages, hasPanels=con@hasPanels,
  	conType=class(con), DateStamp= Sys.time(), 
	TSdoc=paste(desc, "retrieved ", Sys.time()),
	TSdescription=desc,
	TSlabel=names,
	TSsource=con@dbname # could be better
	) 
    mat
    } 
    )


#setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSzipConnection"),
#   definition= function(x, serIDs=seriesNames(data), con, ...)   
#    "TSput for TSzip connection not supported." )

setMethod("TSdescription",   signature(x="character", con="TSzipConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdescription for TSzip connection not supported." )


setMethod("TSdoc",   signature(x="character", con="TSzipConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdoc for TSzip connection not supported." )

setMethod("TSlabel",   signature(x="character", con="TSzipConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSlabel for TSzip connection not supported." )

setMethod("TSsource",   signature(x="character", con="TSzipConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSsource for TSzip connection not supported." )
