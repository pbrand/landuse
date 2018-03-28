library(rgdal)
library(gdalUtils)
library(raster)
library(stringi)

path = '/home/daniel/R/landuse/prepare_sentinel_data/db'

#################SENTINEL 2################
max_dim =  10980
dir_in = file.path(path, 'sentinel_2_data')
dir_out = file.path(path, 'sentinel2')
  
#translate all files
dirs = list.files(dir_in, full.names = TRUE)

for(n in 1:length(dirs)){
  dir = dirs[n]
  dir.create(file.path(dir_out, n))
files = setdiff(list.files( file.path(dir,'IMG_DATA'), full.names = TRUE,  pattern = 'jp2') , list.files( file.path(dir,'IMG_DATA'), full.names = TRUE,  pattern = 'xml') )
for(i in 1:length(files) ){
  gdal_translate(files[i], file.path(dir_out, n, paste0( i, '.tif')), outsize = c(max_dim, max_dim) )   
    }
    
  
}


#stack all files
dirs = list.files('/home/daniel/sentinel2', full.names = TRUE)


for(i in 1:length(dirs)){
  dir = dirs[i]

  
  files = list.files(dir, full.names = TRUE, recursive = TRUE, pattern = 'tif')
  total = raster(files[1])
  
  
  
  for(j in 2:length(files) ){
    
    new = raster(files[j])
    total = stack ( total, new )
    writeRaster(total,file.path('sentinel_2', paste0(i, 'tif') )  )
    }
  
  
}



new = raster( values(new), nrows = max_dim, ncols = max_dim, extent = extent(new))

#####################SENTINEL1##################################