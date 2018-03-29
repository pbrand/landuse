#################SENTINEL 2################

source('prepare_sentinel_data/source.r')

max_dim =  10980
dir_in = file.path(path, 'sentinel_2_data')
dir_out = file.path(path, 'sentinel2')
  
#translate all files
dirs = list.files(dir_in, full.names = TRUE)

for(n in 1:length(dirs)){
  dir = dirs[n]
  dir.create(file.path(dir_out, n))
files = setdiff(list.files( file.path(dir,'IMG_DATA'), full.names = TRUE,  pattern = 'jp2') , list.files( file.path(dir,'IMG_DATA'), full.names = TRUE,  pattern = 'xml') )
names =  unlist( lapply(strsplit(files, '[_.]'), function(x){ x[27]}))
                        
for(i in 1:length(files) ){
  gdal_translate(files[i], file.path(dir_out, n, paste0( names[i], '.tif')), outsize = c(max_dim, max_dim) )   
    }
    
  
}



