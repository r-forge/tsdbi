service <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")

if(identical(as.logical(service), TRUE)) {

require("TSMySQL")

cat("************** RMySQL  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

m <- dbDriver("MySQL") # note that this is needed in sourced files.

###### This is to set up tables. Otherwise use TSconnect#########
   dbname   <- Sys.getenv("MYSQL_DATABASE")
   if ("" == dbname)   dbname <- "test"

   user    <- Sys.getenv("MYSQL_USER")
   if ("" != user) {
       # specifying host as NULL or "localhost" results in a socket connection
       host    <- Sys.getenv("MYSQL_HOST")
       if ("" == host)     host <- Sys.info()["nodename"] 
       if ("" == passwd)   passwd <- NULL
       passwd  <- Sys.getenv("MYSQL_PASSWD")
       #  See  ?"dbConnect-methods"
       con <- dbConnect("MySQL",
          username=user, password=passwd, host=host, dbname=dbname)  
     }else  con <- 
       dbConnect(m, dbname=dbname) # pass user/passwd/host in ~/.my.cnf

dbListTables(con) 
source(system.file("TSsql/CreateTables.TSsql", package = "TSdbi"))
dbListTables(con) 
dbDisconnect(con)
##################################################################

con <- if ("" != user)  
          tryCatch(TSconnect(m, dbname=dbname, username=user, password=passwd, host=host)) 
    else  tryCatch(TSconnect(m, dbname=dbname)) # pass user/passwd/host in ~/.my.cnf

if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSdbi"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSdbi"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSdbi"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSdbi"))

cat("**************        disconnecting test\n")
dbDisconnect(con)
dbUnloadDriver(m)

} else  {
   cat("MYSQL not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_MYSQL_ setting ", service, "\n")
   }
