from collections import defaultdict
from pathlib import Path
from statistics import median
import csv
import sys
root=Path(sys.argv[1])
prefix=sys.argv[2]
records={}
for f in sorted(root.glob(prefix+'-*.stat')):
    project,round_number,build,workload=f.stem.split('-',3)
    counters={}
    for line in f.read_text().splitlines():
        if ';' in line:
            value,unit,event,*rest=line.split(';')
            counters[event]=value
    for ext in ['sha256','bytes']:
        counters[ext]=(root/(f.stem+'.'+ext)).read_text().strip()
    lines=(root/(f.stem+'.load')).read_text().splitlines()
    for key,index in [('begin',0),('end',2),('load1_before',1),('load1_after',3)]:
        counters[key]=lines[index].split()[0]
    records[(workload,int(round_number),build)]=counters
cols=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock','bytes','sha256','begin','end','load1_before','load1_after']
with open(sys.argv[3],'w') as out:
    writer=csv.writer(out,delimiter='\t',lineterminator='\n')
    writer.writerow(['workload','round','variant',*cols])
    for (name,r,b),m in sorted(records.items()):
        writer.writerow([name,r,b,*[m[c] for c in cols]])
for name in sorted({k[0] for k in records}):
    rounds=sorted({r for (n,r,b) in records if n==name and r>0 and (n,r,'base') in records and (n,r,'head') in records})
    print(name,len(rounds),'pairs',end=' ')
    if not rounds:
        print()
        continue
    for metric in ['instructions:u','cycles:u','task-clock']:
        base=[float(records[name,r,'base'][metric]) for r in rounds]
        head=[float(records[name,r,'head'][metric]) for r in rounds]
        ratios=[(b/a-1)*100 for a,b in zip(base,head)]
        print(f'{metric} {median(base):.2f}->{median(head):.2f} {median(ratios):+.3f}% [{min(ratios):+.2f},{max(ratios):+.2f}]',end='; ')
    digests={records[name,r,b]['sha256'] for r in rounds for b in ['base','head']}
    print('digests',len(digests))
