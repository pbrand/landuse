library(raster)
  #select files that do not hava bgt.rds in them
  dirs = list.files('db')
  
  for(dir in dirs){
    print(paste('bizzy with', dir))
    #read shape of kind 'kind'
    shape = readRDS( file.path('db',dir,  paste0( 'CBS.rds') ))  
    
    r = raster(file.path( 'db', dir, dir))
    
    
      label = raster::rasterize( shape , r, field =  as.numeric( shape$wordt2012 ), fun = max )
    
      
      
    writeRaster(label, file.path('db', dir, 'CBS_labels_new.tif') , overwrite= TRUE)
    
  }
    
   