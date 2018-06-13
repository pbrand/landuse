#what happens if you download something with the same name?

setwd('/home/daniel/R/landuse/Sentinel_API/R_scripts_for_sentinelhub')

source('download_syn.r')



x1 = 6.01
x2 = 6.06
y1 = 52.32
y2 = 52.37
area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
proj4string(area) =  CRS("+proj=longlat +datum=WGS84")


#Read in shape and cover it
shape_name = 'Ethiopia' #  'Netherlands' #   'Aruba' #   'Estonia' 'Netherlands' #
shape_chapter = 'countries'
area = readOGR(file.path('shapes', shape_chapter, shape_name))
covering =   cover(area, w_im  , h_im)


#############################PARAMETERS####################################################
#needed in case you want to use pre-defined shape
size =  3000
date_to = '2017-06-01'  #starting date
time_window = 365 #timewindow
dir_out = '/home/daniel/Projecten/clouds' #where to write the downloads
satellite = 'L1C'
w_im = 6000
h_im = 6000
w = 30000
h = 30000
wait = 15
preview = 0
res = 10
days = 15
################################################################################################



sample_regions = sample(c(1:length(covering)), size = size, replace =  TRUE)
sample_regions = covering[sample_regions,]
sample_dates = sample(c(1:time_window), size = size, replace =  TRUE)
sample_dates = as.Date(date_to) + sample_dates

plot(sample_regions)

print(paste('done in ', round((100*20)/(60*60),1), 'hours'))

for( i in 1:size){
  download( sample_regions[i,] ,satellite , file.path(dir_out, 'beelden',i ), sample_dates[i], days , wait, w, h, res , preview)
}

Sys.sleep(300)

#get all images out of the subfolders
files= list.files(file.path(dir_out, 'beelden'), full.names =  TRUE, recursive = TRUE)
names = strsplit(files, '[/]')
names = unlist(lapply(names, function(x){
 x[length(x)] 
}))

for(i in 1:length(files)){
  r = raster::stack(files[i])
  r= crop(r, extent(r, 1,512, 1, 512) )
  writeRaster(r, filename = file.path(dir_out, 'beelden',  names[i]), overwrite = TRUE)
}

#remove all other files
file.remove(files)
dirs = list.dirs(file.path(dir_out,'beelden'))[-1]
unlink(dirs, recursive = TRUE)


#make jpegs
make_preview(file.path(dir_out, 'beelden'))

#place all tiffs that have an image in raw, remove all other tiffs
files = list.files( file.path(dir_out, 'beelden'), pattern = 'tif')
file.rename(file.path(dir_out, 'beelden', files), file.path(dir_out, 'raw', files))
 
 
 
 