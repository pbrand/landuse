prepare_rasters = function(x1,x2,y1,y2, satellite, dir_input){
  library(gdalUtils)
  library(rgdal)
  library(McSpatial)
  library(raster)
 
    source('devide_in_smaller.r')
   source('transleer.r')
  
  coords = devide_in_smaller(x1 =x1,x2= x2,y1= y1,y2= y2)
  
zone =  (floor((x1 + 180)/6) %% 60) + 1
  
  area = SpatialPoints(cbind(c(x1,x2), c(y1, y2 ) ),  proj4string=CRS("+proj=longlat"))
  area = spTransform(area, CRS(paste0("+proj=utm +zone=", zone))) 
  
 
  
  if(satellite == 'Sentinel2'){
    
    for(i in 1:nrow(coords)){
    dir_output = i
    print(i)
    transleer(x1 = coords$x1[i],x2 = coords$x2[i],y1 = coords$y1[i ],y2 = coords$y2[i], satellite = satellite, dir_output = i, dir_input = dir_input)
    }
  
    }


}
