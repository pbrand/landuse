

devide_in_smaller = function(x1,x2,y1,y2){


step_x = (x2-x1) /  ( geodistance(longvar = x1, latvar = y1 , lotarget = x2 , latarget = y1  )$dist *1.609344*1000 /20000)   
step_y = (y2- y1) / (  geodistance(longvar = x1, latvar = y1 , lotarget = x1 , latarget = y2  )$dist *1.609344*1000 /20000 )  

len_x = floor((x2-x1)/ step_x) +1
len_y = floor((y2-y1)/ step_y) +1


x_mins = x1 + c(0:(len_x-1)) * step_x
x_maxs = x1 + c(1:len_x) * step_x

y_mins = y1 + c(0:(len_y-1)) * step_y
y_maxs = y1 + c(1:len_y) * step_y

coords = lapply( c(1:length(y_mins)), function(i){
  data.frame('x1' = x_mins, 'x2'= x_maxs, 'y1'= y_mins[i], 'y2'= y_maxs[i])
  
})

coords = rbindlist(coords)

return(coords)
}