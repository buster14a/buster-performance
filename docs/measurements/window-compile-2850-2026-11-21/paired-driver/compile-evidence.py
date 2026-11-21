from pathlib import Path
from statistics import median
from itertools import product
import csv,hashlib,re,sys
root,out=map(Path,sys.argv[1:3]); out.mkdir(parents=True,exist_ok=True)
control=sys.argv[3] if len(sys.argv)>3 else 'parent'
data={}; hashes=set(); obj_sizes=set()
with (out/'pmu.tsv').open('w') as f:
 wr=csv.writer(f,delimiter='\t',lineterminator='\n'); wr.writerow(['round','position','mode','user-cycles','kernel-cycles','user-instructions','kernel-instructions','task-ms','page-faults','context-switches','cpu-migrations','object-bytes','object-sha256'])
 for p in sorted((root/'real').glob('*.perf'),key=lambda p:tuple(map(int,p.stem.split('-')[1:]))):
    mode,n,pos=p.stem.split('-'); n,pos=map(int,(n,pos)); rows=[line.split(',') for line in p.read_text().splitlines() if ',' in line]
    events={row[2]:float(row[0]) for row in rows}
    assert len(events)==9 and all(float(row[4])==100 for row in rows), p
    assert not p.with_suffix('.stderr').read_bytes() and not p.with_suffix('.stdout').read_bytes(),p
    h=p.with_suffix('.sha256').read_text().strip(); size=int(p.with_suffix('.bytes').read_text())
    hashes.add(h);obj_sizes.add(size)
    vec=[events[e] for e in ['cycles:u','cycles:k','instructions:u','instructions:k','task-clock','page-faults','context-switches','cpu-migrations']]
    wr.writerow([n,pos,mode,*[int(v) if i!=4 else v for i,v in enumerate(vec)],size,h])
    data.setdefault((mode,n),[]).append(vec)
 assert len(data)==21 and all(len(x)==2 for x in data.values())
def means(mode,n):
    return [sum(col)/len(col) for col in zip(*data[mode,n])]
def cycles(mode,n):
    return sum(means(mode,n)[:2])/716136
print('object',hashes,obj_sizes);assert len(hashes)==len(obj_sizes)==1
for mode in [control,'off','on']:
    samples=[cycles(mode,n) for n in range(1,8)]
    print(mode,'user/kernel combined cycles/token min median max',*[round(f(samples),4) for f in [min,median,max]],'median group',*[round(median(v),2) for v in zip(*(means(mode,n) for n in range(1,8)))])
for a,b in [('on','off'),('on',control),('off',control)]:
    deltas=[cycles(a,n)-cycles(b,n) for n in range(1,8)]
    print(a,'minus',b, 'cycles/token min median max',*[round(f(deltas),4) for f in [min,median,max]])
