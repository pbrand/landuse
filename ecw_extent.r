

ecw_path = '/media/daniel/Elements/ECW'

ecw_files = list.files(ecw_path)


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
  
  ecws <- data.frame(file.path(ecw_path, ecw_filenames), lower_left_x, lower_left_y, upper_right_x, upper_right_y)
  
  
  saveRDS(ecws, paste0(ecw_path,'/ecw_extent.rds')