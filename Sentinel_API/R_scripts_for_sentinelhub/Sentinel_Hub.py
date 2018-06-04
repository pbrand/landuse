import argparse
import numpy as np
from sentinelhub import WmsRequest, MimeType, CRS, BBox, CustomUrlParam

from sentinelhub.constants import MimeType 

INSTANCE_ID = "390ee32f-87f7-4536-ac56-5ddce307ff00"

def save_sentinel_patch(x1, x2, y1, y2,
                        date_earliest, date_latest, 
                        width, height,
                        data_folder, satellite_id='L2A'):
    ''' Little utility function that sends a request to sentinel-hub to extract a patch from sentinel1 or sentinel2 data.
        The returned patch is stored in .tiff format.
        
        Parameters:
        x1, x2, y1, y2:                         Are used to create a boundingbox in WGS84 format.
        date_earliest, date_latest:             Create the time window of which the newest image is requested. Format: %Y-%m-%d.
        width, height:                          The width and height in pixels of the patch.
        data_folder:                            The path to where the image will be stored.
        satellite_id:                           Should be one of the following: [L2A, L1C, SENTINEL1] 
                                                (corresponding layers are created in the sentinel-hub configuration tool) '''
    box_coords_wgs84 = [y1, x1, y2, x2]
    bbox = BBox(bbox=box_coords_wgs84, crs=CRS.WGS84)

    if satellite_id == 'L2A':
        layer = 'ALL-BANDS-L2A'
    elif satellite_id == 'L1C':
        layer = 'ALL-BANDS-L1C'
    elif satellite_id == 'SENTINEL1':
        layer = 'SENTINEL1'
    else:                                  # No Valid satellite source was given. 
        return False 
    
    wms_bands_request = WmsRequest(data_folder=data_folder,
                                   layer=layer,
                                   bbox=bbox, 
                                   time=(date_earliest, date_latest),
                                   width=width, height=height,
                                   image_format=MimeType.TIFF_d32f,
                                   instance_id=INSTANCE_ID,
                                   custom_url_params={CustomUrlParam.ATMFILTER: 'ATMCOR',
                                                      CustomUrlParam.TRANSPARENT: True,
                                                      CustomUrlParam.SHOWLOGO: False}
                                   )
    
    wms_img = wms_bands_request.get_data(save_data=True)
    print(wms_img)
    if not wms_img: # Image extraction Failed.
        return False
    else:
        return True            # Image succesfully extracted.


# Create a parser and define command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument('x1', help='x-coordinate of bottom-left box point', type=float)
parser.add_argument('y1', help='y-coordinate of bottom-left box point', type=float)
parser.add_argument('x2', help='x-coordinate of top-right box point', type=float)
parser.add_argument('y2', help='y-coordinate of top-right box point', type=float)

parser.add_argument('date_earliest', help='Beginning of time window', type=str)
parser.add_argument('date_latest', help='End of time window', type=str)

parser.add_argument('width', help='width of patch in pixels', type=int)
parser.add_argument('height', help='height of patch in pixels', type=int)

parser.add_argument('data_folder', help='folder to store the requested image in', type=str)
parser.add_argument('satellite_id', help='Should be one of the following: [L2A, L1C, SENTINEL1]')

# Parse values from command-line arguments
args = parser.parse_args()

x1, x2, y1, y2 = [args.x1, args.x2, args.y1, args.y2]
date_earliest, date_latest = [args.date_earliest, args.date_latest]
width, height = [args.width, args.height]
data_folder = args.data_folder
satellite_id = args.satellite_id

succeeded = save_sentinel_patch(x1, x2, y1, y2,
                                date_earliest, date_latest, 
                                width, height,
                                data_folder, satellite_id)

print('Extraction succesful?: ', 'Yes' if succeeded else 'No')
