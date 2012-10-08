#  TScompare may need one of these
NOTPARALLEL=TSodbc TSMySQL TSSQLite TSPostgreSQL TSdata

#  ../Makevars goes up real path not sym link, so
QC=${shell cd ../ ; pwd}

include $(QC)/Makevars 

default: $(DEFAULT)

include $(QC)/Makerules

# some tests depend on the the first one creating the database
.NOTPARALLEL: $(TESTS:%=$(FLAGS)/tests/%)
