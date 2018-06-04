library(gdalUtils)
library(rgdal)
library(McSpatial)
library(raster)
library(data.table)

##############hoofdfunctie
process_images = function(x1,x2,y1,y2,satellite, dir_input, polygons){
  #make area
  area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
  proj4string(area) =  CRS("+proj=longlat +datum=WGS84")
  
  #find covering of the area
  max_w= 50000 #meter
  max_h = 50000 #meter
  covering = cover(area, w, h)
  
  #find UTMC bounding coordinates for the boxes
  covering@data$zone =  (floor((covering$x1 + 180)/6) %% 60) + 1
  covering$x1_utm = -1
  covering$x2_utm = -1
  covering$y1_utm = -1
  covering$y2_utm = -1
  
  
  for(i in 1:length(covering)){
    utm_transform =   spTransform( covering[i,], CRS(paste0("+proj=utm +zone=", covering$zone[i] )))@bbox
    covering$x1_utm[i] = utm_transform[1,1]
    covering$x2_utm[i] = utm_transform[1,2]
    covering$y1_utm[i] = utm_transform[2,1]
    covering$y2_utm[i] = utm_transform[2,2]
  }
  
  ####cut out these regions from the downloaded files
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
  
  
  
  for(i in 1:length(covering)){
    
  }
  
  
  
}


#######################




######################################cover a shape with rectangles of equal width and heigth
cover = function(area, w, h){
  
  
  #get coordinates that form a bounding box
  x1 =  area@bbox[1,1]
  x2 =  area@bbox[1,2]
  y1 =  area@bbox[2,1]
  y2 =  area@bbox[2,2]
  
  
  
  parts_x = floor( ( geodistance(longvar = x1, latvar = y1 , lotarget = x2 , latarget = y1  )$dist *1.6*1000 ) / max_w +1)
  parts_y =  floor( ( geodistance(longvar = x1, latvar = y1 , lotarget = x1 , latarget = y2  )$dist *1.6*1000 ) / max_h +1 )
  
  x2_vec = x1 + (x2 - x1)/parts_x * rep(c(1:parts_x), each  = parts_y)
  x1_vec = x1 + (x2 - x1)/parts_x * rep(c(0: (parts_x-1)), each  = parts_y)
  
  y2_vec= y1 + (y2- y1)/parts_y * rep( c(1:parts_y), times = parts_x)
  y1_vec= y1 + (y2- y1)/parts_y * rep( c(0:(parts_y-1)), times = parts_x)
  
  coords =  data.frame('x1' = x1_vec , 'y1' = y1_vec, 'x2' = x2_vec, 'y2' = y2_vec)
  
  
  
  coords$w = geodistance(longvar = coords$x1, latvar = coords$y1 , lotarget = coords$x2 , latarget = coords$y1  )$dist *1.6*1000 
  coords$h = geodistance(longvar = coords$x1, latvar = coords$y1 , lotarget = coords$x1 , latarget = coords$y2  )$dist *1.6*1000 
  
  
  
  #make polygons out of it
  covering =  SpatialPolygons( lapply(c(1:nrow(coords)), function(i){
    Polygons( list(Polygon( data.frame('x' = c( coords$x1[i], coords$x2[i], coords$x2[i], coords$x1[i], coords$x1[i]), 'y' = c(coords$y1[i], coords$y1[i], coords$y2[i], coords$y2[i], coords$y1[i]) ))) ,i) 
  }))
  
  rownames(coords) = c(1:nrow(coords))
  covering = SpatialPolygonsDataFrame( covering, data = coords)
  proj4string(covering) =  CRS("+proj=longlat +datum=WGS84")
  
  
  #give polygons a dataframe, widht, height, does it intersect with the area?
  
  covering@data$intersects =  unlist( lapply(c(1:length(covering)), function(i){
    gIntersects(area, covering[i,])
    
  }))
  
  covering = covering[covering$intersects,]  
  
  return(covering)
}


##########################################


prepare_images = function(x1,x2,y1,y2,satellite, dir_input, polygons){
  
  
  #split up the area in windows
  
  
  
  
  ############DEVIDE IN SMALLER 
  pix = 10
  step_x = (x2-x1) /  ( geodistance(longvar = x1, latvar = y1 , lotarget = x2 , latarget = y1  )$dist *1.609344*1000 / (2000 * pix) )   
  step_y = (y2- y1) / (  geodistance(longvar = x1, latvar = y1 , lotarget = x1 , latarget = y2  )$dist *1.609344*1000 / (2000 * pix) )  
  
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
  
  #################
  
  
  ############FIND ZONE AND TRANSLATE COORDINATE TO THAT ZONE
  
  ###############################
  
  #####If sentinel2
  if(satellite == 'Sentinel2'){
    
    
    
    zone =  (floor((x1 + 180)/6) %% 60) + 1
    temp_min = SpatialPoints(cbind( coord$x1, coord$y1 ),  proj4string=CRS("+proj=longlat"))
    temp_min = spTransform(temp_min, CRS(paste0("+proj=utm +zone=", zone)))
    temp_max = SpatialPoints(cbind( coord$x2, coord$y2 ),  proj4string=CRS("+proj=longlat"))
    temp_max = spTransform(temp_max, CRS(paste0("+proj=utm +zone=", zone)))
    
    
    coord_utm = data.frame('x1' =  temp_min@coords[,1], 'y1' = temp_min@coords[,2], 'x2' = temp_max@coords[,1], 'y2' =  temp_max@coords[,2] )
    
    ########################################gdal translate for each subwindow and band
    for(i in 1:nrow(coord)){
      dir_output = i
      
      ##transleren, uitsnijden en resampelen met gdal_translate
      w = round(   geodistance(longvar = coord$x1[i], latvar = coord$y1[i] , lotarget = coord$x2[i] , latarget = coord$y1[i]  )$dist *1.609344*1000 /pix)
      h = round(   geodistance(longvar = coord$x1[i], latvar = coord$y1[i] , lotarget = coord$x1[i] , latarget = coord$y2[i]  )$dist *1.609344*1000 /pix )
      
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
  
  #throw away old files
  # files = list.files(dir_input)
  # files = setdiff( files, c(1:nrow(coord)) )
  # files = file.path(dir_input, files)
  #   
  # unlink(files, recursive = TRUE)
  
  
  
  
}
