import subprocess, sys, os, time
sys.path.insert(0, os.path.dirname(__file__))
from mutants import M
TREE='/home/user/buster-mut'
F=TREE+'/src/buster/compiler/ssa.c'
LOG=os.path.dirname(__file__)+'/results.txt'
orig=open(F).read()
only=sys.argv[1:]
env=dict(os.environ)
clang=subprocess.run("ls -d ~/.cache/buster/toolchain/*/llvm-*/bin/clang | head -1",shell=True,capture_output=True,text=True).stdout.strip()
env['PATH']=os.path.dirname(clang)+':'+env['PATH']
TESTS=[
 ['./build/compiler','test-ssa'],
 ['./build/compiler','test-ssa-ir'],
 ['./build/compiler','test-ir-lowering'],
]
CT=subprocess.run("sed -n 's|^\\([0-9][0-9]*\\)$|build/c-testsuite/tests/single-exec/\\1.c|p' tests/c-testsuite/subset.txt",shell=True,cwd=TREE,capture_output=True,text=True).stdout.split()
TESTS.append(['./build/compiler','test-ssa-source','--typed']+CT)
TESTS.append(['./build/compiler','test-ssa-source','--generate','24','--clang','clang'])
try:
  for mid,old,new in M:
    if only and mid not in only: continue
    assert orig.count(old)==1,(mid,orig.count(old))
    open(F,'w').write(orig.replace(old,new))
    t0=time.time()
    b=subprocess.run(['./build.sh','--config','Release'],cwd=TREE,capture_output=True,text=True,env=env)
    if b.returncode!=0:
        res='UNBUILT'
    else:
        res='SURVIVED'
        for t in TESTS:
            try:
                r=subprocess.run(t,cwd=TREE,capture_output=True,text=True,env=env,timeout=900)
                ok=r.returncode==0
            except subprocess.TimeoutExpired:
                ok=False; t=t+['(timeout)']
            if not ok:
                res='KILLED by '+' '.join(t[:3])
                break
    with open(LOG,'a') as l: l.write(f"{mid} {res} {int(time.time()-t0)}s\n")
finally:
    open(F,'w').write(orig)
