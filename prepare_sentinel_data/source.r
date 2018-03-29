library(rgdal)
library(gdalUtils)
library(raster)
library(SpaDES)

path = '/home/daniel/R/landuse/prepare_sentinel_data/db'

dirs = list.files( file.path(path, 'sentinel2')  , full.names = TRUE)

for(dir in dirs){
  files = list.files(dir, full.names = TRUE)
  r = stack(files)
  
}