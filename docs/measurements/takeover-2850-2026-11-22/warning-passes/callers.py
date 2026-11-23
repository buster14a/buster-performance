#!/usr/bin/env python3
# callers.py SYM BR PATTERN...: for the samples whose function's name holds PATTERN, the function that called it, read
# from the sample's branch records (newest first): the first record that enters the function from outside it.
import sys, collections
syms = [l.split() for l in open(sys.argv[1])]
brs = [l.split() for l in open(sys.argv[2])]
assert len(syms) == len(brs), (len(syms), len(brs))
own = collections.Counter()
for s in syms:
    own[s[1].split('+')[0] if len(s) > 1 else '?'] += 1
total = len(syms)
print('samples', total)
for pattern in sys.argv[3:]:
    callers = collections.Counter(); hits = 0
    for s, b in zip(syms, brs):
        name = s[1] if len(s) > 1 else '?'
        if pattern not in name: continue
        hits += 1
        caller = '(not in 16 records)'
        for entry in b:
            fields = entry.split('/')
            if len(fields) < 2: continue
            source = fields[0].split('+')[0]; target = fields[1].split('+')[0]
            if pattern in target and pattern not in source and 'memset' not in source:
                caller = source; break
        callers[caller] += 1
    print(f'--- {pattern}: {hits} samples, {100*hits/total:.2f}%')
    for name, count in callers.most_common(30):
        print(f'{100*count/total:6.2f}%  {count:5d}  {name}')
