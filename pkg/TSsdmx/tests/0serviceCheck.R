#  get public key
soap1.2.env.head <- '<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"> <soap12:Body>'

soap1.2.env.foot <- ' </soap12:Body></soap12:Envelope>'

keyServer <- 'http://stats.oecd.org//OECDStatWS_Authentication/OECDStatWS_Authentication.asmx' 

getKey.soap1.2 <-
 '<GetPublicKey xmlns="http://stats.oecd.org/OECDStatWS/Authentication/" />'


h = basicTextGatherer()

h$reset()
curlPerform(url=keyServer,
       httpheader=c(Accept="text/xml", Accept="multipart/*",        
       'Content-Type' = "text/xml; charset=utf-8"),
       postfields=paste(
           soap1.2.env.head, getKey.soap1.2, soap1.2.env.foot, collapse=""),
       writefunction = h$update,
       verbose = TRUE
       )
     
h$value()


xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)
str(xmlTreeParse(h$value(), asText=TRUE))
str(xmlTreeParse(h$value(), asText=TRUE)$doc$file)
xmlTreeParse(h$value(), asText=TRUE)$doc$file
htmlTreeParse(xmlTreeParse(h$value(), asText=TRUE)$doc$children, asText=TRUE)

names(xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children$Envelope)
xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children
xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children$Envelope
xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children$Envelope$Body
xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children$Envelope[["Body"]]

str(xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children$Envelope[["Body"]])

xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children$Envelope[["Body"]] [[1]][[1]][[1]]

str(xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children$Envelope[["Body"]] [[1]][[1]][[1]])

names(xmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$doc$children$Envelope[["Body"]] [[1]][[1]][[1]])

nchar(h$value())
write(h$value(), file="zot.txt")
htmlTreeParse(h$value(), asText=TRUE, trim=TRUE)
htmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$children$html
xmlTreeParse(htmlTreeParse(h$value(), asText=TRUE, trim=TRUE)$children$html, asText=TRUE, trim=TRUE)

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
</soap12:Envelope>

