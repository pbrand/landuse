dirs = list.files('output', full.names = TRUE)

for(i in 1:length(dirs)){
  dir = dirs[i]
  files = list.files(dir, pattern = 'wegdeel', full.names = TRUE)
  file.remove(files)
}