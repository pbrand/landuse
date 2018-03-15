
dirs = find_dirs(pattern = 'CBS_labels.tif', full = TRUE )

for(dir in dirs){
file.rename( from = file.path(dir, 'CBS _labels.tif'), to = file.path(dir, 'CBS_labels.tif')  )
  
}





dirs = find_dirs(pattern = 'bgt_labels.tif' , full = TRUE)

for(dir in dirs){
  file.rename( from = file.path(dir, 'bgt _labels.tif'), to = file.path(dir, 'bgt_labels.tif')  )
  
}