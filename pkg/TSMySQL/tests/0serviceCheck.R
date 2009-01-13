z <- Sys.getenv("_R_CHECK_HAVE_MYSQL_")

Sys.info()

if(identical(as.logical(z), TRUE))  require("TSMySQL") else {
   cat("MYSQL not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_MYSQL_ setting ", z, "\n")
   }
