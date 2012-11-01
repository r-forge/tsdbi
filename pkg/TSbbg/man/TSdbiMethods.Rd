\name{TSdbiMethods}
\alias{TSconnect,bbgDriver,character-method}
\alias{TSget,character,TSbbgConnection-method}
\alias{TSput,ANY,character,TSbbgConnection-method}
\alias{TSdelete,character,TSbbgConnection-method}
\alias{TSdoc,character,TSbbgConnection-method}
\alias{TSdescription,character,TSbbgConnection-method}
\alias{TSlabel,character,TSbbgConnection-method}
\alias{TSsource,character,TSbbgConnection-method}
\alias{TSdates,character,TSbbgConnection-method}
\alias{TSexists,character,TSbbgConnection-method}

\alias{dbDisconnect,TSbbgConnection-method}

\alias{dbUnloadDriver,bbgDriver-method}

\alias{bbg}

\alias{TSbbgConnection-class}

\alias{dbObjectId-class}
\alias{bbgObject-class}
\alias{bbgDriver-class}

\title{TSdbi bbg Methods}
\description{Methods for TSdbi bbg time series dtabase connection.}
\usage{
    \S4method{TSconnect}{bbgDriver,character}(drv, dbname=NULL, ...)

    \S4method{TSget}{character,TSbbgConnection}(serIDs, con, 
	TSrepresentation = getOption("TSrepresentation"), 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names = NULL,
	TSdescription = FALSE, TSdoc = FALSE, TSlabel=FALSE, TSsource=TRUE, ...)

    \S4method{TSput}{ANY,character,TSbbgConnection}(x, serIDs=seriesNames(x), 
	con, TSdescription.=TSdescription(x), 
	TSdoc.=TSdoc(x), TSlabel.=NULL, TSsource.=NULL, warn = TRUE, ...)

    \S4method{TSdates}{character,TSbbgConnection}(serIDs, con, ...)

    \S4method{TSexists}{character,TSbbgConnection}(serIDs, con, ...)

    \S4method{TSdelete}{character,TSbbgConnection}(serIDs, con, ...)

    \S4method{TSdescription}{character,TSbbgConnection}(x, con, ...)

    \S4method{TSdoc}{character,TSbbgConnection}(x, con, ...)

    \S4method{TSlabel}{character,TSbbgConnection}(x, con, ...)

    \S4method{TSsource}{character,TSbbgConnection}(x, con, ...)
 
    \S4method{dbDisconnect}{TSbbgConnection}(conn,...)

    \S4method{dbUnloadDriver}{bbgDriver}(drv, ...)

    \method{bbg}{default}()
}
\arguments{
    \item{drv}{A bbgDriver.}
    \item{dbname}{NULL, for compatability with other TS* packages.}
    \item{con}{A dat source connection.}
    \item{serIDs}{identifiers for series to extract.}
    \item{x}{a series identifier for
       TSdescription and TSdoc or, for print, 
       a database connection as returned by TSconnect.}
    \item{TSrepresentation}{time series representation to use for the result.}
    \item{names}{Optional character vector to use for series names. Defaults to
       serIDs.}
    \item{tf}{Optional tframe to use for truncating data. (See \code{tfwindow}.)}
    \item{start}{Optional start date to use for truncating data. (See \code{tfwindow}.)}
    \item{end}{Optional end date to use for truncating data. (See \code{tfwindow}.)}
    \item{TSdescription}{TRUE or FALSE indicating whether description 
       should be extracted}
    \item{TSdescription.}{Description to put on the database.}
    \item{TSdoc}{TRUE or FALSE indicating whether documentation 
       should be extracted.}
    \item{TSdoc.}{Documentation to put on the database.}
    \item{TSlabel}{For compatibility with other TS packages. Not supported in
        bbg}
    \item{TSlabel.}{For compatibility with other TS packages. Not supported in
        bbg}
    \item{TSsource}{For compatibility with other TS packages. Not supported in
        bbg}
    \item{TSsource.}{For compatibility with other TS packages. Not supported in
        bbg}
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
using \code{blpConnect} from \pkg{Rbbg} and \code{TSget} retrieves data
using \code{bdh}.
}

\seealso{ 
\code{\link[TSdbi]{TSdbi-package}}
}
\examples{
 require("tfplot")
 con <- TSconnect("bbg")
  x  <- TSget("USCRWTIC Index", con)

  start(x)
  end(x)
  
  tfplot(x)
}
\keyword{ts}

