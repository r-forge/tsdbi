\name{TSsdmxMethods}
\alias{sdmx}

\alias{TSconnect,sdmxConnection,missing-method}
\alias{TSget,character,TSsdmxConnection-method}
\alias{TSdates,character,TSsdmxConnection-method}
\alias{TSdescription,character,TSsdmxConnection-method}
\alias{TSdoc,character,TSsdmxConnection-method}
\alias{TSlabel,character,TSsdmxConnection-method}
\alias{TSsource,character,TSsdmxConnection-method}

\alias{TSsdmxConnection-class}

\title{Methods to wrap sdmx  for TSdbi Generics}
\description{Get a time series (matrix) using SDMX, for example, from the OECD database.}
\usage{
    sdmx(...) 
    \S4method{TSconnect}{sdmxConnection,missing}(
	q, dbname, user="", password = "", host="", ...)
    \S4method{TSget}{character,TSsdmxConnection}(
	serIDs, con, TSrepresentation = options()$TSrepresentation, 
	tf = NULL, start = tfstart(tf), end = tfend(tf), names=serIDs, 
	quiet = TRUE, ...)
    \S4method{TSdates}{character,TSsdmxConnection}(
	serIDs, con, vintage=NULL, panel=NULL, ... )  
    \S4method{TSdescription}{character,TSsdmxConnection}(x, con, ... )  
    \S4method{TSdoc}{character,TSsdmxConnection}(x, con, ... )  
    \S4method{TSlabel}{character,TSsdmxConnection}(x, con, ... )  
    \S4method{TSsource}{character,TSsdmxConnection}(x, con, ... )  
}
\arguments{
    \item{q}{A character string indicating the query interface to use, or
         a database connection object.}
    \item{dbname}{The name of the database to which the connection should be
         established, omitted if \code{q} is a database connection object.}
    \item{con}{a database connection object.}
    \item{serIDs}{identifiers for series on the database.}
    \item{vintage}{character string indicating vintage of the series on the 
        database (not supported by this database).}
    \item{panel}{character string indicating panel of the series on the 
        database (not supported by this database).}
    \item{x}{time series data(TSput), or 
      identifiers for series on the database (TSdoc and TSdescription).}
    \item{names}{optional character vector to use for series names in the R
    object. See details.}
    \item{tf}{time frame for trimming data, passed to tfwindow.}
    \item{start}{time frame for trimming data, passed to tfwindow.}
    \item{end}{time frame for trimming data, passed to tfwindow.}
    \item{TSrepresentation}{time representation for returned series. 
          (See \code{TSget} in package \pkg{TSdbi}.)}
    \item{quiet}{logical to suppress progress report.}
    \item{user}{(unused) a character string indicating a user id.}
    \item{password}{(unused) a character string indicating a password.}
    \item{host}{(unused) a character string indicating a host computer.}
    \item{...}{Arguments passed to other methods or to sdmxCall.}
}
\value{Depends.}
\details{
These functions interface to the SDMX databases such as the OECD web portal. 
\code{TSget} is a wrapper to \code{RJSDMX::getSDMX} to provided an
interface that is consistent with \pkg{TSdbi}. 
The \pkg{TSdbi} function argument \code{serIds} is passed as the series to 
return, and \code{dbname} indicates the data provider (e.g. "OECD").
The SDMX query syntax allows for the possibility of indicating several series
by using  \code{+, |} and \code{*} characters. For example, 
\code{'G20_PRICES.CAN+MEX.CPALTT01.IXOB.M'} would indicate Canada and Mexico,
while \code{'G20_PRICES.*.CPALTT01.IXOB.M'} would indicate all countries.
By default, \code{TSget} will uses series names as returned by the SDMX call.
The argument \code{names} can be used to replace names, but only in some 
situations. 
If \code{*} is used in \code{serIds} then \code{names} will be ignored because
the number and order of the returned series cannot be guaranteed.
If \code{+} or \code{|} are used in more than one field then \code{names} 
will be ignored.
If \code{+} or \code{|} are used in only one field then \code{names} 
will applied, but this requires that \code{TSget} sort the series in the 
specified order since the SDMX call does not guarantee the return order. 
(This may change, an enhancement request has been made.)
Thus, specifying \code{serIds} as  \code{'G20_PRICES.CAN+MEX.CPALTT01.IXOB.M'} 
or specifying it as \code{c('G20_PRICES.CAN.CPALTT01.IXOB.M', 
'G20_PRICES.MEX.CPALTT01.IXOB.M')} should return the same result, but the 
mechanism is different. In the first case the \code{getSdmx} call returns both 
series and then the \code{TSget} sorts the result into the proper order to 
apply the names.
In  the second case the \code{TSget} code makes two separate calls to 
\code{getSdmx}.

The treatment of  \code{start}  and \code{end} dates also differs in a subtle
way depending on the specification. A character specification is assumed to be
an SDMX specification, so \code{start="1990-Q1"} is passed unchanged as part of
the  \code{getSdmx} call whereas  \code{start=c(1990,1)} cannot detemine the
frequency, so uses \code{getSdmx} to return the whole series, then truncates 
at the appropriate start date.

(See \code{TSget} in \pkg{TSdbi} for more details on \code{TSget}.)

\pkg{TSsdmx} does not support writing data to the source.

The class \code{TSsdmxConnection} extends class
\code{DBIConnection} in the DBI package.

See the vignette in \pkg{TSdata} for additional examples.

When the \pkg{TSsdmx} method \code{TSconnect} is first used the underlying code 
reads a configuration file that sets, among other things, the 
amount of printout done during retrieval. The default is useful for debugging 
but will be more than typically expected in an \code{R} session. 
A system wide default location for this file can be set. 
A user's default will be found in the users home directory (~/.SdmxClient in
Linux). More details on this file can be found at 
\url{https://github.com/amattioc/SDMX/wiki/Configuration}. \code{R} users will
probably want to specify \code{SDMX.level = OFF} and 
\code{java.util.logging.ConsoleHandler.level = OFF}
to suppress most printed output. Otherwise, \code{R} programs that 
use \code{try()} will not suppress printed error messages as they should. 
With the levels set OFF, the error and warning messages are still returned to
the \code{R} to deal with as appropriate.
}

\seealso{ 
\code{\link[RJSDMX]{getSDMX}},
\code{\link[TSdbi]{TSdates}},
\code{\link[TSdbi]{TSget}},
\code{\link[tframe]{tfwindow}},
}
\examples{
  require("TSsdmx")
  require("tfplot")
  \dontrun{
  oecd <- TSconnect("sdmx", dbname="OECD")
  x <- TSget('G20_PRICES.CAN.CPALTT01.IXOB.M',oecd) 
  tfplot(x)
  }
}
\keyword{ts}
