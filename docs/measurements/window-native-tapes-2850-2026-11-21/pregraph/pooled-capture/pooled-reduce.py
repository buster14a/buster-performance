"""Reduce paired source-window stage TSC samples; each observation is one whole-program pass."""
import csv, re, statistics, sys
from collections import Counter
from pathlib import Path
p = Path(sys.argv[1])
control, variant = sys.argv[2:4]
w = csv.writer(sys.stdout, delimiter='\t', lineterminator='\n')
w.writerow(['corpus','stage','denominator','units','off median','on median','paired median','paired minimum','paired maximum','rounds lower'])
for corpus in ('sqlite','lua','musl','main'):
    paired = {}
    receipts = set()
    controls = set()
    for rd in range(1,8):
        runs = {control:[], variant:[]}
        for f in sorted(p.glob(f'{corpus}-{rd}-*.timings')):
            mode = f.stem.split('-')[-1]
            if mode not in runs: continue
            times = Counter()
            for line in f.open():
                group, rest = line.rstrip().split(' ',1)
                vals = {k:int(v) for k,v in re.findall(r'([\w-]+)=(\d+)',rest)}
                for k,v in vals.items(): times[group,k] += v
            assert times['source-T','count'] == times['source-cost','count']
            receipt=f.with_suffix('.receipt').read_text()
            assert 'probe-native' in receipt and 'differences=0' in receipt
            assert not re.search(r'differences=[1-9]',receipt)
            receipts.add(receipt)
            controls.add(tuple((k,v) for k,v in sorted(times.items()) if k[0]=='source-rows' or k[1]=='count'))
            t={k[1]:v for k,v in times.items() if k[1]!='count' and k[0] in ['source-T','source-cost']}
            t['total']=sum(t.values())
            t['tests through retain']=t['inputs']+t['selection']+t['prepare']+t['rows']+t['retain']
            t['inputs + selection + prepare']=t['inputs']+t['selection']+t['prepare']
            values = {(k,'swept record'):v/times['source-T','count'] for k,v in t.items()}
            if corpus=='sqlite':
                for k,v in t.items(): values[k,'preprocessed token']=v/716136
            runs[mode].append(values)
        assert len(runs[variant])==len(runs[control])==2
        paired[rd]={m:{k:statistics.mean(v[k] for v in a) for k in a[0]} for m,a in runs.items()}
    assert len(receipts)==1, (corpus, len(receipts))
    assert len(controls)==1, (corpus,controls)
    for k in paired[1][control]:
        before,after=([r[m][k] for r in paired.values()] for m in (control,variant))
        d=[b-a for a,b in zip(before,after)]
        w.writerow([corpus,*k,'TSC ticks',*[f'{v:.4f}' for v in (statistics.median(before),statistics.median(after),statistics.median(d),min(d),max(d))],sum(v<0 for v in d)])
