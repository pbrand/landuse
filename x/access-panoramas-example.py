
# coding: utf-8

# # Accessing the Datapunt Amsterdam Panorama API
# 
# Below a small example script that grabs a random sample of panoramas from the Datapunt Amsterdam Panorama data set.

# In[1]:


import random
import os
import sys
import requests
import json

API_URL = 'https://api.data.amsterdam.nl/panorama'
ENDPOINT = '/recente_opnames/2017/'

# Set the following to an appropriate value:
#TARGET_PATH = '/Users/data/Documents/FotosAmsterdam/' # note the slash at the end
TARGET_PATH = '/media/datalab/Seagate Expansion Drive/FotosAmsterdam'

# In[ ]:
def progressBar(value,endvalue,idx):
    bar_length=25
    percent = float(value)/endvalue
    arrow   = '-'*int(round(percent*bar_length)-1)+'>'
    spaces1 = ' '*int(bar_length-len(arrow))
    spaces2 = ' '*int(len(str(endvalue))-len(str(value)))
    spaces0 = ' '*int(7-len(str(idx)))
    
    sys.stdout.write('\rIdx: {0} [{1}] Currently at panorama {2} out of {3}'.format(spaces0+str(idx),arrow+spaces1,spaces2+str(value),str(endvalue)))
    sys.stdout.flush()
    

def check_how_many(url):
    """
    Access HAL-JSON count from first results page in API.
    """
    results = requests.get(url)
    data = json.loads(results.text)
    return data['count']

def get_panorama_detail(dataset_url, n):
    """
    Grab the n-th panorama in the dataset.
    """
    parameters = {
        'page_size': 1,
        'page': n
    }
    
    r = requests.get(dataset_url, params=parameters)
    data = json.loads(r.text)
    return data['results'][0]

def grab_panoramas(n=300000):
    """
    Randomly sample n panoramas from the panorama dataset.
    """
    dataset_url = API_URL + ENDPOINT
    print('Randomly sampling {} panoramas.'.format(n))
    n_panoramas = check_how_many(dataset_url)
    print('There are {} panoramas int the {} dataset.'.format(n_panoramas, dataset_url))
    assert n <= n_panoramas
    
    # Determine which panoramas to access:
    # random.seed(10) # uncomment for deterministic behavior (handy for debugging)
    indices = list(range(1, n_panoramas + 1)) # not zero based indexing
    random.shuffle(indices)
    to_access = indices[0:n]
    
    # Access the panoramas and download the 2000px equirectangular projected image.
    print('Downloading to {} ...'.format(TARGET_PATH))
    for i, idx in enumerate(to_access):
        #if i % 100 == 0:
        #    print('Currently at panorama {} out of {}'.format(i, n))
        progressBar(i,n,idx)
        if os.path.exists(os.path.join(TARGET_PATH, "Foto"+str(idx)+".jpg")):
            continue
        details = get_panorama_detail(dataset_url, idx)
        image_url = details['image_sets']['equirectangular']['small']
        
        #print(idx)
        download(TARGET_PATH, image_url,"Foto"+str(idx)+".jpg")
    print('Done donwloading.')


def download(TARGET_PATH, image_url,name):
    """
    Download and save a panorama file, in directory structure mimicking url structure.
    """
    assert TARGET_PATH # be sure to set the path to download to, otherwise we crash here!
    if not os.path.exists(TARGET_PATH):
        os.makedirs(TARGET_PATH)
        
    r = requests.get(image_url)
    assert r.status_code == 200
    
    target_image_path = os.path.join(TARGET_PATH, name)
    #print('Downloading to: ', target_image_path)
    with open(target_image_path, 'wb') as f_out:
        r.raw.decode_content = True
        for chunk in r.iter_content(1024):
            f_out.write(chunk)

def main():
    grab_panoramas()

main()
