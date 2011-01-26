\name{zip}
\alias{zip}
\alias{TSconnect,zipDriver,character-method}
\alias{TSget,character,TSzipConnection-method}
\alias{TSdates,character,TSzipConnection-method}
\alias{TSdescription,character,TSzipConnection-method}
\alias{TSdoc,character,TSzipConnection-method}
\alias{TSlabel,character,TSzipConnection-method}

\alias{dbDisconnect,TSzipConnection-method}

\alias{zipDriver-class}
\alias{TSzipConnection-class}

\title{Methods for TSdbi Generics to Connect to zipped csv Files}
\description{Get a time series (matrix) from a zipped csv file (at a url).}
\usage{
     zip() 
    \S4method{TSget}{character,TSzipConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, ...)
    \S4method{TSconnect}{zipDriver,character}( drv, dbname, 
       map=list(ids, data, dates, names=NULL, description=NULL,
         tsrepresentation = function(data,dates){zoo(data, as.Date(dates))}),
	  ...)
    \S4method{TSdates}{character,TSzipConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSzipConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSzipConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSzipConnection}(x, con, ... )  

    \S4method{dbDisconnect}{TSzipConnection}(conn,...)
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
    \item{map}{A list with elements indicating the location of data, serIDs, dates, and optional metadata (see Details).}
    \item{...}{Arguments currently unused.}
}
\value{Depends.}
\details{
These functions interface to zip (\code{.zip}) files. 
\code{TSget} is a wrapper to \code{read.csv} to provide an interface that is consistent 
with \pkg{TSdbi}. The \pkg{TSdbi} function argument \code{serId} is passed as the series to return,
\code{dbname} indicates the location of zip files (a url or directory). 
(See \code{TSget} in \pkg{TSdbi} for
more details on how this works.)

\pkg{TSzip} does not support writing data to the source.

The classes \code{zipDriver} and \code{TSzipConnection} extend classes
\code{DBIDriver} and  \code{DBIConnection} in the DBI package.

See the package vignette for additional examples.
}

\seealso{ 
\code{\link[TSdbi]{TSdates}},
\code{\link[TSdbi]{TSget}},
\code{\link[tframe]{tfwindow}},
}
\examples{
    # data from http://pitrading.com/
    con <- try(TSconnect("zip", dbname="pitrading"))
    x <- TSget("EURUSD", con)
    tfplot(x)
    }
\keyword{ts}
