<hr>
<?php require("header.php") ; ?>
<hr>
<?php  require("forgeBar.php") ; ?>
<table width=100% ALIGN=CENTER CELLPADDING=5 border=0>
<?php require("navigate.php") ; ?>
<!-------------------- START OF CONTENTS -------------------------->
<BODY BGCOLOR="#FFFFFF">
<b>Project Package Status</b>
<hr>

<P>
The general status of the packages is as follows: <i>TSgetSymbol</i>, 
<i>TShistQuote</i>, <i>TSxls</i>, <i>TSzip</i> <i>TSMySQL</i>, 
<i>TSPostgreSQL</i>, <i>TSSQLite</i>, <i>TSodbc</i>, <i>TScompare</i>, 
and <i>TSdata</i> work and are actively tested. 
<i>TSjson</i> works and is actively tested, but 
currently is only implemented for a connection to Statistics Canada.
Please contact the project administrator if you are interested in helping
implement for other data sources.
<P>
<i>TSOracle</i> may work, but I have no mechanism to test it. (Volunteers 
please contact the project administrator.)
<P>
<i>TSfame</i> worked (in 2011) but I no longer have access to Fame to test 
it. (Also, the <i>fame</i> package, which <i>TSfame</i> uses, requires
purchasing the Fame API driver to build completely. 
I have never tested this in Windows, but it should work.)
<P>
<i>TSpadi</i> worked (in 2011) but I no longer have access to Fame to 
test it and it has been archived on CRAN. It is largely superceded 
by <i>TSfame</i> and other packages.
<P>
<i>TSsdmx</i> is still experimental.

<P>See the R-forge packages or source code repository
for more specific details about current versions and ongoing changes.

<P> If you are interested in becoming a developer on this project, especially
if you can test or help extend the packages to cover other sources of time
series data, please contact the project administrator.
