dirs = find_dirs( pattern = 'BGT.rds', full = TRUE)

legend = read.csv( file.path(path_harddrive, 'db/bgt_legend.csv'))

for(dir in dirs){
  print(dir)
  bgt = readRDS( file.path(dir, 'bgt.rds'))
  
 bgt$number =  legend$number[ match(bgt$category, legend$names)]
 
 saveRDS( bgt, file.path(dir, 'BGT.rds') )
 file.remove(file.path(dir, 'bgt.rds'))
}