\name{hasData}

\alias{hasData}
\alias{hasDataCount}
\alias{hasDataNames}
\alias{hasDataDescriptions}


\title{Functions to Check a Returned Time Series Data Object}
\description{Check a time series (matrix) for returned data and metadata.}
\usage{
    hasData(x, quiet=FALSE) 
    hasDataCount(x) 
    hasDataNames(x) 
    hasDataDescriptions(x) 
}
\arguments{
    \item{x}{A time series (matrix) as returned by \code{TSget} using 
      an \code{sdmx} connection.}
    \item{quiet}{Suppress warnings and just return the logical result.}
}

\value{Depends.}
\details{
These functions check data returnded from SDMX databases such as Eurostat to verify if
data and metadata has been returned by a query specification. This is a useful check
because wildcard specifications may often result in no data being returned.

\code{hasData} returns a logical vector, one element for each series in \code{x}, indication \code{TRUE} if there is numeric data in that series or \code{FALSE} if all
the data in the series is \code{NA} or \code{NaN}. If \code{quiet=FALSE} (the default)
then a warning is issued for each series that has completely missing data.

\code{hasDataCount} prints a count of the number of series with actual data, and returns
the number (invisibly).

\code{hasDataNames} returns the names of series with actual data.

\code{hasDataDescriptions} returns the descriptions of series with actual data.
}

\seealso{ 
\code{\link[TSdbi]{TSget}}
}

\examples{
  \dontrun{
  require("TSsdmx")
  eurostat <- TSconnect("sdmx", dbname="EUROSTAT")

  # 28 series, 23 with data
  z <-  TSget("ei_nama_q.Q.MIO-EUR.NSA.CP.*.IT", eurostat) 

  sum(hasData(z, quiet=TRUE)) 

  hasDataCount(z)
  hasDataNames(z)

  hasDataDescriptions(z)
  }
}
\keyword{ts}
