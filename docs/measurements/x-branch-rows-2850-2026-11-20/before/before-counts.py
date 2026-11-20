#!/usr/bin/env python3
# before-counts.py FETCH: the specification's first table for the branches' rows, from the piece before's final runs
# on the 9700X (FETCH/rows-on1-CORPUS-1.txt: the shadow with --window-rows, the update's rows on).
import re, sys
fetch = sys.argv[1]
rows = [[], [], [], [], [], []]
for corpus in ('sqlite3', 'lua', 'musl'):
    text = open('%s/rows-on1-%s-1.txt' % (fetch, corpus), errors='replace').read()
    x = re.search(r'window rows expressions=(\d+) records=\d+ taken=(\d+) \(([\d.]+)%\)', text)
    l = re.search(r"window rows listed, by an expression's first record's reason: update=(\d+) branches=(\d+) refused-conversion=(\d+) constant-to-a-floating-class=(\d+)", text)
    b = re.search(r'window contexts branched=(\d+) \(([\d.]+)% of the records swept\) of-them-a-condition=(\d+)', text)
    f = lambda s: '{:,}'.format(int(s))
    rows[0].append(f(x.group(1))); rows[1].append('%s (%s%%)' % (f(x.group(2)), x.group(3)))
    rows[2].append(f(l.group(2))); rows[3].append('%s (%s%% of the records swept)' % (f(b.group(1)), b.group(2))); rows[4].append(f(b.group(3)))
    rows[5].append('%s; %s; %s' % (f(l.group(1)), f(l.group(3)), f(l.group(4))))
names = ('expressions C takes on the window', 'their tapes made today', '**listed for X, first for an operator evaluated as branches**', "the records C's loop evaluates as branches", "of them a statement's CONDITION",
         'listed first for an update; a refused conversion; a constant to a floating class')
print('| | `sqlite3.c` | Lua | musl |'); print('| --- | ---: | ---: | ---: |')
for name, row in zip(names, rows):
    print('| %s | %s |' % (name, ' | '.join(row)))
