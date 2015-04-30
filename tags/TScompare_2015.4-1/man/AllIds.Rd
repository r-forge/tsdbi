\name{AllIds}
\alias{AllIds}
\alias{AllPanels}
\alias{AllVintages}

\title{Extract Series Information from a Databases}
\description{Utilities for series information from databases.}
\usage{
    AllIds(con, vintage=getOption("TSvintage"))
    AllPanels(con)
    AllVintages(con)
}
\arguments{
    \item{con}{a database connection as returned by TSconnect.}
    \item{vintage}{the  vintage for which series identifiers will be returned.}
}
\value{depends.}
\details{ MORE HERE
The function \code{AllIds} returns a string vector of all the series 
identifiers in the database.

The function \code{AllPanels} returns a string vector of all the panel 
identifiers in the database.

The function \code{AllVintages} returns a string vector of all the vintages 
in the database.
}

\seealso{ 
\code{\link{TScompare}},
\code{\link[TSdbi]{TSconnect}},
\code{\link[TSdbi]{TSget}}
}
\keyword{ts}

