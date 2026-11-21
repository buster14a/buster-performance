from pathlib import Path
import sys,ast,re,csv,subprocess,hashlib
d=Path(__file__).resolve().parent;w=d.parent;group=sys.argv[1] if len(sys.argv)>1 else 'avail'
src=w/('availability-key-words' if group=='avail' else 'declaration-list-heads')
out=w/('availability-keys-study' if group=='avail' else 'declaration-list-study')/'focused'
if group=='avail':
 s=(src/'src/buster/compiler/c_check_deprecated_walk_test.c').read_text()
 a=s.index('= {') if '= {' in s[:s.index('typedef struct')] else s.index('{')
 b=s.index('\n};',a)
 cases=[''.join(ast.literal_eval(x) for x in re.findall(r'"(?:\\.|[^"\\])*"',chunk)) for chunk in re.split(r',\s*\n',s[a:b])]
 cases=[x for x in cases if x.strip()]
 cases+=['extern int x __attribute__((deprecated)); int a(void){return 1;}','extern int x __attribute__((deprecated)); extern int x; int a(void){return x;}','enum E { first __attribute__((deprecated)), other }; int a(void){return first;}','typedef struct __attribute__((unavailable)) {int v;} S; int a(S *s){return 3;}','int f(void) __attribute__((unavailable)); int a(void){return f();}']
else:
 cases=['int a[]={1,2}, b[]={3,4,5}; int z=sizeof(a)+sizeof(b);','extern int n; int t(int n){int a[]={n,n+1},b[]={n+2,n+3}; return sizeof(a)+b[0];}','extern int a; int f(int a, int b[a]) { int x = a, y=x+1; return b[y]; }','int x=1; int f(void){int x=x; return x;}','typedef int T; int f(void){T a[]={2,3}; {typedef char T; T b[]={1,2,3}; return sizeof(a)+sizeof(b);} }','extern int f(int a); int f(int a){int b=a; { int a=b; b=a+1; } return b;}','int q[][2]={{1,2},{3,4}}; int f(void){return sizeof(q);}','int x[] = {[7]=3}, y[] = {[3]=2}; _Static_assert(sizeof(x)==32,"bound"); int f(void){return y[3];}','int f(void){int k=sizeof(k);return k;}','int a[2]={1,2,3};','int a[]={u};','typedef int T; int f(T a){return a;} int g(void){return f(3);}']
bins=[w/'main-fbef-clean/build/compiler',src/'build/compiler'];clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
headers=['case','std','policy','lanes','matched','status','clang syntax status','object','stdout','diagnostics']
def digest(s):return hashlib.sha256(s).hexdigest()
with (out/'checks.tsv').open('w',buffering=1) as f:
 rows=csv.writer(f,delimiter='\t',lineterminator='\n');rows.writerow(headers)
 for i,c in enumerate(cases):
  path=out/(str(i)+'.c');path.write_text(c+'\n');obj=out/'same.o'
  for std in ('c17','gnu17','c23'):
   for pol,flags in [('default',[]),('warnings',['-Wall','-Wextra']),('error',['-Werror=deprecated-declarations'])]:
    oracle=subprocess.run([clang,'-std='+std,'-nostdinc','-fsyntax-only',*flags,path],capture_output=True)
    for lane in [1,4]:
     r=[]
     for cc in bins:
      obj.unlink(missing_ok=True)
      p=subprocess.run([cc,'-std='+std,'--lanes',str(lane),'-nostdinc','-c',*flags,path,'-o',obj],capture_output=True,timeout=45,cwd=src)
      r.append((p.returncode,digest(obj.read_bytes()) if obj.exists() else '-',digest(p.stdout),digest(p.stderr)))
     rows.writerow([i,std,pol,lane,int(r[0]==r[1]),r[1][0],oracle.returncode,*r[1][1:]])
     assert r[0]==r[1],(i,std,pol,lane)
