"""Summarize T replacement and the native stream comparisons in a raw log directory."""
import csv
from pathlib import Path
from collections import Counter
import re
import sys

root = Path(sys.argv[1])
writer = csv.writer(sys.stdout, delimiter='\t', lineterminator='\n')
writer.writerow(['case', 'T records substituted', 'complete T roots with X rows', 'X entries', 'X differences',
                 'context differences across window', 'row differences across window', 'native roots',
                 'native entries', 'native differences', 'global symbol entries', 'calls', 'call arguments',
                 'variadic calls', 'native call roots', 'labels'])
def fields(line):
    return {k: int(v) for k, v in re.findall(r'([\w-]+)=(\d+)', line)}
for case in ('sqlite', 'lua', 'musl', 'main', 'partial', 'mutant', 'symbol', 'argument', 'variadic'):
    stats = Counter()
    with (root/(case+'.err')).open() as report:
        for line in report:
            if line.startswith(('probe-bridge replaced=', 'probe-through roots=')):
                stats.update(fields(line))
    lines = (root/(case+'.out')).read_text().splitlines()
    def get(prefix):
        matched = [line for line in lines if line.startswith(prefix)]
        assert len(matched) == 1
        return fields(matched[0])
    c, x, n = map(get, ['node-shadow: window contexts expressions=', 'node-shadow: window rows expressions=', 'probe-native roots='])
    writer.writerow([case, *[stats[k] for k in ('replaced', 'roots', 'entries', 'differences')], c['differences'], x['differences'],
                     *[n[k] for k in ('roots', 'entries', 'differences', 'globals', 'calls', 'arguments', 'variadic', 'call-roots', 'labels')]])
