from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import subprocess,os,csv,hashlib,resource
d=Path(__file__).resolve().parent; src=d.parent/'reader-chain-default';old=d.parent/'reader-chain-parent'/'build/compiler';new=src/'build/compiler'
fixtures=subprocess.check_output(['git','ls-files','tests/*.c'],cwd=src,text=True).splitlines()
modes=[[],['-Wall','-Wextra'],['-g','--poison-arenas'],['--node-window-assignments'],['--deferred-bodies','--lanes','2','-Wall'],['--scalar'],['--attested=verify','--poison-arenas']]
resource.setrlimit(resource.RLIMIT_CORE,(0,0));out=d/'corpus';out.mkdir(exist_ok=True)
def pair(item):
 n,source=item;rows=[]
 for i,flags in enumerate(modes):
  vals=[]
  for k,cc in enumerate([old,new]):
   of=out/(str(n)+'.o');of.unlink(missing_ok=True)
   r=subprocess.run([str(cc),*flags,'-c',source,'-o',str(of)],cwd=src,capture_output=True)
   sha=hashlib.sha256(of.read_bytes()).hexdigest() if of.exists() else ''
   vals.append((r.returncode,r.stdout,r.stderr,sha))
  same=vals[0]==vals[1];a=vals[0];b=vals[1]
  if not same:
   (out/f'{n}-{i}-old.err').write_bytes(a[2]);(out/f'{n}-{i}-new.err').write_bytes(b[2])
  rows.append((source,i,same,a[0],b[0],a[3],b[3],hashlib.sha256(a[2]).hexdigest(),hashlib.sha256(b[2]).hexdigest()))
 of.unlink(missing_ok=True);return rows
with ThreadPoolExecutor(max_workers=2) as pool,(d/'corpus.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['source','mode','same','parent_status','candidate_status','parent_object','candidate_object','parent_stderr','candidate_stderr'])
 for rows in pool.map(pair,enumerate(fixtures)):
  w.writerows(rows);f.flush()
