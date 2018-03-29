source('prepare_sentinel_data/source.r')

dirs = list.files(file.path(path, 'sentinel2'), full.names = TRUE)

for(dir in dirs){
  files = list.files(dir, full.names = TRUE)
  r = stack(files)
}

files = list.files(dir, full.names = TRUE)
r = raster(files[3])


splitRaster(r, nx = 2, ny = 2, path = path)