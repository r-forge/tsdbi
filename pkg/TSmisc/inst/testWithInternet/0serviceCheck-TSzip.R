#not sure what to check here

service <- Sys.getenv("_R_CHECK_HAVE_PERL_")

Sys.info()

if(identical(as.logical(service), TRUE)) {
   require("TSzip") 
 }else {
   cat("Perl libraries not available. Skipping tests.\n")
   cat("_R_CHECK_HAVE_PERL_ setting ", service, "\n")
   }
