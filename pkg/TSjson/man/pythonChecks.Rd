\name{pythonRequirementsTests}
\alias{findPython2cmd}
\alias{checkPython}
\alias{checkForPythonModule}

\title{Functions to Check Python and Python Module Availability}
\description{Functions to find the command for python, check the  python 
version, and check availability of python modules.}
\usage{
     findPython2cmd()
     checkPython(CMD, majorVersion)
     checkForPythonModule(CMD, module)
}
\arguments{
    \item{CMD}{a character string.}
    \item{majorVersion}{a number (2 or 3).}
    \item{module}{a character string.}
}
\value{Depends.}
\details{
The function \code{findPython2cmd} checks various possibilities to determine
a command to execute Python version 2. The first check is the environment variable \code{PYTHON2}, followed by the environment variable \code{PYTHON}.
If the second finds a version that is not 2 then it is ignored.
If neither of these result in a successful Python 2 command then system
commands "python2 -V" and "python -V" are attempted. If a valid Python 2
command is found the the character string representing the command is returned.
Otherwise an error is indicated.

The function \code{checkPython} returns \code{TRUE} if \code{CMD} gives a 
Python with the major version as specified by \code{majorVersion} and
\code{FALSE} otherwise. (\code{majorVersion} would typically be 2 or 3.)

The function \code{checkForPythonModule} returns \code{TRUE} if the python
indicate by \code{CMD} can load a module as specified by the string \code{module} and returns \code{FALSE} otherwise. 
}
\seealso{ 
\code{\link{TSconnect}}
}
\examples{
  require("TSjson")
  CMD <- findPython2cmd()
  checkPython(CMD, 2)
  checkPython(CMD, 3)
  checkForPythonModule(CMD, "system") # this should always be available
}
