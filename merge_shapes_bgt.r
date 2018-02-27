#crop and save individual shapes

dirs = list.dirs('db/bgt', recursive = FALSE)

for(i  in 1:length(dirs)){
print(paste('bizzy with bgt part', i))
dir =dirs[i]
wegdeel = readOGR( paste0( dir, '/wegdeel'))
waterdeel = readOGR( paste0(dir, '/waterdeel'))
pand = readOGR( paste0( dir, '/pand'))

pand@proj4string = projection
wegdeel@proj4string = projection
waterdeel@proj4string = projection

pand$category = 'pand'
pand@data = data.frame('category'  = pand$category)
wegdeel@data = data.frame('category'  = wegdeel$function.)
waterdeel@data = data.frame('category'  = waterdeel$class)

shape = rbind(waterdeel, pand)
shape = rbind(shape, wegdeel)

#####wat doet dit????
shape <- gBuffer(shape, byid=TRUE, width=0)
#########


for(file in files){
  print(paste('bizzy with', file))
  r = raster(paste0('db/hoogte bestand/', file))
  extent = extent(r)
  

  shape_part = crop(shape, extent)

saveRDS(shape_part, paste0( subdir, '/', file , '/bgt__', i, '.rds'))
}
}

#merge all the shapes that have been written
file_names = list.files(paste0(subdir, '/', file), pattern = 'bgt_', full.names = TRUE)
shapes = list()
for(i in 1:length(file_names)){
  shapes[[i]] = readRDS(file_names[i])
  file.remove(file_names[i])
}

shape = do.call(rbind, shapes)
saveRDS(shape, paste0(subdir, '/', file, '/bgt.rds'))


