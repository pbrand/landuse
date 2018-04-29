####TEST INPUT
 y1 = 51.5
 x1 = 4.5
 y2 = 52.5
 x2 = 5.5
 dir_input = 'Sentinel_API/db/test'
 satellite = 'Sentinel2'
# 
prepare_images(x1= x1, x2 = x2, y1 = y1, y2= y2, dir_input = dir_input, satellite = satellite)

prepare_images = function(x1,x2,y1,y2,satellite, dir_input){





library(gdalUtils)
library(rgdal)
library(McSpatial)
library(raster)
library(data.table)

############DEVIDE IN SMALLER 
step_x = (x2-x1) /  ( geodistance(longvar = x1, latvar = y1 , lotarget = x2 , latarget = y1  )$dist *1.609344*1000 /20000)   
step_y = (y2- y1) / (  geodistance(longvar = x1, latvar = y1 , lotarget = x1 , latarget = y2  )$dist *1.609344*1000 /20000 )  

len_x = floor((x2-x1)/ step_x) +1
len_y = floor((y2-y1)/ step_y) +1


x_mins = x1 + c(0:(len_x-1)) * step_x
x_maxs = x1 + c(1:len_x) * step_x

y_mins = y1 + c(0:(len_y-1)) * step_y
y_maxs = y1 + c(1:len_y) * step_y

coord = lapply( c(1:length(y_mins)), function(i){
  data.frame('x1' = x_mins, 'x2'= x_maxs, 'y1'= y_mins[i], 'y2'= y_maxs[i])
  
})

coord = rbindlist(coord)


zone =  (floor((x1 + 180)/6) %% 60) + 1
temp_min = SpatialPoints(cbind( coord$x1, coord$y1 ),  proj4string=CRS("+proj=longlat"))
temp_min = spTransform(temp_min, CRS(paste0("+proj=utm +zone=", zone)))
temp_max = SpatialPoints(cbind( coord$x2, coord$y2 ),  proj4string=CRS("+proj=longlat"))
temp_max = spTransform(temp_max, CRS(paste0("+proj=utm +zone=", zone)))


coord_utm = data.frame('x1' =  temp_min@coords[,1], 'y1' = temp_min@coords[,2], 'x2' = temp_max@coords[,1], 'y2' =  temp_max@coords[,2] )
#################


############FIND ZONE AND TRANSLATE COORDINATE TO THAT ZONE

###############################

#####If sentinel2
if(satellite == 'Sentinel2'){
  
  ########################################gdal translate for each subwindow and band
  for(i in 1:nrow(coord)){
    dir_output = i
    
    ##transleren, uitsnijden en resampelen met gdal_translate
    w = round(   geodistance(longvar = coord$x1[i], latvar = coord$y1[i] , lotarget = coord$x2[i] , latarget = coord$y1[i]  )$dist *1.609344*1000 /10)
    h = round(   geodistance(longvar = coord$x1[i], latvar = coord$y1[i] , lotarget = coord$x1[i] , latarget = coord$y2[i]  )$dist *1.609344*1000 /10 )
    
    bands = c("B01", "B02","B03","B04", "B05", "B06", "B07","B08", "B09", "B10", "B11", "B12",  "B8A")
    
    
  
    files = unlist(lapply(bands, function(band){
       setdiff( list.files(dir_input, pattern = paste0(band,'.jp2'), full.names = FALSE , recursive = TRUE) ,  list.files(dir_input, recursive = TRUE, pattern = '.xml', full.names = FALSE) )

      }))
    
    dir.create(file.path( dir_input, dir_output))
    
    out_names = unlist(lapply(files, function(x){
      x = strsplit(x, '[/]')[[1]][5]
      x= strsplit(x, '[.]')[[1]][1]
    }))
    
    for( j in 1:length(files)){
      gdal_translate( file.path( dir_input, files[j]), file.path(dir_input, dir_output, paste0(out_names[j], '.tif')) , projwin = c( coord_utm$x1[i], coord_utm$y2[i], coord_utm$x2[i] , coord_utm$y1[i] ), outsize = c(w,h))
    }
    
  
    
    #########################mosaic the raster per band
    for(band in bands){
      print(band)
      files = setdiff( list.files(file.path(dir_input, dir_output), pattern = band),  list.files(file.path(dir_input, dir_output), pattern = 'aux')   )
      #read and crop the raster
      
   r = raster(file.path(dir_input, dir_output, files[1]) )
      
      if(length(files)>1){
        for(n in 2:length(files)){
        r_new = raster( file.path(dir_input, dir_output, files[n]))
        r[r[,,]==0 ] = r_new[r[,,]==0 ]
      }
      }
      writeRaster(r, file.path( dir_input, dir_output, paste0(band, '.tif')), overwrite = TRUE)
      
    }
    
    #remove junk files
    files=  setdiff( list.files(file.path(dir_input, dir_output)),  paste0(bands, '.tif') )
    file.remove( file.path(dir_input, dir_output, files))
    
  }
    
  
    
  
  
}




########################################################
#######################################################
#########################################################
if(satellite == 'Sentinel1'){
  
  ########################################gdal translate for each subwindow and band
  for(i in 1:nrow(coord)){
    dir_output = i
    
    ##transleren, uitsnijden en resampelen met gdal_translate
    w = round(   geodistance(longvar = coord$x1[i], latvar = coord$y1[i] , lotarget = coord$x2[i] , latarget = coord$y1[i]  )$dist *1.609344*1000 /10)
    h = round(   geodistance(longvar = coord$x1[i], latvar = coord$y1[i] , lotarget = coord$x1[i] , latarget = coord$y2[i]  )$dist *1.609344*1000 /10 )
    
    bands = c("B01", "B02","B03","B04", "B05", "B06", "B07","B08", "B09", "B10", "B11", "B12",  "B8A")
    
    
    
    files = unlist(lapply(bands, function(band){
      setdiff( list.files(dir_input, pattern = paste0(band,'.jp2'), full.names = FALSE , recursive = TRUE) ,  list.files(dir_input, recursive = TRUE, pattern = '.xml', full.names = FALSE) )
      
    }))
    
    dir.create(file.path( dir_input, dir_output))
    
    out_names = unlist(lapply(files, function(x){
      x = strsplit(x, '[/]')[[1]][5]
      x= strsplit(x, '[.]')[[1]][1]
    }))
    
    for( j in 1:length(files)){
      gdal_translate( file.path( dir_input, files[j]), file.path(dir_input, dir_output, paste0(out_names[j], '.tif')) , projwin = c( coord_utm$x1[i], coord_utm$y2[i], coord_utm$x2[i] , coord_utm$y1[i] ), outsize = c(w,h))
    }
    
    
    
    #########################mosaic the raster per band
    for(band in bands){
      print(band)
      files = setdiff( list.files(file.path(dir_input, dir_output), pattern = band),  list.files(file.path(dir_input, dir_output), pattern = 'aux')   )
      #read and crop the raster
      
      r = raster(file.path(dir_input, dir_output, files[1]) )
      
      if(length(files)>1){
        for(n in 2:length(files)){
          r_new = raster( file.path(dir_input, dir_output, files[n]))
          r[r[,,]==0 ] = r_new[r[,,]==0 ]
        }
      }
      writeRaster(r, file.path( dir_input, dir_output, paste0(band, '.tif')), overwrite = TRUE)
      
    }
    
    #remove junk files
    files=  setdiff( list.files(file.path(dir_input, dir_output)),  paste0(bands, '.tif') )
    file.remove( file.path(dir_input, dir_output, files))
    
  }
  
  
  
  
  
}



}
