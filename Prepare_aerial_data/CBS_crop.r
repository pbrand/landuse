CBS_crop = function(path_harddrive){

  #find all folders in output which do not have a CBS shape in them
  dirs = find_dirs(pattern = 'CBS', full = FALSE)
  ###
  
  
for(dir in dirs){
  print(paste('bizzy with', dir))
  r = raster( file.path(path_harddrive, 'output', dir, dir))
  extent = extent(r)

shapes = list.files( file.path(path_harddrive, 'db', 'CBS'))

CBS = readRDS(file.path(path_harddrive, 'db', 'CBS', shapes[1])  )
CBS = crop(CBS, extent)
shapes = shapes[-1]

for(shape in shapes){
    CBS_extra = readRDS( file.path(path_harddrive, 'db', 'CBS', shape)  )
  CBS_extra = crop(CBS_extra, extent)
  CBS = rbind(CBS, CBS_extra)
}

saveRDS(CBS, file.path(path_harddrive, 'output', dir , 'CBS.rds'))

}
  
  
  
}