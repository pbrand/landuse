path =  "/home/daniel/R/landuse/Sentinel_models/db"



library(jpeg)
library(tensorflow)
library(data.table)
library(magrittr)
library(keras)

source('Sentinel_models/one_hot.r')
source('Sentinel_models/read_batch.r')
source('Sentinel_models/select_files.r')