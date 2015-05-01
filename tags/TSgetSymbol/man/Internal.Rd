\name{Internal}
\alias{dbConnect,getSymbolConnection-method}
\alias{dbDisconnect,getSymbolConnection-method}

\alias{getSymbolDriver-class}

\title{Internal DBI Methods for getSymbols}
\description{Pretend  getSymbols has DBI methods for connections.}
\usage{
    \S4method{dbConnect}{getSymbolConnection}(drv, dbname, ...)
    \S4method{dbDisconnect}{getSymbolConnection}(conn,...)
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
