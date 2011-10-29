
#RODBC is non-neg numeric value (or -1 for failure) with S3 class and attributes

ODBC <- function () {new("ODBCDriver", Id = as(1,"integer"))} #Id is ignored

setClass("dbObjectId", representation(Id = "integer", "VIRTUAL"))
setClass("ODBCObject", representation("DBIObject", "dbObjectId", "VIRTUAL"))
setClass("ODBCDriver", representation("DBIDriver", "ODBCObject"))
setClass("ODBCConnection", representation("DBIConnection", "ODBCObject"))

#this works but the connection gives warnings when it eventually gets closed
#setOldClass("RODBC",  prototype=odbcConnect("test"))

#handle_ptr= <externalptr> 
setOldClass("RODBC",  prototype=structure(integer(1),
  class='RODBC',           connection.string=character(1), 
  handle_ptr=integer(1),   case=character(1),     id=integer(1), 
  believeNRows=logical(1), bulk_add=character(1), colQuote=character(1), 
  tabQuote=character(1),   encoding=character(1), rows_at_time=1000))

##setClass("TSodbcConnection", contains=c("DBIConnection","TSdb"),
##    representation(Id="RODBC"))

setClass("TSodbcConnection", contains=c("DBIConnection","conType","TSdb","RODBC"))

####### some kludges to make this look like DBI. ######
setMethod("dbListTables", signature(conn="RODBC"), definition=function(conn,...)
     as(sqlTables(channel=conn)$TABLE_NAME, "character"))

##setMethod("dbListTables", signature(conn="TSodbcConnection"), definition=
##      function(conn, ...) as(sqlTables(channel=conn@Id)$TABLE_NAME, "character"))

setMethod("dbExistsTable", signature(conn="RODBC", name="character"),
   definition=function(conn, name, ...) name %in% dbListTables(conn))

setMethod("dbRemoveTable", signature(conn="RODBC", name="character"),
   definition=function(conn, name, ...) {
     if (-1 == sqlDrop(conn, name, errors = FALSE) ) FALSE else TRUE})

setMethod("dbGetQuery", signature(conn="RODBC", statement="character"),
   definition=function (conn, statement, ...){
      r <- sqlQuery(channel=conn, statement, ...)
      if( NROW(r) == 0) NULL else r
      }) 

##setMethod("dbGetQuery", signature(conn="TSodbcConnection", statement="character"),
##   definition=function (conn, statement, ...){
##      q <- sqlQuery(channel=conn@Id, statement, ...)
##      if(0==NROW(q)) NULL else q}) 

setMethod("dbDisconnect", signature(conn="RODBC"), definition=function(conn,...)
     odbcClose(channel=conn))

##setMethod("dbDisconnect", signature(conn="TSodbcConnection"),
##   definition=function(conn, ...) odbcClose(channel=conn@Id))

# this does nothing, but prevents error messages
setMethod("dbUnloadDriver", signature(drv="ODBCDriver"),
   definition=function(drv, ...) invisible(TRUE))

#  this is pretty bad
setMethod("dbGetException", signature(conn="TSodbcConnection"),
   definition=function(conn, ...) list(errorNum=0))

#######     end kludges   ######

