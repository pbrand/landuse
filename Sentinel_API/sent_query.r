sent_query = function(q){
  library(DBI)
  library(RPostgreSQL)

#######connect to database and sent query
drv <- dbDriver("PostgreSQL")
con = dbConnect( drv  , dbname= 'esa_index', host = 'birdsai.co',port = 5432, user = 'maasd', password = 'Brooksrange24')
result = dbSendQuery(con, q)
result = fetch(result, n = -1)
#View(result)
dbDisconnect(con)
}