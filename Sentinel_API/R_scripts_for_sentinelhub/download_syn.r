#############################PARAMETERS####################################################


#search input of user
date_to = '2018-01-19'  #what date are we considering
satellite = 'L1C' #What satellite system do we use  other possibilities L1C L2A and SENTINEL1
days = 20 # How far are we looking back


#in case of box what are the bounding coordinates
x1 =  4.5
x2 = 5
y1 = 50
y2 = 51

#needed in case you want to use pre-defined shape
shape_name = 'Netherlands' #  'Aruba' # 

#where to write the downloads
dir_out = '/home/daniel/R/landuse/requests'


##parameters to restrict requests in size, depend on the user account
threshold_area = 5  #how large can the requested area be
threshold_days = 31 #For how long a period can the user requst data
wait = 60  #how many seconds does the server wait till making the wms request for the next tile
################################################################################################

###############################callable functions###############################
#main_base_on_boundingbox(x1,x2,y1,y2,satellite, dir_out, date_to, days, cores, threshold_area, wait, threshold_days)

#main_base_on_shape(x1,x2,y1,y2,satellite, dir_out, date_to, days, shape_name, wait, threshold_area, threshold_days)

#make_preview(dir_out)

#what_are_the_shapes()


################################Required libraries########################################
#setwd('/home/daniel/R/landuse/Sentinel_API/R_scripts_for_sentinelhub')
library(datetime)
library(rgdal)
library(rgeos)
library(McSpatial)
library(parallel)
library(jpeg)
library(raster)
#sentinelhub package of python. python 3 or higher required

###################################donwload based on a bounding box#########################################
#callable from C#

