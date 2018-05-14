library(DBI)
library(RPostgreSQL)
library(datetime)
library(suncalc)
library(sp)
library(rgdal)
library(rgeos)
library(rPython)
library(parallel)
library(raster)
library(gdalUtils)
library(EBImage)

#######Test input
x1 = 0
x2 = 18
y1 = 43
y2 = 50
date = "2017-02-15"
days = 100
month_from = 1
month_to = 12
daylight = TRUE
satellite = 'Sentinel2'
downsample_factor = 1     ############is not used in this function but is a required user input to determine output
dir_output = 'test2'       ##########is not used in this function but is required to assign output dir to downloads
cloud_cover = 25


polygons = select(x1,x2,y1,y2, date, month_from, cloud_cover = cloud_cover , month_to, daylight, satellite,  days)
  



library(leaflet)

area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('lng' = c(x1 , x2 , x2, x1, x1), 'lat' = c(y1, y1, y2, y2, y1) ))) ,1) ))
area@proj4string <-CRS("+init=epsg:3857")

m = leaflet()
m = addProviderTiles(m, providers$OpenStreetMap)
m = addPolygons(m, data = area, color = 'red')
m = addPolygons(m, data = polygons, color = 'blue')
m = addTiles(m)
saveWidget(m, "temp.html")


string = 'random'
polygons = polygons

plot_grid(string, polygons){
png(paste(string, '.png'))
par(bg=NA)
plot(polygons)
dev.off()
}
