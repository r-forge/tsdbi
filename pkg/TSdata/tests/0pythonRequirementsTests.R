# require('devtools')
# devtools::install_github("trevorld/findpython")
# find_python_cmd(required_modules = c('argparse', 'json | simplejson'))

require('findpython')

cmdExists <- can_find_python_cmd(
    minimum_version = '2.6',
    maximum_version = '2.9',
    required_modules = c('sys', 're', 'urllib2', 'csv', 'mechanize', 'json')
    )

if (cmdExists) CMD  <- attr(cmdExists, 'python_cmd') else
   stop('adequate python was not found. ')
  
