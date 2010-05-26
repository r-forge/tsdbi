\name{TSdbiMethods}
\alias{TSconnect,fameDriver,character-method}
\alias{TSget,character,TSfameConnection-method}
\alias{TSput,ANY,character,TSfameConnection-method}
\alias{TSdelete,character,TSfameConnection-method}
\alias{TSdoc,character,TSfameConnection-method}
\alias{TSdescription,character,TSfameConnection-method}
\alias{TSlabel,character,TSfameConnection-method}
\alias{TSdates,character,TSfameConnection-method}
\alias{TSexists,character,TSfameConnection-method}

\alias{dbDisconnect,TSfameConnection-method}
\alias{dbUnloadDriver,fameDriver-method}

\alias{fame}

\alias{TSfameConnection-class}
\alias{dbObjectId-class}
\alias{fameObject-class}
\alias{fameDriver-class}

\title{TSdbi fame Methods}
\description{Methods for TSdbi fame time series dtabase connection.}
\usage{
    \S4method{TSconnect}{fameDriver,character}(
	drv, dbname, 
	accessMode = if (file.exists(dbname)) "shared" else "create", ...)
    \S4method{TSget}{character,TSfameConnection}(
	serIDs, con, 
	TSrepresentation = getOption("TSrepresentation"), 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names = serIDs,
	TSdescription = FALSE, TSdoc = FALSE, TSlabel=FALSE,   ...)
    \S4method{TSput}{ANY,character,TSfameConnection}(
	x, serIDs=seriesNames(x), con, TSdescription.=TSdescription(x),
	TSdoc.=TSdoc(x), TSlabel.=NULL, warn = TRUE, ...)
    \S4method{TSdates}{character,TSfameConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ...)
    \S4method{TSexists}{character,TSfameConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ...)
    \S4method{TSdelete}{character,TSfameConnection}(serIDs, con,  
            vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdescription}{character,TSfameConnection}(x, con, ...)
    \S4method{TSdoc}{character,TSfameConnection}(x, con, ...)
    \S4method{TSlabel}{character,TSfameConnection}(x, con, ...)

    \S4method{dbDisconnect}{TSfameConnection}(conn,...)
    \S4method{dbUnloadDriver}{fameDriver}(drv, ...)

    \method{fame}{default}()
}
\arguments{
    \item{drv}{A fameDriver.}
    \item{dbname}{A character string indicating a [server and] database name.}
    \item{con}{A database connection.}
    \item{conn}{A database connection.}
    \item{serIDs}{identifiers for series to extract.}
    \item{vintage}{character string indicating vintage of the series on the 
        database (not supported by this database).}
    \item{panel}{character string indicating panel of the series on the 
        database (not supported by this database).}
    \item{x}{data series to put on the database, or a series identifier for
       TSdescription and TSdoc or, for print, 
       a database connection as returned by TSconnect.}
    \item{TSrepresentation}{time series representation to use for the result.}
    \item{names}{Optional character vector to use for series names.}
    \item{tf}{Optional tframe to use for truncating data. (See \code{tfwindow}.)}
    \item{start}{Optional start date to use for truncating data. (See \code{tfwindow}.)}
    \item{end}{Optional end date to use for truncating data. (See \code{tfwindow}.)}
    \item{TSdescription}{TRUE or FALSE indicating whether description 
       should be extracted}
    \item{TSdescription.}{Description to put on the database.}
    \item{TSdoc}{TRUE or FALSE indicating whether documentation 
       should be extracted.}
    \item{TSdoc.}{Documentation to put on the database.}
    \item{TSlabel}{For compatibility with other TS packages. Not supported in
        Fame}
    \item{TSlabel.}{For compatibility with other TS packages. Not supported in
        Fame}
    \item{warn}{Logical indicating if warning messages should be suppressed.} 
    \item{accessMode}{Optional character indicating the mode to use when opening 
          the Fame database when establishing the first connection. After the 
	  first connection, "read" will be used for reading and "update" for writing.}
    \item{...}{Arguments passed to other methods.}
}
\value{depends.}
\details{
These are fame methods for \pkg{TSdbi}. See the package \pkg{TSdbi} for details 
and see the vignette distributed with this package for more complete examples.
}

\seealso{ 
\code{\link[TSdbi]{TSdbi-package}},
\code{\link[DBI]{dbConnect}},
\code{\link[TSdbi]{TSput}}
}
\examples{
    con <- try(TSconnect(dbDriver("fame"), dbname="test.db"))
    if(! inherits(con, "try-error")) {
      z <- ts(rnorm(100), start=c(1975,1), frequency=12)
      seriesNames(z) <- "random1"
      if(TSexists("random1", con)) TSreplace(z, con) else
      TSput(z, con)
      z1 <- TSget("random1", con)
      tfplot(z1)
      z <- ts(matrix(rnorm(100),50,2), start=c(1975,1), frequency=4)
      seriesNames(z) <- c("random2","random3")
      if(TSexists("random2", con) |
         TSexists("random3", con) ) TSreplace(z, con) else
      TSput(z, con)
      z2 <- TSget("random2", con)
      tfplot(z2)
      TSdates("D1", con)
      TSdates("random2", con)
      TSdates(c("random1","random2","random3"), con)
      TSmeta("random2", con)
      options(TSconnection=con)
      z2 <- TSget(c("random2","random3"))
      z <- TSdates(c("D1","random2","random3"))
      print(z)
      TSmeta("random2")
      TSdelete("random1", con)
      TSdelete("random2")
      dbDisconnect(con)
      }
}
\keyword{ts}

