###########################################################################################################
select = function(x1,x2,y1,y2, date, month_from, month_to, daylight, satellite){
  
  #make area
  area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
  proj4string(area) =  CRS("+proj=longlat +datum=WGS84")
  
  
  
############prepare input data for query
##find daylight hours
date = as.Date(date)
sun_info = getSunlightTimes(x1, y1, date = date, tz="UTC") 	
if(daylight == TRUE){
 hour_from = format(sun_info$sunriseEnd, '%H')
 hour_to =format( sun_info$sunsetStart, '%H')
}else{
  hour_from = format( sun_info$sunset, '%H')
  hour_to = format(sun_info$sunrise, '%H')
}
#in case midnight lies within the time stamp, fix it
if(hour_from > hour_to){
  hour_from_1 = hour_from
  hour_from_2 = "00"
  hour_to_1 = "24"
  hour_to_2 = hour_to
}else{
  hour_from_1 = hour_from
  hour_from_2 = hour_from
  hour_to_1 = hour_to
  hour_to_2 = hour_to
}
#### make datetime of date
date = paste(date,  '00:00:00')



##################built kwerie
q = paste0("SELECT *  FROM index WHERE",
          "(extract(month from content_start_date) BETWEEN ", month_from, " AND ", month_to,                              ###SELECT CORRECT DATES 
          ") AND (",
          "lat_max > ", y1, " AND long_max > ", x1 , " AND lat_min < ", y2 , " AND long_min < ", x2,                                #### MAKE SURE either x1,y1 or x2,y2 lay in the square
         ") AND (",
         "(extract(hour from content_start_date) BETWEEN ", hour_from_1, " AND ", hour_to_1 ,  ") OR (extract(hour from content_start_date) BETWEEN ",    hour_from_2, " AND ", hour_to_2, ")" ,  #########SELECT hours
         ") AND (",
         "content_start_date <= \'", date, "\'",                                                                     #Take only earlier dates
         ") AND (",
         "download_size< 3500000000",                                                  ##############bestand groote
         ") AND (",
         "satellite = \'", satellite , "\'" ,
         ") ",
         "ORDER BY content_start_date DESC")                                                                            #####ORDER BY DATE
          
#######connect to database and sent query
drv <- dbDriver("PostgreSQL")
con = dbConnect( drv  , dbname= 'esa_index', host = 'birdsai.co',port = 5432, user = 'maasd', password = 'Brooksrange24')
result = dbSendQuery(con, q)
result = fetch(result, n = -1)
#View(result)
dbDisconnect(con)

#eror handeling
if(nrow(result) ==0){ print('error no products found in index')}else{




################Transform output to SpatialPolygonsDataFrame format
polygons = SpatialPolygons( lapply(  c(1:nrow(result))  , function(i){
 polygon = as.numeric(unlist(strsplit( result$geometry[i],  '[ ,]')))
 polygon = as.data.frame( matrix(polygon  ,  ncol = 2 , byrow = TRUE ))
 colnames(polygon) = c('y', 'x')
 polygon = polygon[,2:1]
 polygon = Polygon(polygon)
 
 polygon = date_line_case(polygon, i)

 return(polygon)
}))
polygons = SpatialPolygonsDataFrame(polygons, result)
proj4string(polygons) =  CRS("+proj=longlat +datum=WGS84")
rm(result)

#########Search most recent satellite images that cover the area
#make polygon of area
#loop till the square is covered
ids = c()
for(i in 1:length(polygons)){
  if( gIntersects(area, polygons[i,]) ){ 
    area = gDifference(area, polygons[i,])
    ids = c(ids, i)
    }
  if( is.null(area)){ break}
}

return(polygons[ids,])
}


}