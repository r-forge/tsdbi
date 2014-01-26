#    python  checkForPython.py 2
#    python  checkForPython.py 3
#    python2  checkForPython.py 3
#    python3  checkForPython.py 3

# Note: mechanize is not (yet) available for Python 3, 
# Also, urllib2 is split into urllib.request, urllib.error in Python 3

try: 
    import sys
    ver = sys.argv[1]
    if str(sys.version_info[0]) == ver: print("exit=0 version="+str(sys.version_info)) 
    else:                               print("exit=1 version="+str(sys.version_info))
except: 
    print("exit=1 moduleError=python module sys is not available for version check.")
