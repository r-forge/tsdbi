z <- loadedNamespaces()

unloadNamespace("tseries") # loads zoo ?

#if (!all(z == loadedNamespaces())
#    stop("unloading a not loaded namespace is changing loadedNamespaces.")

require("RMySQL")
require("RPostgreSQL")
unloadNamespace("RMySQL")
unloadNamespace("RPostgreSQL")

require("TSmisc")
require("TSjson")
unloadNamespace("TSmisc")
unloadNamespace("TSjson")

require("TSmisc")
require("TSSQLite")
unloadNamespace("TSmisc")
unloadNamespace("TSSQLite")

require("TSmisc")
require("TSPostgreSQL")
unloadNamespace("TSPostgreSQL")
unloadNamespace("TSmisc")

require("TSmisc")
require("TSMySQL")
unloadNamespace("TSmisc")
unloadNamespace("TSMySQL")

require("TSMySQL")
require("TSSQLite")
unloadNamespace("TSMySQL")
unloadNamespace("TSSQLite")

require("TSMySQL")
require("TSPostgreSQL")

# next failing with  argument "where" is missing, with no default 
#  as of Jan 2015,  R-devel, new MySQL 0.10, 2015,1-1 versions of TS* ready for release
#  R Under development (unstable) (2015-01-02 r67308) -- "Unsuffered Consequences"
#  Platform: x86_64-unknown-linux-gnu (64-bit)
#unloadNamespace("TSMySQL")
#unloadNamespace("TSPostgreSQL")

#detach("package:TScompare", unload=TRUE)
#detach("package:TSmisc", unload=TRUE)
#detach("package:TSjson", unload=TRUE)
#detach("package:WriteXLS", unload=TRUE)
