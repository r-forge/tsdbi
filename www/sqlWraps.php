<?php  require("forgeBar.php") ; ?>
<hr>
<?php require("header.php") ; ?>
<hr>
<table width=100% ALIGN=CENTER CELLPADDING=5 border=0>
<?php require("navigate.php") ; ?>
<!-------------------- START OF CONTENTS -------------------------->
<BODY BGCOLOR="#FFFFFF">
<c><b>SQL Databases</b></c>
<hr>
<P>
The <b>SQL variants</b> (<i>TSPostgreSQL</i>, <i>TSMySQL</i>, <i>TSSQLite</i>, 
<i>TSodbc</i>, and untested <i>TSOracle</i>) include table structure 
definitions for the database. 
The database does not need to be built with R, but the table structure needs 
to be respected for the TS* SQL variants to work.
<P>
With the SQL tables I believe series of daily frequency and lower are 
handled fairly well. (I work mostly with monthly and quarterly data, 
but also use daily and weekly data.) In theory, tick data (time stamped series)
are also handled, but I have never work with that kind of data, so it 
is not well tested.
<P>
The tables also provide a mechanism for storing meta data descriptions of 
series, so you can store company descriptions, but there is no SQL 
structure within the description. That is, you could not do a SQL query 
to select certain types of businesses based on the description. 
(This would probably not be too difficult to implement, but it is not in 
the structure provided.)
<P>
There is a not very well tested mechanism for handling series name 
changes (by an alias).
<P>
<b><i>TSMySQL</i></b> is a wrapper for package <i>RMySQL</i>.
<b><i>TSPostgreSQL</i></b> is a wrapper for package <i>RPostgreSQL</i>.
<b><i>TSSQLite</i></b> is a wrapper for package <i>RSQLite</i>.
<b><i>TSodbc</i></b> is a wrapper for package <i>RODBC</i>.
<b><i>TSOracle</i></b> is a wrapper for package <i>ROracle</i>.
