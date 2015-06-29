# This just does a dbConnect (not a TSconnect) to see if things work

#  Testing using .my.cnf

service <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")

Sys.info()

require("TSMySQL") 
m <- RMySQL::MySQL()

dbname   <- Sys.getenv("MYSQL_DATABASE")
if ("" == dbname)   dbname <-  "test" 

if(!identical(as.logical(service), TRUE)) {
   cat("MYSQL not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_MYSQL_ setting ", service, "\n")

   } else {

   con <- RMySQL::dbConnect(m, dbname=dbname) #user/passwd/host in ~/.my.cnf

   DBI::dbListTables(con) 
   
   RMySQL::dbDisconnect(con)
   }
