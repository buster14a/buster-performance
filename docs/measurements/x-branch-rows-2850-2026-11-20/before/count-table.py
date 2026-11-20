#!/usr/bin/env python3
# count-table.py COUNT [OWN]: the specification's table of the count before it (COUNT: the 9700X's three lines, in the
# corpora's order sqlite3.c, Lua, musl; OWN: the cloud container's line for the compiler's own source, with the
# expressions that keep a row over eight entries).
import re, sys
lines = open(sys.argv[1]).read().splitlines()
own = open(sys.argv[2]).read().splitlines() if len(sys.argv) > 2 else []
pattern = (r"listed first for branches=(\d+) with another record that lists them=(\d+) alone=(\d+); of those alone: records evaluated as branches=(\d+) of-them-roots=(\d+) tested values=(\d+)"
           r" with a conversion's part=(\d+) of a narrow class=(\d+) rows over eight with the test=(\d+) own entries 0\.\.4=(\d+),(\d+),(\d+),(\d+),(\d+)(?: expressions with such a row=(\d+))?")
rows = [re.search(pattern, l).groups() for l in lines + own]
assert len(lines) == 3 and len(own) <= 1
f = lambda s: '{:,}'.format(int(s))
names = ['**listed for X, first for a record evaluated as branches**', 'of them with another record that lists them', 'their records evaluated as branches; of them roots', 'the values those test',
         "with a conversion's part of their own", 'of a narrow class (the test has four entries, and three otherwise)', 'own entries: none; one; two; three; four',
         'a row over eight entries with the test; the expressions with one']
cells = [[f(r[0]) for r in rows], [f(r[1]) for r in rows], ['%s; %s' % (f(r[3]), f(r[4])) for r in rows], [f(r[5]) for r in rows], [f(r[6]) for r in rows], [f(r[7]) for r in rows],
         ['; '.join(f(x) for x in r[9:14]) for r in rows], ['%s; %s' % (f(r[8]), f(r[14]) if r[14] is not None else ('0' if r[8] == '0' else '?')) for r in rows]]
head = ['`sqlite3.c`', 'Lua', 'musl'] + (["the compiler's own source"] if own else [])
print('| | ' + ' | '.join(head) + ' |'); print('| --- |' + ' ---: |' * len(head))
for name, row in zip(names, cells):
    print('| %s | %s |' % (name, ' | '.join(row)))
