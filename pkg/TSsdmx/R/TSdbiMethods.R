dbBackEnd <- function(...) {
  drv <- "sdmx"
  attr(drv, "package") <- "TSsdmx"
  new("sdmxDriver", Id = drv)
  }

# there is an SDMX primer at
# http://www.ecb.int/stats/services/sdmx/html/index.en.html

# NB firebug shows browser requests to server, so is useful for seeing what is
#  sent to the server

####### some kludges to make this look like DBI. ######
#for this require("DBI") 

setClass("sdmxDriver", contains=c("DBIDriver"), slots=c(Id = "character")) 

# this does nothing but prevent errors if it is called. 
setMethod("dbDisconnect", signature(conn="TSsdmxConnection"), 
     definition=function(conn,...) TRUE)

#######     end kludges   ######

setClass("TSsdmxConnection", contains=c("DBIConnection", "conType","TSdb"),
   slots=c(user="character", password="character", host="character") )

setMethod("TSconnect",   signature(q="sdmxConnection", dbname="missing"),
  definition= function(q, dbname, user="", password="", host="", ...){
   #  user / password / host  for future consideration
   dbname) <- q@dbname
   
   # there could be a better connection test mechanism below, especially
   #  since this breaks if the test series disappears
   if      (dbname == "ECB" ) 
      con <- try(TSgetECB('122.ICP.M.U2.N.000000.4.ANR',...),  silent=TRUE)
      # series '118.DD.A.I5.POPE.LEV.4D' disappeared
   else if (dbname == "FRB")
    con <- try(TSgetFRB('G19.79d3b610380314397facd01b59b37659',...),silent=TRUE)
   else if (dbname == "BoC")
      con <- try(TSgetBoC(c('CDOR', 'OIS'),...), silent=TRUE)
   else if (dbname == "OECD")
      con <- try(TSgetOECD('CPIAUCNS',...), silent=FALSE)
   else if (dbname == "BIS")
      con <- try(TSgetBIS('', ...), silent=FALSE)
   else if (dbname == "WB")
      con <- try(TSgetWB('', ...), silent=FALSE)
   else if (dbname == "UN")
      con <- try(TSgetUN('', ...), silent=FALSE)
   else if (dbname == "IMF")
      con <- try(TSgetIMF('', ...), silent=FALSE)
   else if (dbname == "EuroStat")
      con <- try(TSgetEuroStat('', ...), silent=FALSE)
   else stop(dbname,"not recognized. Please contact the package maintainer if you would like to help implement this database.")

   if(inherits(con, "try-error")) 
         stop("Could not establish TSsdmxConnection to ",  dbname)
   
   new("TSsdmxConnection", drv="sdmx", dbname=dbname, 
        hasVintages=FALSE, hasPanels=FALSE, 
	user=user, password=password, host=host ) 
   } )


