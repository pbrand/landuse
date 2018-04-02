source('prepare_sentinel_data/source.r')






name_in  = 'sentinel2_input/IMG_DATA'
name_out  = 'sentinel2/IMG_DATA'
max_dim = 10980

#translate
translate(name,  max_dim = max_dim )









# # CROP

bands = list.files( file.path(path, name) , pattern = 'tif', full.names = TRUE)
names = unlist(lapply( strsplit(bands, '[/.]') , function(x){x[[9]]}  ))

new = c( 499980, 554880 ,  4990200 , 5045100 )

for(i in 1:length(bands)){
  band = bands[i]
  r = raster(band)
  r = crop(r, new )
  writeRaster(r, paste0(names[i], '.tif'))
}

#####merge one file

name = 'IMG_DATA'
name = 'test'
window_dim = 64
num_bands = 13





bands = list.files( file.path(path, name) , pattern = 'tif', full.names = TRUE)
bands = stack(bands)
writeRaster(bands, 'test.tif')

