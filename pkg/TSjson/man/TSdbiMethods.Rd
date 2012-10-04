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

\title{Use fromJSON to implement methods for TSdbi Generics}
\description{Get a time series data from databases exporting series as json 
  objects. In particular, proxies to other databases such as Statisics Canada.}
\usage{
     jsonCall() 
    \S4method{TSget}{character,TSjsonConnection}(
	serIDs, con=getOption("TSconnection"), 
	TSrepresentation=getOption("TSrepresentation"), 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
        TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
	quiet = TRUE, repeat.try=3, ...)
    \S4method{TSconnect}{jsonDriver,character}(
	drv, dbname, user=NULL, password = NULL, host=NULL, ...)
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
json  object (JavaScript Object Notation). The database can be a proxy portal 
to the real database, simply providing an intermediate server supporting a 
programmable API. The intermediate proxy server then
contacts the real server, automatically providing appropriate button clicks
to a web interface at the real data source, and retrieves and relays the data.

\code{TSget} is a wrapper for \code{jsonCall} to provide an interface that 
is consistent with \pkg{TSdbi}. The \pkg{TSdbi} function argument \code{serId} 
specifies the series to return.
The \code{user}, \code{password}, and \code{host}, can be specified in the 
argument. If specified as \code{NULL} (the default) then they will be 
determined by reading a file \code{~/.TSjson.cfg} which should have a single
line with three fields: user  password  host. If the file does not
exist then environment variables "TSJSONUSER", "TSJSONPASSWORD", 
and "TSJSONHOST" will be used.

\code{dbname} specifies a recognized database (e.g "cansim") which is expanded
to an appropriate string to find the database. For unrecognized databases the
value of \code{dbname} is simply appended to the URL specification, allowing for
arbitrary database host. (But, of course, the value returned by the host must be
a time series in the recognized format in order for this to work. The URL
specification is expanded to \code{"http://user:password@host/dbname/serID"}.

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
  require("TSjson")
  con <- TSconnect("json", dbname="cansim")

  TSdates(c("v498086", "v498087","V122746", "v687341", "V36610", "v141"), con)
 
  TSdescription(c("v687341", "v687342"), con)

  x <- TSget("v498086", con)
  require("tfplot")
  tfplot(x)
}
\keyword{ts}
