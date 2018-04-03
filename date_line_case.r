#construc eastern and wester hemishpere SpatialPolygons


date_line_case = function(polygon, i){
east =   SpatialPolygons( list(Polygons( list(Polygon(  Polygon( data.frame('x' = c(90, 180, 180, 90), 'y' = c(-90, -90, 90, 90) )) )),1)))
proj4string(east) =  CRS("+proj=longlat +datum=WGS84")
west =   SpatialPolygons( list(Polygons( list(Polygon(  Polygon( data.frame('x' = c(-180, -90, -90, -180), 'y' = c(-90, -90, 90, 90) )) )),1)))
proj4string(west) =  CRS("+proj=longlat +datum=WGS84")



#case handeling of dateline
polygons_temp = SpatialPolygons( list(    Polygons(list(polygon), 1) )  )
proj4string(polygons_temp) =  CRS("+proj=longlat +datum=WGS84")
if( gIntersects( polygons_temp, east) & gIntersects(polygons_temp, west) ){
  eastern = polygon
  eastern@coords[ eastern@coords[,1] <0 , 1] = 180
  western = polygon
  western@coords[ western@coords[,1] >0 , 1] = -180
  polygon = Polygons(list(eastern, western), i)
}else{
  polygon = Polygons(list(polygon), i)
}

return(polygon)
}
####end case handeling