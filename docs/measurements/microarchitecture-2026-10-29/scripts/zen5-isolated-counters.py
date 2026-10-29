#!/usr/bin/env python3
"""Recollect Zen 5 events individually; acquire/release the shared lock per process."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

p=argparse.ArgumentParser()
p.add_argument('--compiler',required=True)
p.add_argument('--corpus',required=True)
p.add_argument('--event-probes',required=True)
p.add_argument('--out',required=True)
p.add_argument('--repetitions',type=int,default=2)
p.add_argument('--resume',action='store_true')
a=p.parse_args()
compiler=str(Path(a.compiler).resolve());corpus=Path(a.corpus).resolve();out=Path(a.out).resolve();out.mkdir(exist_ok=True,parents=True)
os.environ.update({'EXCLUSIVE_OWNER':'codex-microarch-20261029',
                   'EXCLUSIVE_TITLE':'Buster 9700X isolated counter sweep',
                   'EXCLUSIVE_LINK':'https://github.com/buster14a/buster-performance/pull/120',
                   'LC_ALL':'C','SOURCE_DATE_EPOCH':'1792454400'})
os.environ.pop('CPATH',None);os.environ.pop('C_INCLUDE_PATH',None)
lock=str(Path.home()/'buster-fast-bench/exclusive.sh')
base=['--predefines',str(corpus/'provenance/gnu17-pinned-predefines.txt'),'--clang-features',
      '-march=znver5','-std=gnu17','-nostdinc','-isystem',str(corpus/'headers/usr/lib/clang/23/include'),
      '-isystem',str(corpus/'headers/usr/local/include'),'-isystem',str(corpus/'headers/usr/include'),'-I'+str(corpus/'sqlite')]
source=str(corpus/'sqlite/sqlite3.c')
with tempfile.TemporaryDirectory(prefix='buster-isolated-') as tmp:
    obj=str(Path(tmp)/'sqlite.o')
    workloads={'preprocess':[compiler,'-E','-P',*base,'-o','/dev/null',source],
               'syntax':[compiler,'-fsyntax-only',*base,source],
               'compile':[compiler,'-c',*base,'-o',obj,source]}
    events=[x['event'] for x in json.loads(Path(a.event_probes).read_text()) if x['available']]
    temp_stat=Path(tmp)/'perf.csv';temp_error=Path(tmp)/'stderr'
    path=out/'recovery.jsonl'
    completed=set()
    if a.resume and path.exists():
        for line in path.read_text().splitlines():
            row=json.loads(line)
            if row['status']==0:
                completed.add((row['event'],row['repetition'],row['workload']))
    with path.open('a' if a.resume else 'w') as log:
        for index,event in enumerate(events):
            for repetition in range(a.repetitions):
                for workload,cmd in workloads.items():
                    if (event,repetition,workload) in completed:
                        continue
                    perf=['perf','stat','--no-big-num','-x',';','-o',str(temp_stat),
                          '-e',f'cycles:u,instructions:u,{event}:u','--',*cmd]
                    with temp_error.open('wb') as err:
                        run=subprocess.run([lock,'timeout','30','taskset','-c','2',*perf],
                                           stdout=subprocess.DEVNULL,stderr=err,check=False)
                    # Waiting messages identify other owners; they are coordination, not measurement data.
                    error='\n'.join(line for line in temp_error.read_text(errors='replace').splitlines()
                                    if not line.startswith(('exclusive.sh: ', '  title: ', '  link: ')))
                    row={'event':event,'repetition':repetition,'workload':workload,'status':run.returncode,
                         'perf_stat':temp_stat.read_text() if temp_stat.exists() else '', 'stderr':error}
                    log.write(json.dumps(row)+'\n');log.flush()
            if index % 20 == 0:print('isolated event',index+1,'of',len(events),flush=True)
print('done',len(events),'events',flush=True)
