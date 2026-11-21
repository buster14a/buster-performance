from pathlib import Path
import csv,subprocess,shlex,os,sys,random,tempfile,hashlib,statistics
d=Path(__file__).resolve().parent;src=Path(os.environ["BUSTER_CORPUS_ROOT"]).resolve();cc=Path(sys.argv[1]).resolve()
a=subprocess.check_output(['bash','-c','source '+shlex.quote(str(d/'corpora.sh'))+'; printf %s "$sqlite_arguments"'],cwd=src,text=True);opts=shlex.split(a)
cpu=min(os.sched_getaffinity(0));os.sched_setaffinity(0,{cpu})
masks=[0,1,2,4,8,15];samples={}
with tempfile.TemporaryDirectory() as t,(d/'component-cost.tsv').open('w',buffering=1) as f:
 t=Path(t);stat=t/'s';obj=t/'u.o';w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('policy round mask instructions cycles branches branch_misses faults obj'.split());gold=None
 for warm in (-1,0,1,2,3,4,5,6):
  policies=['default','window'];random.Random(43+warm).shuffle(policies)
  for p in policies:
   ms=masks.copy();random.Random(18341+warm).shuffle(ms)
   for m in ms:
    env=dict(os.environ,BUSTER_CALL_COST_PRIOR=str(m));pr=subprocess.run(['perf','stat','-x','\t','-o',stat,'-e','instructions:u,cycles:u,branches:u,branch-misses:u,page-faults','--',cc,'--lanes','1',*(['--node-window'] if p=='window' else []),'-c',*opts,'-o',obj],env=env,capture_output=True)
    assert pr.returncode==0,(p,m,pr.stderr)
    h=hashlib.sha256(obj.read_bytes()).hexdigest();gold=gold or h;assert h==gold
    data=[line.split('\t')[0] for line in stat.read_text().splitlines() if line and line[0].isdigit()];assert len(data)==5,data
    w.writerow([p,warm,m,*data,h])
    if warm>=0:samples[p,warm,m]=list(map(int,data))
for p in ('default','window'):
 for m in masks[1:]:
  diffs=[[samples[p,n,m][k]-samples[p,n,0][k] for n in range(7)] for k in range(5)]
  print(p,m,*(int(statistics.median(x)) for x in diffs),flush=True)
