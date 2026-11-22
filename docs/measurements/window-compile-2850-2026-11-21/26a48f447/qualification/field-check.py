from pathlib import Path
import csv,hashlib,itertools,subprocess
d=Path(__file__).resolve().parent
b=d.parent
source=d/'fields.c'; output=d/'fields.o'
clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
baseline=b/'main-fbef-clean/build/compiler'; candidate=b/'body-local-emission/build/compiler'
def run(cmd):
 return subprocess.run(cmd,capture_output=True,timeout=30)
def h(x):return hashlib.sha256(x).hexdigest()
subprocess.run([clang,'-no-pie',source,d/'provider.c','-o',d/'clang-exe'],check=True)
oracle=run([d/'clang-exe'])
options={'default':[],'pic':['-fPIC'],'debug':['-g'],'patch':['-fpatchable-function-entry=12,4'],'debugpic':['-g','-fPIC'],'tier1':['--tier1'],'noinline':['-fno-inline'],'unwind':['-fasynchronous-unwind-tables'],'unwindpatch':['-funwind-tables','-fpatchable-function-entry=12,4'],'unused':['-Wall','-Wextra']}
with (d/'field-check.tsv').open('w',buffering=1) as f:
 w=csv.writer(f,delimiter='\t');w.writerow(['window','mode','lanes','matches','status','object','runtime','stderr'])
 for win,mode,lanes in itertools.product([0,1,64,2048,100000],options,[1,2]):
  pair=[]
  for cc in [baseline,candidate]:
   output.unlink(missing_ok=True)
   p=run([cc,'-c',f'--emit-window={win}','--lanes',str(lanes),'-std=gnu17',*options[mode],source,'-o',output])
   pair.append((p.returncode,p.stdout,p.stderr,output.read_bytes() if output.exists() else b''))
  exact=pair[0]==pair[1]
  assert exact,(win,mode,lanes,pair[0][:3],pair[1][:3])
  runtime='unsupported'
  rc,so,se,obj=pair[1]
  if rc == 0:
   r=run([clang,'-no-pie',output,d/'provider.c','-o',d/'test-exe'])
   assert r.returncode==0,r.stderr
   r=run([d/'test-exe'])
   assert (r.returncode,r.stdout,r.stderr)==(oracle.returncode,oracle.stdout,oracle.stderr),(win,mode,r.stdout,oracle.stdout)
   runtime=r.stdout.decode().strip()
  w.writerow([win,mode,lanes,exact,rc,h(obj),runtime,se.decode().splitlines()[0] if se else '-'])
