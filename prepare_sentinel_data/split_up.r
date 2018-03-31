source('prepare_sentinel_data/source.r')

bands = list.files(file.path(path, name_out), full.names = FALSE)

for(band in bands){
  dir.create(file.path(path, name_out, strsplit(band, '[.]')[[1]][1]))
  splitRaster(raster( file.path(path, name_out, band)   )  , nx = 2, ny = 2, path =  file.path(path, name_out, strsplit(band, '[.]')[[1]][1]) )
}




