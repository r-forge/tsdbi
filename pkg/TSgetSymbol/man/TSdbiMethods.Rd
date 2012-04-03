\name{getSymbol}
\alias{getSymbol}
\alias{TSconnect,getSymbolDriver,character-method}
\alias{TSget,character,TSgetSymbolConnection-method}
\alias{TSdates,character,TSgetSymbolConnection-method}
\alias{TSdescription,character,TSgetSymbolConnection-method}
\alias{TSdoc,character,TSgetSymbolConnection-method}
\alias{TSlabel,character,TSgetSymbolConnection-method}
\alias{TSsource,character,TSgetSymbolConnection-method}

\alias{dbDisconnect,TSgetSymbolConnection-method}

\alias{getSymbolDriver-class}
\alias{TSgetSymbolConnection-class}

\title{Methods to wrap getSymbols for TSdbi Generics}
\description{Get a time series (matrix) using getSymbols from package quantmod, for example, from the Federal Reserve FRED database.}
\usage{
     getSymbol() 
    \S4method{TSget}{character,TSgetSymbolConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
	quote = if (con@dbname == "yahoo") "Close" else NULL, 
	quiet = TRUE, repeat.try=3, ...)
    \S4method{TSconnect}{getSymbolDriver,character}(
	drv, dbname, user="", password = "", host="", ...)
    \S4method{TSdates}{character,TSgetSymbolConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSgetSymbolConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSgetSymbolConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSgetSymbolConnection}(x, con, ... )  
    \S4method{TSsource}{character,TSgetSymbolConnection}(x, con, ... )  

    \S4method{dbDisconnect}{TSgetSymbolConnection}(conn,...)
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
    \item{quote}{reference item (e.g. ''Close''). See details.}
    \item{quiet}{logical to suppress progress report.}
    \item{repeat.try}{integer number of times to attempt retrieval before giving
          up.}
    \item{user}{(unused) a character string indicating a user id.}
    \item{password}{(unused) a character string indicating a password.}
    \item{host}{(unused) a character string indicating a host computer.}
    \item{...}{Arguments passed to getSymbols.}
}
\value{Depends.}
\details{
These functions interface to web database (e.g. FRED) using \code{getSymbols} 
from the \pkg{quantmod} package. 
\code{TSget} is just a wrapper to \code{getSymbols}. 
No extra functionality is provided, only an interface that is consistent 
with \pkg{TSdbi}. The \pkg{TSdbi} function argument \code{serId} is passed 
as the series to return,
\code{dbname} is mapped to \code{getSymbols} argument \code{src}, and
\code{TSrepresentation} to \code{return.class}. The \code{getSymbols} 
argument \code{auto.assign} is set to \code{FALSE} and the series is 
returned for assignment by the user, as with other \code{TSget} 
database interfaces. (See \code{TSget} in \pkg{TSdbi} for
more details on how this works.)

The argument \code{quote} with default{"Close"} for \code{dbname="yahoo"},
and \code{NULL} otherwsie, is provided to allow
automatically extracting part of the multivariate series returned by
\code{getSymbols}. It can be set to any of \code{"Open", "High", "Low", 
"Close", "Volume", "Adjusted"}. If it is set to \code{NULL} then all 
will be returned. 

\pkg{TSgetSymbol} does not support writing data to the source.

The classes \code{getSymbolDriver} and \code{TSgetSymbolConnection} extend classes
\code{DBIDriver} and  \code{DBIConnection} in the DBI package.

See the package vignette for additional examples.
}

\seealso{ 
\code{\link[TSdbi]{TSdates}},
\code{\link[TSdbi]{TSget}},
\code{\link[quantmod]{getSymbols}}
\code{\link[tframe]{tfwindow}},
}
\examples{
    require("tfplot")
    con <- TSconnect("getSymbol", dbname="FRED")
    x <- TSget("CPIAUCNS", con)
    tfplot(x)
  }
\keyword{ts}
