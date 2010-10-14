service1 <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")
service2 <- Sys.getenv("_R_CHECK_HAVE_PADI_")

save.image("etsCheck0.RData")

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
save.image("etsCheck0a.RData")
      ids1 <- ids[1:100000,]
      ids11 <- ids[1:10000,]
      ids12 <- ids[10001:20000,]
      ids13 <- ids[20001:30000,]
      ids14 <- ids[30001:40000,]
      ids15 <- ids[40001:50000,]
      ids16 <- ids[50001:60000,]
      ids17 <- ids[60001:70000,]
      ids18 <- ids[70001:80000,]
      ids19 <- ids[80001:90000,]
      ids110 <- ids[90001:100000,]
      ids12 <- ids[10001:20000,]
      ids2 <- ids[100001:200000,]
      ids3 <- ids[200001:300000,]
      ids4 <- ids[300001:400000,]
      ids5 <- ids[400001:500000,]
      ids6 <- ids[500001:631960,]

 save.image("etsCheck0b.RData")
     eq1   <- TScompare(ids11, con1, con2, na.rm=FALSE)
     eq2   <- TScompare(ids12, con1, con2, na.rm=FALSE)
     eq3x   <- TScompare(ids13, con1, con2, na.rm=FALSE) # error
     eq4   <- TScompare(ids14, con1, con2, na.rm=FALSE)
     eq5   <- TScompare(ids15, con1, con2, na.rm=FALSE) #warnings to check
     eq6   <- TScompare(ids16, con1, con2, na.rm=FALSE)
     eq7   <- TScompare(ids17, con1, con2, na.rm=FALSE)
     eq8   <- TScompare(ids18, con1, con2, na.rm=FALSE)
     eq9   <- TScompare(ids19, con1, con2, na.rm=FALSE)
     eq10   <- TScompare(ids110, con1, con2, na.rm=FALSE)

 save.image("etsCheck0c.RData")

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
