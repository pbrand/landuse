
  source('Sentinel_API/sentinel_data_conversion.r')
  source('Sentinel_API/devide_in_smaller.r')
  source('Sentinel_API/transleer.r')

  
  library(gdalUtils)
  library(rgdal)
  library(McSpatial)
  library(raster)
  library(data.table)
  

  coord = devide_in_smaller(x1 =x1,x2= x2,y1= y1,y2= y2)

zone =  (floor((x1 + 180)/6) %% 60) + 1

  area = SpatialPoints(cbind(c(x1,x2), c(y1, y2 ) ),  proj4string=CRS("+proj=longlat"))
  area = spTransform(area, CRS(paste0("+proj=utm +zone=", zone)))


   if(satellite == 'Sentinel2'){
     print('hoi')
    for(i in 1:nrow(coord)){
    dir_output = i
    print(i)
    transleer(x1 = coord$x1[i],x2 = coord$x2[i],y1 = coord$y1[i ],y2 = coord$y2[i],  dir_output = i, dir_input = dir_input)
    }

     }


