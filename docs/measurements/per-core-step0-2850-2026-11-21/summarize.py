from pathlib import Path
import csv,re,collections,statistics as st,sys
d=Path(__file__).resolve().parent
samples=[]; intervals=[]
for label,folder in [('flat dictionary',d/'results'),('vector lookup',d/'collected/vector'),('distant operands',d/'collected/far'),('window storage',d/'collected/inputs'),('row emission',d/'collected/emission')]:
 v=collections.defaultdict(list); expected=collections.defaultdict(list)
 for f in sorted(folder.glob('*.txt')):
  g,cache,r,pos,m=f.stem.split('-');text=f.read_text()
  row=re.search(r'^time\tthis path\tper taken node: ticks ([\d.]+) cycles ([\d.]+) instructions ([\d.]+) mispredicted branches ([\d.]+)\tfirst pass: cycles ([\d.]+)',text,re.M)
  if row is None: continue
  take=re.search(r'^taken\texpressions=(\d+) of (\d+)\tnodes=(\d+) .*?the first path.s nodes=(\d+).*?expressions=(\d+) nodes=(\d+)\tby this one alone=(\d+)',text,re.M)
  check=re.search(r'^checked\tthe first path: emitted=(\d+) wrong-expressions=0 wrong-entries=0\tthis path: emitted=(\d+) wrong-expressions=0 wrong-entries=0',text,re.M)
  assert take and check and int(take[7])==0 and 'facts differing from the truth=0' in text and 'contexts or targets differing from the truth=0' in text and 'templates differing from the first path\'s=0' in text
  expected[label,g,cache,r].append((int(pos),m))
  obs=[float(x) for x in row.groups()];samples.append([label,g,cache,int(r),int(pos),m,*obs,*take.groups(),*check.groups()])
  v[g,cache,m,int(r)].append(obs)
 ref='fargather' if label=='window storage' else 'scratchfargather' if label=='row emission' else 'lanes'
 for k,group in expected.items():
  order=[t[1] for t in sorted(group)];assert order==order[::-1] and all(order.count(name)==2 for name in order),(k,order)
 for g,cache,m,r in sorted(v):
  if r!=1:continue
  av=[[st.mean(x[i] for x in v[g,cache,m,n]) for i in range(5)] for n in range(1,4)]
  bv=[[st.mean(x[i] for x in v[g,cache,ref,n]) for i in range(5)] for n in range(1,4)]
  for i,key in enumerate(['ticks','cycles','instructions','branch misses','first pass cycles']):
   ds=[a[i]-b[i] for a,b in zip(av,bv)]
   o=[label,g,cache,m,ref,key,st.median(a[i] for a in av),st.median(ds),min(ds),max(ds),sum(n<0 for n in ds)];intervals.append(o)
   if i==1:print(label,g,cache,m,round(o[6],3),round(o[7],3))
for filename,head,rows in [('samples.tsv',['experiment','corpus','cache','round','position','mode','ticks/node','cycles/node','instructions/node','mispredictions/node','first pass cycles/node','taken roots','all roots','taken nodes','scalar nodes','scalar-only roots','scalar-only nodes','vector-only roots','scalar entries','candidate entries'],samples),('paired.tsv',['experiment','corpus','cache','mode','reference','metric per taken node','median absolute','median paired difference','minimum delta','maximum delta','lower pairs'],intervals)]:
 with (d/filename).open('w') as f:
  w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(head);w.writerows(rows)
