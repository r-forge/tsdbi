<HTML>
<TITLE>TSdbi</TITLE></a>
<?php  require("forgeBar.php") ; ?>
<hr>
<?php require("header.php") ; ?>
<hr>
<table width=100% ALIGN=CENTER CELLPADDING=5 border=0>
<?php require("navigate.php") ; ?>
<!-------------------- START OF CONTENTS -------------------------->
<BODY BGCOLOR="#FFFFFF">
<hr>
<b><i>TSdbi</i></b> is the base package in a group of packages,
that provide a common interface (API) to time series databases. 
That is, you specify the connection, and after that all of your R code 
syntax can be the same, and does not depend on the specifics of the 
underlying mechanism. These packages are almost all wrappers for other 
packages. The main benefits of the TS* packages are that they provide a 
common interface, and a 
mechanism for returning a specified time series representation. 
(For example, the <i>fame</i> package returns <i>tis</i> series, 
but <i>TSfame</i> handles conversion and allows the possibility of 
returning other representations like <i>zoo</i> series.) 
<a href=otherFeatures.php>Other features</a> include the ability to handle
vintages of data (sometimes called "realtime data") and panels of time series.

<P>Guide vignettes with the packages on CRAN provide examples. 

<P>
Several of the packages pull <a href=webWraps.php>
<b>data from the Internet</b>.</a> This includes
<i>TSgetSymbol</i>, <i>TShistQuote</i>, <i>TSxls</i>, <i>TSzip</i> 
and <i>TSsdmx</i>.

<P>
Other packages provide a mechanism for 
<a href=sqlWraps.php><b>building an SQL time series database</b>.</a> 
This includes
<i>TSMySQL</i>, <i>TSPostgreSQL</i>, <i>TSSQLite</i>, <i>TSodbc</i> 
and untested <i>TSOracle</i>.
If you already have a backend SQL database, and are not building the database,
just an interface to an <b>existing database</b>, then the <i>TSdbi</i> package 
function <i>TSquery</i> may be useful. It can be used to construct 
time series from SQL databases that contain sequential data but were built 
for purposes other than storing time series data.

<P>
Some packages act as a <b>database wrapper</b> to extend the API to existing 
time series database interfaces. These include <i>TSfame</i>, which is a wrapper to the
<i>fame</i> R package, which is an interface to Fame databases. <i>TSpadi</i>
(deprecated) is also a mechanism to interface to Fame and possibly other 
database. <i>TSsdmx</i> (in development) will provide mechanism to interface to
SDMX data, both locally and over the Internet.

<P>
<i>TScompare</i> provides a way to compare large numbers of series on different
databases. 

<P>
<b><i>TSdbi</i></b> uses the NAMESPACE and methods from package <i>DBI</i>.

<P>
The general <a href=status.php><b>status</b> of the packages is here</a>.

<!-------------------------------- END OF CONTENTS ------------------->
</table>

</body></html>
