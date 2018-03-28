select_files = function(num, data){
 
  labels = unique(data$label)
  batch = list()
  
  for(i in 1:length(labels)){
    data_class = data[data$label == labels[i],]
    samp = sample( x=  c(1: nrow(data_class)) , size = num )
    batch[[i]] = data_class[samp,]
  }
  batch = rbindlist(batch)
  
  
  batch_labels = as.vector(batch$label)
  batch_files= read_batch(files = as.character(batch$file))
  
  return(list(batch_files, batch_labels))
  
}