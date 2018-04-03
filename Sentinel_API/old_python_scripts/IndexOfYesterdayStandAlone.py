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
        res = {"MinMax" : ["NA","NA","NA","NA"],
               "Polygon":  "NA"}
    else:
        x1 = x.find('<gml:coordinates>')
        x2 = x.find('</gml:coordinates>')
        x  = x[x1+len('<gml:coordinates>'):x2]
        x=x.split(' ')
        y1=list()
        y2=list()
        y =list()
        for el in x:
            b = el.split(',')
            y1.append(float(b[0]))
            y2.append(float(b[1]))
            y.append([float(b[0]),float(b[1])])
        res = {"MinMax"  : [min(y1),max(y1),min(y2),max(y2)],
               "Polygon" :  y}
    return(res)
##################################################

#Set the date (As today is nog yet completed use an offset of 1 day)
Today  = datetime.date.today()
Offset = datetime.timedelta(days=0) 

Filter = "&$filter= year(ContentDate/End) eq " + str((Today-Offset).year)  + \
             " and month(ContentDate/End) eq " + str((Today-Offset).month) + \
               " and day(ContentDate/End) eq " + str((Today-Offset).day)

data  = opvragen_json("https://scihub.copernicus.eu/dhus/odata/v1/Products?$format=json"+Filter+"&$inlinecount=allpages&$top=10")
Total = int(data['d']['__count'])

Index=list()

print('The amount of products is: '+str(Total))

skip = 0
while skip<Total:
    perc = str(round(100*skip/Total,3))
    sys.stdout.write('\rNow at: {0}% of the total. Skip equals: {1}'.format(' '*int(5-len(perc))+perc,' '*int(6-len(str(skip)))+str(skip)))
    sys.stdout.flush()
    
    data = opvragen_json("https://scihub.copernicus.eu/dhus/odata/v1/Products?$format=json"+Filter+"&$skip="+str(skip)+"&$top=100")
    for x in data['d']['results']:
        SentinalType = x['Name'][0:2]
        Id           = x['Id']
        DatumTijd    = datetime.datetime.fromtimestamp(int(x['ContentDate']['End'][6:-5]))
        Coordinaten  = CalculateCoordinates(x['ContentGeometry'])
        
        Index.append({'SentinalType':   SentinalType,
                      'ID':             Id,
                      'DatumTijd':      DatumTijd,
                      'Coordinaten':    Coordinaten["Polygon"],
                      'Xmin':           Coordinaten["MinMax"][0],
                      'Xmax':           Coordinaten["MinMax"][1],
                      'Ymin':           Coordinaten["MinMax"][2],
                      'Ymax':           Coordinaten["MinMax"][3]})
        
    skip=skip+100

print('')
print('Done!')

#write to csv/database

#with open("db/Index.csv","a") as f:
#    for el in Index:
#        f.write(el['SentinalType'])
#        for t in ['ID','DatumTijd','Xmin','Xmax','Ymin','Ymax']:
#            f.write(','+str(el[t]))
#        f.write('\n')
