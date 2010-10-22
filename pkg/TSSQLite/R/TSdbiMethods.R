#.onLoad <- function(library, section) {
#   require("methods")
#   require("TSdbi")
#   require("RSQLite")
#   }

setClass("TSSQLiteConnection", contains=c("SQLiteConnection","conType", "TSdb")) 

setMethod("print", "TSSQLiteConnection", function(x, ...) {
    print(x@TSdb)
    })

setMethod("TSconnect",   signature(drv="SQLiteDriver", dbname="character"),
   definition=function(drv, dbname, ...) {
        con <- dbConnect(drv, dbname=dbname, ...)
	if(!dbExistsTable(con, "Meta"))
	  stop("The database does not appear to be a TS database,")
	new("TSSQLiteConnection" , con, drv="SQLite", dbname=dbname, 
	       hasVintages=dbExistsTable(con, "vintageAlias"), 
	       hasPanels  =dbExistsTable(con, "panels"))
	})

setMethod("TSput", signature(x="ANY", serIDs="character", con="SQLiteConnection"),
   definition= function(x, serIDs=seriesNames(x), con=getOption("TSconnection"), Table=NULL, 
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x),   TSlabel.=TSlabel(x),
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...) 
 TSdbi:::TSputSQL(x, serIDs, con, Table=Table, 
  TSdescription.=TSdescription., TSdoc.=TSdoc., TSlabel.=TSlabel., 
  vintage=vintage, panel=panel) )

setMethod("TSget", signature(serIDs="character", con="SQLiteConnection"),
   definition= function(serIDs, con=getOption("TSconnection"), 
       TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf),
       names=NULL, TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE,
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    TSdbi:::TSgetSQL(serIDs, con, TSrepresentation=TSrepresentation,
       tf=tf, start=start, end=end,
       names=names, TSdescription=TSdescription, TSdoc=TSdoc, TSlabel=TSlabel,
       vintage=vintage, panel=panel) )

setMethod("TSdates", signature(serIDs="character", con="SQLiteConnection"),
   definition= function(serIDs, con=getOption("TSconnection"),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
     TSdbi:::TSdatesSQL(serIDs, con, vintage=vintage, panel=panel) )


setMethod("TSdescription",   signature(x="character", con="SQLiteConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSdescriptionSQL(x=x, con=con) )

setMethod("TSdoc",   signature(x="character", con="SQLiteConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSdocSQL(x=x, con=con) )

setMethod("TSlabel",   signature(x="character", con="SQLiteConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSlabelSQL(x=x, con=con) )

setMethod("TSdelete", signature(serIDs="character", con="SQLiteConnection"),
     definition= function(serIDs, con=getOption("TSconnection"),  
     vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
  TSdbi:::TSdeleteSQL(serIDs=serIDs, con=con, vintage=vintage, panel=panel) )


setMethod("dropTStable", 
   signature(con="SQLiteConnection", Table="character", yesIknowWhatIamDoing="ANY"),
   definition= function(con=NULL, Table, yesIknowWhatIamDoing=FALSE){
    if((!is.logical(yesIknowWhatIamDoing)) || !yesIknowWhatIamDoing)
      stop("See ?dropTStable! You need to know that you may be doing serious damage.")
    if(dbExistsTable(con, Table)) dbRemoveTable(con, Table)
    return(TRUE)
    } )
