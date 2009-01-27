# This just does a dbConnect (not a TSconnect) to see if things work

service <- Sys.getenv("_R_CHECK_HAVE_ODBC_")

Sys.info()

if(identical(as.logical(service), TRUE)) {
   require("TSodbc") 

   dbname   <- Sys.getenv("ODBC_DATABASE")
   if ("" == dbname)   dbname <- NULL

   user    <- Sys.getenv("ODBC_USER")
   if ("" != user) {
       host    <- Sys.getenv("ODBC_HOST")
       if ("" == host)     host <- Sys.info()["nodename"] 
       if ("" == passwd)   passwd <- NULL
       passwd  <- Sys.getenv("ODBC_PASSWD")
       #  See  ?odbcConnect   ?odbcDriverConnect
       con <- odbcConnect(dsn=dbname, uid=user, pwd=passwd, connection=host)  
    } else {
       if (is.null(dbname))   dbname <- "test"  # NULL dbname causes problem
       con <-  odbcConnect(dsn=dbname) # pass user/passwd/host in ~/.odbc.ini
       }
   odbcClose(con)
 } else {
   cat("ODBC not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_ODBC_ setting ", service, "\n")
   }
