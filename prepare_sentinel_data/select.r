#input
#dag of nacht?
#datum
#x1,x2,y1,y2



#strategie
#doe kwerie die alle data tot 1 maand voor de datum ophaalt tijdens dag of nacht die een overlap heeft met de geselecteerde regio en sort ze op recentheid
#ga in en forloop de index langs totdat de shapes het vierkant coveren


library(DBI)





drv <- dbDriver("PostgreSQL")
con = dbConnect(drv, dbname= 'company', host = 'courses.csrrinzqubik.us-east-1.rds.amazonaws.com',
                port = 3306, user = 'student', password = 'datacamp')




library("RPostgreSQL")



library('RSQLServer')
con = dbConnect(RMySQL::MySQL(), dbname= 'company', host = 'courses.csrrinzqubik.us-east-1.rds.amazonaws.com',
                port = 3306, user = 'student', password = 'datacamp')




dbListTables(con)

q = "select * from sales WHERE   date >= '2015-09-19' AND date <= '2017-09-19' " 


result = dbSendQuery(con, q)
data.frame = fetch(result, n = -1)
data.frame



