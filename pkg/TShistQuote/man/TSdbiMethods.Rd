\name{histQuote}
\alias{histQuote}
\alias{TSconnect,histQuoteDriver,character-method}
\alias{TSget,character,TShistQuoteConnection-method}
\alias{TSdates,character,TShistQuoteConnection-method}
\alias{TSdescription,character,TShistQuoteConnection-method}
\alias{TSdoc,character,TShistQuoteConnection-method}
\alias{TSlabel,character,TShistQuoteConnection-method}

\alias{dbDisconnect,TShistQuoteConnection-method}

\alias{histQuoteDriver-class}
\alias{TShistQuoteConnection-class}

\title{Methods to wrap get.hist.quote for TSdbi Generics}
\description{Get a time series (matrix) from stock quote URL}
\usage{
     histQuote() 
    \S4method{TSget}{character,TShistQuoteConnection}(serIDs, con,
        TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
	quote = "Close", quiet = TRUE, ...)
##    \S4method{TSput}{ANY,character,TShistQuoteConnection}(x, serIDs=seriesNames(data), con, ...)   
    \S4method{TSconnect}{histQuoteDriver,character}(drv, dbname, 
               user="", password = "", host="", ...)
    \S4method{TSdates}{character,TShistQuoteConnection}(serIDs, con, ... )  
    \S4method{TSdescription}{character,TShistQuoteConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TShistQuoteConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TShistQuoteConnection}(x, con, ... )  

    \S4method{dbDisconnect}{TShistQuoteConnection}(conn,...)
}
\arguments{
    \item{con}{a database connection object.}
    \item{conn}{a database connection object.}
    \item{serIDs}{identifiers for series on the database.}
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
    \item{quote}{reference time (e.g. ''Close'') passed to \code{get.hist.quote}.}
    \item{quiet}{logical to suppress progress report, passed to \code{get.hist.quote}.}
    \item{user}{(unused) a character string indicating a user id.}
    \item{password}{(unused) a character string indicating a password.}
    \item{host}{(unused) a character string indicating a host computer.}
    \item{...}{Arguments passed to get.hist.quote.}
}
\value{Depends.}
\details{
These functions interface to a stock quote URL using get.hist.quote from the 
\code{tseries} package. Only URLs ''yahoo'' and ''oanda'' are supported.
\pkg{TShistQuote} is just a wrapper to \code{get.hist.quote}. No 
extra functionality is provided, only an interface that is consistent 
with \pkg{TSdbi}. The \pkg{TSdbi} function argument
\code{dbname} is mapped to \code{get.hist.quote} argument \code{provider}, and
\code{serId} to \code{instrument}.
Argument \code{quote} (ignored for provider 'oanda') is
set to ''Close'' by default, but can be specified.
\code{get.hist.quote} argument \code{retclass} is replaced by \pkg{TSdbi}
argument \code{TSrepresentation}. (See \code{TSget} in \pkg{TSdbi} for
more details on how this works.)


\pkg{TShistQuote} does not support writing data to the source URL.

The classes \code{histQuoteDriver} and \code{TShistQuoteConnection} extend classes
\code{DBIDriver} and  \code{DBIConnection} in the DBI package.

See the package vignette for additional examples.
}

\seealso{ 
\code{\link[TSdbi]{TSdates}},
\code{\link[TSdbi]{TSget}},
\code{\link[tseries]{get.hist.quote}}
\code{\link[tframe]{tfwindow}},
}
\examples{
  if (require("histQuote")){
    con <- try(TSconnect("histQuote", dbname="ets"))
    if(! inherits(con, "try-error")) {
        x <- TSget("^gdax", con)
        tfplot(x)
       }
    }
  }
\keyword{ts}
