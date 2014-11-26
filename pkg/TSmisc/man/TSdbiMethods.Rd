\name{TSmiscMethods}

\alias{histQuote}
\alias{TShistQuoteConnection-class}

\alias{TSconnect,histQuoteConnection,missing-method}
\alias{TSget,character,TShistQuoteConnection-method}
\alias{TSdates,character,TShistQuoteConnection-method}
\alias{TSdescription,character,TShistQuoteConnection-method}
\alias{TSdoc,character,TShistQuoteConnection-method}
\alias{TSlabel,character,TShistQuoteConnection-method}
\alias{TSsource,character,TShistQuoteConnection-method}

\alias{getSymbol}
\alias{TSgetSymbolConnection-class}

\alias{TSconnect,getSymbolConnection,missing-method}
\alias{TSget,character,TSgetSymbolConnection-method}
\alias{TSdates,character,TSgetSymbolConnection-method}
\alias{TSdescription,character,TSgetSymbolConnection-method}
\alias{TSdoc,character,TSgetSymbolConnection-method}
\alias{TSlabel,character,TSgetSymbolConnection-method}
\alias{TSsource,character,TSgetSymbolConnection-method}

\alias{xls}
\alias{TSxlsConnection-class}

\alias{TSconnect,xlsConnection,missing-method}
\alias{TSget,character,TSxlsConnection-method}
\alias{TSdates,character,TSxlsConnection-method}
\alias{TSdescription,character,TSxlsConnection-method}
\alias{TSdoc,character,TSxlsConnection-method}
\alias{TSlabel,character,TSxlsConnection-method}
\alias{TSsource,character,TSxlsConnection-method}

\alias{zip}
\alias{TSzipConnection-class}

\alias{TSconnect,zipConnection,missing-method}
\alias{TSget,character,TSzipConnection-method}
\alias{TSdates,character,TSzipConnection-method}
\alias{TSdescription,character,TSzipConnection-method}
\alias{TSdoc,character,TSzipConnection-method}
\alias{TSlabel,character,TSzipConnection-method}
\alias{TSsource,character,TSzipConnection-method}

\alias{Quandl}

\alias{TSconnect,QuandlConnection,missing-method}
\alias{TSget,character,TSQuandlConnection-method}
\alias{TSdoc,character,TSQuandlConnection-method}
\alias{TSdescription,character,TSQuandlConnection-method}
\alias{TSlabel,character,TSQuandlConnection-method}
\alias{TSsource,character,TSQuandlConnection-method}
\alias{TSdates,character,TSQuandlConnection-method}
\alias{TSexists,character,TSQuandlConnection-method}

\alias{TSQuandlConnection-class}

