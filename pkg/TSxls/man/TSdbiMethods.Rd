\name{xls}
\alias{xls}
\alias{TSconnect,xlsDriver,character-method}
\alias{TSget,character,TSxlsConnection-method}
\alias{TSdates,character,TSxlsConnection-method}
\alias{TSdescription,character,TSxlsConnection-method}
\alias{TSdoc,character,TSxlsConnection-method}
\alias{TSlabel,character,TSxlsConnection-method}
\alias{TSsource,character,TSxlsConnection-method}

\alias{dbDisconnect,TSxlsConnection-method}

\alias{xlsDriver-class}
\alias{TSxlsConnection-class}

\title{Methods for TSdbi Generics to Connect to Spreadsheets}
\description{Get a time series (matrix) from a spreadsheet.}
\usage{
     xlsCall() 
    \S4method{TSget}{character,TSxlsConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, ...)
    \S4method{TSconnect}{xlsDriver,character}( drv, dbname, 
       map=list(ids, data, dates, names=NULL, description=NULL, sheet=1,
         tsrepresentation = function(data,dates){zoo(data, as.Date(dates))}),
	  ...)
    \S4method{TSdates}{character,TSxlsConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSxlsConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSxlsConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSxlsConnection}(x, con, ... )  
    \S4method{TSsource}{character,TSxlsConnection}(x, con, ... )  

    \S4method{dbDisconnect}{TSxlsConnection}(conn,...)
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
    \item{sheet}{optional integer to indicate the sheet of the workbook
      to use default=1).}
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
These functions interface to the spreadsheets (\code{.xls}) files. 
\code{TSget} is just a wrapper to \code{read.xls} to provide an interface that is consistent 
with \pkg{TSdbi}. The \pkg{TSdbi} function argument \code{serId} is passed as the series to return,
\code{dbname} indicates the spreadsheets file. 
(See \code{TSget} in \pkg{TSdbi} for
more details on how this works.)

\pkg{TSxls} does not support writing data to the source.

The classes \code{xlsDriver} and \code{TSxlsConnection} extend classes
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
  if (require("TSxls")){
    con <- try(TSconnect("xls", dbname="OECD"))
    if(! inherits(con, "try-error")) {
        x <- TSget("whatever", con)
        tfplot(x)
       }
    }
  }
\keyword{ts}
