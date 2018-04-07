source('classify_sentinel/source.r')

name = 'IMG_DATA'
name = 'test'
window_dim = 64
num_bands = 3

bands = readTIFF('test.tif')
bands = bands[,,4:2]
bands = bands /max(bands)

model = load_model_hdf5(file.path(path,'model_rgb'))
 ##################################
 
 N_x = floor(dim(bands)[2]/ window_dim) -1
 N_y = floor(dim(bands)[1]/ window_dim) -1
 
  
  combinations = expand.grid(0:N_x, 0:N_y)
  colnames(combinations) = c('x', 'y')

  prediction = matrix(-1, ncol = N_x, nrow = N_y)
  
  sub_im = array(-1, dim = c(1, window_dim, window_dim, num_bands))
   
  for(i in 1:nrow(combinations)){
  print(i/nrow(combinations))
    
  sub_im[1,,,] =   bands[ (combinations$y[i] * window_dim +1 ) :((combinations$y[i]+1) * window_dim),  (combinations$x[i] * window_dim +1 ) :((combinations$x[i]+1) * window_dim), ]    
  
  
  prediction[combinations$y[i], combinations$x[i] ] =  model$predict_classes(sub_im)
  
  }
  
  rm(bands)
  saveRDS(prediction, file.path(path,'prediction_rgb.rds'))
  
  
  prediction = readRDS(file.path(path,'prediction_rgb.rds'))
  image(prediction)
# 
# bands = list.files( file.path(path, name) , pattern = 'tif', full.names = TRUE)
# bands = c(bands[1:8], bands[13] , bands[9:12])
# bands = stack(bands)
# writeRaster(bands, 'test.tif')




