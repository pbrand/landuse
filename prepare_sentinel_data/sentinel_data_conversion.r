#################SENTINEL 2################

#give a directory with subdirectories in which spectral bands are present
# give directory in which these subdirectories must be copied with converted data
#give dimensions of the output rasters


translate = function(max_dim, name){
  dir_in = file.path(path, name_in)
  dir_out =   file.path(path,  name_out)
  dir.create(dir_out)
  
  
files = setdiff(list.files( dir_in ,   pattern = 'jp2') ,  union(list.files( dir_in,  pattern = 'xml') ,list.files( dir_in,   pattern = 'TCI')  ) )
names =  unlist( lapply(strsplit(files, '[_.]'), function(x){ x[3]}))
                        
for(i in 1:length(files) ){
  gdal_translate( file.path(dir_in, files[i]) , file.path(dir_out , paste0( names[i], '.tif')), outsize = c(max_dim, max_dim) )   
    }
    
  




}