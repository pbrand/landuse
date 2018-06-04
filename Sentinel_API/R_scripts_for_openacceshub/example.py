import sentinelhub

y1, x1, y2, x2 = [52.23802, 4.83122, 52.2844, 4.8851]
date_earliest = '2017-05-24'
date_latest = '2017-05-30'
width = 800
height = 800
data_folder = '/Users/patrick/Desktop/Sentinel-Hub'
satellite_id='SENTINEL1'

success = Sentinel_Hub.save_sentinel_patch(x1, x2, y1, y2,
                              date_earliest, date_latest, 
                              width, height,
                              data_folder, satellite_id)
print('Did it work??: ', 'Yes' if success else 'No')
