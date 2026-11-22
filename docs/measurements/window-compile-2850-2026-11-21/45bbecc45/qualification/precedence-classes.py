from pathlib import Path
import collections,csv,subprocess
s=Path(__file__).resolve().parent;w=s.parent
exe=w/'fixed-parser-parents/build/compiler';d=s/'key-blocks'
sym=subprocess.check_output(['nm','-S',exe],text=True);seg=subprocess.check_output(['readelf','-Wl',exe],text=True)
segments=[tuple(int(row.split()[n],16) for n in [1,2,4]) for row in seg.splitlines() if row.strip().startswith('LOAD')]
tables=[]
with exe.open('rb') as f:
 for name in ['levels','left_thresholds','right_thresholds','rules']:
  addr,sz=next((int(r.split()[0],16),int(r.split()[1],16)) for r in sym.splitlines() if r.endswith(' parse_role_'+name));off,start,length=next((o,a,l) for o,a,l in segments if a<=addr and addr+sz<=a+l);f.seek(off+addr-start);tables.append(f.read(sz))
raw=list(zip(*tables));unique=sorted(set(raw));keys=bytes(unique.index(x) for x in raw)+bytes(256-len(raw))
with (s/'precedence-class-census.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','tokens','roles','exact-k4-classes','block-width','complete-blocks','distinct-contexts','duplicated-blocks','top16-coverage','top256-coverage','top1024-coverage'])
 for name in ['sqlite','main']:
  role=(d/(name+'.roles')).read_bytes();depth=(d/(name+'.depths')).read_bytes();cls=role.translate(keys);n=len(role)
  for k in [8,16,32,64,128,256]:
   hist=collections.Counter()
   for i in range(0,n-k+1,k):
    dep=depth[i:i+k];m=min(dep);hist[(cls[i:i+k],bytes(x-m for x in dep))]+=1
   v=sorted(hist.values(),reverse=True);t.writerow([name,n,len(raw),len(unique),k,n//k,len(hist),n//k-len(hist),*[sum(v[:j]) for j in [16,256,1024]]])
