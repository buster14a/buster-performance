"""Verify the body-window list, record and decoy oracles and collect paired PMU measurements."""
import csv
import hashlib
import io
import re
import shutil
import statistics as st
import sys
import tarfile
from collections import defaultdict
from pathlib import Path

here=Path(__file__).resolve().parent
dataset='step1-product-calls'
directory='finish-calls-in-window-order'
runner='facts-product-pair.sh'
rounds=5
labels=['factsmain0e1d','factsproduct']
raw=here/'raw/results'
out=here.parent/'perf/docs/measurements/per-core-step1-2850-2026-11-21'/directory
out.mkdir(parents=True,exist_ok=True)
reference='0e1d5b825801135bf50e79da9d546bc95209ab30'
def write(name,head,rows):
    with (out/name).open('w') as f:
        t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rows)
builds=[]
for label in labels:
    patch=here/(label+'.patch')
    rev=(raw/label/'revision.txt').read_text().splitlines()
    digest=hashlib.sha256(patch.read_bytes()).hexdigest() if label==labels[1] else '-'
    assert rev[0]==reference and (rev[1].split()[0]==digest if label==labels[1] else len(rev)==1)
    builds.append([label,reference,digest,(raw/label/'compiler.sha256').read_text().split()[0]])
    if label==labels[1]: shutil.copy(patch,out)
write('builds.tsv',['build','source','applied patch sha256','compiler sha256'],builds)
samples=[];summary=[];vals=defaultdict(list);coverage=defaultdict(set)
with tarfile.open(out/'measurements.tar.xz','w:xz') as t:
    for g in ('sqlite','lua','musl'):
        for mode in ('whole','lean'):
            for n in range(1,rounds+1):
                half=labels if n%2 else labels[::-1]
                for pos,l in enumerate(half+half[::-1]):
                    f=raw/dataset/f'{g}-{mode}-{n}-{pos}-{l}.txt'
                    log=f.read_text()
                    m=re.search(r'^node-facts: taken identifiers=(\d+) \([\d.]+%\) lookups=(\d+) \([\d.]+%\) differences=0 list-differences=0 failures=0 \(differences over decoys 0\)',log,re.M)
                    metrics=re.search(r'^node-facts: the kernel a taken leaf or lookup: cycles=([\d.]+) instructions=([\d.]+) mispredicted-branches=([\d.]+)',log,re.M)
                    passes=re.search(r'^node-facts: the two passes, a record of the windows: the given records put in place and the kernel: cycles=([\d.]+) instructions=([\d.]+) ticks=([\d.]+); the given records alone: cycles=([\d.]+) instructions=([\d.]+) ticks=([\d.]+)',log,re.M)
                    loops=re.search(r"^node-facts: the kernel's loops, TSC ticks \(([\d.]+) cycles a tick\): a leaf=([\d.]+) a lookup=([\d.]+); a window's second run: a leaf=([\d.]+) a lookup=([\d.]+)",log,re.M)
                    assert m and metrics and passes and loops,f
                    coverage[g,mode].add(m.groups())
                    data=tuple(map(float,metrics.groups()+passes.groups()))
                    calibration,leaf,lookup,leaf2,lookup2=map(float,loops.groups())
                    data+=tuple(calibration*x for x in (leaf,lookup,leaf2,lookup2))
                    vals[g,mode,n,l].append(data)
                    samples.append([g,mode,n,pos,l,*m.groups(),*data])
                    blob=('\n'.join(line for line in log.splitlines() if line.startswith(('node-','measure-node-machine:')))+'\n').encode()
                    item=tarfile.TarInfo(f.name);item.size=len(blob);t.addfile(item,io.BytesIO(blob))
assert all(len(v)==1 for v in coverage.values())
write('samples.tsv',['input','mode','round','position','build','taken identifiers','taken lookups','cycles/taken','instructions/taken','branch misses/taken','full cycles/window record','full instructions/window record','full ticks/window record','given cycles/window record','given instructions/window record','given ticks/window record','first leaf cycles/leaf','first lookup cycles/lookup','second leaf cycles/leaf','second lookup cycles/lookup'],samples)
for (g,mode) in coverage:
    for l in labels:
        for i,k in enumerate(('cycles','instructions','branch misses','full cycles/window record','full instructions/window record','full ticks/window record','given cycles/window record','given instructions/window record','given ticks/window record','first leaf cycles/leaf','first lookup cycles/lookup','second leaf cycles/leaf','second lookup cycles/lookup')):
            v=[st.mean(x[i] for x in vals[g,mode,n,l]) for n in range(1,rounds+1)]
            ref=[st.mean(x[i] for x in vals[g,mode,n,labels[0]]) for n in range(1,rounds+1)]
            delta=[x-y for x,y in zip(v,ref)]
            row=[g,mode,l,k,st.median(v),st.median(delta),min(delta),max(delta),sum(x<0 for x in delta)]
            summary.append(row)
            if k=='cycles':print(g,mode,l,round(row[4],3),round(row[5],3))
write('paired.tsv',['input','mode','build','metric (per taken record unless indicated)','median','paired median difference','minimum difference','maximum difference','lower rounds'],summary)
for f in [here/runner,Path(__file__),here/'raw/corpora.sh']:shutil.copy(f,out)
