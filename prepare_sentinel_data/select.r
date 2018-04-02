library(DBI)
library(datetime)
library(RPostgreSQL)
library(suncalc)


#######Input
x1 = -9.5
y1 = 107.6
x2 = -9.55
y2 = 107.65
date = "2016-02-15"
month_from = 1
month_to = 1
day = TRUE
satellite = 'Sentinel1'


#######connect to database

drv <- dbDriver("PostgreSQL")

con = dbConnect( drv  , dbname= 'esa_index', host = 'birdsai.co',
                 port = 5432, user = 'maasd', password = 'Brooksrange24')



##find daylight hours
date = as.Date(date)
sun_info = getSunlightTimes(x1, y1, date = date, tz="UTC") 	

if(day == TRUE){
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


#### make datetime before which we are searching
date = paste(date,  '00:00:00')
q = paste("SELECT * FROM index")



#built kwerie
q = paste0("SELECT * FROM index WHERE",
          "(extract(month from content_start_date) BETWEEN ", month_from, " AND ", month_to,                              ###SELECT CORRECT DATES 
          ") AND (",
          "lat_max > ", x1, " AND long_max > ", y1 , " AND lat_min < ", x2 , " AND long_min < ", y2,                                #### MAKE SURE either x1,y1 or x2,y2 lay in the square
         ") AND (",
         "(extract(hour from content_start_date) BETWEEN ", hour_from_1, " AND ", hour_to_1 ,  ") OR (extract(hour from content_start_date) BETWEEN ",    hour_from_2, " AND ", hour_to_2, ")" ,                            #########SELECT hours
         ") AND (",
         "content_start_date <= \'", date, "\'",                                                                     #Take only earlier dates
         ") AND (",
         "download_size< 3500000000",                                                  ##############bestand groote
         ") AND (",
         "satellite = \'", satellite , "\'" ,
         ") ",
         "ORDER BY content_start_date DESC")                                                                            #####ORDER BY DATE
          
          



result = dbSendQuery(con, q)
result = fetch(result, n = -1)
View(result)

dbDisconnect(con)

