\name{TSdbiMethods}
\alias{TSconnect,QuandlDriver,character-method}
\alias{TSget,character,TSQuandlConnection-method}
\alias{TSdoc,character,TSQuandlConnection-method}
\alias{TSdescription,character,TSQuandlConnection-method}
\alias{TSlabel,character,TSQuandlConnection-method}
\alias{TSsource,character,TSQuandlConnection-method}
\alias{TSdates,character,TSQuandlConnection-method}
\alias{TSexists,character,TSQuandlConnection-method}

\alias{dbDisconnect,TSQuandlConnection-method}

\alias{dbUnloadDriver,QuandlDriver-method}

\alias{Quandl}

\alias{TSQuandlConnection-class}

\alias{dbObjectId-class}
\alias{QuandlObject-class}
\alias{QuandlDriver-class}

\title{TSdbi Quandl Methods}
\description{Methods for TSdbi Quandl time series database connection.}
\usage{
    \S4method{TSconnect}{QuandlDriver,character}(drv, dbname=NULL, ...)

    \S4method{TSget}{character,TSQuandlConnection}(serIDs, con, 
	TSrepresentation = getOption("TSrepresentation"), 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names = NULL,
	TSdescription = FALSE, TSdoc = FALSE, TSlabel=FALSE, TSsource=TRUE, ...)

    \S4method{TSdates}{character,TSQuandlConnection}(serIDs, con, ...)

    \S4method{TSexists}{character,TSQuandlConnection}(serIDs, con, ...)

    \S4method{TSdescription}{character,TSQuandlConnection}(x, con, ...)

    \S4method{TSdoc}{character,TSQuandlConnection}(x, con, ...)

    \S4method{TSlabel}{character,TSQuandlConnection}(x, con, ...)

    \S4method{TSsource}{character,TSQuandlConnection}(x, con, ...)
 
    \S4method{dbDisconnect}{TSQuandlConnection}(conn,...)

    \S4method{dbUnloadDriver}{QuandlDriver}(drv, ...)

    \method{Quandl}{default}()
}
\arguments{
    \item{drv}{A QuandlDriver.}
    \item{dbname}{NULL, for compatability with other TS* packages.}
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
        Quandl}
    \item{TSsource}{If TRUE (default) TSsource in the result is set to
        "Quandl".}
    \item{warn}{Logical indicating if warning messages should be suppressed.} 
   \item{...}{Arguments passed to other methods.}
}
\value{depends.}
\details{
These are methods for \pkg{TSdbi} . See the package \pkg{TSdbi} for details 
and see the vignette distributed with the TSdata package for more complete 
examples.

This package provides a wrapper to the \pkg{Quandl} package to provide a 
\pkg{TSdbi} API for users. Function \code{TSConnect} sets the information used
for the connection. \code{TSget} retrieves data.
Both \code{start} and \code{end} can be either date objects or 
character strings.
}

\seealso{ 
\code{\link[TSdbi]{TSdbi-package}}
}
\examples{
 require("tfplot")
 con <- TSconnect("Quandl", dbname="NSE")
 x  <- TSget("OIL", con, start="2001-01-01")
 start(x)
 end(x)
 
 x  <- TSget("OIL", con, start=as.Date("2001-01-01")) 
 tfplot(x)
 
 x <- TSget("OIL", con, quote="OPEN")

 tfplot(x)
}
\keyword{ts}

