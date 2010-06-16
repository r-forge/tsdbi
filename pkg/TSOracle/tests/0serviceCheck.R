# This just does a dbConnect (not a TSconnect) to see if things work

service <- Sys.getenv("_R_CHECK_HAVE_ORACLE_")

Sys.info()

if(identical(as.logical(service), TRUE)) {
   require("TSOracle") 
   m <- dbDriver("Oracle")

   dbname   <- Sys.getenv("ORACLE_DATABASE")
   if ("" == dbname)   dbname <-  NULL 

   user    <- Sys.getenv("ORACLE_USER")
   if ("" != user) {
       # specifying host as NULL or "localhost" results in a socket connection
       host    <- Sys.getenv("ORACLE_HOST")
       if ("" == host)     host <- Sys.info()["nodename"] 
       passwd  <- Sys.getenv("ORACLE_PASSWD")
       if ("" == passwd)   passwd <- NULL
       #  See  ?"dbConnect-methods"
       con <- dbConnect(m,
          username=user, password=passwd, host=host, dbname=dbname)  
      }else {
        if (is.null(dbname))   dbname <- "test"  # NULL dbname causes segfault
	con <- dbConnect(m, dbname=dbname) # pass user/passwd/host in ~/.my.cnf
	}
   # dbListTables(con) needs a non-null dbname
   dbDisconnect(con)
 }else {
   cat("ORACLE not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_ORACLE_ setting ", service, "\n")
   }
