
# Nov 2013 need devel version for bug fixes
#  install.packages("devtools")
#  require("devtools")
#  install_github("R-package", "quandl", ref="develop")

require("TSQuandl")
require("tfplot")
 
cat("**************        connecting to Quandl\n")

con <- TSconnect("Quandl", dbname="BOC") 
# token from ~/.Quandl or env variable QUANDL_TOKEN
 
x <- TSget("CDA_CPI", con)

tfplot(x)

z <- TSget("CDA_CPI", con, TSrepresentation="zoo", TSdescription=TRUE)

TSdescription(z)

TSdescription("CDA_CPI", con)
