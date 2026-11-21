from pathlib import Path
import os,re,csv,tempfile,hashlib,subprocess
d=Path(__file__).resolve().parent;cc=d/'read-condition.compiler';out=d/'compact-warning-grid';out.mkdir(exist_ok=True)
base=re.search(r'^switches=\((.*?)\)$',(d/'compact-conditions.sh').read_text(),re.M)[1]
opt=dict(i.split('=',1) for i in base.split());opts=dict(opt,NODE_SOURCE_COMPACT='1',NODE_SOURCE_COMPACT_REPORT='1',NODE_SOURCE_COMPACT_CONDITION='1',NODE_SOURCE_COMPACT_READ_CONDITION='1')
prefix='struct R { int n; unsigned bit:3; }; extern int global;\n'
bodies=[
 'int f(int *p,int x){ if (*p==x) return 1; return 0;}',
 'int f(int *p,int x){ if (p[x]==x) return 1; return 0;}',
 'int f(struct R *p,int x){if(p->n==x) return 1;return 0;}',
 'int f(struct R *p,int x){if(p->bit==x) return 1;return 0;}',
 'int f(volatile int *p,int x){if(*p==x) return 1;return 0;}',
 'int f(_Atomic(int) *p,int x){if(*p==x) return 1;return 0;}',
 'int f(int *p,int x){int y;if(p[x]==y) return 1;return 0;}',
 'int f(int x){int *p;if(*p==x) return 1;return 0;}',
 'int f(int x){struct R *p;if(p->n==x) return 1;return 0;}',
 'int f(int *p,int x){int y;if(x)y=3;if(*p==y)return 1;return 0;}',
 'int f(int *p,int x){if(p[x]==global)return 1;return 0;}',
 'static int z; int f(int *p,int x){if(*p==z)return 1;return 0;}',
 'int f(int *p,int x){if(*p==x++)return x;return x+1;}',
 'int f(int *p,int x){if(p[x++]==x)return 1;return 0;}',
 'int f(int *p,int x){if(p[x]==x&&x)return 1;return 0;}',
 'int f(int *p,int x){if(p[x]==x||x)return 1;return 0;}',
 'int f(int *p,int x){do {--x;}while(p[x]!=0);return x;}',
 'int f(int *p,int x){while(*p!=x){++p;}return x;}',
 'int f(int *p,int x){for(;*p!=x;++p){}return x;}',
 'int f(int *p,int x){if(x){}else if(p[x]==0)return x;return 0;}',
 'int f(int *p,int x){if(0){if(*p==x)return 1;}return 0;}',
 'int f(int *p,int x){if(sizeof(*p==x))return 1;return 0;}',
 'int f(int *p,int x){if(_Generic(x,int:*p==x,default:0))return 1;return 0;}',
 'int f(int *restrict p,const int x){if(*p==x)return x;return 0;}',
 'int f(int *p,int x){int *q=p+1; if(*q==x) return 1; return 0;}',
 'int f(int **p,int *q){if(*p==q)return 1;return 0;}',
 'int f(int *p,int x){if(*p==(1u<<32))return x;return 0;}',
 'int f(int *p,int x){if(*p==x) return zzz;return 0;}']
pragmas=['','#pragma GCC diagnostic warning "-Wuninitialized"\n','#pragma GCC diagnostic error "-Wunused-parameter"\n','#pragma GCC diagnostic ignored "-Wuninitialized"\n']
skip=re.compile(rb'^(?:cross-(?:canonical|chunk|cost|keys|view) |node-proof |source-(?:conditions|rows) |splice-(?:taken|local-class): |(?:condition|branch|label|call)-taken |compact-(?:consumed|taken): )')
def h(p):return hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else '-'
with (out/'results.tsv').open('w',buffering=1) as o,tempfile.TemporaryDirectory(dir=out) as tmp:
 w=csv.writer(o,delimiter='\t',lineterminator='\n');w.writerow(['shape','pragma','policy','same','status','takes','consumed','ELF','native','diagnostic'])
 tmp=Path(tmp);obj=tmp/'f.o';native=tmp/'typed'
 for i,body in enumerate(bodies):
  for j,pragma in enumerate(pragmas):
   src=out/f'{i}-{j}.c';src.write_text(prefix+pragma+body+'\n')
   for pol,flags in [('plain',[]),('debug',['-g']),('wall',['-Wall','-Wextra']),('everything',['-Weverything']),('error',['-Werror'])]:
    result=[];logs=[]
    for opts0 in ({},opts):
     obj.unlink(missing_ok=True);native.unlink(missing_ok=True)
     r=subprocess.run([str(cc),'--lanes','1','-nostdinc','-c',*flags,str(src),'-o',str(obj)],capture_output=True,env=dict(os.environ,**opts0,NODE_SOURCE_NATIVE_ORACLE=str(native)),timeout=10)
     clean=b''.join(l for l in r.stderr.splitlines(True) if not skip.match(l));logs.append(clean)
     result.append((r.returncode,h(obj),h(native),hashlib.sha256(clean).hexdigest(),hashlib.sha256(r.stdout).hexdigest()))
    a,b=result;w.writerow([i,j,pol,int(a==b),b[0],r.stderr.count(b'compact-taken:'),r.stderr.count(b'compact-consumed:'),*b[1:4]])
    if a!=b:(out/f'{i}-{j}-{pol}.diff').write_bytes(repr(result).encode()+b'\n'+logs[0]+b'---\n'+logs[1])
