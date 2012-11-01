z <- Sys.getenv("_R_CHECK_HAVE_BBG_")

Sys.info()

if(identical(as.logical(z), TRUE))  {
     require("Rbbg") 
     conn <-  try(blpConnect(verbose=FALSE))

     if(inherits(conn, "try-error") ) 
        stop("Could not establish TSbbgConnection.")
   } else {
     cat("Rbbg not available. Skipping tests.\n")
     cat("_R_CHECK_HAVE_BBG_ setting ", z, "\n")
   }
