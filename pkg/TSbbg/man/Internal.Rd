\name{Internal}

\alias{dbConnect,bbgDriver-method}
\alias{dbDisconnect,bbgConnection-method}

\alias{bbgDriver-class}

\title{Internal DBI Methods for TSbbg}
\description{Pretend TSbbg has DBI methods for connections.}
\usage{
    \S4method{dbConnect}{bbgDriver}(drv, dbname, ...)
    \S4method{dbDisconnect}{bbgConnection}(conn,...)
}
\arguments{
    \item{drv}{a database driver object.}
    \item{dbname}{a character string indicating the name of a database.}
    \item{conn}{a database connection object.}
    \item{...}{Arguments passed to methods.}
}
\value{Depends.}
\details{
These methods just fake DBI connections. 
}
\keyword{internal}
