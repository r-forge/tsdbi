# TSgetURI is mainly for debugging other TSget functions

require("RCurl")
require("XML")

#this gets the data but the zs parse fails
#z <- TSgetURI(query=
#"http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&SERIES_KEY=122.ICP.M.U2.N.000000.4.ANR&type=sdmx")

#we can tell the namespace in effect for the first Series node:
#  xmlNamespace(xmlRoot(z1)[["DataSet"]][[2]])

#vs

#this seems to get only the header
#z <- TSgetURI(query=
#"http://sdw.ecb.europa.eu/export.do?SERIES_KEY=122.ICP.M.U2.N.000000.4.ANR&BS_ITEM=&sfl5=3&sfl4=4&sfl3=4&sfl1=3&DATASET=0&FREQ=M&node=2116082&exportType=sdmx")


# this  works
#z <- TSgetURI(query=
#"http://sdw.ecb.europa.eu/export.do?SERIES_KEY=117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E&sfl5=4&sfl4=4&sfl3=4&sfl2=4&sfl1=3&DATASET=0&FREQ=Q&node=2116082&exportType=sdmx")

# and this monthly version works too (but not right dates from R)
#z <- TSgetURI(query=
#"http://sdw.ecb.europa.eu/export.do?SERIES_KEY=117.BSI.M.U2.Y.U.A21.A.4.U2.2250.Z01.E&REF_AREA=308&sfl5=3&sfl4=4&sfl3=4&sfl2=4&sfl1=3&DATASET=0&FREQ=M&BS_SUFFIX=E&node=2116082&exportType=sdmx")


#  this worked but then series disappeared
TSsdmx:::TSgetURI("http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&SERIES_KEY=118.DD.A.I5.POPE.LEV.4D&type=sdmx") #as v3

z <- TSsdmx:::TSgetURI(query="http://credit.bank-banque-canada.ca/webservices?service=getSeriesSDMX&args=CDOR_-_-_OIS_-_-_SWAPPEDTOFLOAT_-_-_FIRST_-_-_Last")


#Consumer credit from all sources (I think)
z <- TSsdmx:::TSgetURI(query=
"https://www.federalreserve.gov/datadownload/Output.aspx?rel=G19&series=79d3b610380314397facd01b59b37659&lastObs=&from=01/01/1981&to=12/31/2010&filetype=sdmx&label=include&layout=seriescolumn")

