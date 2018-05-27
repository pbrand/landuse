library(tiff)
library(feather)

dirs = list.files('db')

for(dir in dirs){
print(dir)
 file =  list.files( file.path('db', dir), full.names = TRUE, pattern = 'CBS_labels_new')

 r = readTIFF(file)
 
r[r==10] = 1 #rail
r[r==11] = 2 #road
r[r==12] = 3 #airport
r[r==20] = 4 #residential
r[r==21] = 5 #comercial
r[r==22] = 5 #comercial
r[r==23] = 5 #comercial
r[r==24] = 6 #industrial
r[r==30] = 7 #dump
r[r==31] = 8 #wreck
r[r==32] = 9 #cementery
r[r==33] = 10 #mining
r[r==34] = 11 #construction site
r[r==35] = 12 #semi sealed
r[r==40] = 13 #park
r[r==41] = 14 #rail terrain
r[r==42] = 15 #vegtable garden
r[r==43] = 16 #recreational
r[r==44] = 17 #bungalow park
r[r==50] = 18 #greenhouses
r[r==51] = 19 #farming
r[r==60] = 20 #forrest
r[r==61] = 21 #dry natural
r[r==62] = 22 #wet natural
r[r==70] = 23 #water
r[r==71] = 23
r[r==72] = 23
r[r==73] = 23
r[r==74] = 23
r[r==75] = 23
r[r==76] = 23
r[r==77] = 23
r[r==78] = 23
r[r==80] = 23
r[r==81] = 23
r[r==82] = 23
r[r==83] = 23

r = as.data.frame(r)
write_feather(r, file.path('db', dir, 'label.fe'))


}