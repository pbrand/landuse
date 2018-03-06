make_labels = function(path_harddrive, kind){

#select files that do not hava bgt.rds in them
dirs = list.files(file.path(path_harddrive, 'output'), full.names = TRUE)
select = c()
for(dir in dirs){
  select = c(select, length(  list.files( dir , pattern = paste(kind , 'labels') ) ) ==0)
}
dirs = dirs[select]



for(dir in dirs){
  print(paste('bizzy with', dir))
  #read shape of kind 'kind'
 shape = readRDS( file.path(dir, kind, '.rds'))  

 #make dir
 dir.create( file.path(dir, paste(kind, 'labels')))
 
 #loop over alle sub_images heen  
  ims = list.files( file.path(dir, paste(kind, 'labels')))
  
  for(im in ims){
    r = raster( file.path(dir, 'arial_image' ,im))
    label = rasterize(im, shape, field = shape$category)
    writeRaster(label, file.path(dir, paste(kind, 'label', im) ))
    
  }
  
  
}
}