from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import os,subprocess,csv,hashlib,sys,resource,re
d=Path(__file__).resolve().parent;rev=sys.argv[1];cc=d/(rev+'-compiler');p=d/rev/'tracked';p.mkdir(exist_ok=True);repo=d.parent/'window-pure-interior'
files=subprocess.check_output(['git','ls-files','tests/*.c'],cwd=repo,text=True).splitlines()
flags=[[],['-Wall','-Wextra'],['-g','--poison-arenas'],['--scalar'],['--deferred-bodies','--lanes','2'],['-Weverything'],['--attested=verify','--verify']]
sha=lambda b:hashlib.sha256(b).hexdigest()
resource.setrlimit(resource.RLIMIT_CORE,(0,0))
def check(job):
 idx,src=job;results=[];t=p/(str(idx)+'.o')
 for j,policy in enumerate(flags):
  seen=[];takes=0;removed=0
  for mode in ('plain','source'):
   env=os.environ.copy()
   if mode=='source':env.update(NODE_PURE_INTERIOR='1',NODE_PURE_INTERIOR_REPORT='1')
   t.unlink(missing_ok=True)
   r=subprocess.run([cc,*policy,'-c',src,'-o',t],cwd=repo,capture_output=True,env=env)
   info=r.stderr.splitlines(keepends=True);diag=b''.join(l for l in info if not l.startswith(b'interior-taken:'))
   seen.append((r.returncode,sha(diag),sha(r.stdout),sha(t.read_bytes()) if t.exists() else ''))
   if mode=='source':
    taken=[q for l in info if (q:=re.match(rb'interior-taken: token=\d+ node=\d+ removed=(\d+)',l))]
    takes=len(taken);removed=sum(int(m[1]) for m in taken)
   if len(seen)==1 or seen[0]!=seen[1]:(p/f'{idx}-{j}-{mode}.err').write_bytes(diag)
  if seen[0]==seen[1]:(p/f'{idx}-{j}-plain.err').unlink(missing_ok=True)
  results.append([src,j,*seen[0],*seen[1],seen[0]==seen[1],takes,removed])
 t.unlink(missing_ok=True);return results
with ThreadPoolExecutor(max_workers=2) as pool,(p/'tracked.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['file','policy',*[m+'_'+k for m in ['ordinary','source'] for k in ['status','diagnostic','stdout','elf']],'same','roots','removed'])
 for rows in pool.map(check,enumerate(files)):w.writerows(rows);f.flush()
