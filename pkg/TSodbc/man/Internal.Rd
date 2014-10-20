\name{Internal}

\alias{dbConnect,odbcDriver-method}
\alias{dbDisconnect,odbcConnection-method}

\alias{odbcDriver-class}

\title{Internal DBI Methods for TSodbc}
\description{Pretend TSodbc has DBI methods for connections.}
\usage{
    \S4method{dbConnect}{odbcDriver}(drv, dbname, ...)
    \S4method{dbDisconnect}{odbcConnection}(conn,...)

    \S4method{dropTStable}{RODBC,character,ANY}(con, Table, 
                           yesIknowWhatIamDoing=FALSE)

    \S4method{dbExistsTable}{RODBC,character}(conn, name, ...)
    \S4method{dbRemoveTable}{RODBC,character}(conn, name, ...)
    \S4method{dbGetQuery}{RODBC,character}(conn, statement, ...)
    \S4method{dbListTables}{RODBC}(conn,...)
}
\arguments{
    \item{drv}{a database driver object.}
    \item{dbname}{a character string indicating the name of a database.}
    \item{conn}{a database connection object.}
    \item{name}{A database table.}
    \item{statement}{Character string with an SQL statement.}
    \item{yesIknowWhatIamDoing}{logical to help prevent accidents.}
    \item{...}{Arguments passed to methods.}
}
\value{Depends.}
\details{
These methods just fake DBI connections. 
}
\keyword{internal}
