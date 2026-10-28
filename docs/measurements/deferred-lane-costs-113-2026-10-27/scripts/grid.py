#!/usr/bin/env python3
# Reads benchmark-checker-deferred logs (runs.sh's headings "== round R RUN UNIT lanes L") into rows, one per process:
# the unit's figures and, for the one-lane reading and the process's lanes, each reading's fields. Then summarizes by
# run, unit and lanes over the rounds: the change of the lanes' reading against the same process's one lane (lowest,
# median, highest), and the medians of the other fields.
import re, sys, statistics, collections

def fields(line):
    out = {}
    for m in re.finditer(r'(\w+)=([-\w./]+)', line):
        out[m.group(1)] = m.group(2)
    return out

def read(paths):
    rows = []
    for path in paths:
        head = None
        unit = None
        readings = []
        for line in open(path, errors='replace'):
            line = line.rstrip('\n')
            if line.startswith('== round '):
                parts = line.split()
                head = {'round': int(parts[2]), 'run': parts[3], 'unit': parts[4], 'lanes': int(parts[6]), 'log': path}
                unit = None
                readings = []
            elif line.startswith('checker-deferred: file=') and head is not None:
                unit = fields(line)
            elif line.startswith('checker-deferred:   lanes=') and head is not None and unit is not None:
                readings.append(fields(line))
                if len(readings) == 2:
                    rows.append(dict(head=head, unit=unit, one=readings[0], many=readings[1]))
    return rows

def num(d, k, default=None):
    v = d.get(k)
    if v is None:
        return default
    v = v.split('/')[0]
    try:
        return float(v)
    except ValueError:
        return default

def summarize(rows):
    groups = collections.OrderedDict()
    for r in rows:
        key = (r['head']['run'], r['head']['unit'], r['head']['lanes'])
        groups.setdefault(key, []).append(r)
    out = []
    for key, rs in groups.items():
        changes = [(num(r['many'], 'whole') / num(r['one'], 'whole') - 1) * 100 for r in rs]
        med = lambda f, which: statistics.median([num(r[which], f, 0.0) for r in rs])
        u = rs[0]['unit']
        out.append(dict(run=key[0], unit=key[1], lanes=key[2], rounds=len(rs), tokens=int(num(u, 'tokens')), bodies=int(num(u, 'bodies')),
                        body_tokens=int(num(u, 'body_tokens')), largest=int(num(u, 'largest_body')), second=int(num(u, 'second_body', -1)),
                        low=min(changes), median=statistics.median(changes), high=max(changes),
                        one=med('whole', 'one'), many=med('whole', 'many'), span1=med('lanes_span', 'one'), span=med('lanes_span', 'many'),
                        walks1=med('walks', 'one'), walks=med('walks', 'many'),
                        active=med('active', 'many'), copies=med('copies', 'many'), copy1=med('copy', 'one'), copy=med('copy', 'many'),
                        dispatch1=med('dispatch', 'one'), dispatch=med('dispatch', 'many'), wake=med('wake', 'many'),
                        arenas1=med('arenas', 'one'), arenas=med('arenas', 'many'),
                        first=sum(int(r['many'].get('largest_first', '0/0').split('/')[0]) for r in rs),
                        passes=sum(int(r['many'].get('largest_first', '0/0').split('/')[1]) for r in rs)))
    return out

if __name__ == '__main__':
    rows = read(sys.argv[1:])
    s = summarize(rows)
    cols = ['run', 'unit', 'lanes', 'rounds', 'tokens', 'bodies', 'body_tokens', 'largest', 'second', 'low', 'median', 'high', 'one', 'many', 'span',
            'active', 'copies', 'copy1', 'copy', 'dispatch', 'wake', 'arenas', 'first', 'passes']
    print('\t'.join(cols))
    for g in s:
        print('\t'.join(('%+.1f' % g[c]) if c in ('low', 'median', 'high') else ('%.2f' % g[c]) if isinstance(g[c], float) and c in ('one', 'many', 'span') else
                        str(int(g[c])) if isinstance(g[c], float) else str(g[c]) for c in cols))
