onehot = function(batch_labels, clas){

  a = array(0, dim = c(length(batch_labels), clas))

  for(i in 1:length(batch_labels)){
  one_hot = rep(0, clas)
  one_hot[batch_labels[i]] = 1
    a[i,] = as.integer(one_hot  )
  }

return(a)
}
