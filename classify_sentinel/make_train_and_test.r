files = list.files(file.path(path, 'train'), full.names = TRUE, recursive = TRUE)




class = unlist(lapply(files, function(x){
  strsplit(x,'[/]')[[1]][ 9]
}))

files = unlist(lapply(files, function(x){
  strsplit(x,'[/]')[[1]][ 10]
}))

files = file.path(class, files)

data = data.frame('file' = files, 'class' = class)

data$label = as.numeric(as.factor(data$class))



saveRDS(data, file.path(path,'data.rds') )
