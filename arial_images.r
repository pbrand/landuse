arial_images = function(path_harddrive){

ecw_files = list.files( file.path(path_harddrive, 'ECW'), pattern = '.ecw', full.names = TRUE)


gdal_setInstallation(ignore.full_scan = FALSE)

print("Check 1...")
  
  
  
  #creeer een vector met de rd coordinaten van de hoeken van de ecw bestanden
  lower_left_x <- vector()
  lower_left_y <- vector()
  upper_right_x <- vector()
  upper_right_y <- vector()
  
  for(i in 1:length(ecw_files)){
    

    info <- gdalinfo(  ecw_files[i], raw_output = FALSE)   

    
    lower_left_x[i] = info$bbox[[1,1]]
    lower_left_y[i] = info$bbox[[2,1]]
    upper_right_x[i] = info$bbox[[1,2]]
    upper_right_y[i] = info$bbox[[2,2]]
  }
  
  ecws <- data.frame( ecw_files, lower_left_x, lower_left_y, upper_right_x, upper_right_y)
  
  
  saveRDS(ecws, file.path(path_harddrive, 'ECW','ecw_extent.rds'))
  
  print("Check 2...")
  
  dirs = find_dirs(pattern = 'arial_image', full = FALSE)
  
  
  print('start cutting out images')
  
  #loop over all directories and read in the hoogte bestand
  for(dir in dirs){
    print(paste('bezig met', dir))
    r = raster( file.path(path_harddrive, 'output', dir, dir))
    #loop over all ecw files
      for(j in 1:nrow(ecws)){

        #make an extent object from the row
        #check if the altitude file falls within the range of the ECW file
        if(!is.null(try(intersect( extent(r),  c(ecws$lower_left_x[j], ecws$upper_right_x[j], ecws$lower_left_y[j], ecws$upper_right_y[j] ) )) )){
          print(j)
        v =  as.vector(extent(r))[c(1,4,2,3)]
        
        suppressWarnings( gdal_translate(ecws$ecw_files[j] , outsize =  dim(r)[2:1], file.path(path_harddrive, 'output', dir ,paste0('arial_image_', j, '.tiff') ), projwin = v ) )
        
        #r = raster(file.path(path_harddrive, 'output', dir ,paste0('arial_image_', j, '.tiff')) )
        #r = crop(r, c(ecws$lower_left_x[j], ecws$upper_right_x[j], ecws$lower_left_y[j], ecws$upper_right_y[j] )  )
        
        }
      
      }
    
  }
  
  print("Check 3...")
  
  
 
 #merge the remaining rasters
 
 #dirs =  list.files(tif_path)
 
 #for( dir in dirs){
  # print(dir)
   
  # fotos = list.files(paste0(subdir, '/', dir), pattern = 'luchtfoto', full.names = TRUE)
   
 #}
 
}
