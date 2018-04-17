source('Sentinel_API/source.r')

################Transform output to SpatialPolygonsDataFrame format
polygons = SpatialPolygons( lapply(  c(1:nrow(result))  , function(i){
  polygon = as.numeric(unlist(strsplit( result$geometry[i],  '[ ,]')))
  polygon = as.data.frame( matrix(polygon  ,  ncol = 2 , byrow = TRUE ))
  colnames(polygon) = c('y', 'x')
  polygon = polygon[,2:1]
  polygon = Polygon(polygon)
  
  polygon = date_line_case(polygon, i)
  
  return(polygon)
}))
polygons = SpatialPolygonsDataFrame(polygons, result)
proj4string(polygons) =  CRS("+proj=longlat +datum=WGS84")
