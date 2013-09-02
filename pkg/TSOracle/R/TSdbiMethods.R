
# This can be 
#setClass("TSOraConnection", contains="OraConnection",
#             representation=representation(TSdb="TSdb")) 
# in which case we need 
#new("TSOraConnection" , con, TSdb=new("TSdb", dbname=dbname, 
#  	       hasVintages=dbExistsTable(con, "vintages"), 
#  	       hasPanels  =dbExistsTable(con, "panels"))) 

# or 
setClass("TSOraConnection", contains=c("OraConnection", "conType", "TSdb"))

setAs("TSOraConnection", "integer", 
  def=getMethod("coerce", c("dbObjectId","integer"))) 

# in which case we need 
#new("TSOraConnection" , con, drv="Oracle", dbname=dbname, 
#  	       hasVintages=dbExistsTable(con, "vintages"), 
#  	       hasPanels  =dbExistsTable(con, "panels")) 

#setMethod("print", "TSOraConnection", function(x, ...) {
#    print(x@TSdb)
#    })

setMethod("TSconnect",   signature(drv="OraDriver", dbname="character"),
   definition=function(drv, dbname, ...) {
        con <- dbConnect(drv, dbname=dbname, ...)
	if(0 == length(dbListTables(con))){
	  dbDisconnect(con)
          stop("Database ",dbname," has no tables.")
	  }
	if(!dbExistsTable(con, "Meta")){
	  dbDisconnect(con)
          stop("Database ",dbname," does not appear to be a TS database.")
	  }
	new("TSOraConnection" , con, drv="Oracle", dbname=dbname, 
  	       hasVintages=dbExistsTable(con, "vintageAlias"), 
  	       hasPanels  =dbExistsTable(con, "panels")) 
	})

setMethod("TSput",   signature(x="ANY", serIDs="character", con="TSOraConnection"),
   definition= function(x, serIDs, con=getOption("TSconnection"), Table=NULL, 
       TSdescription.=TSdescription(x), TSdoc.=TSdoc(x), TSlabel.=TSlabel(x),
        TSsource.=TSsource(x),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    TSputSQL(x, serIDs, con, Table=Table, 
       TSdescription.=TSdescription., TSdoc.=TSdoc., TSlabel.=TSlabel.,
        TSsource.=TSsource.,
       vintage=vintage, panel=panel) )

setMethod("TSget",   signature(serIDs="character", con="TSOraConnection"),
   definition= function(serIDs, con=getOption("TSconnection"), 
       TSrepresentation=options()$TSrepresentation,
       tf=NULL, start=tfstart(tf), end=tfend(tf), names=NULL, 
       TSdescription=FALSE, TSdoc=FALSE, TSlabel=FALSE, TSsource=TRUE,
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
    TSgetSQL(serIDs, con, TSrepresentation=TSrepresentation,
       tf=tf, start=start, end=end, names=names, 
       TSdescription=TSdescription, TSdoc=TSdoc, TSlabel=TSlabel,
         TSsource=TSsource,
       vintage=vintage, panel=panel) )

setMethod("TSdates",    signature(serIDs="character", con="TSOraConnection"),
   definition= function(serIDs, con=getOption("TSconnection"),  
       vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
     TSdatesSQL(serIDs, con, vintage=vintage, panel=panel) )


setMethod("TSdescription",   signature(x="character", con="TSOraConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdescriptionSQL(x=x, con=con) )

setMethod("TSdoc",   signature(x="character", con="TSOraConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSdocSQL(x=x, con=con) )

setMethod("TSlabel",   signature(x="character", con="TSOraConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSlabelSQL(x=x, con=con) )

setMethod("TSsource",   signature(x="character", con="TSOraConnection"),
   definition= function(x, con=getOption("TSconnection"), ...)
        TSsourceSQL(x=x, con=con) )

setMethod("TSdelete", 
   signature(serIDs="character", con="TSOraConnection", vintage="ANY", panel="ANY"),
   definition= function(serIDs, con=getOption("TSconnection"),  
   vintage=getOption("TSvintage"), panel=getOption("TSpanel"), ...)
  TSdeleteSQL(serIDs=serIDs, con=con, vintage=vintage, panel=panel) )

setMethod("TSvintages", 
   signature(con="TSOraConnection"),
   definition=function(con) {
     if(!con@hasVintages) NULL else   
     sort(dbGetQuery(con,"SELECT  DISTINCT(vintage) FROM  vintages;" )$vintage)
     } )

setMethod("dropTStable", 
   signature(con="OraConnection", Table="character", yesIknowWhatIamDoing="ANY"),
   definition= function(con=NULL, Table, yesIknowWhatIamDoing=FALSE){
    if((!is.logical(yesIknowWhatIamDoing)) || !yesIknowWhatIamDoing)
      stop("See ?dropTStable! You need to know that you may be doing serious damage.")
    if(dbExistsTable(con, Table)) dbRemoveTable(con, Table)
    return(TRUE)
    } )
