from pathlib import Path
import sys,os,re,csv,itertools,shlex,subprocess,hashlib,random,statistics,tempfile,time,json
d=Path(__file__).resolve().parent;w=d.parent;r=d/'975f49ab5';cc=r/'compiler';orig=d/'27441f465/compiler';src=w/'switch-inputs';bs=w/'pregraph-warning-study/compiler-source';st=list(csv.DictReader((d/'a60859270/stages/stage-counts.tsv').open(),delimiter='\t'));argv={}
for c in ['sqlite','self','lua','musl']:
 if c=='self':x=['-march=native','-I'+str(bs/'src'),'-fwrapv','-funsigned-char','--predefines',str(w/'proof-predefines.h'),str(bs/'src/buster/compiler/main.c')]
 else:x=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$'+c+'_arguments"'],cwd=src,text=True))
 argv[c]=x
units={};h=lambda x:hashlib.sha256(x).hexdigest()
with (r/'source-predictions.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['corpus','unit','mode','tokens','seeds','roots','removed','ELF'])
 for row in st:
  c,file=row['corpus'],row['unit'];flags=[x for x in argv[c] if not x.endswith('.c')];o=r/'one.o'
  for mode in ['t0','t1','t4','t16']:
   env={**os.environ,'BUSTER_WINDOW_UNIT_SEEDS':mode[1:],'BUSTER_WINDOW_UNIT_GROUPS':'1'}
   if mode=='t0':env['BUSTER_WINDOW_UNIT_SEEDS_REPORT']='1'
   q=subprocess.run([cc,'--lanes','1','-c','--time-stages','--node-window-constants',*flags,file,'-o',o],env=env,capture_output=True);assert q.returncode==0,(c,file)
   m=re.search(rb'^integer-window-unit: token-count=(\d+) seeds=(\d+)',q.stderr,re.M);z=re.search(rb'^constant-window: roots=(\d+) removed=(\d+) graph-nodes=(\d+)',q.stderr,re.M)
   roots,rm=map(int,[row['roots'],row['removed']]);actual=[int(z[1]),int(z[2])] if z else [0,0]
   if mode=='t0':num,seed=map(int,m.groups()) if m else (0,0)
   expected=[roots,rm] if seed>=int(mode[1:]) else [0,0]
   assert expected==actual and h(o.read_bytes())==row['elf_sha256'],(c,file,mode,seed,expected,actual)
   units[file]=(seed,roots,rm);t.writerow([c,file,mode,num,seed,*actual,row['elf_sha256']]);f.flush()
limits=[0,1,2,4,8,16,32]
cases=['parent','original-on','plain','at0','at1','t1','t4','t16']
with (r/'coverage.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['corpus','minimum','enabled_units','false_positives','lost_positive_units','roots','removed'])
 for c,x in argv.items():
  for limit in limits:
   vals=[units[file] for file in x if file.endswith('.c')];selected=[v for v in vals if v[0]>=limit];t.writerow([c,limit,len(selected),sum(v[1]==0 for v in selected),sum(v[1]>0 and v[0]<limit for v in vals),sum(v[1] for v in selected),sum(v[2] for v in selected)])
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
with (r/'screen-pmu.tsv').open('w') as f,tempfile.TemporaryDirectory(dir=r) as tmp:
 out=csv.writer(f,delimiter='\t',lineterminator='\n');out.writerow(['corpus','round','mode','instructions','user_cycles','kernel_cycles','faults','elapsed_ms','manifest'])
 for c in ['musl','lua','sqlite','self']:
  x=argv[c];files=[s for s in x if s.endswith('.c')];stable=set()
  for n in range(4):
   order=cases.copy();random.Random(674+n).shuffle(order)
   for m in order:
    t=Path(tmp)
    for o in t.glob('*.o'):o.unlink()
    cmd=[orig if m in ['parent','original-on'] else cc,'--lanes','1','-c',*(['--node-window-constants'] if m not in ['parent','plain'] else []),*x];env=os.environ.copy()
    if m.startswith('at'):env['BUSTER_WINDOW_UNIT_SEEDS']=m[2:]
    if m.startswith('t'):env['BUSTER_WINDOW_UNIT_SEEDS']=m[1:];env['BUSTER_WINDOW_UNIT_GROUPS']='1'
    if len(files)==1:cmd+=['-o',t/'unit.o']
    counter=t/'pc'
    if n:cmd=['perf','stat','-x,','-o',counter,'-e','instructions:u,cycles:u,cycles:k,minor-faults','--',*cmd]
    a=time.monotonic_ns();q=subprocess.run(cmd,cwd=t,env=env,capture_output=True);elapsed=(time.monotonic_ns()-a)/1e6;assert q.returncode==0,(c,m,q.stderr[-300:])
    elf=sorted(t.glob('*.o'));assert len(elf)==len(files);dig=hashlib.sha256(q.stderr)
    for e in elf:dig.update(e.name.encode()+b'\0'+hashlib.sha256(e.read_bytes()).digest())
    token=dig.hexdigest();stable.add(token);assert len(stable)==1
    if n:
     counters={fields[2]:int(fields[0]) for l in counter.read_text().splitlines() if len(fields:=l.split(','))>2 and fields[0].isdigit()};out.writerow([c,n,m,*[counters[k] for k in ('instructions:u','cycles:u','cycles:k','minor-faults')],elapsed,token]);f.flush()
