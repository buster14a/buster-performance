from pathlib import Path
import sys,hashlib,itertools,subprocess
a,b,out=map(Path,sys.argv[1:])
prefix='typedef unsigned long size_t; typedef struct Pair {int x,y;} Pair;\n'
sources=[
'int f(int a) { return sizeof(int[a]); }',
'long f(int a) { return sizeof(int (*)[a]); }',
'signed char f(int a) { return sizeof(int); }',
'unsigned char f(int a) { return _Alignof(long double); }',
'void f(int a) { return; }',
'void f(int a) { return a; }',
'int f(int a) { return; }',
'Pair f(int a) { return (Pair){.y=a,.x=(int)sizeof (Pair)}; }',
'int *f(int *a) {return a+1;}',
'long f(int a){return _Generic(a,int:(short)a,default:(long)a);}',
'int f(int a){return ({if(a)return 2;42;});}',
'int f(int a){return ({if(a)return sizeof(int[a]);a++;});}',
'int f(int a){return ({_Generic(a,int:a,default:1);});}',
'_Noreturn void f(int a){ if(a) return; __builtin_trap();}',
'enum E{ A,B }; enum E f(int a){return (enum E)a;}',
'__attribute__((naked)) void f(void){__asm__("ret");}',
'char* f(void){return (char*)__PRETTY_FUNCTION__;}',
'int f(int x) { return sizeof (x + (int)sizeof(int)); }',
'double f(double x){return (double)(x + 0x1p-3);}',
'struct T{ long x; }; struct T f(void){return (struct T){7};}',
'int f(void) { return return 0; }','return 7;','int f(int x){ return (x,); }',
'int f(int n){ typedef int A[n]; return sizeof(A); }',
'#define RETURN return\nint f(void){RETURN 8;}',
'int f(int x){goto L;return x+1;L: return sizeof(x);}',
'const void *f(void){ return ({(void*)0;}); }']
flags=[[],['--no-deferred-bodies'],['--deferred-bodies','--lanes','4'],['--scalar'],['--poison-arenas'],['-g'],['--tier1'],['-Weverything','-Wno-c++-compat'],['-Wall','-Wextra','-Werror']]
stats=dict(pairs=0,differences=0,objects=0)
with (out/'pairs.tsv').open('w') as data:
 for idx,fl in itertools.product(range(len(sources)),range(len(flags))):
  src=out/'return.c';o=out/'return.o';src.write_text(prefix+sources[idx]+'\n')
  def run(cc):
   o.unlink(missing_ok=True)
   r=subprocess.run([cc,'-std=gnu17','-c',*flags[fl],src,'-o',o],capture_output=True)
   return (r.returncode,r.stdout,r.stderr,hashlib.sha256(o.read_bytes()).hexdigest() if o.is_file() else '')
  x,y=run(a),run(b);stats['pairs']+=1;stats['differences']+=x!=y;stats['objects']+=bool(y[3])
  print(idx,fl,x[0],y[0],x[3],y[3],x==y,sep='\t',file=data)
  if x!=y: print(idx,fl,repr(x),repr(y))
print(stats)
sys.exit(bool(stats['differences']))
