# One mutant at a time in TREE: apply, Develop build, run its runners until one fails (killed), revert.
import sys,subprocess,os,time
sys.path.insert(0,os.path.dirname(__file__))
from mutants import MUTANTS
tree=sys.argv[1]; out=sys.argv[2]; only=sys.argv[3:] 
env=dict(os.environ)
res=open(out,'a')
for name,f,old,new,runners in MUTANTS:
    if only and name not in only: continue
    p=os.path.join(tree,f); s=open(p).read()
    assert s.count(old)==1,(name,s.count(old))
    open(p,'w').write(s.replace(old,new))
    try:
        b=subprocess.run(['./build.sh'],cwd=tree,capture_output=True,text=True)
        if b.returncode!=0:
            res.write(f'{name}\tBUILD-FAILED\n'); res.flush(); continue
        exe=os.path.join(tree,'build/compiler')
        verdict='SURVIVED'
        for r in runners:
            cmd=[exe]+[a.replace('EXE',exe) for a in r.split()]
            t=time.time()
            try:
                q=subprocess.run(cmd,cwd=tree,capture_output=True,text=True,timeout=3600,env=env)
                rc=q.returncode; tail=(q.stdout+q.stderr)[-300:].replace('\n',' | ')
            except subprocess.TimeoutExpired:
                rc='timeout'; tail=''
            if rc!=0:
                verdict=f'KILLED by {r} rc={rc} ({time.time()-t:.0f}s): {tail}'
                break
        res.write(f'{name}\t{verdict}\n'); res.flush()
    finally:
        open(p,'w').write(s)
res.write('done\n'); res.flush()
