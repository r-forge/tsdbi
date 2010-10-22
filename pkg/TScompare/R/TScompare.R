testequaltf <- function(s1, s2) {
    r <- try(all( c(earliestEnd(s1) == earliestEnd(s2), 
	   latestStart(s1) == latestStart(s2))), silent=TRUE)
    if (inherits(r, "try-error")) r <- FALSE # so includes failed as well as unequal
    # failure may be because of different tf representations, 
    #     eg. zoo from sql vs ts from padi for weekly.
    r
    }

TScompare <- function(ids, con1, con2, na.rm=FALSE, fuzz=1e-14) {
	if(2 != NCOL(ids)) stop("ids must have 2 columns.")
	rw <- rv <- rep(NA, NROW(ids))
	na1 <- na2 <- NULL
	for (i in 1:NROW(ids)){
	   s1 <- try(TSget(ids[i,1], con1), silent=TRUE)
	   s2 <- try(TSget(ids[i,2], con2), silent=TRUE)
	   if (inherits(s1, "try-error")) {
	      na1 <- c(na1, ids[i,1])
	      rw[i] <- rv[i] <- NA
	      }
	   else if (inherits(s2, "try-error")) {
	      na2 <- c(na2, ids[i,2])
	      rw[i] <- rv[i] <- NA
	      }
	   else {
	      if(na.rm) {
		   s1 <- trimNA(s1)
		   s2 <- trimNA(s2)
		   }
	      rw[i] <- testequaltf(s1, s2)
	   
	      ii <- ! is.na(s1)
	      if(rw[i]) rv[i] <- all( c(ii == !is.na(s2)) && 
		                 max(abs(c(s1)[ii] - c(s2)[ii])) < fuzz)
	      }
	   }
	r <- list(window=rw, value=rv, ids=ids, na1=na1, na2=na2,con1=con1, con2=con2)
	class(r) <- "TScompare"
	r
	}

summary.TScompare  <- function(object, ...){
	x <- list(n=length(object$window),
		  na1=length(object$na1),
		  na2=length(object$na2),
		  na =sum(is.na(object$window)),
		  window=sum(object$window, na.rm=TRUE),
		  value=sum(object$value, na.rm=TRUE))
	class(x) <- "summary.TScompare"
	x
	}

print.summary.TScompare  <- function(x, digits=getOption("digits"), ...){
	cat(x$n - x$na1, " of ", x$n, "are available on con1.\n")
	cat(x$n - x$na2, " of ", x$n, "are available on con2.\n")
	cat(x$window, " of ", x$n - x$na, "remaining have the same window.\n")
	cat(x$value,  " of ", x$n - x$na, "remaining have the same window and values.\n")
	invisible(x)
	}

tfplot.TScompare  <- function(x, con1, con2, diff=FALSE){
	v <- x$value
	v[is.na(v)] <- FALSE
	ids <- x$ids[!(v & x$window),]
	for (i in 1:NROW(ids)){
	   if(diff) tfplot(TSget(ids[i,1], con1) - TSget(ids[i,2], con2),
	                   Title=ids[i,1])
	   else     tfplot(TSget(ids[i,1], con1),  TSget(ids[i,2], con2),
	                   Title=ids[i,1])
	   }
	invisible(x)
	}

AllIds <- function(con)dbGetQuery(con, "select distinct id from Meta;")$id

AllPanels <- function(con){
	if(con@hasPanels)
	     dbGetQuery(con, "select distinct panel from Meta;")$panel
	else NULL }


AllVintages <- function(con){
	if(con@hasVintages)
	     dbGetQuery(con, "select distinct vintage from Meta;")$vintage
	else NULL }
