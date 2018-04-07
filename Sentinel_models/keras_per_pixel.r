#a linear stack of layers
source('Sentinel_models/packages.r')



#data loading
files = list.files(dir, full.names = FALSE)
data = data.frame('images' = file.path(dir_images, files), 'labels' =  file.path(dir_labels, files))
split = sample(x =  c(1:nrow(data)), size = round(0.8*nrow(data)) )
train = data[split,]
test = data[-split,]

######Parameters
clas = 
h = as.integer(64) #heigth image
w = as.integer(64) #width image
channels = 16L
max_pred = 0.8
format = 'tif'
#####

model<-keras_model_sequential()

#configuring the Model
model.add(Layer(input_shape=(3, 360, 480)))

# encoding layers

# block 1
model.add(Convolution2D(64, (3, 3), activation='relu', padding='same', name='block1_conv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(64, (3, 3), activation='relu', padding='same', name='block1_conv2', data_format='channels_first'))
model.add(BatchNormalization())

model.add(MaxPooling2D((2, 2), name='block1_pool'))
# print(model.name, model.output_shape)

# block 2
model.add(Convolution2D(128, (3, 3), activation='relu', padding='same', name='block2_conv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(128, (3, 3), activation='relu', padding='same', name='block2_conv2', data_format='channels_first'))
model.add(BatchNormalization())

model.add(MaxPooling2D((2, 2), name='block2_pool'))
# print(model.name, model.output_shape)

# block 3
model.add(Convolution2D(256, (3, 3), activation='relu', padding='same', name='block3_conv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(256, (3, 3), activation='relu', padding='same', name='block3_conv2', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(256, (3, 3), activation='relu', padding='same', name='block3_conv3', data_format='channels_first'))
model.add(BatchNormalization())

model.add(MaxPooling2D((2, 2), name='block3_pool'))
# print(model.name, model.output_shape)

# block 4
model.add(Convolution2D(512, (3, 3), activation='relu', padding='same', name='block4_conv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(512, (3, 3), activation='relu', padding='same', name='block4_conv2', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(512, (3, 3), activation='relu', padding='same', name='block4_conv3', data_format='channels_first'))
model.add(BatchNormalization())

# model.add(MaxPooling2D((2, 2), name='block4_pool'))
# print(model.name, model.output_shape)

# block 5
model.add(Convolution2D(512, (3, 3), activation='relu', padding='same', name='block5_conv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(512, (3, 3), activation='relu', padding='same', name='block5_conv2', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(512, (3, 3), activation='relu', padding='same', name='block5_conv3', data_format='channels_first'))
model.add(BatchNormalization())

# model.add(MaxPooling2D((2, 2), name='block5_pool'))

# print("After encoding: model shape = ", model.output_shape)

# decoding layers

# block 6
# model.add(UpSampling2D((2, 2), name='block6_up', data_format='channels_first'))

model.add(Convolution2D(512, (3, 3), padding='same', name='block6_deconv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(512, (3, 3), padding='same', name='block6_deconv2', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(512, (3, 3), padding='same', name='block6_deconv3', data_format='channels_first'))
model.add(BatchNormalization())
# print(model.name, model.output_shape)

# block 7
# model.add(UpSampling2D((2, 2), name='block6_up'))

model.add(Convolution2D(512, (3, 3), padding='same', name='block7_deconv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(512, (3, 3), padding='same', name='block7_deconv2', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(512, (3, 3), padding='same', name='block7_deconv3', data_format='channels_first'))
model.add(BatchNormalization())
# print(model.name, model.output_shape)

# block 8
model.add(UpSampling2D((2, 2), name='block8_up'))

model.add(Convolution2D(256, (3, 3), padding='same', name='block8_deconv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(256, (3, 3), padding='same', name='block8_deconv2', data_format='channels_first'))
model.add(BatchNormalization())
# print(model.name, model.output_shape)

# block 9
model.add(UpSampling2D((2, 2), name='block9_up'))

model.add(Convolution2D(128, (3, 3), padding='same', name='block9_deconv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(128, (3, 3), padding='same', name='block9_deconv2', data_format='channels_first'))
model.add(BatchNormalization())
# print(model.name, model.output_shape)

# block 10
model.add(UpSampling2D((2, 2), name='block10_up'))

model.add(Convolution2D(64, (3, 3), padding='same', name='block10_deconv1', data_format='channels_first'))
model.add(BatchNormalization())
model.add(Convolution2D(64, (3, 3), padding='same', name='block10_deconv2', data_format='channels_first'))
model.add(BatchNormalization())

# print("After decoding: model shape = ", model.output_shape)

# final

model.add(Convolution2D(num_classes, (1, 1), padding='valid', name='final', data_format='channels_first'))
# print(model.name, model.output_shape)

model.add(Reshape((num_classes, data_shape), input_shape=(num_classes, 360, 480)))
model.add(Permute((2, 1)))
model.add(Activation('softmax'))



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


