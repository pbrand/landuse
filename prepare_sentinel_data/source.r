library(DBI)
library(RPostgreSQL)
library(datetime)
library(suncalc)
library(sp)
library(rgdal)
library(rgeos)


path = '/home/daniel/R/landuse/prepare_sentinel_data/db'

source('prepare_sentinel_data/sentinel_data_conversion.r')
source('prepare_sentinel_data/merge_rasters.r')
source('prepare_sentinel_data/date_line_case.r')