library(DBI)
library(RPostgreSQL)
library(datetime)
library(suncalc)
library(sp)
library(rgdal)
library(rgeos)
library(raster)
library(gdalUtils)
###########################################################################################################
select = function(x1,x2,y1,y2, date, month_from, cloud_cover ,month_to, daylight, satellite, days){
  
  if(x2<x1){
    polygons_1 = find_polygons(x1,180,y1,y2, date, month_from, cloud_cover ,month_to, daylight, satellite, days)
    polygons_2 = find_polygons(-180,x2,y1,y2, date, month_from, cloud_cover ,month_to, daylight, satellite, days)
    polygons = rbind(polygons_1, polygons_2, makeUniqueIDs = TRUE)
  }else{
    polygons = find_polygons(x1,x2,y1,y2, date, month_from, cloud_cover ,month_to, daylight, satellite, days)
  }
  
  draw(x1,x2,y1,y2, polygons)
  
  return(polygons)
  
  
  
}





find_polygons = function(x1,x2,y1,y2, date, month_from, cloud_cover ,month_to, daylight, satellite, days){
  
  
  
  #make area
  area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1, x1), 'y' = c(y1, y1, y2, y2, y1) ))) ,1) ))
  proj4string(area) =  CRS("+proj=longlat +datum=WGS84")
  area = gBuffer(area, width = 0) 
  
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
  date_from = paste( as.Date(date) - days,  '00:00:00')
  date_to = paste(date,  '00:00:00')
  
  
  if(satellite == 'Sentinel2'){
    ##################built kwerie
    q = paste0("SELECT *  FROM index WHERE",
               "(extract(month from content_start_date) BETWEEN ", month_from, " AND ", month_to,                              ###SELECT CORRECT DATES 
               ") AND (",
               "lat_max > ", y1, " AND long_max > ", x1 , " AND lat_min < ", y2 , " AND long_min < ", x2,                                #### MAKE SURE either x1,y1 or x2,y2 lay in the square
               ") AND (",
               "(extract(hour from content_start_date) BETWEEN ", hour_from_1, " AND ", hour_to_1 ,  ") OR (extract(hour from content_start_date) BETWEEN ",    hour_from_2, " AND ", hour_to_2, ")" ,  #########SELECT hours
               ") AND (",
               "content_start_date <= \'", date_to, "\'", " AND content_start_date >= \'", date_from, "\'" ,                                                                     #Take only earlier dates
               ") AND (",
               "cloud_cover < ", cloud_cover,                                                                                  ##########max cloudcover
               ") AND (",
               "download_size< 3500000000",                                                  ##############bestand groote
               ") AND (",
               "satellite = \'", satellite , "\'" ,
               ") ",
               "ORDER BY content_start_date DESC")                                                                            #####ORDER BY DATE
  }else{
    q = paste0("SELECT *  FROM index WHERE",
               "(extract(month from content_start_date) BETWEEN ", month_from, " AND ", month_to,                              ###SELECT CORRECT DATES 
               ") AND (",
               "lat_max > ", y1, " AND long_max > ", x1 , " AND lat_min < ", y2 , " AND long_min < ", x2,                                #### MAKE SURE either x1,y1 or x2,y2 lay in the square
               ") AND (",
               "(extract(hour from content_start_date) BETWEEN ", hour_from_1, " AND ", hour_to_1 ,  ") OR (extract(hour from content_start_date) BETWEEN ",    hour_from_2, " AND ", hour_to_2, ")" ,  #########SELECT hours
               ") AND (",
               "content_start_date <= \'", date_to, "\'", " AND content_start_date >= \'", date_from, "\'" ,                                                                     #Take only earlier dates
               ") AND (",
               "download_size< 3500000000",                                                  ##############bestand groote
               ") AND (",
               "satellite = \'", satellite , "\'" ,
               ") ",
               "ORDER BY content_start_date DESC")                                                                            #####ORDER BY DATE
  }
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
    dateline =   SpatialPolygons( list(Polygons( list(Polygon(  Polygon( data.frame('x' = c(179, 180, 180, 179), 'y' = c(-90, -90, 90, 90) )) )),1)))
    dateline = gBuffer(dateline, width = 0) 
    proj4string(dateline) =  CRS("+proj=longlat +datum=WGS84")
    
    
    i = 1
    polygons = list()
    
    frame = data.frame()
    
    for(n in 1:nrow(result)){
      polygon = as.numeric(unlist(strsplit( result$geometry[n],  '[ ,]')))
      polygon = as.data.frame( matrix(polygon  ,  ncol = 2 , byrow = TRUE ))
      colnames(polygon) = c('y', 'x')
      polygon = polygon[,2:1]
      polygon = Polygon(polygon)
      
      #make temoporaty polygons to compare calculate intersection
      polygons_temp = SpatialPolygons( list(    Polygons(list(polygon), 1) )  )
      proj4string(polygons_temp) =  CRS("+proj=longlat +datum=WGS84")
      polygons_temp = gBuffer(polygons_temp, width = 0) 
      
      
      if( gIntersects( polygons_temp, dateline) ){
        
        western = polygon
        western@coords[ western@coords[,1] >0 , 1] = -180
        polygons = append(polygons, Polygons( list(western),i) )
        frame = rbind(frame, result[n,])
        i =i+1
        eastern = polygon
        eastern@coords[ eastern@coords[,1] <0 , 1] = 180
        polygons = append(polygons, Polygons( list(eastern), i) )
        frame = rbind(frame, result[n,])
        i = i+1
      }else{
        polygons = append(polygons, Polygons(list(polygon), i))
        frame = rbind(frame, result[n,])
        i = i+1
        
      }
    }
    rownames(frame) = c(1:nrow(frame))
    polygons = SpatialPolygons(polygons)
    polygons = SpatialPolygonsDataFrame(polygons, data = frame)
    proj4string(polygons) =  CRS("+proj=longlat +datum=WGS84")
    polygons = gBuffer(polygons, width = 0) 
    #############################
    
    
    
    #####Throw away redundant polygons
    
    #order polygons by surface in common with the area to be covered
    intersections = c()
    for( z in 1:length(polygons)){
      area_temp = gIntersection(area, polygons[z,])
      intersections = c(intersections, gArea(area_temp) )
    }
    polygons = polygons[order(intersections),]
    
    #remove polygons if one can do without
    z=1
    while(z <= length(polygons) & length(polygons) >1 ){
      if(is.null(gDifference(area, polygons[-z,]))){
        polygons = polygons[-z,]
      }else{
        z = z+1
      }
    }
    
    ###############
    
    polygons = polygons[!duplicated(polygons$id),]
    
    return(polygons)
  }
  
  
}


draw = function(x1,x2,y1,y2, polygons){
  
  if(x2<x1){
    #draw area
    area_1 =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, 180, 180, x1), 'y' = c(y1, y1, y2, y2) ))) ,1) ))
      area_2 =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(-180, x2, x2, -180), 'y' = c(y1, y1, y2, y2) ))) ,1) ))
      area = rbind(area_1, area_2 , makeUniqueIDs = TRUE)
      
      proj4string(area) =  CRS("+proj=longlat +datum=WGS84")
    png('image.png')
    plot(polygons)
    plot(area, add = TRUE, col = 'red')
    dev.off()
    
    
  }else{
    area =  SpatialPolygons( list(Polygons( list(Polygon( data.frame('x' = c(x1, x2, x2, x1), 'y' = c(y1, y1, y2, y2) ))) ,1) ))    
    png('image.png')
    plot(polygons)
    plot(area, add = TRUE, col = 'red')
    dev.off()
  }
  
  
  
  
  
  
  
}