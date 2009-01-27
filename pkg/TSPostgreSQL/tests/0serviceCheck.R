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
       if ("" == passwd)   passwd <- NULL
       passwd  <- Sys.getenv("POSTGRES_PASSWD")
       #  See  ?"dbConnect-methods"
       con <- dbConnect(m,
          username=user, password=passwd, host=host, dbname=dbname)  
      }else {
        if (is.null(dbname))   dbname <- "test" #RPostgreSQL default is template1
	con <- dbConnect(m, dbname=dbname) # pass user/passwd/host in ~/.my.cnf
	}
   # dbListTables(con) needs a non-null dbname
   dbDisconnect(con)
 }else {
   cat("POSTGRES not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_POSTGRES_ setting ", service, "\n")
   }
