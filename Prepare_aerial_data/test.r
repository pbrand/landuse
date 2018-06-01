library(tiff)
library(feather)

dirs = list.files( file.path('db', 'raw'))

for(dir in dirs){
print(dir)
 file =  list.files( file.path('db', 'raw', dir), full.names = TRUE, pattern = 'CBS_labels_new')

 r = readTIFF(file)
 
r[r==10] = 1 #rail
r[r==11] = 2 #road
r[r==12] = 4 #airport
r[r==20] = 5 #residential
r[r==21] = 6 #comercial
r[r==22] = 6 #comercial
r[r==23] = 6 #comercial
r[r==24] = 7 #industrial
r[r==30] = 8 #dump
r[r==31] = 9 #wreck
r[r==32] = 10 #cementery
r[r==33] = 11 #mining
r[r==34] = 12 #construction site
r[r==35] = 13 #semi sealed
r[r==40] = 14 #park
r[r==41] = 15 #rail terrain
r[r==42] = 16 #vegtable garden
r[r==43] = 17 #recreational
r[r==44] = 18 #bungalow park
r[r==50] = 19 #greenhouses
r[r==51] = 20 #farming
r[r==60] = 21 #forrest
r[r==61] = 22 #dry natural
r[r==62] = 23 #wet natural
r[r==70] = 3 #water
r[r==71] = 3
r[r==72] = 3
r[r==73] = 3
r[r==74] = 3
r[r==75] = 3
r[r==76] = 3
r[r==77] = 3
r[r==78] = 3
r[r==80] = 3
r[r==81] = 3
r[r==82] = 3
r[r==83] = 3

r = as.data.frame(r)
write_feather(r, file.path('db', 'raw', dir, 'label.fe'))


}





