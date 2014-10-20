\name{Internal}

\alias{dbConnect,TSfameDriver-method}
\alias{dbDisconnect,TSfameConnection-method}

\alias{fameLocalDriver-class}

\title{Internal DBI Methods for TSfame}
\description{Pretend TSfame has DBI methods for connections.}
\usage{
    \S4method{dbConnect}{fameLocalConnection}(drv, dbname, ...)
    \S4method{dbConnect}{fameServerConnection}(drv, dbname, ...)

    \S4method{dbDisconnect}{fameLocalConnection}(conn,...)
    \S4method{dbDisconnect}{fameServerConnection}(conn,...)
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
