PREREQ_PACS=tframePlus TSdbi TShistQuote

include ../Makevars
#override ./Makevars to not copy Licence
CODE_PREREQS=$(CODE) DESCRIPTION NAMESPACE #INDEX LICENSE

default:	$(DEFAULT)

PRETESTLIB=$(CODE_PREREQS) $(CODESCAN)

include ../Makerules
