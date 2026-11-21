from pathlib import Path
import subprocess,os,re,hashlib,csv,sys
root=Path(os.environ.get('BUSTER_EVIDENCE_OUT',Path(__file__).resolve().parent)).resolve();root.mkdir(exist_ok=True)
d=root/os.environ.get('CASE_OUT','cases');d.mkdir(exist_ok=True)
cc=Path(sys.argv[1]).resolve()
src={
'parameter': 'int f(int) __attribute__((visibility("hidden"))); int g(int i){return f(i);}',
'wrapper': 'int f(int); int main(void){return f(7);}',
'warning-attr':'int f(int) __attribute__((warning("callee warned"))); int g(void){return f(7);}',
'error-attr':'int f(int) __attribute__((error("callee denied"))); int g(void){return f(7);}',
'musttail':'int f(int); int g(int n){ __attribute__((musttail)) return f(7); }',
'bit-int':'extern int f(_BitInt(31)); int g(void){return f(7);}',
'hex':'extern int f(int); int g(void){return f(0x100);}',
'large':'extern int f(int); int g(void){return f(0x80000000u);}',
'plain-unsigned':'extern int f(int); int g(void){return f(1u);}',
'size-long':'extern int f(int); int g(void){return f(3l);}',
'old-typedef':'typedef int I; extern I f(I); int g(void){return f(7);}',
'local-shadow':'int f(int x){return x+1;} static int q(int x){return x+2;} int g(void){int(*f)(int)=q;return f(7);}',
 'late-diagnose':'int f(int); int g(void){return f(7);} int f(int x) __attribute__((diagnose_if(x==7,"denied","error")));',
'early-diagnose':'int f(int x) __attribute__((diagnose_if(x==7,"denied","error"))); int f(int); int g(void){return f(7);}',
'nested-decl':'int g(void){extern int f(int x) __attribute__((diagnose_if(x==7,"denied","error")));return f(7);}',
'late-noreturn':'int f(int);int g(void){return f(7);} _Noreturn int f(int i){for(;;){} }',
'sibling-attr':'int b(int) __attribute__((deprecated)); int f(int); int g(void){return f(7);}',
'diagnose-warning':'int f(int x) __attribute__((diagnose_if(x==7,"suspicious","warning"))); int g(void){return f(7);}',
'default-visibility':'int f(int) __attribute__((visibility("hidden"))); int g(void){return f(7);}',
'inline-linkage':'inline int f(int n){return n+1;} int g(void){return f(7);}',
'static-unused':'static int f(int x){return x+1;} int g(void){return f(7);}',
'static-undefined':'static int f(int x); int g(void){return f(7);}',
'block-extern':'int g(void){extern int f(int x); return f(7);}',
'conditional':'int f(int); int g(int x){if(x){return f(7);}else{return f(8);}}',
'gc-profile':'int f(int); int a(void){return f(7);}int b(int x){return a();}',
'huge-call':'int f(int); int g(int x){switch(x){'+''.join('case %d:return f(%d);'%(i,i) for i in range(48))+'default:return f(0);}}',
 'msabi-typedef': 'typedef int F(int) __attribute__((ms_abi));extern F f; int g(void){return f(7);}',
'abi-plain':'typedef int F(int);extern F f;int g(void){return f(7);}',
'const-param':'extern int f(const int);int g(void){return f(7);}',
'vectorcall':'__attribute__((vectorcall)) int f(int);int g(void){return f(7);}',
'ifunc-proto':'int target(int x){return x;} static void *resolver(void){return &target;} int f(int) __attribute__((ifunc("resolver")));int g(void){return f(7);}',
'zero': 'extern int callee(void); int run(void){return callee();}',
'one': 'extern int callee(int); int run(void){return callee(7);}',
'local': 'static int callee(int n){return n+1;} int run(void){return callee(7);}',
'inline':'static inline int callee(int n){return n+5;} int run(void){return callee(7);}',
'early':'static int f(int); int g(void){return f(5);} static int f(int n){return n*n;}',
'calls':'extern int a(int),b(int); int f(int x){if(x){return b(1);} return a(2);}',
'other-refs':'extern int f(int); int (*p)(int)=f; int g(void){return f(3);}',
'indirect':'int g(int (*f)(int)){return f(7);}',
'weak':'extern int f(int) __attribute__((weak)); int g(void){return f(7);}',
'asm':'extern int f(int) __asm("__custom_f"); int g(void){return f(7);}',
'alias':'int a(int x){return x+1;} extern int f(int) __attribute__((alias("a"))); int g(void){return f(7);}',
'weak-alias':'int a(int x){return x+1;} extern int f(int) __attribute__((weak,alias("a"))); int g(void){return f(7);}',
'deprecated':'int f(int) __attribute__((deprecated("avoid"))); int g(void){return f(7);}',
'unavailable':'int f(int) __attribute__((unavailable("blocked"))); int g(void){return f(7);}',
'returns-twice':'int f(int) __attribute__((returns_twice)); int g(void){return f(7);}',
'noreturn':'int f(int) __attribute__((noreturn)); int g(void){return f(7);}',
'warn-unused':'int f(int) __attribute__((warn_unused_result)); int g(void){return f(7);}',
'pure':'int f(int) __attribute__((pure)); int g(void){return f(7);}',
'const':'int f(int) __attribute__((const)); int g(void){return f(7);}',
'diagnose-if':'int f(int x) __attribute__((diagnose_if(x==7,"bad arg","error"))); int g(void){return f(7);}',
'bad-count':'extern int f(int,int); int g(void){return f(7);}',
'first-param-array':'extern int f(int*); int g(void){return f(7);}',
'oldstyle':'int f(); int g(void){return f(7);}',
'format':'int f(int x) __attribute__((enable_if(x>1,"too small"))); int g(void){return f(7);}',
'lib':'extern int abs(int); int g(void){return abs(7);}',
'builtin':'int g(void){return __builtin_popcount(7);}',
'line':'extern int f(int);\nint g(void){\nreturn\nf(\n7\n);\n}',
'redecl':'extern int f(int); int g(void){return f(7);} extern int f(int) __attribute__((returns_twice));',
'target':'__attribute__((target("avx2"),always_inline)) static inline int f(int x){return x+1;} int g(void){return f(7);}',
'target-default':'__attribute__((target("default"))) int f(int x){return x;} __attribute__((target("sse4.2"))) int f(int x){return x+1;} int g(void){return f(7);}',
'struct':'struct V {int x;}; static int f(struct V x){return x.x;} int g(void){return f((struct V){7});}',
'nested':'int f(int); int g(void){return f(f(7));}',
'sizeof':'int f(int); int g(void){return sizeof(f(7));}',
'macro':'int f(int);\n#define A(a) f(a)\nint g(void){return A(__LINE__);}',
'with-label':'int f(int); int g(int x){if(x)goto A; return f(3); A:return f(4);}',
'static-inline-unused':'static int f(int n){return n+1;} static int g(void){return f(7);} int h(void){return 0;}',
'ifunc':'int dispatched(int);int (*resolver(void))(int){return dispatched;} int f(int) __attribute__((ifunc("resolver"))); int g(void){return f(7);}',
}
def run(name,source,features,mode):
 path=d/(name+'.c');path.write_text(source+'\n')
 outfile=d/f'{name}-{features}-{mode}.o'
 outfile.unlink(missing_ok=True)
 env=os.environ.copy()
 if mode!='off':env['BUSTER_CALL_PROTO']='1';env['BUSTER_CALL_LOG']='1'
 if mode=='no-ref':env['BUSTER_CALL_OMIT_REFERENCE']='1'
 flags={'default':[], 'debug':['-g'], 'wall':['-Wall','-Wextra'], 'all':['-Weverything'], 'optimized':['-O2']}[features]
 selection=[] if mode=='off' and os.environ.get('BUSTER_ORDINARY_BASE') else ['--node-window']
 r=subprocess.run([cc,*selection,'-fno-color-diagnostics',*flags,'-c',path,'-o',outfile],capture_output=True,text=True,env=env)
 diag='\n'.join(line for line in r.stderr.splitlines() if not line.startswith('call-row:'))
 (d/f'{name}-{features}-{mode}.diagnostics').write_text(diag)
 return r.returncode,diag,hashlib.sha256(outfile.read_bytes()).hexdigest() if outfile.exists() else '-',sum(l.startswith('call-row:') for l in r.stderr.splitlines())
with (root/os.environ.get('CASE_TSV','proto.tsv')).open('w') as o:
 w=csv.writer(o,delimiter='\t',lineterminator='\n');w.writerow(('case','features','before','after','taken','diagnostics','elf','no-ref-status','no-ref-elf'))
 for name,source in src.items():
  for features in ('default','debug','wall','all','optimized'):
   a=run(name,source,features,'off');b=run(name,source,features,'on');c=run(name,source,features,'no-ref')
   w.writerow((name,features,a[0],b[0],b[3],int(a[1]==b[1]),int(a[2]==b[2]),c[0],int(a[2]==c[2])))
