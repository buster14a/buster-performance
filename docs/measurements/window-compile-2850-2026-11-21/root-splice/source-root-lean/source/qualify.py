from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import os,subprocess,csv,hashlib,sys,re,resource
d=Path(__file__).resolve().parent;cc=Path(sys.argv[1]).resolve();p=d/(sys.argv[2]+'-tracked');p.mkdir(exist_ok=True)
repo=d.parent/'source-lean-driver'; parent=d.parent/'source-graph-study'/'7ef990068-compiler'; files=subprocess.check_output(['git','ls-files','tests/*.c'],cwd=repo,text=True).splitlines()
flags=[[],['-Wall','-Wextra'],['-g','--poison-arenas'],['--scalar'],['--deferred-bodies','--lanes','2'],['-Weverything'],['--attested=verify','--verify']]
sha=lambda b:hashlib.sha256(b).hexdigest()
resource.setrlimit(resource.RLIMIT_CORE,(0,0))
def check(job):
 idx,src=job;results=[];target=p/(str(idx)+'.o')
 for j,policy in enumerate(flags):
  seen=[];takes=0
  for k,(exe,extra) in enumerate([(parent,[]),(cc,[]),(cc,['--node-window-source'])]):
   target.unlink(missing_ok=True)
   r=subprocess.run([str(exe),*policy,*extra,'-c',src,'-o',str(target)],cwd=repo,capture_output=True,env={**os.environ,'NODE_SOURCE_COMPACT_REPORT':'1','NODE_SPLICE_REPORT':'1'})
   msg=[];traces=[]
   for l in r.stderr.splitlines(keepends=True):
    if l.startswith((b'compact-taken:',b'compact-consumed:',b'splice-taken:',b'splice-local-class:')):traces.append(l)
    else:msg.append(l)
   payload=b''.join(msg)
   seen.append((r.returncode,sha(payload),sha(r.stdout),sha(target.read_bytes()) if target.exists() else ''))
   if k==2:takes=sum(l.startswith(b'compact-taken:') for l in traces)
   if k==2 and seen[0]!=seen[2]:
    (p/f'{idx}-{j}-source.err').write_bytes(payload)
  results.append((src,j,*seen[0],*seen[1],*seen[2],len(set(seen))==1,takes))
 target.unlink(missing_ok=True)
 return results
with ThreadPoolExecutor(max_workers=2) as pool, (p/'tracked.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['file','policy',*[version+'_'+col for version in ['parent','same','source'] for col in ['exit','diagnostic','stdout','object']],'same','admissions'])
 for rows in pool.map(check,enumerate(files)):w.writerows(rows);f.flush()
