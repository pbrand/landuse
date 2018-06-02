area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, (x1+x2)/2 , x1, x2, x2, x1, x1), 'y' = c(y1, y1, y1, y1, y2, y2, y1) ))) ,1) ))

area = gBuffer(area, width = 0)

gIntersection(area, pol_temp)