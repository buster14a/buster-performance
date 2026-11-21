from pathlib import Path
import subprocess,sys,csv,re,tempfile,hashlib,os
d=Path(__file__).resolve().parent;out=d/'call-policies';out.mkdir(exist_ok=True)
ref=d/'abi-condition.compiler'
src0='extern int regular(int);\n'
decls=[
 ('plain','extern int selected(int);','selected(x)'),
 ('attributed','extern int selected(int) __attribute__((returns_twice));','selected(x)'),
 ('variadic','extern int selected(int,...);','selected(x,2)'),
 ('old style','extern int selected();','selected(x)'),
 ('indirect','extern int (*selected)(int);','selected(x)'),
 ('ms abi','extern int selected(int) __attribute__((ms_abi));','selected(x)'),
 ('sysv','extern int selected(int) __attribute__((sysv_abi));','selected(x)'),
 ('aligned','typedef int A __attribute__((aligned(16))); extern int selected(A);','selected(x)'),
 ('struct','struct z{int x;}; extern int selected(struct z);','selected((struct z){x})'),
 ('wide','extern int selected(__int128);','selected((__int128)x+1)'),
 ('float','extern double selected(double);','selected((double)x)!=0.0'),
 ('atomic','extern int selected(_Atomic(int));','selected(x)'),
 ('pure','extern int selected(int) __attribute__((pure));','selected(x)'),
 ('noreturn','extern void selected(int) __attribute__((noreturn));','(selected(x),0)'),
 ('overload','extern int selected(int) __attribute__((overloadable));extern int selected(long) __attribute__((overloadable));','selected(x)'),
 ('weak','extern int selected(int) __attribute__((weak));','selected(x)'),
 ('asm','extern int selected(int) __asm__("a_different_symbol");','selected(x)'),
 ('inlined','static inline int selected(int z){return z*2;}','selected(x)'),
 ('alias','int target(int z){return z-2;} extern int selected(int) __attribute__((alias("target")));','selected(x)'),
 ('conditional','extern int a(int),b(int);','(x>1?a:b)(x)'),
 ('builtin','extern int abs(int);','abs(x)'),
 ('builtin name','','__builtin_popcount((unsigned)x)')]
base=re.search(r'^switches=\((.*?)\)$',(d/'compact-conditions.sh').read_text(),re.M)[1]
opt={k:v for k,v in [i.split('=',1) for i in base.split()]};opt['NODE_SOURCE_CONSUME_FIXED_CALL']='1'
skip=re.compile(rb'^(?:cross-(?:canonical|chunk|cost|keys|view) |node-proof |source-(?:conditions|rows) |splice-(?:taken|local-class): |(?:condition|branch|label|call)-taken )')
def h(b):return hashlib.sha256(b).hexdigest()
with (out/'grid.tsv').open('w',buffering=1) as o,tempfile.TemporaryDirectory(dir=out) as t:
 w=csv.writer(o,delimiter='\t',lineterminator='\n');w.writerow(['family','std','policy','same','status','condition_takes','calls','args','native_with_abi','ELF','diagnostics']);t=Path(t)
 for i,(tag,dec,x) in enumerate(decls):
  c=out/f'probe-{i}.c';c.write_text(src0+dec+'\n'+f'int exercise(int x) {{ int v=0; if ({x}) v+=4; if (regular(x) && ({x})) v+=2; if (({x}) || regular(x)) v++; return v; }}\n')
  for std in ['gnu17','gnu23']:
   for p,fl in [('ordinary',[]),('debug',['-g']),('warnings',['-Wall','-Wextra']),('all',['-Weverything'])]:
    outcomes=[];logs=[]
    for on in False,True:
     elf=t/'file.o';native=t/'native';elf.unlink(missing_ok=True);native.unlink(missing_ok=True)
     env=dict(os.environ,NODE_SOURCE_NATIVE_ORACLE=str(native))
     if on:env.update(opt)
     r=subprocess.run([str(ref),'--lanes','1','-nostdinc','-std='+std,'-c',*fl,str(c),'-o',str(elf)],capture_output=True,env=env,timeout=15)
     norm=b''.join(l for l in r.stderr.splitlines(True) if not skip.match(l));logs.append(norm)
     outcomes.append((r.returncode,h(native.read_bytes()) if native.exists() else '-',h(elf.read_bytes()) if elf.exists() else '-',h(norm),h(r.stdout)))
    a,b=outcomes
    calls=sum(map(int,re.findall(rb'^call-taken .*?calls=(\d+)',r.stderr,re.M)))
    args=sum(map(int,re.findall(rb'^call-taken .*?arguments=(\d+)',r.stderr,re.M)))
    w.writerow([tag,std,p,int(a==b),b[0],r.stderr.count(b'condition-taken '),calls,args,*b[1:4]])
    if a!=b:(out/f'{i}-{std}-{p}.diff').write_bytes(repr(outcomes).encode()+b'\n'+logs[0]+b'---\n'+logs[1])
