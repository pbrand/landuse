source('Sentinel_API/sentinel_data_conversion.r')
source('Sentinel_API/devide_in_smaller.r')
source('Sentinel_API/transleer.r')

library(gdalUtils)
library(rgdal)
library(McSpatial)
library(raster)
library(data.table)

y1 = 60
x1 = 148
y2 = 60.1
x2 = 148.5
satellite = 'Sentinel2'
dir_output = 'db/test3'


prepare_rasters(x1 = x1,x2 = x2,y1 = y1,y2 = y2, satellite = satellite,  dir_input = dir_input)
 