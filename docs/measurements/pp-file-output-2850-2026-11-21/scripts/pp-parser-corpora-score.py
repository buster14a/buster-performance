"""Pair within-round medians; label widths and copies separately."""
import re, sys
from collections import defaultdict
from pathlib import Path
from statistics import median

root = Path(sys.argv[1])
short = {'tree-driver': [('0','4096')], 'sparse-corpora':[('before','requests')], 'bracket-corpora':[('before','bracket')], 'returnguard-time':[('before','off'),('off','stream'),('off','replay'),('replay','stream')], 'return-time':[('before','off'),('off','stream'),('off','replay'),('replay','stream')], 'identity-time': [('before','off'),('off','on'),('before','on')]}
short['decode-time'] = [('before','off'),('off','writer'),('writer','physical'),('writer','decode'),('off','decode'),('before','decode')]
short['digit-time'] = [('before','off'),('off','writer'),('writer','read'),('off','read'),('before','read')]
short['digit-compact-time'] = [('before','off'),('off','writer'),('writer','read'),('off','compact-only'),('read','compact'),('compact-only','compact'),('off','compact'),('before','compact')]
short['digits8-time'] = [('before','off'),('off','on'),('before','on')]
for name, pairs in short.items():
    d = root/name
    if not (d/'status').exists(): continue
    data=defaultdict(lambda:defaultdict(lambda:defaultdict(list)))
    hashes=defaultdict(set)
    for mark in (d/'status').read_text().splitlines():
        r,c,pos,label=mark.split()
        p=d/f'{r}-{c}-{pos}-{label}'
        def add(metric,val):
            data[c,metric][r][label].append(float(val))
        for line in p.with_suffix('.stages').read_text().splitlines():
            parts=line.split('\t')
            if len(parts)>=3 and parts[0]=='time-stage' and parts[1] in ('preprocess','parse','check-input','total'):
                add(parts[1]+' ms',parts[2])
            m=re.search(r'tree-clock count=(\d+) width=(\d+) windows=(\d+) largest=(\d+) sizes=(\d+) ticks=(\d+)',line)
            if m: add('charged tree TSC ticks/token',int(m[6])/int(m[1]));add('charged tree ticks',m[6])
        for line in p.with_suffix('.wall').read_text().splitlines():
            m=re.match(r'run \d+ list \d+: (\S+) ms wall.*?, (\d+) KiB wait4 peak, (\d+) minor faults, \d+ major, (\d+) user cycles, (\d+) instructions, status 0',line)
            if m:
                for metric,val in zip(('wall ms','peak KiB','minor faults','wall cycles','wall instructions'),m.groups()):add(metric,val)
        if p.with_suffix('.front').exists():
            line = next(x for x in p.with_suffix('.front').read_text().splitlines() if x.startswith('front '))
            _,tokens,rows,returns,setup,run,release=map(str,line.split())
            for metric,val in [('raw PP ns',run),('PP setup ns',setup),('PP release ns',release),('raw PP ns/t',float(run)/int(tokens))]: add(metric,val)
        if p.with_suffix('.perf').exists():
            counters = {}
            for line in p.with_suffix('.perf').read_text().splitlines():
                fields = line.split(';')
                if len(fields) > 2 and fields[0].isdigit():
                    counters[fields[2]] = int(fields[0])
            if 'cycles:u' in counters and 'cycles:k' in counters:
                counters['cycles:u+k'] = counters['cycles:u'] + counters['cycles:k']
            for event, value in counters.items():
                if p.with_suffix('.front').exists():
                    add('raw ' + event + '/t', value / int(tokens))
                else:
                    add('process ' + event, value)
        if p.with_suffix('.kernels').exists():
            for line in p.with_suffix('.kernels').read_text().splitlines():
                m=re.match(r'^\s+(\S+)\s+(\S+) ms\s+\S+ ns/token\s+(\S+) cycles/token \[[^]]+\]\s+(\S+) instructions/token',line)
                if m and m[1] in ('input','convert','keywords','input-keywords','combined','vector','vector-fallback','vector-k6','tree','tree-sizes','handoff','conversion'):
                    add(m[1]+' cycles/t',m[3]);add(m[1]+' ins/t',m[4])
        hashes[c].add(p.with_suffix('.sha256').read_text().strip())
    for c,h in hashes.items(): print(name,c,'ELF',len(h),*sorted(h))
    for a,b in pairs:
        print(name,a,b)
        for (c,metric),rounds in data.items():
            vals=[(median(arms[a]),median(arms[b])) for arms in rounds.values() if a in arms and b in arms]
            changes=[100*(v/u-1) for u,v in vals if u]
            if not changes:continue
            print(f'{c:7s} {metric:30s} {len(vals):2d} {median(u for u,v in vals):15,.3f} {median(v for u,v in vals):15,.3f}  {median(changes):+7.3f}% [{min(changes):+.3f},{max(changes):+.3f}]')
