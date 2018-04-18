source('Sentinel_API/sentinel_data_conversion.r')
source('Sentinel_API/devide_in_smaller.r')
source('Sentinel_API/transleer.r')

y1 = 60
x1 = 148
y2 = 60.1
x2 = 148.1
satellite = 'Sentinel2'
dir_input = '/home/maasd/test3'

prepare_rasters(x1 = x1,x2 = x2,y1 = y1,y2 = y2, satellite = satellite,  dir_input = dir_input)
