source('Sentinel_API/source.r')


#######Test input
x1 = 111
x2 = 112
y1 = 28
y2 = 28.5
date = "2020-02-15"
month_from = 1
month_to = 12
daylight = TRUE
satellite = 'Sentinel1'
downsample_factor = 1     ############is not used in this function but is a required user input to determine output
dir_output = 'test'        ##########is not used in this function but is required to assign output dir to downloads
user = 
pswd = 

#leave index running
############Script Minghai

#select required products
products_select = select(x1 = x1, y1 = y1, x2 = x2, y2 = y2, date = date, month_from = month_from, month_to = month_to , daylight = daylight, satellite = satellite)




#download files function
for(id in products_select$id ){
python.call('download_file', id , path, user, pswd)
}
#translate files funcion

#merge files function
