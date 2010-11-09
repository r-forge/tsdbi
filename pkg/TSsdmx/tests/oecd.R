I found this wiki about SDMX that has some examples that might help. It looks 
like this is a query format for ISTAT SDMX.
  http://sdmx.wikispaces.com/Example4 

I also found this: 
 http://stats.oecd.org/OECDSTATWS_SDMXNEW/QueryPage.aspx?Type=MDDimensionMember 
It looks like you can plug in the SDMX export query here.

So yes, there is some sort of SOAP web service through which you feed this query. Perhaps there are clues to using it here, but you need a login: http://stats.oecd.org/SDMXWS/sdmx.asmx


Yes, it's using SOAP. There's a link on this page -- 
 http://stats.oecd.org/SDMXWS/sdmx.asmx
to the "service description", which leads to the WSDL file that describes the 
web service: http://stats.oecd.org/SDMXWS/sdmx.asmx?WSDL

 
You might find it helpful to feed that WSDL (Web Service Definition Language) 
file into this "online SOAP client"  service - it's very useful and instructive:
   http://www.soapclient.com/soaptest.html
 

http://stats.oecd.org/SDMXWS/sdmx.asmx
or test at
http://stats.oecd.org/OECDSTATWS_SDMXNEW/QueryPage.aspx?Type=DataGeneric

XML (Soap?) request for M1 and M3 to oecd (non-public db).

require("SSOAP") #asdcl2
require("RCurl") #asdcl2
require("XML")

s1 <- SOAPServer("services.soaplite.com", "interop.cgi")
z <- .SOAP(s1, "echoString", "From R", action="urn:soapinterop", 
           xmlns=c(namesp1="http://soapinterop.org/"), handlers =NULL)

Following works on the tests site
   http://stats.oecd.org/OECDSTATWS_SDMXNEW/QueryPage.aspx?Type=DataGeneric
(validates with error but gets data - but not DEMOPOP_0).

<message:QueryMessage 
  xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" 
  xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
  xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query http://www.sdmx.org/docs/2_0/SDMXQuery.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message http://www.sdmx.org/docs/2_0/SDMXMessage.xsd" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Header xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message">
		<ID>none</ID>
		<Test>false</Test>
		<Truncated>false</Truncated>
		<Prepared>2010-10-20T21:05:04</Prepared>
		<Sender id="YourID">
			<Name xml:lang="en">Your English Name</Name>
		</Sender>
		<Receiver id="OECD">
			<Name xml:lang="en">Organisation for Economic Co-operation and Development</Name>
			<Name xml:lang="fr">Organisation de coopération et de développement économiques</Name>
		</Receiver>
		<!--
    <message:DataSetAction>Replace</message:DataSetAction>
    <message:ReportingBegin>2007-02-22T00:00:00</message:ReportingBegin>
    -->
	</Header>
	<Query xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message">
		<DataWhere xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query">
			<And>
				<DataSet>REFSERIES</DataSet>
				<Dimension id="LOCATION">AUS</Dimension>
				<Attribute id="TIME_FORMAT">P1Y</Attribute>
				<Time>
					<StartTime>1960</StartTime>
					<EndTime>2010</EndTime>
				</Time>
				<Or>
					<Dimension id="SUBJECT">DEMOPOP_0</Dimension>
					<Dimension id="SUBJECT">IPI</Dimension>
					<Dimension id="SUBJECT">IMPGOOD</Dimension>
				</Or>
			</And>
		</DataWhere>
	</Query>
</message:QueryMessage>


Note that with     <!--Dimension id="LOCATION">AUS</Dimension-->
all countries  are returned.
<message:QueryMessage xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query http://www.sdmx.org/docs/2_0/SDMXQuery.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message http://www.sdmx.org/docs/2_0/SDMXMessage.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Header xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message">
		<ID>none</ID>
		<Test>false</Test>
		<Truncated>false</Truncated>
		<Prepared>2010-10-20T21:05:04</Prepared>
		<Sender id="YourID">
			<Name xml:lang="en">Your English Name</Name>
		</Sender>
		<Receiver id="OECD">
			<Name xml:lang="en">Organisation for Economic Co-operation and Development</Name>
			<Name xml:lang="fr">Organisation de coopération et de développement économiques</Name>
		</Receiver>
		<!--
    <message:DataSetAction>Replace</message:DataSetAction>
    <message:ReportingBegin>2007-02-22T00:00:00</message:ReportingBegin>
    -->
	</Header>
	<Query xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message">
		<DataWhere xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query">
			<And>
				<DataSet>REFSERIES</DataSet>
				<Dimension id="LOCATION">AUS</Dimension>
				<Attribute id="TIME_FORMAT">P1Y</Attribute>
				<Time>
					<StartTime>1960</StartTime>
					<EndTime>2010</EndTime>
				</Time>
				<Or>
					<Dimension id="SUBJECT">DEMOPOP_0</Dimension>
					<Dimension id="SUBJECT">IPI</Dimension>
					<Dimension id="SUBJECT">IMPGOOD</Dimension>
				</Or>
			</And>
		</DataWhere>
	</Query>
</message:QueryMessage>

see also http://www.omegahat.org/SSOAP/examples/keggGen.S

z <-  .SOAP(oecd, 
     method, ..., 
     .soapArgs = list(), 
     action, 
     nameSpaces = SOAPNameSpaces(), 
     xmlns = NULL, 
     handlers = SOAPHandlers(), 
     .types = NULL, 
     .convert = TRUE, 
    .opts = list(), 
    curlHandle = getCurlHandle(), 
    .header = getSOAPRequestHeader(action, .server = server), 
    .literal = FALSE, 
    .soapHeader = NULL, 
    .elementFormQualified = FALSE) 


################# curlPerform from RCurl as possible option##############
  curlPerform(..., .opts = list(), curl = getCurlHandle(), .encoding = integer())
     curlMultiPerform(curl, multiple = TRUE)
     
modified from curlMultiPerform examples:
    require("RCurl")
    h = basicTextGatherer()
    #h$reset()
      
    # SOAP request
    body = '<?xml version="1.0" encoding="UTF-8"?>\
     <SOAP-ENV:Envelope SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" \
                        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" \
                        xmlns:xsd="http://www.w3.org/1999/XMLSchema" \
                        xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" \
                        xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance">\
       <SOAP-ENV:Body>\
            <namesp1:hi xmlns:namesp1="http://www.soaplite.com/Demo"/>\
       </SOAP-ENV:Body>\
     </SOAP-ENV:Envelope>\n'
 
			
body = ''
    soecd <- "http://stats.oecd.org/OECDSTATWS_SDMXNEW/QueryPage.aspx?Type=DataGeneric"
 
    curlPerform(url=soecd,
       httpheader=c(Accept="text/xml", Accept="multipart/*",        
                    SOAPAction='"http://www.soaplite.com/Demo#hi"',
                    'Content-Type' = "text/xml; charset=utf-8"),
       postfields=body,
       writefunction = h$update,
       verbose = TRUE
       )
     
       body = h$value()
     

require("TSsdmx")
cat("************** TSsdmx  Examples ******************************\n")

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

