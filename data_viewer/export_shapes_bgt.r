install.packages('rgdal')
library(rgdal)

path = '/Users/patrick/Data/output'


dirs = list.dirs(path, full.names = TRUE, recursive = FALSE)
dirs

for(dir in dirs){
  bgt = readRDS(file.path(dir, 'bgt.rds'))
  
  dir.create('bgt', dir)
  writeOGR(bgt, file.path(dir, 'bgt'), 'bgt', driver="ESRI Shapefile")}

