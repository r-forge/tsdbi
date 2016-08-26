\name{TSdata-package}
\alias{TSdata-package}

\docType{package}

\title{Examples of Time Series Database Interface Packages}

\description{Examples of several "TS*" time series database interface packages
and use of multiple package simultaneously.
}

\section{Usage}{
   library("TSdata") 
}

\details{
This package generates vignettes \emph{Guide.pdf},
\emph{GuideAppendix.pdf} and \emph{GuideDevel.pdf}. 
The last covers work in progress and may be empty or broken.
The package contains no functions or data, and exists only to
generate the vignettes. These vignettes are available on CRAN, so the
package does not need to be installed. Installation can be difficult 
because of all the other packages that are required.
}

\seealso{
\code{
   \link[TSdbi]{TSdbi-package},
   \link[TSPostgreSQL]{TSPostgreSQLConnection-class},
   \link[TSMySQL]{TSMySQLConnection-class},
   \link[TSSQLite]{TSSQLiteConnection-class},
   \link[TSodbc]{TSodbcConnection-class},
   \link[TSsdmx]{TSsdmxConnection-class},
   \link[TSmisc]{TSmiscMethods},
   \link[TScompare]{TScompare},
   \link[tframe]{tframe-package},
   \link[tfplot]{tfplot},
   \link[zoo]{zoo},
   \link[xts]{xts-package},
   \link[tseries]{get.hist.quote},
   \link[WriteXLS]{WriteXLS},
   \link[DBI]{DBI-package},
   \link[RJSDMX]{RJSDMX-package},
   \link[RPostgreSQL]{PostgreSQLConnection-class},
   \link[RSQLite]{SQLiteConnection-class},
   \link[RMySQL]{RMySQL-package},
   \link[RODBC]{RODBC-package}
   }
}
\concept{TSdbi}
\keyword{ts}


