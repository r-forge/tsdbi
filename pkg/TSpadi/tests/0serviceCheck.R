# This does a TSconnect to see if things work

service <- Sys.getenv("_R_CHECK_HAVE_PADI_")

Sys.info()

if(identical(as.logical(service), TRUE)) {
   require("TSpadi") 
   m <- dbDriver("padi")

   dbname   <- Sys.getenv("PADI_DATABASE")
   if (is.null(dbname))   dbname <- "test"  

   user    <- Sys.getenv("PADI_USER")
   if ("" != user) {
       # specifying host as NULL or "localhost" results in a socket connection
       host    <- Sys.getenv("PADI_HOST")
       if ("" == host)     host <- Sys.info()["nodename"] 
       if ("" == passwd)   passwd <- NULL
       passwd  <- Sys.getenv("PADI_PASSWD")
       con <- TSconnect(m,
          username=user, password=passwd, host=host, dbname=dbname)  
      }else {
	con <- TSconnect(m, dbname=dbname) # pass user/passwd/host in .padi.cfg
	}
 }else {
   cat("PADI not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_PADI_ setting ", service, "\n")
   }
