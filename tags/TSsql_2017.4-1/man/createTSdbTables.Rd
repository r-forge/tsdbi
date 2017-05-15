\name{createTSdbTables}
\alias{createTSdbTables}
\alias{removeTSdbTables}

\title{Create and Remove Time Series Database Tables}
\description{Create or remove all the TS database tables.}
\usage{
  createTSdbTables(con, index=FALSE)
  removeTSdbTables(con, yesIknowWhatIamDoing=FALSE, ToLower=FALSE)
}
\arguments{
    \item{con}{A database connection object (NOT a TSconnect object).}
    \item{yesIknowWhatIamDoing}{logical to help prevent accidents.}
    \item{index}{logical to indicate if table date indexes should be added.}
    \item{ToLower}{logical indicating if table names should be converted to lower case.}
}
\value{logical to indicate success.}
\details{
The function createTSdbTables() creates tables on the database to store
time series data. Typically this is done only on initial setup, and might be 
done by a database administrator and not by an end user. (It is used for
examples and testing but will rarely be used otherwise.) Adding date indexes
(index=TRUE) will typically speed searching but may dramatically slow down
writing to the database (but for small databases it will not make much
difference either way).

The function removeTSdbTables removes all the TS database tables.
WARNING: use these function only if you know what you are doing. They destroy
the whole database and all stored series.
The function \code{removeTSdbTables} needs to work 
around the problem that different 
db engines treat capitalized table names differently. For example, MySQL uses
table name Meta while Posgresql converts to meta. The argument \code{ToLower}
indicates if table names should be converted to lower case.

The \code{con} needs to be specified. A default \code{con} is not used 
on purpose to help avoid accidental use. The argument \code{yesIknowWhatIamDoing}
defaults to \code{FALSE} and must be set to \code{TRUE} or the function will 
return an error. Beware that dropping tables will destory the 
integrity of the of
the database, and would usually only be done when you are intializing a TS database.
Database permission may also be set to prevent users from dropping tables. If that
is the case, then this function will return a failure error.
}
\seealso{
\code{\link[DBI]{dbConnect}},
\code{\link{TSdates}},
\code{\link{TSget}},
\code{\link{TSput}}
}
\keyword{ts}


