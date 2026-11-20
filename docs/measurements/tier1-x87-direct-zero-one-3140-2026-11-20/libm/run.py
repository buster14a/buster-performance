from pathlib import Path
import csv,hashlib,os,statistics,subprocess
p=Path(__file__).resolve().parent;w=p.parents[1];d=p/'out';d.mkdir(exist_ok=True);corpus=Path('/home/david/dev/buster-corpus');musl=corpus/'libc/musl';gen=corpus/'musl-generated/obj';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';versions={'clang':cc,'parent':w/'x87-double/build/compiler','candidate':w/'x87-rom/build/compiler'};sources=sorted((musl/'src/math').glob('*.c'))+sorted((musl/'src/complex').glob('*.c'));names=['exp2l','expm1l','log10l','acosl','atan2l','powl','coshl','frexpl','exp10l','tgammal','erfl','sinl'];flags=['-O2','-march=znver5','-w','-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700'];flags+=['-I'+str(f) for f in [musl/'arch/x86_64',musl/'arch/generic',gen/'src/internal',musl/'src/include',musl/'src/internal',gen/'include',musl/'include']];os.environ.update(SOURCE_DATE_EPOCH='1792454400',LC_ALL='C')
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def tab(name,header,rows):
 with (p/name).open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(header);t.writerows(rows)
run(cc,'-std=gnu11','-O1','-ffp-model=strict','-fno-builtin','-c',p/'math.c','-o',d/'driver.o');records=[];blobs={}
for v,exe in versions.items():
 dst=d/v;dst.mkdir(exist_ok=True);objs=[]
 for f in sources:
  o=dst/(f.stem+'.o');src=w/'trunc-evidence/real/out/clang'/o.name
  if v=='clang' and src.exists():o=src
  else:run(exe,*([] if v=='clang' else ['--tier1','--lanes','1']),*flags,'-c',f,'-o',o,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
  objs.append(o)
 a=dst/'libmath.a';run('ar','rcsD',a,*objs);e=dst/'math';mp=dst/'link.map';run(cc,'-no-pie',d/'driver.o',a,'-lm','-Wl,-Map,'+str(mp),'-o',e);m=mp.read_text();assert all('libmath.a('+n+'.o)' in m for n in names);bits=dst/'results.bin';run(e,bits,timeout=120);b=bits.read_bytes();assert len(b)==3*4*2048*12*16;blobs[v]=b;records.append([v,len(objs),sha(a),sha(e),sha(bits),len(b)//16]);print(v,'completed',flush=True)
tab('identities.tsv',['compiler','archive_members','archive_sha256','exe_sha256','observations_sha256','observations'],records);r=[]
for name,a,b in [('parent-to-candidate','parent','candidate'),('clang-to-parent','clang','parent'),('clang-to-candidate','clang','candidate')]:
 for k,n in enumerate(names):
  status=[0,0,0,0,0];count=0
  for i in range(16*k,len(blobs[a]),16*len(names)):
   x=blobs[a][i:i+16];y=blobs[b][i:i+16];count+=1
   for j,m in enumerate([x[:10]!=y[:10],x[10]!=y[10],x[11]!=y[11],x[12:]!=y[12:],x!=y]):status[j]+=m
  r.append([name,n,count,*status])
tab('comparisons.tsv',['comparison','function','observations','value_differences','x87_flag_differences','mxcsr_flag_differences','exponent_differences','any_differences'],r);assert blobs['parent']==blobs['candidate']
