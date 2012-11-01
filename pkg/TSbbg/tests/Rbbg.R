# test that the bbg package is working

# might need env variable to find ddl
# export bbg=/apps/bbg

if(identical(as.logical(Sys.getenv("_R_CHECK_HAVE_RBBG_")), TRUE)) {


cat("**************        connecting Bloomberg\n")

  require("Rbbg")

  conn <-  try(blpConnect(verbose=FALSE))

  if(inherits(conn, "try-error") ) 
      stop("Could not establish TSbbgConnection.")

cat("**************        extractin from Bloomberg\n")

  x  <- bdh(conn, "USCRWTIC Index", "PX_LAST", "20020101")

  xp <- bdp(conn, "EUAPEA Index",  c("NAME","LAST_UPDATE_DT","TIME"))

} else  cat("Rbbg not available. Skipping tests.")
