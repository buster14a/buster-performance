from pathlib import Path
import csv,hashlib,itertools,os,subprocess,resource
p=Path(__file__).resolve().parent;w=p.parents[1];src=p/'lua-5.4.8/src';ts=p/'lua-5.4.8-tests';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400');resource.setrlimit(resource.RLIMIT_CORE,(0,0))
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
rows=[]
for mode,v in itertools.product(['release','internal'],['clang','control','candidate']):
 d=p/(mode+'-'+v);c=cc if v=='clang' else w/('final-'+v)/'build/compiler';e=d/'lua-readline';o=d/'lua-readline.o';ext=[] if v=='clang' else ['--tier1','--lanes','1'];opt=['-O2','-std=gnu99','-DLUA_USE_READLINE','-DLUA_COMPAT_5_3','-DLUA_USE_LINUX','-march=znver5','-w','-I',src]
 if mode=='internal':opt+=['-DLUA_USER_H="ltests.h"','-I',ts/'ltests']
 run(c,*ext,*opt,'-c',src/'lua.c','-o',o);run(cc,'-no-pie','-Wl,-E',o,*sorted(q for q in d.glob('*.o') if q.name not in ('lua-readline.o','lua.o')),'-lm','-ldl','-lreadline','-o',e)
 with (d/'full-readline.log').open('w') as log:
  try:rc=subprocess.run([e,'all.lua'],cwd=d/'suite',stdout=log,stderr=subprocess.STDOUT,timeout=510).returncode
  except subprocess.TimeoutExpired:rc=124
 (d/'full-readline.status').write_text(str(rc)+'\n');rows.append([mode,v,sha(e),sha(o),rc]);print(mode,v,rc,flush=True)
with (p/'readline-checks.tsv').open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(['mode','compiler','executable_sha256','readline_lua_object_sha256','full_exit']);t.writerows(rows)
