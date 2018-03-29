merge_rasters = function(dir_in){

dirs = list.files(file.path(path, dir_in), full.names= TRUE)

bands = setdiff( list.files(dirs[1]) , list.files(dirs[1], pattern = 'TCI.tif') )


for(band in bands){
  all_bands = file.path(dirs, band)
  total = raster(all_bands[1])
  
  for(i in 2:length(all_bands)){
    print(i)
    new = raster(all_bands[i])
    total = mosaic(total, new, fun = max)
  }
  print('writing raster')
  writeRaster(total, file.path(path, dir_in, band ))
}


}