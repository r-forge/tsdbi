<hr>
<?php require("header.php") ; ?>
<hr>
<?php  require("forgeBar.php") ; ?>
<table width=100% ALIGN=CENTER CELLPADDING=5 border=0>
<?php require("navigate.php") ; ?>
<!-------------------- START OF CONTENTS -------------------------->
<BODY BGCOLOR="#FFFFFF">
<b>Data from the Internet</b>
<hr>
<P>
<b><i>TSgetSymbol</i></b> is a wrapper for <i>getSymbols</i> in package
<i>quantmod</i> and, among other sources can retrieve data from Yahoo, Google,
Oanda and the U.S. Federal Reserve FRED database.
<P>
<b><i>TShistQuote</i></b> is a wrapper for  <i>get.hist.quote</i> in package 
<i>tseries</i> and can be used to get stock prices from Yahoo and Oanda.
<P>
<b><i>TSxls</i></b> is a wrapper for <i>read.xls</i> in package 
<i>gdata</i>. A map of the location of data in a spreadsheet is specified.
The spreadsheet can be a local file or come from an Internet location.
An example with data from the Reserve Bank of Australia is provided.
<P>
<b><i>TSzip</i></b> downloads zipped comma separated value files, unzips 
them and then extracts the data. An example is provided with exchange rate
data from pitrading.com (no affiliation).
<P>
<b><i>TSjson</i></b> gets time series data from the 
source, and imports it to R using Javascript object notation (JSON). 
Fetching the data is done
using a script with <i>Python mechanize</i> to click through web pages to get a 
file to downloaded. It does not use a real API to the data server (although it
could if the server implements support). For this reason <i>TSjson</i> should be
considered a temporary solution, until the data server implements a proper API. 
The <i>Python</i> scripts are not generic, there needs to be a customized script
for a specific site. Currently, only a Statistics Canada connection is supported.
If you would like to work on a connection to another site, please contact the 
package maintainer.
<P>
<i>TSjson</i> package supports two mechanisms for contacting the web data 
source. The first calls a <i>Python</i> script distributed with the package. 
This requires that the R client machine can run  <i>Python</i> and has several 
<i>Python</i> modules installed (mechanize, sys, json, re, csv, urllib2), which
all seem to be installed with 
<a href="http://wwwsearch.sourceforge.net/mechanize>python-mechanize</a>.
On most systems, including Windows, install can be 
done by going to the directory of the unzipped package that contains the
file setup.py and at the command prompt running  "python setup.py install". 
It will also be necessary have python on your PATH so the program can be found.
(On many Linux systems these modules are available with the debian package
<i>python-mechanize</i>.)
<P>
Since installing software may be difficult in some environments, a second
mechanism uses an intermediate proxy portal to the real web source data server.
The proxy retrieves and relays the data. This requires setting up an HTTP server
somewhere on the Internet, which must have <i>Python</i> and the modules installed,
but on the R client machine only R and the <i>TSjson</i> package are required.
The server can require user identification and a password.
Please contact the package maintainer if you would be interested in providing 
an intermediate proxy server to the community.
<P>
<b>TSsdmx</i></b> (not yet working) will (hopefully) be a wrapper for 
a yet to be released package that handles SDMX data. 
SDMX is an XML time series data format supported by several large international organizations (OECD, Eurostat, the ECB, the IMF, the UN, the BIS,
the Federal Reserve Board, the World Bank, the Italian Statistics agency, 
and to a small extent by the Bank of Canada).
For this reason it is likely to be the most complete interface
at some time in the future. Several of these organizations provide an option to 
download data in SDMX format, after clicking through web pages to construct a 
data request. 
However, a SOAP or REST protocol for doing this automatically does not yet seem
to be completely standardized. Furthermore, a complete, robust, SDMX parser is a
non-trivial project, or at least requires a good understand of some powerful 
tools. For these reasons the <i>TSsdmx</i> package is still very experimental.

<P> If you are interested in becoming a developer on these projects, please contact 
the project administrator.
