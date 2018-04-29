library(DBI)
library(RPostgreSQL)
library(datetime)
library(suncalc)
library(sp)
library(rgdal)
library(rgeos)
library(rPython)
library(parallel)
library(raster)
library(gdalUtils)
library(EBImage)

#######Test input
x1 = 111
x2 = 130
y1 = 28
y2 = 35
date = "2017-02-15"
month_from = 1
month_to = 12
daylight = TRUE
satellite = 'Sentinel1'
downsample_factor = 1     ############is not used in this function but is a required user input to determine output
dir_output = 'test2'       ##########is not used in this function but is required to assign output dir to downloads
cloud_cover = 25


polygons = select(x1,x2,y1,y2, date, month_from, cloud_cover = cloud_cover , month_to, daylight, satellite)
  


area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
proj4string(area) =  CRS("+proj=longlat +datum=WGS84")

plot(polygons)
plot(area, add = TRUE)



