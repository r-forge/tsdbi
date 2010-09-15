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

   if (!inherits(con1, "try-error") & !inherits(con2, "try-error")) {
      ids <- AllIds(con1)
      if(!is.null(AllPanels(con1)))   stop("Bad result. ets does not have panels.")
      if(!is.null(AllVintages(con1))) stop("Bad result. ets does not have vintages.")
      ids <- cbind(ids, ids)
      eq   <- TScompare(ids, con1, con2, na.rm=FALSE)
save.image("etsCheck1.RData")
      print(summary(eq))
      eqrm <- TScompare(ids, con1, con2, na.rm=TRUE)
save.image("etsCheck2.RData")
      print(summary(eqrm))
  
      cat("**************        disconnecting ets\n")
      dbDisconnect(con1)
      #dbDisconnect(con2)
      }
}
