#download subregions of actueel hoogte bestand
#download a subregion of the BGT covering the subregion of the hoogtebestand

#set workdirectory with
# a subdir db/bgt in which you place subfolder wegdeel and pand with in them the shapefiles and the gml file wegdeel.
# place the CBS.rds under db/CBS
# in db/hoogte bestand tiff files covering the region of the bgt subregion



#load required packages
source('packages.r')

subdir = '/media/daniel/Elements/output' #where to create the ouptu?
files = list.files('db/hoogte bestand')  # where are the altitude file located?
projection = readRDS('db/projection.rds') #load projection information
path_harddrive = '/media/daniel/Elements' #path to hardrive




#make subdirs and place hoogte bestand in the directory
dir.create(subdir)
print('starting to copy hoogte bestanden to output')
for(file in files){
  print(paste('bizzy with', file))
  dir.create(paste0( subdir, '/' , file ))
  r = raster(paste0('db/hoogte bestand/', file))
  writeRaster(r, paste0(subdir, '/' , file, '/', file))
}

#crop the CBS shape and place in dir
print('starting to crop and copy CBS files')

source('CBS_crop.r')
CBS_crop(files = files, subdir = subdir)


###########this part is only if we use the kadaster information as well
#Merge the bgt shapes, crop and place in subdir
#print('bizzy with mergin, croping and copying shapes bgt')
#source('merge_shapes_bgt.r')
#merge_shapes_bgt(files = files, subdir = subdir, projection = projection)
############

#cut out the required arial images
source('ecw_extent.r')



#Next up selecting and croping all images that fall into the subregion

#Next up rasterizing the CBS shapes over the images


#Next up rasterizing the bgt shapes over the images


#Next up adding the altitude as layer in the image






