source('packages.r')

#shape = readOGR('db/CBS_shape_publicatie_bestand')
shape = readRDS('db/shape_publicatie_bestand.rds')
shape = readRDS('db/CBS/shape_mutatie.rds')

sh = readRDS('db/CBS/shape_mutatie_bestand_wgs_1.rds')

n = 1
m = length(sh)

for(i in n:m){
  print(i/m)
  for(j in 1:length(shape@polygons[[i]])){
  shape@polygons[[i]]@Polygons[[j]]@coords = sh@polygons[[i]]@Polygons[[j]]@coords
  }
}


saveRDS(shape, 'db/CBS/shape_mutatie_bestand_wgs.rds')


#omrekenen naar wgs
for(i in 1:length(shape)){
print(i / length(shape))
  
  for(j in 1:length((shape@polygons[[i]]) )){
  shape@polygons[[i]]@Polygons[[j]] = spTransform(shape[i,], CRS("+proj=longlat +datum=WGS84"))@polygons[[1]]@Polygons[[j]]
}
  }

saveRDS(shape, 'db/CBS/shape_mutatie_bestand_wgs.rds')


#plotten
map = leaflet()
map = addProviderTiles(map, 'Esri.WorldImagery')


for(i in 1:5){
map = addPolygons(map, lng = shape@polygons[[i]]@Polygons[[1]]@coords[,1],  lat = shape@polygons[[i]]@Polygons[[1]]@coords[,2] )
}
map


#haal categorie eruit
shape = shape[shape$BG2012 %in% c(60) ,]


#get sentinel data
mapImageData1 <- get_map(location = c(lon = -0.016179, lat = 51.538525),
                         color = "color",
                         source = "google",
                         maptype = "satellite",
                         zoom = 17)





#crop shape
sh = crop(shape, extent(shape[1,])  )

#rasterize

r = raster(nrow = 600, ncol = 600, extent(shape[2,]))

r = raster(nrow = 1, ncol = 1)
extent(r) = c(183415, 183440, 456809, 456830)

r = rasterize(shape, r, shape$BG2012)

plot(r)
unique(values(r))


#AHN
r = raster('db/hoogte bestand/1.tif')
r = raster(nrow = 600, ncol = 100, extent(r))
r = rasterize(shape, r, shape$wordt2012)
writeRaster(r, 'raster.tif')



#lees bgt
shape = readOGR('db/bgt/bgt_pand.gml', require_geomType = "wkbPolygon")
