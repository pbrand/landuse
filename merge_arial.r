merge_arial = function(path_harddrive){
dirs = list.files( file.path(path_harddrive, 'output'), full.names = TRUE)

for(dir in dirs){
  
images =   list.files(dir, pattern = 'arial', full.names = TRUE)
  
for(im in images){
  r = raster(im)
  if( length(unique(values(r))) < 6){
    file.remove(im)
  }
}

}

}