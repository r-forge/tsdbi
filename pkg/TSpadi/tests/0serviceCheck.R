# This does a TSconnect to see if things work

service <- Sys.getenv("_R_CHECK_HAVE_PADI_")

Sys.info()

if(identical(as.logical(service), TRUE)) {
   require("TSpadi") 
   cat("PADI_STARTUP set to: ", Sys.getenv("PADI_STARTUP"),"\n")
   cat("PADI_CLEANUP set to: ", Sys.getenv("PADI_CLEANUP"),"\n")
   m <- dbDriver("padi")

   dbname   <- Sys.getenv("PADI_DATABASE")
   if ("" == dbname)   dbname <- "test"  

   user    <- Sys.getenv("PADI_USER")
   if ("" != user) {
        # specifying host as NULL or "localhost" results in a socket connection
        cat("Using environment variables for PADI connection info.\n")
        host	<- Sys.getenv("PADI_HOST")
        if ("" == host)     host <- Sys.info()["nodename"] 
        passwd  <- Sys.getenv("PADI_PASSWD")
        if ("" == passwd)   passwd <- NULL
        cat("TSconnect skipped in this test. The server is started in other tests.\n")
        #con <- TSconnect(m,
        #   username=user, password=passwd, host=host, dbname=dbname)  
      }else {
        cat("Using .padi.cfg for PADI connection info.\n")
        cat("TSconnect skipped in this test. The server is started in other tests.\n")
	#con <- TSconnect(m, dbname=dbname) # pass user/passwd/host in .padi.cfg
	}
 }else {
   cat("PADI not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_PADI_ setting ", service, "\n")
   }
