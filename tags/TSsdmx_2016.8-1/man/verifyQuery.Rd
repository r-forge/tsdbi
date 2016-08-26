\name{verifyQuery}

\alias{verifyQuery}

\title{Check Query Against a Provider}
\description{Check validity of fields of a query against a provider.}
\usage{
    verifyQuery(provider, Q, verbose = TRUE)
}
\arguments{
    \item{provider}{Character string indicating a provider.}
    \item{Q}{Character string indicating fields of a query.}
    \item{verbose}{Logical indicating if problems should be printed out. 
      If FALSE only return the logical result.}
}

\value{TRUE/FALSE returned invisibly}
\details{
This functions check fields of the query \code{Q} against those expected by
the provider indicated by \code{provider}. If all fields check ok 
then \code{TRUE} is returned, 
otherwise the result is \code{FALSE}. If \code{verbose} is \code{TRUE} then the 
first error found will be printed.

Note that, even though the query is valid, the providor may not have data
for the specified combination of fields, in which case a data request will
not return data.

As of February 2015, the WB provider is not responding to queries in the same
way as it indicates they should be, so this utility is not very useful with 
this provider. That is, even if the declared structure is FREQ.SERIES.REF_AREA,
you have to build the WB query as REF_AREA.SERIES.

}

\seealso{ 
\code{\link[RJSDMX]{getProviders}},
\code{\link[RJSDMX]{getFlows}},
\code{\link[RJSDMX]{getDimensions}},
\code{\link[RJSDMX]{getCodes}}
}

\examples{
\dontrun{
  print(verifyQuery('IMFx', 'PGI.CA.*.*.*.*'))# returns FALSE

  print(verifyQuery('IMF', 'PGI.CA.*.*.*.*', verbose = FALSE)) # returns TRUE

  print(verifyQuery('IMF', 'PGI.CAN.*.*.*.*'))# returns FALSE 

  #print(verifyQuery('NBB', 'HICP.000000.*.*'))
  #print(verifyQuery('NBB', 'HICP.000000.BE.M'))
  }
}
\keyword{ts}
