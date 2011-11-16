<?php  require("forgeBar.php") ; ?>
<hr>
<?php require("header.php") ; ?>
<hr>
<table width=100% ALIGN=CENTER CELLPADDING=5 border=0>
<?php require("navigate.php") ; ?>
<!-------------------- START OF CONTENTS -------------------------->
<BODY BGCOLOR="#FFFFFF">
<b>Project Package Status</b>
<hr>

<P>
The general status of the packages is as follows: <i>TSgetSymbol</i>, 
<i>TShistQuote</i>, <i>TSxls</i>, <i>TSzip</i> <i>TSMySQL</i>, 
<i>TSPostgreSQL</i>, <i>TSSQLite</i>, <i>TSodbc</i> work and are actively 
tested. 
<P>
<i>TSOracle</i> may work, but I have no mechanism to test it.
<P>
<i>TSfame</i> works (as of 2011) but I no longer have access to Fame to test 
it. (Also, the <i>fame</i> package, which <i>TSfame</i> uses, requires
purchasing the Fame API driver to build. 
I have never tested this in Windows, but it should work.)
<i>TSpadi</i> works (as of 2011) but I no longer have access to Fame to 
test it, and it is largely superceded by <i>TSfame</i>.
<P>
<i>TSsdmx</i> is on hold pending release of an SDMX package.

<P>See the R-forge packages or source code repository
for more specific details about current versions and ongoing changes.

<P> If you are interested in becoming a developer on this project, especially
if you can test or help extend the packages to cover other sources of time
series data, please contact the project administrator.
