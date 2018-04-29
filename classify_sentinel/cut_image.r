source('classify_sentinel/source.r')
bands = setdiff( list.files(file.path(path, 'regio_utrecht'), full.names = TRUE) , list.files(file.path(path, 'regio_utrecht'), pattern = 'aux', full.names = TRUE)  )

bands = lapply(bands, function(band){
  as.array(raster(band))
})

bands = do.call(abind, c(bands, list(along =3)) )

bands = bands[,,4:2]


window_dim = 64
num_bands = 3
##################################

N_x = floor(dim(bands)[2]/ window_dim) -1
N_y = floor(dim(bands)[1]/ window_dim) -1


combinations = expand.grid(0:N_x, 0:N_y)
colnames(combinations) = c('x', 'y')

prediction = matrix(-1, ncol = N_x, nrow = N_y)

sub_im = array(-1, dim = c( window_dim, window_dim, num_bands))




for(i in 1:nrow(combinations)){
  print(i/nrow(combinations))
  
  sub_im[,,] =   bands[ (combinations$y[i] * window_dim +1 ) :((combinations$y[i]+1) * window_dim),  (combinations$x[i] * window_dim +1 ) :((combinations$x[i]+1) * window_dim), ]    
  sub_im = sub_im - 1
  sub_im = sub_im/max(sub_im)
  
  writeJPEG(sub_im, file.path(path, 'cut', paste0(i, '.jpg')))
  
}

