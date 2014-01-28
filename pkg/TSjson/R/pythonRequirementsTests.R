
findPython2cmd <- function() {
  CMD <- NULL
  if      ("" != Sys.getenv("PYTHON2")) CMD <- Sys.getenv("PYTHON2")
  else if ("" != Sys.getenv("PYTHON" )) CMD <- Sys.getenv("PYTHON")

  # continue looking if this is not Python 2
  r <- try(system(paste(CMD, "-V 2>&1"), intern=TRUE), silent=TRUE)

  if(inherits(r, "try-error"))    CMD <- NULL
  else if (!grepl("Python 2", r)) CMD <- NULL

  if (is.null(CMD)){

     r <- try(system("python2 -V", ignore.stderr=TRUE), silent=TRUE)

     if(!inherits(r, "try-error") && (0 == r))    CMD <- "python2"
     else {
       r <- try(system("python  -V", ignore.stderr=TRUE), silent=TRUE)
       if (!inherits(r, "try-error") && (0 == r)) CMD <- "python"
       }

     if (is.null(CMD)) stop("Python not found.",
        "Check shell command path or set environment variable PYTHON2.")

     # confirm this is really Python 2
     r <- try(system(paste(CMD, "-V 2>&1"), intern=TRUE), silent=TRUE)
     if(inherits(r, "try-error") ){
       cat(r, "\n")  
       stop(CMD, " is now failing. Internal error in findPython2cmd.")
       }

     if (! grepl("Python 2", r )){
        cat("failed Python 2 check using CMD=", CMD, "-V 2>&1\n")
        stop(CMD, "does not find Python 2.",
         "Check shell command path or set environment variable PYTHON2.")
	}
     }

  CMD
  }


checkPython <- function(CMD, majorVersion) {
    # This check uses CMD to specify python and code
    #    TSjson/exec/checkForPython.py, rather than "python -V"
    # It checks that python runs and has majorVersion (2 or 3)
    
    # It should return TRUE or FALSE with an attribute giving a message.

    # examples
    # checkPython("pythonNot", 2)
    # checkPython("python", 2)
    # checkPython("python3", 3)
    # checkPython("python2", 3)

    qq <- paste(CMD,
      "/home/paul/qc/TSjson/exec/checkForPython.py", majorVersion)
    rr <- try(system(qq, intern=TRUE))
    
    if (inherits(rr , "try-error")){
       r <- FALSE
       attr(r, "message") <- paste(shQuote(CMD), "execution failed.")
       }
    else {
       r <- grepl("^exit=0", rr)
       attr(r, "message") <- rr
       }
    r
    }


checkForPythonModule <- function(CMD, module){
    # This check uses CMD to specify python and code
    #    TSjson/exec/pythonModuleTest.py
    # It returns TRUE or FALSE indicating if the module is available.

    # examples
    # checkPython("python", "sys")
    # checkPython("python2", "mechanize")

    qq <- paste(CMD, "/home/paul/qc/TSjson/exec/pythonModuleTest.py", module)
    rr <- try(system(qq, intern=TRUE))
    
    if (inherits(rr , "try-error")){
       r <- FALSE
       attr(r, "message") <- paste(shQuote(CMD), "execution failed.")
       }
    else {
       r <- grepl("^exit=0", rr)
       }
    r
    }

