# Before starting R you need to set user/passwd/host in ~/.pgpass

require("TSPostgreSQL")

if(require("RPostgreSQL") ) {
cat("************** RPostgreSQL  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

m <- dbDriver("PostgreSQL")

###### This is to set up tables. Otherwise use TSconnect#########
# pass user/passwd in ~/.pgpass (but host seems to be a problem).
con <- dbConnect(m, dbname="test", 
  host=if(!is.null(Sys.getenv("PGHOST"))) Sys.getenv("PGHOST") else "localhost")
##################################################################

dbListTables(con) 
source(system.file("TSsql/CreateTables.TSsql", package = "TSdbi"))
dbListTables(con) 
dbDisconnect(con)

# pass user/passwd in ~/.pgpass (but host defaults to PGHOST or localhost).
con <- TSconnect("PostgreSQL", dbname="test")
 
#if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSdbi"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSdbi"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSdbi"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSdbi"))

cat("**************        disconnecting test\n")
dbDisconnect(con)
dbUnloadDriver(m)

} else  warning("RPostgreSQL not available. Skipping tests.")
