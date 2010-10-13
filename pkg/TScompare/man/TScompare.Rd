\name{TScompare}
\alias{TScompare}
\alias{summary.TScompare}
\alias{AllIds}
\alias{AllPanels}
\alias{AllVintages}

\title{Construct Time Series Data From a Database}
\description{Construct a time series from a database}
\usage{
    TScompare(ids, con1, con2, na.rm=FALSE, fuzz=1e-14)
    summary.TScompare(x)
    AllIds(con)
    AllPanels(con)
    AllVintages(con)
}
\arguments{
    \item{ids}{matrix with two columns of character strings indicating pairs
       of series identifiers. (See details.)}
    \item{con}{a database connection as returned by TSconnect.}
    \item{con1}{a database connection as returned by TSconnect.}
    \item{con2}{a database connection as returned by TSconnect.}
    \item{na.rm}{a logical indicating if NA values should be removed from the 
       beginning and end of series.}
    \item{fuzz}{a small value indicating the tolerance within which values are
       considered to be the same.}
    \item{x}{a \code{TScompare} object as returned by \code{TScompare}.}
}
\value{depends.}
\details{
}

\seealso{ 
\code{\link[TSdbi]{TSconnect}}
\code{\link[TSdbi]{TSget}},
}
\keyword{ts}
