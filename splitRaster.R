split_arial_images = function(path_harddrive, n, m, kind){



#loop over all subdirs that do allready have a directory arial_images and have a luchtfoto tif file
dirs = list.files( file.path(path_harddrive, 'output'), full.names =  TRUE)
select = c()
for(dir in dirs){
select = c( select, length(  list.files(dir, pattern = paste0(kind, 's'))) == 0)
}
dirs = dirs[select]


for( dir in dirs ){
  print(dir)

#lees de volledige luchtfoto in 
ims = list.files(dir, pattern = paste0(kind,'_') , full.names = TRUE)

for( im in ims){

r = raster(im)
#split de luchtfoto en sla het op in luchtfoto_dir
rasters = splitRaster(r , nx = n, ny = m, path =  file.path(dir, paste0(kind, 's')))

for(i in 1:length(rasters) ){
  writeRaster( rasters[[i]] ,file.path(dir, paste0(kind, 's'), paste0(i, '.tif')), overwrite = TRUE)
}
}
# 
# #transleer alles van .grd .gri naar .tiff
# files = list.files( file.path( dir, kind) , pattern = '.grd', full.names = TRUE)
# 
# for(i  in 1:length(files)){
#   #transleer het raster
#   r = raster(files[i])
#   writeRaster(r, file.path(  dir, kind , paste0('arial_image_' , i, '.tiff') ) , overwrite = TRUE)
# }
# 
# 
# #verwijder de overgebleven .grd en .gri files
 grd_files =  list.files( file.path( dir, paste0(kind, 's')) , pattern = '.grd', full.names = TRUE)
 gri_files =   list.files( file.path(dir, paste0(kind, 's')) , pattern = '.gri', full.names = TRUE)
 
 for(i in 1:length(grd_files)){
   file.remove(grd_files[i])
   file.remove(gri_files)
   
 }
 

}

}