\name{TScompare}
\alias{TScompare}
\alias{summary.TScompare}
\alias{tfplot.TScompare}
\alias{tfDetails}
\alias{doubleCheck}

\title{Compare Time Series Data From Different Databases}
\description{Utilities for comparing time series from different databases.}
\usage{
    TScompare(ids, con1, con2, na.rm=FALSE, fuzz=1e-14)
    doubleCheck(x, con1=x$con1, con2=x$con2, na.rm=FALSE, fuzz=1e-10)
    tfDetails(x, con1=x$con1, con2=x$con2, na.rm=FALSE)
    \method{summary}{TScompare}(object, ...)
    \method{tfplot}{TScompare}(x, con1=x$con1, con2=x$con2, diff=FALSE, ...)
}
\arguments{
    \item{ids}{matrix with one or two columns of character strings indicating pairs
       of series identifiers. (See details.)}
    \item{x}{a TScompare object as returned by TScompare.}
    \item{con1}{a database connection as returned by TSconnect.}
    \item{con2}{a database connection as returned by TSconnect.}
    \item{na.rm}{a logical indicating if NA values should be removed from the 
       beginning and end of series.}
    \item{fuzz}{a small value indicating the tolerance within which values are
       considered to be the same.}
    \item{object}{a \code{TScompare} object as returned by \code{TScompare}.}
    \item{diff}{logical indicating if the difference should be plotted, rather 
       than the two series.}
    \item{...}{other arguments. (Not currently used.)}
}

\value{depends.}

\details{
\code{TScompare} compares series from two databases (\code{con1} and 
\code{con2}) to check if the series are the same. 
If \code{ids} is a vector or matrix with one column then the same series
identifiers are used for both databases. If\code{ids} is a matrix with two
columns then the first columns indicates the series ids on first database and 
the second column indicates corresponding id on the second database.

Series are first checked to see that they cover the same time window.
If the window comparison fails (is \code{FALSE}) then the value comparison 
is also indicated as \code{FALSE}. When the  window comparison is \code{TRUE}
then the  value comparison is set \code{TRUE} if all values are within
\code{fuzz} in absolute value.

The function \code{doubleCheck} reruns value comparisons using a different 
(relaxed) \code{fuzz}. It only checks \code{FALSE}
results, and returns the new result with a different fuzz. (It will be much 
quicker on very long checks if most series do not need to be rechecked.)
Connections (cons) may have expired if there is a long delay bfore running this,
in which case they need to be re-established.

The method \code{summary.TScompare} summarizes the result returned by \code{TScompare}
or \code{doubleCheck}.

The method \code{tfplot.TScompare} plots differences in the series.

The function \code{tfDetails} provides details about differences in the time
window for series that are not equal.
}

\seealso{ 
\code{\link{AllIds}},
\code{\link[TSdbi]{TSconnect}},
\code{\link[TSdbi]{TSget}}
}
\keyword{ts}

