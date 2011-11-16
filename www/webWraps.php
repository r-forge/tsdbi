<?php  require("forgeBar.php") ; ?>
<hr>
<?php require("header.php") ; ?>
<hr>
<table width=100% ALIGN=CENTER CELLPADDING=5 border=0>
<?php require("navigate.php") ; ?>
<!-------------------- START OF CONTENTS -------------------------->
<BODY BGCOLOR="#FFFFFF">
<b>Data from the Internet</b>
<hr>
<P>
Several of the TS* packages are wrappers for other R packages that can be used
to download series from the Internet. In general, the TS* packages try to
retain the data's time frame information if possible. They also try to provide
a mechanism to choose a time series representation other than what might be 
provided by the underlying package.
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
<b><i>TSsdmx</i></b> (not yet working) will (hopefully) be a wrapper for 
a yet to be released package that handles SDMX data. Data is provided in this
format by the OECD, Eurostat, the ECB, the IMF, the UN, the BIS, the Federal
Reserve Board, the World Bank, the Italian Statistics agency, and to a small 
extent by the Bank of Canada.
