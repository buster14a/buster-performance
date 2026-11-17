#!/usr/bin/env python3
# tables.py RESULTS: every A/B of the record as one table a kind, from abstat's files (RESULTS/abstat*-LABEL.txt): the
# paired difference of B from A in percent of A with its quartiles, and the rounds in which B read less than A.
import glob, os, re, sys
results = sys.argv[1]
jobs = [('abstat-', 'job-ask.sh (main d1cf1fe82: base against ask)'), ('abstat3-', 'job-ask3.sh (base against ask3; same: base against a second copy of itself)'),
        ('abstatf-', 'job-final.sh (main 2d8174328: base2 against final)'), ('abstats-', 'job-slots.sh (base2 against slots; final against slots)'),
        ('abstatv-', 'job-variants.sh (base2 against scratch, off, none, orderonly)'), ('abstatl-', 'job-last.sh (base2 against scratch)'),
        ('abstatc-', 'job-command.sh (the units as one command, 9 rounds)'),
        ('abstatw-', "job-vec.sh (base2 against vec, the counting without a loop, a key's length in its last byte; vecoff: its asks never made)"),
        ('abstatx-', "job-fin.sh (base2 against fin, the pull request's code and list; finoff: its asks never made)"),
        ('abstath-', "job-head.sh (base2 against head, the pull request's tree)"),
        ('abstatk-', 'job-knob.sh (one copy of one executable, its asks off against them at the third, fourth and fifth miss, and off again) and job-knob2.sh (base2 and fin against the knob build, asks at 3 or off on both sides)')]
events = ['cycles:k', 'cycles:u', 'instructions:u', 'page-faults', 'iTLB-load-misses']
for prefix, title in jobs:
    files = sorted(f for f in glob.glob(os.path.join(results, prefix + '*.txt')) if re.match(re.escape(prefix) + r'[a-z]', os.path.basename(f)))
    if not files:
        continue
    print('## ' + title)
    print()
    print('| A/B | rounds | ' + ' | '.join(events) + ' |')
    print('| --- | ---: | ' + ' | '.join('---:' for _ in events) + ' |')
    for f in files:
        label = os.path.basename(f)[len(prefix):-4]
        rows = {}
        rounds = '?'
        for line in open(f):
            m = re.match(r'\S+: (\d+) rounds', line)
            if m:
                rounds = m.group(1)
            m = re.match(r'(\S+)\s+.*?([+-][\d.]+)% \[([+-][\d.]+), ([+-][\d.]+)\]\s+(\d+)/(\d+)\s*$', line)
            if m:
                rows[m.group(1)] = f'{m.group(2)}% [{m.group(3)}, {m.group(4)}] {m.group(5)}/{m.group(6)}'
        print(f'| {label} | {rounds} | ' + ' | '.join(rows.get(e, '?') for e in events) + ' |')
    print()
