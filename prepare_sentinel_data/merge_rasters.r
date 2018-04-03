merge_rasters = function(dir_in, dir_out){

dirs = list.files(dir_in, full.names = TRUE)

bands = setdiff( list.files(dirs[2]) , list.files(dirs[1], pattern = 'TCI.tif') )


for(band in bands){
  print(band)
  all_bands = file.path(dirs, band)
  all_bands = lapply(all_bands, function(x){ raster(x)  })
  

  total = do.call(mosaic, c(all_bands,fun = max)  )
  writeRaster(total, file.path(dir_out, band ))
}

file.remove( list.files(dir_out, pattern = 'tif.aux.xml', full.names = TRUE))

}


