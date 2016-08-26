\name{Internal}

\alias{dbConnect,TSsdmxDriver-method}
\alias{dbDisconnect,TSsdmxConnection-method}

\alias{sdmxDriver-class}

\title{Internal DBI Methods for TSsdmx}
\description{Pretend TSsdmx has DBI methods for connections.}
\usage{
    \S4method{dbConnect}{TSsdmxConnection}(drv, dbname, ...)
    \S4method{dbDisconnect}{TSsdmxConnection}(conn,...)
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
