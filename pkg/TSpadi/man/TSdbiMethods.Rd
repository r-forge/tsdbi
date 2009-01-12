\name{padi}
\alias{padi}
\alias{TSconnect,padiDriver,character-method}
\alias{TSget,character,TSpadiConnection-method}
\alias{TSput,ANY,character,TSpadiConnection-method}
\alias{TSdates,character,TSpadiConnection-method}
\alias{TSdescription,character,TSpadiConnection-method}
\alias{TSdoc,character,TSpadiConnection-method}
\alias{TSlabel,character,TSpadiConnection-method}

\alias{padiDriver-class}
\alias{TSpadiConnection-class}

\title{padi Methods for TSdbi Generics}
\description{Get a time series matrix structure from a database}
\usage{
     padi() 
    \S4method{TSget}{character,TSpadiConnection}(serIDs, con, names=serIDs, ...)
    \S4method{TSput}{ANY,character,TSpadiConnection}(x, serIDs=seriesNames(data), con, ...)   
    \S4method{TSconnect}{padiDriver,character}(drv, dbname, 
               user=NULL, password = NULL, host="", timeout=60, ...)
    \S4method{TSdates}{character,TSpadiConnection}(serIDs, con, ... )  
    \S4method{TSdescription}{character,TSpadiConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSpadiConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSpadiConnection}(x, con, ... )  
}
\arguments{
    \item{con}{a database connection object.}
    \item{serIDs}{identifiers for series on the database.}
    \item{x}{time series data(TSput), or 
      identifiers for series on the database (TSdoc and TSdescription).}
    \item{names}{optional character vector to use for series names in the R
    object.}
    \item{drv}{a database driver object.}
    \item{dbname}{a character string indicating the name of a database.}
    \item{user}{a character string indicating a user id.}
    \item{password}{a character string indicating a password.}
    \item{host}{a character string indicating a host computer.}
    \item{timeout}{time in seconds to wait for host to respond.}
    \item{...}{Arguments passed to getpadi or putpadi.}
}
\value{Depends.}
\details{
These functions interface with a Fame database using the padi protocol. 
It is usually better to pass host/user/password information using a
configuration file rather than as arguments. \code{TSconnect} will look
for a file \code{.padi.cfg} in the user's home directory.

The classes \code{padiDriver} and \code{TSpadiConnection} extend classes
\code{DBIDriver} and  \code{DBIConnection} in the DBI package.

 \code{TSput.padi} is not working.
}

\seealso{ 
\code{\link[TSdbi]{TSdates}},
\code{\link[TSdbi]{TSget}},
\code{\link[TSdbi]{TSput}}
}
\examples{
  if (require("padi")){
    library()  # debugging to see where padi is found if this fails
    #m <- dbDriver("padi")
    m <- padi()
    con <- try(TSconnect(m, dbname="ets"))
    if(! inherits(con, "try-error")) {
      print(con)
      TSdates(c("B1630", "B1642", "D1"), con)
      z1 <- TSget(c("B1630", "B1642"), con)
      TSmeta(z1)
      }
    }
  }
\keyword{ts}