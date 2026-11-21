import csv,json,os,re,sys,shlex,subprocess,tempfile
from pathlib import Path
d=Path(sys.argv[1]).resolve()
cc=Path(sys.argv[2]).resolve()
base={k:v for k,v in os.environ.items() if not k.startswith('NODE_')}
env={k:'1' for k in ('NODE_SOURCE_BODY_SELECTION','NODE_SPLICE_REPORT','NODE_PROOF_NO_FP','NODE_PROOF_POINTERS','NODE_PROOF_CALLS','NODE_SOURCE_ROWS','NODE_PROOF_NATIVE','NODE_SPLICE_FRONT','NODE_SPLICE_ENABLE','NODE_SOURCE_COMPACT','NODE_SOURCE_COMPACT_REPORT','NODE_SOURCE_LOCAL_ACCESS','NODE_SOURCE_PRUNED_GUARDS')}
flags={}
files={}
for corp,args in zip(('sqlite','lua','musl','buster'),sys.argv[3:7]):
 words=shlex.split(args);flags[corp]=[f for f in words if not f.endswith('.c')]
 for p in words:
  if p.endswith('.c'):files[corp, Path(p).name]=p
rows=list(csv.DictReader((d/'corpora/receipts.tsv').open(),delimiter='\t'))
# Root selection, request and every source containing such a hole, all from public raw counts.
missing=[r for r in rows if int(r['roots'])!=int(r['consumed'])]
o=d/'coverage';o.mkdir(exist_ok=True)
with (o/'coverage.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n')
 w.writerow(['corpus','policy','tu','token','declaration','emitted_body','compact_rows','native_rows'])
 for r in missing:
  corp=r['corpus'];src=files[corp,Path(r['file']).name]
  args=['--lanes','1','-c',*flags[corp],*(['-Wall','-Wextra'] if r['policy']=='wall' else []),src]
  with tempfile.TemporaryDirectory(dir=o) as tmp:
   data=[]
   for e in [dict(base,NODE_SOURCE_BODY_SELECTION='1'),dict(base,**env)]:
    a=subprocess.run([cc,*args,'-o',tmp+'/x.o'],env=e,capture_output=True)
    assert a.returncode==0,(src,a.stderr[-2048:])
    bodies={tuple(map(int,v)) for v in re.findall(rb'^body-selection: open=(\d+) close=(\d+) decl=(\d+) selected=(\d+)',a.stderr,re.M)}
    assert bodies,(corp,src)
    data.append((bodies,a.stderr))
   assert data[0][0]==data[1][0],(corp,src)
   bodies,log=data[1]
   taken={int(t):(int(dels),int(n)) for t,dels,n in re.findall(rb'^compact-taken: token=(\d+).*?removed=(\d+) rows=(\d+)',log,re.M)}
   consumed={int(i) for i in re.findall(rb'^compact-consumed: token=(\d+)',log,re.M)}
   assert len(taken)==int(r['roots']) and len(consumed)==int(r['consumed'])
   for t in sorted(taken.keys()-consumed):
    owners=[(dec,selected) for op,cl,dec,selected in bodies if op<t<cl]
    assert len(owners)==1,(t,owners)
    w.writerow([corp,r['policy'],r['file'],t,*owners[0],*taken[t]])
