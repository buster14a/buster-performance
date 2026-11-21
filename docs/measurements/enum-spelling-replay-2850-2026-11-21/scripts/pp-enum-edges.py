"""Actual default, mapped and fatal warning streams plus complete normal and debug ELFs."""
import hashlib,subprocess,sys
from pathlib import Path
before,after,slot=map(Path,sys.argv[1:]);slot.mkdir(parents=True,exist_ok=True)
obj=slot/'result.o';unit=slot/'unit.c'
source={
'anon': 'enum E{E1}; enum {A}; int main(void){return E1==A;}',
'named-typedef': 'enum E{E1}; typedef enum {A} T; int main(void){return E1==A;}',
'late-typeof': 'enum E{E1}; enum {A} v; int main(void){return E1==A;} typedef __typeof__(v) Late;',
'qualified': 'enum E{E1}; enum {A} v; typedef const __typeof__(v) Late; int main(void){return E1==A;}',
'pointer': 'enum E{E1}; typedef enum {A} *Ptr; int main(void){return E1==A;}',
'aligned': 'enum E{E1}; typedef enum {A} T __attribute__((aligned(8))); int main(void){return E1==A;}',
'macro-definition': '#define MAKE(k) enum {k}\nenum E{E1};MAKE(A) v; int main(void){return E1==A;}',
'macro-substitution': '#define FORWARD(x) x\n#define MAKE(k) enum {k}\nenum E{E1};FORWARD(MAKE(A)) v; int main(void){return E1==A;}',
'macro-arg-tag': '#define BIND(k) k { A } v\nenum E{E1}; BIND(enum); int main(void){return E1==A;}',
'macro-typedef': '#define MAKE(k,name) typedef enum {k} name\nenum E{E1}; MAKE(A,T); int main(void){return E1==A;}',
'nested-scope': 'enum E{E1}; int main(void){enum {A} v; {typedef __typeof__(v) Local; Local q=A; if(q) return q;} return E1==A;}',
'bare-member': 'enum E{E1}; struct S { enum {A}; int a; }; int main(void){return E1==A;}',
'line-name': '#line 101 "file (unnamed here.c"\nenum E{E1}; struct S { enum {A}; int a; }; int main(void){return E1==A;}',
'rejected': '#define AFLAG enum {A}\nenum E{E1}; AFLAG v; int good(void){return A==E1;} int broken(void){return (1+;',
'file-order': 'enum E{E1}; enum {A} obj; int a(void){return E1==A;} typedef __typeof__(obj) Name; int b(void){return E1==A;}',
'redecl-nested':'enum E{E1}; enum {A} g; int fn(void){typedef __typeof__(g) T; typedef T TT; return E1==A;}',
'non-enum':'struct {int x;} a; struct {int x;} b; int main(void){return a==b;}',
'anonymous-structure':'struct S{union {int x; double y;};};struct {int x;} first,second;int main(void){return first==second;}',
}
policies={'default':[],'wall':['-Wall','-Wextra'],'anon':['-Wanon-enum-enum-conversion','-Wno-enum-compare'],'named':['-Werror=enum-compare','-Wno-anon-enum-enum-conversion'],'quiet':['-w'],'fatal':['-Wenum-conversion','-Wanon-enum-enum-conversion','-Werror','-Wfatal-errors']}
def run(cc,flags):
 obj.unlink(missing_ok=True)
 q=subprocess.run([cc,'-c',*flags,'-o',obj,unit],capture_output=True)
 return (q.returncode,q.stdout,q.stderr,obj.read_bytes() if obj.exists() else b'')
with (slot/'edges.tsv').open('w') as log:
 for name,body in source.items():
  unit.write_text(body+'\n')
  for policy,flags in policies.items():
   for debug in (False,True):
    opts=(['-g'] if debug else [])+flags;a=run(before,opts);b=run(after,opts)
    if a!=b:
     for tag,result in (('before',a),('after',b)):(slot/f'failure-{tag}.err').write_bytes(result[2])
     raise RuntimeError((name,policy,debug,a[0],b[0]))
    print(name,policy,debug,a[0],len(a[2]),int(bool(a[-1])),hashlib.sha256(a[2]).hexdigest(),hashlib.sha256(a[-1]).hexdigest(),sep='\t',file=log,flush=True)
print('216 targeted pairs passed')
