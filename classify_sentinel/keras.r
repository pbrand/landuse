library(raster)
library(tiff)
library(tensorflow)
library(keras)
library(EBImage)
path = "/home/daniel/R/landuse/classify_sentinel/db"


source('classify_sentinel/read_files.r')

train = readRDS(file.path(path ,'data.rds'))
train$file = as.character( file.path(path, 'train', train$file))



w = 64
h = 64


#source('model.r')model<-keras_model_sequential()

model<-keras_model_sequential()

model %>%  
  layer_conv_2d(filter=32, kernel_size=c(4,4),padding="same",    input_shape=c(w,h,3) , activation = 'relu') %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(4,4), padding = 'same', activation = 'relu')  %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_conv_2d(filter=64 , kernel_size=c(3,3),padding="same", activation = 'relu') %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_conv_2d(  filters = 64 , kernel_size=c(3,3) , padding="same", activation = 'relu') %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=128 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_conv_2d(  filters = 128 , kernel_size=c(3,3) , padding="same", activation = 'relu') %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=128 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_conv_2d(  filters = 128 , kernel_size=c(3,3) , padding="same", activation = 'relu') %>%
  layer_flatten() %>%
  layer_dropout(0.5) %>%
  layer_dense(units = 1024L , activation = 'relu') %>%
  layer_dense(units = 1024L , activation = 'relu') %>%
  layer_dense(units = 3 , activation = 'softmax')



opt<-optimizer_adam( lr= 0.0001 , decay = 0 )

compile(model, loss="categorical_crossentropy", optimizer=opt, metrics = "accuracy")

#model = keras::load_model_hdf5(file.path(path,'model'))







#Train the network
for (i in 1:2000000) {
  
  
  files = read_files(data = train, w, h, n = 16)
  print(i)
  model$fit( x= files[[1]], y= files[[2]], batch_size = dim(files)[1], epochs = 1L  )
  
 
  
  
}

model$save(file.path(path, 'model'))
