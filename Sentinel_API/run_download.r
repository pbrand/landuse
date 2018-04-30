system( './download.sh 148 148.5 60 60.5 2020-02-15 1 12 TRUE Sentinel1 ./test13' , wait = TRUE )



./download.sh 4 7 49 53 2017-02-15 1 12 TRUE Sentinel1 ./test13

library(raster)
library(rgdal)
library(gdalUtils)

gdal_translate( 'Sentinel_API/db/test0/x.dat' , 'test.tif')

x = stack('Sentinel_API/db/test0/x.dat')

