
cat("************** ECB sdmx   ******************************\n")
require("TSsdmx")
#require("RCurl") 
#require("XML")
#require("tframe")

con <- TSconnect("sdmx", dbname="BOC") 


########## to clean out below

# there is an SDMX primer at
# http://www.ecb.int/stats/services/sdmx/html/index.en.html


# identifiers can be extraced at 

# NB firebug shows browser requests to server, so is useful for seeing what is
#  sent to the server

these retrieve the data but has the wrong ns or <DataSet> parse problem
z <- TSgetURI(query="http://credit.bank-banque-canada.ca/webservices?service=getSeriesSDMX&args=CDOR_-_-_OIS_-_-_SWAPPEDTOFLOAT_-_-_FIRST_-_-_Last")

z <- TSgetURI(query="http://credit.bank-banque-canada.ca/webservices?service=getSeriesSDMX&args=CDOR_-_-_FIRST_-_-_Last")

Browse[1]> h$value()
[1] "<?xml version=\"1.0\" ?><S:Envelope xmlns:S=\"http://schemas.xmlsoap.org/soap/envelope/\"><S:Body><ns2:getSeriesSDMXResponse xmlns:ns2=\"http://www.bank-banque-canada.ca/services\"><return xmlns=\"\"><CompactData xmlns=\"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message\" xmlns:cds=\"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact\" xmlns:common=\"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common\" xmlns:compact=\"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact\" xmlns:message=\"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message http://bocdev/sdmx/SDMXMessage.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact http://bocdev/sdmx/SDMXCompactData.xsd\"><Header><Id>BOC CDOR OIS SWAPPEDTOFLOAT 2010-12-05T10:34:40</Id><Test>true</Test><Name xml:lang=\"en\">Bank of Canada</Name><Prepared>2010-12-05T10:34:40</Prepared><Sender id=\"boc\"><Name xml:lang=\"en\">Bank of Canada</Name><Contact><Department xml:lang=\"en\">Web Communications</Department><Uri>web@bankofcanada.ca</Uri></Contact></Sender><ReportingBegin>FIRST</ReportingBegin><ReportingEnd>Last</ReportingEnd></Header><DataSet>

TSdescription(z) 


#monthly ?

TSdescription(x) 

options(TSconnection=con)


x <- TSget(c("TOTALSL","TOTALNS"), con, 
       names=c("Total Consumer Credit Outstanding SA",
               "Total Consumer Credit Outstanding NSA"))
plot(x)
tfplot(x)
TSdescription(x) 

