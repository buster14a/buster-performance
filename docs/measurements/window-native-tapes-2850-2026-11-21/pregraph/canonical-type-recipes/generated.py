"""End-to-end checks of source type lifetime, direct calls and their fallback."""
import collections,hashlib,json,os,re,subprocess,sys,tempfile
from pathlib import Path
d=Path(__file__).resolve().parent
cc=Path(sys.argv[1]).resolve()
dest=Path(sys.argv[2]).resolve();dest.mkdir(parents=True,exist_ok=True)
cases={
    "functions":"extern int f(int); extern int g(int); int h(int a){f(a);g(a);return f(a);}",
    "reuse":"extern int f(int); int g(int a){ f(a);f(a);f(a); return f(a);}",
    "macro":"#define F(f,x) ((f)(x))\nextern int f(int); int g(int v){F(f,v); return F(f,2);}",
    "varargs":"extern int trace(const char*,...); int g(int a){trace(\"x\",a); return trace(\"y\",2,a,4L);}",
    "arg_designator":"int f(int); void apply(int (*)(int)); int g(void){apply(f);return f(11);}",
    "array":"extern int apply(int*); int g(int a){int v[9];v[0]=a;return apply(v);}",
    "const_array":"extern int get(const int*); int g(void){const int a[2]={2,3};return get(a);}",
    "vla":"extern int fetch(char*,int); int g(int a){char tmp[a];char *p; p=tmp; p[0]=42;return fetch(p,a);}",
    "array_pointer":"extern int get(int (*)[7]); int g(void){int a[7]={0};return get(&a);}",
    "ptr_qual":"int get(volatile int*); int g(void){volatile int a=0;return get(&a);}",
    "nested":"int a(int);int b(int);int g(int x){return a(b(x));}",
    "retaddr":"int n; int *p(void){return &n;} int get(const int*); int f(void){return get(p());}",
    "struct_arg":"struct S{int a,b;};int g(struct S);int h(int x){struct S s={x,3};return g(s);}",
    "indirect":"typedef int F(int);int g(F*fn,int x){int (*hold)(int)=fn;return hold(x);}",
    "fp_alias":"int f(int); typedef int F(int); F *const handler=f; int g(void){return handler(6);}",
    "complex":"extern double f(double); int g(int x){return f(x);}",
    "implicit":"int g(void){return missing(2);}",
    "bad_arg":"extern int f(int*); int g(void){return f(9);}",
    "scope":"extern int f(int); int g(int x){{int(*f)(int)=0;if(x) return f(6);}return f(x);}",
    "cond":"extern int f(int);int x;int g(void){if(0)f(3); x&&f(2);return f(1);}",
    "inline":"extern inline int f(int x){return x+1;} static int q(int x){return f(x);} int g(void){return q(8);}",
    "goto":"extern int f(int);int g(int a){goto body;skip:return f(0);body:if(a)goto skip;return f(1);}",
    "oversized":"extern int f(int);int g(int a){"+"f(a);"*600+"return f(a);}",
    "pragma":"#pragma clang diagnostic push\n#pragma clang diagnostic error \"-Wunused-value\"\nextern int f(int);int g(int a){a;return f(a);}\n#pragma clang diagnostic pop",
    "string_table":"extern int p(const char*);int g(void){return p(\"first\")+p(\"second\")+p(\"first\");}",
}
trace=('node-proof ','cross-','source-','node-front','probe-','splice-','loc-row ','node-shadow:')
base=dict(os.environ,NODE_PROOF_NO_FP='1',NODE_PROOF_POINTERS='1',NODE_PROOF_CALLS='1',NODE_SOURCE_ROWS='1',NODE_PROOF_NATIVE='1',NODE_CROSS_CHUNK='n',NODE_SPLICE_FRONT='1',NODE_SOURCE_STRINGS='1')
for k in ['NODE_CROSS_SYMBOLIC_CALLEE','NODE_CROSS_TYPE_VIEW','NODE_CROSS_TYPE_WIDE','NODE_SPLICE_ENABLE','NODE_SPLICE_REPORT']:base.pop(k,None)
results=[]
for name,src in cases.items():
 f=dest/(name+'.c');f.write_text(src+'\n')
 for tag,flags in [('default',[]),('warnings',['-Wall','-Wextra']),('error',['-Wall','-Wextra','-Werror']),('debug',['-g'])]:
  expect=None
  for lane,env in [('ordinary',{}),('front',dict(NODE_SPLICE_ENABLE='1')),('direct',dict(NODE_SPLICE_ENABLE='1',NODE_CROSS_TYPE_VIEW='1')),('wide',dict(NODE_SPLICE_ENABLE='1',NODE_CROSS_TYPE_VIEW='1',NODE_CROSS_TYPE_WIDE='1'))]:
   with tempfile.TemporaryDirectory(dir=dest) as directory:
    tmp=Path(directory);obj=tmp/'unit.o';g=tmp/'graph.bin'
    e=base|env
    if lane=='ordinary':e.pop('NODE_SPLICE_FRONT',None)
    res=subprocess.run([cc,'--lanes','1','-c',*flags,str(f),'-o',obj],env=e|{'NODE_SOURCE_GRAPH_ORACLE':str(g)},capture_output=True,timeout=60)
    lines=res.stderr.decode(errors='replace').splitlines()
    ordinary='\n'.join(l for l in lines if not l.startswith(trace))
    receipt=[res.returncode,res.stdout.hex(),ordinary,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '',hashlib.sha256(g.read_bytes()).hexdigest() if g.exists() else '']
    canonical=[l for l in lines if l.startswith('cross-canonical')]
    if expect is None: expect=receipt
    results.append([name,tag,lane,[i for i,(x,y) in enumerate(zip(expect,receipt)) if x!=y],receipt,canonical])
(dest/'matrix.json').write_text(json.dumps(results,indent=1)+'\n')
print(len(results),collections.Counter((a[2],tuple(a[3])) for a in results),flush=True)
