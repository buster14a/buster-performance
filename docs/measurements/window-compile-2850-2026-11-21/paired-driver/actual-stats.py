"""Generate per-mode medians and properly paired ranges from the verified raw rows."""
import csv
from collections import defaultdict
from pathlib import Path
from statistics import mean,median
import sys
root=Path(sys.argv[1]); base=sys.argv[2]
series=defaultdict(lambda:defaultdict(list)); digests=set()
for name in ('pmu.tsv','wall.tsv'):
 for r in csv.DictReader((root/name).open(),delimiter='\t'):
    k=(r['mode'],int(r['round']))
    digests.add(r['object-sha256'])
    if name.startswith('pmu'):
      series['cycles/token'][k].append((int(r['user-cycles'])+int(r['kernel-cycles']))/716136)
      series['user instructions'][k].append(int(r['user-instructions']))
      series['task ms'][k].append(float(r['task-ms']))
    else:series['wall ms'][k].append(float(r['milliseconds']))
assert len(digests)==1
print('sha256',next(iter(digests)))
for metric,groups in series.items():
 assert len(groups)==21 and all(len(v)==2 for v in groups.values())
 values={m:[mean(groups[m,n]) for n in range(1,8)] for m in (base,'off','on')}
 print(metric, ' | '.join(f'{m} {median(v):.5f}' for m,v in values.items()))
 if metric=='wall ms':
    print('decimal MB/s',' | '.join(f'{m} {9507.037/median(v):.5f}' for m,v in values.items()))
 for c in (base,'off'):
    delta=[a-b for a,b in zip(values['on'],values[c])]
    print('    on minus',c,'median',round(median(delta),5),'range',*(round(f(delta),5) for f in (min,max)))
