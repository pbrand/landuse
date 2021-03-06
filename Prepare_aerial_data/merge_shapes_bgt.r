#crop and save individual shapes

merge_shapes_bgt = function(path_harddrive){

bgt_parts = list.dirs( file.path(path_harddrive, 'db', 'bgt'), recursive = FALSE)


shape_names = c('wegdeel', 'waterdeel', 'pand')

for(shape_name in shape_names){
print(shape_name)

for(i  in 1:length(bgt_parts)){
print(paste('Starting with bgt part', bgt_parts[i]))
bgt_part =bgt_parts[i]
shape = readOGR( file.path( bgt_part, shape_name))

projection = readRDS( file.path(path_harddrive, 'db', 'projection.rds'))
shape@proj4string = projection

if(shape_name == 'pand'){ 
  shape$category = 'pand'
  shape@data = data.frame('category'  = shape$category)}

if(shape_name == 'wegdeel'){
  shape@data = data.frame('category'  = shape$function.)}
if(shape_name == 'waterdeel'){shape@data = data.frame('category'  = shape$class)}

#####wat doet dit????
shape <- gBuffer(shape, byid=TRUE, width=0)
#########

#select files that do not hava bgt.rds in them
dirs_output = find_dirs(pattern = 'BGT',full = FALSE)

#loop over alle dirs heen en plaats subshape erin
for(dir_output in dirs_output){
  print(paste('bizzy with', dir_output))
  r = raster( file.path(path_harddrive, 'output', dir_output, dir_output))
  extent = extent(r)
  
  shape_part = crop(shape, extent)

saveRDS(shape_part, file.path( path_harddrive, 'output', dir_output, paste0('bgt_', shape_name, '_', i, '.rds') ))
}
}
  
}

###############

print('start merging')
dirs_output = dirs_output = find_dirs(pattern = 'BGT',full = FALSE)

#merge all the shapes that have been written
for(dir_output in dirs_output){
  print(dir_output)
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

############Label all bgt file with numbers as well########
print('add numbers from legend')
dirs = find_dirs( pattern = 'BGT.rds', full = TRUE)

legend = read.csv( file.path(path_harddrive, 'db/bgt_legend.csv'))

for(dir in dirs){
  print(dir)
  bgt = readRDS( file.path(dir, 'bgt.rds'))
  
  bgt$number =  legend$number[ match(bgt$category, legend$names)]
  
  saveRDS( bgt, file.path(dir, 'BGT.rds') )
  #file.remove(file.path(dir, 'bgt.rds'))
}

}