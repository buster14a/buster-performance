import os
import csv,os,subprocess,hashlib
from pathlib import Path
d=Path(os.environ.get("BUSTER_CASE_DIR",Path(__file__).resolve().parent)).resolve();out=d/'mutants';out.mkdir(exist_ok=True);cc=d/'observer'
def digest(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest() if p.exists() else ''
rs=[]
for source,opts in [('runtime.c',[]),('runtime.c',['-g']),('uninit.c',['-Werror=uninitialized']),('case-results/multi-line.c',['-g']),('case-results/two-fields.c',['-g'])]:
 for fault in ['ordinary','none','read','offset','order']:
  o=out/'case.o';n=out/'native';m=out/'marks';exe=out/'case'
  for t in [o,n,m,exe]:t.unlink(missing_ok=True)
  env=dict(os.environ,BUSTER_CALL_FORCE_DEBUG='1',BUSTER_WINDOW_CALL_LOG='1',NODE_SOURCE_NATIVE_ORACLE=str(n),BUSTER_CALL_MARKS=str(m))
  if fault!='ordinary':env['BUSTER_CALL_ARROW']='1'
  if fault not in ['ordinary','none']:env['BUSTER_MEMBER_FAULT']=fault
  cp=subprocess.run([cc,'--lanes','1','--node-window-calls',*opts,'-c',d/source,'-o',o],env=env,capture_output=True);log=cp.stderr.decode()
  stem=Path(source).stem+'-'+('debug' if '-g' in opts else 'regular')+'-'+fault
  (out/(stem+'.stderr')).write_bytes(cp.stderr)
  run=''
  if source=='runtime.c' and cp.returncode==0:
   subprocess.run(['clang',o,'-o',exe],check=True);run=subprocess.run([exe]).returncode
  rows=(Path(source).stem,' '.join(opts),fault,cp.returncode,run,log.count('arrow-call:'),digest(o),digest(n),digest(m))
  rs.append(rows)
with (out/'matrix.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('source opts fault compile_exit runtime_exit member_sites object_sha native_sha marks_sha'.split());w.writerows(rs)
