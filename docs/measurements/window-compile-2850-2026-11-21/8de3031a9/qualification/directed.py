import csv,hashlib,subprocess
from pathlib import Path
d=Path(__file__).resolve().parent
w=d.parent
tests={'bare': 'int x; int f(int y){int z=y;return z;}', 'multi': 'int a=1,b=2,c; int f(void){int x=a,y=b;return x+y+c;}', 'shadow': 'int n; int f(int n){{int n=4; n++;}return n;}', 'record': 'struct A{int x,y;unsigned bf:2;int *p;};int f(struct A a){return a.x+a.bf;}', 'array': 'typedef int A[4];A x; int f(void){return sizeof(x);}', 'function': 'typedef int F(int); F f; int f(int x){return x;}', 'attrs': 'typedef __attribute__((aligned(16))) int T; T x; int y __attribute__((deprecated)); int f(void){return y;}', 'sugar': 'typedef int (__attribute__((ms_abi)) *Fn)(int); Fn x; Fn y;', 'nullability': 'typedef int *_Nullable IP; IP p; int *_Nonnull q;', 'node': 'typedef int __attribute__((noderef)) N; N x; N *p; int f(void){return *p;}', 'atomic': '_Atomic int x,z; int f(void){int r=x; z=r; return z;}', 'pad': 'struct S{char a;long b;};void f(struct S x){__builtin_clear_padding(&x);}', 'kr': 'int f(a,b) int a,b; {return a+b;}', 'bad1': 'int x; double x;', 'bad2': 'struct A {int x; double x;};', 'invalid': 'int f(void){int x=4,x=5;return x;}', 'enum': 'enum E {A=3}; enum E x; int f(void){enum E y=A; return y+x;}', 'gnu': 'struct S{int a,b;}; _Thread_local static struct S s; int f(void){__typeof__(s) x=s;return x.b;}', 'unnamed': 'int f(int, int (*)(int));struct S{int :4;int x;};', 'vla': 'void f(int n){typedef int A[n]; A a;int *p=a;(void)p;}'}
out=d/'directed';out.mkdir(exist_ok=True)
parent=w/'main-fbef-clean/build/compiler';candidate=w/'plain-declarator-run/build/compiler'
with (out/'results.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['case','std','flags','lanes','same','status','object','stdout','stderr'])
 for name,body in tests.items():
  src=out/(name+'.c');src.write_text(body+'\n')
  for std in ('c17','gnu17','c23'):
   for case,flags in [('ordinary',[]),('diagnostics',['-Wall','-Wextra']),('errors',['-Wall','-Werror']),('debug',['-g'])]:
    for lane in (1,4):
     twins=[]
     for compiler in (parent,candidate):
      obj=out/'same.o';obj.unlink(missing_ok=True)
      r=subprocess.run([compiler,'-c','-nostdinc','-std='+std,'--lanes',str(lane),*flags,src,'-o',obj],capture_output=True,timeout=50)
      h=lambda s:hashlib.sha256(s).hexdigest()
      twins.append((r.returncode,h(obj.read_bytes()) if obj.exists() else '-',h(r.stdout),h(r.stderr)))
     t.writerow([name,std,case,lane,int(twins[0]==twins[1]),*twins[1]])
     assert twins[0]==twins[1],(name,std,case,lane)
