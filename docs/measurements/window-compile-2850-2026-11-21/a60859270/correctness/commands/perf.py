from pathlib import Path
import os,sys,shlex,random,statistics,subprocess,csv,json,hashlib,time
d=Path(__file__).resolve().parent;rev=sys.argv[1];w=d.parent;cc=d/rev/'compiler';base=d/'b86eadcbd-compiler';res=d/rev/'perf';res.mkdir(exist_ok=True);tmp=res/'objects';tmp.mkdir(exist_ok=True);src=w/'switch-inputs';bs=w/'pregraph-warning-study/compiler-source'
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
allrows=[]
with (res/'runs.tsv').open('w') as f:
 wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(['corpus','round','mode','instructions','cycles_user','cycles_kernel','faults','wall_ms','objects','manifest','stderr'])
 for corpus,size in [('sqlite',1),('self',1),('lua',34),('musl',1336)]:
  if corpus=='self':opts=['-march=native','-I'+str(bs/'src'),'-fwrapv','-funsigned-char','--predefines',str(w/'proof-predefines.h'),str(bs/'src/buster/compiler/main.c')]
  else:opts=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$'+corpus+'_arguments"'],text=True,cwd=src))
  if corpus in ('sqlite','self'):
   check=[]
   for mode,exe,flags in [('parent',base,[]),('plain',cc,[]),('option',cc,['--node-window-constants'])]:
    o=res/(corpus+'-'+mode+'.o')
    cp=subprocess.run([exe,'--lanes','1','-c',*flags,*opts,'-o',o],capture_output=True);assert cp.returncode==0,(corpus,mode,cp.stderr[-200:])
    check.append([hashlib.sha256(o.read_bytes()).hexdigest(),hashlib.sha256(cp.stderr).hexdigest()])
   assert check[0]==check[1]==check[2],(corpus,check)
   ob=res/(corpus+'-stage.o');cp=subprocess.run([cc,'--lanes','1','--time-stages','--node-window-constants','-c',*opts,'-o',ob],capture_output=True);assert cp.returncode==0 and hashlib.sha256(ob.read_bytes()).hexdigest()==check[0][0]
   (res/(corpus+'-preflight.json')).write_text(json.dumps({'parent_plain_option_same':True,'ELF':check[0][0],'stderr':check[0][1],'stage':[l for l in cp.stderr.decode().splitlines() if l.startswith('constant-window:')]},indent=2)+'\n')
  hashes=set();n=3 if corpus in ['musl','lua'] else 7
  for r in range(n+1):
   order=['parent','plain','option'];random.Random(464+r).shuffle(order)
   for mode in order:
    for s in tmp.glob('*.o'):s.unlink()
    exe=base if mode=='parent' else cc;args=[exe,'--lanes','1','-c',*(['--node-window-constants'] if mode=='option' else []),*opts]
    if size==1: args+=['-o',str(tmp/'unit.o')]
    pc=res/'pmu'
    if r:args=['perf','stat','-x,','-o',pc,'-e','instructions:u,cycles:u,cycles:k,minor-faults','--',*args]
    t=time.monotonic_ns();p=subprocess.run(args,capture_output=True,cwd=tmp);elapsed=(time.monotonic_ns()-t)/1e6;assert not p.returncode,(mode,corpus,p.stderr[-300:])
    objs=sorted(tmp.glob('*.o'));assert len(objs)==size,(len(objs),size);dig=hashlib.sha256()
    for o in objs:dig.update(o.name.encode()+b'\x00'+hashlib.sha256(o.read_bytes()).digest())
    ans=(dig.hexdigest(),hashlib.sha256(p.stderr).hexdigest());hashes.add(ans);assert len(hashes)==1,(corpus,mode,r)
    if r:
     ctr={v[2]:int(v[0]) for l in pc.read_text().splitlines() if len(v:=l.split(','))>=3 and v[0].isdigit()};vals=[ctr[k] for k in ['instructions:u','cycles:u','cycles:k','minor-faults']]+[elapsed];allrows.append((corpus,r,mode,vals));wr.writerow([corpus,r,mode,*vals,size,*ans]);f.flush()
  summary={}
  for a,b in [('plain','parent'),('option','plain'),('option','parent')]:
   summary[a+' minus '+b]={}
   for j,k in enumerate(['instructions','cycles_user','cycles_kernel','faults','wall_ms']):
    ds=[next(v[j] for g,i,m,v in allrows if (g,i,m)==(corpus,r,a))-next(v[j] for g,i,m,v in allrows if (g,i,m)==(corpus,r,b)) for r in range(1,n+1)]
    summary[a+' minus '+b][k]=[statistics.median(ds),min(ds),max(ds)]
  (res/(corpus+'.json')).write_text(json.dumps(summary,indent=2)+'\n')
