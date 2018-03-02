arial_images = function(ecw_path){
ecw_files = list.files( paste0(path_harddrive, '/ECW'), pattern = '.ecw')


gdal_setInstallation(ignore.full_scan = FALSE)
  
  
  
  #creeer een vector met de rd coordinaten van de hoeken van de ecw bestanden
  lower_left_x <- vector()
  lower_left_y <- vector()
  upper_right_x <- vector()
  upper_right_y <- vector()
  
  for(i in 1:length(ecw_files)){
    
    info <- gdalinfo( file.path(ecw_path, ecw_files[i]), raw_output = FALSE)   
    lower_left_x[i] = info$bbox[[1,1]]
    lower_left_y[i] = info$bbox[[2,1]]
    upper_right_x[i] = info$bbox[[1,2]]
    upper_right_y[i] = info$bbox[[2,2]]
  }
  
  ecws <- data.frame(file.path(ecw_path, ecw_files), lower_left_x, lower_left_y, upper_right_x, upper_right_y)
  
  
  saveRDS(ecws, paste0(ecw_path,'/ecw_extent.rds'))
  
  
  
  #get all hoogtebestanden en cut out from ecw and place in subdir
  
  tif_files = list.files( paste0(path_harddrive, '/db/hoogtebestand'))
  for(file in tif_files){
    r = raster( paste0(path_harddrive, '/output/', file, '/', file))
      for(j in 1:nrow(ecws)){
        
        #make an extent object from the row
        #check if the altitude file falls within the range of the ECW file
        if(!is.null(try(intersect( extent(r),  c(ecws$lower_left_x[j], ecws$upper_right_x[j], ecws$lower_left_y[j], ecws$upper_right_y[j] ) )) )){
        v =  as.vector(extent(r))[c(1,4,2,3)]
        
        
        suppressWarnings( gdal_translate(ecws$file.path.ecw_path..ecw_files.[j] , outsize =  dim(r)[1:2], paste0(path_harddrive, '/output/', file ,'/luchtfoto_', j, '.gtiff'), projwin = v ) )
        }
      
      }
    
  }
  
  
  
  
 
 #merge the remaining rasters
 
 #dirs =  list.files(tif_path)
 
 #for( dir in dirs){
  # print(dir)
   
  # fotos = list.files(paste0(subdir, '/', dir), pattern = 'luchtfoto', full.names = TRUE)
   
 #}
 
}
