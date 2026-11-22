from pathlib import Path
import csv,hashlib,os,subprocess
p=Path(__file__).resolve().parent;t=p/'edge';t.mkdir(exist_ok=True)
orig=(p.parent/'source-member-location-reads-study/field-tests.py').read_text()
ns={'__file__':str(p.parent/'source-member-location-reads-study/field-tests.py')};exec(orig[:orig.index('modes=')],ns)
cases=ns['cases'];cases['chain-external']=(p/'probe.c').read_text()
base=p/'compiler';prod=p.parent/'main-fbef-clean/build/compiler'
pfx='struct V{int h;int x;};struct R{int n;struct V *p;struct V v;};'
cases.update({
'chain-unseq-read':pfx+'int f(struct R*r){return r->p->x + (r++->v.x);}',
'chain-unseq-address':pfx+'int g(int*,int*);int f(struct R*r){return g(&r->p->x,&(r++)->p->x);}',
'chain-uninit':pfx+'int f(void){struct R*r;return r->p->x;}',
'chain-store-self':pfx+'void f(struct R*r){r->v.x=r->v.x;}',
'chain-packed-address':'struct __attribute__((packed)) P{char z;int x;};struct Q{struct P p;};int *f(struct Q*q){return &q->p.x;}',
'chain-builtin-extent':pfx+'int f(struct R*r){return __builtin_object_size(&r->v.x,1);}',
'chain-unsequenced-base':pfx+'void f(struct R*r){r->p->x = (r++)->v.x;}',
'chain-pointer-sugar':'typedef int Num;struct M{Num x;};struct N{struct M m;};int f(struct N*n){return n->m.x|1.0;}',
'chain-flex':'struct L{int n;int v[];};struct R{struct L*l;};int f(struct R*r,int k){return r->l->v[k];}',
'chain-anon':'struct R{union{struct{int x;};long l;};};int f(struct R*r){return r->x;}',
'chain-qualified':'struct M{volatile int x;};struct N{const struct M *m;};int f(struct N*n){return n->m->x;}',
'chain-bit':'struct M{unsigned x:4;};struct N{struct M*m;};int f(struct N*n){return n->m->x;}',
'chain-incomplete':'struct M;struct N{struct M*m;};int f(struct N*n){return n->m->x;}struct M{int x;};',
'chain-subscript-err':pfx+'int f(struct R*r){return r->v.x[2];}',
'chain-address-call':pfx+'int g(int*);int f(struct R*r){return g(&r->v.x);}',
'chain-local-shadow':pfx+'int f(struct R*r){struct V{int a[13];int x;};struct R{struct V v;};struct R s={{ {0},3 }};return r->v.x+s.v.x;}',
'chain-nested-atomic':'struct X{int x;};struct T{_Atomic(struct X)*p;};int f(struct T*t){return t->p->x;}',
})
sha=lambda x:hashlib.sha256(x).hexdigest()
with (p/'edge.tsv').open('w',buffering=1) as log:
 w=csv.writer(log,delimiter='\t');w.writerow(['case','policy','base-exit','chain-exit','Clang-exit','object','stdout','stderr','hits','hops'])
 for n,s in cases.items():
  f=t/(n+'.c');f.write_text(s);results=[]
  for mode,flags in [('default',[]),('wall',['-Wall','-Wextra']),('strict',['-Wall','-Wextra','-Werror']),('quiet',['-w']),('everything',['-Weverything'])]:
   rs=[]
   for arm,cc,ex in [('base',prod,{}),('chain',base,{'BUSTER_CONTROL_MEMBER_OPERANDS':'1'}),('clang','clang',{})]:
    obj=t/'out.o';obj.unlink(missing_ok=True);r=subprocess.run([cc,'-std=gnu17',*flags,'-c',f,'-o',obj],env=os.environ|ex,capture_output=True);rs.append((r.returncode,sha(obj.read_bytes()) if obj.exists() else '',r.stdout,r.stderr))
    if arm!='clang':(t/(n+'.'+mode+'.'+arm+'.stderr')).write_bytes(r.stderr)
   audit=subprocess.run([base,'-std=gnu17',*flags,'-c',f,'-o',t/'audited.o'],env=os.environ|{'BUSTER_CONTROL_MEMBER_OPERANDS':'1','BUSTER_CHAIN_AUDIT':'1'},capture_output=True)
   rows=[line.split() for line in audit.stderr.splitlines() if line.startswith(b'source-chain\t')];a,b,c=rs;w.writerow((n,mode,a[0],b[0],c[0],*(int(a[i]==b[i]) for i in range(1,4)),len(rows),sum(int(v[3]) for v in rows)))
