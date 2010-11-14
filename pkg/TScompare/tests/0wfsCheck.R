service1 <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")
service2 <- Sys.getenv("_R_CHECK_HAVE_PADI_")

if(!identical(as.logical(service1), TRUE) |
   !identical(as.logical(service2), TRUE)) {
   cat("PADI or MYSQL not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_MYSQL_ setting ", service1, "\n")
   cat("_R_CHECK_HAVE_PADI_ setting ", service2, "\n")
} else  {

   require("TScompare")
   require("TSMySQL")
   require("TSpadi")

   user1    <- Sys.getenv("MYSQL_USER")
   if ("" != user1) {
       # specifying host as NULL or "localhost" results in a socket connection
       host1    <- Sys.getenv("MYSQL_HOST")
       if ("" == host1)     host1 <- Sys.info()["nodename"] 
       passwd1  <- Sys.getenv("MYSQL_PASSWD")
       if ("" == passwd1)   passwd1 <- NULL
     }

   con1 <- if ("" != user1)  
            try(TSconnect("MySQL", dbname="wfs", 
	        username=user1, password=passwd1, host=host1), silent=TRUE) 
      else  try(TSconnect("MySQL", dbname="wfs"), silent=TRUE) # pass user/passwd/host in ~/.my.cnf


   user2    <- Sys.getenv("PADI_USER")
   if ("" != user2) {
       # specifying host as NULL or "localhost" results in a socket connection
       host2    <- Sys.getenv("MYSQL_HOST")
       if ("" == host2)     host2 <- Sys.info()["nodename"] 
       passwd2  <- Sys.getenv("MYSQL_PASSWD")
       if ("" == passwd2)   passwd2 <- NULL
     }
    
   con2 <-  if ("" != user2) 
            try(TSconnect("padi", dbname="ets",
	         username=user, password=passwd, host=host2), silent=TRUE) 
       else try(TSconnect("padi", dbname="ets"), silent=TRUE) # pass user/passwd/host in ~/.padi.cfg

   if      (inherits(con1, "try-error"))
           cat("wfs connection not available. Skipping 0wfsCheck tests.")
   else if (inherits(con2, "try-error"))
           cat("ets connection not available. Skipping 0wfsCheck tests.")
   else {
      ids <- AllIds(con1)
      if(!is.null(AllPanels(con1)))   stop("Bad result. wfs does not have panels.")
      if( is.null(AllVintages(con1))) stop("Bad result. wfs has vintages.")
      ids <- cbind(ids, ids)
      eq   <- TScompare(ids, con1, con2, na.rm=FALSE)
      print(summary(eq))
      eqrm <- TScompare(ids, con1, con2, na.rm=TRUE)
      print(summary(eqrm))
  
      cat("**************        disconnecting ets\n")
      dbDisconnect(con1)
      #dbDisconnect(con2)
      }
}
