\name{json}
\alias{json}
\alias{TSconnect,jsonDriver,character-method}
\alias{TSget,character,TSjsonConnection-method}
\alias{TSdates,character,TSjsonConnection-method}
\alias{TSdescription,character,TSjsonConnection-method}
\alias{TSdoc,character,TSjsonConnection-method}
\alias{TSlabel,character,TSjsonConnection-method}
\alias{TSsource,character,TSjsonConnection-method}

\alias{dbDisconnect,TSjsonConnection-method}

\alias{jsonDriver-class}
\alias{TSjsonConnection-class}

\title{Wrap getURL and fromJSON to implement methods for TSdbi Generics}
\description{Get a time series data from databases exporting series as json 
  objects. In particular, proxies to other databases such as Statisics Canada.}
\usage{
     jsonCall() 
    \S4method{TSget}{character,TSjsonConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
        TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
	quiet = TRUE, repeat.try=3, ...)
    \S4method{TSconnect}{jsonDriver,character}(
	drv, dbname, user="", password = "", host="", ...)
    \S4method{TSdates}{character,TSjsonConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSjsonConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSjsonConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSjsonConnection}(x, con, ... )  
    \S4method{TSsource}{character,TSjsonConnection}(x, con, ... )  

    \S4method{dbDisconnect}{TSjsonConnection}(conn,...)
}
\arguments{
    \item{con}{a database connection object.}
    \item{conn}{a database connection object.}
    \item{serIDs}{identifiers for series on the database.}
    \item{vintage}{character string indicating vintage of the series on the 
        database (not supported by this database).}
    \item{panel}{character string indicating panel of the series on the 
        database (not supported by this database).}
    \item{x}{time series data(TSput), or 
      identifiers for series on the database (TSdoc and TSdescription).}
    \item{names}{optional character vector to use for series names in the R
    object.}
    \item{drv}{a database driver object.}
    \item{dbname}{a character string indicating the name of a database.}
    \item{tf}{time frame for trimming data, passed to tfwindow.}
    \item{start}{time frame for trimming data, passed to tfwindow.}
    \item{end}{time frame for trimming data, passed to tfwindow.}
    \item{TSrepresentation}{time representation for returned series. 
          (See \code{TSget} in package \pkg{TSdbi}.)}
    \item{TSdescription}{logical to indicate if description shouod be retrieved.}
    \item{TSdoc}{logical to indicate if documentation shouod be retrieved.}
    \item{TSlabel}{logical to indicate if label shouod be retrieved.}
    \item{TSsource}{logical to indicate if source information shouod be retrieved.}
    \item{quiet}{logical to suppress progress report.}
    \item{repeat.try}{integer number of times to attempt retrieval before giving
          up.}
    \item{user}{(unused) a character string indicating a user id.}
    \item{password}{(unused) a character string indicating a password.}
    \item{host}{(unused) a character string indicating a host computer.}
    \item{...}{Arguments passed to jsonCall.}
}
\value{Depends.}
\details{
These functions interface to databases that provide time series data as a simple
json object. The database can be a proxy portal to the real database, simply
providing an intermediate server with a programmable API, while that server
contacts the real server, automatically providing appropriate button clicks.

\code{TSget} is just a wrapper to \code{jsonCall} provides an interface that is consistent 
with \pkg{TSdbi}. The \pkg{TSdbi} function argument \code{serId} is passed as the series to return,
The \code{user} \code{passwd} \code{host} can be specified in the argument. If
they are \code{NULL} then they will be determined by environment variables or 
from file \code{~/.TSjson.cfg}
\code{dbname} is reserved for future use. 

\pkg{TSjson} does not support writing data to the source.

The classes \code{jsonDriver} and \code{TSjsonConnection} extend classes
\code{DBIDriver} and  \code{DBIConnection} in the DBI package.

See the package vignette or the vignette for package \pkg{TSdata} for 
additional examples.
}

\seealso{ 
\code{\link[TSdbi]{TSdates}},
\code{\link[TSdbi]{TSget}},
\code{\link[tframe]{tfwindow}},
}
\examples{
  if (require("TSjson")){
    con <- try(TSconnect("json", dbname="statcan"))
    if(! inherits(con, "try-error")) {
        x <- TSget("v498086", con)
        tfplot(x)
       }
    }
  }
\keyword{ts}
