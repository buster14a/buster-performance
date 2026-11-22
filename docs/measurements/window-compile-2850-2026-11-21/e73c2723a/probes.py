from common import *
q=D/'oracle/cases';q.mkdir(parents=True,exist_ok=True)
sources={
 'plain':'int f(int a){return a*3+2;}',
 'atomic-present':'struct A{_Atomic(int) n;}; int f(int a){return a*3+2;}',
 'atomic-read-write':'int f(int a){_Atomic(int) n=2; n+=a; ++n; return n;}',
 'atomic-pointer':'struct S { _Atomic(int*) p; }; int f(struct S *s,int *q){s->p=q;return *s->p;}',
 'c11-builtin':'int f(_Atomic(int)*a,int b){return __c11_atomic_fetch_add(a,b,5);}',
 'wrapped-atomic':'typedef _Atomic(int) A __attribute__((aligned(8))); int f(A *p,int a){*p=a;return *p;}',
 'ext-logical':'typedef int V __attribute__((ext_vector_type(4))); typedef _Atomic(int) A; V f(V x,V y){return (!x)||(x&&y);}',
 'vector-register':'typedef int V __attribute__((vector_size(16)));typedef _Atomic(int) A; V f(V a,V b){return a*b+(a>>b);} int g(V x,int i){return x[i];}',
 'vector-transport':'typedef int V __attribute__((vector_size(128)));V f(V a,V b){return a*b+(a>>b);} int g(V x,int i){return x[i];}',
 'wrapped-transport':'typedef int V __attribute__((ext_vector_type(32)));typedef V A __attribute__((aligned(64))); A f(A a,A b){return (!a)||(a&&b);}',
 'vector-scalar-conversions':'typedef int V __attribute__((ext_vector_type(32))); V f(V a,int b){return a+b;} void g(V*p,int n){*p+=n;}',
 'vector-casts':'typedef int I __attribute__((ext_vector_type(32)));typedef float F __attribute__((ext_vector_type(32)));F f(I i){return __builtin_convertvector(i,F);}',
 'vector-builtins':'typedef unsigned V __attribute__((ext_vector_type(32)));V f(V a,V b){return __builtin_elementwise_add_sat(a,b)+__builtin_elementwise_popcount(a);}',
 'vector-comparison':'typedef int V __attribute__((ext_vector_type(32)));V f(V a,V b){return (a<b)?a:b;}',
 'atomic-vector':'typedef int V __attribute__((vector_size(16))); V f(_Atomic(V)*p,V a){*p=a;return *p;}',
 'scalar-bit-builtin':'typedef _Atomic(int) A; unsigned f(unsigned x){return __builtin_elementwise_popcount(x);}',
 'unrelated-large-vector':'typedef int V __attribute__((vector_size(128))); V v; int f(int value){return value/2 + value*4;}',
 'transport-combined':'typedef unsigned V __attribute__((ext_vector_type(32))); typedef int I __attribute__((ext_vector_type(32))); _Atomic(int) g; unsigned f(V a,V b){V s=a+b; s[2]+=s[1]; g++; return __builtin_elementwise_popcount(s)[2]+g;}',
 'rejected-vector':'typedef int V __attribute__((ext_vector_type(32)));int f(V a){return a.foo;}',
 'rejected-atomic':'int f(void){_Atomic(int[3]) a;return 0;}',
 'runtime-atomic':'int main(void){_Atomic(int) v=3;int a=v++;v+=4;return a+v;}',
 'runtime-vectors':'typedef int V __attribute__((vector_size(16)));typedef int W __attribute__((vector_size(128)));int main(void){V a={1,2,3,4};V b={4,3,2,1};W w={5,6};return (a*b)[2]+w[1];}',
}
sources.update({'inline-compound-tag': 'struct I; int f(void){return ((struct B {int n;struct I*p __attribute__((counted_by(n)));}){1}).n;}', 'inline-compound-anonymous': 'struct I; int f(void){return ((struct {int n;struct I*p __attribute__((counted_by(n)));}){1,0}).n;}', 'inline-typeof-initializer': 'struct I; int f(void){__typeof__(struct {int n;struct I*p __attribute__((counted_by(n)));}) v={1};return v.n;}', 'inline-sizeof-compound': 'struct I; int f(void){return sizeof((struct {int n;struct I*p __attribute__((counted_by_or_null(n)));}){1});}', 'late-block-definition': 'int early(void){return 7;} struct I; int f(void){return ((struct B {int n;struct I*p __attribute__((counted_by(n)));}){1}).n;}'})
matrix=[];atom=[]
for i,(element,width) in enumerate([('unsigned char',1),('short',2),('int',4),('double',8)]):
 for size in (8,16,32,64,128,256):
  name=f'v{i}_{size}';lanes=size//width
  matrix.extend([f'typedef {element} {name} __attribute__((ext_vector_type({lanes})));',
   f'{name} add_{name}({name} a,{name} b){{return a+b;}}',
   f'{element} sub_{name}({name} a,int index){{return a[index];}}',
   f'void store_{name}({name} *p,int i,{element} x){{(*p)[i]=x;}}',
   f'{name} scalar_{name}({name} p,{element} x){{return p+x;}}'])
  if element!='double':
   matrix.append(f'{name} logic_{name}({name} a,{name} b){{return (a>b)?a:b;}}')
   matrix.append(f'{name} sat_{name}({name} a,{name} b){{return __builtin_elementwise_add_sat(a,b);}}')
for i,t in enumerate(['unsigned char','short','int','long long']):
 atom.extend([f'typedef _Atomic({t}) atomic_{i};',f'{t} read_{i}(atomic_{i} *p){{return *p;}}',
  f'{t} update_{i}(atomic_{i} *p,{t} x){{return (*p+=x);}}',
  f'{t} bump_{i}(atomic_{i} *p){{return (*p)++;}}',
  f'{t} swap_{i}(atomic_{i} *p,{t} v){{return __c11_atomic_exchange(p,v,5);}}'])
sources['generated-vector-widths']='\n'.join(matrix)
sources['generated-atomic-updates']='\n'.join(atom)
for n,s in sources.items():(q/(n+'.c')).write_text(s+'\n')
probes={n:['-std=c23','-nostdinc',q/(n+'.c')] for n in sources}
