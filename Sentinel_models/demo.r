#a linear stack of layers
source('Sentinel_models/packages.r')

names = c('anual_crop', 'forrest', 'herbacious', 'highway', 'industrial', 'pasture', 'permanent_crop', 'Residential', 'river', 'lake' )

path = 'Sentinel_models/db/test'

#data loading
files = list.files(file.path(path,'unsorted'), full.names= TRUE)
######Parameters
clas = 9 #number of classes
h = as.integer(64) #heigth image
w = as.integer(64) #width image
channels = 3L
format = 'jpg'
#####

for(i in 1:10){
  dir.create( file.path(path, names[i]) )
}
model = load_model_hdf5('Sentinel_models/db/models/model_rgb')


for(file in files){
  im = readJPEG(file)
  im = array(im , dim = c(1, w,h,channels))
  
  n = as.numeric(model$predict_classes(im)[1]) +1
  file.copy(from = file, to = file.path(path, names[ n ] )  )
  
  print(file)
  #move file to dir k
}

#dirs = file.path(path, c(0:clas))
#unlink(dirs, recursive = TRUE)
#files = files[sample(c(1:length(files)), length(files) )]

# for(i in 1:length(files)){
#   file.rename(files[i], file.path(path, paste0(i, '.jpg')))
# }



