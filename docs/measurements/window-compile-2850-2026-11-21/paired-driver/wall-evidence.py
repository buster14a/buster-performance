from pathlib import Path
from statistics import median
import csv,re,sys
root,dest=map(Path,sys.argv[1:3]); control=sys.argv[3] if len(sys.argv)>3 else 'parent'
rounds=int(sys.argv[4]) if len(sys.argv)>4 else 7
buckets={};digests=set(); dest.mkdir(parents=True,exist_ok=True)
with (dest/'wall.tsv').open('w') as out:
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow(['round','position','mode','milliseconds','object-sha256'])
 for f in sorted(root.glob('*.log'),key=lambda f:tuple(map(int,f.stem.split('-')[1:]))):
    tag,n,pos=f.stem.split('-');n,pos=int(n),int(pos)
    text=f.read_text()
    samples=re.findall(r'^run 1 list 1[^\n]*?: ([\d.]+) ms wall,',text,re.M)
    assert len(samples)==1,(f,samples,text[:1000])
    digest=f.with_suffix('.sha256').read_text().strip()
    digests.add(digest); val=float(samples[0]);buckets.setdefault((tag,n),[]).append(val)
    w.writerow([n,pos,tag,val,digest])
assert len(digests)==1 and len(buckets)==3*rounds and all(len(vals)==2 for vals in buckets.values())
means={k:sum(a)/len(a) for k,a in buckets.items()}
for group in [control,'off','on']:
 v=median(means[group,n] for n in range(1,rounds+1)); print(group,'wall ms',v,'MB/s',9507.037/v)
for a,b in [('on','off'),('on',control),('off',control)]:
 ds=[means[a,n]-means[b,n] for n in range(1,rounds+1)]
 print('delta',a,b,[round(f(ds),5) for f in [median,min,max]])
