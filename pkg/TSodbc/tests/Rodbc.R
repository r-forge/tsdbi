# Before starting R you need to set user/passwd/host in ~/.my.cnf

require("TSodbc")

if(require("RODBC") ) {
  library("tframe")

cat("************** RODBC  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

m <- dbDriver("ODBC")

###### This is to set up tables. Otherwise use TSconnect#########
  # This will fail if ODBC support is not installed or set up on the system 
  # with a message like:  [RODBC] ERROR: state IM002, code 0, 
  # message [unixODBC][Driver Manager]Data source name not found, 
  # and no default driver specified
 con <- odbcConnect("test") # pass user/ passwd / host in .obc.ini
##################################################################

#dbListTables(con) 
source(system.file("TSsql/CreateTables.TSsql", package = "TSdbi"))
#dbListTables(con) 
#dbDisconnect(con)

#con <- TSconnect("ODBC", dbname="test") 
con <- TSconnect("ODBC", dbname="test") # pass user/passwd/host in ~/.obc.ini
if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSdbi"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSdbi"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSdbi"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSdbi"))

cat("**************        disconnecting test\n")
dbDisconnect(con)
dbUnloadDriver(m)

} else  warning("RODBC not available. Skipping tests.")
