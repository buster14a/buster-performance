from pathlib import Path
import csv,statistics as st,re,io,tarfile,hashlib,shutil
from collections import defaultdict
d=Path(__file__).resolve().parent;w=d.parent
raw=d/'raw/results'
p=raw/'step1-fact-batches';out=w/'perf/docs/measurements/per-core-step1-2850-2026-11-21/fact-lookups'
out.mkdir(exist_ok=True,parents=True)
data=defaultdict(list);cases=defaultdict(list);oracles=defaultdict(set);samples=[];summary=[]
labels=['main3257','factsstride','factsmember']
def write(name,head,rows):
 with (out/name).open('w') as f:
  cw=csv.writer(f,delimiter='\t',lineterminator='\n');cw.writerow(head);cw.writerows(rows)
with tarfile.open(out/'measurements.tar.xz','w:xz') as archive:
 for f in sorted(p.glob('*.txt')):
  g,mode,rd,pos,label=f.stem.split('-'); rd=int(rd);pos=int(pos)
  log=f.read_text();text='\n'.join(l for l in log.splitlines() if l.startswith(('node-','measure-node-machine:')))+'\n'
  bs=text.encode();ti=tarfile.TarInfo(f.name);ti.size=len(bs);archive.addfile(ti,io.BytesIO(bs))
  row=re.search(r'^node-facts: the kernel a taken leaf or lookup: cycles=([\d.]+) instructions=([\d.]+) mispredicted-branches=([\d.]+)',text,re.M)
  ck=re.search(r'^node-facts: taken identifiers=(\d+) \([\d.]+%\) lookups=(\d+) \([\d.]+%\) differences=0 list-differences=0 failures=0 \(differences over decoys 0\)',text,re.M)
  assert row and ck, f
  oracles[g,mode].add(ck.groups()); cases[g,mode,rd].append((pos,label));vals=list(map(float,row.groups()))
  data[g,mode,rd,label].append(vals);samples.append([g,mode,rd,pos,label,*ck.groups(),*vals])
assert len(samples)==108 and all(len(v)==1 for v in oracles.values())
for k,val in cases.items():
 ls=[l for _,l in sorted(val)];assert ls==ls[::-1] and sorted(ls)==sorted(labels*2)
for g,mode in sorted(oracles):
 for l in labels:
  for i,metric in enumerate(('cycles','instructions','branch misses')):
   val=[st.mean(x[i] for x in data[g,mode,r,l]) for r in range(1,4)]
   ref=[st.mean(x[i] for x in data[g,mode,r,labels[0]]) for r in range(1,4)]
   diff=[x-y for x,y in zip(val,ref)]
   summary.append([g,mode,l,metric,st.median(val),st.median(diff),min(diff),max(diff),sum(x<0 for x in diff)])
   if i==0: print(g,mode,l,round(st.median(val),3),round(st.median(diff),3))
write('samples.tsv',['input','kernel','round','position','build','taken identifiers','taken lookups','cycles/taken','instructions/taken','branch misses/taken'],samples)
write('paired.tsv',['input','kernel','build','metric per taken record','median','paired difference','minimum difference','maximum difference','lower rounds'],summary)
for l,patch in [('factsstride',w/'fact-batch-study/stride.patch'),('factsmember',w/'fact-member-study/members.patch')]:
 rev=(raw/l/'revision.txt').read_text().splitlines();assert rev[0]=='f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae' and rev[1].split()[0]==hashlib.sha256(patch.read_bytes()).hexdigest()
 shutil.copy(patch,out)
write('builds.tsv',['label','source','patch hash','compiler hash'],[[l,'f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae',(raw/l/'revision.txt').read_text().splitlines()[-1].split()[0] if l!=labels[0] else 'none',(raw/l/'compiler.sha256').read_text().split()[0]] for l in labels])
for f in ['facts-batch-pair.sh','facts-batch-record.py','raw/corpora.sh']:shutil.copy(d/f,out)
