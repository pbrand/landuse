source('Sentinel_API/sentinel_data_conversion.r')
source('Sentinel_API/devide_in_smaller.r')

y1 = 60
x1 = 148
y2 = 61
x2 = 149

coords = devide_in_smaller(x1 =x1,x2= x2,y1= y1,y2= y2)



satellite = 'Sentinel2'
dir_input = 'Sentinel_API/db/test3'        ##########is not used in this function but is required to assign output dir to downloads


for(i in 1:nrow(coords)){
dir_output = i


prepare_rasters(x1 = coords$x1[i],x2 = coords$x2[i],y1 = coords$y1[i ],y2 = coords$y2[i], satellite = satellite, dir_output = i, dir_input = dir_input)
}