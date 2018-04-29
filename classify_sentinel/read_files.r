

read_files = function(data, w,h, n){
  
classes = unique(data$label)
data = lapply(classes, function(x){
  data = data[data$label == x,]
  samp = sample(c(1:nrow(data)), n)
  return(data[samp,])

  })
  data = rbindlist(data)
  order = sample(c(1:nrow(data)), nrow(data))
  data = data[order,]

  
  #read files
  files = data$file
  a = array(0, dim = c(n *length(classes), w, h, 3))
  
  
for(i in 1:length(files)){
im = readImage( files[i] )


a[i,,,] = im

}
  
  #make labels
  labels = as.matrix(data.frame( 'rownumber' = c(1:nrow(data)), 'label'= data$label))
  labels_onehot = array(0, dim = c(nrow(data), length(classes)  ))
  labels_onehot[labels] = 1
  
  
  return(list(a, labels_onehot))
}

