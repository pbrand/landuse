library(DBI)
library(RPostgreSQL)
library(datetime)
library(suncalc)
library(sp)
library(rgdal)
library(rgeos)
library(rPython)

path = '/home/daniel/R/landuse/Sentinel_API/db'

source('Sentinel_API/date_line_case.r')
source('Sentinel_API/select.r')
python.load('Sentinel_API/DownloadFiles.py')