##setMethod("TSconnect",   signature(drv="ODBCDriver", dbname="character"),
##   definition=function(drv, dbname, ...) {
##        con <- odbcConnect(dsn=dbname) #, uid = "", pwd = "", ...)
##	if(con == -1) stop("error establishing ODBC connection.") 
##	if(0 == length(dbListTables(con))){
##	  dbDisconnect(con)
##          stop("Database ",dbname," has no tables.")
##	  }
##	if(!dbExistsTable(con, "meta")){
##	  odbcClose(con)
##          stop("Database ",dbname," does not appear to be a TS database.")
##	  }
##	new("TSodbcConnection" , Id=con, dbname=dbname, 
##  	       hasVintages=dbExistsTable(con, "vintages"), 
##  	       hasPanels  =dbExistsTable(con, "panels")) 
##	})
setMethod("TSconnect",   signature(drv="ODBCDriver", dbname="character"),
   definition=function(drv, dbname, ...) {
        con <- odbcConnect(dsn=dbname) #, uid = "", pwd = "", ...)
	if(con == -1) stop("error establishing ODBC connection.") 
	if(0 == length(dbListTables(con))){
	  dbDisconnect(con)
          stop("Database ",dbname," has no tables.")
	  }
	if(!dbExistsTable(con, "meta")){
	  odbcClose(con)
          stop("Database ",dbname," does not appear to be a TS database.")
	  }
	new("TSodbcConnection" , con, drv="ODBC", dbname=dbname, 
  	       hasVintages=dbExistsTable(con, "vintageAlias"), 
  	       hasPanels  =dbExistsTable(con, "panels")) 
	})

setMethod("TSput",   signature(x="ANY", serIDs="character", con="TSodbcConnection"),
   definition= function(x, serIDs, con=getOption("TSconnection"), Table=NULL, 
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=TSlabel(x),
         TSsource.=TSsource(x),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
 TSdbi:::TSputSQL(x, serIDs, con, Table=Table, 
   TSdescription.=TSdescription., TSdoc.=TSdoc., TSlabel.=TSlabel.,
     TSsource.=TSsource., 
   vintage=vintage, panel=panel) )

setMethod("TSget",   signature(serIDs="character", con="TSodbcConnection"),
   definition= function(serIDs, con=getOption("TSconnection"), 
       TSrepresentation=getOption("TSrepresentation"),
       tf=NULL, start=tfstart(tf), end=tfend(tf), names=NULL, 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
   TSdbi:::TSgetSQL(serIDs, con, TSrepresentation=TSrepresentation,
       tf=tf, start=start, end=end,
       names=names, TSdescription=TSdescription, TSdoc=TSdoc, TSlabel=TSlabel,
         TSsource=TSsource,
       vintage=vintage, panel=panel) )

setMethod("TSdates",    signature(serIDs="character", con="TSodbcConnection"),
   definition= function(serIDs, con=getOption("TSconnection"),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
      TSdbi:::TSdatesSQL(serIDs, con, vintage=vintage, panel=panel) )


setMethod("TSdescription",   signature(x="character", con="TSodbcConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        as.character(TSdbi:::TSdescriptionSQL(x=x, con=con)) )

setMethod("TSdoc",   signature(x="character", con="TSodbcConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        as.character(TSdbi:::TSdocSQL(x=x, con=con)) )

setMethod("TSlabel",   signature(x="character", con="TSodbcConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        as.character(TSdbi:::TSlabelSQL(x=x, con=con)) )

setMethod("TSsource",   signature(x="character", con="TSodbcConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSsourceSQL(x=x, con=con))

setMethod("TSdelete", signature(serIDs="character", con="TSodbcConnection"),
     definition= function(serIDs, con=getOption("TSconnection"),  
     vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
   TSdbi:::TSdeleteSQL(serIDs=serIDs, con=con, vintage=vintage, panel=panel) )

setMethod("TSvintages", 
   signature(con="TSodbcConnection"),
   definition=function(con) {
     if(!con@hasVintages) NULL else   
     dbGetQuery(con,"SELECT  DISTINCT(vintage) FROM  vintages;" )$vintage
     } )

setMethod("dropTStable", 
   signature(con="RODBC", Table="character", yesIknowWhatIamDoing="ANY"),
   definition= function(con=NULL, Table, yesIknowWhatIamDoing=FALSE){
    if((!is.logical(yesIknowWhatIamDoing)) || !yesIknowWhatIamDoing)
      stop("See ?dropTStable! You need to know that you may be doing serious damage.")
    if(dbExistsTable(con, Table)) dbRemoveTable(con, Table) else TRUE
    } )
