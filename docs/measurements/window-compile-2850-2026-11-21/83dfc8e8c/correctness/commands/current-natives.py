"""Read the ordinary backend's true sourced inputs and side tables with identical observation on both paths."""
from pathlib import Path
import subprocess,os,shlex,struct,csv,tempfile,hashlib,sys
from concurrent.futures import ThreadPoolExecutor
d=Path(__file__).resolve().parent;r=d/'83dfc8e8c/native';w=d.parent;cc=Path(sys.argv[1]).resolve();r.mkdir(exist_ok=True);src=w/'switch-inputs';bs=w/'pregraph-warning-study/compiler-source';cases=[]
policies=[('normal',[]),('debug',['-g']),('wall',['-Wall','-Wextra']),('everything',['-Weverything'])]
h=lambda b:hashlib.sha256(b).hexdigest()
for group in ['sqlite','self','lua','musl']:
 if group=='self':ns=['-march=native','-I'+str(bs/'src'),'-fwrapv','-funsigned-char','--predefines',str(w/'proof-predefines.h'),str(bs/'src/buster/compiler/main.c')]
 else:ns=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$'+group+'_arguments"'],cwd=src,text=True))
 files=[t for t in ns if t.endswith('.c')];flags=[t for t in ns if not t.endswith('.c')]
 for file in files:
  for policy,opts in policies: cases.append((group,file,flags,policy,opts))
def one(q):
 group,file,flags,policy,opts=q
 with tempfile.TemporaryDirectory(dir=r) as tmp:
  p=Path(tmp);results=[]
  for mode in ['ordinary','option']:
   o=p/'a.o';n=p/'a.native';o.unlink(missing_ok=True);n.unlink(missing_ok=True)
   env=os.environ.copy();env['NODE_SOURCE_NATIVE_ORACLE']=str(n)
   pr=subprocess.run([cc,'--lanes','1','-c',*(['--node-window-constants'] if mode=='option' else []),*opts,*flags,file,'-o',o],cwd=src,capture_output=True,env=env)
   assert not pr.returncode,(file,pr.stderr[-300:]);data=n.read_bytes() if n.exists() else b'';counts=[0]*5;at=0
   while at<len(data):
    _,sz,loc,call,args,dbg=struct.unpack_from('<6I',data,at);at+=24+sz*(10+4*dbg)+2*loc+13*call+args
    for i,z in enumerate([1,sz,loc,call,args]):counts[i]+=z
   assert at==len(data)
   results.append((h(pr.stderr),h(o.read_bytes()),h(data),*counts))
  return [group,file,policy,*results[0],results[0]==results[1]]
with (r/'pairs.tsv').open('w') as f,ThreadPoolExecutor(max_workers=2) as pool:
 a=csv.writer(f,delimiter='\t',lineterminator='\n');a.writerow(['group','unit','policy','diagnostics','elf','native','bodies','rows','locals','calls','arguments','same'])
 for row in pool.map(one,cases):a.writerow(row);f.flush()
