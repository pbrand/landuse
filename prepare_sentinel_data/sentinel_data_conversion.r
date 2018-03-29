#################SENTINEL 2################

#give a directory with subdirectories in which spectral bands are present
# give directory in which these subdirectories must be copied with converted data
#give dimensions of the output rasters


translate = function(max_dim, dir_in, dir_out){
#translate all files
dirs = list.files(dir_in, full.names = TRUE)

for(n in 1:length(dirs)){
  dir = dirs[n]
  dir.create(file.path(dir_out, n))
files = setdiff(list.files( dir, full.names = TRUE,  pattern = 'jp2') , list.files( dir, full.names = TRUE,  pattern = 'xml') )
names =  unlist( lapply(strsplit(files, '[_.]'), function(x){ x[6]}))
                        
for(i in 1:length(files) ){
  gdal_translate(files[i], file.path(dir_out, n, paste0( names[i], '.tif')), outsize = c(max_dim, max_dim) )   
    }
    
  
}



}