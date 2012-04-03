require("TShistQuote")  
require("tfplot")  

yahoo <- TSconnect("histQuote", dbname="yahoo") 
oanda <- TSconnect("histQuote", dbname="oanda") 

x <- TSget(serIDs="^gspc", con=yahoo)
png(file="gspcsmall.png",width=480, height=240, pointsize=12, bg = "white")
# mv gspcsmall.png gspcsmall.png.orig ; pngcrush gspcsmall.png.orig gspcsmall.png
#png(file="gspc.png",    width=960, height=480, pointsize=12, bg = "white")
  tfOnePlot(x, start=as.Date("2011-01-01"), 
    Title = "Running commentary, blah, blah, blah", 
    subtitle="gspc",
    ylab= "index",
    xlab= "2011",
    source="Source: Yahoo (^gspc)",
    footnoteRight = paste("Extracted:", date()),
    lastObs = TRUE )
dev.off()

z <- TSget(serIDs="^ftse", con=yahoo)
png(file="ftsesmall.png",width=480, height=240, pointsize=12, bg = "white")
# mv ftsesmall.png ftsesmall.png.orig ; pngcrush ftsesmall.png.orig ftsesmall.png
#png(file="ftse.png",    width=960, height=480, pointsize=12, bg = "white")
  tfOnePlot(z, start=as.Date("2011-09-01"),
    Title = "Running commentary, blah, blah, blah", 
    subtitle="FTSE",
    ylab= "index",
    xlab= "2011",
    source="Source: Yahoo (^ftse)",
    footnoteRight = paste("Extracted:", date()),
    lastObs = TRUE )
dev.off()
 
ibmC <- TSget("ibm", yahoo, quote = "Close")

png(file="ibmsmall.png",width=480, height=240, pointsize=12, bg = "white")
# mv ibmsmall.png ibmsmall.png.orig ; pngcrush ibmsmall.png.orig ibmsmall.png
#png(file="ibm.png",    width=960, height=480, pointsize=12, bg = "white")
  tfOnePlot(ibmC, start=as.Date("2011-01-01"),
    Title = "Running commentary, blah, blah, blah", 
    subtitle="IBM Close",
    ylab= "dollars",
    xlab= "2011",
    source="Source: Yahoo (ibm)",
    footnoteRight = paste("Extracted:", date()),
    lastObs = TRUE )
dev.off()

ibmV <- TSget("ibm", con=yahoo, quote = "Vol")/1e6

png(file="ibmVsmall.png",width=480, height=240, pointsize=12, bg = "white")
# mv ibmVsmall.png ibmVsmall.png.orig ; pngcrush ibmVsmall.png.orig ibmVsmall.png
#png(file="ibmV.png",    width=960, height=480, pointsize=12, bg = "white")
  tfOnePlot(ibmV, 
    Title = "Running commentary, blah, blah, blah", 
    subtitle="IBM Volume",
    ylab= "million dollars",
    source="Source: Yahoo (ibm)",
    footnoteRight = paste("Extracted:", date()),
    lastObs = TRUE )
dev.off()

EuroUSD <- TSget("EUR/USD", con=oanda, start=Sys.Date() - 480)

png(file="EuroUSDsmall.png",width=480, height=240, pointsize=12, bg = "white")
# mv EuroUSDsmall.png EuroUSDsmall.png.orig ; pngcrush EuroUSDsmall.png.orig EuroUSDsmall.png
#png(file="EuroUSD.png",    width=960, height=480, pointsize=12, bg = "white")
  tfOnePlot(EuroUSD, start=as.Date("2011-01-01"),
    Title = "Running commentary, blah, blah, blah", 
    subtitle="EUR / USD",
    ylab= "Euro / USD",
    source="Source: Oanda (EUR/USD)",
    footnoteRight = paste("Extracted:", date()),
    lastObs = TRUE )
dev.off()


EuroUSD <- TSget("EUR/USD", con=oanda, start=Sys.Date() - 480)

png(file="EuroUSDsmall.png",width=480, height=240, pointsize=12, bg = "white")
# mv EuroUSDsmall.png EuroUSDsmall.png.orig ; pngcrush EuroUSDsmall.png.orig EuroUSDsmall.png
#png(file="EuroUSD.png",    width=960, height=480, pointsize=12, bg = "white")
  tfOnePlot(EuroUSD, start=as.Date("2011-01-01"),
    Title = "Running commentary, blah, blah, blah", 
    subtitle="EUR / USD",
    ylab= "Euro / USD",
    source="Source: Oanda (EUR/USD)",
    footnoteRight = paste("Extracted:", date()),
    lastObs = TRUE )
dev.off()

tyx <- TSget("^TYX", con=yahoo, quote="Close")

png(file="tyxsmall.png",width=480, height=240, pointsize=12, bg = "white")
# mv tyxsmall.png tyxsmall.png.orig ; pngcrush tyxsmall.png.orig tyxsmall.png
#png(file="tyx.png",    width=960, height=480, pointsize=12, bg = "white")
  tfOnePlot(tyx, start=as.Date("2011-01-01"), 
    Title = "Running commentary, blah, blah, blah", 
    subtitle="30-Year Treasury Bond",
    ylab= "index",
    xlab= "2011",
    source="Source: Yahoo (tyx)",
    footnoteRight = paste("Extracted:", date()),
    lastObs = TRUE )
dev.off()


