#!/usr/bin/env python3
# proxies.py LABEL=DIR...: the threading counters (TEMPORARY instrumentation, never committed) summed per corpus from
# each DIR/{sqlite,lua,lvm}.txt ("name=value" lines a process appends at its exit), as a Markdown table of the keys
# named below.
import sys, os
keys = ['attempts', 'cfgs', 'cfg_blocks', 'cfg_instructions', 'scan1_instructions', 'analyses', 'analysis_blocks',
        'scan2', 'scan2_instructions', 'walks', 'walk_steps', 'changed_rounds', 'blocks', 'copies', 'merges',
        'rewrite_instructions', 'deferred_copy_phi']
cols = [a.split('=', 1) for a in sys.argv[1:]]
def load(d, corpus):
    out = {}
    p = os.path.join(d, corpus + '.txt')
    for line in open(p):
        if '=' in line:
            k, v = line.strip().split('=')
            out[k] = out.get(k, 0) + int(v)
    return out
for corpus in ['sqlite', 'lua']:
    data = [load(d, corpus) for _, d in cols]
    print(f'\n{corpus}\n')
    print('| | ' + ' | '.join(l for l, _ in cols) + ' |')
    print('| --- |' + ' ---: |' * len(cols))
    for k in keys:
        if all(k not in d for d in data):
            continue
        print(f'| {k} | ' + ' | '.join(f'{d[k]:,}' if k in d else '-' for d in data) + ' |')
