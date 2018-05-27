source('Sentinel_API/select.r')


#######Test input
x1 = 179
x2 = -179
y1 = 52
y2 = 53
date = "2017-02-15"
days = 100
month_from = 1
month_to = 12
daylight = TRUE
satellite = 'Sentinel2'
downsample_factor = 1     ############is not used in this function but is a required user input to determine output
dir_output = 'test1'       ##########is not used in this function but is required to assign output dir to downloads
cloud_cover = 25


polygons = select(x1,x2,y1,y2, date, month_from, cloud_cover = cloud_cover , month_to, daylight, satellite,  days)





#draw area
area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
proj4string(area) =  CRS("+proj=longlat +datum=WGS84")

#get map
location = extent(polygons)
sq_map <-  get_map(location = c(location[1] - 0.5, location[3] -0.5, location[2] +0.5, location[4]+0.5), maptype = "satellite", source = "google")


  ggmap(sq_map) + geom_polygon( data = polygons, aes(long,lat), fill = 'red', alpha = 0.2)+ geom_polygon( data = area, aes(long,lat), fill = 'yellow', alpha = 0.2)

  
  
  ggplot() + geom_polygon( data = area, aes(long,lat), fill = 'yellow', alpha = 0.2)