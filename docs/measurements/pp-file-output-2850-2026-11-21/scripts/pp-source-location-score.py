from collections import defaultdict
from pathlib import Path
from statistics import median
import re, sys

root = Path(sys.argv[1])
samples = defaultdict(lambda: defaultdict(lambda: defaultdict(list)))
hashes = defaultdict(set)

for row in (root / 'status').read_text().splitlines():
    round_id, corpus, order, arm = row.split()
    path = root / f'{round_id}-{corpus}-{order}-{arm}'
    def observe(metric, value):
        samples[corpus, metric][round_id][arm].append(float(value))
    tokens = None
    for line in path.with_suffix('.pp').read_text().splitlines():
        if line.startswith('front '):
            tokens, runs, covered, setup, elapsed, release = map(int, line.split()[1:])
            for metric, val in [('PP tokens',tokens),('spans',runs),('borrowed rows',covered),('raw pp ms',elapsed/1e6),('raw pp ns/t',elapsed/tokens)]:observe(metric,val)
    assert tokens
    consume=[]
    for line in path.with_suffix('.consume').read_text().splitlines():
        if not line.startswith('consume '):continue
        _,n,number,checksum,elapsed = line.split()
        hashes[corpus,'location digest'].add(checksum)
        if int(n)==0:observe('cold consume ns/t',int(elapsed)/int(number))
        else:consume.append(int(elapsed)/int(number))
    observe('warm consume ns/t',median(consume))
    for suffix,name in [('.pp.perf','raw pp'),('.print.perf','actual print'),('.perf','staged compile')]:
        counts={}
        for line in path.with_suffix(suffix).read_text().splitlines():
            fields=line.split(';')
            if len(fields)>2 and fields[0].isdigit():counts[fields[2]]=int(fields[0])
        counts['cycles:u+k']=counts['cycles:u']+counts['cycles:k']
        for event in ('cycles:u','cycles:k','cycles:u+k','instructions:u','minor-faults'):
            observe(f'{name} {event}/t',counts[event]/tokens)
    for line in path.with_suffix('.stages').read_text().splitlines():
        fields=line.split('\t')
        if len(fields)>=3 and fields[0]=='time-stage' and fields[1] in ('preprocess','parse','check-input','total'):observe(fields[1]+' ms',fields[2])
    for line in path.with_suffix('.wall').read_text().splitlines():
        m=re.match(r'run \d+ list \d+: (\S+) ms wall.*?, (\d+) KiB wait4 peak, (\d+) minor faults, \d+ major, (\d+) user cycles, (\d+) instructions, status 0',line)
        if m:
            for key,val in zip(('wall ms','peak KiB','wall minor faults','wall user cycles','wall instructions'),m.groups()):observe(key,val)
    for suffix,name in [('.print.sha256','-E -P text'),('.sha256','ELF')]:hashes[corpus,name].add(path.with_suffix(suffix).read_text().strip())
for (corpus,metric),values in hashes.items():
    print(corpus,metric,'distinct',len(values),*values);assert len(values)==1
for a,b in [('before','off'),('off','record'),('record','restore'),('record','view'),('restore','view'),('off','view'),('before','view')]:
    print(a,b)
    for (corpus,metric),rounds in samples.items():
        v=[(median(t[a]),median(t[b])) for t in rounds.values() if a in t and b in t]
        if not v:continue
        diffs=[100*(y/x-1) for x,y in v if x]
        if not diffs:continue
        print(f'{corpus:7s} {metric:32s} {len(v)} {median(x for x,y in v):14,.3f} {median(y for x,y in v):14,.3f} {median(diffs):+7.3f}% [{min(diffs):+.3f}, {max(diffs):+.3f}]')
