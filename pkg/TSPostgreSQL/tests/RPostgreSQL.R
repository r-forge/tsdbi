service <- Sys.getenv("_R_CHECK_HAVE_POSTGRES_")

if(identical(as.logical(service), TRUE)) {

require("TSPostgreSQL")

cat("************** RPostgreSQL  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

m <- dbDriver("PostgreSQL") # note that this is needed in sourced files.

###### This is to set up tables. Otherwise use TSconnect#########

   dbname   <- Sys.getenv("POSTGRES_DATABASE")
   if ("" == dbname)   dbname <- "test"

   user    <- Sys.getenv("POSTGRES_USER")
   host <- Sys.getenv("POSTGRES_HOST")
   if ("" == host) host  <- Sys.getenv("PGHOST")
   if ("" == host) host  <- "localhost"  #Sys.info()["nodename"] 
   if ("" != user) {
       passwd  <- Sys.getenv("POSTGRES_PASSWD")
       if ("" == passwd)   passwd <- NULL
       #  See  ?"dbConnect-methods"
       con <- dbConnect(m, dbname=dbname,
          user=user, password=passwd, host=host)  
     }else  {
	#( the postgres driver may also use PGDATABASE, PGHOST, PGPORT, PGUSER )
       # The Postgress documentation seems to suggest that it should be
       #   possible to get the host from the .pgpass file too, but I cannot.
       #get user/passwd in ~/.pgpass
       con <- dbConnect(m, dbname=dbname, host=host) 
       }

dbListTables(con) 
source(system.file("TSsql/CreateTables.TSsql", package = "TSdbi"))
dbListTables(con) 
dbDisconnect(con)
##################################################################

# pass user/passwd in ~/.pgpass (but host defaults to PGHOST or localhost).

con <- if ("" != user)  
          tryCatch(TSconnect(m, dbname=dbname, user=user, password=passwd, host=host)) 
    else  tryCatch(TSconnect(m, dbname=dbname)) 
    
if(inherits(con, "try-error")) stop("CreateTables did not work.")

source(system.file("TSsql/Populate.TSsql", package = "TSdbi"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSdbi"))
source(system.file("TSsql/dbGetQuery.TSsql", package = "TSdbi"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSdbi"))

cat("**************        disconnecting test\n")
dbDisconnect(con)
dbUnloadDriver(m)

} else  {
   cat("POSTGRES not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_POSTGRES_ setting ", service, "\n")
   }
