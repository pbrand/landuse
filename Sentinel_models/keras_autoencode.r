#a linear stack of layers
source('Sentinel_models/packages.r')



#data loading
files = list.files( file.path(path, 'rgb'), full.names = TRUE , recursive = TRUE, include.dirs = FALSE )
files = unlist( lapply(files, function(x){
  return(strsplit(x, '/db/')[[1]][2])
}))
split = sample(x =  c(1:length(files)), size = round(0.8*length(files)) )
train = files[split]
test = files[-split]



######Parameters
h = as.integer(64) #heigth image
w = as.integer(64) #width image
channels = 3L
max_pred = 0.8
format = 'jpg'
#####

model<-keras_model_sequential()



# encoding layers

model %>%  
  layer_conv_2d(filter=32, kernel_size=c(5,5),padding="same",    input_shape=c(64,64,channels) ) %>%  
  layer_activation("relu") %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(4,4), padding = 'same')  %>%  
  layer_activation("relu") %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 , kernel_size=c(3,3),padding="same") %>%
  layer_activation("relu") %>%  
  layer_conv_2d_transpose(  filters = 64 , kernel_size=c(3,3) ,strides = c(2L, 2L), padding="same") %>%
  layer_activation("relu") %>%  
  layer_conv_2d_transpose(  filters = 3 , kernel_size=c(3,3) ,strides = c(2L, 2L), padding="same") %>%
  
  layer_activation("softmax") 


opt<-optimizer_adam( lr= 0.0001 , decay = 1e-6 )

model %>%
  compile(loss="categorical_crossentropy", optimizer=opt, metrics = "accuracy")

#model = load_model_hdf5(file.path(path,'models/model_all2'))



#Train the network
for (i in 1:2000000) {
  
  samp = sample( c(1:length(train)), 2)
  
  #lees 50 random plaatjes in
  batch_files= read_batch(files = as.character( train[samp] ), format = format, channels = channels)
  
  
  model$fit( x= batch_files, y= batch_files, batch_size = dim(batch_files)[1], epochs = 1L  )
  
  
  if(i %% 100 == 0){
    
    samp = sample( c(1:length(test)), 30)
    
    #lees 50 random plaatjes in
    batch_files= read_batch(files = as.character( test[samp] ), format = format, channels = channels)
    
    
    pred = model$evaluate( x= batch_files, y= batch_files , steps = 1L )
    
    
    print( paste('test loss is', pred[[1]]))
    
  }
  
}



#model$save( file.path(path,'models/model_rgb' ))