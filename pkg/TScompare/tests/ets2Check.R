# compare two databases on the same server

service1 <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")

if(!identical(as.logical(service1), TRUE)) {
   cat("MYSQL not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_MYSQL_ setting ", service1, "\n")
 } else  {

   require("TScompare")
   require("TSMySQL")

   user1    <- Sys.getenv("MYSQL_USER")
   if ("" != user1) {
       # specifying host as NULL or "localhost" results in a socket connection
       host1    <- Sys.getenv("MYSQL_HOST")
       if ("" == host1)     host1 <- Sys.info()["nodename"] 
       passwd1  <- Sys.getenv("MYSQL_PASSWD")
       if ("" == passwd1)   passwd1 <- NULL
     }

   con1 <- {if ("" != user1)  
            tryCatch(TSconnect("MySQL", dbname="etsv", username=user1, password=passwd1, host=host1)) 
      else  tryCatch(TSconnect("MySQL", dbname="etsv")) # pass user/passwd/host in ~/.my.cnf
      }
    
   con2 <-  {if ("" != user1) 
            try(TSconnect("MySQL", dbname="etsv2", username=user, password=passwd, host=host1)) 
       else try(TSconnect("MySQL", dbname="etsv2")) 
      }

   if (!inherits(con1, "try-error") & !inherits(con2, "try-error")) {
      ids <- AllIds(con1)
      #length(ids)
      #[1] 645813  with Nov 11, 2011 data snap
      if(!is.null(AllPanels(con1)))  stop("Bad result. etsv should not have panels.")
      if(is.null(AllVintages(con1))) stop("Bad result. etsv should have vintages.")
      ids <- cbind(ids, ids)

        save.image("etsCheck0b.RData")
        # This had errors because zoo tf returned by sql causes failure when 
	#  compare with ts tf returned by padi for weekly data: 
	#    Error in if (tf[3] != fr) stop("frequencies must be that same.") :
	#  These are now 
	#  returned as FALSE in tfwindow comparison.
	eq3x   <- TScompare(ids13, con1, con2, na.rm=FALSE) # errors
        print(summary(eq3x))
        eq5   <- TScompare(ids15, con1, con2, na.rm=FALSE) #warnings to check
        print(summary(eq5))

        save.image("etsCheck0c.RData")
	}

   ids <- ids[1:100,] # nice to do all, but too slow for regular build

#quick test
#eq   <- TScompare(ids[1:10,], con1, con2, na.rm=FALSE)
#print(summary(eq))
#eqd <- doubleCheck(eq, con1, con2, fuzz=1.1) 
#print(summary(eqd))
     
# comparing ets from Sun and Intel (Linux) 2011_11_11, the diff of meta is ok:
#~/DBs/BUILD:diff etsV.mysql.etsv/loadTables/FLAGS/2011_11_11/csvData/Meta.csv etsV.mysql.etsv2/loadTables/FLAGS/2011_11_11/csvData/Meta.csv  | wc
#    0       0       0
      eq   <- TScompare(ids, con1, con2, na.rm=FALSE)#started Fri pm
      # still running Tues am
      print(summary(eq))
      eqrm <- TScompare(ids, con1, con2, na.rm=TRUE)
      print(summary(eqrm))

      #eq1 <- TScompare(ids[1:100000,], con1, con2, na.rm=FALSE)#start Tues 10am
      # done Wed am
      print(summary(eq1))
      tfplot(eq1, con1, con2)
eq1d <- doubleCheck(eq1, con1, con2, fuzz=1.1) # about 15 min
      print(summary(eq1d))
      tfplot(eq1d, con1, con2, diff=TRUE)
z <- tfDetails(eq1d, con1, con2)

      #eq2 <- TScompare(ids[100001:200000,], con1, con2, na.rm=FALSE)#start Thu 9:45am
      # 
      #print(summary(eq2))
      # 100000  of  100000 remaining have the same window.
      #  99336  of  100000 remaining have the same window and values.
      #eq2d <- doubleCheck(eq2, con1, con2, fuzz=1.1) 
      #print(summary(eq2d)) 
      # 100000  of  100000 remaining have the same window.
      #  99912  of  100000 remaining have the same window and values.
      tfplot(eq2d, con1, con2, diff=TRUE)
tfplot(TSget("QA170899", con1), TSget("QA170899", con2))    
tfplot(TSget("QA170899", con1) - TSget("QA170899", con2)) # 100 ~2005 
z <- tfDetails(eq2, con1, con2)
z
      #eq3 <- TScompare(ids[200001:300000,], con1, con2, na.rm=FALSE, fuzz=1.1)#start Thu 9:48am
      #print(summary(eq3)) all ok
 
      #eq4 <- TScompare(ids[300001:400000,], con1, con2, na.rm=FALSE, fuzz=1.1)#start Wed pm
      #print(summary(eq4))  all ok


      # next cause a segfault crash, inside try()
      # possibly related to server being busy, or too large?
      #eq5  <- TScompare(ids[400001:500000,], con1, con2, na.rm=FALSE, fuzz=1.1)#start Thur am
 
      # failed too
      #eq51  <- TScompare(ids[400001:450000,], con1, con2, na.rm=FALSE, fuzz=1.1)#start Thur pm
      
      # but smaller chunks worked
      #eq511 <- TScompare(ids[400001:425000,], con1, con2, na.rm=FALSE, fuzz=1.1)#start Thur pm
      #print(summary(eq511)) all ok
    
      #eq512 <- TScompare(ids[425001:450000,], con1, con2, na.rm=FALSE, fuzz=1.1)
      #print(summary(eq512)) all ok
      
      #eq52 <- TScompare(ids[450001:500000,], con1, con2, na.rm=FALSE, fuzz=1.1)#start Thur pm
      #print(summary(eq52)) all ok
      
      #eq6 <- TScompare(ids[500001:645813,], con1, con2, na.rm=FALSE, fuzz=1.1)
      #print(summary(eq6)) 145441  of  145813 remaining have the same window and values.
      #tfplot(eq6, con1, con2, diff=TRUE)
      #eq6d <- doubleCheck(eq6, con1, con2, fuzz=10.1)
      #print(summary(eq6d)) 145640  of  145813 remaining have the same window and values. 
      #eq6dd <- doubleCheck(eq6, con1, con2, fuzz=1000.1) 
      #print(summary(eq6dd))  145684  of  145813 remaining have the same window and values.
      #eq6dd <- doubleCheck(eq6, con1, con2, fuzz=1000000.1) 
      #print(summary(eq6dd))  145778  of  145813 remaining have the same window and values.
      # tfplot(eq6dd, con1, con2, diff=FALSE) these series are scale 1e13,
      # so diff is 1e6 in some cases, which is negligable
      
      cat("**************        disconnecting ets\n")
      dbDisconnect(con1)
      #dbDisconnect(con2)
      }
}
