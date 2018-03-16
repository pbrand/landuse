dirs = find_dirs(pattern = 'aerial_image_full', full = TRUE )

for(dir in dirs){
  print(paste('bizzy with', dir))
  
  #remove all transperant images
  files = list.files(dir, pattern = 'arial', full.names = TRUE)
  for(file in files){
    r = stack(file)
    if(dim(r)[3]== 1){
      print(file)
      file.remove(file)
    }
  }
  
 
  files = list.files(dir, pattern = 'arial', full.names = TRUE)
  main_file = files[1]
  
  #in case there is more than 1 file we must merge
  if(length(files)>1){
  r = stack(main_file)
  
  #split the image in multiple bands
  for(i in 1:3){
    print(paste('bizzy with splitting band', i))
    writeRaster(r[[i]], file.path(dir, paste0('aerial_full_',i, '.tif')), overwrite = TRUE)
  }
  rm(r)
  
  
  #loop over all bands
  for(i in 1:3){
    print(paste('bizzy with updating band', i))
    #loop over all files
    for(file in files[-1]){
      r = raster(file.path(dir, paste0('aerial_full_',i, '.tif')))
      new_r = raster(file, band = i)
      
      values(r)[ values(r) == 0 | values(r)>250] =   values(new_r)[ values(r) == 0 | values(r)>250]
      
      writeRaster(r, file.path(dir, paste0('aerial_full_',i, '.tif')), overwrite = TRUE)
    }
    
  }
  
  
  #file.remove(files)
  
  #merge the layers
  rm(r)
  rm(new_r)
  files =  list.files(dir, pattern = 'aerial_full' ,full.names = TRUE)
  r1 = raster(files[1]) 
  r2 = raster(files[2]) 
  r3 = raster(files[3]) 
  
  writeRaster(  stack(r1,r2,r3)  , file.path(dir, 'aerial_image_full.tif'), options= 'INTERLEAVE=BAND' )
 file.remove(files)
  }else{
    print('renamed')
    file.rename(main_file, file.path(dir, 'aerial_image_full.tif'))
  }
}

