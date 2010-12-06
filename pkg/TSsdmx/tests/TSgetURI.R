
this gets the data but the zs parse fails
#z <- TSgetURI(query="http://sdw.ecb.europa.eu/quickviewexport.do?trans=&start=&end=&snapshot=&periodSortOrder=&SERIES_KEY=122.ICP.M.U2.N.000000.4.ANR&type=sdmx")

vs

this seems to get only the header
#z <- TSgetURI(query="http://sdw.ecb.europa.eu/export.do?SERIES_KEY=122.ICP.M.U2.N.000000.4.ANR&BS_ITEM=&sfl5=3&sfl4=4&sfl3=4&sfl1=3&DATASET=0&FREQ=M&node=2116082&exportType=sdmx")

# this is the query as per instructions below that work, but the only this does not
#  diff, as above seems to be that <DataSet> does not have ns inf in <>
#z <- TSgetURI(query="http://sdw.ecb.europa.eu/export.do?SERIES_KEY=122.ICP.M.U2.N.000000.4.ANR&REF_AREA=308&sfl4=4&sfl3=4&sfl2=4&DATASET=0&ICP_SUFFIX=ANR&node=2120778&exportType=sdmx")

 <DataSet xmlns="http://www.ecb.int/vocabulary/stats/bsi" xsi:schemaLocation="http://www.ecb.int/vocabulary/stats/bsi https://stats.ecb.int/stats/vocabulary/bsi/2005-07-01/sdmx-compact.xsd">

# this is the one that works
#z <- TSgetURI(query="http://sdw.ecb.europa.eu/export.do?SERIES_KEY=117.BSI.Q.U2.N.A.A21.A.1.U2.2250.Z01.E&sfl5=4&sfl4=4&sfl3=4&sfl2=4&sfl1=3&DATASET=0&FREQ=Q&node=2116082&exportType=sdmx")

# and this monthly version works too (but not right dates from R)
#z <- TSgetURI(query="http://sdw.ecb.europa.eu/export.do?SERIES_KEY=117.BSI.M.U2.Y.U.A21.A.4.U2.2250.Z01.E&REF_AREA=308&sfl5=3&sfl4=4&sfl3=4&sfl2=4&sfl1=3&DATASET=0&FREQ=M&BS_SUFFIX=E&node=2116082&exportType=sdmx")
