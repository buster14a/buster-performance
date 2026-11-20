from pathlib import Path
import csv,hashlib,os,resource,subprocess
p=Path(__file__).resolve().parent;rcs=[];os.environ['LC_ALL']='C';resource.setrlimit(resource.RLIMIT_CORE,(0,0))
for mode in ['release','internal']:
 for v in ['clang','control','candidate']:
  d=p/(mode+'-'+v);e=d/'lua-readline'
  with (d/'full-pipe.log').open('w') as fh:
   try:rc=subprocess.run([e,'all.lua'],cwd=d/'suite',input=b'',stdout=fh,stderr=subprocess.STDOUT,timeout=480).returncode
   except subprocess.TimeoutExpired:rc=124
  s=(d/'full-pipe.log').read_text(errors='replace');(d/'full-pipe.status').write_text(str(rc)+'\n');rcs.append([mode,v,rc,s.count('***** FILE'), 'final OK !!!' in s,hashlib.file_digest(e.open('rb'),'sha256').hexdigest()]);print(rcs[-1],flush=True)
with (p/'full-checks.tsv').open('w') as f:q=csv.writer(f,delimiter='\t',lineterminator='\n');q.writerow(['mode','compiler','full_exit','test_file_sections','upstream_completion','executable_sha256']);q.writerows(rcs)
