make_labels = function(path_harddrive, kind){
  
  #select files that do not hava bgt.rds in them
  dirs = find_dirs(pattern = paste0(kind , '_labels'), full = FALSE)
  
  
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
      writeRaster(label, file.path(path_harddrive, 'output', dir, paste0(kind, '_labels.tif')) )
      
    
    
    
  }
}