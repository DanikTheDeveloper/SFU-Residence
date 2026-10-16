import math,json,urllib.request
from urllib.parse import urlencode
from pathlib import Path
# Standard Transverse Mercator forward series, GRS80/NAD83 UTM zone 10.
def utm(lon,lat):
 a=6378137.; f=1/298.257222101; e=f*(2-f); ep=e/(1-e)
 p=math.radians(lat); l=math.radians(lon+123); sn=math.sin(p); co=math.cos(p); t=math.tan(p)**2; c=ep*co**2; A=co*l; n=a/math.sqrt(1-e*sn*sn)
 m=a*((1-e/4-3*e**2/64-5*e**3/256)*p-(3*e/8+3*e**2/32+45*e**3/1024)*math.sin(2*p)+(15*e**2/256+45*e**3/1024)*math.sin(4*p)-35*e**3/3072*math.sin(6*p))
 return (500000+.9996*n*(A+(1-t+c)*A**3/6+(5-18*t+t*t+72*c-58*ep)*A**5/120),.9996*(m+n*math.tan(p)*(A*A/2+(5-t+9*c+4*c*c)*A**4/24+(61-58*t+t*t+600*c-330*ep)*A**6/720)))
if __name__=='__main__':
 lo=utm(-122.934,49.2775); hi=utm(-122.921,49.283);print(lo,hi,flush=True)
 p={'f':'json','where':'1=1','geometry':','.join(map(str,lo+hi)),'geometryType':'esriGeometryEnvelope','inSR':26910,'outFields':'OBJECTID,Elevation','returnGeometry':'true'}
 url='https://gis.burnaby.ca/arcgis/rest/services/BurnabyMap/BBY_PUBLIC_TOC/MapServer/5/query?'+urlencode(p)
 raw=urllib.request.urlopen(url,timeout=40).read();d=json.loads(raw);print(len(raw),len(d.get('features',[])),d.get('error'),d.get('exceededTransferLimit'),flush=True)
 if d.get('features'):Path('data/terrain_sources/contours_native.json').write_bytes(raw)
