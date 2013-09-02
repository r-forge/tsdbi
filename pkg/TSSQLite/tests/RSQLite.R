if(identical(as.logical(Sys.getenv("_R_CHECK_HAVE_SQLLITE_")), TRUE)) {

require("TSSQLite")

cat("************** RSQLite  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

m <- dbDriver("SQLite")

con <- dbConnect(m, dbname="test") # no user/passwd/host

dbListTables(con) 

#source(system.file("TSsql/CreateTables.TSsql", package = "TSdbi"))
require("TSsql")
removeTSdbTables(con, yesIknowWhatIamDoing=TRUE)
createTSdbTables(con, index=FALSE)

dbListTables(con) 
dbDisconnect(con)

con <- try(TSconnect(m, dbname="test") )
if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSdbi"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSdbi"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSdbi"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSdbi"))

cat("**************        remove test tables\n")
removeTSdbTables(con, yesIknowWhatIamDoing=TRUE)

cat("**************        disconnecting test\n")
dbDisconnect(con)
#  dbUnloadDriver(m) complains about open connections.

} else  cat("SQLLITE not available. Skipping tests.")
