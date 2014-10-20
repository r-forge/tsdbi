\name{Internal}

\alias{dbConnect,TSxlsDriver-method}
\alias{dbDisconnect,TSxlsConnection-method}

\alias{xlsDriver-class}

\title{Internal DBI Methods for TSxls}
\description{Pretend TSxls has DBI methods for connections.}
\usage{
    \S4method{dbConnect}{TSxlsConnection}(drv, dbname, ...)
    \S4method{dbDisconnect}{TSxlsConnection}(conn,...)
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
