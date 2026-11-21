import hashlib,json,subprocess,sys
from pathlib import Path
base,cand,slot=map(Path,sys.argv[1:])
slot.mkdir(parents=True,exist_ok=True); main=slot/'unit.c'; obj=slot/'unit.o'
defs="""enum E { A=1,B=2 }; enum F { C=3,D=4 }; enum { U=5 }; typedef enum { V=6 } Named;
#define MIX(x,y) ((x)+(y))
"""
groups={
"named-compare":("enum-compare","(A == C)"),
"anon-compare":("anon-enum-enum-conversion","(A == U)"),
"named-int":("enum-enum-conversion","MIX(A,C)"),
"anon-int":("anon-enum-enum-conversion","MIX(A,U)"),
"typedef-int":("enum-enum-conversion","MIX(A,V)"),
"condition":("enum-compare-conditional","(x ? A : C)"),
"floating":("enum-float-conversion","(int)(A+1.25)"),
}
flags={"default":[],"wall":["-Wall","-Wextra"],"all":["-Wconversion","-Wanon-enum-enum-conversion"],"named":["-Wno-anon-enum-enum-conversion","-Wenum-enum-conversion","-Wenum-compare","-Wenum-compare-conditional"],"anon":["-Wno-enum-compare","-Wanon-enum-enum-conversion"],"quiet":["-w"],"fatal":["-Werror","-Wfatal-errors","-Wenum-conversion","-Wanon-enum-enum-conversion"]}
def pragma(level,name):return f'#pragma clang diagnostic {level} "-W{name}"\n'
def run(cc,opts):
    obj.unlink(missing_ok=True)
    p=subprocess.run([cc,*opts,'-c','-o',obj,main],capture_output=True)
    return p.returncode,p.stdout,p.stderr,obj.read_bytes() if obj.exists() else b''
def stat(x):
    if isinstance(x,int):return x
    return hashlib.sha256(x).hexdigest()
with (slot/'cases.tsv').open('w') as out:
 for key,(group,expr) in groups.items():
  fn='int fn(int x){ return '+expr+'; }\n'
  variants={
   "bare":fn,
   "pragma": pragma('warning',group)+fn,
   "pushpop":'#pragma clang diagnostic push\n'+pragma('ignored',group)+fn+'#pragma clang diagnostic pop\n'+fn.replace('fn(', 'fn2('),
   "system":'#include "header.h"\n'+fn.replace('fn(', 'fn2('),
   "repaired":pragma('warning',group)+fn+'int broken(void){return (1+;\n',
  }
  (slot/'header.h').write_text('#pragma GCC system_header\n'+pragma('warning',group)+fn)
  for shape,s in variants.items():
   main.write_text(defs+s)
   for policy,args in flags.items():
    a,b=run(base,args),run(cand,args)
    if a!=b:
        for label,body in [('base',a),('candidate',b)]:(slot/f'failure.{label}').write_bytes(body[2])
        raise RuntimeError((key,shape,policy))
    print(key,shape,policy,a[0],len(a[2]),int(bool(a[-1])),*map(stat,a[1:]),sep='\t',file=out,flush=True)
print('245 status/stdout/stderr/full object pairs passed')
