dirs = find_dirs( pattern = 'bgt.rds', full = TRUE)

legend = read.csv('db/bgt_legend.csv')

for(dir in dirs){
  bgt = readRDS( file.path(dir, 'bgt.rds'))
  
 bgt$number =  legend$number[ match(bgt$category, legend$names)]
 
 saveRDS( bgt, file.path(dir, 'BGT.rds') )
 #file.remove(file.path(dir, 'bgt.rds'))
}