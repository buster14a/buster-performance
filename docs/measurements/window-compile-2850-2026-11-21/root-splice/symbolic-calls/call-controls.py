from pathlib import Path
import csv,os,tempfile,subprocess,hashlib,sys,re
d=Path(__file__).resolve().parent;cc=Path(sys.argv[1]).resolve()
env=dict(NODE_SPLICE_FRONT='1',NODE_SOURCE_ROWS='1',NODE_SOURCE_ONLY='1',NODE_SOURCE_STRINGS='1',
 NODE_SOURCE_REFRESH_POINTERS='1',NODE_PROOF_NATIVE='1',NODE_PROOF_NO_FP='1',NODE_PROOF_CALLS='1',NODE_PROOF_POINTERS='1',NODE_SPLICE_ENABLE='1',NODE_SPLICE_CALLS='1',NODE_SPLICE_REPORT='1')
modes={'ordinary':{},'source-only':env,'wrong-source':dict(env,NODE_SOURCE_CALL_FAULT='t'),'wrong-symbol':dict(env,NODE_SOURCE_CALL_FAULT='s'),'wrong-arg':dict(env,NODE_SOURCE_CALL_FAULT='v'),'invalid-object':dict(env,NODE_PROOF_CALL_ROW_FAULT='s'),'invalid-class':dict(env,NODE_PROOF_CALL_ROW_FAULT='a'),'invalid-varargs':dict(env,NODE_PROOF_CALL_ROW_FAULT='v')}
if os.getenv('CALL_VIEW_TESTS'):
 for name,opts in modes.items():
  if name!='ordinary': opts.pop('NODE_SOURCE_REFRESH_POINTERS',None); opts['NODE_CROSS_SYMBOLIC_CALLEE']='1'
with tempfile.TemporaryDirectory() as td,(d/('view-controls.tsv' if os.getenv('CALL_VIEW_TESTS') else 'direct-controls.tsv')).open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('mode exit taken native_sha256 object_sha256 same_status same_diag same_native same_object link run'.split());ref=None
 for name,opts in modes.items():
  t=Path(td);obj=t/'fixture.o';nat=t/'native';exe=t/'run'
  for p in (obj,nat,exe):p.unlink(missing_ok=True)
  e=dict(os.environ,**opts,NODE_SOURCE_NATIVE_ORACLE=str(nat));p=subprocess.run([cc,'--lanes','1','-g','-c',d/'callfixture.c','-o',obj],env=e,capture_output=True);ls=p.stderr.splitlines(keepends=True)
  diag=b''.join(r for r in ls if not r.startswith((b'source-rows ',b'node-proof ',b'splice-',b'probe-select ',b'cross-view ',b'cross-symbolic ',b'cross-canonical ',b'cross-call-private ')))
  h=lambda file:hashlib.sha256(file.read_bytes()).hexdigest() if file.exists() else '-'
  v=[p.returncode,diag,h(nat),h(obj)];ref=v if ref is None else ref;link=run='-'
  if obj.exists():
   link=subprocess.run(['cc','-no-pie',d/'call-main.c',obj,'-o',exe],capture_output=True).returncode
   if link==0 and name!='wrong-symbol':run=subprocess.run([exe],capture_output=True).returncode
  w.writerow([name,p.returncode,sum(x.startswith(b'splice-direct:') for x in ls),v[2],v[3],*[int(a==b) for a,b in zip(v,ref)],link,run])
