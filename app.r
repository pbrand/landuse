#download subregions of actueel hoogte bestand and put it in db/hoogte bestad
#download a subregion of the BGT covering the subregion of tiffs in db/hoogte bestand. Place it in db/bgt

#make sure projections.rds can be found in db
#make sure the CBS shape can be foudn as a whole or in parts in db/CBS



#load required packages
source('packages.r')
source('find_dirs.r')
# 
# subdir = '/media/daniel/Elements/output' #where to create the ouptu?
# files = list.files('db/hoogte bestand')  # where are the altitude file located?
# projection = readRDS('db/projection.rds') #load projection information
# path_harddrive = '/media/daniel/Elements' #path to hardrive
path_harddrive = '/media/daniel/82A8DA92A8DA8457' #path to hardrive

path_harddrive = '/media/daniel/Elements'

# path_harddrive = '/media/daniel/Elements' #path to hardrive
#path_harddrive = '/media/daniel/82A8DA92A8DA8457' #path to hardrive
#path_harddrive = '/media/daniel/Elements' #path to hardrive
#path_harddrive = '/home/daniel/R/landuse'
path_harddrive = 'E:'



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
############Label all bgt file with numbers as well########
source('label_bgt.r')



################################UNZIP AND MOVE ARIAL IMAGES TO OUTPUT##########################################
#cut out the required arial images
source('arial_images.r')
arial_images(path_harddrive)

#fuse all founde images into one
source('merge_aerial.r')


###################################MERGE ARIAL IMAGES INTO ONE############################################
#source('merge_arial')
#merge_arial(path_harddrive = path_harddrive)

####GENERATE THE LABELS for BGT
print('start generating labels for BGT')
source('make_labels_new.r')
make_labels(path_harddrive = path_harddrive, kind = 'bgt')

#####GENERATE THE LABEL FOR CBS
print('start generating labels for CBS')
source('make_labels_new.r')
make_labels(path_harddrive = path_harddrive, kind = 'CBS ')

