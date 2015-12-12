# This just does a dbConnect (not a TSconnect) to see if things work

#  Testing using arguments for user/password/etc

service <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")

Sys.info()

require("TSMySQL") 
m <- RMySQL::MySQL()

if(!identical(as.logical(service), TRUE)) {
   cat("MYSQL not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_MYSQL_ setting ", service, "\n")

   } else {

   dbname  <- Sys.getenv("MYSQL_DATABASE")
   user    <- Sys.getenv("MYSQL_USER")
   passwd  <- Sys.getenv("MYSQL_PASSWD")
   host    <- Sys.getenv("MYSQL_HOST")

   if (""==dbname )   
       stop("environment variable must be specified for MySQL dbname.")

   if (""==host || ""==user || ""==passwd ) {
       cat("environment variables not specified for MySQL connection.",
               " Using .my.cnf\n")
       con <- RMySQL::dbConnect(m, dbname=dbname)  
       } else {
       con <- RMySQL::dbConnect(m,
          username=user, password=passwd, host=host, dbname=dbname)  
       } 
   
   DBI::dbListTables(con, dbname) #needs a non-null dbname

   RMySQL::dbDisconnect(con)

   xcon <- try(RMySQL::dbConnect(m,
      username="bad", password=passwd, host=host, dbname=dbname), silent=TRUE)

   if (!inherits(xcon, "try-error" ))   
     stop("connection with bad user name is not failing! 
           Probably using config file")
  

   xcon <- try(RMySQL::dbConnect(m,
          username=user, password="bad", host=host, dbname=dbname), silent=TRUE)
   if (!inherits(xcon, "try-error" ))   
     stop("connection with bad password is not failing! 
           Probably using config file")
  
   }
