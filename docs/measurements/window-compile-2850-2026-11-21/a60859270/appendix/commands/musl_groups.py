"""Attribute the option's cost to disjoint real-musl source groups, grouped after compilation by admitted roots."""
from pathlib import Path
import csv,os,shlex,statistics,subprocess,sys,time,hashlib,tempfile,random,json
d=Path(__file__).resolve().parent;r=d/sys.argv[1];w=d.parent;out=r/'musl-groups';out.mkdir(exist_ok=True);tree=w/'switch-inputs';cc=r/'compiler';parent=d/'b86eadcbd-compiler'
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
args=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$musl_arguments"'],cwd=tree,text=True));flags=[s for s in args if not s.endswith('.c')];rows=[x for x in csv.DictReader((r/'stages/stage-counts.tsv').open(),delimiter='\t') if x['corpus']=='musl']
groups=[(0,1),(1,3),(3,10),(10,30),(30,100000)]
with (out/'groups.tsv').open('w') as f,tempfile.TemporaryDirectory(dir=out) as temp:
 a=csv.writer(f,delimiter='\t',lineterminator='\n');a.writerow(['min','past','units','roots','removed','round','mode','instructions','user_cycles','kernel_cycles','faults','wall_ms','manifest'])
 for low,high in groups:
  units=[x for x in rows if low<=int(x['roots'])<high];files=[x['unit'] for x in units];manifest=set()
  assert files
  for n in range(4):
   modes=['plain','opt','parent'];random.Random(28506+n).shuffle(modes)
   for m in modes:
    tmp=Path(temp)
    for o in tmp.glob('*.o'):o.unlink()
    cmd=[parent if m=='parent' else cc,'--lanes','1','-c',*(['--node-window-constants'] if m=='opt' else []),*flags,*files];ct=tmp/'ctr'
    if n:cmd=['perf','stat','-e','instructions:u,cycles:u,cycles:k,minor-faults','-x,','-o',ct,'--',*cmd]
    start=time.monotonic_ns();q=subprocess.run(cmd,cwd=tmp,capture_output=True);wall=(time.monotonic_ns()-start)/1e6;assert q.returncode==0,(low,m,q.stderr[-300:])
    outs=sorted(tmp.glob('*.o'));assert len(outs)==len(files);dig=hashlib.sha256(q.stderr)
    for o in outs:dig.update(o.name.encode()+b'\0'+hashlib.sha256(o.read_bytes()).digest())
    key=dig.hexdigest();manifest.add(key);assert len(manifest)==1
    if n:
     cnt={q[2]:int(q[0]) for ln in ct.read_text().splitlines() if len(q:=ln.split(','))>2 and q[0].isdigit()}
     a.writerow([low,high,len(files),sum(int(x['roots']) for x in units),sum(int(x['removed']) for x in units),n,m,*[cnt[i] for i in ('instructions:u','cycles:u','cycles:k','minor-faults')],wall,key]);f.flush()
