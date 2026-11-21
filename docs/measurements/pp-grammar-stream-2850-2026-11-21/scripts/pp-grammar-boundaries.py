import hashlib,os,subprocess,sys
from pathlib import Path
before,after,out=map(Path,sys.argv[1:]);out.mkdir(parents=True,exist_ok=True)
unit=out/'unit.c';obj=out/'current.o'; header=out/'line.h'
header.write_text("#define MAKE(x) x\n#define STAMP _Pragma(\"clang diagnostic push\")\n")
cases={
    'plain':'int f(int x){return x+3;}', 'split-colon':'struct S {int x;};int f(void){return 3 :: 2;}',
    'pragma':'#pragma pack(push,1)\nstruct S{char c;int x;};\n#pragma pack(pop)\nint size=sizeof(struct S);',
    'broken':'int f(int x){return (x+;}','macro':'#include "line.h"\nMAKE(int) both(void){return (3);}',
    'pragma-in-macro':'#include "line.h"\nSTAMP\nint a;\n#pragma clang diagnostic pop',
    'no-tokens':'/*foo*/','raw-grammar':'typedef int I; int (*p)(I);int f(void){return __extension__ (1+2);}',
    'typo':'typedef int Type; int f(void){Tipe a;return a;}',
    'language':'struct [[gnu::packed]] S{int x;}; int s=sizeof(struct S);'
}
pads=(0,1,2,31,60,61,62,63,64,65,125,126,127,128,129,16381,16384)
def run(cc,mode,args):
    env={**os.environ,'BUSTER_TEST_PP_GRAMMAR_STREAM':str(mode)}
    obj.unlink(missing_ok=True);q=subprocess.run([cc,*args,unit],capture_output=True,env=env)
    return q.returncode,q.stdout,q.stderr,obj.read_bytes() if obj.exists() else b''
with (out/'cases.tsv').open('w') as log:
 for pad in pads:
  for name,body in cases.items():
   unit.write_text(';'*pad+'\n'+body+'\n')
   for flags in (['-fsyntax-only'],['-Wall','-Wextra','-fsyntax-only'],['-g','-c','-o',str(obj)],['-c','-o',str(obj)]):
    ref=run(before,0,flags)
    for mode in (1,2):
     test=run(after,mode,flags)
     if test!=ref: raise SystemExit((pad,name,mode,flags,ref[:3],test[:3]))
    print(pad,name,flags,ref[0],*(hashlib.sha256(x).hexdigest() for x in ref[1:]),sep='\t',file=log,flush=True)
print('680 source/policy observations, writer and consumer each matched the parent on stdout, diagnostics, status and complete object')
