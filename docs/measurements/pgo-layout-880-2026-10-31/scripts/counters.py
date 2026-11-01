#!/usr/bin/env python3
"""Issue #880: frontend counters for layout variants; one lock per process."""
import argparse, json, os, subprocess, tempfile
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument('--corpus', required=True)
p.add_argument('--out', required=True)
p.add_argument('--builds', required=True, help='comma list name=dir')
p.add_argument('--placements', default='0,512')
p.add_argument('--repetitions', type=int, default=2)
p.add_argument('--resume', action='store_true')
a = p.parse_args()
corpus = Path(a.corpus).resolve(); out = Path(a.out).resolve(); out.mkdir(exist_ok=True, parents=True)
os.environ.update({'EXCLUSIVE_OWNER':'devin-880','EXCLUSIVE_TITLE':'buster #880 PGO layout counters',
                   'EXCLUSIVE_LINK':'https://github.com/buster14a/buster/issues/880',
                   'LC_ALL':'C','SOURCE_DATE_EPOCH':'1792454400'})
os.environ.pop('CPATH',None); os.environ.pop('C_INCLUDE_PATH',None)
lock = str(Path.home()/'buster-fast-bench/exclusive.sh')
base = ['--predefines',str(corpus/'provenance/gnu17-pinned-predefines.txt'),'--clang-features',
      '-march=znver5','-std=gnu17','-nostdinc','-isystem',str(corpus/'headers/usr/lib/clang/23/include'),
      '-isystem',str(corpus/'headers/usr/local/include'),'-isystem',str(corpus/'headers/usr/include'),'-I'+str(corpus/'sqlite')]
source = str(corpus/'sqlite/sqlite3.c')
events = ['de_no_dispatch_per_slot.no_ops_from_frontend','de_no_dispatch_per_slot.backend_stalls',
          'op_cache_hit_miss.op_cache_miss','op_cache_hit_miss.all_op_cache_accesses',
          'l2_request_g1.cacheable_ic_read','bp_l2_btb_correct','ex_no_retire.empty',
          'de_src_op_disp.x86_decoder','ex_ret_brn_misp']
builds = []
for spec in a.builds.split(','):
    n,d = spec.split('=',1); builds.append((n,Path(d).resolve()))
placements = a.placements.split(',')
path = out/'counters.jsonl'
completed = set()
if a.resume and path.exists():
    for line in path.read_text().splitlines():
        r = json.loads(line)
        if r['status']==0: completed.add((r['build'],r['placement'],r['event'],r['repetition'],r['workload']))
with tempfile.TemporaryDirectory(prefix='buster-880-') as tmp, path.open('a' if a.resume else 'w') as log:
    obj = str(Path(tmp)/'sqlite.o')
    for bname,bdir in builds:
        for pl in placements:
            comp = str(bdir/f'compiler-{pl}')
            workloads = {'preprocess':[comp,'-E','-P',*base,'-o','/dev/null',source],
                         'syntax':[comp,'-fsyntax-only',*base,source],
                         'compile':[comp,'-c',*base,'-o',obj,source]}
            for event in events:
                for rep in range(a.repetitions):
                    for workload,cmd in workloads.items():
                        key=(bname,pl,event,rep,workload)
                        if key in completed: continue
                        perf=['perf','stat','--no-big-num','-x',';','-e',f'cycles:u,instructions:u,{event}:u','--',*cmd]
                        run = subprocess.run([lock,'timeout','60','taskset','-c','2',*perf],
                                             stdout=subprocess.DEVNULL,stderr=subprocess.PIPE)
                        err='\n'.join(l for l in run.stderr.decode(errors='replace').splitlines()
                                      if not l.startswith(('exclusive.sh: ','  title: ','  link: ')))
                        log.write(json.dumps({'build':bname,'placement':pl,'event':event,'repetition':rep,
                            'workload':workload,'status':run.returncode,'stderr':err})+'\n'); log.flush()
            print(f'{bname} placement {pl} done',flush=True)
print('done',flush=True)
