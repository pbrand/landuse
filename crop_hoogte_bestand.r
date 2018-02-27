dir.create( paste0(subdir, '/hoogte bestand region'))

bgt = readRDS( paste0(subdir, '/bgt_region.rds') )
extent = extent(bgt)
rm(bgt)

files = list.files('db/hoogte bestand', include.dirs  = FALSE)


for(file in files){
  print(file)
  r = raster(paste0('db/hoogte bestand/', file))
  if(!is.null(intersect(extent(r), extent))){
  r = crop(r, extent)
 writeRaster(r, paste0(subdir, '/hoogte bestand region/', file), overwrite = TRUE) 
 }
}
