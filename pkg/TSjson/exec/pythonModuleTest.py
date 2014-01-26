#    python  pythonModuleTest.py sys
#    python  pythonModuleTest.py urllib2
#    python  pythonModuleTest.py mechanize
#    python3  pythonModuleTest.py sys
#    python3  pythonModuleTest.py mechanize  #should fail

import sys

modName = sys.argv[1]

try: 
    __import__(modName)
    print("exit=0") 
except: 
    print("exit=1 moduleError=python module", modName," is not available.")
