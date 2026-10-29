#!/usr/bin/env python3
"""Compare getrusage's pre-exec high water with live post-exec VmHWM."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import tempfile
import time

p=argparse.ArgumentParser()
p.add_argument('--compiler',required=True)
p.add_argument('--corpus',required=True)
p.add_argument('--out',required=True)
a=p.parse_args()
compiler=str(Path(a.compiler).resolve()); corpus=Path(a.corpus).resolve(); out=Path(a.out).resolve();out.mkdir(exist_ok=True,parents=True)
os.environ['SOURCE_DATE_EPOCH']='1792454400'
os.environ.pop('CPATH',None);os.environ.pop('C_INCLUDE_PATH',None)

def sample(name, object_path):
    cmd=[compiler,'--time-stages','-c','--predefines',str(corpus/'provenance/gnu17-pinned-predefines.txt'),
         '--clang-features','-march=znver5','-std=gnu17','-nostdinc',
         '-isystem',str(corpus/'headers/usr/lib/clang/23/include'),'-isystem',str(corpus/'headers/usr/local/include'),
         '-isystem',str(corpus/'headers/usr/include'),'-I'+str(corpus/'sqlite'),'-o',str(object_path),str(corpus/'sqlite/sqlite3.c')]
    log=out/f'rss-parent-{name}.stderr'
    with log.open('wb') as err:
        proc=subprocess.Popen(cmd,stdout=subprocess.DEVNULL,stderr=err)
        seen=[]
        while True:
            try:
                if os.readlink(f'/proc/{proc.pid}/exe')==compiler:
                    status=Path(f'/proc/{proc.pid}/status').read_text()
                    for line in status.splitlines():
                        if line.startswith('VmHWM:'):
                            seen.append(int(line.split()[1]));break
            except (OSError,ProcessLookupError):pass
            pid, status, ru=os.wait4(proc.pid, os.WNOHANG)
            if pid:
                proc.returncode=os.waitstatus_to_exitcode(status)
                break
            time.sleep(0.001)
    lines=log.read_text().splitlines()
    reported=next(int(x.split('\t')[2]) for x in lines if x.startswith('time-process\tpeak-rss-kb\t'))
    additions=sum(int(x.split('\t')[6]) for x in lines if x.startswith('time-stage\t') and x.split('\t')[1]!='stage' and len(x.split('\t'))>=7)
    return {'returncode':proc.returncode,'reported_peak_kib':reported,'wait4_maxrss_kib':ru.ru_maxrss,
            'sampled_post_exec_vmhwm_max_kib':max(seen) if seen else None,'vmhwm_samples':len(seen),
            'sum_stage_peak_added_kib':additions}

with tempfile.TemporaryDirectory(prefix='buster-rss-parent-') as tmp:
    result={'small_parent':sample('small',Path(tmp)/'small.o')}
    allocation=bytearray(1024*1024*1024)
    for i in range(0,len(allocation),4096):allocation[i]=1
    result['large_parent']=sample('large',Path(tmp)/'large.o')
    result['parent_allocation_mib']=1024
    result['outputs_equal']=Path(tmp,'small.o').read_bytes()==Path(tmp,'large.o').read_bytes()
(out/'rss-parent-repro.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
