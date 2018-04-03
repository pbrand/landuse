source('classify_sentinel/source.r')

name = 'IMG_DATA'
name = 'test'
window_dim = 64
num_bands = 13

bands = readTIFF(file.path(path, 'test.tif'))
 model = load_model_hdf5(file.path(path,'model'))


 N_x = floor(dim(bands)[1]/ window_dim)
  N_y = floor(dim(bands)[2]/ window_dim)
 
  
  fill_temp = rep(-1, N_x*N_y)
  prediction = data.frame( 'x' = fill_temp , 'y' = fill_temp , 'label' = fill_temp  )
  
  
  for(n_x in 1:N_x){
    for(n_y in 1:N_y){
      
      
    }
    
  }
  
# 
# bands = list.files( file.path(path, name) , pattern = 'tif', full.names = TRUE)
# bands = c(bands[1:8], bands[13] , bands[9:12])
# bands = stack(bands)
# writeRaster(bands, 'test.tif')




