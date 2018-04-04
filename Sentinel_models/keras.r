#a linear stack of layers
source('Sentinel_models/packages.r')



#data loading
data = readRDS( file.path(path,'data_rgb.rds' )) 
#data = data[data$label %in% c(1,2,8),]
data$label = as.numeric(as.factor(data$label))
split = sample(x =  c(1:nrow(data)), size = round(0.8*nrow(data)) )
train = data[split,]
test = data[-split,]

######Parameters
clas = as.integer(length(unique(data$label)))#number of classes
h = as.integer(64) #heigth image
w = as.integer(64) #width image
channels = 3L
max_pred = 0.8
format = 'jpg'
#####

model<-keras_model_sequential()

#configuring the Model

model %>%  
  layer_conv_2d(filter=32, kernel_size=c(5,5),padding="same",    input_shape=c(64,64,channels) ) %>%  
  layer_activation("relu") %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(4,4))  %>%  layer_activation("relu") %>%
  layer_activation("relu") %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_dropout(0.25) %>%
  layer_conv_2d(filter=64 , kernel_size=c(3,3),padding="same") %>%
  layer_activation("relu") %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%
  layer_conv_2d(filter=128,kernel_size=c(3,3) ) %>%
  layer_activation("relu") %>%    
  layer_dropout(0.25) %>%
  layer_flatten() %>%  
  layer_dense(400) %>%  
  layer_activation("relu") %>%
  layer_dropout(0.5) %>%  
  layer_dense(clas) %>%  
  layer_activation("softmax") 

opt<-optimizer_adam( lr= 0.0001 , decay = 1e-6 )

model %>%
  compile(loss="categorical_crossentropy", optimizer=opt, metrics = "accuracy")

#model = load_model_hdf5(file.path(path,'models/model_all2'))



#Train the network
for (i in 1:2000000) {
  
  #lees 50 random plaatjes in
  data_class = select_files(data = train, num = 2)
  batch_labels = onehot(data_class[[2]], clas = clas)
  batch_files= data_class[[1]]

  model$fit( x= batch_files, y= batch_labels, batch_size = dim(batch_files)[1], epochs = 1L  )

  
  if(i %% 100 == 0){
    data_class = select_files(data = test, num = 50)
    batch_labels = onehot(data_class[[2]], clas = clas)
    batch_files= data_class[[1]]
    
    pred = model$evaluate( x= batch_files, y= batch_labels , steps = 1L )
  print( paste('Accuracy is', pred[[2]]))
  
  if(pred[[2]]> max_pred){
  #save model
  model$save( file.path(path,'models/model_rgb' ))
    saveRDS(max_pred,file.path(path, 'models/max_pred.rds'))
  max_pred = pred[[2]]
    }
  
   }
  
}
  
  
  