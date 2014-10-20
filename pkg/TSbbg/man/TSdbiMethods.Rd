\name{TSbbgMethods}

\alias{dbBackEnd}

\alias{TSconnect,TSbbgConnection,missing-method}
\alias{TSget,character,TSbbgConnection-method}
\alias{TSdoc,character,TSbbgConnection-method}
\alias{TSdescription,character,TSbbgConnection-method}
\alias{TSlabel,character,TSbbgConnection-method}
\alias{TSsource,character,TSbbgConnection-method}
\alias{TSdates,character,TSbbgConnection-method}
\alias{TSexists,character,TSbbgConnection-method}

\alias{TSbbgConnection-class}

title{TSdbi bbg Methods}
\description{Methods for TSdbi bbg time series database connection to Bloomberg.}
\usage{
    dbBackEnd(...)
    \S4method{TSconnect}{TSbbgConnection,missing}(q, dbname=NULL, ...)

    \S4method{TSget}{character,TSbbgConnection}(serIDs, con, 
	TSrepresentation = getOption("TSrepresentation"), 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names = NULL,
	TSdescription = FALSE, TSdoc = FALSE, TSlabel=FALSE, TSsource=TRUE, ...)

    \S4method{TSdates}{character,TSbbgConnection}(serIDs, con, ...)

    \S4method{TSexists}{character,TSbbgConnection}(serIDs, con, ...)

    \S4method{TSdescription}{character,TSbbgConnection}(x, con, ...)

    \S4method{TSdoc}{character,TSbbgConnection}(x, con, ...)

    \S4method{TSlabel}{character,TSbbgConnection}(x, con, ...)

    \S4method{TSsource}{character,TSbbgConnection}(x, con, ...)
 }
\arguments{
    \item{q}{A character string indicating the query interface to use, or
         a database connection object.}
    \item{dbname}{The name of the database to which the connection should be
         established, omitted if \code{q} is a database connection object.
         NULL, for compatability with other TS* packages.}
    \item{con}{A data source connection.}
    \item{serIDs}{identifiers for series to extract.}
    \item{x}{a series identifier for
       TSdescription and TSdoc or, for print, 
       a database connection as returned by TSconnect.}
    \item{TSrepresentation}{time series representation to use for the result.}
    \item{names}{Optional character vector to use for series names. Defaults to
       serIDs.}
    \item{tf}{Optional tframe to use for truncating data. (See \code{tfwindow}.)}
    \item{start}{Optional start date to use for truncating data.)}
    \item{end}{Optional end date to use for truncating data.)}
    \item{TSdescription}{TRUE or FALSE indicating whether description 
       should be extracted}
    \item{TSdoc}{TRUE or FALSE indicating whether documentation 
       should be extracted.}
    \item{TSlabel}{For compatibility with other TS packages. Not supported in
        bbg}
    \item{TSsource}{If TRUE (default) TSsource in the result is set to
        "Bloomberg".}
    \item{warn}{Logical indicating if warning messages should be suppressed.} 
   \item{...}{Arguments passed to other methods.}
}
\value{depends.}
\details{
These are methods for \pkg{TSdbi} . See the package \pkg{TSdbi} for details 
and see the vignette distributed with the TSdata package for more complete 
examples.

This package provides a wrapper to the \pkg{Rbbg} package to provide a 
\pkg{TSdbi} API for users. Function \code{TSConnect} establishes a connection
using \code{blpConnect} from \pkg{Rbbg}. \code{TSget} retrieves data
using \code{bdh} if \code{start} is a date with no time or using \code{bar} if
\code{start} has a date with a time.  Bothe \code{start} and \code{end} can be
either date/time  objects or character strings.
}

\seealso{ 
\code{\link[TSdbi]{TSdbi-package}}
}
\examples{
 require("tfplot")
 con <- TSconnect("bbg")
 x  <- TSget("USCRWTIC Index", con, start="2001-01-01")
 start(x)
 end(x)
 
 x  <- TSget("USCRWTIC Index", con, start=as.Date("2001-01-01")) 
 tfplot(x)
 
 x <- TSget("RYA ID Equity", con, quote="TRADE", 
            start= "2012-11-20 09:00:00.000", 
	     end = "2012-11-20 15:00:00.000", interval="60")

  tfplot(x)
}
\keyword{ts}

