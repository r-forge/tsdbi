\name{getSymbols}
\alias{getSymbols}
\alias{TSconnect,getSymbolsDriver,character-method}
\alias{TSget,character,TSgetSymbolsConnection-method}
\alias{TSdates,character,TSgetSymbolsConnection-method}
\alias{TSdescription,character,TSgetSymbolsConnection-method}
\alias{TSdoc,character,TSgetSymbolsConnection-method}
\alias{TSlabel,character,TSgetSymbolsConnection-method}

\alias{dbDisconnect,TSgetSymbolsConnection-method}

\alias{getSymbolsDriver-class}
\alias{TSgetSymbolsConnection-class}

\title{Methods to wrap getSymbols for TSdbi Generics}
\description{Get a time series (matrix) using getSymbols from package quantmod, for example, from the Federal Reserve FRED database.}
\usage{
     getSymbols() 
    \S4method{TSget}{character,TSgetSymbolsConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
	quote = "Close", quiet = TRUE, repeat.try=3, ...)
##  \S4method{TSput}{ANY,character,TSgetSymbolsConnection}(
##	x, serIDs=seriesNames(data), con, ...)   
    \S4method{TSconnect}{getSymbolsDriver,character}(
	drv, dbname, user="", password = "", host="", ...)
    \S4method{TSdates}{character,TSgetSymbolsConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSgetSymbolsConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSgetSymbolsConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSgetSymbolsConnection}(x, con, ... )  

    \S4method{dbDisconnect}{TSgetSymbolsConnection}(conn,...)
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
    \item{quote}{reference time (e.g. ''Close'') passed to \code{getSymbols}.}
    \item{quiet}{logical to suppress progress report, passed to \code{getSymbols}.}
    \item{repeat.try}{integer number of times to attempt retrieval before giving
          up.}
    \item{user}{(unused) a character string indicating a user id.}
    \item{password}{(unused) a character string indicating a password.}
    \item{host}{(unused) a character string indicating a host computer.}
    \item{...}{Arguments passed to getSymbols.}
}
\value{Depends.}
\details{
These functions interface to the FRED database using getSymbols from the 
\code{quantmod} package. 
\pkg{TSgetSymbols} is just a wrapper to \code{getSymbols}. No 
extra functionality is provided, only an interface that is consistent 
with \pkg{TSdbi}. The \pkg{TSdbi} function argument
\code{dbname} is mapped to \code{getSymbols} argument \code{provider}, and
\code{serId} to \code{instrument}.
Argument \code{quote} (ignored for provider 'oanda') is
set to ''Close'' by default, but can be specified.
\code{getSymbols} argument \code{retclass} is replaced by \pkg{TSdbi}
argument \code{TSrepresentation}. (See \code{TSget} in \pkg{TSdbi} for
more details on how this works.)


\pkg{TSgetSymbols} does not support writing data to the source.

The classes \code{getSymbolsDriver} and \code{TSgetSymbolsConnection} extend classes
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
  if (require("getSymbols")){
    con <- try(TSconnect("getSymbols", dbname="FRED"))
    if(! inherits(con, "try-error")) {
        x <- TSget("CPIAUCNS", con)
        tfplot(x)
       }
    }
  }
\keyword{ts}
