#!/usr/bin/python
# eg
#    cansimGet.py v498086
#    ./cansimGet.py V36610
#    ./cansimGet.py V39050
# or
#    python  cansimGet.py v498086

# weekly
#    cansimGet.py V36610

# based on code by Geoff Wright

import sys
import json

mnem = sys.argv[1]

def get(mnem):
    
    #if sys.version_info >= (3, 0):
    #	import urllib.request, urllib.error
    #else:
    # untested in v3 urllib2 is split into urllib.request, urllib.error
    import urllib2
    import mechanize, re, csv
    # Open search form
    response = mechanize.urlopen("http://www5.statcan.gc.ca/cansim/home-accueil?lang=eng")
    if not response: return dict(error="URL not responding.", mnem=mnem)

    #mnem=request.args[0]
    # Find form
    forms = mechanize.ParseResponse(response, backwards_compat=False)
    form = forms[0]
    form.set_value(mnem, name="pattern", kind="text")
    request2 = form.click()

    response2 = mechanize.urlopen(request2)
    if not response2: 
        return dict(error="Form navigation step 2 failed.", mnem=mnem)
    forms = mechanize.ParseResponse(response2, backwards_compat=False)
    form = forms[0]
    try: 
        request3 = form.click(id="a08Sbm")
    except: 
        return dict(error="Series not found.", mnem=mnem)

    response3 = mechanize.urlopen(request3)
    if not response3:
        return dict(error="Form navigation step 3 failed.", mnem=mnem)
    forms = mechanize.ParseResponse(response3, backwards_compat=False)
    form = forms[0]
    
    try: 
        control = form.find_control("smonth", type="select")
        startper = str(control.get_items()[0]).lstrip("*")
        form.set_value([startper],name="smonth")
    except: 
        startper = 12
        
    control = form.find_control("syear", type="select")
    startyear = str(control.get_items()[0]).lstrip("*")

    form.set_value([startyear],name="syear")
    form.set_value(['SERIES_CSV_TIME_AS_ROW'],name="exporterId")
    request4 = form.click(label="Retrieve now")
    
    response4 = mechanize.urlopen(request4)
    if not response4:
        return dict(error="Form navigation step 4 failed.", mnem=mnem)
    
    csv_search = re.search('http://www5.statcan.gc.ca/cansim/results/cansim.[0-9]*\.csv', response4.read())
    if not csv_search:
        return dict(error="File to download not found.", mnem=mnem)
    
    f_url = csv_search.group()
    
    f = urllib2.urlopen(f_url)
    if not f: return dict(error="Retrieving file failed.", mnem=mnem)
   
    a = []
    for l in f.readlines():
        a.append(l)
    
    try: desc = a[1].split('"')[1].strip("\n")
    except:desc=a[1] 
    shortdesc = desc.split('; ')[-1]
    freq = a[2].split(',')[0].strip("\n")
    mnem = a[2].split(',')[1].strip("\r\n")
    source = "Statistics Canada: "+desc.split(":")[0]+"; "+mnem
    
    # Format to make accessible as R object
    if freq == "Annual":
        freq = 1
        startper = 1
    elif freq == "Semi-annual":
        freq = 2
        startper = 1
    elif freq == "Quarterly":
        freq = 4
        startper = int(startper)/3
    elif freq == "Monthly":
        freq = 12
        startper = int(startper)
    elif freq == "Weekly":
        startper = 1
    elif freq == "Daily":
        startper = 1
    else:
        freq = "Error"
    
    start = [int(startyear),startper]
    
    d = []
    x = []
    for i in range(3,len(a)):
       xi = a[i]
       if (freq == "Weekly") | (freq == "Daily"):
            d.append(xi.split(',')[0])
       
       xi = xi.split(',')[1].strip("\r\n")
       
       if xi == "":
            x.append(None)
       elif xi == "..":
            x.append(None)
	    # check this bad data point with statcan or BoC
       else:
            x.append(float(xi))
    
    #session.shortdesc = shortdesc
    #session.x = x
    
    if (freq == "Weekly") | (freq == "Daily"):
       return dict(desc=desc,shortdesc=shortdesc,freq=freq,
                mnem=mnem,dates=d,x=x,source=source)
    else:
       return dict(desc=desc,shortdesc=shortdesc,freq=freq,
                mnem=mnem,start=start,x=x,source=source)


#z = get(mnem)
#print '%(mnem)s has freq %(freq)03d ' % z
#print 'dates %(dates)s ' % z

print(json.JSONEncoder().encode(get(mnem)))
