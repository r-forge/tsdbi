\name{Internal}
\alias{histQuoteDriver-class}
\alias{dbConnect,histQuoteDriver-method}
\alias{dbDisconnect,histQuoteConnection-method}

\alias{getSymbolDriver-class}
\alias{dbConnect,getSymbolConnection-method}
\alias{dbDisconnect,getSymbolConnection-method}

\alias{zipDriver-class}
\alias{dbConnect,TSzipDriver-method}
\alias{dbDisconnect,TSzipConnection-method}

\alias{xlsDriver-class}
\alias{dbConnect,TSxlsDriver-method}
\alias{dbDisconnect,TSxlsConnection-method}


\alias{dbConnect,TSQuandlDriver-method}
\alias{dbDisconnect,TSQuandlConnection-method}
\alias{dbObjectId-class}
\alias{QuandlObject-class}
\alias{QuandlDriver-class}


\title{Internal DBI Methods for histQuote}
\description{Pretend histQuote has DBI methods for connections.}
\usage{
    \S4method{dbConnect}{histQuoteDriver}(drv, dbname, ...)
    \S4method{dbDisconnect}{histQuoteConnection}(conn, ...)

    \S4method{dbConnect}{TSzipConnection}(drv, dbname, ...)
    \S4method{dbDisconnect}{TSzipConnection}(conn,...)

    \S4method{dbConnect}{getSymbolConnection}(drv, dbname, ...)
    \S4method{dbDisconnect}{getSymbolConnection}(conn,...)

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
