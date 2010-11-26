# test that the fame package is working with a server

#  (at BoC I need environment  export FAME=/apps/fame92r2 ) for fame
# export FAME=/apps/fame92r2

if(identical(as.logical(Sys.getenv("_R_CHECK_HAVE_FAME_")), TRUE)) {

 # require("tis")

cat("***********   test fame server (ets)\n")

  require("fame")

  if(!fameRunning()) fameStart(workingDB = FALSE)
 


  Id <- try(fameDbOpen("ets /home/ets/db/etsmfacansim.db", accessMode = "read"))
  if(inherits(Id, "try-error") ) 
      stop("Could not establish fameConnection to ets /home/ets/db/etsmfacansim.db")

  fameDbClose(Id) #works in 2.9-1 but fails in 2.10 without fix

cat("***********   reading from ets /home/ets/db/etsmfacansim.db\n")

   r <- getfame("V122646", db="ets /home/ets/db/etsmfacansim.db", save = FALSE, 
             envir = parent.frame(),
             start = NULL, end = NULL, getDoc = FALSE)[[1]]

cat("***********   reading from ets /home/ets/db/etsmfacansim.db using con\n")
 
  # using this con requires R package fame 2.10 with fix 
  con <- fameConnection(service = "2959", 
     host = "ets", user = "", password = "", stopOnFail = TRUE)

   r2 <- getfame("V122646", db="/home/ets/db/etsmfacansim.db",
      connection=con, save = FALSE, 
             envir = parent.frame(),
             start = NULL, end = NULL, getDoc = FALSE)[[1]]
 

} else  cat("FAME not available. Skipping tests.")
