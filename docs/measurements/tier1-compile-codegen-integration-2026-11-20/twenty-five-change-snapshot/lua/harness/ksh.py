from pathlib import Path
import csv,hashlib,subprocess,resource
p=Path(__file__).resolve().parent;shell=Path((p/'env/chosen').read_text().strip());rows=[];resource.setrlimit(resource.RLIMIT_CORE,(0,0))
for mode in ['release','internal']:
 for v in ['clang','control','candidate']:
  d=p/(mode+'-'+v);e=d/'lua-readline';suite=d/'suite'
  with (d/'full-ksh.log').open('w') as f:
   args=['bwrap','--ro-bind','/','/','--bind',suite,suite,'--ro-bind',shell,'/usr/bin/bash','--dev','/dev','--tmpfs','/tmp','--chdir',suite,'--',e,'all.lua']
   try:rc=subprocess.run(args,input=b'',stdout=f,stderr=subprocess.STDOUT,timeout=420).returncode
   except subprocess.TimeoutExpired:rc=124
  s=(d/'full-ksh.log').read_text(errors='replace');(d/'full-ksh.status').write_text(str(rc)+'\n');rows.append([mode,v,rc,s.count('***** FILE'),'final OK !!!' in s,hashlib.file_digest(e.open('rb'),'sha256').hexdigest()]);print(rows[-1],flush=True)
with (p/'ksh-checks.tsv').open('w') as f:q=csv.writer(f,delimiter='\t',lineterminator='\n');q.writerow(['mode','compiler','exit','test_file_sections','upstream_completion','executable_sha256']);q.writerows(rows)
