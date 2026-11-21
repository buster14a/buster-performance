from pathlib import Path
import csv,subprocess,hashlib
d=Path(__file__).resolve().parent;w=d.parent;src=w/'initializer-owners';out=d/'focused';out.mkdir(exist_ok=True)
cases=['int a=9;int f(void){return a;}', 'int a[]={1,2},b[]={3};int f(void){return a[1]+b[0];}', 'struct S{int n;int m;};struct S s={.m=3};int f(void){return s.m;}', 'int f(int x){int a[3]={[2]=x};return a[2];}', 'int f(int x){int a=x,b=a;return b;}', 'int f(int x){int a(x);return a;}', 'int x=1;int f(void){return ((int[]){x,2})[0];}', 'struct S{int a;};int f(int a){return ((struct S){a}).a;}', 'int x=({ int k=4;k; });', 'int x=(int){3};int f(void){return x;}', 'int f(void){auto x=(int){2};return x;}', 'int f(void){auto x=(_Atomic int*)0;return !!x;}', 'int a[2] = {[8]=1};', 'int bad(void){int x=(struct S){2};return x;}', 'int f(void){int *p=1;return *p;}', 'int f(int a){int x=0;{int x=a+1;x++;}return x;}', 'int f(int n){int a[n];int *p=(int[]){1,2};return p[1]+sizeof(a);}', '_Static_assert(((int){1})==1, "");', 'int unused;int f(int n){int x __attribute__((unused))=n;return 1;}', 'int f(int x){static int q=3;int (*p)(int)=f;return x?p(0):q;}']
bins=[w/'main-fbef-clean/build/compiler',src/'build/compiler'];clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
headers=['case','std','policy','lanes','matched','status','clang syntax status','object','stdout','diagnostics']
def digest(s):return hashlib.sha256(s).hexdigest()
with (out/'checks.tsv').open('w',buffering=1) as f:
 rows=csv.writer(f,delimiter='\t',lineterminator='\n');rows.writerow(headers)
 for i,c in enumerate(cases):
  path=out/(str(i)+'.c');path.write_text(c+'\n');obj=out/'same.o'
  for std in ('c17','gnu17','c23'):
   for pol,flags in [('default',[]),('warnings',['-Wall','-Wextra']),('error',['-Werror'])]:
    oracle=subprocess.run([clang,'-std='+std,'-nostdinc','-fsyntax-only',*flags,path],capture_output=True)
    for lane in [1,4]:
     r=[]
     for cc in bins:
      obj.unlink(missing_ok=True)
      p=subprocess.run([cc,'-std='+std,'--lanes',str(lane),'-nostdinc','-c',*flags,path,'-o',obj],capture_output=True,timeout=45,cwd=src)
      r.append((p.returncode,digest(obj.read_bytes()) if obj.exists() else '-',digest(p.stdout),digest(p.stderr)))
     rows.writerow([i,std,pol,lane,int(r[0]==r[1]),r[1][0],oracle.returncode,*r[1][1:]])
     assert r[0]==r[1],(i,std,pol,lane)
