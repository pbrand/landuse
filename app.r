#download subregions of actueel hoogte bestand and put it in db/hoogte bestad
#download a subregion of the BGT covering the subregion of tiffs in db/hoogte bestand. Place it in db/bgt

#make sure projections.rds can be found in db
#make sure the CBS shape can be foudn as a whole or in parts in db/CBS



#load required packages
source('packages.r')


#path_harddrive = '/media/daniel/Elements' #path to hardrive
path_harddrive = '/home/daniel/R/landuse'



###################################################MOVE HOOGTE BESTAND TIFFS TO OUTPUT####################################################################
#make subdirs and place hoogte bestand in the directory
print('starting to copy hoogte bestanden to output')
files = list.files( file.path(path_harddrive, 'db', 'hoogte bestand') )  # where are the altitude file located?
files_already_done = list.files( file.path(path_harddrive, 'output' ))
files = files[ !files %in% files_already_done ]

for(file in files){
  print(paste('bizzy with', file))
  dir.create(file.path( path_harddrive, 'output', file ))
  r = raster( file.path(path_harddrive, 'db' , 'hoogte bestand', file))
  writeRaster(r, file.path(path_harddrive, 'output' , file , file))
}
##################################################CROP AND PLACE CBS SHAPES IN OUTPUT##############################################################################

#crop the CBS shape and place in dir
print('starting to crop and copy CBS files')

source('CBS_crop.r')
CBS_crop(path_harddrive = path_harddrive)

############################################################CROP MERGE AND MOVE BGT TO OUTPUT##################################################################

###########this part is only if we use the kadaster information as well
#Merge the bgt shapes, crop and place in subdir
print('bizzy with mergin, croping and copying shapes bgt')
source('merge_shapes_bgt.r')
merge_shapes_bgt(path_harddrive = path_harddrive)
############

################################UNZIP AND MOVE ARIAL IMAGES TO OUTPUT##########################################
#cut out the required arial images
source('arial_images.r')
arial_images(path_harddrive)

##################################SPLIT UP ARIAL IMAGE INTO MULTIPLE IMAGES######################################


#devide arial images into parts
source('splitRaster')
spilt_arial_images(path_harddrive = path_harddrive, n = 20 , m = 20, kind = 'arial_image')

#############################################################################






