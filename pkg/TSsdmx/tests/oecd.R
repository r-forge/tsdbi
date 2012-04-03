# Status:  Not nearly working
#    Preliminary investigation notes below.
#    Uses SOAP and may require authentication. 
#    Account does not seem necessary, but not sure.

#################################################
####### lots of junk to clean out below #######
#################################################

#This wiki about SDMX that has some examples that might help. It looks 
#like this is a query format for ISTAT SDMX.
#  http://sdmx.wikispaces.com 
#  http://sdmx.wikispaces.com/Example 
#  http://sdmx.wikispaces.com/Example4 

#####  http://sdmx.wikispaces.com/OECD+Web+Service  #####
#####  http://sdmx.wikispaces.com  #####

#It looks like you can plug in the SDMX export query here:
#http://webnet.oecd.org/Sdmxws/Home.aspx
#or
#http://webnet.oecd.org/Sdmxws/Home.aspx?Type=MDDimensionMember
# the old service is at
#http://webnet.oecd.org/OECDStatWS_SDMX/SDMXQuery.aspx
#and new service was previously called 
#http://stats.oecd.org/OECDSTATWS_SDMXNEW/QueryPage.aspx?Type=MDDimensionMember 


#Tthere is some sort of SOAP web service through which you feed this query. #Perhaps there are clues to using it here, but you need a login: #http://stats.oecd.org/SDMXWS/sdmx.asmx


#It is using SOAP. There's a link on this page -- 
# http://stats.oecd.org/SDMXWS/sdmx.asmx
#to the "service description", which leads to the WSDL file that describes the 
#web service: http://stats.oecd.org/SDMXWS/sdmx.asmx?WSDL
#web service: http://stats.oecd.org/OECDSTATWS_SDMXNEW/sdmx.asmx?WSDL

 
#You might find it helpful to feed that WSDL (Web Service Definition Language) 
#file into this "online SOAP client"  service - it's very useful 
#and instructive:
#   http://www.soapclient.com/soaptest.html
 

#http://stats.oecd.org/SDMXWS/sdmx.asmx
#or test at
#http://stats.oecd.org/SDMXWS/QueryPage.aspx?Type=DataGeneric
#or
#http://stats.oecd.org/OECDSTATWS_SDMXNEW/QueryPage.aspx?Type=DataGeneric

#XML (Soap?) request for M1 and M3 to oecd (non-public db).

require("SSOAP") #asdcl2
require("RCurl") #asdcl2
require("XML")

s1 <- SOAPServer("services.soaplite.com", "interop.cgi")
z <- .SOAP(s1, "echoString", "From R", action="urn:soapinterop", 
           xmlns=c(namesp1="http://soapinterop.org/"), handlers =NULL)

#Following works on the tests site
#   http://stats.oecd.org/OECDSTATWS_SDMXNEW/QueryPage.aspx?Type=DataGeneric
#(validates with error but gets data - but not DEMOPOP_0).

query <- '
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
			<Name xml:lang="fr">Organisation de cooperation et de developpement economiques</Name>
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
'  #end query

#Note that with     <!--Dimension id="LOCATION">AUS</Dimension-->
#all countries  are returned.


#see also http://www.omegahat.org/SSOAP/examples/keggGen.S

#see ?.SOAP

################# curlPerform from RCurl as possible option##############
      
####### see SOAP request example from curlPerform help #######
 
####### now try oecd sdmx SOAP #######

require("RCurl")
require("XML")
#  get public key
soap1.2.env.head <- '<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"> <soap12:Body>'

soap1.2.env.foot <- ' </soap12:Body></soap12:Envelope>'

keyServer <- 'http://stats.oecd.org//OECDStatWS_Authentication/OECDStatWS_Authentication.asmx' 

getKey.soap1.2 <-
 '<GetPublicKey xmlns="http://stats.oecd.org/OECDStatWS/Authentication/" />'


# authenticate

auth <- '<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Header>
    <RequesterInfoSoapHeader xmlns="http://stats.oecd.org/OECDStatWS/Authentication/">
      <RequestingApplication>string</RequestingApplication>
      <UserIdentityDomain>string</UserIdentityDomain>
      <UserIdentityUserName>string</UserIdentityUserName>
      <SessionToken>string</SessionToken>
    </RequesterInfoSoapHeader>
  </soap12:Header>
  <soap12:Body>
    <Authenticate xmlns="http://stats.oecd.org/OECDStatWS/Authentication/">
      <logon>string</logon>
      <domain>string</domain>
      <encryptedpassword>string</encryptedpassword>
    </Authenticate>
  </soap12:Body>
</soap12:Envelope>'

# see example at http://stats.oecd.org/SDMXWS/sdmx.asmx?op=GetGenericData

#soap1.0

