import argparse,csv,hashlib,os,subprocess,threading
from pathlib import Path
parser=argparse.ArgumentParser()
parser.add_argument('ordinary',type=Path)
parser.add_argument('candidate',type=Path)
parser.add_argument('out',type=Path)
args=parser.parse_args();d=args.out.resolve();d.mkdir(parents=True,exist_ok=True)
ordinary=args.ordinary.resolve();candidate=args.candidate.resolve()
src={'atoms':'int ext(int);static const int a[]={4,1,3};int y;int f(int x){return ext(x)+a[x%3]+y;}',
 'sections':'__attribute__((section(".text.one"),aligned(64))) int first(int x){return x+1;} __attribute__((section(".text.two"),aligned(128))) int second(int x){return first(x)-3;}',
 'symbols':'static int a;extern int b;extern __thread int tls;const void *refs[]={&a,&b};int f(void){return (a==b)+tls;}',
 'tables':'int g(int);int f(int i){switch(i){case 0:return g(4);case 1:return g(3);case 2:return g(8);case 3:return g(1);case 4:return g(7);case 5:return g(5);default:return -1;}}',
 'weak':'extern int ext(int) __attribute__((weak));int f(int i){return ext?ext(i):4;}',
 'runtime':'struct Big{int a[64];};struct Big f(struct Big x){struct Big a=x;return a;} int g(struct Big *x,struct Big *y){*x=*y;return x->a[0];}',
 'asm':'asm(".pushsection .text.asm_fragment,\\"ax\\"\\n.globl extra\\nextra: nop\\nret\\n.popsection");int f(int i){asm("" : "+r"(i));return i;}',
 'empty':'extern int g(int);',
 'invalid':'int f(void){return missing;}',
 'aligned':'int a(void){return 1;} int b(int) __attribute__((aligned(512))); int b(int x){return x+1;} int c(void){return 2;}',
}
src.update({
 'large-data':'const unsigned char big[65537]={[3]=1,[32769]=2,[65536]=7}; unsigned char other[8511]={[4234]=6}; unsigned f(unsigned n){return big[n%65537]+other[n%8511];}',
 'large-mixed':'int host;struct Row { int *at; char blob[4200]; };struct Row a[2]={{&host,"a"},{&host,"b"}}; int f(void){return a[1].blob[0];}',
 'comdat':'asm(".pushsection .text.shared,\\"axG\\",@progbits,shared,comdat\\n.weak shared\\n.type shared,@function\\nshared: call external\\nret\\n.size shared,.-shared\\n.popsection"); extern int shared(void);int use(void){return shared();}',
 'signed-addends':'extern char a[]; extern char b[]; char *p[]={a+17, a-41, b+0x100000010ULL, b-0x100000020ULL};',
 'local-string-pool':'static const char a[]="local"; static const char b[]="longer"; const char *act[] = {a,b+2}; const char *f(unsigned i){return act[i&1];}',
 'mixed-data':'extern int f(void);extern int e; int data; int (*fn)(void)=f; struct Record{int*a,*b;void*fn;}; static struct Record r={&e,&data, f}; int g(void){return r.a==r.b || f();}',
 'tlsforms':'extern __thread int external; static __thread int local; __thread int visible; int f(void){return external+local+visible;} int *g(void){return &local;}',
 'weak-locals':'static int s(void){return 1;} int f(void){return s();} extern __typeof(f) a __attribute__((weak,alias("f"))); int (*deps[])(void)={s,f,a};',
})
policies={'ordinary':[],'debug':['-g'],'sections':['-ffunction-sections','-fdata-sections'],'pic':['-fPIC'],'unwind':['-fasynchronous-unwind-tables'],'patch':['-fpatchable-function-entry=8,4'],'quiet':['-w']}
env={k:v for k,v in os.environ.items() if not k.startswith(("BUSTER_CONTROL_","BUSTER_OBJECT_","BUSTER_SOURCE_"))}
native=env|{k:'1' for k in ('BUSTER_CONTROL_EARLY_RELEASE','BUSTER_CONTROL_EARLY_NATIVE','BUSTER_SOURCE_WRITE_COLUMNS','BUSTER_SOURCE_GROW_GRAPH','BUSTER_SOURCE_RETIRE_LISTS','BUSTER_SOURCE_FILE_DATA','BUSTER_CONTROL_SOURCE_NATIVE')}
modes={
 'ordinary-rela':env|{'BUSTER_OBJECT_TEXT_STREAM':'1','BUSTER_OBJECT_EARLY_RELOCATIONS':'1'},
 'source-rela':native|{'BUSTER_OBJECT_TEXT_STREAM':'1','BUSTER_OBJECT_EARLY_RELOCATIONS':'1'},
 'fields-rela':native|{'BUSTER_OBJECT_TEXT_STREAM':'1','BUSTER_CONTROL_OBJECT_FIELDS':'1','BUSTER_OBJECT_EARLY_RELOCATIONS':'1'},
 'data-only':env|{'BUSTER_OBJECT_TEXT_STREAM':'1','BUSTER_OBJECT_DATA_SPANS':'1'},
 'data-rela':native|{'BUSTER_OBJECT_TEXT_STREAM':'1','BUSTER_OBJECT_TEXT_RUNS':'1','BUSTER_OBJECT_EARLY_RELOCATIONS':'1','BUSTER_OBJECT_DATA_SPANS':'1'},
 'packed-rela':native|{'BUSTER_OBJECT_TEXT_STREAM':'1','BUSTER_CONTROL_OBJECT_FIELDS':'1','BUSTER_OBJECT_TEXT_RUNS':'1','BUSTER_OBJECT_EARLY_RELOCATIONS':'1'},
}
sha=lambda data:hashlib.sha256(data).hexdigest()
def obs(c,e,p,flags,artefact):
 artefact.unlink(missing_ok=True)
 r=subprocess.run([c,'--lanes','1','-nostdinc','-c',*flags,p,'-o',artefact],env=e,stdin=subprocess.DEVNULL,capture_output=True,timeout=20)
 return (r.returncode,r.stdout,r.stderr,artefact.read_bytes() if artefact.exists() else None)
