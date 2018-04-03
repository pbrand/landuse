#################SENTINEL 2################

dir_output
area


  #calculate gdistance to get required resolution pixels
dimx = 10*gDistance(extent(area)[1], extent(area)[2] )
dimy = 

#files = list.files( dir,   pattern = 'jp2', recursive = TRUE, full.names = TRUE)

#make dirs for all bands
#make dataframe of bands and filenames
#translate all bands to the special band directory

v =  as.vector(extent(area))[c(1,4,2,3)]

gdal_translate( files[i] , 'test.tif', outsize = c(dim, dim  ), projwin = v)


