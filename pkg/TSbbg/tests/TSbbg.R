#  To find dll might need something like  
# export bbg=/apps/bbg

require("tfplot")

if(identical(as.logical(Sys.getenv("_R_CHECK_HAVE_RBBG_")), TRUE)) {

require("Rbbg") ## should not need this when Rbbg is in Depends
require("TSbbg")

cat("**************        connecting to Bloomberg\n")

con <- TSconnect("bbg") 

cat("**************    bdh() call  examples\n")

  x  <- TSget("USCRWTIC Index", con, start=as.Date("2001-01-01"))
  x  <- TSget("USCRWTIC Index", con, start="2002-01-01")

  start(x)
  end(x)
  
  tfplot(x)

dbDisconnect(con)

} else  cat("Rbbg not available. Skipping tests.")
