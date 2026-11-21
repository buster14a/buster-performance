from pathlib import Path
import hashlib,os,sys,subprocess,shlex,random,statistics,csv,json,time
d=Path(__file__).resolve().parent;rev=sys.argv[1];exe=d/(rev+'-compiler');corpus=os.environ.get('PW_CORPUS','sqlite');p=d/rev/('perf' if corpus=='sqlite' else 'perf-'+corpus);p.mkdir(exist_ok=True);src=d.parent/'switch-inputs';modes={'plain':{},'dry':{'NODE_PURE_INTERIOR':'1','NODE_PURE_INTERIOR_DRY':'1'},'source':{'NODE_PURE_INTERIOR':'1'}}
if len(sys.argv)>2:
 modes.update(maskdry=dict(NODE_PURE_INTERIOR='1',NODE_PURE_INTERIOR_DRY='1',NODE_PURE_INTERIOR_MASK='1'),mask=dict(NODE_PURE_INTERIOR='1',NODE_PURE_INTERIOR_MASK='1'))
if len(sys.argv)>2 and sys.argv[2]=='spelling':
 modes.pop('source');modes.pop('dry')
 modes.update(spell={**modes['mask'],'NODE_PURE_INTERIOR_SPELLINGS':'1'},spelldry={**modes['maskdry'],'NODE_PURE_INTERIOR_SPELLINGS':'1'})
if len(sys.argv)>2 and sys.argv[2]=='fuse':
 modes={'parent':{},'plain':{},'unfused':dict(NODE_PURE_INTERIOR='1',NODE_PURE_INTERIOR_MASK='1',NODE_PURE_INTERIOR_SPELLINGS='1')}
 modes['fuse']={**modes['unfused'],'NODE_PURE_INTERIOR_FUSE':'1'}
 modes['fusedry']={**modes['fuse'],'NODE_PURE_INTERIOR_DRY':'1'}
args=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$sqlite_arguments"'],cwd=src,text=True));bs=d.parent/'pregraph-warning-study/compiler-source'
if corpus=='self':args=['-march=native','-I'+str(bs/'src'),'-fwrapv','-funsigned-char','--predefines',str(d.parent/'proof-predefines.h'),str(bs/'src/buster/compiler/main.c')]
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))});rs=[]
with (p/'pairs.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['round','mode','instructions','cycles_u','cycles_k','faults','wall_ms','elf'])
 for i in range(8):
  order=list(modes);random.Random(3426+i).shuffle(order)
  for m in order:
   pc=p/'pmu';out=p/'unit.o';active = d.parent/'lean-source-study/bb86d4685-compiler' if m=='parent' else exe;cmd=[str(active),'--lanes','1','-c',*args,'-o',out];out.unlink(missing_ok=True)
   if i:cmd=['perf','stat','-x,','-o',pc,'-e','instructions:u,cycles:u,cycles:k,minor-faults','--',*cmd]
   start=time.monotonic_ns();r=subprocess.run(cmd,capture_output=True,cwd=src,env={**os.environ,**modes[m]});elapsed=(time.monotonic_ns()-start)/1e6;assert r.returncode==0 and not r.stderr
   if i:
    counters={v[2]:int(v[0]) for l in pc.read_text().splitlines() if len(v:=l.split(','))>=3 and v[0].isdigit()}
    vals=[counters[k] for k in ['instructions:u','cycles:u','cycles:k','minor-faults']]+[elapsed];rs.append((i,m,vals));w.writerow([i,m,*vals,hashlib.sha256(out.read_bytes()).hexdigest()]);f.flush()
out={}
pairs=[('dry','plain'),('source','dry'),('source','plain'),('maskdry','plain'),('mask','maskdry'),('mask','source'),('mask','plain'),('spelldry','maskdry'),('spell','mask'),('spelldry','plain'),('spell','spelldry'),('spell','plain'),('plain','parent'),('fuse','unfused'),('fusedry','plain'),('fuse','fusedry'),('fuse','plain'),('fuse','parent')]
for a,b in [(a,b) for a,b in pairs if a in modes and b in modes]:
 out[a+' minus '+b]={}
 for j,k in enumerate(['instructions','user_cycles','kernel_cycles','faults','wall_ms']):
  ds=[next(v[j] for r,m,v in rs if r==i and m==a)-next(v[j] for r,m,v in rs if r==i and m==b) for i in range(1,8)]
  out[a+' minus '+b][k]=[statistics.median(ds),min(ds),max(ds)]
print(json.dumps(out,indent=2))
