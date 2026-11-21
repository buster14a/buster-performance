from pathlib import Path
import csv,sys,statistics as st,collections
def summarize(root):
 d=Path(root)
 for c,den in [('sqlite',716136),('main',2433563)]:
  rows=collections.defaultdict(list);hashes=set()
  for f in d.glob(c+'-*.stat'):
   r=int(f.stem.split('-')[1]);mode=f.stem.split('-')[-1];m={}
   try:
    for row in csv.reader(f.open()):
     if len(row)>4:m[row[2]]=float(row[0])
    assert 'cycles:k' in m
    hashes.add(f.with_suffix('.sha').read_text().split()[0])
   except (IndexError,ValueError,AssertionError,FileNotFoundError):continue
   rows[r,mode].append([m['instructions:u'],m['cycles:u']+m['cycles:k'],m['minor-faults']])
  modes=set(k[1] for k in rows)
  print(c,'elfs',len(hashes))
  for a,b in [('own','base'),('own','off'),('off','base')]:
   if {a,b}<=modes:
    diff=[]
    for r in [1,2,3]:
     if len(rows[r,a])!=2 or len(rows[r,b])!=2:continue
     diff.append([st.mean(x)-st.mean(y) for x,y in zip(zip(*rows[r,a]),zip(*rows[r,b]))])
    print(a,b,'n',len(diff),'insn/cycles/faults', [st.median(x) for x in zip(*diff)])
for root in sys.argv[1:]: print(root);summarize(root)
