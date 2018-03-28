x = c()
y = c()
for(dir in dirs){
  
  bgt = readRDS(file.path(dir, 'BGT.rds'))
  x = c(x, as.character(bgt$category))
  y = c(y, bgt$number)
}


unique(as.character(x))
unique(y)[order(unique(y))]

for(dir in dirs){
  
  file.rename(file.path(dir, 'bgt_labels.tif'), file.path(dir, 'bgt_labels_oud.tif'))
}