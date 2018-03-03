#crop and save individual shapes

merge_shapes_bgt = function(path_harddrive){

dirs = list.dirs( file.path(path_harddrive, 'db', 'bgt'), recursive = FALSE)

for(i  in 1:length(dirs)){
print(paste('Starting with bgt part', i))
dir =dirs[i]
wegdeel = readOGR( file.path( dir, 'wegdeel'))
waterdeel = readOGR( file.path(dir, 'waterdeel'))
pand = readOGR( file.path( dir, 'pand'))

projection = readRDS( file.path(path_harddrive, 'db', 'projection.rds'))

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

#select files that do not hava bgt.rds in them
dirs_output = list.files(file.path(path_harddrive, 'output'))
select = c()
for(dir_output in dirs_output){
select = c(select, length(  list.files( file.path(path_harddrive, 'output', dir_output), pattern = 'bgt.rds') ) ==0)
}
dirs_output = dirs_output[select]

for(dir_output in dirs_output){
  print(paste('bizzy with', dir_output))
  r = raster( file.path(path_harddrive, 'output', dir_output, dir_output))
  extent = extent(r)
  

  shape_part = crop(shape, extent)

saveRDS(shape_part, file.path( path_harddrive, 'output', dir_output, paste0('bgt_', i, '.rds') ))
}
}

###############


for(dir_output in dirs_output){
  print(dir_output)
#merge all the shapes that have been written
file_names = list.files( file.path(path_harddrive, 'output', dir_output), pattern = 'bgt_', full.names = TRUE)
shapes = list()
for(i in 1:length(file_names)){
  shapes[[i]] = readRDS(file_names[i])
  file.remove(file_names[i])
}

shapes = compact(shapes)
shape = do.call(rbind, shapes)
saveRDS(shape,  file.path( file.path(path_harddrive, 'output', dir_output) , 'bgt.rds'))

}


}