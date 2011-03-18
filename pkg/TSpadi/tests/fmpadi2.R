# This file (previously fmpadi2.R in BOCtests) contains tests the require
#  starting a local padi server with a Fame back-end. The environement variable
#  settings that are checked will typically mean that these tests are not run.

 Sys.info()

   require("stats" )   #,      warn.conflicts=FALSE)
   require("EvalEst" )   #,    warn.conflicts=FALSE)
   require("TSpadi" )   #, warn.conflicts=FALSE)
   require("monitor" )   #, warn.conflicts=FALSE)
 DSEversion()

#   A TS PADI server is necessary for these tests.

cat("Not sure if these are still needed.\n")
Sys.getenv()["PATH"]
Sys.getenv()["PADI_LDLIB"]
Sys.getenv()["PADI_STARTUP"]
Sys.getenv()["PADI_CLEANUP"]




#############################################

#   backwards compatibility function tests

#############################################

fm.padi.function.tests <- function( verbose=TRUE, synopsis=TRUE, fuzz=1e-12,
  local.server=Sys.info()[["nodename"]], server="ets") # "bc" "padi"
{# A short set of tests for backwards compatability.

warning("Some backward compatibility tests (S to fm) may fail with RPC timeout. Setting timeout is not supported for backwards compatibility.")

  if((PADIserverProcess()  !=
            paste(Sys.getenv("PADI"), "/","fame.server",sep=""))
   | (PADIcleanupScript()  !=
            paste(Sys.getenv("PADI"), "/","cleanup.fame.server",sep="")) )
     stop("These tests require the environment variables PADI_STARTUP=fame.server and PADI_CLEANUP=cleanup.fame.server.")
 
  cat("Assuming load.padi has been executed (eg. in .First.lib)\n")
  if (synopsis & !verbose) cat("All BOC backward compatability (fm) tests...")
  all.ok <- TRUE
  max.error <- NA
  pause.for.server <- function(server)
    {# An error here like RPC: Program not registered
     #  may be because the read attempt is not waiting long enough for
     #  the last server to stop and the next server to start up.
     # To ensure padi server is terminated:
     for (i in 1:30)
       {if (!checkPADIserver(server)) break
        Sys.sleep(1)
       }
     invisible()
    }

  if (verbose) cat("S to fm test 0a... ")
  file <-paste(tempfile(),".db", sep="")
  on.exit(unlink(file))
  ok <- putfm(ts(3*exp(1:20), start=c(1900,1)), file,"exp")
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  pause.for.server(local.server)

  if (verbose) cat("S to fm test 0b... ")
  z <- getfm(file,"exp")
  error <- max(abs((z - 3*exp(1:20))))
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 1a... ")
  za <- getpadi( "I37026",server=server) # default - all data CPI
  ok <- 25 < length(za)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 1b... ")
  zb <- getfm( "etsgdpfc.db", "I37026")      #  CPI
  error <- max(abs((za - zb)))
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 2a... ")
  za <- getpadi( "I37026",server=server,            #   CPI
                starty=1988, startm=1,      # starty,startp,
                endy=1990, endm=12)         # endy,endp,
  ok <- 25 < length(za)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 2b... ")
  zb <- getfm( "/home/ets/db/etsgdpfc.db", # dbname
                "I37026",                   #   CPI
                starty=1988, startp=1,      # starty,startp,
                endy=1990, endp=12)         # endy,endp,
  error <- max(abs((za - zb)))
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 3a... ")
  za <- getpadi( "I37026",server=server,               #   CPI
                starty=1988, startm=1, 
                nobs=8)                 # nobs,
  ok <- 8 == length(za)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 3b... ")
  zb <- getfm( "etsgdpfc.db",          # dbname
                "I37026",               #   CPI
                starty=1988, startp=1,  # starty,startp,
                nobs=8)                 # nobs,
  error <- max(abs((za - zb)))
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 4a... ")
  za <- getpadi( c("B14017","B1627","I37026","B820500"),# all data. this is a formula
           server=c(server,server,server,server) ) # R90,M1,GDP,CPI
  ok <- 25 < length(za)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 4b... ")
  zb <- getfm( c("etsmfacansim.db","etsmfacansim.db","etsgdpfc.db","etscpi.db"), #dbnames
                c("B14017","B1627","I37026","B820500") ) # R90,M1,GDP,CPI
  if(sum(is.na(za)) != sum(is.na(zb)))
    {error <- NA
     ok <- FALSE
    }
  else
    {error <- max(abs((za[!is.na(za)] - zb[!is.na(zb)])))
     ok <-  fuzz > error
    }
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 5a... ")
  za <- getpadi( c("B14017","B1627"),server=server ) # default - all data R90,M1
  ok <- 25 < length(za)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 5b... ")
  zb <- getfm( "etsmfacansim.db", c("B14017","B1627") ) # R90,M1
  if(sum(is.na(za)) != sum(is.na(zb)))
    {error <- NA
     ok <- FALSE
    }
  else
    {error <- max(abs((za[!is.na(za)] - zb[!is.na(zb)])))
     ok <-  fuzz > error
    }
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 6a... ")
  za <- getpadi( "B820500", server=server) # default - all data - this is a formula
  ok <- 25 < length(za)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 6b... ")
  zb <- getfm("etscpi.db", "B820500")	# this is a formula
  if(sum(is.na(za)) != sum(is.na(zb)))
    {error <- NA
     ok <- FALSE
    }
  else
    {error <- max(abs((za[!is.na(za)] - zb[!is.na(zb)])))
     ok <-  fuzz > error
    }
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }


  if (verbose) cat("S to fm test 7a... ")
  za <- getpadi( "B820500", server=server,       # this is a formula
	    starty = 1988, startm = 1, nobs = 8) # nobs
  ok <- 8 == length(za)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  if (verbose) cat("S to fm test 7b... ")
  zb <- getfm("etscpi.db", "B820500", 	# this is a formula
	starty = 1988, startp = 1, nobs = 8)	# nobs
  if(sum(is.na(za)) != sum(is.na(zb)))
    {error <- NA
     ok <- FALSE
    }
  else
    {error <- max(abs((za[!is.na(za)] - zb[!is.na(zb)])))
     ok <-  fuzz > error
    }
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

