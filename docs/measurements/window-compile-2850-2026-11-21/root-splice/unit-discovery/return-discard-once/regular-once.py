from pathlib import Path
import sys,os,re,csv,shlex,subprocess,hashlib,random,statistics,tempfile,time
d=Path(__file__).resolve().parent;w=d.parent;r=d/'0e46b4d75';cc=r/'compiler';orig=d/'a60859270/compiler';src=w/'switch-inputs';bs=w/'pregraph-warning-study/compiler-source';st=list(csv.DictReader((d/'a60859270/stages/stage-counts.tsv').open(),delimiter='\t'));argv={}
for c in ['sqlite','self','lua','musl']:
 if c=='self':x=['-march=native','-I'+str(bs/'src'),'-fwrapv','-funsigned-char','--predefines',str(w/'proof-predefines.h'),str(bs/'src/buster/compiler/main.c')]
 else:x=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$'+c+'_arguments"'],cwd=src,text=True))
 argv[c]=x
def mode(m):
 env=os.environ.copy();flags=[]
 if m not in ['plain','orig-plain']:flags=['--node-window']
 if m[0] in ['u','m']:
  env['BUSTER_REGULAR_WINDOW_UNIT_SEEDS']=m[1:]
  if m[0]=='m':env['BUSTER_REGULAR_WINDOW_MARK_ENDS']='1'
 return (orig if m.startswith('orig') else cc),flags,env
h=lambda x:hashlib.sha256(x).hexdigest()
with (r/'source-predictions.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['corpus','unit','mode','seeds','taken','replaced','graph','elf'])
 for row in st:
  c,file=row['corpus'],row['unit'];x=[a for a in argv[c] if not a.endswith('.c')];o=r/'one.o';comparisons=[]
  for m in ['orig-full','u1','m1']:
   b,flags,env=mode(m)
   if m!='orig-full':env['BUSTER_REGULAR_WINDOW_REPORT']='1'
   q=subprocess.run([b,'--lanes','1','-c','--time-stages',*flags,*x,file,'-o',o],env=env,capture_output=True)
   a=re.search(rb'^regular-window-unit: tokens=(\d+) seeds=(\d+)',q.stderr,re.M)
   z=re.search(rb'^node-window: taken=(\d+) ordinary-nodes-replaced=(\d+) summary-nodes=(\d+) graph-nodes=(\d+)',q.stderr,re.M)
   cap=[int(z[1]),int(z[2]),int(z[4])] if z else [0,0,0];elf=h(o.read_bytes()) if o.exists() else '-'
   assert q.returncode==0 and elf==row['elf_sha256'],(c,file,m,q.returncode,q.stderr[-300:]);comparisons.append(cap)
   t.writerow([c,file,m,int(a[2]) if a else '-',*cap,elf]);f.flush()
  # Emit any cap gap without stopping the aggregate comparison.
  if len(set(tuple(z) for z in comparisons))!=1:print('admission diff',file,comparisons,flush=True)
modes=['orig-plain','orig-full','plain','full','u1','u4','u16','m1','m4','m16']
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
with (r/'screen-pmu.tsv').open('w') as f,tempfile.TemporaryDirectory(dir=r) as tmp:
 out=csv.writer(f,delimiter='\t',lineterminator='\n');out.writerow(['corpus','round','mode','instructions','user_cycles','kernel_cycles','faults','elapsed_ms','manifest'])
 for c in ['musl','lua','sqlite','self']:
  x=argv[c];files=[s for s in x if s.endswith('.c')];stable=set()
  for n in range(4):
   order=modes.copy();random.Random(9961+n).shuffle(order)
   for m in order:
    b,flags,env=mode(m);t=Path(tmp)
    for o in t.glob('*.o'):o.unlink()
    cmd=[b,'--lanes','1','-c',*flags,*x]
    if len(files)==1:cmd+=['-o',t/'unit.o']
    counter=t/'pc'
    if n:cmd=['perf','stat','-x,','-o',counter,'-e','instructions:u,cycles:u,cycles:k,minor-faults','--',*cmd]
    a=time.monotonic_ns();q=subprocess.run(cmd,cwd=t,env=env,capture_output=True);elapsed=(time.monotonic_ns()-a)/1e6;assert q.returncode==0,(c,m,q.stderr[-300:])
    elf=sorted(t.glob('*.o'));assert len(elf)==len(files);dig=hashlib.sha256(q.stderr)
    for e in elf:dig.update(e.name.encode()+b'\0'+hashlib.sha256(e.read_bytes()).digest())
    token=dig.hexdigest();stable.add(token);assert len(stable)==1
    if n:
     counters={fields[2]:int(fields[0]) for l in counter.read_text().splitlines() if len(fields:=l.split(','))>2 and fields[0].isdigit()};out.writerow([c,n,m,*[counters[k] for k in ('instructions:u','cycles:u','cycles:k','minor-faults')],elapsed,token]);f.flush()
