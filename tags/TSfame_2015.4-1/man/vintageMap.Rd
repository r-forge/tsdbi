\name{vintageMap}
\alias{vintageMap}

\title{Read vintage names and file paths to use for TSconnect}
\description{Read vintage names and file paths to use for TSconnect.}
\usage{
    vintageMap(file)
}
\arguments{
    \item{file}{A character string indicating a file.}
}
\value{a character vector with names}
\details{
The argument \code{file} should be a character string indicating a 
file that will be read. The file should have lines with two space separated
columns, the first indicating a name to be used for a vintage, e.g.,
2009-01-07, and the second indicating the path to the database file to use for
that vintage, e.g., /path/to/ets_2009-01-07.db. The file is read and the 
result is a string that can be passed as the dbname to TSfame's TSconnect 
method.
}

\seealso{ 
\code{\link{TSconnect}}
}
\keyword{ts}

