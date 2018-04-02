#Download the packages needed
import requests
import os
from zipfile import ZipFile
    
#################################################

def download_file(ID,Folder):
    url  = "https://scihub.copernicus.eu/dhus/odata/v1/Products('"+ID+"')/$value"
    File = Foler+ID+"/"
    Temp = Folder+"temp.zip"
    r = requests.get(url,auth=(user,pswd))
    with open(Temp,"wb") as f:
        f.write(r.content)
    with ZipFile(Temp,"r") as f:
        f.extractall(File)
    os.remove(Temp)
    
