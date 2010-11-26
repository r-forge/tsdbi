  
#######  try ECB sdmx  #######

# require("SSOAP") #asdcl2
require("RCurl") #asdcl2
require("XML")

#wget 
csv <- "http://sdw.ecb.europa.eu/export.do?SERIES_KEY=117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E&SERIES_KEY=117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E&SERIES_KEY=117.BSI.Q.U2.N.A.A23.A.1.U2.2250.Z01.E&BS_ITEM=&sfl5=3&sfl4=4&sfl3=4&sfl1=3&DATASET=0&FREQ=Q&node=2116082&exportType=csv"
#sdmx
sdmx <- "http://sdw.ecb.europa.eu/export.do?SERIES_KEY=117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E&SERIES_KEY=117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E&SERIES_KEY=117.BSI.Q.U2.N.A.A23.A.1.U2.2250.Z01.E&BS_ITEM=&sfl5=3&sfl4=4&sfl3=4&sfl1=3&DATASET=0&FREQ=Q&node=2116082&exportType=sdmx"

 f = system.file("exampleData", "mtcars.xml", package="XML")
     # Same as xmlParse()
z <- xmlParseDoc(f)

 doc = xmlTreeParse(f, useInternalNodes = TRUE)
 getNodeSet(doc, "//variables[@count]")
 getNodeSet(doc, "//record")

 getNodeSet(doc, "//record[@id='Mazda RX4']")

 # free(doc)

See  getNodeSet examples  !!!!

h = basicTextGatherer()

h$reset()
curlPerform(url=soecd,
       httpheader=c(Accept="text/xml", Accept="multipart/*",        
       SOAPAction='http://stats.oecd.org/OECDStatWS/SDMX/GetGenericData',
       'Content-Type' = "text/xml; charset=utf-8"),
       postfields=body,
       writefunction = h$update,
       verbose = TRUE
       )
curlPerform(url=sdmx, writefunction = h$update, verbose = TRUE)
     
z <- xmlParse(h$value(), asText=TRUE, trim=TRUE)
z <- xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)
z <- xmlParseString(h$value())
z <- xmlParseDoc(h$value())
z <- xml(h$value())
# str(z)
names(z)
names(z$doc)
str(z$doc)
z$doc$children

names(z$doc$children$MessageGroup)
str(z$doc$children$MessageGroup)

nchar(h$value())
write(h$value(), file="zot.txt")
htmlTreeParse(h$value(), asText=TRUE, trim=TRUE)
     
# should try to get <faultstring> out of $children in case of bad query
names(htmlTreeParse(h$value(), asText=TRUE, trim=TRUE))
htmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$children

cat("************** TSsdmx  Examples ******************************\n")
require("TSsdmx")

con <- TSconnect("sdmx", dbname="OECD") 

oecd <- SOAPServer("stats.oecd.org", "OECDSTATWS_SDMXNEW/QueryPage.aspx")

z <- .SOAP(oecd, ""),
	 handlers =NULL)


#monthly
x <- TSget("whatever", con) 
plot(x)
tfplot(x)

TSdescription(x) 

options(TSconnection=con)

#quarterly
x2 <- TSget("whatever")
tfplot(x2)
plot(x2)
TSdescription(x2) 

x <- TSget(c("CPIAUCNS","M2"), con)
plot(x)
tfplot(x)
TSdescription(x) 

x <- TSget(c("TOTALSL","TOTALNS"), con, 
       names=c("Total Consumer Credit Outstanding SA",
               "Total Consumer Credit Outstanding NSA"))
plot(x)
tfplot(x)
TSdescription(x) 

Q dates on these are month-day, and frequency is wrong

x <- TSget(c("TDSP","FODSP"), con, 
       names=c("Household Debt Service Payments as a Percent of Disposable Personal Income",
               "Household Financial Obligations as a percent of Disposable Personal Income"))
tfplot(x)
TSdescription(x) 

x <- TSget("ibm", quote = c("Close", "Vol"))
plot(x)
tfplot(x)
if(!all(TSrefperiod(x) == c("Close", "Vol"))) stop("TSrefperiod error, test 4.")
TSdescription(x) 

tfplot(x, xlab = TSdescription(x))
tfplot(x, Title="IBM", start="2007-01-01")

conO <- TSconnect("sdmx", dbname="yahoo") 

