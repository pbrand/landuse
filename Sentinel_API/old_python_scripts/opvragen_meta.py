
import requests
import json
import getpass
import sys
from pathlib import Path

user = "kloetq"
pswd ='Datalab1'

Folder = '/home/datalab/Documenten/Datalab/output/'



def opvragen_json(url):
  r=requests.get(url,auth=(user,pswd))
  return json.loads(r.text)

Filter = '&$filter= year(ContentDate/End) eq 2018 and month(ContentDate/End) eq 1'

geojson = {'type':'FeatureCollection', 'features':[]}
geojson2= {'type':'FeatureCollection', 'features':[]}

data  = opvragen_json("https://scihub.copernicus.eu/dhus/odata/v1/Products?$format=json"+Filter+"&$inlinecount=allpages&$top=10")
Total = int(data['d']['__count'])
