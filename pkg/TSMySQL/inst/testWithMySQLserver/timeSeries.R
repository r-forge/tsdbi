service <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")
require("tfplot")

if(identical(as.logical(service), TRUE)) {

require("TSMySQL")
require("timeSeries")

cat("***** RMySQL  with timeSeries representation *********\n")
dbname   <- Sys.getenv("MYSQL_DATABASE")

if (""==dbname )   
       stop("environment variable must be specified for MySQL dbname.")

#user/passwd/host in ~/.my.cnf
setup <- RMySQL::dbConnect(RMySQL::MySQL(), dbname=dbname) 


TSsql::removeTSdbTables(setup, yesIknowWhatIamDoing=TRUE)
TSsql::createTSdbTables(setup, index=FALSE)

  
#user/passwd/host in ~/.my.cnf
con <- tryCatch(TSconnect("MySQL", dbname=dbname)) 

if(inherits(con, "try-error")) stop("Cannot connect to TS MySQL database.")

# check also passing arguments
# specifying host as NULL or "localhost" results in a socket connection
host    <- Sys.getenv("MYSQL_HOST")
user	<- Sys.getenv("MYSQL_USER")
passwd  <- Sys.getenv("MYSQL_PASSWD")

if (!(""==host || ""==user || ""==passwd )) {
  con2 <- TSconnect("MySQL", dbname=dbname, 
               username=user, password=passwd, host=host)
  dbDisconnect(con2)
  }

z <- ts(matrix(rnorm(10),10,1), start=c(1990,1), frequency=1)
TSput(z, serIDs="Series 1", con) 

# timeSeries seems to have a bug
#z2 <- timeSeries:::as.timeSeries.ts(z)
#z2 <- timeSeries:::as.timeSeries.zoo(zoo(z))
#z2 <- timeSeries:::as.timeSeries.zoo(zooreg(z))
#start(z2)
#time(z2)

# these retrieve but lose date info
z <- TSget("Series 1", con, TSrepresentation="timeSeries")
if("timeSeries" != class(z)) stop("timeSeries class object not returned.")

z <- TSget("Series 1", con, TSrepresentation=timeSeries::timeSeries)
if("timeSeries" != class(z)) stop("timeSeries class object not returned.")

#unresolved problem with timeSeries  (see above)
#tfplot(z)
#gives  'origin' must be supplied

TSrefperiod(z) 
TSdescription(z) 

#unresolved problem 
#tfplot(z, start="1991-01-01", Title="Test")
#gives  'origin' must be supplied

cat("**************        remove test tables\n")
TSsql::removeTSdbTables(con, yesIknowWhatIamDoing=TRUE)

cat("**************        disconnecting test\n")
dbDisconnect(con)

} else  {
   cat("MYSQL not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_MYSQL_ setting ", service, "\n")
   }
