make_labels = function(path_harddrive, kind){
  
  #select files that do not hava bgt.rds in them
  dirs = find_dirs(pattern = paste0(kind , '_labels'), full = FALSE)

  
  for(dir in dirs){
    print(paste('bizzy with', dir))
    #read shape of kind 'kind'
    shape = readRDS( file.path(dir,  paste0(kind, '.rds') ))  
    
    r = raster( file.path(dir, dir))
    
    
    
    
     shape$wordt2012[ shape$wordt2012==10] = 1 # shape$wordt2012ail
     shape$wordt2012[ shape$wordt2012==11] = 2 # shape$wordt2012oad
     shape$wordt2012[ shape$wordt2012==12] = 4 #ai shape$wordt2012po shape$wordt2012t
     shape$wordt2012[ shape$wordt2012==20] = 5 # shape$wordt2012esidential
     shape$wordt2012[ shape$wordt2012==21] = 5 # shape$wordt2012esidential
     shape$wordt2012[ shape$wordt2012==22] = 5 # shape$wordt2012esidential
     shape$wordt2012[ shape$wordt2012==23] = 5 # shape$wordt2012esidential
     shape$wordt2012[ shape$wordt2012==24] = 6 #indust shape$wordt2012ial
     shape$wordt2012[ shape$wordt2012==30] = 7 #semi
     shape$wordt2012[ shape$wordt2012==31] = 7 #semi
     shape$wordt2012[ shape$wordt2012==32] = 7 #semi
     shape$wordt2012[ shape$wordt2012==33] = 7 #semi
     shape$wordt2012[ shape$wordt2012==34] = 7 #semi
     shape$wordt2012[ shape$wordt2012==35] = 7 #semi
     shape$wordt2012[ shape$wordt2012==40] = 8 #pa shape$wordt2012k
     shape$wordt2012[ shape$wordt2012==41] = 8 # shape$wordt2012ail te shape$wordt2012 shape$wordt2012ain
     shape$wordt2012[ shape$wordt2012==42] = 8 #vegtable ga shape$wordt2012den
     shape$wordt2012[ shape$wordt2012==43] = 8 # shape$wordt2012ec shape$wordt2012eational
     shape$wordt2012[ shape$wordt2012==44] = 8 #bungalow pa shape$wordt2012k
     shape$wordt2012[ shape$wordt2012==50] = 9 #g shape$wordt2012eenhouses
     shape$wordt2012[ shape$wordt2012==51] = 10 #fa shape$wordt2012ming
     shape$wordt2012[ shape$wordt2012==60] = 11 #fo shape$wordt2012 shape$wordt2012est
     shape$wordt2012[ shape$wordt2012==61] = 12 #d shape$wordt2012y natu shape$wordt2012al
     shape$wordt2012[ shape$wordt2012==62] = 13 #wet natu shape$wordt2012al
     shape$wordt2012[ shape$wordt2012==70] = 3 #wate shape$wordt2012
     shape$wordt2012[ shape$wordt2012==71] = 3
     shape$wordt2012[ shape$wordt2012==72] = 3
     shape$wordt2012[ shape$wordt2012==73] = 3
     shape$wordt2012[ shape$wordt2012==74] = 3
     shape$wordt2012[ shape$wordt2012==75] = 3
     shape$wordt2012[ shape$wordt2012==76] = 3
     shape$wordt2012[ shape$wordt2012==77] = 3
     shape$wordt2012[ shape$wordt2012==78] = 3
     shape$wordt2012[ shape$wordt2012==80] = 3
     shape$wordt2012[ shape$wordt2012==81] = 3
     shape$wordt2012[ shape$wordt2012==82] = 3
     shape$wordt2012[ shape$wordt2012==83] = 3
    
   
    
    
    
    
    
      if(kind == 'CBS'){
        label = raster::rasterize( shape , r, field =  as.numeric( shape$wordt2012 ) )
      }else{
        shape = shape[shape$number != 3,]
        label = raster::rasterize( shape , r, field =   as.numeric( shape$number), fun = max) ###adde fun = max  
      }
      writeRaster(label, file.path(dir, paste0(kind, '_labels.tif')) , overwrite= TRUE)
      
    
    
    
  }
}