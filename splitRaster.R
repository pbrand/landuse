split_arial_images = function(path_harddrive, n, m, kind){



#loop over all subdirs that do allready have a directory arial_images and have a luchtfoto tif file
dirs = list.files( file.path(path_harddrive, 'output'), full.names =  TRUE)
select = c()
for(dir in dirs){
select = c( select, length(  list.files(dir, pattern = 'arial_images')) == 0)
}
dirs = dirs[select]


for( dir in dirs ){

#lees de volledige luchtfoto in 
im = list.files(dir, pattern = kind , full.names = TRUE)[1]
r = raster(im)
#split de luchtfoto en sla het op in luchtfoto_dir
splitRaster(r , nx = n, ny = m, path =  file.path(dir, kind))


#transleer alles van .grd .gri naar .tiff
files = list.files( file.path( dir, kind) , pattern = '.grd', full.names = TRUE)

for(i  in 1:length(files)){
  #transleer het raster
  r = raster(files[i])
  writeRaster(r, file.path(  dir, kind , paste0('arial_image_' , i, '.tiff') ) , overwrite = TRUE)
}


#verwijder de overgebleven .grd en .gri files
grd_files =  list.files( file.path( dir, kind) , pattern = '.grd', full.names = TRUE)
gri_files =   list.files( file.path(dir, kind) , pattern = '.gri', full.names = TRUE)

for(i in 1:length(grd_files)){
  file.remove(grd_files[i])
  file.remove(gri_files)
  
}


}

}