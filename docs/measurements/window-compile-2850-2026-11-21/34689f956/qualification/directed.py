import csv,hashlib,subprocess
from pathlib import Path
d=Path(__file__).resolve().parent
w=d.parent
tests={
'plain':'int f(int a,int b){int x=a; return x=b;}',
'bitfield':'struct S{signed x:4;unsigned y:7;}; int f(int a){struct S s={0};return (s.x=a)+(s.y=a+3);}',
'pointer':'int f(int *p,int x){const int *q=p;return q==p ? (*p=x) : 0;}',
'address':'static int z; static int *q=&z; int *f(int **p){return *p=q;}',
'atomic':'_Atomic int z; int f(int a){int y=z;return z=y+a;}',
'floating':'double f(float a, int b){long double x=(long double)a;double y;return y=x+b;}',
'complex':'_Complex double f(_Complex float x){_Complex double z=x;return z=(x+1);}',
'wide':'__int128 f(__int128 x){unsigned __int128 y=x;return y=y+3;}',
'aggregate':'struct V{long x; double y;};struct V f(struct V a,struct V b){return a=b;}',
'comp_literal':'struct P {int x;};int f(int v){struct P p={1};p=(struct P){v};return p.x;}',
'bad_type':'struct A{int a;};struct B{int b;}; int f(struct A x,struct B y){x=y;return x.a;}',
'const_record':'struct S{const int x;};int f(struct S a,struct S b){a=b;return a.x;}',
'bad_pointer':'int *f(double d){int *p=d;return p;}',
'bad_lvalue':'int f(int x){(x+1)=3; return x;}',
'bad_return':'struct P{int x;};struct P f(int i){return i;}',
'bad_qualifier':'int f(const int *p){int *q=p;return *q;}',
'vector':'typedef int V __attribute__((vector_size(16))); V f(V a,V b){return a=b;}',
'null':'int *f(int c,int *p){if(c)p=0;return p;}',
'fp_env':'#pragma STDC FENV_ACCESS ON\ndouble f(float x){volatile float y=x;return y;}',
'void':'void f(void){} void g(void){return f();}',
}
out=d/'directed';out.mkdir(exist_ok=True)
parent=w/'main-fbef-clean/build/compiler';candidate=w/'direct-assignment-value/build/compiler'
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
