#get extent

CBS_crop = function(files, subdir){

for(file in files){
  print(paste('bizzy with', file))
  r = raster(paste0('db/hoogte bestand/', file))
  extent = extent(r)

shapes = list.files('db/CBS')

CBS = readRDS(paste0( 'db/CBS/', shapes[1])  )
CBS = crop(CBS, extent)
shapes = shapes[-1]

for(shape in shapes){
  CBS_extra = readRDS(paste0( 'db/CBS/', shape)  )
  CBS_extra = crop(CBS_extra, extent)
  CBS = rbind(CBS, CBS_extra)
}

saveRDS(CBS,paste0(subdir, '/', file , '/CBS.rds'))

}
  
  
  
}