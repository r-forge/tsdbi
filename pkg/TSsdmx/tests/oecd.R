require("TSsdmx")
cat("************** TSsdmx  Examples ******************************\n")

con <- TSconnect("sdmx", dbname="OECD") 

#monthly
x <- TSget("whatever", con) 
plot(x)
tfplot(x)

TSdescription(x) 

options(TSconnection=con)

#quarterly
x2 <- TSget("whatever")
tfplot(x2)
plot(x2)
TSdescription(x2) 

x <- TSget(c("CPIAUCNS","M2"), con)
plot(x)
tfplot(x)
TSdescription(x) 

x <- TSget(c("TOTALSL","TOTALNS"), con, 
       names=c("Total Consumer Credit Outstanding SA",
               "Total Consumer Credit Outstanding NSA"))
plot(x)
tfplot(x)
TSdescription(x) 

Q dates on these are month-day, and frequency is wrong

x <- TSget(c("TDSP","FODSP"), con, 
       names=c("Household Debt Service Payments as a Percent of Disposable Personal Income",
               "Household Financial Obligations as a percent of Disposable Personal Income"))
tfplot(x)
TSdescription(x) 

x <- TSget("ibm", quote = c("Close", "Vol"))
plot(x)
tfplot(x)
if(!all(TSrefperiod(x) == c("Close", "Vol"))) stop("TSrefperiod error, test 4.")
TSdescription(x) 

tfplot(x, xlab = TSdescription(x))
tfplot(x, Title="IBM", start="2007-01-01")

conO <- TSconnect("sdmx", dbname="yahoo") 

