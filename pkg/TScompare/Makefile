#  TScompare may need one of these
NOTPARALLEL=TSMySQL TSSQLite TSPostgreSQL TSodbc 

#  ../Makevars goes up real path not sym link, so
QC=${shell cd ../ ; pwd}

include $(QC)/Makevars 

default: $(DEFAULT)

include $(QC)/Makerules
