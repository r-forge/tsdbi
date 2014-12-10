
# Nov 2013 needed devel version for bug fixes, but good with >=2.4.0
#  install.packages("devtools")
#  require("devtools")
#  install_github("R-package", "quandl")
#  install_github("R-package", "quandl", ref="develop")

require("TSQuandl")
require("tfplot")
 
cat("**************        connecting to Quandl\n")

# token from ~/.Quandl or env variable QUANDL_TOKEN if available.
# Otherwise, Quandl default limit applies.
con <- TSconnect("Quandl", dbname="BOC") 
 

# ts
cpi <- TSget("CDA_CPI", con)

if (12 != frequency(cpi))    stop("cpi  ts frequency is not correct.")

tfplot(cpi, graphs.per.page=4)


# zoo
cpiz <- TSget("CDA_CPI", con, TSrepresentation="zoo")

# see coredata check below

if (12 != frequency(cpiz)) stop("cpi zoo frequency is not correct.")

if("CDA_CPI BOC via Quandl" != TSsource(cpiz)) 
   stop("cpi zoo TSsource data problem.")

tfplot(cpiz, graphs.per.page=4)


# xts
require("xts") #needed to extract frequency

cpix <- TSget("CDA_CPI", con, TSrepresentation="xts", TSdescription=TRUE)

if (max(abs(cpi - coredata(cpiz))) > 1e-6 )
    stop("cpi ts and zoo coredata do not compare.")

if (12 != frequency(cpix)) stop("cpi xts frequency is not correct.")

if(is.na(TSdescription(cpix))) stop("cpi xts description problem.")

if("CDA_CPI BOC via Quandl" != TSsource(cpix)) 
   stop("cpi xts TSsource data problem.")

tfplot(cpix, graphs.per.page=4)

TSdescription(cpix)

require("zoo") # for coredata but not for above
if (max(abs(cpi - coredata(cpiz))) > 1e-6 )
    stop("cpi ts and zoo coredata do not compare.")

# meta data via con
TSdescription("CDA_CPI", con)
