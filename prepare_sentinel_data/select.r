library(DBI)
library(datetime)
library(RPostgreSQL)
library(suncalc)

#input
#day TRUE/FALSE
#date
#x1,x2,y1,y2


#######Input
x1 = 33.43
y1 = -84.22
x2 = 34.43
y2 = -83.22
date = as.Date("2008-01-01")
month_from = 1
month_to = 12
day = TRUE


#######connect to database

drv <- dbDriver("PostgreSQL")

con = dbConnect( drv  , dbname= 'esa_index', host = 'localhost',
                 port = 5432, user = 'maasd', password = 'Brooksrange24')



##find daylight hours
sun_info = getSunlightTimes(x1, y1, date = date, tz="UTC") 	

if(day == TRUE){
 hour_from = format(sun_info$sunriseEnd, '%H')
 hour_to =format( sun_info$sunsetStart, '%H')
}else{
  hour_from = format( sun_info$sunset, '%H')
  hour_to = format(sun_info$sunrise, '%H')
}


#built kwerie
q = paste("SELECT * FROM index WHERE  (extract(month from content_start_date) BETWEEN", month_from, "AND", month_to,     ###SELECT CORRECT DATES 
          ") AND (((",
         "lat_min BETWEEN", x1, "AND", x2   ,                                                                                                      #### MAKE SURE either x1,y1 or x2,y2 lay in the square
          ") AND (",
         "long_min BETWEEN", y1, "AND", y2   , 
         ")) OR ((",
         "lat_max BETWEEN", x1, "AND", x2   ,                                                                                                     
         ") AND (",
         "long_max BETWEEN", y1, "AND", y2   , 
         "))) AND(",
         "extract(hour from content_start_date) BETWEEN", hour_from, "AND", hour_to ,                                 ##############SELECT hours
         ")",
         "ORDER BY content_start_date DESC")                                                                            #########ORDER BY DATE
          
          

result = dbSendQuery(con, q)
result = fetch(result, n = -1)
View(result)

