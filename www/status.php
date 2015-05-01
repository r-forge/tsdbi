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
The general status of the packages is as follows:

<P><i>TSsdmx</i> has rapidly become the prime mechanism for downlaoding data
from most statistical organizations. Some of the data providers are still
in development mode and not completely stable.

<P><i>TSmisc</i> contains wrappers that were previously in separate package
(<i>TSgetSymbol</i>, <i>TShistQuote</i>, <i>TSxls</i>, <i>TSzip</i>) and thus
is fairly well tested and stable.

<P><i>TSMySQL</i>, <i>TSPostgreSQL</i>, <i>TSSQLite</i>, and <i>TSodbc</i> 
are all well tested and stable. 

<P><i>TScompare</i>, and <i>TSdata</i> are also mature and well tested.

<P><i>TSjson</i> works and is fairly actively tested, but 
is only implemented for a connection to Statistics Canada. The umderlying
mechanizm is not a real API and inherits some instability because of this.
This package will be phased out when Statistics Canada implements SDMX/REST.
It has been archived on CRAN and is only available from this R-forge site.

<P><i>TSOracle</i> may work, but I have no mechanism to test it. (Volunteers 
please contact the project administrator.) 
It is only available from this R-forge site.

<P><i>TSfame</i> worked (in 2011) but I no longer have access to Fame to test 
it. (Also, the <i>fame</i> package, which <i>TSfame</i> uses, requires
purchasing the Fame API driver to build completely. 
I have never tested this in Windows, but it should work.)

<P><i>TSpadi</i> worked (in 2011) but I no longer have access to Fame to 
test it and it has been archived on CRAN and is only available from 
this R-forge site. It is largely superceded by <i>TSfame</i> and other packages.

<P> If you are interested in becoming a developer on this project, especially
if you can test or help extend the packages to cover other sources of time
series data, please contact the project administrator.
