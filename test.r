library(jpeg)
library(raster)

dir_out = '/home/daniel/R/landuse/request' #where to write the downloads


#find all tiff files that have not yet ben translated to jpeg
files =  setdiff( list.files(dir_out, recursive = TRUE, include.dirs = FALSE, full.names = TRUE, pattern = '.tiff'), list.files(dir_out, recursive = TRUE, include.dirs = FALSE, full.names = TRUE, pattern = 'xml') )
target_files = gsub(files, patter = 'tiff', replacement = 'jpg')

#if there are tiff files found translate them into jpeg, save the jpegs in the same folder using the same name


  for( i in 1:length(files)){
    print(files[i])
    im = raster::stack(files[i], bands = c(4,3,2) )
    im = raster::as.array(im)
    
  # im =  sqrt(sqrt(im*0.4) )
   im = sqrt(im) 
    writeJPEG(im, target_files[i])
  }


