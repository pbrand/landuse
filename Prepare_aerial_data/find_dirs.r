find_dirs = function(pattern = pattern, full = full){

 
  
dirs_output = list.files(file.path(path_harddrive, 'output'))
select = c()
for(dir_output in dirs_output){
  select = c(select, length(  list.files( file.path(path_harddrive, 'output', dir_output), pattern = pattern) ) ==0)
}
dirs_output = dirs_output[select]


if(full == TRUE){ dirs_output = file.path(path_harddrive, 'output', dirs_output)}

return(dirs_output)
}