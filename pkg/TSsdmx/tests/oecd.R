XML (Soap?) request for M1 and M3 to oecd (non-public db).
<message:QueryMessage
   xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" 
   xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
   xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query 
   http://www.sdmx.org/docs/2_0/SDMXQuery.xsd 
   http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message 
   http://www.sdmx.org/docs/2_0/SDMXMessage.xsd" 
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<Header xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message">
<ID>none</ID><Test>false</Test>
<Truncated>false</Truncated>
<Prepared>2010-05-17T19:45:39</Prepared>
<Sender id="YourID"><Name xml:lang="en">Your English Name</Name></Sender>
<Receiver id="OECD"><Name xml:lang="en">Organisation for Economic Co-operation and Development</Name>
<Name xml:lang="fr">Organisation de coopération et de développement économiques</Name></Receiver></Header>
<Query xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message">
<DataWhere xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query">
<And><DataSet>MEI</DataSet>
<Dimension id="LOCATION">CAN</Dimension>
<Dimension id="MEASURE">ST</Dimension>
<Dimension id="FREQUENCY">M</Dimension>
<Attribute id="TIME_FORMAT">P1M</Attribute>
<Time><StartTime>1955-01</StartTime><EndTime>2010-07</EndTime></Time>
<Or>
<Dimension id="SUBJECT">MANMM101</Dimension>
<Dimension id="SUBJECT">MABMM301</Dimension>
</Or></And></DataWhere></Query></message:QueryMessage>


require("TSsdmx")
cat("************** TSsdmx  Examples ******************************\n")

con <- TSconnect("sdmx", dbname="OECD") 

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

