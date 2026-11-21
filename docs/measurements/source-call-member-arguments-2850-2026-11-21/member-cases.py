"""Complete object, diagnostic, native-row, declaration-reference, and physical admission comparisons."""
import argparse,collections,csv,hashlib,os,re,subprocess,tempfile
from pathlib import Path

argp=argparse.ArgumentParser()
argp.add_argument('compiler',type=Path);argp.add_argument('out',type=Path)
a=argp.parse_args(); d=a.out.resolve();d.mkdir(parents=True,exist_ok=True);cc=a.compiler.resolve()
prefix='typedef int word; struct S { int at0; char pad[7]; word at12; int *pointer; volatile int device; unsigned bits:3; _Atomic int atom; };\nextern int f(int); extern int combine(int,int,int); extern void drop(int); extern int takep(int*);\n'
cases={
  'offset-zero':'int test(struct S *p){return f(p->at0);}',
  'offset-twelve':'int test(struct S *p){return f(p->at12);}',
  'pointer-field':'int test(struct S *p){return takep(p->pointer);}',
  'discard':'void test(struct S *p){drop(p->at12);}',
  'two-fields':'int test(struct S *a,struct S *b){return combine(a->at12,2,b->at0);}',
  'repeated-base':'int test(struct S *a){return combine(a->at12,a->at0,a->at12);}',
  'chain':'struct L {struct S *s;}; int test(struct L *p){return f(p->s->at12);}',
  'const':'int test(const struct S *p){return f(p->at12);}',
  'volatile-base':'int test(volatile struct S *p){return f(p->at12);}',
  'volatile-pointer':'int test(struct S *volatile p){return f(p->at12);}',
  'volatile-field':'int test(struct S *p){return f(p->device);}',
  'atomic-field':'int test(struct S *p){return f(p->atom);}',
  'bitfield':'int test(struct S *p){return f(p->bits);}',
  'incomplete':'struct L; int test(struct L *p){return f(p->j);} struct L{int j;};',
  'unknown-member':'int test(struct S *p){return f(p->absent);}',
  'deprecated':'struct L{int j __attribute__((deprecated));}; int test(struct L *p){return f(p->j);}',
  'unavailable':'struct L{int j __attribute__((unavailable));}; int test(struct L *p){return f(p->j);}',
  'macro':'#define FIELD(P) P->at12\nint test(struct S *p){return f(FIELD(p));}',
  'shadow':'int test(struct S *p){ { struct S *q = p; return f(q->at12);} }',
  'uninitialized':'int test(void){struct S *p; return f(p->at12);}',
  'maybe-uninitialized':'int test(struct S *a,int y){struct S *p; if(y){p=a;} return f(p->at12);}',
  'packed':'struct __attribute__((packed)) P {char a; int b;}; int test(struct P *p){return f(p->b);}',
  'union':'union U{int a;}; int test(union U *p){return f(p->a);}',
  'anon':'struct L{struct { int j; };}; int test(struct L *p){return f(p->j);}',
  'register':'int test(register struct S *p){return f(p->at12);}',
  'static':'int test(void){static struct S *p; return f(p->at12);}',
  'global':'extern struct S *p; int test(void){return f(p->at12);}',
  'tls':'_Thread_local struct S *p; int test(void){return f(p->at12);}',
  'funcptr':'struct C{int (*fn)(int);}; extern int cal(int(*p)(int)); int test(struct C *p){return cal(p->fn);}',
  'narrow-formal':'extern int cal(short); int test(struct S *p){return cal(p->at12);}',
  'qualified-field':'struct Q {const int x;}; int test(struct Q *p){return f(p->x);}',
  'address-space':'struct Q {int x;}; int test(struct Q __attribute__((address_space(256)))*p){return f(p->x);}',
  'post-increment':'int test(struct S *p){return f((p++)->at12);}',
  'mixed-effects':'int test(struct S *p,int i){return combine(p->at0,i++,p->at12);}',
  'nested-call':'int test(struct S *p){return combine(f(p->at0),p->at0,p->at12);}',
  'unseq':'int test(struct S *p,int i){return combine(i++,p->at0,i++);}',
  'parameter-list':'int test(struct S *p){return combine(0,p->at12,1);}',
  'multi-line':'int test(struct S *p){\n return f(\n p\n ->\n at12\n );\n}',
  'pragma':'#pragma clang diagnostic push\n#pragma clang diagnostic error "-Wuninitialized"\nint test(void){struct S *p; return f(p->at12);}\n#pragma clang diagnostic pop',
  'illegal-member-offset':'struct P{int :0; int arr[];}; int test(struct P*p){return takep(p->arr);}',
  'no-deref':'int test(struct S * __attribute__((noderef)) p){return f(p->at12);}',
  'binding-const':'struct S *get(void); int test(void){struct S *const p=get(); return f(p->at12);}',
}
for k in range(1,9):
 for pos in range(k):
  vals=['1']*k;vals[pos]='p->at12'
  cases[f'arity-{k}-{pos}']=f'extern int cal({",".join(["int"]*k)}); int test(struct S*p){{return cal({",".join(vals)});}}'
pols={'default':[],'wall':['-Wall','-Wextra'],'all':['-Weverything'],'error':['-Werror=uninitialized','-Werror=unsequenced','-Werror=deprecated-declarations'],'debug':['-g'],'tier1':['--tier1'],'twolanes':['--lanes','2'],'poison':['--poison-arenas']}
def sha(v):return hashlib.sha256(v).hexdigest()
def digest(p):return sha(p.read_bytes()) if p.exists() else ''
with tempfile.TemporaryDirectory(dir=d) as tmp, (d/'results.tsv').open('w',buffering=1) as fout:
 scratch=Path(tmp); w=csv.writer(fout,delimiter='\t',lineterminator='\n');w.writerow('source policy normal_status extended_status ordinary_hits extended_hits member_sites total_members same_stderr same_stdout same_elf same_native same_refs normal_sha extended_sha'.split())
 for key,body in cases.items():
  s=d/(key+'.c');s.write_text(prefix+body+'\n')
  for policy,opts in pols.items():
   records=[]
   for use in [False,True]:
    p=scratch/'output.o';n=scratch/'native';r=scratch/'refs'
    for x in (p,n,r):x.unlink(missing_ok=True)
    env=dict(os.environ,BUSTER_WINDOW_CALL_LOG='1',NODE_SOURCE_NATIVE_ORACLE=str(n),BUSTER_CALL_REFERENCES=str(r))
    if use: env['BUSTER_CALL_ARROW']='1'
    cmd=[cc,'--node-window-calls','--lanes','1',*opts,'-c',s,'-o',p]
    cp=subprocess.run(cmd,env=env,capture_output=True)
    lines=cp.stderr.splitlines(keepends=True);diag=b''.join(l for l in lines if not l.startswith((b'plain-call:',b'arrow-call:')))
    counts=re.findall(rb'^arrow-call: token=\d+ members=(\d+)',cp.stderr,re.M)
    records.append([cp.returncode,sha(diag),sha(cp.stdout),digest(p),digest(n),digest(r),cp.stderr.count(b'plain-call:'),len(counts),sum(map(int,counts)),diag])
   old,new=records; w.writerow([key,policy,old[0],new[0],old[6],new[6],new[7],new[8],*[int(x==y) for x,y in zip(old[1:6],new[1:6])],old[3],new[3]])
   if old[:6]!=new[:6]:
    (d/(key+'-'+policy+'-base.err')).write_bytes(old[-1]);(d/(key+'-'+policy+'-new.err')).write_bytes(new[-1])
