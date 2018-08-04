setwd('/home/daniel/R/landuse/Sentinel_API/R_scripts_for_sentinelhub')
source('download_syn.r')



date_to = '2018-05-10'  #what date are we considering
satellite = 'L2A' #What satellite system do we use possibilities: L1C , L2A and SENTINEL1
days = 20 # How far are we looking back
preview = 1
x1 = 
x2 = 
y1 = 
y2 = 
shape_name = 'Netherlands'  # 'Aruba' # 'Pannama' #'Estonia' #   
shape_chapter = 'shapes/countries'
dir_out = 'request' #where to write the downloads
threshold_area = 10  #how large can the requested area be
threshold_days = 20 #For how long a period can the user requst data
wait = 0  #how many seconds does the server wait till making the wms request for the next tile
w= 3000 # width of the tiles in meter
h = 3000 #heigth of the tiles in meter
res = 10 # resolution in meter



estimate_bbox(x1,x2,y1,y2,date_from, days, dir_out, wait, threshold_area, threshold_days, w, h, res, preview)

main_base_on_boundingbox(x1,x2,y1,y2,satellite, dir_out, date_to, days, wait, w, h, res, preview)

estimate_shape(shape_chapter, shape_name,date_from, days, dir_out, wait, threshold_area, threshold_days, w, h, res, preview)

main_base_on_shape(shape_chapter, satellite, dir_out, date_to, days, shape_name, wait, w, h, res, preview)

