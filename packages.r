
packages = c( 'rgdal', 'gdalUtils' , 'EBImage' , 'leaflet', 'ggplot2', 'ggmap', 'raster', 'rgeos', 'osmar', 'multiplex', 'plyr')
packages = packages[ ! packages %in% installed.packages()  ]
for(package in packages){ install.packages(package)}

library(rgdal)
library(gdalUtils)
library(EBImage)
library(leaflet)
library(ggplot2)
library(ggmap)
library(raster)
library(rgeos)
library(osmar)
library(multiplex)
library(plyr)