\title{TSdbi Extensions to Wrap Several Different Data Source Formats}
\description{Get a time series (matrix) from a variety of source URLs}
\usage{
    histQuote(...) 
    getSymbol(...) 
    xls(...)
    zip(...)
    Quandl(...)

    \S4method{TSconnect}{histQuoteConnection,missing}(q, dbname, ...)
    \S4method{TSget}{character,TShistQuoteConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
	quote = "Close", quiet = TRUE, repeat.try=3, ...)
    \S4method{TSdates}{character,TShistQuoteConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TShistQuoteConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TShistQuoteConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TShistQuoteConnection}(x, con, ... )  
    \S4method{TSsource}{character,TShistQuoteConnection}(x, con, ... )  

    \S4method{TSconnect}{getSymbolConnection,missing}(
	q, dbname, ...)
    \S4method{TSget}{character,TSgetSymbolConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
	quote = NULL, quiet = TRUE, repeat.try=3, ...)
    \S4method{TSdates}{character,TSgetSymbolConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSgetSymbolConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSgetSymbolConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSgetSymbolConnection}(x, con, ... )  
    \S4method{TSsource}{character,TSgetSymbolConnection}(x, con, ... )  

    \S4method{TSconnect}{xlsConnection,missing}(q, dbname, 
       map=list(ids, data, dates, names=NULL, description=NULL, sheet=1,
         tsrepresentation = function(data,dates){zoo(data, as.Date(dates))}),
	  ...)
    \S4method{TSget}{character,TSxlsConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, ...)
    \S4method{TSdates}{character,TSxlsConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSxlsConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSxlsConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSxlsConnection}(x, con, ... )  
    \S4method{TSsource}{character,TSxlsConnection}(x, con, ... )  

    \S4method{TSconnect}{zipConnection,missing}(q, dbname, 
                suffix=c("Open","High","Low","Close","Volume","OI"), ...)
    \S4method{TSget}{character,TSzipConnection}(
	serIDs, con, TSrepresentation=options()$TSrepresentation,
        tf=NULL, start=tfstart(tf), end=tfend(tf),
        names=NULL, quote=con@suffix, ...)
    \S4method{TSdates}{character,TSzipConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSzipConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSzipConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSzipConnection}(x, con, ... )  
    \S4method{TSsource}{character,TSzipConnection}(x, con, ... )  

    \S4method{TSconnect}{QuandlConnection,missing}(q, dbname,
               token=NULL, ...)
    \S4method{TSget}{character,TSQuandlConnection}(serIDs, con, 
	TSrepresentation = getOption("TSrepresentation"), 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names = NULL,
	quote = NULL, TSdescription = FALSE, TSdoc = FALSE, TSlabel=FALSE,
	TSsource=TRUE, vintage = NULL, ...)
    \S4method{TSdates}{character,TSQuandlConnection}(serIDs, 
        con=getOption("TSconnection"), vintage=NULL, panel=NULL, ...)
    \S4method{TSexists}{character,TSQuandlConnection}(serIDs, con,
           vintage=NULL, panel=NULL, ...)
    \S4method{TSdescription}{character,TSQuandlConnection}(x, con, ...)
    \S4method{TSdoc}{character,TSQuandlConnection}(x, 
                con=getOption("TSconnection"), ...)
    \S4method{TSlabel}{character,TSQuandlConnection}(x, con, ...)
    \S4method{TSsource}{character,TSQuandlConnection}(x, con, ...)

}
\arguments{
    \item{q}{a string indicating a query interface to use, or a database connection object.}
    \item{dbname}{a string indicating a database or omitted if \code{q} ia a connection object.}
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
    \item{quote}{reference time (e.g. ''Close'') passed to \code{get.hist.quote}. For zip method, a vector of strings, as in suffix, indicating series that
           should be returned in the result(see Details).}
    \item{quiet}{logical to suppress progress report, passed to \code{get.hist.quote}.}
    \item{repeat.try}{integer number of times to attempt retrieval before giving
          up.}
    \item{sheet}{optional integer to indicate the sheet of the workbook
      to use default=1).}
    \item{map}{A list with elements indicating the location of data, serIDs, dates, and optional metadata (see Details).}
    \item{suffix}{A vector of strings indicating names of the columns if the 
          zipped file has more than one series (see Details).}
    \item{TSdescription}{TRUE or FALSE indicating whether description 
       should be extracted}
    \item{TSdoc}{TRUE or FALSE indicating whether documentation 
       should be extracted.}
    \item{TSlabel}{For compatibility with other TS packages. Not supported in
        Quandl}
    \item{TSsource}{If TRUE (default) TSsource in the result is set to
        "Quandl".}
    \item{token}{character string of Quandl access token.}
    \item{...}{Arguments passed to other methods, or by histQuote 
        to get.hist.quote.}
}
\value{Depends.}
\details{
These functions interface to a stock quote URL using get.hist.quote from the 
\code{tseries} package. Only URLs ''yahoo'' and ''oanda'' are supported.
\pkg{TShistQuote} is a wrapper to \code{get.hist.quote}. No 
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
The package \pkg{TSQuandl}provides a wrapper to the \pkg{Quandl} package to provide a 
\pkg{TSdbi} API for users. Both \code{start} and \code{end} can be either date objects or 
character strings.

The Quandl access token can be specified either [NOT WORKING: as an argument to \code{TSConnect} (\code{token="chars"}) or ] in a file .Quandl.cnf in the user's
home directory, or in an environment variable 'QUANDL_TOKEN', or using the 
\pkg{Quandl} \code{Quandl.auth()} function. This last will require the user to
load \pkg{Quandl} in order to set it. 
The search will be done in that order and the first non-\code{NULL} value used. If no token is found then access will be tried without a token, but this will be subject to the limit imposed by Quandl.

The argument \code{quote} can be used to select a subset of the data requested,
in the case of a multivariate dataset. For example, daily stock or
stock index results may have columns "Open", "High", "Low",  "Close", ... . 
The argument \code{quote} can be used to select from these.  
Note that when argument \code{quote} is specified to select a subset of the dataset requested, capitalization is important.

See the package vignette for additional examples.
}

\seealso{ 
\code{\link[TSdbi]{TSconnect}},
\code{\link[TSdbi]{TSdates}},
\code{\link[TSdbi]{TSget}},
\code{\link[tseries]{get.hist.quote}}
\code{\link[tframe]{tfwindow}},
\code{\link[Quandl]{Quandl}}
}
\examples{
    require("tfplot")
    
    con <- TSconnect("histQuote", dbname="yahoo") 
    x <- TSget("^ftse", con)
    tfplot(x)

    con <- TSconnect("getSymbol", dbname="FRED")
    x <- TSget("CPIAUCNS", con)
    tfplot(x)

    # data from http://pitrading.com/
    # par(ask=TRUE) # to pause between pages
    con <- TSconnect("zip", dbname="http://pitrading.com/free_eod_data")
    x <- TSget("EURUSD", con)
    tfplot(x, graphs.per.page=3)

    z <- TSget(c("AD", "CD"), con, quote="Close")
    tfplot(z, start="2007-01-01", Title=
     "Futures, Australian and Canadian Dollar Continuous Contract at Close",
      graphs.per.page=3)

  ####  Australian Money ####
  #  test file copied Nov. 29, 2010 from 
  #  http://www.rba.gov.au/statistics/tables/xls/d03hist.xls  

    testfile <- system.file("testxls/d03hist.xls", package = "TSxls")
 
    con1 <- TSconnect("xls", dbname=testfile,
          map=list(ids  =list(i=11,     j="B:Q"), 
	           data =list(i=12:627, j="B:Q"), 
	           dates=list(i=12:627, j="A"),
                   names=list(i=4:7,    j="B:Q"), 
		   description = NULL,
		   tsrepresentation = function(data,dates){
		       ts(data,start=c(1959,7), frequency=12)}))

    z <- TSget("DMACN", con1)
    tfplot(z)

 con <- TSconnect("Quandl", dbname="NSE")
 x  <- TSget("OIL", con, start="2001-01-01")
 start(x)
 end(x)
 
 x  <- TSget("OIL", con, start=as.Date("2001-01-01")) 
 tfplot(x)
 
 dimnames(x)[2]
 x <- TSget("OIL", con, quote="Open")

 tfplot(x)

}
\keyword{ts}
