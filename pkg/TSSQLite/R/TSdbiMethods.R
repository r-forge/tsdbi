
setClass("TSSQLiteConnection", contains=c("SQLiteConnection","conType", "TSdb")) 

#setAs("TSSQLiteConnection", "integer", 
#  def=getMethod("coerce", c("dbObjectId","integer"))) 

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

setMethod("TSput", signature(x="ANY", serIDs="character", con="TSSQLiteConnection"),
   definition= function(x, serIDs=seriesNames(x), con=getOption("TSconnection"), Table=NULL, 
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x),   TSlabel.=TSlabel(x),
         TSsource.=TSsource(x),
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...) 
 TSdbi:::TSputSQL(x, serIDs, con, Table=Table, 
  TSdescription.=TSdescription., TSdoc.=TSdoc., TSlabel.=TSlabel.,
   TSsource.=TSsource.,
  vintage=vintage, panel=panel) )

setMethod("TSget", signature(serIDs="character", con="TSSQLiteConnection"),
   definition= function(serIDs, con=getOption("TSconnection"), 
       TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf), names=NULL, 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    TSdbi:::TSgetSQL(serIDs, con, TSrepresentation=TSrepresentation,
       tf=tf, start=start, end=end, names=names, 
       TSdescription=TSdescription, TSdoc=TSdoc, TSlabel=TSlabel,
         TSsource=TSsource,
       vintage=vintage, panel=panel) )

setMethod("TSdates", signature(serIDs="character", con="TSSQLiteConnection"),
   definition= function(serIDs, con=getOption("TSconnection"),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
     TSdbi:::TSdatesSQL(serIDs, con, vintage=vintage, panel=panel) )


setMethod("TSdescription",   signature(x="character", con="TSSQLiteConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSdescriptionSQL(x=x, con=con) )

setMethod("TSdoc",   signature(x="character", con="TSSQLiteConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSdocSQL(x=x, con=con) )

setMethod("TSlabel",   signature(x="character", con="TSSQLiteConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSlabelSQL(x=x, con=con) )

setMethod("TSsource",   signature(x="character", con="TSSQLiteConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdbi:::TSsourceSQL(x=x, con=con) )

setMethod("TSdelete", signature(serIDs="character", con="TSSQLiteConnection"),
     definition= function(serIDs, con=getOption("TSconnection"),  
     vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
  TSdbi:::TSdeleteSQL(serIDs=serIDs, con=con, vintage=vintage, panel=panel) )


setMethod("TSvintages", 
   signature(con="TSSQLiteConnection"),
   definition=function(con) {
     if(!con@hasVintages) NULL else   
     sort(dbGetQuery(con,"SELECT  DISTINCT(vintage) FROM  vintages;" )$vintage)
     } )

setMethod("dropTStable", 
   signature(con="SQLiteConnection", Table="character", yesIknowWhatIamDoing="ANY"),
   definition= function(con=NULL, Table, yesIknowWhatIamDoing=FALSE){
    if((!is.logical(yesIknowWhatIamDoing)) || !yesIknowWhatIamDoing)
      stop("See ?dropTStable! You need to know that you may be doing serious damage.")
    if(dbExistsTable(con, Table)) dbRemoveTable(con, Table)
    return(TRUE)
    } )