with (d/'cases.tsv').open('w',buffering=1) as t:
 w=csv.writer(t,delimiter='\t');w.writerow(('case','policy','mode','status','same-status','same-stdout','same-stderr','same-file','file-sha'))
 for name,text in src.items():
  p=d/(name+'.c');p.write_text(text+'\n')
  for policy,flags in policies.items():
   a=obs(ordinary,env,p,flags,d/'ordinary.o')
   for mode,e in modes.items():
    b=obs(candidate,e,p,flags,d/'candidate.o');w.writerow((name,policy,mode,b[0],*(int(x==y) for x,y in zip(a,b)),sha(b[3]) if b[3] is not None else ''))
    if a!=b:(d/(name+'-'+policy+'-'+mode+'.stderr')).write_bytes(b[2])
f=d/'atoms.c';a=obs(ordinary,env,f,[],d/'ordinary.o');expected=a[-1];answers=[]
for mode,e in modes.items():
 for dest in ('existing-file','hard-link','pipe','dev-null','dev-full'):
  p=d/(mode+'-'+dest+'.o');p.unlink(missing_ok=True); alias=d/(mode+'.saved');alias.unlink(missing_ok=True); data=[];th=None
  old=b'x'*(len(expected)+300)
  if dest=='existing-file':p.write_bytes(old)
  if dest=='hard-link':p.write_bytes(old);os.link(p,alias)
  if dest=='pipe':os.mkfifo(p);th=threading.Thread(target=lambda:data.append(p.read_bytes()));th.start()
  if dest.startswith('dev-'):p=Path('/dev')/dest[4:]
  r=subprocess.run([candidate,'--lanes','1','-nostdinc','-c',f,'-o',p],env=e,capture_output=True,timeout=15)
  if th:th.join(5)
  status_expected=dest!='dev-full'
  exact=r.returncode==0 if status_expected else r.returncode!=0
  if dest=='pipe': exact &= data==[expected]
  if dest in ('existing-file','hard-link'):exact &= p.read_bytes()==expected
  if dest=='hard-link':exact &= alias.read_bytes()==old
  answers.append((mode,dest,r.returncode,int(exact)))
with (d/'destinations.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t');w.writerow(('mode','destination','status','exact'));w.writerows(answers)

assert all(r[3] for r in answers)
with (d/'cases.tsv').open() as f:
 for r in csv.DictReader(f,delimiter='\t'):
  assert all(r[c]=='1' for c in ('same-status','same-stdout','same-stderr','same-file')), r
