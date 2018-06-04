#testinput

x1 =  4.83122
x2 = 4.8851
y1 = 52.23802
y2 = 52.2844


dir_out = '/home/daniel/R/landuse/requests'
dir_script = 'Sentinel_API/R_scripts_for_sentinelhub/Sentinel_Hub.py'
date_to = '2016-05-24'
satellite = 'L1C'
days = 15

library(datetime)
library(rgdal)
library(rgeos)
library(McSpatial)
##############hoofdfunctie
download = function(x1,x2,y1,y2,satellite, dir_output, date_to, days){
 
  #make polygon from border coordinates. In future version input should be a polygon to begin with
  area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
  proj4string(area) =  CRS("+proj=longlat +datum=WGS84")
   
  #compute date_from to
  date_from =  as.character(as.Date(date_to) - days)
 
  
  #find covering of the area. The covering object is a polygons of squares covering the polygon area
  max_w= 50000 #meter
  max_h = 50000 #meter
  covering = cover(area, w, h)
 
  #now download for each square in the covering polygon a tile from sentinelhub
  for(i in 1:length(covering)){
    
    #calculate the required resolution in order to get more or less 10 meters per pixel
   w =  round(geodistance(longvar = covering$x1[i], latvar = covering$y1[i] , lotarget = covering$x2[i] , latarget = covering$y1[i]  )$dist*1.6*100)
   h =  round(geodistance(longvar = covering$x1[i], latvar = covering$y1[i] , lotarget = covering$x1[i] , latarget = covering$y2[i]  )$dist*1.6*100) 
   
   #run hte download in the comandline
    #You ned to fill in the path to the python script Sentinel_Hub.py here!!!!!!!!!!!!!!!!!!
    comand = paste('python3 Sentinel_API/R_scripts_for_sentinelhub/Sentinel_Hub.py',  x1 , y1,  x2,  y2, date_from,  date_to,  w ,  h,  dir_out,  satellite)
    system(comand)
    
    #rename the file to something something more christian
    file = setdiff( list.files(dir_out), paste0(c(1:length(covering)), '.tiff') )
    file.rename( file.path( dir_out, file), paste0(dir_out, '/', i, '.tif'))
    
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

