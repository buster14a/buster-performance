from common import *
import ast,csv,gzip,hashlib,json,re,shutil,subprocess
out=D/'oracle';out.mkdir(exist_ok=True);cases=out/'cases';cases.mkdir(exist_ok=True);streams=out/'streams';streams.mkdir(exist_ok=True);tree=CC.parent.parent;clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def store(b):
 h=hashlib.sha256(b).hexdigest();p=streams/(h+'.gz')
 if not p.exists():p.write_bytes(gzip.compress(b,mtime=0))
 return h
def run(cc,flags,opts,e,src):
 obj=out/'unit.o';obj.unlink(missing_ok=True);r=subprocess.run([cc,'--lanes','1','-c',*opts,*flags,'-o',obj],env=env|e,cwd=ROOT,capture_output=True,timeout=270);h=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-'
 return (r.returncode,h,store(r.stdout),store(r.stderr)),r.stderr
fixture=tree/'src/buster/compiler/c_check_type_sugar_driver_test.c';src=fixture.read_text()
for section in ('check_driver_counted_incomplete_fixtures','check_driver_counted_incomplete_initializer_fixtures'):
 match=re.search(r'static const [^;]*?\b'+section+r'\[\] =\s*\{(.*?)\n\};',src,re.S)
 if not match:continue
 for name,lits in re.findall(r'\.name = "([^"]+)",\s*\.source = ((?:"(?:[^"\\]|\\.)*"\s*)+),',match[1]):
  v=''.join(ast.literal_eval(x) for x in re.findall(r'"(?:[^"\\]|\\.)*"',lits));(cases/(re.sub(r'[^A-Za-z0-9]+','-',name).strip('-')+'.c')).write_text(v)
assert list(cases.glob('*.c'))
shutil.copy(tree/'tests/driver/counted_by_diagnostics.c',cases/'driver.c')
(cases/'legal.c').write_text('struct Node; struct A{unsigned len;struct Node *p __attribute__((counted_by(len)));}; struct Node{int x;};int f(struct A*a){return a->p->x;}\n')
(cases/'ordinary.c').write_text('struct Node;struct A{unsigned len;struct Node *p;};struct Node*f(struct A*a){return a->p;}\n')
(cases/'sized.c').write_text('struct Node;struct A{unsigned len;struct Node*p __attribute__((sized_by(len)));};struct Node*f(struct A*a){return a->p;}\n')
(cases/'absent.c').write_text('struct Node;struct A{int n;int a[] __attribute__((counted_by(n)));};struct Node*f(struct Node*n){return n;}\n')
(cases/'optional.c').write_text('struct Node;struct A{unsigned len;struct Node*p __attribute__((counted_by_or_null(len)));};struct Node*f(struct A*a){return a->p;}\n')
(cases/'nested.c').write_text('struct Node;struct A{unsigned len;struct Node*p __attribute__((counted_by(len)));};struct Outer{struct A a;};int f(struct Outer*x){return x->a.p!=0;}\n')
(cases/'aligned-typedef.c').write_text('struct I;typedef struct I *P __attribute__((aligned(8)));struct C{unsigned n;P p __attribute__((counted_by(n)));};struct I*f(struct C*x){return x->p;}\n')
(cases/'address-only.c').write_text('struct I;struct C{unsigned n;struct I*p __attribute__((counted_by(n)));};struct I**f(struct C*x){return &x->p;}\n')
(cases/'absent-after-recovery.c').write_text('struct S{int n;struct U*p __attribute__((counted_by(n))); int bad[-1];}; struct U; struct T{struct U *p;};struct U*f(struct T*x){return x->p;}\n')
probes={p.stem:['-std=c23','-nostdinc',p] for p in cases.glob('*.c') if p.stem!='driver'}
probes.update({f'driver-{i}':['-std=c23','-nostdinc',f'-DCOUNTED_CASE={i}',cases/'driver.c'] for i in range(10)})
fail=[];previous=[];history=[]
with (out/'comparisons.tsv').open('w',buffering=1) as f, (out/'fingerprints.tsv').open('w',buffering=1) as g,(out/'clang.tsv').open('w',buffering=1) as c:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('input','policy','mode','exit','ELF','stdout','stderr','same-prior-mode','same-current-ordinary'))
 ft=csv.writer(g,delimiter='\t',lineterminator='\n');ft.writerow(('input','scope','mode','exit','rows','nodes','equal-prior','equal-ordinary','stderr'))
 ct=csv.writer(c,delimiter='\t',lineterminator='\n');ct.writerow(['case','mode','status','errors','warnings','notes','stderr'])
 for name,flags in [*args.items(),*probes.items()]:
  real=name in args
  if not real:
   cr=subprocess.run([clang,*flags,'-fsyntax-only'],capture_output=True);ct.writerow([name,'clang',cr.returncode,cr.stderr.count(b'error:'),cr.stderr.count(b'warning:'),cr.stderr.count(b'note:'),store(cr.stderr)])
  for pol,opts in [('default',[]),('warnings',['-Wall','-Wextra']),('fatal',['-Wall','-Wextra','-Werror'])]+([] if real else [('dumps',['--dump-typed','--dump-static'])]):
   rows={}
   for mode,b,e in [('prior-ordinary',PRIOR,{}),('ordinary',CC,{}),]:
    val,err=run(b,flags,opts,e,name);rows[mode]=val
    if not real and pol=='default' and mode in ['ordinary','source']:ct.writerow([name,mode,val[0],err.count(b'error:'),err.count(b'warning:'),err.count(b'note:'),val[-1]])
   for m,v in rows.items():
    old=rows['prior-source' if 'source' in m else 'prior-ordinary'];t.writerow([name,pol,m,*v,int(v==old),int(v==rows['ordinary'])])
    if v!=old:fail.append([name,pol,m,'prior'])
   if pol=='default' and real:
    for k,v in [('ordinary',W/'source-typed-study'/(name+'.o')),]:
     h=hashlib.sha256(v.read_bytes()).hexdigest();ok=h==rows[k][1];history.append([name,k,h,rows[k][1],ok])
     if not ok:fail.append([name,k,'frozen'])
  print(name,'differences',len(fail),flush=True)
for k,data in [('failures',fail),('historical',history),('previous',previous)]: (out/(k+'.json')).write_text(json.dumps(data,indent=2))

subprocess.run(['python3',D/'locations.py'],check=True)
