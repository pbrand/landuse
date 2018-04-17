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





bands = c("B01", "B02","B03","B04", "B05", "B06", "B07","B08", "B09", "B10", "B11", "B12",  "B8A")

for(band in bands){
   #list all directories
  ids =   list.dirs(dir_output,  full.names = FALSE, recursive = FALSE)
  dirs = file.path(dir_output, ids)
  
  
  for(i in 1:length(dirs)){
    dir = dirs[i]
    ####Retrieve coordinates
    id = ids[i]
    q = paste0('SELECT * FROM index WHERE id = \'', id, '\'' )
    result = dbSendQuery(con, q)
    result = fetch(result, n = -1)
    file = setdiff( list.files(dir, recursive = TRUE, pattern = paste0(band,'.jp2'), full.names = TRUE) ,  list.files(dir, recursive = TRUE, pattern = 'xml', full.names = TRUE) )
    r = raster(file)
    extent(r) = c(result$long_min, result$long_max, result$lat_min,  result$lat_max )
    writeRaster(r, file.path(dir_output, paste0(band , '_', id, '.tif')))
  }
  
}


#gdal_translate
w = round(   geodistance(longvar = x1, latvar = y1 , lotarget = x2 , latarget = y1  )$dist *1.609344*1000 /10)
h = round(   geodistance(longvar = x1, latvar = y1 , lotarget = x1 , latarget = y2  )$dist *1.609344*1000 /10 )

files = list.files(dir_output, full.name = FALSE, pattern = 'tif')

for(file in files){
  gdal_translate( file.path( dir_output, file), file.path(dir_output, paste0('new_',file)) , projwin = c(x1,y2,x2, y1 ), outsize = c(w,h))
}

#merge
for(band in bands){
files = intersect( list.files(dir_output, pattern = 'new', full.names = TRUE ) , list.files(dir_output, pattern = band, full.names = TRUE )  )

r = lapply(files, function(x){
  r = stack(x)
  
})

r = do.call(mosaic, c(r, list(fun = max), list(tolerance = 0.2)))
writeRaster(r, file.path(dir_output, paste0(band, '.tif')))
}




#remove all leftover junk
files = setdiff(list.files(dir_output, recursive = TRUE, full.names = TRUE), file.path(dir_output, paste0(bands,'.tif')) )
file.remove(files)

dirs = setdiff(list.files(dir_output, recursive = TRUE, full.names = TRUE), file.path(dir_output, paste0(bands,'.tif')) )
unlink(dirs, recursive = TRUE)












if(satellite == 'Sentinel2'){
  
  
  bands = c("B01", "B02","B03","B04", "B05", "B06", "B07","B08", "B09", "B10", "B11", "B12", "B13", "B8A")
  
  for(band in bands){
    band_list = list()

    #list all directories
  ids =   list.files(dir_output, include.dirs = TRUE, full.names = FALSE)
  dirs = file.path(dir_output, ids)
    
  
  for(i in 1:length(dirs)){
    dir = dirs[i]
    ####Retrieve coordinates
    id = ids[i]
    q = paste0('SELECT * FROM index WHERE id = \'', id, '\'' )
    result = dbSendQuery(con, q)
    result = fetch(result, n = -1)
    
    #source('Sentinel_API/to_polygon.r')
    
    
    
    
    
    
    
     #cfind the filename of the band in the directory
     file = setdiff( list.files(dir, recursive = TRUE, pattern = paste0(band,'.jp2'), full.names = TRUE) ,  list.files(dir, recursive = TRUE, pattern = 'xml', full.names = TRUE) )
      #read and crop the raster
     r = raster(file)
     
     extent(r) = c(result$long_min, result$long_max, result$lat_min,  result$lat_max )
     

       band_list[[i]] = r
  
       

  }
  #merge the rasters
  band_total =  do.call('mosaic', c(band_list, list(fun = max), list(tolerance = 0.1)) )
  band_total = crop(band_total, extent(im))
  
  writeRaster(file.path(dir_output, paste0(band, '.tif')))
  
  }
  
  
}
  
  
  
  
  
  
  
  