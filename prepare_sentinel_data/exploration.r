source('prepare_sentinel_data/source.r')

dirs = list.files(file.path(path, 'sentinel2'), full.names = TRUE)

for(dir in dirs){
  files = list.files(dir, full.names = TRUE)
  r = stack(files)
}