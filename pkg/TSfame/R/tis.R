
tframe.tis <- function (x) {
  tf <- time(x)
  class(tf) <- c( "tistframe", class(tf), "tframe")
  tf
  }

tfSet.tistframe <- function(value, x) {
   r <- tis:::tis(x, value) 
   if (inherits(r, "try-error")) {r <- x ; attr(r, "tframe") <- value}
   r
   }

tfstart.tis <- function(x) tis:::start(x)
tfend.tis   <- function(x) tis:::end(x)

tfstart.tistframe <- function(x) x[1]
tfend.tistframe   <- function(x) x[length(x)]
tfperiods.tistframe   <- function(x) length(x)
periods.tistframe     <- function(x) length(x)

tfwindow.tis <- function(x, tf=NULL, start=tfstart(tf), end=tfend(tf), warn=TRUE)
  {# With the default warn=T warnings will be issued if no truncation takes
   #  place because start or end is outside the range of data.
   y <- tis:::window.tis(x, start=start, end=end, noWarm=!warn)
   seriesNames(y) <- seriesNames(x)
   y
  }

tbind.tis <- function(x, ..., pad.start=TRUE, pad.end=TRUE, warn=TRUE)
 {nm <- seriesNames(x)
  for (z in list(...)) {
    if (!is.null(z)) {
      nm <- c(nm, seriesNames(z))
      x <- union(x, z)
      }
    }
  if (!pad.start | !pad.end)
     x <- trimNA(x, startNAs= !pad.start, endNAs= !pad.end)
  seriesNames(x) <- nm
  x
 }  

