#################SENTINEL 2################
library(gdalUtils)
library(rgdal)
library(McSpatial)
library(DBI)
library(RPostgreSQL)
library(raster)
#######Test input

y1 = 60
x1 = 148.8
y2 = 61
x2 = 149.8
satellite = 'Sentinel2'
dir_output = 'Sentinel_API/db/test3'        ##########is not used in this function but is required to assign output dir to downloads


drv <- dbDriver("PostgreSQL")
con = dbConnect( drv  , dbname= 'esa_index', host = 'birdsai.co',port = 5432, user = 'maasd', password = 'Brooksrange24')


if(satellite == 'Sentinel2'){
  
  
  bands = c("B01", "B02","B03","B04", "B05", "B06", "B07","B08", "B09", "B10", "B11", "B12", "B13", "B8A")
  
  for(band in bands){
    band = list()
#list all directories
  dirs =   list.files(dir_output, include.dirs = TRUE, full.names = TRUE)
  for(i in 1:length(dirs)){
    dir = dirs[i]
    ####Retrieve coordinates
    id = '831edafa-9f72-4774-ace8-3465d2c08b66'
    q = paste0('SELECT * FROM index WHERE id = \'', id, '\'' )
    result = dbSendQuery(con, q)
    result = fetch(result, n = -1)
    bbox = c(result$long_min, result$long_max, result$lat_min,  result$lat_max )
    
     #cfind the filename of the band in the directory
     file = setdiff( list.files(dir, recursive = TRUE, pattern = paste0(band,'.jp2'), full.names = TRUE) ,  list.files(dir, recursive = TRUE, pattern = 'xml', full.names = TRUE) )
      #read and crop the raster
       r = raster(file)
       extent(r) = bbox
       r = crop(r, extent(im))
       band[[i]] = r
  }
  #merge the rasters
  band =  do.call('mosaic', c(band, list(fun = max)))
  
  #resample
  w = round(   geodistance(longvar = extent(band)[1], latvar = extent(band)[3] , lotarget = extent(band)[2] , latarget = extent(band)[3]  )$dist *1.609344*1000 /10)
  h = round(   geodistance(longvar = extent(band)[1], latvar = extent(band)[3] , lotarget = extent(band)[1] , latarget = extent(band)[4]  )$dist *1.609344*1000 /10 )
  im = raster(matrix(0, nrow = h, ncol = w))
  extent(im) = extent(band)
  band = resample(band, im)
    
  #save band
     writeRaster(band, file.path(dir_output, paste0(band, '.tif')))
    
     
      
  
  }
  
  
}


dbDisconnect(con)
