# test that the Quandl package is working

cat("**************        connecting Quandl\n")

  require("Quandl")

cat("**************        extracting from Quandl\n")

  x  <- Quandl("NSE/OIL", type="zoo")