# note: vectors and matrices do not work (as start=c(1,1) which
#        Fame does not like).
# alternate fix
#	if(starty == 1) freq <- 232	# starty=1 is only valid for vectors
# has not been tried.

 if (verbose) cat("S to fm test 8a... ")
  za <- putpadi(ts(.2*(1:100), start=c(1900,1)), dbname=file, series="tseries1") #ts
  error <- 25 < length(za)
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  pause.for.server(server)

  if (verbose) cat("S to fm test 8b... ")
  ok <- putfm(ts(.2*(1:100), start=c(1900,1)),file, "tseries1") #ts
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  pause.for.server(server)

  if (verbose) cat("S to fm test 9a... ")
  #tsmatrix with names
  # tbind was previously tsmatrix
  mat <-tbind(.1*(1:100),.2*(1:100),.3*(1:100))
  mat <- ts(mat,start=c(1900,1),names=c("tsmat1","tsmat2","tsmat3"))
  za <- putpadi(mat,dbname=file) 
  error <- 25 < length(za)
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  pause.for.server(server)

  if (verbose) cat("S to fm test 9b... ")
  ok <-  all( putfm(mat,file, c("tsmat1","tsmat2","tsmat3")) )
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  pause.for.server(server)
 
  if (verbose) cat("S to fm test 10a... ")
  mat <- ts(mat,start=c(1900,1), frequency=4, names=c("tsmat1","tsmat2","tsmat3"))
  za <- putpadi(mat,dbname=rep(file,3)) 
  error <- 25 < length(za)
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  pause.for.server(server)

  if (verbose) cat("S to fm test 10b... ")
  ok <- all( putfm(mat,rep(file,3), c("tsmat1","tsmat2","tsmat3")) )
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  pause.for.server(server)

  if (verbose) cat("S to fm test 11a... ")
  z <-putpadi(mat,dbname=rep(file,3)) 
  pause.for.server(server)
  z <- getpadi(c("tsmat1","tsmat2","tsmat3"),dbname=file)
  error <- max(abs(mat - z))
  ok <-  fuzz > error
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }

  pause.for.server(server)

  if (verbose) cat("S to fm test 11b... ")
  ok <- all( putfm(mat,rep(file,3), c("tsmat1","tsmat2","tsmat3")) )
  pause.for.server(server)
  z <- getfm(file,c("tsmat1","tsmat2","tsmat3"))
  error <- max(abs((mat - z)))
  ok <-  ok & (fuzz > error)
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed!\n")
    }


  if (synopsis) 
    {if (verbose) cat("All BOC backward compatability (fm) tests completed")
     if (all.ok) cat(" ok\n\n")
     else    cat(", some failed! (max. error magnitude= ", max.error,")\n")
    }
  invisible(all.ok)
}

#  An RPC timeout sometimes happens in the fm tests above, but backward 
#      compatiability cannot support timeout.
#   troll.function.tests(verbose=FALSE)
# backward tests are not being kept up and may fail.


#  backward compatable FAME access using PADI


# This is a kludge that relies on the environment variable PADI_STARTUP,
# returned by PADIserverProcess() to being set to indicate "fame.server"
# on my Solaris machines where fame.server can be started locally.
if ( ! (require("TSpadi") && ("fame.server" == PADIserverProcess() ))) 
    warning("Warning: skipping tests that require local fame server.") else {
   fm.padi.function.tests(verbose=TRUE)
   }
