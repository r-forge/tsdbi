\name{TSdbiMethods}
\alias{TSconnect,PostgreSQLDriver,character-method}
\alias{TSget,character,TSPostgreSQLConnection-method}
\alias{TSput,ANY,character,TSPostgreSQLConnection-method}
\alias{TSdelete,character,TSPostgreSQLConnection-method}
\alias{TSdescription,character,TSPostgreSQLConnection-method}
\alias{TSdoc,character,TSPostgreSQLConnection-method}
\alias{TSlabel,character,TSPostgreSQLConnection-method}
\alias{TSsource,character,TSPostgreSQLConnection-method}
\alias{TSdates,character,TSPostgreSQLConnection-method}
\alias{TSvintages,TSPostgreSQLConnection-method}
\alias{dropTStable,PostgreSQLConnection,character,ANY-method}
\alias{dropTStable,PostgreSQLConnection,character-method}

\alias{TSPostgreSQLConnection-class}

\title{TSdbi PostgreSQL Methods}
\description{Methods for TSdbi PostgreSQL time series dtabase connection.}
\usage{
    \S4method{TSconnect}{PostgreSQLDriver,character}(drv, dbname, host = 
       if(!is.null(Sys.getenv("PGHOST"))) Sys.getenv("PGHOST") else "localhost", ...)
    \S4method{TSget}{character,TSPostgreSQLConnection}(serIDs, 
       con=getOption("TSconnection"), 
       TSrepresentation=getOption("TSrepresentation"),
       tf=NULL, start=tfstart(tf), end=tfend(tf), names=NULL, 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSput}{ANY,character,TSPostgreSQLConnection}(x, serIDs, con, Table=NULL, 
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=TSlabel(x),
       TSsource.=TSsource(x), 
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdates}{character,TSPostgreSQLConnection}(serIDs, con,  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdelete}{character,TSPostgreSQLConnection}(serIDs, con,  
   vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdescription}{character,TSPostgreSQLConnection}(x, con, ...)
    \S4method{TSdoc}{character,TSPostgreSQLConnection}(x, con, ...)
    \S4method{TSlabel}{character,TSPostgreSQLConnection}(x, con, ...)
    \S4method{TSsource}{character,TSPostgreSQLConnection}(x, con, ...)
    \S4method{TSvintages}{TSPostgreSQLConnection}(con)
    \S4method{dropTStable}{PostgreSQLConnection,character,ANY}(con, Table, 
                           yesIknowWhatIamDoing=FALSE)
}
\arguments{
    \item{drv}{A PostgreSQLDriver.}
    \item{dbname}{A character string indicating a database name.}
    \item{con}{A database connection.}
    \item{serIDs}{Character string identifiers for series to extract.}
    \item{host}{A character string indicating the server.}
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
    \item{TSlabel}{TRUE or FALSE indicating whether series label 
       should be extracted.}
    \item{TSlabel.}{Short series label to put on the database.}
    \item{TSsource}{TRUE or FALSE indicating whether source indicator 
       should be extracted.}
    \item{TSsource.}{Source indicator to put on the database.}
    \item{Table}{Character string indicating database table. (In TSput this is 
    	necessary if it cannot be determined automatically).}
    \item{vintage}{Vintage to be supplied (if supported by db).}
    \item{panel}{Panel to be supplied (if supported by db).}
    \item{yesIknowWhatIamDoing}{logical to help prevent accidents.}
    \item{...}{Arguments passed to other methods.}
}
\value{depends.}
\details{
These are PostgreSQL methods for \pkg{TSdbi}. The \dots argument to TSconnect 
can be used to pass the
user name and password information to \code{dbConnect}. See the \pkg{TSdbi} for details and
see the vignette distributed with this package for more complete examples.
}

\seealso{ 
\code{\link[TSdbi]{TSdbi-package}},
\code{\link[DBI]{dbConnect}},
\code{\link[TSdbi]{TSput}}
}
\examples{
    con <- try(TSconnect(dbDriver("PostgreSQL"), dbname="test"))
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
      }
    con <- try(TSconnect(dbDriver("PostgreSQL"), dbname="ets"))
    if(! inherits(con, "try-error")) {
      TSmeta("B103", con)
      z1 <- TSget("B103", con)
      tfplot(z1)
      z2 <- TSget(c("B103", "B104"), con)
      tfplot(z2)
      options(TSconnection=con)
      TSmeta("B103")
      z2 <- TSget(c("B103","B104"))
      TSmeta(z2)
      TSdates("D1", con)
      TSdates("B103", con)
      TSdates(c("D1","B103","B104"), con)
      z <- TSdates(c("D1","B103","B104"))
      print(z)
      start(z)
      end(z)
      }
}
\keyword{ts}

