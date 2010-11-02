require("TSgetSymbol")
cat("************** TSgetSymbol  Examples ******************************\n")

con <- TSconnect("getSymbol", dbname="FRED") 

#monthly
x <- TSget("CPIAUCNS", con) 
plot(x)
tfplot(x)

TSdescription(x) 

options(TSconnection=con)

#quarterly
x2 <- TSget("CDSP")
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

#Q dates on these are month-day, and frequency is wrong

x <- TSget(c("TDSP","FODSP"), con, 
       names=c("Household Debt Service Payments as a Percent of Disposable Personal Income",
               "Household Financial Obligations as a percent of Disposable Personal Income"))
tfplot(x)
TSdescription(x) 

yahoo <- TSconnect("getSymbol", dbname="yahoo") 

# load Ford as time series class ts. This is mts with open, close, etc
x <- TSget("F", con=yahoo)
plot(x)
tfplot(x)
