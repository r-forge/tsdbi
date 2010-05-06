# test that the fame package is working through Fame Server

#  (at BoC I need environment  export FAME=/apps/fame92r2 ) for fame
# export FAME=/apps/fame92r2

if(identical(as.logical(Sys.getenv("_R_CHECK_HAVE_FAME_")), TRUE)) {

cat("**************   test fame Server\n")

  require("TSfame")

cat("**************        connecting ets fame server\n")

#con <- TSconnect("fame", dbname="ets /home/ets/db/etsintoecd.db", "read") 
#M.SDR.CCUSMA02.ST 

con <- TSconnect("fame", dbname="ets /home/ets/db/etsmfacansim.db", "read") 

if(!inherits(con, "try-error") ) {
   z <- TSget("V122646", con=con)

   if(any(start(z) != c(1969,1))) stop("Error reading seriesC.")
   tfplot(z)

   } else  cat("ets fame server not available. Skipping tests.")
 
} else  cat("FAME not available. Skipping tests.")
