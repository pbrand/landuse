make_labels = function(path_harddrive, kind){
  
  #select files that do not hava bgt.rds in them
  dirs = list.files(file.path(path_harddrive, 'output'))
  select = c()
  for(dir in dirs){
    select = c(select, length(  list.files( file.path(path_harddrive, 'output', dir) , pattern = paste(kind , '_labels') ) ) ==0)
  }
  dirs = dirs[select]
  
  
  
  for(dir in dirs){
    print(paste('bizzy with', dir))
    #read shape of kind 'kind'
    shape = readRDS( file.path(path_harddrive, 'output',dir,  paste0(kind, '.rds') ))  
    
    r = raster(file.path(path_harddrive, 'output', dir, dir))
    
    
      if(kind == 'CBS'){
        label = raster::rasterize( shape , r, field = shape$wordt2012)
      }else{
        label = raster::rasterize( shape , r, field =   as.numeric(shape$category))  
      }
      writeRaster(label, file.path(path_harddrive, 'output', dir, paste(kind, '_labels.tif')) )
      
    
    
    
  }
}