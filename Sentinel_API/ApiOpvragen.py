#om de directory in te stellen gebruik: cd ~/Documenten/Datalab
#om te runnen in het commad prompt:     python3 ApiOpvragen.py
#runnen binnen python3:                 exec(open('ApiOpvragen.py').read())


#############################################################


#S1
#https://scihub.copernicus.eu/dhus/odata/v1/Products('d1ea4951-2ba2-4d3b-ac15-6b4d8bfd60f2')/$value
#https://scihub.copernicus.eu/dhus/odata/v1/Products('d1ea4951-2ba2-4d3b-ac15-6b4d8bfd60f2')/$value

#S2
#https://scihub.copernicus.eu/dhus/odata/v1/Products('e843f77e-6a81-47a2-b109-fd7700bbf46e')/$value
#https://scihub.copernicus.eu/dhus/odata/v1/Products('b2f82b29-1ce8-46f0-be14-7e7a4e6bb7ac')/$value





###############################################################



import requests
import json
import getpass
import sys
from pathlib import Path

user = "kloetq"
pswd = getpass.getpass("Password of "+user+": ") #Datalab1

Folder = '/home/datalab/Documenten/Datalab/output/'



def opvragen_json(url):
    r=requests.get(url,auth=(user,pswd))
    return json.loads(r.text)

Filter = '&$filter= year(ContentDate/End) eq 2018 and month(ContentDate/End) eq 1'

geojson = {'type':'FeatureCollection', 'features':[]}
geojson2= {'type':'FeatureCollection', 'features':[]}

data  = opvragen_json("https://scihub.copernicus.eu/dhus/odata/v1/Products?$format=json"+Filter+"&$inlinecount=allpages&$top=10")
Total = int(data['d']['__count'])

print('Het totaal aantal is: '+str(Total))

skip = 0

while skip<Total:
    perc = str(round(100*skip/Total,3))
    sys.stdout.write('\rNow at: {0}% of the total. Skip equals: {1}'.format(' '*int(5-len(perc))+perc,' '*int(6-len(str(skip)))+str(skip)))
    sys.stdout.flush()
    
    data = opvragen_json("https://scihub.copernicus.eu/dhus/odata/v1/Products?$format=json"+Filter+"&$skip="+str(skip)+"&$top=100")

    for x in data['d']['results']:
        URL = x['__metadata']['uri']
        Id  = x['Id']
        
        #Add the photo to the folder
        #url = URL + "/Products('Quicklook')/$value"
        #r=requests.get(url,auth=(user,pswd))
        
        feature = {'type':'Feature',
                   'properties':{},
                   'geometry':{'type':'LineString',
                               'coordinates':[]}}
        tt = x['ContentGeometry']
        if tt is None:
            with open(Folder+'Errors_2018_01.txt','a') as f:
                f.write('No Geometry found for Id: '+Id+'\n')
            continue
        
        x1 = tt.find('<gml:coordinates>')
        x2 = tt.find('</gml:coordinates>')
        a  = tt[x1+len('<gml:coordinates>'):x2]
        a=a.split(' ')
        if a[-1]!=a[0]:
            a.append[a[0]]
        b=list()
        for el in a:
            tt = el.split(',')
            b.append([float(tt[1]),float(tt[0])])
        feature['geometry']['coordinates'] = b
        
        
        feature['properties']['url']       = URL
        feature['properties']['Id']        = Id

        #if r.status_code ==200:
        #    file = Folder+Id+'.jpg'
        #    if not(Path(file).exists()):
        #        with open(file, 'wb') as f_out:
        #            r.raw.decode_content = True
        #            for chunk in r.iter_content(1024):
        #                f_out.write(chunk)       
        #    geojson['features'].append(feature)
                        
        #else:
        #    with open(Folder+'Errors.txt','a') as f:
        #        f.write('No Quickvieuw found for Id: '+Id+'\n')
        #    geojson2['features'].append(feature)
        geojson['features'].append(feature)
    skip=skip+100
    
del pswd

print('Done!')

        
with open(Folder+'VieuwAllShapes_2018_01.geojson','w') as f:
    f.write(json.dumps(geojson))
      
with open(Folder+'NoQuickvieuw_2018_01.geojson','w') as f:
    f.write(json.dumps(geojson2))
