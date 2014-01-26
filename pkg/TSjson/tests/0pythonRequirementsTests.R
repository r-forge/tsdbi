
# findPython2cmd checks  in order
#   env variable  PYTHON2
#   env variable  PYTHON
#   sys command   python2
#   sys command   python
# to establish command, then check for modules

require("TSjson")

CMD <- findPython2cmd()


if (!checkPython(CMD, 2)) stop("python 2 is not available.")

#checkPython(CMD, 3)

missing <- NULL
ok <- TRUE

if (!checkForPythonModule(CMD, "urllib2")) {
  ok <- FALSE
  missing <- c(missing, "urllib2")
  }

if (!checkForPythonModule(CMD, "re")) {
  ok <- FALSE
  missing <- c(missing, "re")
  }

if (!checkForPythonModule(CMD, "csv")) {
  ok <- FALSE
  missing <- c(missing, "csv")
  }

if (!checkForPythonModule(CMD, "mechanize")) {
  ok <- FALSE
  missing <- c(missing, "mechanize")
  }

if (!checkForPythonModule(CMD, "json")) {
  ok <- FALSE
  missing <- c(missing, "json")
  }

if (!ok) stop("missing python modules: ", paste(missing, collapse =" "))
