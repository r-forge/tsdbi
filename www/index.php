<HTML>
<TITLE>TSdbi</TITLE></a>
<hr>
<?php require("header.php") ; ?>
<hr>
<?php  require("forgeBar.php") ; ?>
<table width=100% ALIGN=CENTER CELLPADDING=5 border=0>
<?php require("navigate.php") ; ?>
<!-------------------- START OF CONTENTS -------------------------->
<BODY BGCOLOR="#FFFFFF">
<hr>
<b><i>TSdbi</i></b> is the base package in a group of packages,
that provide a common interface (API) to time series sources and databases. 
That is, you specify the connection, and after that all of your R code 
syntax can be the same, and does not depend on the specifics of the 
underlying mechanism. Many of these packages are wrappers for other 
packages. The main benefits of the TS* packages are that they provide both a 
common interface and a 
mechanism for specifying the time series representation to be returned. 
<a href=otherFeatures.php>Other features</a> include the ability to handle
vintages of data (sometimes called "realtime data") and panels of time series.

<P>The package <i>TSdata</i> contains (only) a vignette which is a general guide 
to all the packages. <i>TSdata</i> is difficult to install because it requires
working versions of most of the other packages. It will generally be easier just
to get the vignette from the 
<a href="http://cran.at.r-project.org/web/packages/TSdata/vignettes/Guide.pdf">TSdata vignette on CRAN</a>. Of course, that only discusses released packages.

<P>
Several of the packages pull <a href=webWraps.php>
<b>data from the Internet</b>.</a> This includes <i>TSgetSymbol</i>, <i>TShistQuote</i>, 
<i>TSjson</i>, <i>TSxls</i>, <i>TSzip</i> and <i>TSsdmx</i>.
Of these, <i>TSsdmx</i> 
(in development) should eventually provide the most general mechanism.

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
Some packages act as wrappers to convert the API of existing 
time series (database) interfaces. These include <i>TSfame</i>, which is a wrapper to the
<i>fame</i> R package that is an interface to Fame databases. <i>TSpadi</i>
(deprecated) is also a mechanism to interface to Fame and possibly other 
database. 

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
