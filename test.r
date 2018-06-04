library(raster)

files = list.files('requests/4', full.names = TRUE)

r = raster(files[1])

plot(r)