transleer =  function(x1,x2,y1,y2, satellite, dir_output, dir_input){

##transleren, uitsnijden en resampelen met gdal_translate
w = round(   geodistance(longvar = x1, latvar = y1 , lotarget = x2 , latarget = y1  )$dist *1.609344*1000 /10)
h = round(   geodistance(longvar = x1, latvar = y1 , lotarget = x1 , latarget = y2  )$dist *1.609344*1000 /10 )

bands = c("B01", "B02","B03","B04", "B05", "B06", "B07","B08", "B09", "B10", "B11", "B12",  "B8A")





files = unlist(lapply(bands, function(band){
  setdiff( list.files(dir_input, pattern = paste0(band,'.jp2'), full.names = FALSE , recursive = TRUE) ,  list.files(dir_input, recursive = TRUE, pattern = 'xml', full.names = TRUE) )
}))

dir.create(file.path( dir_input, dir_output))

out_names = unlist(lapply(files, function(x){
  x = strsplit(x, '[/]')[[1]][5]
  x= strsplit(x, '[.]')[[1]][1]
}))

for( i in 1:length(files)){
  gdal_translate( file.path( dir_input, files[i]), file.path(dir_input, dir_output, paste0(out_names[i], '.tif')) , projwin = c( area@coords[1,1], area@coords[2,2], area@coords[2,1] , area@coords[1,2] ), outsize = c(w,h))
  
}



#mosaic the raster per band
for(band in bands){
  print(band)
  files = list.files(file.path(dir_input, dir_output), pattern = band)
  #read and crop the raster
  
  
  
  band_total =  lapply(files, function(file){
    raster(file.path(dir_input, dir_output, file) )
  })
  
  band_total =  do.call('mosaic', c(band_total, list(fun = max), list(tolerance = 0.1)) )
  writeRaster(band_total, file.path( dir_input, dir_output, paste0(band, '.tif')))
  
}

#remove junk files
files=  setdiff( list.files(file.path(dir_input, dir_output)),  paste0(bands, '.tif') )
file.remove( file.path(dir_input, dir_output, files))
}