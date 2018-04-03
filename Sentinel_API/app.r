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

#make area
area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
proj4string(area) =  CRS("+proj=longlat +datum=WGS84")

#leave index running
############Script Minghai

#select required products
products_select = select(area = area, date = date, month_from = month_from, month_to = month_to , daylight = daylight, satellite = satellite)



###############################################################################
####Under directory of ID I want all bans in jp2 or tif format. Can be found in GRANULE/IMG_DATA
no_cores <- min(length(products_select), 3)
cl <- makeCluster(no_cores)
clusterExport(cl, "dir_out", "user", "pswd")

#download files
parLapply(cl, products_select$id, function(id){
      library(rPython)
    python.load('Sentinel_API/DownloadFiles.py')
    python.call('download_file', id , dir_out, user, pswd)
})
  
  #stop cluster
  stopCluster(cl)
  ###################################################################################
  
  
  #translate files funcion case sentinel1
  
  
  #translate files funcion case sentinel2
  
  
  
  #merge files function