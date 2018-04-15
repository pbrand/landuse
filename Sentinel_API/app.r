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
dir_output = path       ##########is not used in this function but is required to assign output dir to downloads
user = "kloetq"
pswd = 'Datalab1'



#######Test input

y1 = 60
x1 = 148.8
y2 = 61
x2 = 149.8
date = "2020-02-15"
month_from = 1
month_to = 12
daylight = TRUE
satellite = 'Sentinel2'
downsample_factor = 1     ############is not used in this function but is a required user input to determine output
dir_output = path        ##########is not used in this function but is required to assign output dir to downloads
user = "kloetq"
pswd = 'Datalab1'


#leave index running
############Script Minghai

#Invoke script Minghai
system( paste('/home/common/download.sh', x1, x2,y1, y2, date, month_from, month_to, daylight, satellite, paste0('/home/common/', dir_output)) , wait = TRUE )
###################################################################################
    
    
    #translate files funcion case sentinel1
    
    
    #translate files funcion case sentinel2
    
    
    
    #merge files function