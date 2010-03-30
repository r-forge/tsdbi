#.onLoad <- function(library, section) {
#   require("methods")
#   require("TSdbi")
#   require("RPostgreSQL")
#   }

setClass("TSPostgreSQLConnection", 
   contains=c("PostgreSQLConnection", "conType", "TSdb")) 

#setMethod("print", "TSPostgreSQLConnection", function(x, ...) {
#   print(x@TSdb)
#   })

setMethod("TSconnect",   signature(drv="PostgreSQLDriver", dbname="character"),
   definition=function(drv, dbname, host=
    if(!is.null(Sys.getenv("PGHOST"))) Sys.getenv("PGHOST") else "localhost", ...) {
        con <- dbConnect(drv, dbname=dbname, host=host, ...)
	if(0 == length(dbListTables(con))){
	  dbDisconnect(con)
          stop("Database ",dbname," has no tables.")
	  }
	if(!dbExistsTable(con, "Meta")){
	  dbDisconnect(con)
          stop("Database ",dbname," does not appear to be a TS database.")
	  }
  	new("TSPostgreSQLConnection" , con, drv="PostgreSQL", dbname=dbname, 
 	       hasVintages=dbExistsTable(con, "vintages"), 
 	       hasPanels  =dbExistsTable(con, "panels")) 
	})

setMethod("TSput",   signature(x="ANY", serIDs="character", con="PostgreSQLConnection"),
   definition= function(x, serIDs, con=getOption("TSconnection"), Table=NULL, 
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=TSlabel(x),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
  TSdbi:::TSputSQL(x, serIDs, con, Table=Table, 
   TSdescription.=TSdescription., TSdoc.=TSdoc., TSlabel.=TSlabel., 
   vintage=vintage, panel=panel,...) )

setMethod("TSget",   signature(serIDs="character", con="PostgreSQLConnection"),
   definition= function(serIDs, con=getOption("TSconnection"), 
       TSrepresentation=getOption("TSrepresentation"),
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=NULL, TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE,
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
   TSdbi:::TSgetSQL(serIDs, con, TSrepresentation=TSrepresentation,
       tf=tf, start=start, end=end,
       names=names, TSdescription=TSdescription, TSdoc=TSdoc, TSlabel=TSlabel,
       vintage=vintage, panel=panel, ...) )

setMethod("TSdates",    signature(serIDs="character", con="PostgreSQLConnection"),
   definition= function(serIDs, con=getOption("TSconnection"),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
      TSdbi:::TSdatesSQL(serIDs, con, vintage=vintage, panel=panel, ...) )


setMethod("TSdescription",   signature(x="character", con="PostgreSQLConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSdescriptionSQL(x=x, con=con, ...) )

setMethod("TSdoc",   signature(x="character", con="PostgreSQLConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSdocSQL(x=x, con=con, ...) )

setMethod("TSlabel",   signature(x="character", con="PostgreSQLConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSlabelSQL(x=x, con=con, ...) )

setMethod("TSdelete", signature(serIDs="character", con="PostgreSQLConnection"),
   definition= function(serIDs, con=getOption("TSconnection"),  
   vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
       TSdbi:::TSdeleteSQL(serIDs=serIDs, con=con, vintage=vintage, panel=panel, ...) )
