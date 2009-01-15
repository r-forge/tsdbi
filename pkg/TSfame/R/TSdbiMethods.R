#.onLoad <- function(library, section) {
#   ok <- require("methods")
#   ok <- ok & require("DBI")
#   ok <- ok & require("TSdbi")
#   ok <- ok & require("fame")
#   ok <- ok & require("zoo")
#   invisible(ok)
#   }

setClass("fameDriver", representation("DBIDriver", Id = "character")) 

fame <- function() {
  drv <- "fame"
  attr(drv, "package") <- "TSfame"
  new("fameDriver", Id = drv)
  }

# require("DBI") for this
setClass("TSfameConnection", contains=c("DBIConnection", "TSdb"))
   #user / password / host  for future consideration
   # different for read or write accessMode = "character"
   
####### some kludges to make this look like DBI. ######
# these do nothing, but prevents error messages

setMethod("dbDisconnect", signature(conn="TSfameConnection"), 
   definition=function(conn,...) invisible(TRUE))

setMethod("dbUnloadDriver", signature(drv="fameDriver"),
   definition=function(drv, ...) invisible(TRUE))
#######     end kludges   ######

setMethod("TSconnect",   signature(drv="fameDriver", dbname="character"),
  definition= function(drv, dbname, 
              accessMode = if(file.exists(dbname)) "shared" else "create", ...){
   #It might be possible to leave the Fame db open, but getfame needs it closed.
   if (is.null(dbname)) stop("dbname must be specified")
   #ensure the db name ends in .db, otherwise fame adds this and then con fails
   db <- sub('$', '.db',sub('.db$', '', dbname))
   if(!fameRunning()) fameStart(workingDB = FALSE)
   Id <- try(fameDbOpen(dbname, accessMode = accessMode))
   if(inherits(Id, "try-error") ) stop("Could not establish TSfameConnection to ", dbname)
   fameDbClose(Id) # this Id is not saved
   new("TSfameConnection", 
          dbname=dbname, hasVintages=FALSE, hasPanels=FALSE) 
   } )


