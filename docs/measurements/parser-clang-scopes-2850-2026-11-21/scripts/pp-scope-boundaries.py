import hashlib,os,subprocess,sys
from pathlib import Path
before,after,out=map(Path,sys.argv[1:]);out.mkdir(parents=True,exist_ok=True)
unit=out/'unit.c';obj=out/'current.o'; header=out/'line.h'
header.write_text("#define MAKE(x) x\n#define STAMP _Pragma(\"clang diagnostic push\")\n")

cases={
    'plain':'int a[6]; int f(int n){return a[n];}',
    'macro-call':'#define N 1\nint f(int,int); int g(void){return f(3,N);}',
    'macro-before-open':'#define N 1\nint f(int,int);int g(void){return f(3,N);} [[deprecated]] int a;',
    'macro-after-open':'#define N 1\n[[deprecated]] int a; int f(int,int);int g(void){return f(3,N);}',
    'clang-scope':'[[__clang__::always_inline]] static inline int f(void){return 3;}',
    'clang-comma':'[[maybe_unused,__clang__::always_inline]] static inline int f(void){return 1;}',
    'alias-clang':'#define ALIAS __clang__\n[[ALIAS::always_inline]] static inline int f(void){return 2;}',
    'numeric':'[[5::unused]] int a;',
    'two-macro-brackets':'#define L [\nL L maybe_unused ]] int a;',
    'digraph':'<:<:maybe_unused:>:> int a;',
    'pragma':'#pragma pack(push,1)\nstruct S{char c;int x;};\n#pragma pack(pop)\nint s=sizeof(struct S);',
    'pragma-between':'[\n#pragma pack()\n[maybe_unused]] int a;',
    'pragma-clang':'[\n#pragma pack()\n[__clang__::always_inline]] static inline int f(void){return 7;}',
    'split':'#define N __clang__\nstruct [[gnu::packed]] S{int x;}; int f(void){return sizeof(struct S);}',
    'broken':'int f(int i){return i[3;}',
    'empty':''
}
pads=(0,1,2,30,60,61,62,63,64,65,125,126,127,128,129,16381)
def run(cc,mode,args):
    env={**os.environ,'BUSTER_TEST_SCOPE_ADMISSION':str(mode)}
    obj.unlink(missing_ok=True);q=subprocess.run([cc,*args,unit],capture_output=True,env=env)
    return q.returncode,q.stdout,q.stderr,obj.read_bytes() if obj.exists() else b''
with (out/'cases.tsv').open('w') as log:
 for pad in pads:
  for name,body in cases.items():
   unit.write_text(';'*pad+'\n'+body+'\n')
   for flags in (['-fsyntax-only'],['-Wall','-Wextra','-fsyntax-only'],['-g','-c','-o',str(obj)],['-c','-o',str(obj)]):
    ref=run(before,0,flags)
    for mode in (1,2,3):
     test=run(after,mode,flags)
     if test!=ref: raise SystemExit((pad,name,mode,flags,ref[:3],test[:3]))
    print(pad,name,flags,ref[0],*(hashlib.sha256(x).hexdigest() for x in ref[1:]),sep='\t',file=log,flush=True)
print('1024 source/policy observations, all three arms matched parent on stdout, diagnostics, status and complete object')
