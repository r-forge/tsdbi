service <- Sys.getenv("_R_CHECK_HAVE_ODBC_")

if(identical(as.logical(service), TRUE)) {

require("TSodbc")

cat("************** RODBC  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

###### This is to set up tables. Otherwise use TSconnect#########
  # This will fail if ODBC support is not installed or set up on the system 
  # with a message like:  [RODBC] ERROR: state IM002, code 0, 
  # message [unixODBC][Driver Manager]Data source name not found, 
  # and no default driver specified

   dbname   <- Sys.getenv("ODBC_DATABASE")
   if ("" == dbname)   dbname <- "test"

   user    <- Sys.getenv("ODBC_USER")
   if ("" != user) {
       host    <- Sys.getenv("ODBC_HOST")
       if ("" == host)     host <- Sys.info()["nodename"] 
       if ("" == passwd)   passwd <- NULL
       passwd  <- Sys.getenv("ODBC_PASSWD")
       #  See  ?odbcConnect   ?odbcDriverConnect
       con <- odbcConnect(dsn=dbname, uid=user, pwd=passwd, connection=host) 
     }else  
       con <- odbcConnect(dsn=dbname) # pass user/passwd/host in ~/.odbc.ini

#dbListTables(con) 
source(system.file("TSsql/CreateTables.TSsql", package = "TSdbi"))
#dbListTables(con) 
dbDisconnect(con)
##################################################################

con <- if ("" != user)  
          tryCatch(TSconnect("ODBC", dbname=dbname, username=user, password=passwd, host=host)) 
    else  tryCatch(TSconnect("ODBC", dbname=dbname)) # pass user/passwd/host in ~/.my.cnf

if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSdbi"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSdbi"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSdbi"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSdbi"))

cat("**************        disconnecting test\n")
dbDisconnect(con)

} else {
   cat("ODBC not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_ODBC_ setting ", service, "\n")
   }
