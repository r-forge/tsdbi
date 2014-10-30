service <- Sys.getenv("_R_CHECK_HAVE_ORACLE_")

if(identical(as.logical(service), TRUE)) {

cat("************** ROracle  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")


###### This is to set up tables. Otherwise use TSconnect#########
   dbname   <- Sys.getenv("ORACLE_DATABASE")
   if ("" == dbname)   dbname <- "test"

   user    <- Sys.getenv("ORACLE_USER")
   if ("" != user) {
       # specifying host as NULL or "localhost" results in a socket connection
       host    <- Sys.getenv("ORACLE_HOST")
       if ("" == host)     host <- Sys.info()["nodename"] 
       passwd  <- Sys.getenv("ORACLE_PASSWD")
       if ("" == passwd)   passwd <- NULL
       #  See  ?"dbConnect-methods"
       con <- Oracle::dbConnect(Oracle::Oracle(),
          username=user, password=passwd, host=host, dbname=dbname)  
     }else  con <- 
       Oracle::dbConnect(Oracle::Oracle(), dbname=dbname) # pass user/passwd/host in ~/.my.cnf

DBI::dbListTables(con) 

TSsql::removeTSdbTables(con, yesIknowWhatIamDoing=TRUE)
TSsql::createTSdbTables(con, index=FALSE)

DBI::dbListTables(con) 
DBI::dbDisconnect(con)
##################################################################
require("TSOracle")

con <- if ("" != user)  
          tryCatch(TSconnect("Oracle", dbname=dbname, username=user, password=passwd, host=host)) 
    else  tryCatch(TSconnect("Oracle", dbname=dbname)) # pass user/passwd/host

if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSsql"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSsql"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSsql"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSsql"))

cat("**************        remove test tables\n")
removeTSdbTables(con, yesIknowWhatIamDoing=TRUE)

cat("**************        disconnecting test\n")
dbDisconnect(con)
dbUnloadDriver(m)

} else  {
   cat("ORACLE not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_ORACLE_ setting ", service, "\n")
   }
