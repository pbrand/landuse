library(raster)

path_harddrive_1 = 'E:output'
path_harddrive_2 = 'D:output'


dirs = list.files(path_harddrive_1)

for( dir in dirs){
  r = raster(file.path( path_harddrive_1, dir, 'bgt_labels.tif'))
  writeRaster(r, file.path( path_harddrive_2, dir, 'bgt_labels.tif'), overwrite = TRUE )
}