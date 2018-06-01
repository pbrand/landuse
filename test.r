east =   SpatialPolygons( list(Polygons( list(Polygon(  Polygon( data.frame('x' = c(90, 180, 180, 90), 'y' = c(-90, -90, 90, 90) )) )),1)))
east = gBuffer(east, width = 0) 
proj4string(east) =  CRS("+proj=longlat +datum=WGS84")
west =   SpatialPolygons( list(Polygons( list(Polygon(  Polygon( data.frame('x' = c(-180, -90, -90, -180), 'y' = c(-90, -90, 90, 90) )) )),1)))
proj4string(west) =  CRS("+proj=longlat +datum=WGS84")
west = gBuffer(west, width = 0) 


i = 1
polygons = list()

frame = data.frame()

for(n in 1:nrow(result)){
  polygon = as.numeric(unlist(strsplit( result$geometry[i],  '[ ,]')))
  polygon = as.data.frame( matrix(polygon  ,  ncol = 2 , byrow = TRUE ))
  colnames(polygon) = c('y', 'x')
  polygon = polygon[,2:1]
  polygon = Polygon(polygon)
  
  #make temoporaty polygons to compare calculate intersection
  polygons_temp = SpatialPolygons( list(    Polygons(list(polygon), 1) )  )
  proj4string(polygons_temp) =  CRS("+proj=longlat +datum=WGS84")
  polygons_temp = gBuffer(polygons_temp, width = 0) 
  
  
  if( gIntersects( polygons_temp, east) & gIntersects(polygons_temp, west) ){
    
      western = polygon
      western@coords[ western@coords[,1] >0 , 1] = -180
      polygons = append(polygons, Polygons( list(western),i) )
      frame = rbind(frame, result[n,])
      i =i+1
      eastern = polygon
      eastern@coords[ eastern@coords[,1] <0 , 1] = 180
      polygons = append(polygons, Polygons( list(eastern), i) )
      frame = rbind(frame, result[n,])
      i = i+1
    }else{
    polygons = Polygons(list(polygon), i)
    frame = rbind(frame, result[n,])
    i = i+1
  
  }
  }
rownames(frame) = c(1:nrow(frame))
polygons = SpatialPolygons(polygons)
polygons = SpatialPolygonsDataFrame(polygons, frame)
proj4string(polygons) =  CRS("+proj=longlat +datum=WGS84")
