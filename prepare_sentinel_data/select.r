#input
#day TRUE/FALSE
#date
#x1,x2,y1,y2

x1 = 33.43
y1 = -84.22
date = as.Date("2008-01-01")

#strategie
#doe kwerie die alle data tot 1 maand voor de datum ophaalt tijdens dag of nacht die een overlap heeft met de geselecteerde regio en sort ze op recentheid
#ga in en forloop de index langs totdat de shapes het vierkant coveren


library(DBI)
library(datetime)
library(RPostgreSQL)
library(suncalc)



#get time boundary



sun_info = getSunlightTimes(x1, y1, date = date, tz="UTC") 	

format(sun_info$sunsetStart, '%H')

if(day == TRUE){
  #query all daytime overlays of last month
  
  SELECT * FROM MyTable
  WHERE DATEPART(HOUR, SyncDate) BETWEEN as.numeric(format(sun_info$sunriseEnd, '%H')) AND as.numeric(format(sun_info$sunsetStart, '%H')) DATEPART(MINUTE, SyncDate) BETWEEN 0 AND 30
  
  
}else{
  
  #query all nighttime overlays of last month
}







#Same As above but look at Time Zone Specification
sunrise.set(33.43, -84.22, "2008/01/01", timezone="America/New_York")
sunrise.set(lat, long, date, timezone = "UTC", num.days = 1)


ts_df <- do.call(rbind, lapply(1:nrow(df), function(i) {
  tz <- df$timezone[i]
  raw <- as.POSIXct(strptime(
    df$actualtime[i],
    format = "%Y-%m-%d %H:%M:%S",
    tz ="Australia/Sydney"),
    tz = "Australia/Sydney")
  ts <- format(raw, tz = tz, usetz = TRUE)
  data.frame(raw=raw,tz=tz,converted = as.POSIXct(ts))
}))



# 
# library('RSQLServer')
# con = dbConnect(RMySQL::MySQL(), dbname= 'company', host = 'courses.csrrinzqubik.us-east-1.rds.amazonaws.com',
#                 port = 3306, user = 'student', password = 'datacamp')



#sent query

library(RMySQL)
con = dbConnect( MySQL()  , dbname= 'company', host = 'courses.csrrinzqubik.us-east-1.rds.amazonaws.com',
                port = 3306, user = 'student', password = 'datacamp')
dbListTables(con)
q = 'SELECT * FROM employees ORDER BY name'


q = "select * FROM employees"

q = "select * from employees WHERE   DATEPART(MONTH, started_at) BETWEEN 1 AND 9 " 

result = dbSendQuery(con, q)
data.frame = fetch(result, n = -1)
data.frame



