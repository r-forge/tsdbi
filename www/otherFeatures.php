<?php  require("forgeBar.php") ; ?>
<hr>
<?php require("header.php") ; ?>
<hr>
<table width=100% ALIGN=CENTER CELLPADDING=5 border=0>
<?php require("navigate.php") ; ?>
<!-------------------- START OF CONTENTS -------------------------->
<BODY BGCOLOR="#FFFFFF">
<b>Other Features</b>
<hr>
<P>
Other features are only supported by some of the underlying mechanisms.
The SQL databases support the ability to handle
<b>vintages of data</b> (sometimes called "realtime data"). That is, copies of 
the series as they were at different points in time can be made available.
This feature has been relatively well tested.
<b>Panel time series</b> is also supported. That is, the same series identifier
associated with, for example, different regions. This feature has not been well 
tested.
In theory, <b>multilingual</b> support of meta data is also possible, but this feature
has not been fully implemented.
<P>
These features are mostly not supported by non-SQL packages variants, because
they are not available in the underlying source data. 
