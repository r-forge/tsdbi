# This just uses dbConnect (not TSconnect) to see if things work

#  Testing using arguments for user/password/etc

# Note that host will default to localhost if neither environment variables
#   PGHOST or POSTGRES_HOST are set. (Only one of them is needed.)

service <- Sys.getenv("_R_CHECK_HAVE_POSTGRES_")

Sys.info()

require("TSPostgreSQL") 
m <- "PostgreSQL"

dbname   <- Sys.getenv("POSTGRES_DATABASE")
if ("" == dbname)  { 
   dbname <- "test" #PostgreSQL default is template1
   cat("dbname set to test.\n")
   } else 
   cat("dbname set to:", dbname, " by env variable POSTGRES_DATABASE\n") 

host    <- Sys.getenv("POSTGRES_HOST")
cat("host set to:", host, " by env variable POSTGRES_HOST\n") 
if ("" == host) {
   host <- Sys.getenv("PGHOST")
   cat("host reset to:", host, "by env variable PGHOST\n")
   # note that the driver will use PGHOST if nothing is specified
   } 
if ("" == host) {
   host <- "localhost"  #Sys.info()["nodename"]
   cat("host reset to:", host, "\n") 
   } 

if(!identical(as.logical(service), TRUE)) {
   cat("POSTGRES not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_POSTGRES_ setting ", service, "\n")

   }else {
   
   user    <- Sys.getenv("POSTGRES_USER")
   cat("user set to:", user, " by env variable POSTGRES_USER\n") 
   # note that the driver seems to $USERNAME if not specified
   passwd  <- Sys.getenv("POSTGRES_PASSWD")
   cat("passwd set by env variable POSTGRES_PASSWD\n") 

   con <- RPostgreSQL::dbConnect(m, dbname=dbname,
      user=user, password=passwd, host=host)  

   DBI::dbListTables(con)

   RPostgreSQL::dbDisconnect(con)
   }