soap1.0.env.head <- '<?xml version="1.0" encoding="UTF-8"?>\
     <SOAP-ENV:Envelope SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" \
                        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" \
                        xmlns:xsd="http://www.w3.org/1999/XMLSchema" \
                        xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" \
                        xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance">\
       <SOAP-ENV:Body>\ '

soap1.0.env.foot <- '</SOAP-ENV:Body>\
     </SOAP-ENV:Envelope>\n'

#soap1.1
# note SOAPAction: "http://stats.oecd.org/OECDStatWS/SDMX/GetGenericData"
# is in the HTML header befor the soap envelope

soap1.1.env.head <- '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>'
#    <GetGenericData xmlns="http://stats.oecd.org/OECDStatWS/SDMX/">
#      <QueryMessage>

#</QueryMessage>
#    </GetGenericData>
soap1.1.env.foot <- '
  </soap:Body>
</soap:Envelope>'

#soap1.2
# note no SOAPAction
soap1.2.env.head <- '<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>'
#    <GetGenericData xmlns="http://stats.oecd.org/OECDStatWS/SDMX/">
#      <QueryMessage>

#</QueryMessage>
#    </GetGenericData>
soap1.2.env.foot <- '
  </soap12:Body>
</soap12:Envelope>'

# example from http://stats.oecd.org/SDMXWS/QueryPage.aspx?Type=DataGeneric
# works  with Get Data button on oecd site 
# (but trouble loading autoamtically in gedit)
queryMessageEg <- '
<message:QueryMessage xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query http://www.sdmx.org/docs/2_0/SDMXQuery.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message http://www.sdmx.org/docs/2_0/SDMXMessage.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<Header xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message">
		<ID>none</ID>
		<Test>false</Test>
		<Truncated>false</Truncated>
		<Prepared>2010-11-11T18:35:38</Prepared>
		<Sender id="YourID">
			<Name xml:lang="en">Your English Name</Name>
		</Sender>
		<Receiver id="OECD">
			<Name xml:lang="en">Organisation for Economic Co-operation and Development</Name>
			<Name xml:lang="fr">Organisation de cooperation et de developpement economiques</Name>
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
				<!--Dimension id="LOCATION">AUS</Dimension-->
				<Attribute id="TIME_FORMAT">P1Y</Attribute>
				<Time>
					<StartTime>1960</StartTime>
					<EndTime>2010</EndTime>
				</Time>
				<Or>
					<Dimension id="SUBJECT">DEMOPOP_0</Dimension>
					<Dimension id="SUBJECT">YP</Dimension>
					<Dimension id="SUBJECT">YPTTTTL1_ST</Dimension>
					<Dimension id="SUBJECT">STATFIN_0</Dimension>
					<Dimension id="SUBJECT">IR</Dimension>
					<Dimension id="SUBJECT">IR3T</Dimension>
					<Dimension id="SUBJECT">IRLT</Dimension>
					<Dimension id="SUBJECT">STATFIN_06</Dimension>
					<Dimension id="SUBJECT">SP</Dimension>
					<Dimension id="SUBJECT">BP</Dimension>
					<Dimension id="SUBJECT">BPBLTT01</Dimension>
					<Dimension id="SUBJECT">CC</Dimension>
					<Dimension id="SUBJECT">CCUS</Dimension>
					<Dimension id="SUBJECT">STATFIN_12</Dimension>
					<Dimension id="SUBJECT">XF</Dimension>
					<Dimension id="SUBJECT">INDSER_0</Dimension>
					<Dimension id="SUBJECT">PR</Dimension>
					<Dimension id="SUBJECT">IPI</Dimension>
					<Dimension id="SUBJECT">TR_0</Dimension>
					<Dimension id="SUBJECT">TR_01</Dimension>
					<Dimension id="SUBJECT">EXPGOOD</Dimension>
					<Dimension id="SUBJECT">IMPGOOD</Dimension>
					<Dimension id="SUBJECT">NETGOOD</Dimension>
					<Dimension id="SUBJECT">LFS_0</Dimension>
					<Dimension id="SUBJECT">LFS_01</Dimension>
					<Dimension id="SUBJECT">POPACT</Dimension>
					<Dimension id="SUBJECT">ET</Dimension>
					<Dimension id="SUBJECT">EC</Dimension>
					<Dimension id="SUBJECT">UNEMP</Dimension>
					<Dimension id="SUBJECT">UNRTSD</Dimension>
					<Dimension id="SUBJECT">UNRTSDTT</Dimension>
					<Dimension id="SUBJECT">NA_0</Dimension>
					<Dimension id="SUBJECT">NA_01</Dimension>
					<Dimension id="SUBJECT">GDPA</Dimension>
					<Dimension id="SUBJECT">GDPVA</Dimension>
					<Dimension id="SUBJECT">PGDPA</Dimension>
					<Dimension id="SUBJECT">GDPA_PPP</Dimension>
					<Dimension id="SUBJECT">GDPA_DOLLAR</Dimension>
					<Dimension id="SUBJECT">GDPA_PH_PPP</Dimension>
					<Dimension id="SUBJECT">GDPA_PH_DOLLAR</Dimension>
					<Dimension id="SUBJECT">GDPA_PH_OECD</Dimension>
					<Dimension id="SUBJECT">NA_02</Dimension>
					<Dimension id="SUBJECT">GDPQ</Dimension>
					<Dimension id="SUBJECT">GDPVQ</Dimension>
					<Dimension id="SUBJECT">PGDPQ</Dimension>
					<Dimension id="SUBJECT">NA_03</Dimension>
					<Dimension id="SUBJECT">GDP_EO</Dimension>
					<Dimension id="SUBJECT">GDPV_EO</Dimension>
					<Dimension id="SUBJECT">PGDP_EO</Dimension>
					<Dimension id="SUBJECT">PCP_EO</Dimension>
					<Dimension id="SUBJECT">PRPPP_0</Dimension>
					<Dimension id="SUBJECT">CP</Dimension>
					<Dimension id="SUBJECT">CPITOT</Dimension>
					<Dimension id="SUBJECT">CPILF</Dimension>
					<Dimension id="SUBJECT">PP</Dimension>
					<Dimension id="SUBJECT">PPI</Dimension>
					<Dimension id="SUBJECT">PRPPP_02</Dimension>
					<Dimension id="SUBJECT">PPPGDP</Dimension>
					<Dimension id="SUBJECT">PPPPC</Dimension>
				</Or>
			</And>
		</DataWhere>
	</Query>