main_base_on_boundingbox = function(x1,x2,y1,y2,satellite, dir_out, date_to, days, cores, threshold_area, wait, threshold_days){
  
  #in case search window in time is too large throw an error
  if(days >31){ return('Time window is larger than your service plan allows.')}
  
  #make polygon out of input
  #in case x2<x1 split the polygon on the date line x = 180
  if(x2<x1){
    area =  SpatialPolygons( list( Polygons( list(Polygon( data.frame('x' = c(x1, 180, 180, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ,   Polygons( list(Polygon( data.frame('x' = c(-180, x2, x2, -180, -180), 'y' = c(y1, y1, y2, y2, y1) ))) ,2) ))
    proj4string(area) =  CRS("+proj=longlat +datum=WGS84")    
  }else{
    area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
    proj4string(area) =  CRS("+proj=longlat +datum=WGS84")
  }
  
  #In case area is too large throw an error
  if(gArea(area) > threshold_area){return('Area is larger than your service plan allowed')}
  
  
  #download the area
  for(i in 1:length(area)){
    download(area[i,],satellite, file.path(dir_out, i), date_to, days, wait)
  }
  
  return('Download ready')
  
}


################################Donwload based on a predefined shape ###############################
#Callable from C#

main_base_on_shape = function(x1,x2,y1,y2,satellite, dir_out, date_to, days, shape_name, wait, threshold_area, threshold_days){
  #check if time window is not too large
  if(days >threshold_days){ return('Time window is larger than your service plan allows.')}
  
  #load n the requested shape
  world = readOGR('world')
  area = world[world$NAME == shape_name,]
  
  #Check if the area is not too large
  if(gArea(area) > threshold_area){return('area was larger than your service plan allowed')}
  
  #download the images
  for(i in 1:length(area)){
    download( area[i,] ,satellite, file.path(dir_out,i), date_to, days , wait )
  }
  return('Download ready')
}


#################dowload an area###################################
#Not callable from C#
download = function(area,satellite, dir_out, date_to, days, wait){
  #create the subdir in which you are going to write
  dir.create(dir_out)
  
  
  #some configuration parameters
  w= 50000 #meter
  h = 50000 #meter
  res = 10 #meter
  
  
  #find covering of the area. The covering object is a polygons of squares covering the polygon area
  #these values are chosen this way as our desired resolution is 10 meters and we can at maximum request and image of 5000 by 5000
  covering = cover(area, w, h)
  
  
  for(i in 1:length(covering)){
    print(i)
    #create a directory in which you are going to place the images of this tile
    dir.create(file.path(dir_out, i))
    
      #compute date_from based on date_to and days
      date_from = as.character(as.Date(date_to) - days)
      #built the wms request
      comand = paste('python3 Sentinel_Hub.py',  covering$x1[i] , covering$y1[i],  covering$x2[i],  covering$y2[i], date_to,  round(covering$w[i]/res) , round(covering$h[i]/res ),  file.path(dir_out, i),  satellite, '--date_earliest', date_from)
      #run the comand synchronosly in the comand line
      try(system(comand, intern = FALSE , wait = FALSE))
      
      #wait a moment before making another request
      Sys.sleep(wait) 
  }
  
  }
  

#################FIND COVERING OF AN AREA######
#Not callable from C#
cover = function(area, w, h){
  
  
  #get coordinates that form a bounding box aournd the area
  x1 =  area@bbox[1,1]
  x2 =  area@bbox[1,2]
  y1 =  area@bbox[2,1]
  y2 =  area@bbox[2,2]
  
  
  #calculate in how many parst we should devide the heigth and width of the bounding box
  parts_x = floor( ( geodistance(longvar = x1, latvar = y1 , lotarget = x2 , latarget = y1  )$dist *1.6*1000 ) / w +1)
  parts_y =  floor( ( geodistance(longvar = x1, latvar = y1 , lotarget = x1 , latarget = y2  )$dist *1.6*1000 ) / h +1 )
  
  #calculate all bounding box coordinates of the covering squares
  x2_vec = x1 + (x2 - x1)/parts_x * rep(c(1:parts_x), each  = parts_y)
  x1_vec = x1 + (x2 - x1)/parts_x * rep(c(0: (parts_x-1)), each  = parts_y)
  y2_vec= y1 + (y2- y1)/parts_y * rep( c(1:parts_y), times = parts_x)
  y1_vec= y1 + (y2- y1)/parts_y * rep( c(0:(parts_y-1)), times = parts_x)
  #place the bounding box coordinates of the covering squares in a dataframe
  coords =  data.frame('x1' = x1_vec , 'y1' = y1_vec, 'x2' = x2_vec, 'y2' = y2_vec)
  
  #calculate width and heigth of the covering squares
  coords$w = geodistance(longvar = coords$x1, latvar = coords$y1 , lotarget = coords$x2 , latarget = coords$y1  )$dist *1.6*1000 
  coords$h = geodistance(longvar = coords$x1, latvar = coords$y1 , lotarget = coords$x1 , latarget = coords$y2  )$dist *1.6*1000 
  
  
  
  #make a polygons object of this covering
  covering =  SpatialPolygons( lapply(c(1:nrow(coords)), function(i){
    Polygons( list(Polygon( data.frame('x' = c( coords$x1[i], coords$x2[i], coords$x2[i], coords$x1[i], coords$x1[i]), 'y' = c(coords$y1[i], coords$y1[i], coords$y2[i], coords$y2[i], coords$y1[i]) ))) ,i) 
  }))
  rownames(coords) = c(1:nrow(coords))
  covering = SpatialPolygonsDataFrame( covering, data = coords)
  proj4string(covering) =  CRS("+proj=longlat +datum=WGS84")
  
  
  ##The following is trivial in case the area to be covered is a square, but for general shapes the following procedure is helpfull
  #look what square actualle intersect with the area itself
  covering@data$intersects =  unlist( lapply(c(1:length(covering)), function(i){
    gIntersects(area, covering[i,])
    
  }))
  #remove all non intersecting squares from the polygon
  covering = covering[covering$intersects,]  
  
  return(covering)
}


###################FIND ALL PREDIFINED SHAPES##############
#Callable from C#
what_are_the_shapes = function(){
  world = readOGR('world')
  return( unique(world$NAME))
}

##################################MAKE JPEG VIEW OF TIFF FILES##################################################
#Callable from C#
make_preview = function(dir_out){
  
  files =  setdiff( list.files(dir_out, recursive = TRUE, include.dirs = FALSE, full.names = TRUE, pattern = 'tiff'), list.files(dir_out, recursive = TRUE, include.dirs = FALSE, full.names = TRUE, pattern = 'xml') )
  target_files = gsub(files, patter = 'tiff', replacement = '.jpg')
  
 
 for( i in 1:length(files)){
    im = raster::stack(files[i], bands = c(4:2) )
    im = raster::as.array(im)
    writeJPEG(im, target_files[i])
 }
  
}

