from pathlib import Path
import csv, hashlib, os, subprocess, sys
d=Path(__file__).resolve().parent
base=d/'cases';base.mkdir(exist_ok=True)
binary=(d/'../live-native-parser/build/compiler').resolve()
probe=(d/'../live-pp-forest-study/live').resolve()
mode=sys.argv[1]
# Make the declarations visible on both sides of at least two real preprocessing checkpoints.
split=''.join(f'extern int a{i};\n'+('#define TICK_'+str(i)+' 1\n' if i%256==255 else '') for i in range(5200))
split2=split.replace('int a','int b').replace('TICK_', 'TOCK_')
forms={
 'typedef-shadow':('typedef int T; typedef struct P { T n; } P;','int fun(P* p) { T n = p->n; { int T=2; n+=T; } return n; }'),
 'tag-shadow':('struct S {int n;}; typedef int R;','R f(struct S s) { struct S { long n; }; struct S t = {2}; return t.n + s.n; }'),
 'old-style':('typedef int I;','int f(a,b) I a; I b; { return a+b; }'),
 'function-pointer':('typedef int (*Fn)(int);','static int twice(int n){return n+n;} Fn fs[] = {twice}; int f(void){return fs[0](2);}'),
 'pack':('#pragma pack(push,1)\ntypedef struct { char a; int b; } Packed;','int f(void){ return sizeof(Packed); }\n#pragma pack(pop)'),
 'pragma-macro':('#define PACK _Pragma("pack(push,1)")\nPACK\nstruct P { char x; int y; };','_Pragma("pack(pop)")\nint f(void){return sizeof(struct P);}'),
 'attribute':('extern int value __attribute__((deprecated("old")));','int f(void) { return value; }'),
 'gnu-asm':('extern int ext(void) __asm__("other");','int f(void){int x=ext(); __asm__("" : "+r"(x)); return x;}'),
 'generic':('typedef double X;','int f(X x){ return _Generic(x, X:1, default:2); }'),
 'type-complete':('struct A; typedef struct A A; extern A* get(void);','struct A { int i; }; int f(void){return get()->i;}'),
 'split-attributes':('typedef unsigned U;','__attribute__((unused)) static U f(U n) __attribute__((unused)); static U f(U n){return n;}'),
 'alignment':('typedef int E[2];','struct A { _Alignas(16) E e; }; int f(void){ return _Alignof(struct A); }'),
 'initializer-body':('struct A {int n;};','struct A p=(struct A){3}; int f(void) { return ((struct A){ .n=p.n }).n; }'),
 'included':('#include "prefix.h"','H f(H v){return v+1;}'),
 'line-warning':('#line 310 "mapped-input.c"\n#warning from live preprocessing','int f(void){return 4;}'),
 'recovery':('typedef int T;','int f(T a) { return a + ; } int g(void) { return 1; }'),
 'preprocessor-fatal':('typedef int T;','#error deliberate\nint f(void){return sizeof(T);}'),
 'unknown-type':('typedef int Good;','extern Missing v; Good f(void){return 2;}'),
 'c23-scope':('typedef int T;','[[__clang__::unavailable]] int dead(void); T f(void){return 0;}'),
}
(base/'prefix.h').write_text('typedef int H;\n')
output=d/('edges-'+mode+'.tsv')
with output.open('w') as fh:
 t=csv.writer(fh,delimiter='\t',lineterminator='\n');t.writerow(['case','policy','reference','candidate','object','stdout','stderr','audit'])
 for name,(before,after) in forms.items():
  src=base/(name+'.c');src.write_text(before+'\n'+split+after+'\n'+split2)
  flags=['-march=native','-std=gnu17','-I'+str(base),str(src)]
  if mode=='forest':
   r=subprocess.run([probe,*flags],capture_output=True)
   (base/(name+'.tree.stderr')).write_bytes(r.stderr)
   row=r.stdout.decode().replace('\n',' ').strip()
   t.writerow([name,'parse','',r.returncode,'','','',row]);fh.flush()
   if r.returncode not in (0,5,6,7) or 'different-tree-or-input-rows=' in row and not row.endswith('different-tree-or-input-rows=0'):raise SystemExit((name,r.returncode,row))
   continue
  for policy,extra in [('default',[]),('strict',['-Wall','-Wextra','-Werror']),('all',['-Weverything'])]:
   results=[]
   for arm,new in [('ordinary',False),('live',True),('audit',True)]:
    prefix=base/(name+'-'+policy+'-'+arm); obj=prefix.with_suffix('.o');obj.unlink(missing_ok=True)
    env=os.environ.copy()
    if new:env['BUSTER_PARSE_LIVE_FOREST']='1'
    if arm=='audit':env['BUSTER_PARSE_LIVE_AUDIT']='1'
    r=subprocess.run([binary,'--lanes','1','-c',*flags,*extra,'-o',obj],capture_output=True,env=env)
    prefix.with_suffix('.stderr').write_bytes(r.stderr)
    results.append((r.returncode,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else None,r.stdout,r.stderr))
   a,b,c=results;t.writerow([name,policy,a[0],b[0],int(a[1]==b[1]),int(a[2]==b[2]),int(a[3]==b[3]),next((l for l in c[3].decode().splitlines() if l.startswith('live-forest')),'')]);fh.flush()
   if a!=b or a[:3]!=c[:3]: raise SystemExit((name,policy,'diff'))
