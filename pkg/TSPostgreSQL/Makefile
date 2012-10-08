#  ../Makevars goes up real path not sym link, so
NOTPARALLEL=TSodbc  TSdata TScompare
QC=${shell cd ../ ; pwd}

include $(QC)/Makevars 

default: $(DEFAULT)

include $(QC)/Makerules

# some tests depend on the the first one creating the database
.NOTPARALLEL: $(TESTS:%=$(FLAGS)/tests/%)
