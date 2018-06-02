source('Sentinel_API/select.r')


#######Test input
x1 = 27
x2 = 27.9
y1 = -1
y2 = 1
date = "2018-05-15"
days = 100
month_from = 1
month_to = 12
daylight = TRUE
satellite = 'Sentinel2'
downsample_factor = 1     ############is not used in this function but is a required user input to determine output
dir_output = 'test1'       ##########is not used in this function but is required to assign output dir to downloads
cloud_cover = 25


polygons = select(x1,x2,y1,y2, date, month_from, cloud_cover = cloud_cover , month_to, daylight, satellite,  days)



