#  This is really a test of the getpadi standalone command, not the R
#   interface, but this is a convenient way to test. 

if(identical(as.logical(Sys.getenv("_R_CHECK_HAVE_PADI_")), TRUE)) {

  require("TSpadi") 

  Sys.info()
  Sys.getenv()["PATH"]
  Sys.getenv()["PADI"]

  pwd <- getwd() 
  scratch.db <- "zot123456b.db"
  fqpscratch.db <- paste(pwd,"/",scratch.db, sep="")
  unlink(scratch.db, recursive = TRUE)

  wait.for.server.to.terminate <- function(server)
    {# wait to ensure padi server is terminated
     for (i in 1:60)
       {if (!checkPADIserver(server)) break
        Sys.sleep(2)
       }
    }

  wait.for.server.to.start <- function(server)
    {# wait to ensure padi server is started
     for (i in 1:30)
       {if (checkPADIserver(server)) break
        Sys.sleep(1)
       }
    }

  server <- PADIserver()
  wait.for.server.to.terminate(server)
  if (checkPADIserver(server))
     stop("A server is already running. Testing stopped. Use cleanupPADIserver() or killPADIserver() to terminate it.")


  ok <- putpadi(ts(exp(1:20), start=c(1950,1),freq=1), series="exp", 
            server=server, server.process="simple.server",
            cleanup.script="cleanup.simple.server",
            dbname=scratch.db, start.server=TRUE)

  if (ok) cat("ok\n") else  cat("failed! putpadi and starting server\n")

  wait.for.server.to.terminate(server)

  cat("getpadi  test simple ... \n")
  
  pid <- system(paste("simple.server ", scratch.db), intern = TRUE)
  cat("      pid: ", pid, "\n")
  z <- system(paste("getpadi ", server," exp", scratch.db), intern = TRUE)
  cat("      getpadi system return message: ", z, "\n")  
  z <- system(paste("cleanup.simple.server ", pid), intern = TRUE)
  cat("      cleanup.simple.server system return message: ", z, "\n")  


if (checkPADIserver("ets"))
 {cat("getpadi  test ets ... ")
  z <- system(paste("getpadi ets B2001"), intern = TRUE)
  cat("      getpadi ets B2001 system return message: ", z, "\n")  
 }

} else  cat("PADI not available. Skipping tests.")
