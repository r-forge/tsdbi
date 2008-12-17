PREREQ_PACS=tframe tframePlus

include ../Makevars
#override ./Makevars to not copy Licence
CODE_PREREQS=$(CODE) DESCRIPTION NAMESPACE #INDEX LICENSE

# The idea is that TSdbi tests should work with or without specific interfaces,
# since some class and method definitions in TSdbi are needed, but in general,
# db plugs are needed only to do actual calls to databases.

default:	inst/TSsql $(DEFAULT)

PRETESTLIB=$(CODE_PREREQS) $(CODESCAN)

inst/TSsql:
	mkdir $@
	ln  $(SRCDIR)/TSdbi/inst/TSsql/HistQuote.TSsql    inst/TSsql/HistQuote.TSsql
	ln  $(SRCDIR)/TSdbi/inst/TSsql/TSdbi.TSsql	  inst/TSsql/TSdbi.TSsql
	ln  $(SRCDIR)/TSdbi/inst/TSsql/CreateTables.TSsql inst/TSsql/CreateTables.TSsql
	ln  $(SRCDIR)/TSdbi/inst/TSsql/Populate.TSsql	  inst/TSsql/Populate.TSsql
	ln  $(SRCDIR)/TSdbi/inst/TSsql/dbGetQuery.TSsql   inst/TSsql/dbGetQuery.TSsql

PACCLEAN=test

include ../Makerules