</message:QueryMessage>'
	
queryMessage <- '
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
			<Name xml:lang="fr">Organisation de cooperation et de developpement economiques</Name>
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
					<Dimension id="SUBJECT">IPI</Dimension>
					<Dimension id="SUBJECT">IMPGOOD</Dimension>
				</Or>
			</And>
		</DataWhere>
	</Query>
</message:QueryMessage>'
			

soecdA <-
   "http://stats.oecd.org/OECDSTATWS_SDMXNEW/sdmx.aspx?op=GetGenericData"
soecdB <-
   "http://stats.oecd.org/SDMXWS/sdmx.asmx?op=GetGenericData"
soecdC <-
   "http://stats.oecd.org/OECDStatWS/SDMX/sdmx.asmx?op=GetGenericData"
 
h = basicTextGatherer()

# SOAPAction  below may be for wrong version? 
# <wsdl:operation name="GetGenericData">
# <soap12:operation soapActionA="http://stats.oecd.org/OECDSTATWS_SDMXNEW/GetGenericData" 
soapActionB="http://stats.oecd.org/SDMXWS/GetGenericData" 
soapActionC="http://stats.oecd.org/OECDStatWS/SDMX/GetGenericData" 

body <- paste(soap1.0.env.head, queryMessage,soap1.0.env.foot, collapse="")
body <- paste(soap1.1.env.head, queryMessage,soap1.1.env.foot, collapse="")
#<faultstring>Server was unable to process request. ---&gt; Object reference not set to an instance of an object.</faultstring>
body <- paste(soap1.2.env.head, queryMessageEg,soap1.2.env.foot, collapse="")
body <- paste(soap1.2.env.head, queryMessage,soap1.2.env.foot, collapse="")

h$reset()
curlPerform(url=soecdB,
curlPerform(url=soecdC,
curlPerform(url=soecdA,
       httpheader=c(Accept="text/xml", Accept="multipart/*",        
                    SOAPAction=soapActionA,
                    'Content-Type' = "text/xml; charset=utf-8"),
       postfields=body,
       writefunction = h$update,
       verbose = TRUE
       )
     
h$value()
# C returns <title>Object moved</title>
# B returns Internal Server Error  SoapException: Server did not recognize the value of HTTP Head
# A returns <title>Object moved</title>


xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)
#  str(xmlTreeParse(h$value(), asText=TRUE))

names(xmlTreeParse(h$value(), asText=TRUE, trim=TRUE))
nchar(h$value())
# write(h$value(), file="zot.txt")
htmlTreeParse(h$value(), asText=TRUE, trim=TRUE)
     
# should try to get <faultstring> out of $children in case of bad query
names(htmlTreeParse(h$value(), asText=TRUE, trim=TRUE))
htmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$children
 
 
   #uri <- 
   #z <- getURLContent(uri)

cat("************** TSsdmx  Examples ******************************\n")
require("TSsdmx")
require("tfplot")

if(FALSE) {

con <- TSconnect("sdmx", dbname="OECD") 

oecd <- SOAPServer("stats.oecd.org", "OECDSTATWS_SDMXNEW/QueryPage.aspx")

z <- .SOAP(oecd, "", handlers =NULL)


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

} # end if FALSE
