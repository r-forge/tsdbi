\name{createTSdbTables}
\alias{createTSdbTables}
\alias{dropTStable}
\alias{removeTSdbTables}

\title{Drop (Remove) a Database Table}
\description{Drop (remove) a database table if it exists.}
\usage{
  createTSdbTables(con, index=FALSE)
  removeTSdbTables(con, yesIknowWhatIamDoing=FALSE)
  dropTStable(con, Table, yesIknowWhatIamDoing=FALSE)
}
\arguments{
    \item{con}{A database connection.}
    \item{Table}{A character string indicating a table to drop.}
    \item{yesIknowWhatIamDoing}{logical to help prevent accidents.}
    \item{index}{logical to indicate if table date indexes should be added.}
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

The functions dropTStable and removeTSdbTables remove an individual database
table and all the TS database tables respectively.
WARNING: use these function only if you know what you are doing. They destroy
the whole database and all stored series.
The function \code{dropTStable} removes the indicated table if it exists on 
the \code{con}. The function dropTStable needs to be generic in order to work 
around the problem that different 
db engines treat capitalized table names differently. For example, MySQL uses
table name Meta while Posgresql converts to meta. A default \code{con} is not used 
on purpose to help avoid accidental use. The arument \code{yesIknowWhatIamDoing}
defaults to \code{FALSE} and must be set to \code{TRUE} or the function will 
return an error. Beware that dropping tables will likely destory the 
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


