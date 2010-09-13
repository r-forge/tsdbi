
testEqual <- function(ids, con1, con2, na.rm=FALSE, fuzz=1e-14) {
	if(2 != NCOL(ids)) stop("ids must have 2 columns.")
	rw <- rv <- rep(NA, NROW(ids))
	for (i in 1:NROW(ids)){
	   s1 <- TSget(ids[i,1], con1)
	   s2 <- TSget(ids[i,2], con2)
	   if(na.rm) {
		s1 <- trimNA(s1)
		s2 <- trimNA(s2)
		}
	   ii <- ! is.na(s1)
	   rw[i] <- all( c(earliestEnd(s1) == earliestEnd(s2), 
	                  latestStart(s1) == latestStart(s2)))
	   
	   if(rw[i]) rv[i] <- all( c(ii == !is.na(s2)) && 
		              max(abs(c(s1)[ii] - c(s2)[ii])) < fuzz)
	   }
	r <- list(window=rw, value=rv, ids=ids, con1=con1, con2=con2)
	class(r) <- "TScomparison"
	r
	}

summary.TScomparison  <- function(x){
	n <- length(x$window)
	cat(sum(x$window), " of ", n, "have the same window\n")
	cat(sum(x$value),  " of ", n, "have the same values\n")
	invisible(x)
	}

tfplot.TScomparison  <- function(x, diff=FALSE){
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
	     dbGetQuery(con, "select distinct vintages from Meta;")$panel
	else NULL }
