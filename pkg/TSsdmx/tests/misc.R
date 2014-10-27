require("TSsdmx")

From: Duncan Temple Lang <duncan@wald.ucdavis.edu>
To: r-help@r-project.org
Subject: Re: [R] Custom XML Readers
In addition to the general tools of the XML package,
I also had code that read documents with a similar structure
to the ones Andy illustrated. I put them and simple examples
of using them at the bottom of
   http://www.omegahat.org/RSXML/
page.
  D.


test  to ask Duncan

require("RCurl")
require("XML")

uri <- "http://sdw.ecb.europa.eu/export.do?SERIES_KEY=117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E&sfl5=4&sfl4=4&sfl3=4&sfl2=4&sfl1=3&DATASET=0&FREQ=Q&node=2116082&exportType=sdmx"
   z <- getURLContent(uri)
   doc <- xmlParse(z)
   nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["DataSet"]][[2]]))
   zs <-   getNodeSet(doc, "//ns:Series[@FREQ]", nmsp )
   length(zs)
[1] 1

and everthing is as I need it.

However, if I go to another source which returns the same structure in a SOAP wrapper

uri <- "http://credit.bank-banque-canada.ca/webservices?service=getSeriesSDMX&args=CDOR_-_-_FIRST_-_-_Last"

   z <- getURLContent(uri)
   doc <- xmlParse(z)
   nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["DataSet"]][[2]]))

gives

Error in UseMethod("xmlNamespace") : 
  no applicable method for 'xmlNamespace' applied to an object of class "NULL"

Possibly I just need some different instruction to get the namspace and then parse, but I think the soap envelope needs to be stripped so I have tried

   zz <- htmlParse(z)

and all of the following, which appear to extract from the SOAP envelope
   zzz <-   getNodeSet(zz, "//body" )
   zzz <-   getNodeSet(zz, "//getseriessdmxresponse" )
   zzz <-   getNodeSet(zz, "//return" )
   zzz <-   getNodeSet(zz, "//dataset" )
   zzz <-   getNodeSet(zz, "//CompactData" )
   zzz <- SSOAP:::parseSOAP(z, reduce = FALSE,  fullNamespaceInfo = TRUE)

but
   doc <- xmlParse(zzz)
gives
Error in file.exists(file) : invalid 'file' argument

or other errors.
 
#FRB

uri <- "https://www.federalreserve.gov/datadownload/Output.aspx?rel=G19&series=79d3b610380314397facd01b59b37659&lastObs=&from=01/01/1943&to=12/31/2010&filetype=sdmx&label=include&layout=seriescolumn"

   z <- getURLContent(uri)
   doc <- xmlParse(z)
   doc <- htmlParse(z)
   # these seem to give an octet-stream, but basicTextGatherer works?
   
   h <- basicTextGatherer()
   h$reset()
   curlPerform(url=uri, writefunction = h$update, verbose = FALSE)

   z <- xmlTreeParse(h$value(),  useInternalNodes = TRUE)
   # looks good to here, more-or-less
   nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["DataSet"]][[2]]))
   nmsp <- c(ns=xmlNamespace(xmlRoot(doc)[["frb:DataSet"]][[2]]))

but can't get the namespace
