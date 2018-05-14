library(tiff)
library(jpeg)
library(EBImage)
library(feather)
library(raster)

dirs = list.files('/media/daniel/6DA3F120567E843D/Luchtfotos/output', full.names = TRUE) 

for(dir in dirs){
  
  print(dir)
  files = union( list.files(dir, full.names = TRUE, pattern = 'CBS_labels') , list.files(dir, full.names = TRUE, pattern = 'CBS _labels') )
  r = readTIFF(files[1])
  
  
  r[r==10] = 1
  r[r==11] = 2
  r[r==12] = 3
  r[r==20] = 4
  r[r==21] = 5
  r[r==22] = 5
  r[r==23] = 5
  r[r==24] = 6
  r[r==30] = 7
  r[r==31] = 8
  r[r==32] = 9
  r[r==33] = 10
  r[r==34] = 11
  r[r==35] = 12
  r[r==40] = 13
  r[r==41] = 14
  r[r==42] = 15
  r[r==43] = 16
  r[r==44] = 17
  r[r==50] = 18
  r[r==51] = 19
  r[r==60] = 20
  r[r==61] = 21
  r[r==62] = 22
  r[r==70] = 23
  r[r==71] = 23
  r[r==72] = 23
  r[r==73] = 23
  r[r==74] = 23
  r[r==75] = 23
  r[r==76] = 23
  r[r==77] = 23
  r[r==78] = 23
  r[r==80] = 23
  r[r==81] = 23
  r[r==82] = 23
  r[r==83] = 23
  
  
  write_feather( as.data.frame(r), file.path( dir, 'label.fe'))
  
  
  
}





























dirs = setdiff( list.files( ) , c('train_data'))

dir.create('train_data')


for(dir in dirs){
  dir.create( file.path('train_data', dir))
  print(dir)
  files = list.files(dir, full.names = TRUE, pattern = 'arial')
  
  r = stack(files[1])
  
  r[is.na(r)] = 0
  
  
  if(length(file)>1){
    for(i in 2:length(files)){
     
      r_new = stack(files[i])
     r_new[is.na(r_new)] = 0
      
      r = mosaic(r, r_new, max )
        
    }
  }
  
  writeRaster(r, file.path('train_data', dir, 'image.tif'), overwrite = TRUE )
  
  
  
  files = union( list.files(dir, full.names = TRUE, pattern = 'CBS_labels') , list.files(dir, full.names = TRUE, pattern = 'CBS _labels') )
  r = readTIFF(files[1])
  
  r[r==10] = 1
  r[r==11] = 2
  r[r==12] = 3
  r[r==20] = 4
  r[r==21] = 5
  r[r==22] = 5
  r[r==23] = 5
  r[r==24] = 6
  r[r==30] = 7
  r[r==31] = 8
  r[r==32] = 9
  r[r==33] = 10
  r[r==34] = 11
  r[r==35] = 12
  r[r==40] = 13
  r[r==41] = 14
  r[r==42] = 15
  r[r==43] = 16
  r[r==44] = 17
  r[r==50] = 18
  r[r==51] = 19
  r[r==60] = 20
  r[r==61] = 21
  r[r==62] = 22
  r[r==70] = 23
  r[r==71] = 23
  r[r==72] = 23
  r[r==73] = 23
  r[r==74] = 23
  r[r==75] = 23
  r[r==76] = 23
  r[r==77] = 23
  r[r==78] = 23
  r[r==80] = 23
  r[r==81] = 23
  r[r==82] = 23
  r[r==83] = 23
  
  
  write_feather( as.data.frame(r), file.path('train_data', dir, 'label.fe'))
  
}

