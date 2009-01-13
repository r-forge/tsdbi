z <- Sys.getenv("_R_CHECK_HAVE_ODBC_")

Sys.info()

if(identical(as.logical(z), TRUE))  require("TSodbc") else {
   cat("ODBC not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_ODBC_ setting ", z, "\n")
   }
