dirs = find_dirs(pattern = 'aerial_image_full', full = TRUE )

for(dir in dirs){
  print(paste('bizzy with', dir))
  
  files = list.files(dir, pattern = 'arial', full.names = TRUE)
  main_file = files[1]
  
  
  
  main_file = raster(main_file)
  for(file in files[-1]){
    new_file = raster(file)
    
    values(main_file)[ values(main_file) == 0 ] = new_file[ values(main_file) == 0   ]
    
  }  
  writeRaster(main_file, file.path(dir, 'aerial_image_full.tif') )
  file.remove(files)

}


