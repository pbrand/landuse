library(DBI)
library(datetime)
library(RPostgreSQL)
library(suncalc)


#######Input
x1 = 33.43
y1 = -84.22
x2 = 34.43
y2 = -83.22
date = "2008-01-01"
month_from = 1
month_to = 12
day = TRUE


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


#### make datetime before which we are searching
date = paste(date,  '00:00:00')
q = paste("SELECT * FROM index WHERE content_start_date >= \' ", date, "\'")



#built kwerie
q = paste("SELECT * FROM index WHERE",
          "(extract(month from content_start_date) BETWEEN", month_from, "AND", month_to,                              ###SELECT CORRECT DATES 
          ") AND (",
          "lat_max >", x1, "AND long_max >", y1 , "AND lat_min <", x2 , "AND long_min <", y2,                                #### MAKE SURE either x1,y1 or x2,y2 lay in the square
         ") AND (",
         "extract(hour from content_start_date) BETWEEN", hour_from, "AND", hour_to ,                                 #########SELECT hours
         ") AND (",
         "content_start_date <= \' ", date, "\'",                                                                     #Take only earlier dates
         ") AND (",
         "download_size< 3500000000",                 ##############bestand groote
         ")",
         "ORDER BY content_start_date DESC")                                                                            #####ORDER BY DATE
          
          



result = dbSendQuery(con, q)
result = fetch(result, n = -1)
View(result)

