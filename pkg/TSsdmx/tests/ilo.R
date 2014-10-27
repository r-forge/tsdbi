#http://www.ilo.org/
http://www.ilo.org/global/statistics-and-databases/lang--en/index.htm
http://laborsta.ilo.org/
http://www.ilo.org/ilostat/faces/home/statisticaldata?_afrLoop=798940075174646#%40%3F_afrLoop%3D798940075174646%26_adf.ctrl-state%3Dug32xk2ku_4

# identifier construction?:
http://www.ilo.org/ilostat/content/conn/ILOSTATContentServer/path/Contribution%20Folders/statistics/web_pages/static_pages/ILOSTATcsv_EN.pdf%20%0A

> browse by country
> Canada
>Unemployment
>by sex and age

require("TSsdmx")

ilo <- TSconnect("sdmx", dbname="ILO")

# ecb identifier
z <- TSget('EXR.A.USD.EUR.SP00.A', ilo)
