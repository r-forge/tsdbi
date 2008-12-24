# Before starting R you need to set user/passwd/host in ~/.my.cnf

require("TSMySQL")

if(require("RMySQL") ) {
cat("************** RMySQL  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

m <- dbDriver("MySQL")

###### This is to set up tables. Otherwise use TSconnect#########
con <- dbConnect(m, dbname="test") # pass user/passwd/host in ~/.my.cnf
##################################################################

dbListTables(con) 
source(system.file("TSsql/CreateTables.TSsql", package = "TSdbi"))
dbListTables(con) 
dbDisconnect(con)

#con <- TSconnect("MySQL", dbname="test") 
con <- TSconnect("MySQL", dbname="test") # pass user/passwd/host in ~/.my.cnf
if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSdbi"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSdbi"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSdbi"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSdbi"))

cat("**************        disconnecting test\n")
dbDisconnect(con)
dbUnloadDriver(m)

} else  warning("RMySQL not available. Skipping tests.")
