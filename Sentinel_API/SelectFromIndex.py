#Download the packages needed
import sys
import csv
import requests
import json
import getpass
import datetime
import os
from zipfile import ZipFile
    
#################################################

#Set username and password
user = "kloetq"
pswd = getpass.getpass("Password of "+user+": ") #Datalab1

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
    
##################################################
#import the current index
IndexS1 = {}
IndexS2 = {}
IndexS3 = {}
with open("db/Index.csv") as file:
    reader = csv.DictReader(file,delimiter=',')
    for row in reader:
        if row['SentinalType']=="S1":
            IndexS1[row['ID']] = [float(row["Xmin"]),float(row["Xmax"]),float(row["Ymin"]),float(row["Ymax"])]
        elif row['SentinalType']=="S2":
            IndexS2[row['ID']] = [float(row["Xmin"]),float(row["Xmax"]),float(row["Ymin"]),float(row["Ymax"])]
        else:
            IndexS3[row['ID']] = [float(row["Xmin"]),float(row["Xmax"]),float(row["Ymin"]),float(row["Ymax"])]


def select_geom(Xmin,Xmax,Ymin,Ymax,Index):
    res = list()
    for el in Index:
        coordinates = Index[el]
        if 


with open("db/Output.txt","w") as f:
    f.write("Starting InifiniteWhileLoop at: "+str(datetime.datetime.now())+'\n\n')

while 1>0:
    if datetime.date.today()!=OldDate:
        if datetime.datetime.now().time()>datetime.time(7):
            exec(open('IndexOfYesterday.py').read())
            OldDate = datetime.date.today()

rm(pswd)
