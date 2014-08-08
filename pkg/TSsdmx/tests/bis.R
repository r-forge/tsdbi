# Status:  Partially working.
#    Preliminary investigation notes.
#     Seem to only be able to get data generatd by a query on the web page 
#     and stored (cookie?)  Have not figured out how to do a remote query.
  

# http://stats.bis.org/

## python playing
## import requests
## get_response = requests.get(url='http://google.com')
## get_response = requests.get(url='http://stats.bis.org/bis-stats-tool/org.bis.stats.ui.StatsApplication/ResultDownload?format=sdmx-ml-data&bookmark=true&query=eJwtzMENwjAQBMC1FUHCC1EHTZzNWiAIkLNRlJc7oLGUQgdUw6FkH7e6eSzgjp93HbAPlzwy1CglxzN74rAKqScpkm6PEZYO2M5rf603ztlt0CpTFaXY5%2BGjwMsLTVIOJg6ux86mapB8ZVnojvZPZXpyAcUP9e8ZAQ%3D%3D')

## get_response.text


## post_data = {'username':'joeb', 'password':'foobar'}
## post_response = requests.post(url='http://some.other.site', data=post_data)


#> Statistics > Display Query URL
 
#http://stats.bis.org/bis-stats-tool/org.bis.stats.ui.StatsApplication/ResultDownload?format=csv&bookmark=true&query=eJxjYGDUOZ1iXcUg4OQZHO7qFO%2FsGBLs7OHq68ogBBVxdQ1ycQxxdPPxD2cAAk4GBvbVUPoWkGZjZASSjAwsbkGugWAWoy8DAD7ID1Q%3D

#Canada, Australia effective real exchange rate

#http://stats.bis.org/bis-stats-tool/org.bis.stats.ui.StatsApplication/ResultDownload?format=sdmx-ml-data&bookmark=true&query=eJwtzMENwjAQBMC1FUHCC1EHTZzNWiAIkLNRlJc7oLGUQgdUw6FkH7e6eSzgjp93HbAPlzwy1CglxzN74rAKqScpkm6PEZYO2M5rf603ztlt0CpTFaXY5%2BGjwMsLTVIOJg6ux86mapB8ZVnojvZPZXpyAcUP9e8ZAQ%3D%3D

#Canada. go to bottom of page to displayquery

#http://stats.bis.org/bis-stats-tool/org.bis.stats.ui.StatsApplication/ResultDownload?format=sdmx-ml-data&bookmark=true&query=eJxjYGDUOcf%2F1YlBwMkzONzVKd7ZMSTY2cPV15VBCCri6hrk4hji6ObjH84ABJwMDOyrofSt%2Bv%2F%2F%2FzOCRFkYOIJc3eIdg1wdgTxGBiZnRwYWtyDXQDCP0ZeBC2hMvJNjsLdrCETIj4EDJBQSGeAKEQhiAACyYBw

