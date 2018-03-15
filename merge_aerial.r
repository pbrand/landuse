dirs = find_dirs(pattern = 'aerial_image_full', full = TRUE )

for(dir in dirs){
  print(paste('bizzy with', dir))
  
  files = list.files(dir, pattern = 'arial', full.names = TRUE)
  main_file = files[1]
  
  
  
  main_file = stack(main_file)
  
  for(file in files[-1]){
    new_file = raster(file)
    
    
    for(i in 1:3){
    values(main_file[[i]])[ values(main_file[[4]]) == 0] =   values(new_file[[i]])[ values(main_file[[4]]) == 0]
    }
  }  
writeRaster(main_file, file.path(dir, 'aerial_image_full.tif'), options= 'INTERLEAVE=BAND' )
  file.remove(files)

}


