#!/usr/bin/python
# eg
#    ./systemRequirementsTests.py
# or
#    python  systemRequirementsTests.py

def test():

    try: 
        import sys
	have_sys = True
    except: 
	have_sys = False
     
    if sys.version_info >= (3, 0): return dict( error=
	"TSjson requires Python 2. Running "+ str(sys.version_info))
    # mechanize is not (yet) available for Python 3, 
    # Also, urllib2 is split into urllib.request, urllib.error in Python 3


    try: 
        import urllib2
	have_urllib2 = True
    except: 
	have_urllib2 = False

    try: 
        import re
	have_re = True
    except: 
	have_re = False

    try: 
        import csv
	have_csv = True
    except: 
	have_csv = False

    try: 
        import mechanize
	have_mechanize = True
    except: 
	have_mechanize = False

    if (have_sys & have_urllib2 & have_re & have_csv & have_mechanize):
        err = 0
    else:
	err = 1

    return dict(
         exit=err, 
             have_sys=have_sys, have_urllib2=have_urllib2,
             have_re = have_re, have_csv = have_csv, 
	     have_mechanize = have_mechanize)


try: 
    import json
    print(json.JSONEncoder().encode(test()))
except: 
    print(dict(exit=1, have_json = False))
    
