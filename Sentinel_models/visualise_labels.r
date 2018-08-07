setwd('Sentinel_models')

library(EBImage)

path_labels = 'db/labels'
path_images = 'db/beelden'


labels = list.files(path_labels)

i=1

for(i in 1:length(labels)){
  label_name = labels[i]
  
  image_name = gsub(label_name, pattern = '.txt', replacement = '.jpg')
  file.copy( file.path(path_images, image_name), file.path('db/visualise', image_name))
  
  label = read.table(file.path(path_labels, label_name), sep = ',')
  label = as.matrix(label)
  label = as.Image(label)  
  label = rotate(label, angle = 90)
  label = flop(label)
  #rotate 90 degrees to the right
  #flip over the y axis
  
    writeImage(label, file.path('db/visualise', paste0(label_name, '_label.jpg')))
}