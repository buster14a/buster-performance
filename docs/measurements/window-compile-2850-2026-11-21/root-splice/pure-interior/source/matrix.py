from pathlib import Path
import os,sys,subprocess,re,csv,hashlib,resource
d=Path(__file__).resolve().parent;rev=sys.argv[1];exe=d/(rev+'-compiler');res=d/rev/'matrix';res.mkdir(exist_ok=True);src=res/'inputs';src.mkdir(exist_ok=True)
resource.setrlimit(resource.RLIMIT_CORE,(0,0))
exprs=['1 + 2','4 - 4','0 + 0','+0','-1','~0','4 * 8','9 / 3','8 % 3','1 << 3','16 >> 2','3 < 1','3 > 1','4 >= 2','4 != 4','7 == 7','6 & 3','6 | 3','6 ^ 3','(1 + 2) * (3 + 4)','-(2 + 5)','((3 - 3))','0 / (3 - 3)','(3 - 3) / 0','1 / 0','2147483647 + 1','(-2147483647 - 1) / -1','1 << 32','-2 << 1','2147483647 << 1','1 << -1','-(~2147483647)','0u + 2','0x4 + 2','1L + 2','(unsigned)1 + 2','1 + (7 / 3)','K + 1','0 && (1 / 0)','__COUNTER__ + 0','-0','K ? 2 + 3 : 3 + 4']
forms={
 'runtime':'''extern int sink(int,int); int f(int n,int *a){int k=EX; int v=sink(EX,n); a[n & 1]=2 + (EX); if (n && (EX)) v++; return v+k+999*(EX); }''',
 'switch':'''int f(int n){switch(n){case EX: return 1; default: return 2;}}''',
 'bound':'''int a[((EX) & 7)+1]; int f(void){return (int)sizeof(a);}''',
 'static':'''enum E{ C=EX }; static int a[]={ [1 + 3] = EX }; static int g=EX; _Static_assert((EX) == C, "test"); int f(void){return a[4] + g;}''',
 'unselected':'''int f(int n){return sizeof((EX)+n) + (n ? +0 : 2+4) + (0 && (EX)) + _Generic(2, int:3, default:(EX));}''',
 'pointer':'''extern void sink(void*); void *p=(EX); int f(int *q){sink(EX); return q==(EX);}''',
 'pragma':'''#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
int f(int n){unsigned char z = EX; if ((EX) & n) return z; return n ? (EX) : z;}
#pragma clang diagnostic pop
''',
 'stmt':'''int f(int n){ int x=({ n += EX; (EX); }); return ({ int z=(EX); n ? z : x; });}''',
 'macro':'''#define H(x,y) ((x)+(y))
#line 700 "arithmetic-origin.h"
int f(int n){ return H(n, EX); }''',
}
policies=[[],['-g'],['-Wall','-Wextra'],['-Weverything'],['-Werror','-Wall','-Wextra'],['-std=c23','-pedantic'],['-fwrapv','-fno-strict-overflow'],['-g','--poison-arenas'],['--deferred-bodies','--lanes','2'],['--verify','--attested=verify'],['--scalar']]
sha=lambda b:hashlib.sha256(b).hexdigest();tot=0;take=0;bad=0
with (res/'pairs.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t',lineterminator='\n');out.writerow(['expr','form','policy','taken','removed','same',*[m+'_'+k for m in ['plain','source'] for k in ['status','stdout','diagnostics','object','native']]])
 for j,e in enumerate(exprs):
  for form,s in forms.items():
   fn=src/(f'{j:02}-{form}.c');fn.write_text('#define K 3\n'+s.replace('EX','('+e+')')+'\n')
   for i,flags in enumerate(policies):
    modes=[];logs={}
    for mode in ('plain','source'):
     o=res/(mode+'.o');w=res/(mode+'.native');o.unlink(missing_ok=True);w.unlink(missing_ok=True)
     env={**os.environ,'NODE_SOURCE_NATIVE_ORACLE':str(w)}
     if mode=='source':env.update(NODE_PURE_INTERIOR='1',NODE_PURE_INTERIOR_REPORT='1')
     r=subprocess.run([exe,'--lanes','1',*flags,'-c',fn,'-o',o],capture_output=True,env=env)
     msgs=r.stderr.splitlines(keepends=True);take_rows=[l for l in msgs if l.startswith(b'interior-taken:')];diag=b''.join(l for l in msgs if not l.startswith(b'interior-taken:'));logs[mode]=diag
     modes.append((r.returncode,sha(r.stdout),sha(diag),sha(o.read_bytes()) if o.exists() else '',sha(w.read_bytes()) if w.exists() else ''))
    eq=modes[0]==modes[1];taken=len(take_rows);removed=sum(int(re.search(rb'removed=(\d+)',l)[1]) for l in take_rows);tot+=1;take+=taken;bad+=not eq
    out.writerow([e,form,i,taken,removed,eq,*modes[0],*modes[1]])
    if not eq:
     for m,msg in logs.items():(res/(f'{j:02}-{form}-{i}-{m}.err')).write_bytes(msg)
   f.flush()
print(tot,take,bad)
