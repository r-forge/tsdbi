z <- Sys.getenv("_R_CHECK_HAVE_POSTGRES_")

Sys.info()

if(identical(as.logical(z), TRUE))  require("TSPostgreSQL") else {
   cat("POSTGRES not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_POSTGRES_ setting ", z, "\n")
   }
