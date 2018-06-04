#command
#python3 Sentinel_Hub.py 4.83122 52.23802 4.8851 52.2844 '2016-05-24' '2017-05-30' 10 10 '/home/daniel/R/landuse' 'SENTINEL1'


x1 =  4.83122
x2 = 4.8851
y1 = 52.23802
y2 = 52.2844

w = 800
h = 800

dir_out = '/home/daniel/R/landuse'
dir_script = 'Sentinel_API/R_scripts_for_sentinelhub/Sentinel_Hub.py'

date_from = '2016-05-24'
date_to = '2017-05-30'

source = 'L1C'

comand = paste('python3', dir_script, x1 , y1,  x2,  y2, date_from,  date_to,  w ,  h,  dir_out,  source)
system(comand)



#SLC1
#L2A
#L1C