\name{TSdbiMethods}
\alias{MySQL}

\alias{TSconnect,MySQLConnection,missing-method}
\alias{TSget,character,TSMySQLConnection-method}
\alias{TSput,ANY,character,TSMySQLConnection-method}
\alias{TSdelete,character,TSMySQLConnection-method}
\alias{TSdescription,character,TSMySQLConnection-method}
\alias{TSdoc,character,TSMySQLConnection-method}
\alias{TSlabel,character,TSMySQLConnection-method}
\alias{TSsource,character,TSMySQLConnection-method}
\alias{TSdates,character,TSMySQLConnection-method}
\alias{TSvintages,TSMySQLConnection-method}

\alias{TSMySQLConnection-class}

\title{TSdbi MySQL Methods}
\description{Methods for TSdbi MySQL time series dtabase connection.}
\usage{
    MySQL(...)
    \S4method{TSconnect}{MySQLConnection,missing}(q, dbname, ...)
    \S4method{TSget}{character,TSMySQLConnection}(serIDs, con, 
       TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf), names=NULL, 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"),   ...)
    \S4method{TSput}{ANY,character,TSMySQLConnection}(x, serIDs, con, Table=NULL, 
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=TSlabel(x),
        TSsource.=TSsource(x),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"),  ...)
    \S4method{TSdates}{character,TSMySQLConnection}(serIDs, con,  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdelete}{character,TSMySQLConnection}(serIDs, con,  
   vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdescription}{character,TSMySQLConnection}(x, con, ...)
    \S4method{TSdoc}{character,TSMySQLConnection}(x, con, ...)
    \S4method{TSlabel}{character,TSMySQLConnection}(x, con, ...)
    \S4method{TSsource}{character,TSMySQLConnection}(x, con, ...)
    \S4method{TSvintages}{TSMySQLConnection}(con)
}
\arguments{
    \item{q}{A character string indicating the query interface to use, or
         a database connection object.}
    \item{dbname}{The name of the database to which the connection should be
         established, omitted if \code{q} is a database connection object.}
    \item{con}{A database connection.}
    \item{serIDs}{identifiers for series to extract.}
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
    \item{TSsource}{TRUE or FALSE indicating whether source indication 
       should be extracted.}
    \item{TSsource.}{Source indication to put on the database.}
    \item{Table}{Character string indicating database table. (In TSput this is 
    	necessary if it cannot be determined automatically).}
    \item{vintage}{Vintage to be supplied (if supported by db).}
    \item{panel}{Panel to be supplied (if supported by db).}
    \item{...}{Arguments passed to other methods or to RMySQL::MySQL}
}
\value{depends.}
\details{
These are MySQL methods for \pkg{TSdbi}. See the \pkg{TSdbi} for details and
see the vignette distributed with package \pkg{TSdata} for more complete 
examples. 
Package \pkg{TSsql} is required for functions createTSdbTables() and
removeTSdbTables().
Typically createTSdbTables() will only be done once, and the tables
will not be removed. These steps are done in the example below.
}

\seealso{ 
\code{\link[TSdbi]{TSdbi-package}},
\code{\link[DBI]{dbConnect}},
\code{\link[TSdbi]{TSput}}
}
\examples{
    require("tfplot")
    \dontrun{
      conInit <- RMySQL::dbConnect(RMySQL::MySQL(), dbname="test")
      TSsql::createTSdbTables(conInit, index=FALSE)
      con <- TSconnect("MySQL", dbname="test")
      z <- ts(rnorm(100), start=c(1975,1), frequency=12)
      seriesNames(z) <- "random1"
      if(TSexists("random1", con)) TSreplace(z, con) else
      TSput(z, con)
      z1 <- TSget("random1", con)
      tfplot(z1)
      z <- ts(matrix(rnorm(100),50,2), start=c(1975,1), frequency=4)
      seriesNames(z) <- c("random2","random3")
      if(TSexists("random2", con) |
         TSexists("random3", con) ) TSreplace(z, con) else TSput(z, con)
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
      TSsql::removeTSdbTables(con, yesIknowWhatIamDoing=TRUE)
      con <- try(TSconnect("MySQL", dbname="ets"))
      if(!inherits(con, "try-error")){
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
}
\keyword{ts}

