#!/usr/bin/env python3
# silence-bodies.py REPORT: from the experiment's `experiment-silence` lines (opening, tokens, the alone machine's
# verdict, result void, main, the body's last statement at its own level a return with a value, every popped root taken
# at reader time, a switch in the body, a goto in the body), the lowered bodies the machine takes whole by what the
# most conservative proof of the return flow's silence leaves of them.
import sys
rows = []
for line in open(sys.argv[1]):
    f = line.split()
    if f and f[0] == 'experiment-silence:':
        rows.append(tuple(int(x) for x in f[1:]))
total = sum(r[1] for r in rows)
def show(name, test):
    sel = [r for r in rows if test(r)]
    print(f"{name}: bodies {len(sel)}, tokens {sum(r[1] for r in sel)} ({100.0 * sum(r[1] for r in sel) / total:.2f}%)")
whole = lambda r: r[2] == 0
quiet = lambda r: r[3] == 1 or r[4] == 1 or r[5] == 1
show("lowered bodies", lambda r: True)
show("whole before the walk (the machine with no node of the walk's)", whole)
show("... whose result is void", lambda r: whole(r) and r[3] == 1)
show("... void, or main, or the last statement at the body's level is a return with a value", lambda r: whole(r) and quiet(r))
show("... none of the three: the return flow's proof is owed", lambda r: whole(r) and not quiet(r))
show("whole, with no switch", lambda r: whole(r) and r[7] == 0)
show("whole, the test holds, no switch and no goto", lambda r: whole(r) and quiet(r) and r[7] == 0 and r[8] == 0)
show("of every lowered body: the test holds", quiet)
