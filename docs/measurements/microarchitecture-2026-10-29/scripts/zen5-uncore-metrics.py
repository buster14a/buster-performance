#!/usr/bin/env python3
"""Try unavailable per-thread metric names on a locked system-wide workload."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import tempfile

p=argparse.ArgumentParser();p.add_argument('--compiler',required=True);p.add_argument('--corpus',required=True)
p.add_argument('--scaling',required=True);p.add_argument('--names',required=True);p.add_argument('--out',required=True)
a=p.parse_args();out=Path(a.out).resolve();out.mkdir(exist_ok=True,parents=True)
os.environ.update({'EXCLUSIVE_OWNER':'codex-microarch-20261029',
 'EXCLUSIVE_TITLE':'Buster 9700X system-wide metric sweep',
 'EXCLUSIVE_LINK':'https://github.com/buster14a/buster-performance/pull/120',
 'LC_ALL':'C','SOURCE_DATE_EPOCH':'1792454400'})
os.environ.pop('CPATH',None);os.environ.pop('C_INCLUDE_PATH',None)
lock=str(Path.home()/'buster-fast-bench/exclusive.sh')
with tempfile.TemporaryDirectory(prefix='buster-uncore-') as tmp, (out/'system-metrics.jsonl').open('w') as log:
 stat=Path(tmp)/'stat';error=Path(tmp)/'stderr';stdout=Path(tmp)/'stdout'
 for i,metric in enumerate(json.loads(Path(a.names).read_text())):
  stat.unlink(missing_ok=True)
  cmd=[lock,'timeout','90','perf','stat','-a','-C','0-7','--no-big-num','-x',';','-o',str(stat),'-M',metric,'--',
       'taskset','-c','0-7','python3',str(Path(a.scaling).resolve()),'--compiler',str(Path(a.compiler).resolve()),
       '--corpus',str(Path(a.corpus).resolve()),'--workers','8','--tasks','32']
  with stdout.open('wb') as so,error.open('wb') as se:r=subprocess.run(cmd,stdout=so,stderr=se,check=False)
  err='\n'.join(line for line in error.read_text(errors='replace').splitlines()
                if not line.startswith(('exclusive.sh: ','  title: ','  link: ','  pull request: ')))
  row={'metric':metric,'status':r.returncode,'perf_stat':stat.read_text() if stat.exists() else '',
       'workload_output':stdout.read_text(errors='replace'),'stderr':err}
  log.write(json.dumps(row)+'\n');log.flush()
  if i%10==0:print('system metric',i+1,'of',len(json.loads(Path(a.names).read_text())),flush=True)
print('done',flush=True)
