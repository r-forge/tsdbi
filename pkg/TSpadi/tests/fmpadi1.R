# This file (previously fmpadi1.R in BOCtests) contains tests the require
#  starting a local padi server with a Fame back-end. The environement variable
#  settings that are checked will typically mean that these tests are not run.

 require("TSpadi")
 Sys.info()

cat("Not sure if these are still needed.\n")
Sys.getenv()["PATH"]
Sys.getenv()["PADI_STARTUP"]
Sys.getenv()["PADI_CLEANUP"]


padi.function.tests.fame <- function( verbose=TRUE, synopsis=TRUE, fuzz=1e-6, 
          scratch.db="zot123456.db")
{# A short set of tests for the S TS PADI client interface
  cat("Assuming load.padi has been executed (eg. in .First.lib)\n")
#  PUBLIC mode fame.server (Fame test 3) does not work with a fully qualified
#     path name (so among other thing tempfile() cannot be used for scratch.db.

#  Note: Sys.getenv()["PWD"] does not work if the run.tests script is run from a sh
#   script in another directory if cd is aliased, so the following is better:
  pwd <- system("pwd", intern=TRUE)
  fqpscratch.db <- paste(pwd,"/",scratch.db, sep="")
  unlink(scratch.db)
  unlink(fqpscratch.db)

  server <- Sys.info()[["nodename"]]
  if (checkPADIserver(server))
     stop("A server is already running. Testing stopped. Use cleanupPADIserver() or killPADIserver() to terminate it.")

  wait.for.server.to.terminate <- function(server)
    {# wait to ensure padi server is terminated
     for (i in 1:30)
       {if (!checkPADIserver(server)) break
        Sys.sleep(1)
       }
    }

  wait.for.server.to.start <- function(server)
    {# wait to ensure padi server is terminated
     for (i in 1:30)
       {if (checkPADIserver(server)) break
        Sys.sleep(1)
       }
    }


#    FAME server tests

  if (synopsis & !verbose) cat("All S to fame.server padi tests ...")
  all.ok <- TRUE
  max.error <- NA

  if (checkPADIserver(server))
     stop("A server is already running. Testing stopped. Use cleanupPADIserver() or killPADIserver() to terminate it.")

  if (verbose) cat("S to fame.server padi test 1a... ")
  ok <- putpadi(ts(exp(1:20), start=c(1950,1),freq=1), series="exp", 
            server=server, server.process="fame.server",
            cleanup.script="cleanup.fame.server",
            dbname=scratch.db, start.server=TRUE)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed! putpadi and starting server\n")
    }

  wait.for.server.to.terminate(server)

  if (verbose) cat("S to fame.server padi test 1b... ")
  ok <- putpadi(ts(exp(1:20), start=c(1950,1),freq=1), series="exp", 
            server=server, server.process="fame.server",
            cleanup.script="cleanup.fame.server",
            dbname=fqpscratch.db, start.server=TRUE)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed! putpadi and starting server\n")
    }

  wait.for.server.to.terminate(server)

  if (verbose) cat("S to fame.server padi test 2 ... ")
  z <- getpadi("exp",server=server, server.process="fame.server",
                  cleanup.script="cleanup.fame.server",
                  dbname=scratch.db, start.server=TRUE)
  error <- max(abs((z - exp(1:20))))
  ok <-  fuzz > error
  ok <- ok & (frequency(z) == 1) & all(start(z) == c(1950,1))
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed! getpadi and starting server\n")
    }

  wait.for.server.to.terminate(server)

  #       simulated shared database ie. a public mode server
  # (this is not the way one would normally set up a public mode server)

warning("skipping shared mode public server tests which broke in March 2002.")
#(actually may have been broken before, but re-org finally pointed out problem?)
if (FALSE) {
 if (verbose) cat("S to fame.server padi test 3 ... ")
  pid <- startPADIserver(server=server, dbname="", 
                 server.process=paste("fame.server ", scratch.db, " UPDATE public"))
  on.exit(cleanupPADIserver(pid, cleanup.script="cleanup.fame.server"))

  wait.for.server.to.start(server)

  ok <- putpadi(ts(2*exp(1:20), start=c(1950,2),freq=4), series="exp2", 
            server=server,  server.process="fame.server",
            cleanup.script="cleanup.fame.server",
            dbname=scratch.db, start.server=FALSE)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n")
     else  cat("failed! putpadi server started\n")
    }

  if (verbose) cat("S to fame.server padi test 4 ... ")
  z <- getpadi("exp2",server=server,  server.process="fame.server",
               cleanup.script="cleanup.fame.server",
               dbname=" ", start.server=FALSE)
  error <- max(abs((z - 2*exp(1:20))))
  ok <-  fuzz > error
  ok <- ok & (frequency(z) == 4) & all(start(z) == c(1950,2))
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n") else  cat("failed! getpadi server started\n") }

 if (verbose) cat("S to fame.server padi test 5 ... ")
  ok <- putpadi(ts(-3*exp(1:20), start=c(1950,10),freq=52), dbname=scratch.db, 
                series="exp3", server=server, 
                server.process="fame.server", 
                cleanup.script="cleanup.fame.server",
                start.server=FALSE, warn=FALSE)
  all.ok <- all.ok & ok
  if (verbose) 
    {if (ok) cat("ok\n") else cat("failed! putpadi (calling putpadi)\n")}

  if (verbose) cat("S to fame.server padi test 6 ... ")
  z <- getpadi("exp3",server=server, server.process="fame.server",
                    cleanup.script="cleanup.fame.server",
                    dbname="", start.server=FALSE, warn=FALSE)
  error <- max(abs((z + 3*exp(1:20))))
  ok <-  fuzz > error
  ok <- ok & (frequency(z) == 52) & all(start(z) == c(1950,10))
  if (!ok) {if (is.na(max.error)) max.error <- error
            else max.error <- max(error, max.error)}

  cleanupPADIserver(pid, cleanup.script="cleanup.fame.server")
}
  on.exit()
  unlink(scratch.db)
  unlink(fqpscratch.db)

  all.ok <- all.ok & ok
  if (verbose) {if(ok) cat("ok\n") else cat("failed! getpadi server started\n")}

  if (synopsis) 
    {if (verbose) cat("All S to fame.server padi tests completed")
     if (all.ok) cat(" OK\n")
     else    cat(", some FAILED! max.error = ", max.error,")\n")
    }

  invisible(all.ok)
}


# This is a kludge that relies on the environment variable PADI_STARTUP,
# returned by PADIserverProcess() to being set to indicate "fame.server"
# on my Solaris machines where fame.server can be started locally.
if ( ! (require("TSpadi") && ("fame.server" == PADIserverProcess() ))) 
    warning("Warning: skipping tests that require local fame server.") else {
 padi.function.tests.fame() 
 }
