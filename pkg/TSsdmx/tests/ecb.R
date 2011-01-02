# Status:  Working, but finding series identifiers is difficult and the
#    mneumonics are obscure. Needs documentation.

cat("************** ECB sdmx   ******************************\n")
require("TSsdmx")

con <- TSconnect("sdmx", dbname="ECB")

# Annual data
z <- TSget("118.DD.A.I5.POPE.LEV.4D", con=con ) 
# #works v3, seems to get only the header with v1
tfplot(z)

#quarterly
# http://sdw.ecb.europa.eu/
#    >Money,banking, and fin. >MFIs loans, dep..> households 
#      |quarterly  | all | select series (click check box) BSI... as below    
#      | Data table | export (csv SDMX excel)


# monthly data 

options(TSconnection=con)

z <- TSget("122.ICP.M.U2.N.000000.4.ANR")# annual rates #works v3 
z <- TSget("122.ICP.M.U2.N.000000.4.INX")# index        #works v3 
tfplot(z)

z <- TSget("117.BSI.M.U2.Y.U.A21.A.4.U2.2250.Z01.E")   #works v3
tfplot(z)


# quarterly data 

skey <-c("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E",
         "117.BSI.Q.U2.N.A.A23.A.1.U2.2250.Z01.E")


z <- TSget(skey)                                       #works v3
tfplot(z)

z <- TSget("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E")   #works v3

z <- TSget(c("117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E",
                "117.BSI.Q.U2.N.A.A22.A.1.U2.2250.Z01.E"))#works v3
tfplot(z)


