"""Qualify actual musl fmal and hypotl on four input families, checking precision and rounding."""
from pathlib import Path
import csv,hashlib,itertools,os,shutil,statistics,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parent;old=w/'x87-pool-evidence';d=p/'real';d.mkdir(exist_ok=True)
cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
ccs={'pool':w/'x87-pool/build/compiler','double':w/'x87-double/build/compiler','clang':cc}
basearch={'pool':old/'libm/out/candidate','double':old/'libm/out/candidate','clang':old/'libm/out/clang'}
musl=Path('/home/david/dev/buster-corpus/libc/musl');gen=Path('/home/david/dev/buster-corpus/musl-generated/obj')
flags=['-O2','-march=znver5','-w','-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700',*['-I'+str(a) for a in [musl/'arch/x86_64',musl/'arch/generic',gen/'src/internal',musl/'src/include',musl/'src/internal',gen/'include',musl/'include']]]
names=['fmal','hypotl'];groups=['ordinary','cancel','exponents','scaled'];pads=[0,16,32,48];vs=['pool','double'];metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock']
os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def save(name,head,rows):
 with (d/name).open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rows)
def exe(v,pad):return d/f'{v}-{pad}'
if sys.argv[1]=='build':
 main=d/'driver.o';run(cc,'-std=gnu17','-fno-builtin','-ffp-model=strict','-O2','-c',p/'real.c','-o',main)
 res=[]
 for v,c in ccs.items():
  dr=d/v;dr.mkdir(exist_ok=True);ar=dr/'libmath.a';shutil.copyfile(basearch[v]/'libmath.a',ar)
  for n in names:
   obj=dr/(n+'.o');run(c,*([] if v=='clang' else ['--tier1','--lanes','1']),*flags,'-c',musl/'src/math'/(n+'.c'),'-o',obj,capture_output=True);run('ar','rD',ar,obj)
  assert len(run('ar','t',ar,capture_output=True,text=True).stdout.splitlines())==300
  for pad in pads:
   ex=exe(v,pad);mp=ex.with_suffix('.map');run(cc,'-no-pie',main,old/'loops/programs'/f'pad{pad}.o',ar,'-Wl,-Map,'+str(mp),'-lmpfr','-lgmp','-lm','-o',ex)
   assert all('libmath.a('+n+'.o)' in mp.read_text() for n in names)
   syms={q[-1]:(q[0],int(q[1],16)) for l in run('nm','-S',ex,capture_output=True,text=True).stdout.splitlines() if len(q:=l.split())==4}
   res.append([v,pad,sha(ar),sha(ex),*[x for n in names for x in syms[n]]])
 save('programs.tsv',['variant','pad','archive_sha256','executable_sha256','fmal_address','fmal_bytes','hypotl_address','hypotl_bytes'],res)
elif sys.argv[1]=='check':
 rows=[];cmp=[];ref=[]
 for n,g in itertools.product(names,groups):
  blobs={}
  for v in ccs:
   f=d/f'{n}-{g}-{v}.bin'
   with f.open('wb') as h:run(exe(v,0),n,g,'check',1,stdout=h)
   b=f.read_bytes();assert len(b)==12*2048*16;blobs[v]=b;rows.append([n,g,v,sha(f),len(b)//16])
  f=d/f'{n}-{g}-mpfr.bin'
  with f.open('wb') as h:run(exe('clang',0),n,g,'oracle',1,stdout=h)
  refs=f.read_bytes();assert len(refs)==4*2048*11
  for a,b in [('pool','double'),('clang','pool'),('clang','double')]:
   x=blobs[a];y=blobs[b];cols=[(0,10),(10,11),(11,12),(12,14),(14,15),(15,16),(0,16)]
   counts=[sum(x[i+s:i+e]!=y[i+s:i+e] for i in range(0,len(x),16)) for s,e in cols]
   cmp.append([n,g,a,b,24576,*counts]);assert a!='pool' or counts==[0]*7
  for v,data in blobs.items():
   for r in range(4):
    definite=bad=0
    for i in range(2048):
     at=11*(r*2048+i);src=16*((8+r)*2048+i)
     if refs[at]:definite+=1;bad+=refs[at+1:at+11]!=data[src:src+10]
    ref.append([n,g,v,r,2048,definite,bad,sha(f)])
 save('checks.tsv',['function','input','compiler','sha256','observations'],rows);save('comparisons.tsv',['function','input','base','head','observations','value','x87_flags','mxcsr','control_word','TOP','errno','any'],cmp);save('mpfr.tsv',['function','input','variant','rounding_index','cases','unambiguous','different','oracle_sha256'],ref)
else:
 cases=list(itertools.product(names,groups,pads));rows=[];idx={};oracles={}
 for r in range(9):
  for j in range(len(cases)):
   n,g,pad=cases[(j+7*r)%len(cases)]
   for v in (vs if (j+r)%2 else vs[::-1]):
    stat=d/'last.stat';h=run('perf','stat','-x',';','--no-big-num','-e',','.join(metrics),'-o',stat,'--',exe(v,pad),n,g,'time',8,capture_output=True,text=True).stdout.strip();assert h==oracles.setdefault((n,g),h)
    obs={q[2]:float(q[0]) for l in stat.read_text().splitlines() if len(q:=l.split(';'))>2 and q[2] in metrics};idx[r,n,g,pad,v]=obs;rows.append([r,n,g,pad,v,h,*[obs[m] for m in metrics]])
  print('round',r,flush=True)
 save('counters.tsv',['round','function','input','pad','compiler','oracle',*metrics],rows);summ=[]
 for n,g,pad in cases:
  for m in metrics:
   a=[idx[r,n,g,pad,'pool'][m] for r in range(1,9)];b=[idx[r,n,g,pad,'double'][m] for r in range(1,9)];pct=[100*(y/x-1) for x,y in zip(a,b)];summ.append([n,g,pad,m,len(a),statistics.median(a),statistics.median(b),statistics.median(pct),min(pct),max(pct)])
 save('paired.tsv',['function','input','pad','metric','pairs','base','head','paired_percent','min_percent','max_percent'],summ)
