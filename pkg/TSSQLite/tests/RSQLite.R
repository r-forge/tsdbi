if(identical(as.logical(Sys.getenv("_R_CHECK_HAVE_SQLITE_")), TRUE)) {


cat("************** RSQLite  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

# no user/passwd/host
setup <- RSQLite::dbConnect(RSQLite::SQLite(), dbname="test") 

RSQLite::dbListTables(setup) 

TSsql::removeTSdbTables(setup, yesIknowWhatIamDoing=TRUE)
TSsql::createTSdbTables(setup, index=FALSE)

DBI::dbListTables(setup) 
DBI::dbDisconnect(setup)

require("TSSQLite")

con <- try(TSconnect("SQLite", dbname="test") )
if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSsql"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSsql"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSsql"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSsql"))

cat("**************        remove test tables\n")
TSsql::removeTSdbTables(con, yesIknowWhatIamDoing=TRUE)

cat("**************        disconnecting test\n")
dbDisconnect(con)

} else  cat("SQLLITE not available. Skipping tests.")
