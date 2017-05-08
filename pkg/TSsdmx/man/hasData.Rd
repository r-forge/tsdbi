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
    
    hasDataCodes(providor, flow, template, wild, gp=NULL) {
}
\arguments{
    \item{x}{A time series (matrix) as returned by \code{TSget} using 
      an \code{sdmx} connection.}
    \item{quiet}{Suppress warnings and just return the logical result.}
    \item{providor}{An SDMX data provider.}
    \item{flow}{A database (flow) at the provider.}
    \item{template}{Indicates code specifications for dimension fields not examined.}
    \item{wild}{The dimesion which is examined.}
    \item{gp}{Optional vector of strings uses via grep to narrow result.}
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

\code{hasDataCodes} returns the descriptions of series that actually return data from 
the query constructed with providor, flow, and template.
}

\seealso{ 
\code{\link[TSdbi]{TSget}}
}

\examples{
  \dontrun{
  require("TSsdmx")
  eurostat <- TSconnect("sdmx", dbname="EUROSTAT")

  # 28 series, sometimes only 23 with data
  z <-  TSget("ei_nama_q.Q.MIO_EUR.NSA.CP.*.IT", eurostat) 

  sum(hasData(z, quiet=TRUE)) 

  hasDataCount(z)
  hasDataNames(z)

  hasDataDescriptions(z)
  
  hasDataCodes( providor='INSEE', flow='CNT-2010-CSI-EMP',
              template='*.EMP', wild='SECT-INST')

  hasDataCodes( providor='IMF2',  flow='DS-BOP',
              template='A.MX.*', wild='INDICATOR')

  hasDataCodes( providor='IMF2',  flow='DS-BOP', 
              template='A.MX.*', wild='INDICATOR', gp= c('Current Account', 'Total'))

  }
}
\keyword{ts}
