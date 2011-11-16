<html>
<head>

<META NAME="Author"     CONTENT="Paul Gilbert">
<META NAME="Title"      CONTENT="Time Series Database Interface">
<META NAME="Keywords"   CONTENT="Time Series Data, Time Series Data Interface">

<script type="text/javascript">
<!--
var imageA1=new Image()
    imageA1.src="US-CPIsmall.png"
var imageA2=new Image()
    imageA2.src="US-M2small.png"
var imageA3=new Image()
    imageA3.src="Fordsmall.png"
var imageA4=new Image()
    imageA4.src="EuroUSDsmall.png"
var imageA5=new Image()
    imageA5.src="adcdsmall.png"
var imageA6=new Image()
    imageA6.src="ftsesmall.png"
var imageA7=new Image()
    imageA7.src="gspcsmall.png"
            
var imageB1=new Image()
    imageB1.src="tyxsmall.png"
var imageB2=new Image()
    imageB2.src="vixsmall.png"
var imageB3=new Image()
    imageB3.src="vsUSDsmall.png"
var imageB4=new Image()
    imageB4.src="ibmVsmall.png"
var imageB5=new Image()
    imageB5.src="ibmsmall.png"
var imageB6=new Image()
    imageB6.src="indusmall.png"
var imageB7=new Image()
    imageB7.src="indusmall.png"
//-->
</script>
</head>

<BODY BGCOLOR="#FFFFFF">

<table BORDER="0" CELLPADDING="5" WIDTH="100%" CELLSPACING="0" BGCOLOR="#FFFFFF" >
<td ALIGN="center" WIDTH="20%">
<font SIZE="+3" color="Black">TSdbi</font>
</td>

<td ALIGN="center" WIDTH="40%">
<a  href="US-CPI.png">
<img name="slideA" width="360" height="180" ></a>
</td>

<td ALIGN="center" WIDTH="40%">
<!-- <a  href="JavaScript:document.images.slideB.src"> -->
<a  href="US-M2.png">
<img name="slideB" width="360" height="180" ></a>
</td>

<script>
<!--
//variable that will increment through the images
var step=1
function slideit(){
  //if browser does not support the image object, exit.
  if (!document.images) return
  document.images.slideA.src=eval("imageA"+step+".src")
  document.images.slideB.src=eval("imageB"+step+".src")
  if (step<7) step++
  else step=1
  //call function "slideit()" every 5 seconds
  setTimeout("slideit()",5000)
  }
slideit()
//-->
</script>

</table>
</body>
</html>
