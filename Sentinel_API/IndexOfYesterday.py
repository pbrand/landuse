#################################################
with open("Output.txt","a") as f:
    f.write("Starting IndexOfYeasterday at: "+str(datetime.datetime.now())+'\n')
#################################################
#This code cannot be run without first importing the packages and functions needed (is done in InfiniteWhileLoop)
#################################################

#Set the date (As today is nog yet completed use an offset of 1 day)
Today  = datetime.date.today()
Offset = datetime.timedelta(days=1) 

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
                      'Xmin':           Coordinaten[0],
                      'Xmax':           Coordinaten[1],
                      'Ymin':           Coordinaten[2],
                      'Ymax':           Coordinaten[3]})
        
    skip=skip+100

print('')
print('Done!')

with open("db/Index.csv","a") as f:
    for el in Index:
        f.write(el['SentinalType'])
        for t in ['ID','DatumTijd','Xmin','Xmax','Ymin','Ymax']:
            f.write(','+str(el[t]))
        f.write('\n')

with open("Output.txt","a") as f:
    f.write("Finished running at: "+str(datetime.datetime.now())+"\n\n")
