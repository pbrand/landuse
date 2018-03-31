source('classify_sentinel/source.r')

name = 'IMG_DATA'
name = 'test'
window_dim = 64
num_bands = 13





bands = list.files( file.path(path, name) , pattern = 'tif', full.names = TRUE)
bands = c(bands[1:8], bands[13] , bands[9:12])
bands = stack(bands)
writeRaster(bands, 'test.tif')


bands = readTIFF(file.path(path, 'test.tif'))

