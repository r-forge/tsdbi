\name{Internal}
\alias{QuandlDriver-class}

\alias{dbConnect,TSQuandlDriver-method}
\alias{dbDisconnect,TSQuandlConnection-method}

\alias{dbObjectId-class}
\alias{QuandlObject-class}

\title{Internal DBI Methods for TSQuandl}
\description{Pretend TSQuandl has DBI methods for connections.}
\usage{
    \S4method{dbConnect}{TSQuandlConnection}(drv, dbname, ...)
    \S4method{dbDisconnect}{TSQuandlConnection}(conn,...)
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
