######################## National Bank Belguim #######################

  require("TSsdmx")
  
  nbb <- TSconnect("sdmx", dbname="NBB")

  z <- TSget('HICP.000000.BE.A', nbb) 
  z <- gTSget('HICP.000000.BE.M', nbb) 

