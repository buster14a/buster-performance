#!/usr/bin/env python3
# census-totals.py: the totals the README's text has, over the four corpora, from the simulation's outputs and
# check-strides' beside this file.
import re, os
here = os.path.dirname(os.path.abspath(__file__))
C = ('sqlite3', 'lua', 'musl', 'own')
T = {c: open('%s/sim-%s.txt' % (here, c)).read() for c in C}
def row(c, name):
    m = re.search(r'^%s\s+(\d+)\s+([\d.]+)%%\s+(\d+)\s+(\d+)$' % re.escape(name), T[c], re.M)
    return (int(m.group(1)), int(m.group(3))) if m else (0, 0)
def total(name):
    return tuple(sum(row(c, name)[i] for c in C) for i in (0, 1))
entries = sum(int(re.search(r'entries (\d+) \(', T[c]).group(1)) for c in C)
print('entries', entries, 'wrong lines', sum(T[c].count('WRONG') for c in C))
print('stores by name', total("its destination's record's object")[0], 'whose own record has the object too', total('(a store by name whose own record has the object too)')[0])
steps = total("an update's step: one, of the class it is computed in")[0] + total("a pointer's update's step (1)")[0]
S = open(here + '/check-strides.txt').read() + open(here + '/check-strides-own.txt').read()
doubles = sum(int(x) for x in re.findall(r'^step own=\d+ kind=1 class=10 value=3ff0000000000000: (\d+)$', S, re.M))
print('steps', steps, 'of them a double\'s', doubles)
pointers = [tuple(int(x) for x in m) for m in re.findall(r'^pointer updates (\d+) whose two strides differ (\d+)$', S, re.M)]
print('pointer updates', sum(p[0] for p in pointers), 'differ', sum(p[1] for p in pointers))
own = total("a branch's label: an operator's own (its preorder number among the labeled)")
print('labels of an operator\'s own', own[0], 'zero', own[0] - own[1])
calls = total("a call's row (its preorder number among the expression's calls)")
print('calls\' rows', calls[0], 'zero', calls[0] - calls[1])
kept2 = sum(int(x) for c in C for x in re.findall(r'^\s+(\d+) \(\s*[\d.]+%\) calls \d labeled \d kept 2$', T[c], re.M))
print('expressions with two postfix updates through an address', kept2)
