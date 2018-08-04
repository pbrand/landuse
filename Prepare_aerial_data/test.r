library(tiff)
library(feather)

output =  '/media/daniel/6DA3F120567E843D/Luchtfotos/output'

dirs = list.files( output)



for(i in 10:length(dirs)){
  dir = dirs[i]
print(dir)
 file =  union( list.files( file.path(output, dir), full.names = TRUE, pattern = 'CBS _labels') , list.files( file.path(output, dir), full.names = TRUE, pattern = 'CBS_labels')  )

 r = readTIFF(file)
 
r[r==10] = 1 #rail
r[r==11] = 2 #road
r[r==12] = 4 #airport
r[r==20] = 5 #residential
r[r==21] = 5 #residential
r[r==22] = 5 #residential
r[r==23] = 5 #residential
r[r==24] = 6 #industrial
r[r==30] = 7 #semi
r[r==31] = 7 #semi
r[r==32] = 7 #semi
r[r==33] = 7 #semi
r[r==34] = 7 #semi
r[r==35] = 7 #semi
r[r==40] = 8 #park
r[r==41] = 8 #rail terrain
r[r==42] = 8 #vegtable garden
r[r==43] = 8 #recreational
r[r==44] = 8 #bungalow park
r[r==50] = 9 #greenhouses
r[r==51] = 10 #farming
r[r==60] = 11 #forrest
r[r==61] = 12 #dry natural
r[r==62] = 13 #wet natural
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
write_feather(r, file.path( output, dir, 'label.fe'))


}





