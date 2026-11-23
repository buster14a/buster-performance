#!/usr/bin/env python3
# diff.py one.sym.tsv eight.sym.tsv ONE_COMPILES EIGHT_COMPILES: cycles a compile by symbol (M), one worker and eight.
import sys, collections
period = 100003
def load(path, compiles):
    d = collections.defaultdict(float)
    for line in open(path):
        n, ev, sym = (line.rstrip('\n').split('\t') + [''])[:3]
        d[(ev, sym)] += int(n) * period / compiles / 1e6
    return d
one = load(sys.argv[1], int(sys.argv[3])); eight = load(sys.argv[2], int(sys.argv[4]))
for ev in ('cycles:u', 'cycles:k'):
    keys = set(k for k in one if k[0] == ev) | set(k for k in eight if k[0] == ev)
    rows = sorted(((eight.get(k, 0) - one.get(k, 0), one.get(k, 0), eight.get(k, 0), k[1]) for k in keys), reverse=True)
    t1 = sum(r[1] for r in rows); t8 = sum(r[2] for r in rows)
    print(f"== {ev}: one {t1:.1f} M, eight {t8:.1f} M, excess {t8 - t1:.1f} M")
    acc = 0
    for d, a, b, s in rows[:int(sys.argv[5]) if len(sys.argv) > 5 else 45]:
        acc += d
        print(f"{d:8.2f} {a:8.2f} {b:8.2f} {b / a if a > 0 else 0:5.2f}x  cum {acc:7.1f}  {s[:70]}")
