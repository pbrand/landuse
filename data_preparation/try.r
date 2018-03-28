main = cbind(c(0, 0, 1, 1),
             c(0, 1, 1, 0))
hole = main/3 + 1/3
island = cbind(c(1.05, 1.05, 1.55, 1.55),
               c(0, .5, .5, 0))
P = Polygons(list(Polygon(main),
                  Polygon(hole, hole = TRUE),
                  Polygon(island)), ID = 1)
SP = SpatialPolygons(list(P))
plot(SP, col = 'red')


r = raster(extent(SP) +1 , nrow = 100, ncol =100)


r = rasterize(SP, r)



r= raster('output/r_14cz2.tif/CBS_labels.tif')
x = readRDS('output/r_14cz2.tif/CBS.rds')

k = rasterize(x, r, field = x$wordt2012, fun = 'max')


plot(r)
plot(k)

