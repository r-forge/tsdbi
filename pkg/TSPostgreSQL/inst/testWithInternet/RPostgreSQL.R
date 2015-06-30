# sourcing HistQuote.TSsql requires the Internet

service <- Sys.getenv("_R_CHECK_HAVE_POSTGRES_")

if(identical(as.logical(service), TRUE)) {


cat("************** RPostgreSQL  Examples ******************************\n")
cat("**************************************************************\n")
cat("* WARNING: THIS OVERWRITES TABLES IN TEST DATABASE ON SERVER**\n")
cat("**************************************************************\n")

###### This is to set up tables. Otherwise use TSconnect#########

dbname   <- Sys.getenv("POSTGRES_DATABASE")
if ("" == dbname)   dbname <- "test"

user	<- Sys.getenv("POSTGRES_USER")
host <- Sys.getenv("POSTGRES_HOST")
if ("" == host) host  <- Sys.getenv("PGHOST")
if ("" == host) host  <- "localhost"  #Sys.info()["nodename"] 
#( the postgres driver may also use PGDATABASE, PGHOST, PGPORT, PGUSER )
#get user/passwd in ~/.pgpass (using line designated by host)
setup <- RPostgreSQL::dbConnect(RPostgreSQL::PostgreSQL(), 
            dbname=dbname, host=host) 

DBI::dbListTables(setup) 

TSsql::removeTSdbTables(setup, yesIknowWhatIamDoing=TRUE, ToLower=TRUE)
TSsql::createTSdbTables(setup, index=FALSE)

DBI::dbListTables(setup) 
DBI::dbDisconnect(setup)
##################################################################

require("TSPostgreSQL")

# pass user/passwd in ~/.pgpass 
con <- tryCatch(TSconnect("PostgreSQL", dbname=dbname, host=host)) 
    
if(inherits(con, "try-error")) stop("CreateTables did not work.")

# check also using arguments for user/passwd
user	<- Sys.getenv("POSTGRES_USER")
passwd  <- Sys.getenv("POSTGRES_PASSWD")
con2 <- TSconnect("PostgreSQL", dbname=dbname,
                              user=user, password=passwd, host=host) 


source(system.file("TSsql/Populate.TSsql", package = "TSsql"))
source(system.file("TSsql/TSdbi.TSsql", package = "TSsql"))

source(system.file("TSsql/dbGetQuery.TSsql", package = "TSsql"))
source(system.file("TSsql/HistQuote.TSsql", package = "TSsql"))

cat("**************        disconnecting test\n")
TSsql::removeTSdbTables(con, yesIknowWhatIamDoing=TRUE, ToLower=TRUE)
dbDisconnect(con)

} else  {
   cat("POSTGRES not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_POSTGRES_ setting ", service, "\n")
   }
