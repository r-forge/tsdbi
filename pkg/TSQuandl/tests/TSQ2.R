require("tfplot")
require("TSQuandl")

cat("**************        connecting to Quandl\n")

con <- TSconnect("Quandl", dbname="NSE") 

  x  <- TSget("OIL", con, start=as.Date("2001-01-01"))
  x  <- TSget("OIL", con, start="2002-01-01", quote="Close")

  start(x)
  end(x)
  
  tfplot(x, graphs.per.page=3)

dbDisconnect(con)
