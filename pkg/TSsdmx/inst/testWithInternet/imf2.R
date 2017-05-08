#http://www.imf.org

require("TSsdmx")

# RJSDMX::sdmxHelp()  # can be useful for finding series identifiers, etc

imf2 <- TSconnect("sdmx",  dbname="IMF2")

hasDataCodes( providor='IMF2',  flow='DS-BOP', template='A.MX.*', wild='INDICATOR')

# available, containing data, with description containing 'Current Account, Total'
hasDataCodes( providor='IMF2',  flow='DS-BOP', template='A.MX.*', wild='INDICATOR',
     gp= c('Current Account', 'Total'))


if(! verifyQuery('IMF2', 'DS-BOP.A.MX.*', verbose=FALSE))
     stop("Query 1 does not verify. Provider changed something.")

# verify check for mis-specified query is working
if(FALSE != verifyQuery('IMF2', 'DS-BOP.A.MX.*.*')) 
     stop("verifyQuery bad dimension check failed")
 
  
z <- TSget('DS-BOP.A.MX.BCA_BP6_USD', imf2)

if(! all(start(z) ==  c(1979,1)))  stop("test 1 start date changed.")
if(frequency(z)   !=  1)           stop("test 1  frequency changed.")

  
z <- TSget('DS-BOP.Q.MX.BCA_BP6_USD', imf2)

if(! all(start(z) ==  c(1979,1)))  stop("test 2 start date changed.")
if(frequency(z)   !=  4)            stop("test 2  frequency changed.")

#  COULD DO MORE TESTS, EG  DIFFERENT FREQ
