z <- Sys.getenv("_R_CHECK_HAVE_POSTGRES_")

Sys.info()

if(identical(as.logical(z), TRUE))  require("TSPostgreSQL") else {
   cat("POSTGRES not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_POSTGRES_ setting ", z, "\n")
   }
# This just does a dbConnect (not a TSconnect) to see if things work

service <- Sys.getenv("_R_CHECK_HAVE_POSTGRES_")

Sys.info()

if(identical(as.logical(service), TRUE)) {
   require("TSPostgreSQL") 
   m <- dbDriver("PostgreSQL")

   dbname   <- Sys.getenv("POSTGRES_DATABASE")
   if ("" == dbname)   dbname <-  NULL 

   user    <- Sys.getenv("POSTGRES_USER")
   if ("" != user) {
       # specifying host as NULL or "localhost" results in a socket connection
       host    <- Sys.getenv("POSTGRES_HOST")
       if ("" == host)     host <- Sys.info()["nodename"] 
       passwd  <- Sys.getenv("POSTGRES_PASSWD")
       if ("" == passwd)   passwd <- NULL
       #  See  ?"dbConnect-methods"
       con <- dbConnect(m, dbname=dbname,
          user=user, password=passwd, host=host)  
     }else  {
        if (is.null(dbname))   dbname <- "test" #RPostgreSQL default is template1
	#( the postgres driver may also use PGDATABASE, PGHOST, PGPORT, PGUSER )
	# The Postgress documentation seems to suggest that it should be
	#   possible to get the host from the .pgpass file too, but I cannot.
	host <- Sys.getenv("POSTGRES_HOST")
	if ("" == host) host  <- Sys.getenv("PGHOST")
	if ("" == host) host  <- "localhost"  #Sys.info()["nodename"] 
	#get user/passwd in ~/.pgpass
	con <- dbConnect(m, dbname=dbname, host=host) 
       }
   # dbListTables(con) needs a non-null dbname
   dbDisconnect(con)
 }else {
   cat("POSTGRES not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_POSTGRES_ setting ", service, "\n")
   }
