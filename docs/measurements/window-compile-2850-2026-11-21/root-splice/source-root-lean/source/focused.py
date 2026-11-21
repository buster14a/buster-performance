from pathlib import Path
import sys,subprocess,csv,hashlib,os,re,resource
d=Path(__file__).resolve().parent;rev=sys.argv[1];cc=d/(rev+'-compiler');where=d/rev/'focused';where.mkdir(parents=True,exist_ok=True)
resource.setrlimit(resource.RLIMIT_CORE,(0,0))
cases = {
 'storage':'''extern int ac; int ac; extern int ac; static int bc; extern int renamed __asm__("actual_name"); static int localcopy;
int source(int x){ int a=x,b=2; a=b; ac=3; bc=7; localcopy=42; renamed=8; { int b=ac; a=b; } return a; }
int reads(void){return ac+bc;} int copies(void){ static int z; z=3; return z; }''',
 'weak':'''extern int weakx __attribute__((weak)); extern int ex; int ex; static __thread int tls; extern volatile int device;
int f(int x){ int a; a=x; if(&weakx) ex=2; tls=6; device=ex; return a; }
int g(void){return weakx;} int h(void){return tls;}''',
 'opt':'''struct S {int x;}; enum E{STEP=2}; typedef int integer;
#pragma STDC FENV_ACCESS ON
extern int iv; int y(int x){ const int c=4; volatile int o=iv; register int r=x; int a=0; a=c; if(o) a=r; return a; }
int z(int x){ int v[x+1]; v[x]=1; return v[x]+STEP; } int w(struct S a){return a.x;}''',
 'labels':'''#define LABEL(x) ({__label__ end; int z=0; if(x) goto end; z=1; end:z;})
int a(int x){return LABEL(x)+LABEL(x-1);} static int k;
int sx(int x){if(0)k=4; if(1&&0)k=8; if(x){k=9;} return 1+(2*3);}
static int closed(int k){k=2;return k;}''',
 'integer':'''unsigned x=0; long long wide; int w(int a){ if(a) return (1+2)*(7-3); x=4294967295u;return x; }
int r(int k){int j=4,m; m=j; if(k) return -1; return j+~6;}
int s(void){return (32767*65537) & 0x7fffffff;} int plus(int k){return +k;}''',
 'warn':'''int g; int f(int a){int un; int b=1; g=2; a=b; return un; }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wuninitialized"
int h(int a){int u; g=a; return u;}
#pragma clang diagnostic pop
int u(void){return 2147483647 + 1;}''',
 'asm':'''static int a; int f(int x){int z; asm volatile ("" : "=r"(z) : "0"(x)); a=1;return z;}
extern int __attribute__((address_space(256))) *t; int g(void){return *t;}''',
 'bad':'''int incomplete; int f(int p){int s=3; if(p) incomplete=2; s=bad_name; return s;}'''
}
flags=[[],['-g'],['--poison-arenas'],['-g','--poison-arenas','-Wall','-Wextra'],['-Wall','-Werror'],['-Weverything'],['-Wuninitialized'],['-Wunused-but-set-parameter'],['--lanes','2'],['--verify'],['--scalar'],['--tier1','-g'],['--deferred-bodies','--lanes','2'],['-std=c23']]
def sha(data):return hashlib.sha256(data).hexdigest()
rows=[]
for case,source in cases.items():
 src=where/(case+'.c');src.write_text(source+'\n')
 for pos,f in enumerate(flags):
  seen=[];n=used=0
  for option in [[],['--node-window-source']]:
   env=dict(os.environ,NODE_SOURCE_COMPACT_REPORT='1',NODE_SPLICE_REPORT='1'); target=where/'f.o'; native=where/'f.native'
   target.unlink(missing_ok=True);native.unlink(missing_ok=True);env['NODE_SOURCE_NATIVE_ORACLE']=str(native)
   r=subprocess.run([str(cc),*f,*option,'-c',str(src),'-o',str(target)],capture_output=True,env=env)
   lines=r.stderr.splitlines(keepends=True)
   diagnostic=b''.join(z for z in lines if not z.startswith((b'compact-taken:',b'compact-consumed:',b'splice-taken:',b'splice-local-class:')))
   seen.append((r.returncode,sha(r.stdout),sha(diagnostic),sha(target.read_bytes()) if target.exists() else '-',sha(native.read_bytes()) if native.exists() else '-'))
   if option:n=sum(l.startswith(b'compact-taken:') for l in lines);used=sum(l.startswith(b'compact-consumed:') for l in lines)
  rows.append((case,pos,n,used,seen[0]==seen[1],*seen[0],*seen[1]))
with (where/'results.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['case','policy','physical','emitted','same',*[a+'_'+v for a in ['plain','option'] for v in ['status','stdout','stderr','object','native']]]);w.writerows(rows)
print(len(rows),'paired',sum(r[2] for r in rows),'physical',sum(r[3] for r in rows),'emitted',[(r[0],r[1],r[5],r[10]) for r in rows if not r[4]])
