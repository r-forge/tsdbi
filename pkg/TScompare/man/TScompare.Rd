\name{TScompare}
\alias{TScompare}
\alias{summary.TScompare}
\alias{tfplot.TScompare}
\alias{AllIds}
\alias{AllPanels}
\alias{AllVintages}

\title{Compare Time Series Data From Different Databases}
\description{Utilities for comparing time series from different databases.}
\usage{
    TScompare(ids, con1, con2, na.rm=FALSE, fuzz=1e-14)
    doubleCheck(x, con1=x$con1, con2=x$con2, na.rm=FALSE, fuzz=1e-10)
    tfDetails(x, con1=x$con1, con2=x$con2, na.rm=FALSE)
    \method{summary}{TScompare}(object, ...)
    \method{tfplot}{TScompare}(x, con1, con2, diff=FALSE, ...)
    AllIds(con)
    AllPanels(con)
    AllVintages(con)
}
\arguments{
    \item{ids}{matrix with two columns of character strings indicating pairs
       of series identifiers. (See details.)}
    \item{x}{a TScompare object as returned by TScompare.}
    \item{con}{a database connection as returned by TSconnect.}
    \item{con1}{a database connection as returned by TSconnect.}
    \item{con2}{a database connection as returned by TSconnect.}
    \item{na.rm}{a logical indicating if NA values should be removed from the 
       beginning and end of series.}
    \item{fuzz}{a small value indicating the tolerance within which values are
       considered to be the same.}
    \item{object}{a \code{TScompare} object as returned by \code{TScompare}.}
    \item{x}{a \code{TScompare} object as returned by \code{TScompare} to plot.}
    \item{diff}{logical indicating if the difference should be plotted, rather 
       than the two series.}
    \item{...}{other arguments. (Not currently used.)}
}
\value{depends.}
\details{ MORE HERE
If the window comparison fails (is \code{FALSE}) then the value comparison 
is also indicated as \code{FALSE}. When the  window comparison is \code{TRUE}
then the  value comparison is set \code{TRUE} if all values are within
\code{fuzz} in absolute value.

The function \code{doubleCheck} reruns value comparisons only for \code{FALSE}
results, and returns the result with a relaxed fuzz. (It will be much quicker 
on very long checks if most series do not need to be rechecked.)
The default connections may have expired, in which case they need to be 
specified.
}

\seealso{ 
\code{\link[TSdbi]{TSconnect}}
\code{\link[TSdbi]{TSget}},
}
\keyword{ts}

