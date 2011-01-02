# Status:  Working, but finding series identifiers is difficult and the
#    mneumonics are obscure. Needs documentation.


#Go through all the steps and at the end there is a link for automated download

#Consumer credit from all sources (I think)
#https://www.federalreserve.gov/datadownload/Output.aspx?rel=G19&series=79d3b610380314397facd01b59b37659&lastObs=&from=01/01/1943&to=12/31/2010&filetype=sdmx&label=include&layout=seriescolumn

cat("*********** Federal Reserve Board sdmx  ************************\n")
require("TSsdmx")

con <- TSconnect("sdmx", dbname="FRB") 

z <- TSget("G19.79d3b610380314397facd01b59b37659", con=con)

tfplot(z, Title="From Federal Reserve Board")
TSdescription(z) 

z <- TSget("H3.a0e6e4ca4fd8cd3d7227e549939ec0ff", con=con)

tfplot(z, Title="From Federal Reserve Board")
TSdescription(z) 

z <- TSget(c("G19.79d3b610380314397facd01b59b37659",
             "H3.a0e6e4ca4fd8cd3d7227e549939ec0ff"), con=con)

tfplot(z, Title="From Federal Reserve Board")
TSdescription(z) 

