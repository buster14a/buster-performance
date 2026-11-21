import subprocess,sys,hashlib
from pathlib import Path
before,after,work=map(Path,sys.argv[1:]);work.mkdir(exist_ok=True)
out=work/'current.o';unit=work/'unit.c';header=work/'open.h'
prefixes=[0,1,2,31,60,61,62,63,64,65,126,127,128,129]
snips={
 'keyword':'#define int long\nint f(int a){return a+7;}\n#undef int\nint g(int a){return f(a);}',
 'redefine':'#define return return 3+\nint f(void){ return 2;}\n#undef return\nint g(void){return 2;}',
 'push':'#define int long\n#pragma push_macro("int")\n#undef int\n#define int short\nint w;\n#pragma pop_macro("int")\nint y;',
 'self':'#define if if\nint f(int x){if(x)return x;return 4;}',
 'paste':'#define JOIN(a,b) a##b\n#define RR(a) JOIN(re,turn) a\n#define return return 6+\nint f(void){RR(4);}',
 'pragma':'#define P _Pragma("clang diagnostic push")\nP\nint v;\n_Pragma("clang diagnostic pop")',
 'poison':'#pragma GCC poison int\nint bad;',
 'define-external':'#include "open.h"\nint f(int x){return x;}\n#undef int\nint g(int y){return y;}',
 'conditional':'#define switch _Bool\n#if defined(switch)\nswitch pred;\n#endif\n#undef switch',
 'rejected':'#define while if\nint broken(void){while(;return 1;}',
}
header.write_text('#define int long\n')
with (work/'cases.tsv').open('w') as log:
 for pad in prefixes:
  for shape,body in snips.items():
   unit.write_text('int pad0;\n'+';'*pad+'\n'+body+'\nint tail[1];\n')
   for opts in (['-E'],['-E','-P'],['-c','-o',str(out)],['-g','-Wall','-Wextra','-c','-o',str(out)]):
    runs=[]
    for cc in (before,after):
     out.unlink(missing_ok=True);q=subprocess.run([cc,*opts,unit],capture_output=True)
     runs.append((q.returncode,q.stdout,q.stderr,out.read_bytes() if out.is_file() else b''))
    if runs[0]!=runs[1]: raise RuntimeError((pad,shape,opts))
    rc,so,se,obj=runs[0];hs=[hashlib.sha256(v).hexdigest() for v in (so,se,obj)]
    print(pad,shape,' '.join(opts),rc,*hs,sep='\t',file=log,flush=True)
print('560 marker, text, normal/debug object and diagnostic pairs matched')
