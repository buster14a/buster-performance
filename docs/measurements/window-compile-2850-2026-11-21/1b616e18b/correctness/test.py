from pathlib import Path
import subprocess,sys,os,hashlib,csv
root=Path(os.environ.get('BUSTER_EVIDENCE_OUT',Path(__file__).resolve().parent)).resolve();root.mkdir(exist_ok=True)
d=root/os.environ.get('PTR_CASES','cases');d.mkdir(exist_ok=True)
cc=Path(sys.argv[1]).resolve()
D='extern void f(int*); '
sources={
'param':D+'void g(int *p){f(p);}',
'local':D+'void g(int *p){int *q=p;f(q);}',
'multiple':D+'void g(int*p){f(p);f(p);f(p);}',
'static':'static void f(int*p){*p+=4;}void g(int *p){f(p);}',
'static-forward':'static void f(int*);void g(int*p){f(p);} static void f(int*p){*p*=2;}',
'address-taken':D+'void g(int*p){int **q=&p;f(p);*q=0;}',
'pointee-const':'void f(const int*);void g(const int*p){f(p);}',
'pointee-volatile':'void f(volatile int*);void g(volatile int*p){f(p);}',
'volatile-local':D+'void g(int* volatile p){f(p);}',
'const-local':D+'void g(int* const p){f(p);}',
'atomic':'void f(int*);void g(_Atomic(int*) p){f(p);}',
'uninit':D+'void g(void){int *p;f(p);}',
'cond-uninit':D+'void g(int b,int*q){int *p;if(b)p=q;f(p);}',
'used':D+'void g(int *p,int*q){p=q;f(p);}',
'global':D+'int *p;void g(void){f(p);}',
'static-local':D+'void g(int*s){static int *p;p=s;f(p);}',
'register':D+'void g(register int*p){f(p);}',
'void-convert':'void f(void*);void g(int*p){f(p);}',
'fn-ptr':'void f(void(*)(void));void g(void(*p)(void)){f(p);}',
'array':'void f(int*);void g(void){int p[2];f(p);}',
'nullness':'void f(int* _Nonnull);void g(int* _Nullable p){f(p);}',
'weak': 'extern void f(int*) __attribute__((weak));void g(int*p){f(p);}',
'deprecated':'extern void f(int*) __attribute__((deprecated));void g(int*p){f(p);}',
'availability':'extern void f(int*) __attribute__((unavailable));void g(int*p){f(p);}',
'checked':'void f(int*p) __attribute__((diagnose_if(p==0,"null","error")));void g(int*p){f(p);}',
'nonnullattr':'void f(int*) __attribute__((nonnull(1)));void g(int*p){f(p);}',
'target':'__attribute__((target("avx2"),always_inline)) static inline void f(int*p){*p=1;}void g(int*p){f(p);}',
'msabi':'typedef void F(int*) __attribute__((ms_abi));extern F f;void g(int*p){f(p);}',
'void-stmt':D+'void g(int*p){({f(p);});}',
'if-body':D+'void g(int*p,int x){if(x)f(p);}',
'if-block':D+'void g(int*p,int x){if(x){f(p);}}',
'loops':D+'void g(int*p,int x){for(;x--;){f(p);}}',
'switch':D+'void g(int*p,int x){switch(x){case 0:f(p);break;default:f(p);}}',
'indirect':'void g(void(*f)(int*),int*p){f(p);}',
'bad-count':'extern void f(int*,int*);void g(int*p){f(p);}',
'varargs':'void f(int*,...);void g(int*p){f(p);}',
'return-int':'int f(int*);void g(int*p){f(p);}',
'discard-casts':D+'void g(int*p){(void)f(p);}',
'list':D+'void g(int*p){f(p),f(p);}',
'labels':D+'void g(int*p){goto L;L:f(p);}',
'fn-decl-asm':'extern void f(int*) __asm__("custom"); void g(int*p){f(p);}',
'out-of-block-scope':'void g(int*p){{extern void f(int*);f(p);}}',
'alias':'void h(int*p){*p=1;}void f(int*) __attribute__((alias("h")));void g(int*p){f(p);}',
}
features={'default':[], 'wall':['-Wall','-Wextra'], 'all':['-Weverything'], 'optimized':['-O2'], 'dbg':['-g']}
with (root/os.environ.get('PTR_TABLE','fixtures.tsv')).open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('case flags before after admissions diag elf omit_ref omit_ref_elf'.split())
 for name,src in sources.items():
  path=d/(name+'.c');path.write_text(src+'\n')
  for feat,flags in features.items():
   out=[]
   for mode in ('off','on','omit'):
    obj=d/f'{name}-{feat}-{mode}.o';obj.unlink(missing_ok=True);env=os.environ.copy()
    if mode=='off':
     for perturb in ('BUSTER_PTR_OMIT_READ','BUSTER_PTR_NARROW'):env.pop(perturb,None)
    if mode!='off':env.update(BUSTER_DISCARD_PTR='1',BUSTER_CALL_LOG='1')
    if mode=='omit':env.update(BUSTER_CALL_OMIT_REFERENCE='1')
    window=[] if mode=='off' and os.environ.get('PTR_ORDINARY_BASE') else ['--node-window']
    r=subprocess.run([cc,*window,*flags,'-c',path,'-o',obj],env=env,capture_output=True,text=True)
    log=r.stderr.splitlines();diag=[l for l in log if not l.startswith('ptr-row:')]
    (d/f'{name}-{feat}-{mode}.diag').write_text('\n'.join(diag))
    out.append((r.returncode,diag,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-',len(log)-len(diag)))
   a,b,c=out;w.writerow((name,feat,a[0],b[0],b[3],int(a[1]==b[1]),int(a[2]==b[2]),c[0],int(a[2]==c[2])))
