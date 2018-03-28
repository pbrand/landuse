source('Sentinel_models/packages.r')

files = list.files( file.path(path, 'rgb'), recursive = TRUE, full.names= FALSE)

classes= unlist( lapply(strsplit(files, '[/_]'), function(x){
  x[[2]]
  
}))
labels = as.numeric( as.factor(classes))

data = data.frame('file' = files, 'class'= classes, 'label' = labels)

data$file = file.path('rgb', data$file)

saveRDS(data, file.path(path,'data_rgb.rds'))