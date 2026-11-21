#!/usr/bin/env python3
"""Measure a same-image switch diagnostic control on every Lua C file, three rotated pairs."""
import argparse
import csv
from hashlib import sha256
import os
from pathlib import Path
from statistics import median
import subprocess
import tempfile

a=argparse.ArgumentParser(description=__doc__)
a.add_argument('compiler', type=Path)
a.add_argument('lua', type=Path)
a.add_argument('raw', type=Path)
args=a.parse_args()
exe=args.compiler.resolve()
rows=[]
baseline_total=candidate_total=0
with tempfile.TemporaryDirectory() as temp:
    root=Path(temp)
    with args.raw.open('w', newline='') as raw:
        writer=csv.writer(raw,delimiter='\t')
        writer.writerow(['unit','round','position','lazy','user_instructions','user_cycles','minor_faults','object_sha256','stdout_sha256','stderr_sha256'])
        for source in sorted(args.lua.resolve().glob('*.c')):
            sampled=[]
            for iteration in range(3):
                pair={}
                for position,lazy in enumerate((0,1) if iteration%2==0 else (1,0)):
                    env=dict(os.environ)
                    env.pop('BUSTER_PRIVATE_LAZY_SWITCH_SPELLING',None)
                    if lazy:
                        env['BUSTER_PRIVATE_LAZY_SWITCH_SPELLING']='1'
                    obj=root/'test.o'
                    stats=root/'counts'
                    cmd=['perf','stat','-x','\t','-o',str(stats),'-e','instructions:u,cycles:u,minor-faults','--',str(exe),'-c',str(source),'-o',str(obj)]
                    run=subprocess.run(cmd,env=env,capture_output=True,check=True)
                    counts={}
                    for line in stats.read_text().splitlines():
                        fields=line.split('\t')
                        if len(fields)>3:
                            counts[fields[2]]=int(fields[0])
                    outputs=(obj.read_bytes(),run.stdout,run.stderr)
                    writer.writerow([source.name,iteration+1,position+1,lazy,counts['instructions:u'],counts['cycles:u'],counts['minor-faults'],
                                     *[sha256(value).hexdigest() for value in outputs]])
                    pair[lazy]=(counts,outputs)
                assert pair[0][1]==pair[1][1],(source,iteration)
                sampled.append((pair[0][0],pair[1][0]))
            ib=median(before['instructions:u'] for before,after in sampled)
            ia=median(after['instructions:u'] for before,after in sampled)
            delta=median(after['instructions:u']-before['instructions:u'] for before,after in sampled)
            print(source.name,ib,ia,delta,sep='\t',flush=True)
            baseline_total+=ib
            candidate_total+=ia
    print('sum of per-file medians',baseline_total,candidate_total,candidate_total-baseline_total,sep='\t')
