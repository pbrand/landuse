#Download the packages needed
import sys
import requests
import json
import getpass
import datetime
#Set username and password
user = "kloetq"
pswd = getpass.getpass("Password of "+user+": ") #Datalab1

#################################################
def opvragen_json(url):
    r=requests.get(url,auth=(user,pswd))
    return json.loads(r.text)

def CalculateCoordinates(x):
    if x is None:
        res = ["NA","NA","NA","NA"]
    else:
        x1 = x.find('<gml:coordinates>')
        x2 = x.find('</gml:coordinates>')
        x  = x[x1+len('<gml:coordinates>'):x2]
        x=x.split(' ')
        y1=list()
        y2=list()
        for el in x:
            b = el.split(',')
            y1.append(float(b[0]))
            y2.append(float(b[1]))
        res = [min(y1),max(y1),min(y2),max(y2)]
    return(res)
##################################################


OldDate = datetime.date.today() - datetime.timedelta(days=2)
with open("db/Index.csv","w") as f:
    f.write("SentinalType")
    for t in ['ID','DatumTijd','Xmin','Xmax','Ymin','Ymax']:
        f.write(','+t)
    f.write('\n')
with open("Output.txt","w") as f:
    f.write("Starting InifiniteWhileLoop at: "+str(datetime.datetime.now())+'\n\n')

while 1>0:
    if datetime.date.today()!=OldDate:
        if datetime.datetime.now().time()>datetime.time(7):
            exec(open('IndexOfYesterday.py').read())
            OldDate = datetime.date.today()

rm(pswd)