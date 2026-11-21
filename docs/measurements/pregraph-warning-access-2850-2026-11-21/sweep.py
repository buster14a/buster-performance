from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import json, os, sys, subprocess
from pathlib import Path
out=Path(sys.argv[1]).resolve()
source=Path(sys.argv[2]).resolve()
listfile=Path(sys.argv[3]).resolve()
name=sys.argv[4]
binary=out/'probe-compiler'
env=dict(os.environ,NODE_PROOF_POINTERS='1',NODE_PROOF_NO_FP='1',NODE_PROOF_CALLS='1')
policies={'default':[],'wall':['-Wall','-Wextra'],'everything':['-Weverything','-Wno-c++-compat']}
def run(job):
 policy,filename=job
 proc=subprocess.run([str(binary),'measure-node-machine','--shadow','--window-rows','--front-first','--passes','0',*policies[policy],filename],cwd=source,env=env,stdout=subprocess.DEVNULL,stderr=subprocess.PIPE)
 counts={}; evidence=[]
 for line in proc.stderr.decode(errors='replace').splitlines():
  if line.startswith('probe-access branch=') or line.startswith('probe-extra kind=') or line.startswith('probe-access kinds ') or line.startswith('probe-entry '):
   parts=line.split();tag=' '.join(parts[:2]) if not line.startswith('probe-entry ') else parts[0]
   counts[tag]=dict(v.split('=') for v in parts[2 if tag!=parts[0] else 1:])
  if line.startswith(('probe-access-difference','probe-extra-difference','probe-access oracle-failed')): evidence.append(line)
 return [policy,filename,proc.returncode,counts,evidence]
with (out/(name+'.jsonl')).open('w') as f,ThreadPoolExecutor(max_workers=2) as pool:
 for r in pool.map(run,[(p,file) for file in listfile.read_text().splitlines() for p in policies]):
  f.write(json.dumps(r,separators=(',',':'))+'\n')
