
require("TSQuandl")
require("tfplot")

cat("**************        connecting to Quandl\n")

con <- TSconnect("Quandl", dbname="BOC")
 
x <- TSget("CDA_CPI", con)

tfplot(x)

z <- TSget("CDA_CPI", con, TSrepresentation="zoo")
