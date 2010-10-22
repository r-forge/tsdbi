\name{TSdbiMethods}
\alias{TSconnect,SQLiteDriver,character-method}
\alias{TSget,character,SQLiteConnection-method}
\alias{TSput,ANY,character,SQLiteConnection-method}
\alias{TSdelete,character,SQLiteConnection-method}
\alias{TSdescription,character,SQLiteConnection-method}
\alias{TSdoc,character,SQLiteConnection-method}
\alias{TSlabel,character,SQLiteConnection-method}
\alias{TSdates,character,SQLiteConnection-method}
\alias{print,TSSQLiteConnection-method}
\alias{dropTStable,SQLiteConnection,character,ANY-method}
\alias{dropTStable,SQLiteConnection,character-method}

\alias{TSSQLiteConnection-class}

\title{TSdbi SQLite Methods}
\description{Methods for TSdbi SQLite time series dtabase connection.}
\usage{
    \S4method{TSconnect}{SQLiteDriver,character}(drv, dbname, ...)
    \S4method{TSget}{character,SQLiteConnection}(
	serIDs, con, TSrepresentation=options()$TSrepresentation,
	tf=NULL, start=tfstart(tf), end=tfend(tf),
	names=NULL, TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE,
	vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSput}{ANY,character,SQLiteConnection}(
	x, serIDs, con, Table=NULL, 
	TSdescription.=TSdescription(x), TSdoc.=TSdoc(x),  TSlabel.=TSlabel(x), 
	vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdates}{character,SQLiteConnection}(
	serIDs, con, 
	vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdelete}{character,SQLiteConnection}(
	serIDs, con,  
	vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    \S4method{TSdescription}{character,SQLiteConnection}(x, con, ...)
    \S4method{TSdoc}{character,SQLiteConnection}(x, con, ...)
    \S4method{TSlabel}{character,SQLiteConnection}(x, con, ...)
    \S4method{print}{TSSQLiteConnection}(x, ...)
    \S4method{dropTStable}{SQLiteConnection,character,ANY}(con, Table, 
                           yesIknowWhatIamDoing=FALSE)
}
\arguments{
    \item{drv}{A SQLiteDriver.}
    \item{dbname}{A character string indicating a database name.}
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
    \item{Table}{Character string indicating database table. (In TSput this is 
    	necessary if it cannot be determined automatically).}
    \item{vintage}{Vintage to be supplied (if supported by db).}
    \item{panel}{Panel to be supplied (if supported by db).}
    \item{yesIknowWhatIamDoing}{logical to help prevent accidents.}
    \item{...}{Arguments passed to other methods.}
}
\value{depends.}
\details{
These are SQLite methods for \pkg{TSdbi}. See the \pkg{TSdbi} for details and
see the vignette distributed with this package for more complete examples.
}

\seealso{ 
\code{\link[TSdbi]{TSdbi-package}},
\code{\link[DBI]{dbConnect}},
\code{\link[TSdbi]{TSput}},
\code{\link[TSdbi]{TSget}}
}
\examples{
    con <- try(TSconnect(dbDriver("SQLite"), dbname="test"))
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
    con <- try(TSconnect(dbDriver("SQLite"), dbname="ets"))
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

