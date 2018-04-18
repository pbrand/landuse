source('Sentinel_API/sentinel_data_conversion.r')
source('Sentinel_API/devide_in_smaller.r')

y1 = 60
x1 = 148
y2 = 61
x2 = 149
satellite = 'Sentinel2'
dir_output

prepare_rasters(x1 = coords$x1[i],x2 = coords$x2[i],y1 = coords$y1[i ],y2 = coords$y2[i], satellite = satellite,  dir_input = dir_input)
