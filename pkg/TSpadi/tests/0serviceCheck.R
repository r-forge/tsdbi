z <- Sys.getenv("_R_CHECK_HAVE_PADI_")

Sys.info()

if(identical(as.logical(z), TRUE))  require("TSpadi") else {
   cat("PADI not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_PADI_ setting ", z, "\n")
   }
