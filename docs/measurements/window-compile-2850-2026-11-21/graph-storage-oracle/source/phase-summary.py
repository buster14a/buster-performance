from pathlib import Path
from statistics import median
import subprocess,re,json,sys
p=Path(sys.argv[1]); keys='usercycles instructions minorfaults userus sysus'.split(); rows={}
for f in sorted(p.glob('*-*.log')):
  a,b=f.stem.split('-')
  row=dict(re.findall(r'(\w+)=(\w+)',next(l for l in f.read_text().splitlines() if l.startswith('storage-phase:'))))
  val={k:int(row[k]) for k in keys}
  assert 'values=0 diagnostics=0 warnings=0 conversions=0 member-offsets=0' in f.read_text()
  rows[(int(a),b)]=val
assert len(rows)==14
result={}
for k in keys:
  a=[rows[(i,'identity')][k] for i in range(1,8)];b=[rows[(i,'pack')][k] for i in range(1,8)]
  dif=[y-x for x,y in zip(a,b)]; result[k]=dict(identity=median(a),pack=median(b),delta=median(dif),minimum=min(dif),maximum=max(dif))
print(json.dumps(result,indent=2))
