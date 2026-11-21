#!/usr/bin/env python3
# tally.py ROUND.txt...: the fault round's verdicts joined by name over the machines that ran it: a line a fault that is
# not caught, and the counts; a fault two machines ran must have one verdict.
import sys, collections
verdicts = {}
names = {}
for path in sys.argv[1:]:
    for line in open(path):
        w = line.split()
        if len(w) < 3 or not w[1].isdigit():
            continue
        verdict, index, name = w[0], int(w[1]), w[2]
        names[index] = name
        verdicts.setdefault(index, set()).add(verdict)
both = [i for i, v in verdicts.items() if len(v) > 1]
for i in sorted(both):
    print('TWO VERDICTS', i, names[i], sorted(verdicts[i]))
count = collections.Counter()
for i in sorted(verdicts):
    v = sorted(verdicts[i])[0] if len(verdicts[i]) == 1 else 'two'
    count[v] += 1
    if v != 'caught':
        print(v, i, names[i])
print(len(verdicts), 'faults:', dict(count), 'ran on two machines:', sum(1 for i in verdicts if False))
