from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import os,sys,subprocess,hashlib
base=Path.cwd(); cc=base/'build/compiler'; d=Path(sys.argv[1]);d.mkdir(exist_ok=True)
sources=[str(base/s) for s in subprocess.check_output(['git','ls-files','tests/*.c'],text=True).splitlines()]
def check(pair):
 i,src=pair
 modes=[[],['-Wall','-Wextra'],['--node-window','--poison-arenas'],['--deferred-bodies','--lanes','2','-Wall'],['--scalar']]
 bad=[]; accepted=0; ordinary_signal=0
 for k,flags in enumerate(modes):
  out=d/f'{i}.o'; res=[]
  for env in ({},{'BUSTER_CHAIN_PACKED':'1','BUSTER_CHAIN_POISON':'1'}):
   if out.exists():out.unlink()
   p=subprocess.run([str(cc),*flags,'-c',src,'-o',str(out)],capture_output=True,env=dict(os.environ,**env))
   res.append((p.returncode,p.stdout,p.stderr,hashlib.sha256(out.read_bytes()).hexdigest() if out.exists() else None))
  accepted+=res[0][0]==0
  ordinary_signal+=res[0][0]<0
  if res[0]!=res[1]:
   bad.append((src,k,(res[0][0],res[0][1],res[0][2],res[0][3]),(res[1][0],res[1][1],res[1][2],res[1][3])))
 if out.exists():out.unlink()
 return (len(modes),accepted,ordinary_signal,bad)
counts=[0,0,0];bad=[]
with ThreadPoolExecutor(max_workers=2) as pool:
 for n,ok,sig,mis in pool.map(check,enumerate(sources)):
  counts=[a+b for a,b in zip(counts,(n,ok,sig))];bad+=mis
print(len(sources),'inputs;',*counts,'pairs/accepted/signals;',len(bad),'mismatches')
for row in bad[:20]:print(repr(row)[:1000])
sys.exit(bool(bad))
