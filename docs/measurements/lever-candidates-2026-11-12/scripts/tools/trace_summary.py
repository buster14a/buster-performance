#!/usr/bin/env python3
# trace_summary.py TRACE.json: clang's -ftime-trace of one unit, summed: the "Total ..." rows (the front end's and
# each pass's whole time), and the functions that took the optimizer longest.
import collections
import json
import sys

events = json.load(open(sys.argv[1]))['traceEvents']
totals = {}
functions = collections.Counter()
sources = collections.Counter()
for event in events:
    name = event.get('name', '')
    duration = event.get('dur', 0)
    detail = event.get('args', {}).get('detail', '')
    if name.startswith('Total '):
        totals[name[6:]] = (duration, event.get('args', {}).get('count', 0))
    elif name in ('OptFunction', 'RunPass') and detail:
        functions[(name, detail)] += duration
    elif name == 'Source' and detail:
        sources[detail] += duration
print('total rows, seconds (count):')
for name, (duration, count) in sorted(totals.items(), key=lambda item: -item[1][0])[:34]:
    print(f'  {duration / 1e6:8.2f}  {name} ({count})')
print('functions by optimizer time, seconds:')
for (kind, detail), duration in functions.most_common(16):
    print(f'  {duration / 1e6:8.2f}  {kind} {detail[:90]}')
opt = [d for (kind, _), d in functions.items() if kind == 'OptFunction']
if opt:
    opt.sort(reverse=True)
    print(f'OptFunction: {len(opt)} functions over the trace\'s granularity, {sum(opt) / 1e6:.1f} s; the top 10 hold {sum(opt[:10]) / 1e6:.1f} s, the top 100 {sum(opt[:100]) / 1e6:.1f} s')
