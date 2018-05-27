preprocess = function(x1,x2,y1,y2){
  
  if(x2<x1){
    return(list( c(x1, 180, y1, y2) , c(-180, x2, y1, y2) ))
  }else{
    return(list(c(x1,x2,y1,y2)))
  }
  
}