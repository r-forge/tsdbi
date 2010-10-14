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
       if ("" == host1)     host <- Sys.info()["nodename"] 
       passwd1  <- Sys.getenv("MYSQL_PASSWD")
       if ("" == passwd1)   passwd1 <- NULL
     }

   con1 <- if ("" != user1)  
            tryCatch(TSconnect("MySQL", dbname="ets", username=user1, password=passwd1, host=host)) 
      else  tryCatch(TSconnect("MySQL", dbname="ets")) # pass user/passwd/host in ~/.my.cnf


   user2    <- Sys.getenv("PADI_USER")
    
   con2 <-  if ("" != user2) 
            try(TSconnect("padi", dbname="ets", username=user, password=passwd, host=host)) 
       else try(TSconnect("padi", dbname="ets")) # pass user/passwd/host in ~/.padi.cfg

   cat("**************     connections tried\n")

   if (!inherits(con1, "try-error") & !inherits(con2, "try-error")) {
      cat("**************      testing AA_BBB_SPREAD and AA_MID\n")
      ids <- matrix(c("AA_BBB_SPREAD", "AA_BBB_SPREAD", "AA_MID", "AA_MID"),2,2)
      eq   <- TScompare(ids, con1, con2, na.rm=FALSE)
      print(summary(eq))
      eqrm <- TScompare(ids, con1, con2, na.rm=TRUE)
      print(summary(eqrm))
  
      cat("**************        disconnecting ets\n")
      dbDisconnect(con1)
      #dbDisconnect(con2)
      }
}