setMethod("TSdates",
  signature(serIDs="character", con="TSsdmxConnection", vintage="ANY", panel="ANY"),
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

setMethod("TSget",     signature(serIDs="character", con="TSsdmxConnection"),
   definition=function(serIDs, con, TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=serIDs, quiet=TRUE, repeat.try=3, ...){ 
    if (is.null(TSrepresentation)) TSrepresentation <- "ts"
    desc <- "" # NEEDS WORK
    
    if     (con@dbname == "ECB") mat <- TSgetECB(serIDs, names=names)
    else if(con@dbname == "FRB") mat <- TSgetFRB(serIDs, names=names)
    else if(con@dbname == "BoC") mat <- TSgetBoC(serIDs, names=names)
    else if(con@dbname == "OECD") mat <- TSgetOECD(serIDs, names=names)
    else if(con@dbname == "BIS")  mat <- TSgetBIS(serIDs, names=names)
    else if(con@dbname == "WB")   mat <- TSgetWB(serIDs, names=names)
    else if(con@dbname == "UN")   mat <- TSgetUN(serIDs, names=names)
    else if(con@dbname == "IMF")  mat <- TSgetIMF(serIDs, names=names)
    else if(con@dbname == "EuroStat") mat <- TSgetEuroStat(serIDs, names=names)
    else stop("dbname", con@dbname, "not recognized.")

    if (NCOL(mat) != length(serIDs)) stop("Error retrieving series", serIDs) 
    mat <- tfwindow(mat, tf=tf, start=start, end=end)
  
    if (! TSrepresentation  %in% c( "ts", "default")){
      require("tframePlus")
      mat <- changeTSrepresentation(mat, TSrepresentation)
      }

    seriesNames(mat) <- names
    TSmeta(mat) <- new("TSmeta", serIDs=serIDs,  dbname=con@dbname, 
        hasVintages=con@hasVintages, hasPanels=con@hasPanels,
  	conType=class(con), DateStamp= Sys.time(), 
	TSdoc=paste(desc, " from ", con@dbname, "retrieved ", Sys.time()),
	TSdescription=paste(desc, " from ", con@dbname),
	TSlabel=desc, 
	TSsource=con@dbname # could be better
	) 
    mat
    } 
    )


#setMethod("TSput",     signature(x="ANY", serIDs="character", con="TSsdmxConnection"),
#   definition= function(x, serIDs=seriesNames(data), con, ...)   
#    "TSput for TSsdmx connection not supported." )

setMethod("TSdescription",   signature(x="character", con="TSsdmxConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdescription for TSsdmx connection not supported." )


setMethod("TSdoc",   signature(x="character", con="TSsdmxConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSdoc for TSsdmx connection not supported." )

setMethod("TSlabel",   signature(x="character", con="TSsdmxConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSlabel for TSsdmx connection not supported." )

setMethod("TSsource",   signature(x="character", con="TSsdmxConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        "TSsource for TSsdmx connection not supported." )

#######  database source specific methods (not exported)   ######
# It should be possible to a have a single SDMX parser deal with the
# result from the fetch, but that is not (yet) done. The parsing still
# needs too much specific information retrieved from each db.

# NB firebug shows browser requests to server, so is useful for seeing what is
#  sent to the server

TSgetOECD <- function(id, names=NULL){
  stop("Connect to this database is not yet working. 
  Please contact the package maintainer if you would like to help implement it.")
 FALSE
 }

TSgetBIS <- function(id, names=NULL){
  stop("Connect to this database is not yet working. 
  Please contact the package maintainer if you would like to help implement it.")
 FALSE
 }

TSgetUN <- function(id, names=NULL){
  stop("Connect to this database is not yet working. 
  Please contact the package maintainer if you would like to help implement it.")
 FALSE
 }

TSgetWB <- function(id, names=NULL){
  stop("Connect to this database is not yet working. 
  Please contact the package maintainer if you would like to help implement it.")
 FALSE
 }

TSgetIMF <- function(id, names=NULL){
  stop("Connect to this database is not yet working. 
  Please contact the package maintainer if you would like to help implement it.")
 FALSE
 }

TSgetEuroStat <- function(id, names=NULL){
  stop("Connect to this database is not yet working. 
  Please contact the package maintainer if you would like to help implement it.")
 FALSE
 }

TSgetBoC <- function(id, names=NULL){
    
   uri <- paste( "http://credit.bank-banque-canada.ca/webservices?service=getSeriesSDMX&args=",
   	    paste(id, "_-_-_", sep="", collapse=""),
   	    paste( "FIRST_-_-_Last",sep="", collapse=""), sep="")

   # should try to check <faultstring> 
   z <- getURLContent(uri)
   #NEED TO STRIP SOAP ENV
   #zz <- htmlParse(z)
   #zz <-   getNodeSet(htmlParse(z), "//series" )
   #zz <-   getNodeSet(zz, "//dataset" )
   #zz <-   getNodeSet(zz, "//CompactData" )
   #zz <-   getNodeSet(htmlParse(z, useInternalNodes = FALSE), "//return" )
   #zz <-   getNodeSet(htmlParse(z), "//return" )
   
   # should be able to parse for nmsp as in TSgetECB
   nmsp <-  c(ns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message") 
   #        getNodeSet(htmlParse(z), "//series", nmsp )
   # length(getNodeSet(htmlParse(z), "//series", nmsp ) )
   # mode(getNodeSet(htmlParse(z), "//series", nmsp ) )

   #doc <- xmlParse(z)
   doc <- htmlParse(z)
   
   # DataSetParse assumes Xpath points to  Series nodes in doc 
   #   so getNodeSet(doc, Xpath, nmsp ) is a list with series as elements
   #   so getNodeSet(doc, "//series[@freq]", nmsp ) is a list with series as elements
   #r <- DataSetParse(doc,"//ns:Series[@FREQ]" ,nmsp)
   #r <- DataSetParse(doc,"//series[@freq]" ,nmsp)
   r <- DataSetParse(doc,"//series[@freq]" ,nmsp,
    obs=".//obs[@time_period]", timeperiod="time_period", value="obs_value")
   
   if(nseries(r) != length(id)) warning("some series not retrieved.")

   if(!is.null(names)) seriesNames(r) <- names

   r
   }

TSgetECB <- function(id, names=NULL){
#  different versions just for testing
# #works with v3, seems to get only the header with v1
# v1
#   uri <- paste( "http://sdw.ecb.europa.eu/export.do?",
#   	    paste("SERIES_KEY=", id, "&", sep="", collapse=""),
#   	    paste( "BS_ITEM=&sfl5=3&sfl4=4&sfl3=4&sfl1=3&DATASET=0&FREQ=",
#     	    fr,"&node=2116082&exportType=sdmx", sep="", collapse=""), sep="")
#      
# v2
#   uri <- paste( "http://sdw.ecb.europa.eu/export.do?",
#   	    paste("SERIES_KEY=", id, "&", sep="", collapse=""),
#   	    paste( "sfl5=4&sfl4=4&sfl3=4&sfl2=4&sfl1=3&DATASET=0&FREQ=Q&node=2116082&exportType=sdmx",
#   	     sep="", collapse=""), sep="")
	    
# v3
   uri <- paste( "http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&",
	   paste("SERIES_KEY=", id, "&", sep="", collapse=""),
	   paste( "type=sdmx", sep="", collapse=""), sep="")

   #BTW, rather than all the work with basicTextGatherer(), I would use
   #z = xmlParse(getURLContent(uri))
   #And ideally, use getForm(), i.e.
   # getForm("http://sdw.ecb.europa.eu/export.do",
   #	  SERIES_KEY = "117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
   #	  SERIES_KEY = "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E",
   #	  BS_ITEM = "", sfl5 = "3", sfl4 = "4", sfl3 = "4", sfl1 = "3",
   #DATASET = "0",
   #	  FREQ = "Q", node = "2116082", exportType = "sdmx")

   #h <- basicTextGatherer()

   #h$reset()
   #curlPerform(url=uri, writefunction = h$update, verbose = FALSE)
   #See  getNodeSet examples
   #z <- xmlTreeParse(h$value(),  useInternalNodes = TRUE)  #FALSE)
   #r <- SDMXparse(z)
   # SDMXparse <- function(z){  
   #   doc <- xmlParse(z)
   #   #doc <- xmlParse(z,asText=TRUE)
   #
   #   #eg. nmsp <- c(ns="http://www.ecb.int/vocabulary/stats/bsi") 
   #   nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["DataSet"]][[2]]))
   #   DataSetParse(doc,"//ns:Series[@FREQ]" ,nmsp)
   #   }
   #  r <- SDMXparse(getURLContent(uri))
   
   doc <- xmlParse(getURLContent(uri))
   #nmsp <-  c(ns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message") 
   nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["DataSet"]][[2]]))

   r <- DataSetParse(doc,"//ns:Series[@FREQ]" ,nmsp)

   # should try to check <faultstring> 

   #f <- gsub("[.]+[0-9,A-Z]*","",sub("[A-Z]*.","",sub("[0-9]*.","",id) ))
   #fr <- f[1]
   if(nseries(r) != length(id)) warning("some series not retrieved.")
   
   if(!is.null(names)) seriesNames(r) <- names
   r
   }

TSgetFRB <- function(id, names=NULL){
   #id should be the release and the key separated by "."
   # eg G19.79d3b610380314397facd01b59b37659

#Consumer credit from all sources (I think)
#https://www.federalreserve.gov/datadownload/Output.aspx?rel=G19&series=79d3b610380314397facd01b59b37659&lastObs=&from=01/01/1943&to=12/31/2010&filetype=sdmx&label=include&layout=seriescolumn


   key <- sub("[0-9,A-Z,a-z]*.","",id)
   rel <- sub("[.]+[0-9,A-Z,a-z]*","",id)
   uri <- paste( 
       paste("https://www.federalreserve.gov/datadownload/Output.aspx?rel=",
                       rel, "&", sep="", collapse=""),
       paste("series=",key, "&", sep="", collapse=""),
       paste( "lastObs=&from=01/01/1981&to=12/31/2010&filetype=sdmx&label=include&layout=seriescolumn", sep="", collapse=""), sep="")
  
   # should try to check <faultstring> 

   #getURLContent should work, but gets octet=stream from frb
   #doc <- xmlParse(getURLContent(uri))
    h <- basicTextGatherer()
   h$reset()
   curlPerform(url=uri, writefunction = h$update, verbose = FALSE)
   z <- h$value()
   
   doc <- xmlParse(z)
   #nmsp <-  c(ns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message") 
   #nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["DataSet"]][[2]]))
   #nmsp <- c(ns=xmlNamespace(xmlRoot(doc))
   #xmlNamespace(doc)
   #xmlNamespace(xmlRoot(doc))
   #xmlNamespace(xmlRoot(doc)[["DataSet"]])
#  <frb:DataSet xmlns:kf="http://www.federalreserve.gov/structure/compact/H3_H3" #id="H3" #xsi:schemaLocation="http://www.federalreserve.gov/structure/compact/H3_H3 #H3_H3.xsd">
   #xmlNamespace((xmlRoot(doc)[["Series"]]))
   #nmspfrb <- xmlNamespace((xmlRoot(doc)[["DataSet"]])) # gets .compact/common
   #xmlNamespaceDefinitions(doc, simplify = TRUE)
   #xmlNamespaceDefinitions(doc, simplify = FALSE)
   #xmlNamespaceDefinitions(doc, recursive = TRUE)
   #nmspfrb<-xmlNamespaceDefinitions(xmlRoot(doc)[["DataSet"]],recursive= TRUE)

   nmspfrb <- xmlNamespaceDefinitions(doc, recursive = TRUE, simplify = TRUE)



   #nmspfrb <-c(kf="http://www.federalreserve.gov/structure/compact/G19_CCOUT",
   #            frb="http://www.federalreserve.gov/structure/compact/common") 
   #nmspfrb <- c(kf="http://www.federalreserve.gov/structure/compact/H3_H3",
   #            frb="http://www.federalreserve.gov/structure/compact/common") 

   r <- DataSetParse(doc,"//kf:Series[@FREQ]" ,nmspfrb,
    obs="frb:Obs[@TIME_PERIOD]", timeperiod="TIME_PERIOD", value="OBS_VALUE")

   if(nseries(r) != length(id)) warning("some series not retrieved.")
   
   if(!is.null(names)) seriesNames(r) <- names
   r
   }

#  z <- TSsdmx:::TSgetFRB("G19.79d3b610380314397facd01b59b37659")
#  z <- TSsdmx:::TSgetFRB("H3.a0e6e4ca4fd8cd3d7227e549939ec0ff")


DataSetParse <- function(doc, Xpath, nmsp, 
    obs=".//ns:Obs[@TIME_PERIOD]", timeperiod="TIME_PERIOD", value="OBS_VALUE"){
   #obs, timeperiod,  value are kludge
   # assumes Xpath points to  Series nodes in doc 
   #   so getNodeSet(doc, Xpath, nmsp ) is a list with series as elements
   # It might be better? is this this pointed to DataSet?
   # It might be possible to extract nmsp?
   
   meta <- function(node){# local function
      c(FREQ=		xmlGetAttr(node, "FREQ",	    nmsp),
        freq=		xmlGetAttr(node, "freq",	    nmsp),  #kludge
   	REF_AREA=	xmlGetAttr(node, "REF_AREA",	    nmsp),
   	ADJUSTMENT=	xmlGetAttr(node, "ADJUSTMENT",      nmsp),
   	BS_REP_SECTOR=  xmlGetAttr(node, "BS_REP_SECTOR",   nmsp),
   	BS_ITEM=	xmlGetAttr(node, "BS_ITEM",	    nmsp),
   	MATURITY_ORIG=  xmlGetAttr(node, "MATURITY_ORIG",   nmsp),
   	DATA_TYPE=	xmlGetAttr(node, "DATA_TYPE",	    nmsp),
   	COUNT_AREA=	xmlGetAttr(node, "COUNT_AREA",      nmsp),
   	BS_COUNT_SECTOR=xmlGetAttr(node, "BS_COUNT_SECTOR", nmsp),
   	CURRENCY_TRANS= xmlGetAttr(node, "CURRENCY_TRANS",  nmsp),
   	BS_SUFFIX=	xmlGetAttr(node, "BS_SUFFIX",       nmsp),
   	TIME_FORMAT=	xmlGetAttr(node, "TIME_FORMAT",     nmsp),
   	COLLECTION=	xmlGetAttr(node, "COLLECTION",      nmsp))
       }

   # separate the series
   zs <-   getNodeSet(doc, Xpath, nmsp )

   m <- r <- NULL
   for (i in seqN(length(zs))) { 
      mt <- meta(zs[[i]])
      m <- c(m, paste(mt, collapse="."))
      #fr <- mt["FREQ"]
      fr <- mt[c("FREQ", "freq")] #kludge
      fr <- fr[!is.na(fr)] #kludge

      # getNodeSet(zs[[i]], "//ns:Obs[@TIME_PERIOD]",nmsp )
      # gets Obs from all series. The XPath needs
      # to tell getNodeSet() to look from that node downwards, not
      # the original document. So you need a .//
      
      #zz <-   getNodeSet(zs[[i]], ".//ns:Obs[@TIME_PERIOD]",nmsp )  
      #zz <-   getNodeSet(zs[[i]], ".//obs[@time_period]",nmsp )  
      zz <-   getNodeSet(zs[[i]], obs,nmsp )        
# first  works for ecb but fails for boc which has lines 
#   <obs obs_status="A" obs_value="1.78" time_period="2010-12-09"/>
# </series> 

      dt <- sapply(zz, xmlGetAttr, timeperiod)
      # obs are usually in sequential order, but not certain, so
      ix <- order(dt)
      dt <- dt[ix]

      # In some formats Q dates are first month of Q, eg Q4 is 2010-10
      # but usually? 2010-Q4

      r1 <- as.numeric( sapply(zz, xmlGetAttr, value) )[ix]
      if (fr == "Q"){ 
        y <- as.numeric(sub("-Q[0-9]","",dt[1]))
	q <- as.numeric(sub("[0-9]*-Q","",dt[1]))
        r2 <- ts(r1, start=c(y,q), frequency=4)
	} 
      else if (fr == "M"){ 
        dt <- strptime(paste(dt,"-01",sep=""), format="%Y-%m-%d")
        r2 <- ts(r1, start=cbind(1900+dt[1]$year, dt$mon[1]), frequency=12) 
	} 
      else if (fr == "A"){ 
        y <- as.numeric(dt[1])
        r2 <- ts(r1, start=cbind(y, 1), frequency=1) 
	} 
      else if (fr == "W"){ 
        require("zoo")
        wk <- as.numeric(sub("....W", "", dt))
	y  <- as.numeric(sub("W..", "", dt))
        lastwk <- as.numeric(format(as.Date(sprintf("%s-12-31", y)), "%V"))#%V, %W, %U ?
	ix <- y + (wk - 1)/ lastwk
	r2 <- zoo(r1, order.by = ix)  
	} 
      else{ 
        require("zoo")
	r2 <- zoo(r1, order.by=as.Date(dt)) 
	} 
      r <- tbind(r, r2)
      }
   if(is.null(r))
     stop("No series retrieved. Series do not exist on the database, or some other problem.")
   seriesNames(r) <- m
   r
   }

TSgetURI <- function(query){
   # function primarily for debugging queries

   fr <- 1 # skip trying to set fr properly (for debugging)

   #getURLContent should work, but gets octet=stream from frb
   #z <- getURLContent(query)
   
   h <- basicTextGatherer()
   h$reset()
   curlPerform(url=query, writefunction = h$update, verbose = FALSE)
   z <- h$value()

   #doc <- xmlTreeParse(z,  useInternalNodes = TRUE)
   #htmlTreeParse(z) # gives nicer printout
   doc <- xmlParse(z)
   nmsp <-  c(ns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message") 
   #nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["DataSet"]][[2]]))


   # separate the series
   # zs <-   getNodeSet(doc, Xpath, nmsp )

   # DataSetParse assumes Xpath points to  Series nodes in doc 
   #   so getNodeSet(doc, Xpath, nmsp ) is a list with series as elements
   #   so getNodeSet(doc, "//series[@freq]", nmsp ) is a list with series as elements
   #   so zs <-  getNodeSet(doc, Xpath, nmsp )
   #   so zs <-  getNodeSet(doc, "//kf:Series[@FREQ]", nmspfrb )
   
   #zz <-   getNodeSet(zs[[i]], ".//ns:Obs[@TIME_PERIOD]",nmsp )  
   #r <- DataSetParse(doc,"//ns:Series[@FREQ]" ,nmsp)
   #r <- DataSetParse(doc,"//series[@freq]" ,nmsp,
   # obs=".//obs[@time_period]", timeperiod="time_period", value="obs_value")
   
   # </frb:DataSet>
   nmspfrb <- c(kf="http://www.federalreserve.gov/structure/compact/G19_CCOUT",
               frb="http://www.federalreserve.gov/structure/compact/common") 
   # r <- TSsdmx:::DataSetParse(doc,"//kf:Series[@FREQ]" ,nmspfrb,
   #  obs="frb:Obs[@TIME_PERIOD]", timeperiod="TIME_PERIOD", value="OBS_VALUE")

   
   # if(nseries(r) != length(id)) warning("some series not retrieved.")

   # if(!is.null(names)) seriesNames(r) <- names

   # r
   doc
   }

# debug(TSgetURI)
