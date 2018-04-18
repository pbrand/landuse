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

prepare_rasters(x1 = x1,x2 = x2,y1 = y1,y2 = y2, satellite = satellite, dir_output = dir_output)

prepare_rasters = function(x1,x2,y1,y2, satellite, dir_output){
  
  area = SpatialPoints(cbind(c(x1,x2), c(y1, y2 ) ),  proj4string=CRS("+proj=longlat"))
  area = spTransform(area, CRS("+proj=utm +zone=55")) 
  
  
  
  
  if(satellite == 'Sentinel2'){
    w = round(   geodistance(longvar = x1, latvar = y1 , lotarget = x2 , latarget = y1  )$dist *1.609344*1000 /10)
    h = round(   geodistance(longvar = x1, latvar = y1 , lotarget = x1 , latarget = y2  )$dist *1.609344*1000 /10 )
    
    bands = c("B01", "B02","B03","B04", "B05", "B06", "B07","B08", "B09", "B10", "B11", "B12",  "B8A")
    
    
    
    
    
    files = unlist(lapply(bands, function(band){
      setdiff( list.files(dir_output, pattern = paste0(band,'.jp2'), full.names = FALSE , recursive = TRUE) ,  list.files(dir_output, recursive = TRUE, pattern = 'xml', full.names = TRUE) )
    }))
    
    out_names = unlist(lapply(files, function(x){
      x = strsplit(x, '[/]')[[1]][5]
      x= strsplit(x, '[.]')[[1]][1]
    }))
    
    for( i in 1:length(files)){
      gdal_translate( file.path( dir_output, files[i]), file.path(dir_output, paste0(out_names[i], '.tif')) , projwin = c( area@coords[1,1], area@coords[2,2], area@coords[2,1] , area@coords[1,2] ), outsize = c(w,h))
      
    }
    
    
    
    #cfind the filename of the band in the directory
    for(band in bands){
      files = list.files(dir_output, pattern = band)
      #read and crop the raster
      band_total = stack(file.path(dir_output, files))
      
      
      
      band_total =  lapply(files, function(file){
        raster(file.path(dir_output,file) )
      })
      
      band_total =  do.call('mosaic', c(band_total, list(fun = max), list(tolerance = 0.1)) )
      writeRaster(band_total, file.path(dir_output, paste0(band, '.tif')))
      
      
    }
    
    
    #remove all leftover junk
    files = setdiff( file.path(dir_output, list.files(dir_output)), file.path(dir_output, paste0(bands,'.tif')) ) 
    file.remove(files)
    
    dirs = setdiff( list.dirs(dir_output) ,dir_output)
    unlink(dirs, recursive = TRUE)
  }else(
    print('I only do sentinel2 for now')
  )
  
  ###########################
}



