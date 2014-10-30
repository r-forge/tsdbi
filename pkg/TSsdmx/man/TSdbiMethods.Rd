\name{TSsdmxMethods}
\alias{sdmx}

\alias{TSconnect,sdmxConnection,missing-method}
\alias{TSget,character,TSsdmxConnection-method}
\alias{TSdates,character,TSsdmxConnection-method}
\alias{TSdescription,character,TSsdmxConnection-method}
\alias{TSdoc,character,TSsdmxConnection-method}
\alias{TSlabel,character,TSsdmxConnection-method}
\alias{TSsource,character,TSsdmxConnection-method}

\alias{TSsdmxConnection-class}

\title{Methods to wrap sdmx  for TSdbi Generics}
\description{Get a time series (matrix) using SDMX, for example, from the OECD database.}
\usage{
    sdmx...) 
    \S4method{TSconnect}{sdmxConnection,missing}(
	q, dbname, user="", password = "", host="", ...)
    \S4method{TSget}{character,TSsdmxConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
	quiet = TRUE, repeat.try=3, ...)
    \S4method{TSdates}{character,TSsdmxConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSsdmxConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSsdmxConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSsdmxConnection}(x, con, ... )  
    \S4method{TSsource}{character,TSsdmxConnection}(x, con, ... )  
}
\arguments{
    \item{q}{A character string indicating the query interface to use, or
         a database connection object.}
    \item{dbname}{The name of the database to which the connection should be
         established, omitted if \code{q} is a database connection object.}
    \item{con}{a database connection object.}
    \item{serIDs}{identifiers for series on the database.}
    \item{vintage}{character string indicating vintage of the series on the 
        database (not supported by this database).}
    \item{panel}{character string indicating panel of the series on the 
        database (not supported by this database).}
    \item{x}{time series data(TSput), or 
      identifiers for series on the database (TSdoc and TSdescription).}
    \item{names}{optional character vector to use for series names in the R
    object.}
    \item{tf}{time frame for trimming data, passed to tfwindow.}
    \item{start}{time frame for trimming data, passed to tfwindow.}
    \item{end}{time frame for trimming data, passed to tfwindow.}
    \item{TSrepresentation}{time representation for returned series. 
          (See \code{TSget} in package \pkg{TSdbi}.)}
    \item{quiet}{logical to suppress progress report.}
    \item{repeat.try}{integer number of times to attempt retrieval before giving
          up.}
    \item{user}{(unused) a character string indicating a user id.}
    \item{password}{(unused) a character string indicating a password.}
    \item{host}{(unused) a character string indicating a host computer.}
    \item{...}{Arguments passed to other methods or to sdmxCall.}
}
\value{Depends.}
\details{
These functions interface to the SDMX databases such as the OECD web portal. 
\code{TSget} is just a wrapper to \code{sdmxCall} provides an interface that is consistent 
with \pkg{TSdbi}. The \pkg{TSdbi} function argument \code{serId} is passed as the series to return,
\code{dbname} indicates the web site (e.g. "OECD"). 
(See \code{TSget} in \pkg{TSdbi} for
more details on how this works.)

\pkg{TSsdmx} does not support writing data to the source.

The classes \code{sdmxDriver} and \code{TSsdmxConnection} extend classes
\code{DBIDriver} and  \code{DBIConnection} in the DBI package.

See the package vignette for additional examples.
}

\seealso{ 
\code{\link[TSdbi]{TSdates}},
\code{\link[TSdbi]{TSget}},
\code{\link[tframe]{tfwindow}},
}
\examples{
  require("tfplot")
  if (require("TSsdmx")){
    con <- try(TSconnect("sdmx", dbname="OECD"))
    if(! inherits(con, "try-error")) {
        x <- TSget("whatever", con)
        tfplot(x)
       }
    }
  }
\keyword{ts}
