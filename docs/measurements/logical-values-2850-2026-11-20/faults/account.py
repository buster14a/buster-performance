#!/usr/bin/env python3
# account.py ROUND1_JOINED ROUND2_JOINED: the two rounds' counts, and what became of the first round's survivors, each
# by its name: a term taken out of the code, one of the first sink rule's (replaced by a rule of six terms), one that
# got a fixture's line or a pin and is caught in the second round, or one that changes nothing a program reaches.
import json, re, sys
def load(path):
    v = {}
    for line in open(path):
        m = re.match(r'(caught|SURVIVED|NONE|not-built|KILLED)\s+(\d+) (\S+)', line)
        if m: v[m.group(3)] = m.group(1)
    return v
one, two = load(sys.argv[1]), load(sys.argv[2])
survivors = [n for n, x in one.items() if x == 'SURVIVED']
taken_out = ['deep-not-any-seed', 'propagate-the-last-too', 'unreached-the-generated-too', 'conditional-for-its-address', 'valued-for-its-address', 'valued-any-class', 'comma-for-its-address',
             'discarded-not-made', 'count-commas-unplaced', 'sink-void-none', 'twice-any-operator', 'reads-an-addressed-does-not', 'held-arm-bit-alone', 'number-tested-an-arm-too', 'voided-the-class']
nothing = ['table-conditional-arm-given', 'key-conditional-its-template', 'key-conditional-every-value']
sink = [n for n in survivors if n.startswith('sinks-')]
rest = [n for n in survivors if n not in taken_out and n not in nothing and n not in sink]
assert all(n in survivors for n in taken_out + nothing), [n for n in taken_out + nothing if n not in survivors]
lined = [n for n in rest if two.get(n) == 'caught']
open_ = [n for n in rest if two.get(n) != 'caught']
ran = {n: x for n, x in two.items() if x != 'NONE'}
out = dict(round1=len(one), round1_caught=sum(x == 'caught' for x in one.values()), round1_survived=len(survivors), taken_out=len(taken_out), sink=len(sink), lined=len(lined), nothing=len(nothing),
           unaccounted=open_, round2=len(ran), round2_caught=sum(x == 'caught' for x in ran.values()), round2_survived=sorted(n for n, x in ran.items() if x == 'SURVIVED'), lined_names=lined)
json.dump(out, sys.stdout, indent=1)
