read_batch = function(files, format, channels){
  
  
  batch = array(0, dim = c(length(files), w, h, channels))
  for(i  in 1:length(files)){
    file = files[i]
    if(format == 'jpg'){
    im = readJPEG(file.path(path, file) )
    }
    if(format == 'tif'){
      im = readTIFF(file.path(path, file) )
    }
    batch[i,,,] = im[,,1:channels]
  }
  return(batch)
}