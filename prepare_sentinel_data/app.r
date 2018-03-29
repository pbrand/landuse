source('prepare_sentinel_data/source.r')

name  = 'romania'
max_dim = 10980


dir.create(file.path(path, 'sentinel2', name))



translate(dir_in = file.path(path,'sentinel2_input', name) , dir_out =   file.path(path, 'sentinel2', name), max_dim = max_dim )


dir_in = file.path(path, 'sentinel2' , name)
dir_out = file.path(path, 'sentinel2' , name)


merge_rasters(dir_in = dir_in, dir_out)


