dir = "/home/daniel/R/landuse/db/bgt_noord holland"

files = list.files(dir, full.names = TRUE)

for(i in 1:length(files)){
  print(i)
  file = files[i]
  print(file)
  dir.create(file.path(file, 'waterdeel'))
  
  res <- try(readOGR( file.path(file,'bgt_waterdeel.gml')) ,silent = TRUE)

  
  if(! class(res) == "try-error"){
shape = readOGR( file.path(file,'bgt_waterdeel.gml'))
writeOGR(shape, file.path(file, 'waterdeel'), layer = 'waterdeel' , driver ="ESRI Shapefile" )
}
}


for(i in 1:length(files)){
  print(i)
  file = files[i]
  dir.create(file.path(file, 'wegdeel'))
  
  res <- try(readOGR( file.path(file,'bgt_wegdeel.gml')) ,silent = TRUE)
  class(res) = "try-error"
  
  if(! class(res) == "try-error"){

  shape = readOGR( file.path(file,'bgt_wegdeel.gml'))
  writeOGR(shape, file.path(file, 'wegdeel'), layer = 'wegdeel' , driver ="ESRI Shapefile" )
  
  }
}