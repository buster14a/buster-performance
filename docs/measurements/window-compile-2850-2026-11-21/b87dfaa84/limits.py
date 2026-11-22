from pathlib import Path
import csv,os,subprocess,hashlib
p=Path(__file__).resolve().parent;d=p/'limits';d.mkdir(exist_ok=True)
inputs={}
for depth in (1,2,3,8,15,16,17,32):
 defs=['struct C0{char padding;int leaf;};']+[f'struct C{i}{{char padding;struct C{i-1} *p;}};' for i in range(1,depth)]
 expr='r'+'->p'*(depth-1)+'->leaf'
 inputs[f'depth-{depth}']=''.join(defs)+f'int f(struct C{depth-1}*r){{return {expr};}}'
inputs['large-offset']='struct C{char pad[0x100000000ULL]; int v;}; struct P{struct C*c;}; int f(struct P*p){return p->c->v;}'
inputs['large-negative']='struct C{char pad[-1]; int v;}; struct P{struct C*c;}; int f(struct P*p){return p->c->v;}'
inputs['zero-offset']='struct I{int v;}; struct A{struct I *i;}; struct B{struct A *a;}; int f(struct B*b){return b->a->i->v;}'
inputs['nested-vs-separate']='struct I{int v;}; struct A{struct I *i;}; struct B{struct A *a;}; int f(struct B*b,int g){return g+b->a->i->v+sizeof b->a->i->v;}'
inputs['builtin-extent']='struct I{int v;}; struct A{struct I *i;}; struct B{struct A *a;}; unsigned f(struct B*b){return __builtin_object_size(&b->a->i->v,1);}'
inputs['macro-duplicate']='typedef unsigned long Len;struct R{Len n;};struct Q{struct R *r;};\n#define CMP(v,x) ((v)<(x)?(v):(x))\nunsigned long f(struct Q*q,long d){return CMP(q->r->n,d);}'
with (p/'limits.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t');out.writerow(['test','policy','ordinary_status','primary_status','compact_status','clang_status','primary_equal','compact_equal','active_primary','active_compact'])
 for label,code in inputs.items():
  src=d/(label+'.c');src.write_text(code+'\n')
  for flags in ([],['-Wall','-Wextra'],['-Wall','-Wextra','-Werror']):
   rr=[];hits=[]
   for cc,options in [(p.parent/'main-fbef-clean/build/compiler',{}),(p/'compiler-7844b9bd3',{'BUSTER_CONTROL_MEMBER_OPERANDS':'1','BUSTER_CHAIN_POISON':'1'}),(p.parent/'member-chain-compact-study/compiler',{'BUSTER_CONTROL_MEMBER_OPERANDS':'1','BUSTER_CHAIN_POISON':'1'}),('clang',{})]:
    dest=d/'case.o';dest.unlink(missing_ok=True);r=subprocess.run([cc,*flags,'-c',src,'-o',dest],env=os.environ|options,capture_output=True)
    rr.append((r.returncode,hashlib.file_digest(dest.open('rb'),'sha256').hexdigest() if dest.exists() else None,r.stdout,r.stderr))
    if options:
     t=subprocess.run([cc,*flags,'-c',src,'-o',dest],env=os.environ|options|{'BUSTER_CHAIN_AUDIT':'1'},capture_output=True);hits.append(sum(l.startswith(b'source-chain\t') for l in t.stderr.splitlines()))
   out.writerow([label,' '.join(flags),*(r[0] for r in rr),int(rr[0]==rr[1]),int(rr[0]==rr[2]),*hits])
