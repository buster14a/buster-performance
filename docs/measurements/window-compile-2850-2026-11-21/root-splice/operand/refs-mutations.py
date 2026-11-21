from pathlib import Path
import csv,hashlib,os,subprocess,sys,tempfile
d=Path(__file__).resolve().parent; cc=Path(sys.argv[1]).resolve()
base={k:v for k,v in os.environ.items() if not k.startswith(('NODE_SOURCE','NODE_SPLICE','NODE_PROOF'))}
proof=dict(NODE_SPLICE_FRONT='1',NODE_SOURCE_ROWS='1', NODE_SOURCE_COMPACT='1',NODE_PROOF_NATIVE='1',NODE_PROOF_NO_FP='1',NODE_PROOF_CALLS='1',NODE_PROOF_POINTERS='1',
          NODE_SOURCE_COMPACT_REPORT='1',NODE_SPLICE_REPORT='1')
cases={'ordinary':None,'required':{},'omit_references':{'NODE_SOURCE_OMIT_REFERENCES':'1'},'reject_required':{'NODE_SOURCE_OMIT_REQUIRED':'1'},'fall_through':{'NODE_SOURCE_OMIT_REQUIRED':'1','NODE_SOURCE_FALLBACK':'1'}}
root=d/'refs-mutation-output';root.mkdir(exist_ok=True)
with (root/'results.tsv').open('w') as fp:
 w=csv.writer(fp,delimiter='\t',lineterminator='\n');w.writerow('mode exit object_sha256 native_sha256 admissions consumes symbols link execute'.split())
 for label,mut in cases.items():
  obj=root/(label+'.o');exe=root/(label+'.exe');wit=root/(label+'.native')
  for f in obj,exe,wit: f.unlink(missing_ok=True)
  e=dict(base)
  if not os.getenv('REFS_ARTIFACT_ONLY'): e['NODE_SOURCE_NATIVE_ORACLE']=str(wit)
  if mut is not None: e.update(proof);e.update(mut)
  c=subprocess.run([cc,'--lanes','1','-g','-c',d/'unique-static.c','-o',obj],env=e,capture_output=True)
  (root/(label+'.err')).write_bytes(c.stderr)
  h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else '-'
  names='-';link='-';run='-'
  if obj.exists():
   names=','.join(x.split()[-1] for x in subprocess.check_output(['nm',obj],text=True).splitlines() if 'retained_' in x) or '-'
   link=subprocess.run(['cc','-no-pie',d/'static-main.c',obj,'-o',exe],capture_output=True).returncode
   if link==0:run=subprocess.run([exe],capture_output=True).returncode
  w.writerow((label,c.returncode,h(obj),h(wit),c.stderr.count(b'compact-taken:'),c.stderr.count(b'compact-consumed:'),names,link,run))
