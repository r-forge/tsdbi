service <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")

if(identical(as.logical(service), TRUE)) {

require("TSMySQL")
require("timeSeries")

cat("***** RMySQL  with timeSeries representation *********\n")
dbname   <- Sys.getenv("MYSQL_DATABASE")
if ("" == dbname)   dbname <- "test"

user	<- Sys.getenv("MYSQL_USER")

# specifying host as NULL or "localhost" results in a socket connection
host	<- Sys.getenv("MYSQL_HOST")
if ("" == host)     host <- Sys.info()["nodename"] 
passwd  <- Sys.getenv("MYSQL_PASSWD")
if ("" == passwd)   passwd <- NULL

con <- if ("" != user)  
          tryCatch(TSconnect("MySQL", dbname=dbname, username=user, password=passwd, host=host)) 
    else  tryCatch(TSconnect("MySQL", dbname=dbname)) # pass user/passwd/host in ~/.my.cnf

if(inherits(con, "try-error")) stop("Cannot connect to TS MySQL database.")

  z <- TSget("Series 1", con, TSrepresentation="timeSeries")
  if("timeSeries" != class(z)) stop("timeSeries class object not returned.")
  tfplot(z)

  options(TSrepresentation="timeSeries")

  z <- TSget(c("matc1","matc2"), con)
  if("timeSeries" != class(z)) stop("timeSeries class object not returned.")
  tfplot(z)
 
  TSrefperiod(z) 
  TSdescription(z) 

  tfplot(z, start="1991-01-01", Title="Test")

cat("**************        disconnecting test\n")
dbDisconnect(con)

} else  {
   cat("MYSQL not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_MYSQL_ setting ", service, "\n")
   }