setMethod("TSdates",  signature(serIDs="character", con="TSfameConnection"),
   definition= function(serIDs, con, ... )  
{  # Indicate  dates for which data is available.
   # This requires retrieving series individually so they are not truncated.
   r <- av <- st <- en <- tb <- NULL
   for (i in 1:length(serIDs))
     {r <- try(TSget( serIDs[i], con=con)) 
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


setMethod("TSget",     signature(serIDs="character", con="TSfameConnection"),
   definition= function(serIDs, con, TSrepresentation=getOption("TSrepresentation"),
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=serIDs, TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, ...)
{ # ... arguments unused
  if (is.null(TSrepresentation)) TSrepresentation <- "default"
  mat <- desc <- doc <- label <-  rp <- NULL
  for (i in seq(length(serIDs))) {
    r <- getfame(serIDs[i], con@dbname, save = FALSE, envir = parent.frame(),
             start = NULL, end = NULL, getDoc = FALSE)
    # r is class tis
#    r <-  if((TSrepresentation=="default" | TSrepresentation=="ts")
#             && frequency(r) %in% c(1,4,12,2)) as.ts(r[[1]]) else as.zoo(r[[1]])

    if(TSrepresentation=="tis") r <- r[[1]]
    else if((TSrepresentation=="default" | TSrepresentation=="ts")
             && tif(r[[1]]) %in% c(1044,1027,1032,1050)) r <-  as.ts(r[[1]]) 
    else {
       rp <- c(rp, tifName(r[[1]]))
       r <- zoo(c(r[[1]]), order.by=as.Date(ti(r[[1]])), frequency=frequency(r[[1]]))
       }
    mat <- tbind(mat, r)
    if(TSdescription) desc <- c(desc, TSdescription(serIDs[i],con) ) 
    if(TSdoc)         doc  <- c(doc,  TSdoc(serIDs[i],con) ) 
    if(TSlabel)       label<- c(label,as(NA, "character")) #TSlabel(serIDs[i],con) ) 
    }

  if(TSlabel) warning("TSlabel not supported in Fame.") 
  if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 

  mat <- tfwindow(mat, tf=tf, start=start, end=end)

  if( (!is.null(rp)) && !all(is.na(rp)) ) TSrefperiod(mat) <- rp      

  if (! TSrepresentation  %in% c( "zoo", "default", "tis"))
      mat <- do.call(TSrepresentation, list(mat))   
  seriesNames(mat) <- if(!is.null(names)) names else serIDs 

  TSmeta(mat) <- new("TSmeta", serIDs=serIDs, dbname=con@dbname, 
      hasVintages=con@hasVintages, hasPanels=con@hasPanels,
      conType=class(con), DateStamp=Sys.time(), 
      TSdescription=if(TSdescription) paste(desc, " from ", con@dbname, 
            "retrieved ", Sys.time()) else as(NA, "character"), 
      TSdoc=if(TSdoc) doc else as(NA, "character"),
      TSlabel=if(TSlabel) label else as(NA, "character"))
  mat
} )


setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSfameConnection"),
   definition= function(x, serIDs=seriesNames(x), con,   
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=NULL, 
       warn=TRUE, ...) 
 {
  if (!is.null(TSlabel.)) warning("TSlabel is not supported in Fame.")
  ids <-  serIDs 
  x <- as.matrix(as.tis(x)) # clobbers seriesNames(x)
  #ids <- gsub(" ", "", serIDs ) # remove spaces in id
  #if(! all( ids == serIDs)) warning("spaces removed from series names.")
  #rP <- TSrefperiod(x)
  #N <- periods(x)
  ok <- TRUE
  for (i in ids)  ok <- ok & !TSexists(i, con=con)

  if (warn & !ok) warning("error series already exist on database.")
  
  if (ok) {
    Id <- fameDbOpen(con@dbname, accessMode = "update")
    on.exit(fameDbClose(Id))
    if (ok) for (i in seq(length(ids))) {
      v <- x[,i]
      documentation(v) <- TSdoc.[i]
      description(v) <- TSdescription.[i]
      #putfame does not write doc and des. fameWriteSeries needs open and close
      ok <- ok & 0==fameWriteSeries(Id, ids[i], v,
  		       update=FALSE, checkBasisAndObserved=FALSE)
      }
  }
  
  if (warn & !ok) warning("error putting data on database.")
  new("logicalId",  ok, 
       TSid=new("TSid", serIDs=serIDs, dbname=con@dbname, 
         conType=class(con), hasVintages=con@hasVintages, hasPanels=con@hasPanels,
	 DateStamp=Sys.time()))
  } )



setMethod("TSdescription",   signature(x="character", con="TSfameConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
     fameWhats(con@dbname, x, getDoc = TRUE)$des )

setMethod("TSdoc",   signature(x="character", con="TSfameConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
     fameWhats(con@dbname, x, getDoc = TRUE)$doc )

#TSlabel gets used for new("Meta", so issuing a warning is not a good idea here.
setMethod("TSlabel",   signature(x="character", con="TSfameConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
     as(NA, "character") )

setMethod("TSdelete", signature(serIDs="character", con="TSfameConnection"),
 definition= function(serIDs, con=getOption("TSconnection"), ...){
    ok <- TRUE
    for (i in seq(length(serIDs))) 
      ok <- ok & 0 == fameDeleteObject(con@dbname, serIDs[i]) 
    new("logicalId",  ok, 
         TSid=new("TSid", serIDs=serIDs, dbname=con@dbname, 
           conType=class(con), hasVintages=con@hasVintages, hasPanels=con@hasPanels,
	   DateStamp=Sys.time()))
   })


setMethod("TSexists", signature(serIDs="character", con="TSfameConnection"),
 definition= function(serIDs, con=getOption("TSconnection"), ...){
   op <- options(warn=-1)
   on.exit(options(op))
   ok <- fameWhats(con@dbname, serIDs, getDoc = FALSE)
   new("logicalId",  !is.null(ok), 
       TSid=new("TSid", serIDs=serIDs, dbname=con@dbname, 
         conType=class(con), hasVintages=con@hasVintages, hasPanels=con@hasPanels,
	 DateStamp=NA))
   })
