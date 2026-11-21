import csv,hashlib,os,re,shlex,subprocess,sys,tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
d=Path(os.environ.get("BUSTER_CASE_DIR",Path(__file__).resolve().parent)).resolve();cc=Path(sys.argv[1]).resolve();out=Path(sys.argv[2]).resolve()
policies=[('debug',['-g'])] if os.environ.get('BUSTER_MEMBER_DEBUG_POLICIES') else [('default',[]),('wall',['-Wall','-Wextra'])]
jobs=[]
for c,a in zip(['sqlite','lua','musl','buster'],sys.argv[3:7]):
 args=shlex.split(a);flags=[a for a in args if not a.endswith('.c')]
 for arg in args:
  if arg.endswith('.c'):
   jobs.extend((c,Path(arg).resolve(),flags+other,pol) for pol,other in policies)
def digest(p):
 return hashlib.file_digest(p.open('rb'),'sha256').hexdigest() if p.exists() else ''
def one(j):
 name,s,flags,pol=j
 with tempfile.TemporaryDirectory(dir=d) as tmp:
  tmp=Path(tmp);r=[]
  for opt in [False,True]:
   obj=tmp/'a.o';native=tmp/'native';refs=tmp/'refs'
   for p in [obj,native,refs]:p.unlink(missing_ok=True)
   env=dict(os.environ,BUSTER_WINDOW_CALL_LOG='1',NODE_SOURCE_NATIVE_ORACLE=str(native),BUSTER_CALL_REFERENCES=str(refs))
   if opt:env['BUSTER_CALL_ARROW']='1'
   p=subprocess.run([cc,'--lanes','1','--node-window-calls',*flags,'-c',s,'-o',obj],capture_output=True,env=env)
   lines=p.stderr.splitlines(keepends=True);err=b''.join(l for l in lines if not l.startswith((b'plain-call:',b'arrow-call:')))
   members=re.findall(rb'^arrow-call: token=\d+ members=(\d+) rows=(\d+)',p.stderr,re.M)
   r.append((p.returncode,hashlib.sha256(err+p.stdout).hexdigest(),digest(obj),digest(native),digest(refs),p.stderr.count(b'plain-call:'),len(members),sum(int(x) for x,y in members),sum(int(y) for x,y in members),err))
  a,b=r
  if a[:5]!=b[:5]:
   mism=d/'corpus-mismatches'/name/s.name/pol;mism.mkdir(parents=True,exist_ok=True);(mism/'ordinary').write_bytes(a[-1]);(mism/'physical').write_bytes(b[-1])
  return [name,str(s),pol,a[0],b[0],a[5],*b[5:9],*[int(x==y) for x,y in zip(a[1:5],b[1:5])],*a[1:5],*b[1:5]]
with out.open('w',buffering=1) as f, ThreadPoolExecutor(max_workers=2) as pool:
 w=csv.writer(f,delimiter='\t',lineterminator='\n')
 w.writerow('corpus source policy baseline_status candidate_status baseline_calls candidate_calls sites members rows same_diag same_elf same_native same_refs base_diag base_elf base_native base_refs new_diag new_elf new_native new_refs'.split())
 for row in pool.map(one,jobs):w.writerow(row)
